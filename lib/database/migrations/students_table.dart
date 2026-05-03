import 'package:drift/drift.dart';

class Students extends Table {
  TextColumn get studentId => text()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get className => text()();
  TextColumn get grade => text()();
  TextColumn get photoUrl => text().nullable()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {studentId};
}