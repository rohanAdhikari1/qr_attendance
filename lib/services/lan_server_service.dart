import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart' as get_x;
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

import '../models/attendance_model.dart';
import '../services/local_storage_service.dart';

/// Embedded HTTP server that runs on the device.
/// Admins/Principals open their browser to http://DEVICE_IP:8080
/// to see a live attendance dashboard — no app install needed.
class LanServerService extends get_x.GetxService {
  final LocalStorageService _storage;
  LanServerService(this._storage);

  static const _port = 8080;

  HttpServer? _server;
  final _sseClients = <StreamController<String>>[];
  final _networkInfo = NetworkInfo();

  final isRunning = false.obs;
  final lanIp = ''.obs;
  final connectedClients = 0.obs;

  // ─── Start / Stop ──────────────────────────────────────────────────────────

  Future<void> start() async {
    if (_server != null) return;
    try {
      final ip = await _networkInfo.getWifiIP() ?? '0.0.0.0';
      lanIp.value = ip;

      final router = Router()
        ..get('/', _handleDashboard)
        ..get('/events', _handleSse)
        ..get('/api/attendance/today', _handleTodayJson)
        ..get('/api/stats', _handleStats);

      final handler = const Pipeline()
          .addMiddleware(_corsMiddleware())
          .addMiddleware(logRequests())
          .addHandler(router.call);

      _server = await io.serve(handler, InternetAddress.anyIPv4, _port);
      isRunning.value = true;
      print('[LAN] Live server at http://$ip:$_port');
    } catch (e) {
      print('[LAN] Failed to start: $e');
    }
  }

  Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
    for (final c in _sseClients) {
      await c.close();
    }
    _sseClients.clear();
    isRunning.value = false;
    connectedClients.value = 0;
  }

  String get dashboardUrl =>
      lanIp.value.isNotEmpty ? 'http://${lanIp.value}:$_port' : '';

  // ─── Push new scan event to all SSE clients ────────────────────────────────

  void pushScanEvent(AttendanceModel record) {
    if (_sseClients.isEmpty) return;
    final json = jsonEncode({
      'type': 'scan',
      'studentId': record.studentId,
      'name': record.studentName,
      'class': record.className,
      'time': record.timestamp.toIso8601String(),
      'synced': record.syncStatus == SyncStatus.synced,
    });
    final data = 'data: $json\n\n';
    final dead = <StreamController<String>>[];
    for (final client in _sseClients) {
      if (client.isClosed) {
        dead.add(client);
      } else {
        client.add(data);
      }
    }
    _sseClients.removeWhere(dead.contains);
    connectedClients.value = _sseClients.length;
  }

  void pushStatsUpdate() {
    if (_sseClients.isEmpty) return;
    final stats = jsonEncode({
      'type': 'stats',
      'total': _storage.totalTodayCount,
      'synced': _storage.syncedTodayCount,
      'pending': _storage.pendingCount,
    });
    final data = 'data: $stats\n\n';
    for (final c in _sseClients) {
      if (!c.isClosed) c.add(data);
    }
  }

  // ─── Handlers ─────────────────────────────────────────────────────────────

  Response _handleDashboard(Request req) {
    final school = _storage.schoolName;
    return Response.ok(
      _buildDashboardHtml(school),
      headers: {'Content-Type': 'text/html; charset=utf-8'},
    );
  }

  Response _handleSse(Request req) {
    final ctrl = StreamController<String>();
    _sseClients.add(ctrl);
    connectedClients.value = _sseClients.length;

    // Send initial connection event + current stats
    final stats = jsonEncode({
      'type': 'connected',
      'total': _storage.totalTodayCount,
      'synced': _storage.syncedTodayCount,
      'pending': _storage.pendingCount,
      'school': _storage.schoolName,
    });
    ctrl.add('data: $stats\n\n');

    // Send today's scans as initial batch
    final today = _storage.getTodayAttendance();
    final batch = jsonEncode({
      'type': 'initial',
      'records': today
          .map((r) => {
                'studentId': r.studentId,
                'name': r.studentName,
                'class': r.className,
                'time': r.timestamp.toIso8601String(),
                'synced': r.syncStatus == SyncStatus.synced,
              })
          .toList(),
    });
    ctrl.add('data: $batch\n\n');

    // Clean up when client disconnects
    ctrl.onCancel = () {
      _sseClients.remove(ctrl);
      connectedClients.value = _sseClients.length;
    };

    return Response.ok(
      ctrl.stream,
      headers: {
        'Content-Type': 'text/event-stream',
        'Cache-Control': 'no-cache',
        'X-Accel-Buffering': 'no',
        'Connection': 'keep-alive',
      },
    );
  }

  Response _handleTodayJson(Request req) {
    final records = _storage.getTodayAttendance();
    final json = jsonEncode({
      'date': DateTime.now().toIso8601String().substring(0, 10),
      'total': records.length,
      'records': records
          .map((r) => {
                'id': r.id,
                'student_id': r.studentId,
                'name': r.studentName,
                'class': r.className,
                'time': r.timestamp.toIso8601String(),
                'sync_status': r.syncStatus.name,
              })
          .toList(),
    });
    return Response.ok(json,
        headers: {'Content-Type': 'application/json'});
  }

  Response _handleStats(Request req) {
    final json = jsonEncode({
      'school': _storage.schoolName,
      'total_today': _storage.totalTodayCount,
      'synced_today': _storage.syncedTodayCount,
      'pending': _storage.pendingCount,
      'timestamp': DateTime.now().toIso8601String(),
    });
    return Response.ok(json,
        headers: {'Content-Type': 'application/json'});
  }

  // ─── CORS middleware ──────────────────────────────────────────────────────

  Middleware _corsMiddleware() => (Handler handler) {
        return (Request request) async {
          if (request.method == 'OPTIONS') {
            return Response.ok('', headers: _corsHeaders);
          }
          final response = await handler(request);
          return response.change(headers: _corsHeaders);
        };
      };

  static const _corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
  };

  // ─── Dashboard HTML ───────────────────────────────────────────────────────

  String _buildDashboardHtml(String schoolName) => '''
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>$schoolName – Live Attendance</title>
<style>
  :root {
    --bg: #0f1322; --surface: #1a1f2e; --card: #1e2438;
    --border: #2a3250; --primary: #1565c0; --accent: #00bcd4;
    --success: #4caf50; --warn: #ffa726; --error: #e53935;
    --text: #ffffff; --muted: #b0bad0;
  }
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body { background: var(--bg); color: var(--text); font-family: 'Segoe UI', system-ui, sans-serif; min-height: 100vh; }
  header { background: var(--surface); border-bottom: 1px solid var(--border); padding: 16px 24px; display: flex; align-items: center; gap: 16px; position: sticky; top: 0; z-index: 10; }
  .logo { width: 40px; height: 40px; background: linear-gradient(135deg, var(--primary), var(--accent)); border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 20px; flex-shrink: 0; }
  .header-info h1 { font-size: 18px; font-weight: 700; }
  .header-info p { font-size: 12px; color: var(--muted); }
  .status-dot { width: 8px; height: 8px; border-radius: 50%; background: var(--error); margin-left: auto; }
  .status-dot.live { background: var(--success); animation: pulse 1.5s infinite; }
  @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:.4} }
  .status-label { font-size: 12px; color: var(--muted); margin-left: 6px; }
  main { padding: 20px; max-width: 900px; margin: 0 auto; }
  .stats { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; margin-bottom: 20px; }
  .stat-card { background: var(--card); border-radius: 14px; padding: 18px; border: 1px solid var(--border); }
  .stat-value { font-size: 36px; font-weight: 700; }
  .stat-label { font-size: 12px; color: var(--muted); margin-top: 4px; }
  .stat-card.total .stat-value { color: var(--accent); }
  .stat-card.synced .stat-value { color: var(--success); }
  .stat-card.pending .stat-value { color: var(--warn); }
  .section-title { font-size: 15px; font-weight: 600; margin-bottom: 12px; display: flex; align-items: center; gap: 8px; }
  .badge { background: var(--accent); color: #000; font-size: 11px; font-weight: 700; padding: 2px 8px; border-radius: 20px; }
  table { width: 100%; border-collapse: collapse; background: var(--card); border-radius: 14px; overflow: hidden; }
  th { background: var(--surface); padding: 10px 14px; text-align: left; font-size: 12px; font-weight: 600; color: var(--muted); text-transform: uppercase; letter-spacing: .5px; border-bottom: 1px solid var(--border); }
  td { padding: 12px 14px; font-size: 13px; border-bottom: 1px solid var(--border); }
  tr:last-child td { border-bottom: none; }
  tr.new-row { animation: slideIn .4s ease; }
  @keyframes slideIn { from { opacity:0; transform: translateY(-10px); background: rgba(0,188,212,.1); } to { opacity:1; transform: translateY(0); } }
  .id-badge { background: rgba(21,101,192,.3); color: var(--accent); font-weight: 700; padding: 3px 8px; border-radius: 6px; font-size: 12px; }
  .sync-badge { padding: 2px 8px; border-radius: 12px; font-size: 11px; font-weight: 600; }
  .sync-badge.synced { background: rgba(76,175,80,.2); color: var(--success); }
  .sync-badge.pending { background: rgba(255,167,38,.2); color: var(--warn); }
  .time { color: var(--muted); font-size: 12px; }
  .empty { text-align: center; padding: 40px; color: var(--muted); }
  footer { text-align: center; padding: 20px; font-size: 11px; color: var(--muted); }
  @media(max-width:600px){ .stats{grid-template-columns:1fr 1fr} th:nth-child(4),td:nth-child(4){display:none} }
</style>
</head>
<body>
<header>
  <div class="logo">🏫</div>
  <div class="header-info">
    <h1 id="school-name">$schoolName</h1>
    <p id="date-label">Loading…</p>
  </div>
  <div id="status-dot" class="status-dot"></div>
  <span id="status-label" class="status-label">Connecting…</span>
</header>
<main>
  <div class="stats">
    <div class="stat-card total"><div class="stat-value" id="stat-total">–</div><div class="stat-label">Total Today</div></div>
    <div class="stat-card synced"><div class="stat-value" id="stat-synced">–</div><div class="stat-label">Synced to Server</div></div>
    <div class="stat-card pending"><div class="stat-value" id="stat-pending">–</div><div class="stat-label">Pending Sync</div></div>
  </div>
  <div class="section-title">Live Scans <span class="badge" id="count-badge">0</span></div>
  <table>
    <thead><tr><th>#</th><th>Student ID</th><th>Name</th><th>Class</th><th>Time</th><th>Status</th></tr></thead>
    <tbody id="tbody"><tr><td colspan="6" class="empty">Waiting for scans…</td></tr></tbody>
  </table>
</main>
<footer>Live Attendance Dashboard · $schoolName · Auto-updates in real time</footer>

<script>
  const tbody = document.getElementById('tbody');
  const dot = document.getElementById('status-dot');
  const statusLabel = document.getElementById('status-label');
  let records = [];
  let counter = 1;

  // Date label
  document.getElementById('date-label').textContent =
    new Date().toLocaleDateString('en-US',{weekday:'long',year:'numeric',month:'long',day:'numeric'});

  function updateStats(total, synced, pending) {
    document.getElementById('stat-total').textContent = total ?? '–';
    document.getElementById('stat-synced').textContent = synced ?? '–';
    document.getElementById('stat-pending').textContent = pending ?? '–';
  }

  function formatTime(iso) {
    return new Date(iso).toLocaleTimeString('en-US',{hour:'2-digit',minute:'2-digit',second:'2-digit'});
  }

  function renderTable(isNew = false) {
    if (records.length === 0) {
      tbody.innerHTML = '<tr><td colspan="6" class="empty">Waiting for scans…</td></tr>';
      document.getElementById('count-badge').textContent = '0';
      return;
    }
    document.getElementById('count-badge').textContent = records.length;
    tbody.innerHTML = records.map((r, i) => `
      <tr class="\${i === 0 && isNew ? 'new-row' : ''}">
        <td style="color:var(--muted)">\${records.length - i}</td>
        <td><span class="id-badge">\${r.studentId}</span></td>
        <td>\${r.name || '—'}</td>
        <td style="color:var(--accent)">\${r.class || '—'}</td>
        <td class="time">\${formatTime(r.time)}</td>
        <td><span class="sync-badge \${r.synced ? 'synced' : 'pending'}">\${r.synced ? 'Synced' : 'Pending'}</span></td>
      </tr>`).join('');
  }

  function connect() {
    const es = new EventSource('/events');

    es.onopen = () => {
      dot.className = 'status-dot live';
      statusLabel.textContent = 'Live';
    };

    es.onmessage = (e) => {
      const msg = JSON.parse(e.data);

      if (msg.type === 'connected') {
        updateStats(msg.total, msg.synced, msg.pending);
        dot.className = 'status-dot live';
        statusLabel.textContent = 'Live';
      }

      if (msg.type === 'initial') {
        records = [...msg.records].reverse();
        renderTable(false);
      }

      if (msg.type === 'scan') {
        records.unshift(msg);
        renderTable(true);
      }

      if (msg.type === 'stats') {
        updateStats(msg.total, msg.synced, msg.pending);
      }
    };

    es.onerror = () => {
      dot.className = 'status-dot';
      statusLabel.textContent = 'Reconnecting…';
      es.close();
      setTimeout(connect, 3000);
    };
  }

  connect();
</script>
</body>
</html>
''';

  @override
  void onClose() {
    stop();
    super.onClose();
  }
}
