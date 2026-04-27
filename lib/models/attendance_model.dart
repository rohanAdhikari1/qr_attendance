import 'package:hive/hive.dart';

enum SyncStatus { pending, synced, failed }

class SyncStatusAdapter extends TypeAdapter<SyncStatus> {
  @override
  final int typeId = 1;

  @override
  SyncStatus read(BinaryReader reader) =>
      SyncStatus.values[reader.readByte()];

  @override
  void write(BinaryWriter writer, SyncStatus obj) =>
      writer.writeByte(obj.index);
}
class AttendanceModel extends HiveObject {
  String id;
  String studentId;
  DateTime timestamp;
  SyncStatus syncStatus;
  String rawQrData;
  String studentName;
  String className;
  String grade;
  int retryCount;

  AttendanceModel({
    required this.id,
    required this.studentId,
    required this.timestamp,
    this.syncStatus = SyncStatus.pending,
    this.rawQrData = '',
    this.studentName = '',
    this.className = '',
    this.grade = '',
    this.retryCount = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'student_id': studentId,
        'timestamp': timestamp.toIso8601String(),
        'raw_qr': rawQrData,
      };

  AttendanceModel copyWith({
    String? id,
    String? studentId,
    DateTime? timestamp,
    SyncStatus? syncStatus,
    String? rawQrData,
    String? studentName,
    String? className,
    String? grade,
    int? retryCount,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      timestamp: timestamp ?? this.timestamp,
      syncStatus: syncStatus ?? this.syncStatus,
      rawQrData: rawQrData ?? this.rawQrData,
      studentName: studentName ?? this.studentName,
      className: className ?? this.className,
      grade: grade ?? this.grade,
      retryCount: retryCount ?? this.retryCount,
    );
  }
}

// ─── Manual Hive Adapter ──────────────────────────────────────────────────────

class AttendanceModelAdapter extends TypeAdapter<AttendanceModel> {
  @override
  final int typeId = 0;

  @override
  AttendanceModel read(BinaryReader reader) {
    final id = reader.readString();
    final studentId = reader.readString();
    final timestamp =
        DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final syncStatus = SyncStatus.values[reader.readByte()];
    final rawQrData = reader.readString();
    final studentName = reader.readString();
    final className = reader.readString();
    final grade = reader.readString();
    final retryCount = reader.readInt();
    return AttendanceModel(
      id: id,
      studentId: studentId,
      timestamp: timestamp,
      syncStatus: syncStatus,
      rawQrData: rawQrData,
      studentName: studentName,
      className: className,
      grade: grade,
      retryCount: retryCount,
    );
  }

  @override
  void write(BinaryWriter writer, AttendanceModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.studentId);
    writer.writeInt(obj.timestamp.millisecondsSinceEpoch);
    writer.writeByte(obj.syncStatus.index);
    writer.writeString(obj.rawQrData);
    writer.writeString(obj.studentName);
    writer.writeString(obj.className);
    writer.writeString(obj.grade);
    writer.writeInt(obj.retryCount);
  }
}
