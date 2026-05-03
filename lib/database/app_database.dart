import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'migrations/attendances_table.dart';
import 'migrations/students_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [AttendancesTable, Students])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}


LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File('$dbFolder/qr_attendance_db.sqlite');
    return NativeDatabase.createInBackground(file);
  });
}
