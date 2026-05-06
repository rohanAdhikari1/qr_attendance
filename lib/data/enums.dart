enum ScanState { idle, scanning, success, duplicate, error, unknown }
enum AttendanceStatus { entry,exit,reEntry }
enum SyncStatus { pending, synced, failed }
enum ScanErrorType {
  invalidQr,
  studentNotFound,
  alreadyMarked,
}

extension EnumStorage on Enum {
  String toStorage() => name;
}

T enumFromString<T extends Enum>(
    List<T> values,
    String? value,
    T fallback,
    ) {
  return values.firstWhere(
        (e) => e.name == value,
    orElse: () => fallback,
  );
}