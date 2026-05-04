import 'package:drift/drift.dart';

class AttendancesTable extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get syncStatus => text()();
  TextColumn get rawQrData => text()();
  TextColumn get studentName => text()();
  TextColumn get className => text()();
  TextColumn get grade => text()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {studentId, timestamp}
  ];
}