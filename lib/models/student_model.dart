import 'package:hive/hive.dart';

class StudentModel extends HiveObject {
  String studentId;
  String name;
  String className;
  String grade;
  String? photoUrl;
  DateTime cachedAt;

  StudentModel({
    required this.studentId,
    required this.name,
    required this.className,
    required this.grade,
    this.photoUrl,
    required this.cachedAt,
  });

  /// Is this cache entry still fresh? (24 hours)
  bool get isFresh =>
      DateTime.now().difference(cachedAt).inHours < 24;

  bool get hasName => name.isNotEmpty;

  @override
  String toString() =>
      'StudentModel($studentId, $name, $className)';
}

// ─── Manual Hive Adapter ──────────────────────────────────────────────────────

class StudentModelAdapter extends TypeAdapter<StudentModel> {
  @override
  final int typeId = 2;

  @override
  StudentModel read(BinaryReader reader) {
    final studentId = reader.readString();
    final name = reader.readString();
    final className = reader.readString();
    final grade = reader.readString();
    final photoRaw = reader.readString();
    final cachedAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    return StudentModel(
      studentId: studentId,
      name: name,
      className: className,
      grade: grade,
      photoUrl: photoRaw.isEmpty ? null : photoRaw,
      cachedAt: cachedAt,
    );
  }

  @override
  void write(BinaryWriter writer, StudentModel obj) {
    writer.writeString(obj.studentId);
    writer.writeString(obj.name);
    writer.writeString(obj.className);
    writer.writeString(obj.grade);
    writer.writeString(obj.photoUrl ?? '');
    writer.writeInt(obj.cachedAt.millisecondsSinceEpoch);
  }
}
