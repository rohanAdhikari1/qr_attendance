import 'package:qr_attendance/data/enums.dart';

class ScannedStudent {
  final String studentId;
  final String? name;
  final String? className;
  final DateTime timestamp;
  final SyncStatus syncStatus;
  final bool fromCache;

  const ScannedStudent({
    required this.studentId,
    this.name,
    this.className,
    required this.timestamp,
    required this.syncStatus,
    this.fromCache = false,
  });
}