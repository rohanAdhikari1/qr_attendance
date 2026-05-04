import 'package:drift/drift.dart';
import '../app_database.dart';
import '../migrations/students_table.dart';

part 'student_dao.g.dart';

@DriftAccessor(tables: [Students])
class StudentDao extends DatabaseAccessor<AppDatabase>
    with _$StudentDaoMixin {
  StudentDao(AppDatabase db) : super(db);

  // =========================
  // INSERT
  // =========================

  Future<void> insertStudent(
      StudentsCompanion student,
      ) async {
    await into(students).insert(
      student,
      mode: InsertMode.insertOrReplace,
    );
  }

  // =========================
  // BULK INSERT
  // =========================

  Future<void> insertStudents(
      List<StudentsCompanion> studentList,
      ) async {
    await batch((batch) {
      batch.insertAll(
        students,
        studentList,
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  // =========================
  // GET ALL
  // =========================

  Future<List<Student>> getAllStudents() {
    return select(students).get();
  }

  // =========================
  // WATCH ALL
  // =========================

  Stream<List<Student>> watchStudents() {
    return select(students).watch();
  }

  // =========================
  // GET BY ID
  // =========================

  Future<Student?> getStudentById(
      String studentId,
      ) {
    return (select(students)
      ..where(
            (tbl) =>
            tbl.studentId.equals(studentId),
      ))
        .getSingleOrNull();
  }

  // =========================
  // SEARCH BY NAME
  // =========================

  Future<List<Student>> searchStudents(
      String query,
      ) {
    return (select(students)
      ..where(
            (tbl) =>
            tbl.name.like('%$query%'),
      ))
        .get();
  }

  // =========================
  // FILTER BY CLASS
  // =========================

  Future<List<Student>> getStudentsByClass(
      String className,
      ) {
    return (select(students)
      ..where(
            (tbl) =>
            tbl.className.equals(className),
      ))
        .get();
  }

  // =========================
  // UPDATE
  // =========================

  Future<bool> updateStudent(
      Student student,
      ) {
    return update(students).replace(student);
  }

  // =========================
  // DELETE
  // =========================

  Future<int> deleteStudent(
      String studentId,
      ) {
    return (delete(students)
      ..where(
            (tbl) =>
            tbl.studentId.equals(studentId),
      ))
        .go();
  }

  // =========================
  // DELETE ALL
  // =========================

  Future<int> deleteAllStudents() {
    return delete(students).go();
  }

  // =========================
  // COUNT
  // =========================

  Future<int> getStudentCount() async {
    final countExp =
    students.studentId.count();

    final query = selectOnly(students)
      ..addColumns([countExp]);

    final result = await query.getSingle();

    return result.read(countExp) ?? 0;
  }

  Stream<int> watchStudentCount() {
    final countExp =
    students.studentId.count();

    final query = selectOnly(students)
      ..addColumns([countExp]);

    return query.watchSingle().map(
          (row) => row.read(countExp) ?? 0,
    );
  }
}