import 'package:drift/drift.dart';

class AttendancesTable extends Table {
  TextColumn get id => text()();

  TextColumn get studentId => text()();

  DateTimeColumn get date => dateTime()();

  DateTimeColumn get entryTime => dateTime().nullable()();

  DateTimeColumn get exitTime => dateTime().nullable()();

  TextColumn get timelapses => text()();

  TextColumn get status => text()();

  TextColumn get syncStatus => text()();

  TextColumn get rawQrData => text()();

  IntColumn get retryCount =>
      integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {studentId, date},
  ];

  @override
  List<String> get customConstraints => [
    'UNIQUE(student_id, attendance_date)',
  ];
}