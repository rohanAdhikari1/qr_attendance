import 'dart:convert';

/// Parses raw QR string data and extracts a student ID.
///
/// Supports formats:
///   StudentId: 1234
///   student_id: 1234
///   studentId: 1234
///   StudentID=1234
///   ID-1234
///   {"studentId":"1234","name":"Ram"}
///   Plain alphanumeric: 1234 or STU1234
class QrParser {
  // All known key patterns (case-insensitive)
  static final List<RegExp> _patterns = [
    // student_id / studentId / StudentId / StudentID / STUDENT_ID
    RegExp(
      r'student[_\s]?id\s*[:\-=]\s*([A-Za-z0-9]+)',
      caseSensitive: false,
    ),
    // id: / ID: / ID= / ID-
    RegExp(
      r'\bid\b\s*[:\-=]\s*([A-Za-z0-9]+)',
      caseSensitive: false,
    ),
    // roll / roll_no / rollno
    RegExp(
      r'roll[_\s]?(?:no|number|num)?\s*[:\-=]\s*([A-Za-z0-9]+)',
      caseSensitive: false,
    ),
    // admission_no / admno
    RegExp(
      r'adm(?:ission)?[_\s]?(?:no|number)?\s*[:\-=]\s*([A-Za-z0-9]+)',
      caseSensitive: false,
    ),
  ];

  /// JSON field keys to try (in priority order)
  static const List<String> _jsonKeys = [
    'studentId',
    'student_id',
    'StudentId',
    'StudentID',
    'STUDENT_ID',
    'rollNo',
    'roll_no',
    'admNo',
    'admission_no',
    'id',
    'ID',
  ];

  /// Returns extracted [studentId] and any extra fields like name, class.
  static QrParseResult parse(String rawData) {
    rawData = rawData.trim();

    // ── 1. Try JSON ───────────────────────────────────────────────────────────
    try {
      final dynamic decoded = jsonDecode(rawData);
      if (decoded is Map<String, dynamic>) {
        String? studentId;
        for (final key in _jsonKeys) {
          if (decoded.containsKey(key) && decoded[key] != null) {
            studentId = decoded[key].toString().trim();
            break;
          }
        }
        if (studentId != null && studentId.isNotEmpty) {
          return QrParseResult(
            studentId: studentId,
            studentName: _mapValue(decoded, ['name', 'studentName', 'student_name', 'fullName']),
            className: _mapValue(decoded, ['class', 'className', 'class_name', 'grade']),
            rawData: rawData,
          );
        }
      }
    } catch (_) {}

    // ── 2. Try key:value regex patterns ──────────────────────────────────────
    for (final pattern in _patterns) {
      final match = pattern.firstMatch(rawData);
      if (match != null) {
        final studentId = match.group(1)!.trim();
        final name = _extractInlineField(rawData, ['name', 'studentName', 'student_name']);
        final cls = _extractInlineField(rawData, ['class', 'className', 'grade']);
        return QrParseResult(
          studentId: studentId,
          studentName: name,
          className: cls,
          rawData: rawData,
        );
      }
    }

    // ── 3. Plain alphanumeric / numeric ID (4-20 chars) ──────────────────────
    if (RegExp(r'^[A-Za-z0-9]{3,20}$').hasMatch(rawData)) {
      return QrParseResult(
        studentId: rawData,
        rawData: rawData,
      );
    }

    // ── 4. Could not parse ───────────────────────────────────────────────────
    return QrParseResult(rawData: rawData);
  }

  static String? _mapValue(Map<String, dynamic> map, List<String> keys) {
    for (final k in keys) {
      if (map.containsKey(k) && map[k] != null) {
        return map[k].toString().trim();
      }
    }
    return null;
  }

  static String? _extractInlineField(String data, List<String> keys) {
    for (final key in keys) {
      final pattern = RegExp('$key\\s*[:\\-=]\\s*([^,;\\n]+)', caseSensitive: false);
      final match = pattern.firstMatch(data);
      if (match != null) return match.group(1)?.trim();
    }
    return null;
  }
}

class QrParseResult {
  final String? studentId;
  final String? studentName;
  final String? className;
  final String rawData;

  const QrParseResult({
    this.studentId,
    this.studentName,
    this.className,
    required this.rawData,
  });

  bool get isValid => studentId != null && studentId!.isNotEmpty;

  @override
  String toString() =>
      'QrParseResult(studentId: $studentId, name: $studentName, class: $className)';
}
