// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AttendancesTableTable extends AttendancesTable
    with TableInfo<$AttendancesTableTable, AttendancesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttendancesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entryTimeMeta = const VerificationMeta(
    'entryTime',
  );
  @override
  late final GeneratedColumn<DateTime> entryTime = GeneratedColumn<DateTime>(
    'entry_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exitTimeMeta = const VerificationMeta(
    'exitTime',
  );
  @override
  late final GeneratedColumn<DateTime> exitTime = GeneratedColumn<DateTime>(
    'exit_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timelapsesMeta = const VerificationMeta(
    'timelapses',
  );
  @override
  late final GeneratedColumn<String> timelapses = GeneratedColumn<String>(
    'timelapses',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawQrDataMeta = const VerificationMeta(
    'rawQrData',
  );
  @override
  late final GeneratedColumn<String> rawQrData = GeneratedColumn<String>(
    'raw_qr_data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    studentId,
    date,
    entryTime,
    exitTime,
    timelapses,
    status,
    syncStatus,
    rawQrData,
    retryCount,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendances_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AttendancesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('entry_time')) {
      context.handle(
        _entryTimeMeta,
        entryTime.isAcceptableOrUnknown(data['entry_time']!, _entryTimeMeta),
      );
    }
    if (data.containsKey('exit_time')) {
      context.handle(
        _exitTimeMeta,
        exitTime.isAcceptableOrUnknown(data['exit_time']!, _exitTimeMeta),
      );
    }
    if (data.containsKey('timelapses')) {
      context.handle(
        _timelapsesMeta,
        timelapses.isAcceptableOrUnknown(data['timelapses']!, _timelapsesMeta),
      );
    } else if (isInserting) {
      context.missing(_timelapsesMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('raw_qr_data')) {
      context.handle(
        _rawQrDataMeta,
        rawQrData.isAcceptableOrUnknown(data['raw_qr_data']!, _rawQrDataMeta),
      );
    } else if (isInserting) {
      context.missing(_rawQrDataMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {studentId, date},
  ];
  @override
  AttendancesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttendancesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      entryTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}entry_time'],
      ),
      exitTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}exit_time'],
      ),
      timelapses: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timelapses'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      rawQrData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_qr_data'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AttendancesTableTable createAlias(String alias) {
    return $AttendancesTableTable(attachedDatabase, alias);
  }
}

class AttendancesTableData extends DataClass
    implements Insertable<AttendancesTableData> {
  final String id;
  final String studentId;
  final DateTime date;
  final DateTime? entryTime;
  final DateTime? exitTime;
  final String timelapses;
  final String status;
  final String syncStatus;
  final String rawQrData;
  final int retryCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AttendancesTableData({
    required this.id,
    required this.studentId,
    required this.date,
    this.entryTime,
    this.exitTime,
    required this.timelapses,
    required this.status,
    required this.syncStatus,
    required this.rawQrData,
    required this.retryCount,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_id'] = Variable<String>(studentId);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || entryTime != null) {
      map['entry_time'] = Variable<DateTime>(entryTime);
    }
    if (!nullToAbsent || exitTime != null) {
      map['exit_time'] = Variable<DateTime>(exitTime);
    }
    map['timelapses'] = Variable<String>(timelapses);
    map['status'] = Variable<String>(status);
    map['sync_status'] = Variable<String>(syncStatus);
    map['raw_qr_data'] = Variable<String>(rawQrData);
    map['retry_count'] = Variable<int>(retryCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AttendancesTableCompanion toCompanion(bool nullToAbsent) {
    return AttendancesTableCompanion(
      id: Value(id),
      studentId: Value(studentId),
      date: Value(date),
      entryTime: entryTime == null && nullToAbsent
          ? const Value.absent()
          : Value(entryTime),
      exitTime: exitTime == null && nullToAbsent
          ? const Value.absent()
          : Value(exitTime),
      timelapses: Value(timelapses),
      status: Value(status),
      syncStatus: Value(syncStatus),
      rawQrData: Value(rawQrData),
      retryCount: Value(retryCount),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AttendancesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttendancesTableData(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String>(json['studentId']),
      date: serializer.fromJson<DateTime>(json['date']),
      entryTime: serializer.fromJson<DateTime?>(json['entryTime']),
      exitTime: serializer.fromJson<DateTime?>(json['exitTime']),
      timelapses: serializer.fromJson<String>(json['timelapses']),
      status: serializer.fromJson<String>(json['status']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      rawQrData: serializer.fromJson<String>(json['rawQrData']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String>(studentId),
      'date': serializer.toJson<DateTime>(date),
      'entryTime': serializer.toJson<DateTime?>(entryTime),
      'exitTime': serializer.toJson<DateTime?>(exitTime),
      'timelapses': serializer.toJson<String>(timelapses),
      'status': serializer.toJson<String>(status),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'rawQrData': serializer.toJson<String>(rawQrData),
      'retryCount': serializer.toJson<int>(retryCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AttendancesTableData copyWith({
    String? id,
    String? studentId,
    DateTime? date,
    Value<DateTime?> entryTime = const Value.absent(),
    Value<DateTime?> exitTime = const Value.absent(),
    String? timelapses,
    String? status,
    String? syncStatus,
    String? rawQrData,
    int? retryCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AttendancesTableData(
    id: id ?? this.id,
    studentId: studentId ?? this.studentId,
    date: date ?? this.date,
    entryTime: entryTime.present ? entryTime.value : this.entryTime,
    exitTime: exitTime.present ? exitTime.value : this.exitTime,
    timelapses: timelapses ?? this.timelapses,
    status: status ?? this.status,
    syncStatus: syncStatus ?? this.syncStatus,
    rawQrData: rawQrData ?? this.rawQrData,
    retryCount: retryCount ?? this.retryCount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AttendancesTableData copyWithCompanion(AttendancesTableCompanion data) {
    return AttendancesTableData(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      date: data.date.present ? data.date.value : this.date,
      entryTime: data.entryTime.present ? data.entryTime.value : this.entryTime,
      exitTime: data.exitTime.present ? data.exitTime.value : this.exitTime,
      timelapses: data.timelapses.present
          ? data.timelapses.value
          : this.timelapses,
      status: data.status.present ? data.status.value : this.status,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      rawQrData: data.rawQrData.present ? data.rawQrData.value : this.rawQrData,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttendancesTableData(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('date: $date, ')
          ..write('entryTime: $entryTime, ')
          ..write('exitTime: $exitTime, ')
          ..write('timelapses: $timelapses, ')
          ..write('status: $status, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rawQrData: $rawQrData, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    studentId,
    date,
    entryTime,
    exitTime,
    timelapses,
    status,
    syncStatus,
    rawQrData,
    retryCount,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttendancesTableData &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.date == this.date &&
          other.entryTime == this.entryTime &&
          other.exitTime == this.exitTime &&
          other.timelapses == this.timelapses &&
          other.status == this.status &&
          other.syncStatus == this.syncStatus &&
          other.rawQrData == this.rawQrData &&
          other.retryCount == this.retryCount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AttendancesTableCompanion extends UpdateCompanion<AttendancesTableData> {
  final Value<String> id;
  final Value<String> studentId;
  final Value<DateTime> date;
  final Value<DateTime?> entryTime;
  final Value<DateTime?> exitTime;
  final Value<String> timelapses;
  final Value<String> status;
  final Value<String> syncStatus;
  final Value<String> rawQrData;
  final Value<int> retryCount;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AttendancesTableCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.date = const Value.absent(),
    this.entryTime = const Value.absent(),
    this.exitTime = const Value.absent(),
    this.timelapses = const Value.absent(),
    this.status = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rawQrData = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttendancesTableCompanion.insert({
    required String id,
    required String studentId,
    required DateTime date,
    this.entryTime = const Value.absent(),
    this.exitTime = const Value.absent(),
    required String timelapses,
    required String status,
    required String syncStatus,
    required String rawQrData,
    this.retryCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       studentId = Value(studentId),
       date = Value(date),
       timelapses = Value(timelapses),
       status = Value(status),
       syncStatus = Value(syncStatus),
       rawQrData = Value(rawQrData);
  static Insertable<AttendancesTableData> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<DateTime>? date,
    Expression<DateTime>? entryTime,
    Expression<DateTime>? exitTime,
    Expression<String>? timelapses,
    Expression<String>? status,
    Expression<String>? syncStatus,
    Expression<String>? rawQrData,
    Expression<int>? retryCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (date != null) 'date': date,
      if (entryTime != null) 'entry_time': entryTime,
      if (exitTime != null) 'exit_time': exitTime,
      if (timelapses != null) 'timelapses': timelapses,
      if (status != null) 'status': status,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rawQrData != null) 'raw_qr_data': rawQrData,
      if (retryCount != null) 'retry_count': retryCount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttendancesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? studentId,
    Value<DateTime>? date,
    Value<DateTime?>? entryTime,
    Value<DateTime?>? exitTime,
    Value<String>? timelapses,
    Value<String>? status,
    Value<String>? syncStatus,
    Value<String>? rawQrData,
    Value<int>? retryCount,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AttendancesTableCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      date: date ?? this.date,
      entryTime: entryTime ?? this.entryTime,
      exitTime: exitTime ?? this.exitTime,
      timelapses: timelapses ?? this.timelapses,
      status: status ?? this.status,
      syncStatus: syncStatus ?? this.syncStatus,
      rawQrData: rawQrData ?? this.rawQrData,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (entryTime.present) {
      map['entry_time'] = Variable<DateTime>(entryTime.value);
    }
    if (exitTime.present) {
      map['exit_time'] = Variable<DateTime>(exitTime.value);
    }
    if (timelapses.present) {
      map['timelapses'] = Variable<String>(timelapses.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rawQrData.present) {
      map['raw_qr_data'] = Variable<String>(rawQrData.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendancesTableCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('date: $date, ')
          ..write('entryTime: $entryTime, ')
          ..write('exitTime: $exitTime, ')
          ..write('timelapses: $timelapses, ')
          ..write('status: $status, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rawQrData: $rawQrData, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudentsTable extends Students with TableInfo<$StudentsTable, Student> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _classNameMeta = const VerificationMeta(
    'className',
  );
  @override
  late final GeneratedColumn<String> className = GeneratedColumn<String>(
    'class_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gradeMeta = const VerificationMeta('grade');
  @override
  late final GeneratedColumn<String> grade = GeneratedColumn<String>(
    'grade',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoUrlMeta = const VerificationMeta(
    'photoUrl',
  );
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
    'photo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _guardianNameMeta = const VerificationMeta(
    'guardianName',
  );
  @override
  late final GeneratedColumn<String> guardianName = GeneratedColumn<String>(
    'guardian_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _guardianPhoneMeta = const VerificationMeta(
    'guardianPhone',
  );
  @override
  late final GeneratedColumn<String> guardianPhone = GeneratedColumn<String>(
    'guardian_phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    studentId,
    name,
    phone,
    className,
    grade,
    photoUrl,
    address,
    guardianName,
    guardianPhone,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'students';
  @override
  VerificationContext validateIntegrity(
    Insertable<Student> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('class_name')) {
      context.handle(
        _classNameMeta,
        className.isAcceptableOrUnknown(data['class_name']!, _classNameMeta),
      );
    } else if (isInserting) {
      context.missing(_classNameMeta);
    }
    if (data.containsKey('grade')) {
      context.handle(
        _gradeMeta,
        grade.isAcceptableOrUnknown(data['grade']!, _gradeMeta),
      );
    } else if (isInserting) {
      context.missing(_gradeMeta);
    }
    if (data.containsKey('photo_url')) {
      context.handle(
        _photoUrlMeta,
        photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('guardian_name')) {
      context.handle(
        _guardianNameMeta,
        guardianName.isAcceptableOrUnknown(
          data['guardian_name']!,
          _guardianNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_guardianNameMeta);
    }
    if (data.containsKey('guardian_phone')) {
      context.handle(
        _guardianPhoneMeta,
        guardianPhone.isAcceptableOrUnknown(
          data['guardian_phone']!,
          _guardianPhoneMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_guardianPhoneMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {studentId};
  @override
  Student map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Student(
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      className: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}class_name'],
      )!,
      grade: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grade'],
      )!,
      photoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_url'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      guardianName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}guardian_name'],
      )!,
      guardianPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}guardian_phone'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $StudentsTable createAlias(String alias) {
    return $StudentsTable(attachedDatabase, alias);
  }
}

class Student extends DataClass implements Insertable<Student> {
  final String studentId;
  final String name;
  final String? phone;
  final String className;
  final String grade;
  final String? photoUrl;
  final String address;
  final String guardianName;
  final String guardianPhone;
  final DateTime cachedAt;
  const Student({
    required this.studentId,
    required this.name,
    this.phone,
    required this.className,
    required this.grade,
    this.photoUrl,
    required this.address,
    required this.guardianName,
    required this.guardianPhone,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['student_id'] = Variable<String>(studentId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['class_name'] = Variable<String>(className);
    map['grade'] = Variable<String>(grade);
    if (!nullToAbsent || photoUrl != null) {
      map['photo_url'] = Variable<String>(photoUrl);
    }
    map['address'] = Variable<String>(address);
    map['guardian_name'] = Variable<String>(guardianName);
    map['guardian_phone'] = Variable<String>(guardianPhone);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  StudentsCompanion toCompanion(bool nullToAbsent) {
    return StudentsCompanion(
      studentId: Value(studentId),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      className: Value(className),
      grade: Value(grade),
      photoUrl: photoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUrl),
      address: Value(address),
      guardianName: Value(guardianName),
      guardianPhone: Value(guardianPhone),
      cachedAt: Value(cachedAt),
    );
  }

  factory Student.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Student(
      studentId: serializer.fromJson<String>(json['studentId']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      className: serializer.fromJson<String>(json['className']),
      grade: serializer.fromJson<String>(json['grade']),
      photoUrl: serializer.fromJson<String?>(json['photoUrl']),
      address: serializer.fromJson<String>(json['address']),
      guardianName: serializer.fromJson<String>(json['guardianName']),
      guardianPhone: serializer.fromJson<String>(json['guardianPhone']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'studentId': serializer.toJson<String>(studentId),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'className': serializer.toJson<String>(className),
      'grade': serializer.toJson<String>(grade),
      'photoUrl': serializer.toJson<String?>(photoUrl),
      'address': serializer.toJson<String>(address),
      'guardianName': serializer.toJson<String>(guardianName),
      'guardianPhone': serializer.toJson<String>(guardianPhone),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  Student copyWith({
    String? studentId,
    String? name,
    Value<String?> phone = const Value.absent(),
    String? className,
    String? grade,
    Value<String?> photoUrl = const Value.absent(),
    String? address,
    String? guardianName,
    String? guardianPhone,
    DateTime? cachedAt,
  }) => Student(
    studentId: studentId ?? this.studentId,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    className: className ?? this.className,
    grade: grade ?? this.grade,
    photoUrl: photoUrl.present ? photoUrl.value : this.photoUrl,
    address: address ?? this.address,
    guardianName: guardianName ?? this.guardianName,
    guardianPhone: guardianPhone ?? this.guardianPhone,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  Student copyWithCompanion(StudentsCompanion data) {
    return Student(
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      className: data.className.present ? data.className.value : this.className,
      grade: data.grade.present ? data.grade.value : this.grade,
      photoUrl: data.photoUrl.present ? data.photoUrl.value : this.photoUrl,
      address: data.address.present ? data.address.value : this.address,
      guardianName: data.guardianName.present
          ? data.guardianName.value
          : this.guardianName,
      guardianPhone: data.guardianPhone.present
          ? data.guardianPhone.value
          : this.guardianPhone,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Student(')
          ..write('studentId: $studentId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('className: $className, ')
          ..write('grade: $grade, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('address: $address, ')
          ..write('guardianName: $guardianName, ')
          ..write('guardianPhone: $guardianPhone, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    studentId,
    name,
    phone,
    className,
    grade,
    photoUrl,
    address,
    guardianName,
    guardianPhone,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Student &&
          other.studentId == this.studentId &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.className == this.className &&
          other.grade == this.grade &&
          other.photoUrl == this.photoUrl &&
          other.address == this.address &&
          other.guardianName == this.guardianName &&
          other.guardianPhone == this.guardianPhone &&
          other.cachedAt == this.cachedAt);
}

class StudentsCompanion extends UpdateCompanion<Student> {
  final Value<String> studentId;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String> className;
  final Value<String> grade;
  final Value<String?> photoUrl;
  final Value<String> address;
  final Value<String> guardianName;
  final Value<String> guardianPhone;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const StudentsCompanion({
    this.studentId = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.className = const Value.absent(),
    this.grade = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.address = const Value.absent(),
    this.guardianName = const Value.absent(),
    this.guardianPhone = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudentsCompanion.insert({
    required String studentId,
    required String name,
    this.phone = const Value.absent(),
    required String className,
    required String grade,
    this.photoUrl = const Value.absent(),
    required String address,
    required String guardianName,
    required String guardianPhone,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : studentId = Value(studentId),
       name = Value(name),
       className = Value(className),
       grade = Value(grade),
       address = Value(address),
       guardianName = Value(guardianName),
       guardianPhone = Value(guardianPhone),
       cachedAt = Value(cachedAt);
  static Insertable<Student> custom({
    Expression<String>? studentId,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? className,
    Expression<String>? grade,
    Expression<String>? photoUrl,
    Expression<String>? address,
    Expression<String>? guardianName,
    Expression<String>? guardianPhone,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (studentId != null) 'student_id': studentId,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (className != null) 'class_name': className,
      if (grade != null) 'grade': grade,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (address != null) 'address': address,
      if (guardianName != null) 'guardian_name': guardianName,
      if (guardianPhone != null) 'guardian_phone': guardianPhone,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudentsCompanion copyWith({
    Value<String>? studentId,
    Value<String>? name,
    Value<String?>? phone,
    Value<String>? className,
    Value<String>? grade,
    Value<String?>? photoUrl,
    Value<String>? address,
    Value<String>? guardianName,
    Value<String>? guardianPhone,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return StudentsCompanion(
      studentId: studentId ?? this.studentId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      className: className ?? this.className,
      grade: grade ?? this.grade,
      photoUrl: photoUrl ?? this.photoUrl,
      address: address ?? this.address,
      guardianName: guardianName ?? this.guardianName,
      guardianPhone: guardianPhone ?? this.guardianPhone,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (className.present) {
      map['class_name'] = Variable<String>(className.value);
    }
    if (grade.present) {
      map['grade'] = Variable<String>(grade.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (guardianName.present) {
      map['guardian_name'] = Variable<String>(guardianName.value);
    }
    if (guardianPhone.present) {
      map['guardian_phone'] = Variable<String>(guardianPhone.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentsCompanion(')
          ..write('studentId: $studentId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('className: $className, ')
          ..write('grade: $grade, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('address: $address, ')
          ..write('guardianName: $guardianName, ')
          ..write('guardianPhone: $guardianPhone, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AttendancesTableTable attendancesTable = $AttendancesTableTable(
    this,
  );
  late final $StudentsTable students = $StudentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    attendancesTable,
    students,
  ];
}

typedef $$AttendancesTableTableCreateCompanionBuilder =
    AttendancesTableCompanion Function({
      required String id,
      required String studentId,
      required DateTime date,
      Value<DateTime?> entryTime,
      Value<DateTime?> exitTime,
      required String timelapses,
      required String status,
      required String syncStatus,
      required String rawQrData,
      Value<int> retryCount,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$AttendancesTableTableUpdateCompanionBuilder =
    AttendancesTableCompanion Function({
      Value<String> id,
      Value<String> studentId,
      Value<DateTime> date,
      Value<DateTime?> entryTime,
      Value<DateTime?> exitTime,
      Value<String> timelapses,
      Value<String> status,
      Value<String> syncStatus,
      Value<String> rawQrData,
      Value<int> retryCount,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AttendancesTableTableFilterComposer
    extends Composer<_$AppDatabase, $AttendancesTableTable> {
  $$AttendancesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get entryTime => $composableBuilder(
    column: $table.entryTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get exitTime => $composableBuilder(
    column: $table.exitTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timelapses => $composableBuilder(
    column: $table.timelapses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawQrData => $composableBuilder(
    column: $table.rawQrData,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AttendancesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AttendancesTableTable> {
  $$AttendancesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get entryTime => $composableBuilder(
    column: $table.entryTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get exitTime => $composableBuilder(
    column: $table.exitTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timelapses => $composableBuilder(
    column: $table.timelapses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawQrData => $composableBuilder(
    column: $table.rawQrData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AttendancesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttendancesTableTable> {
  $$AttendancesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get entryTime =>
      $composableBuilder(column: $table.entryTime, builder: (column) => column);

  GeneratedColumn<DateTime> get exitTime =>
      $composableBuilder(column: $table.exitTime, builder: (column) => column);

  GeneratedColumn<String> get timelapses => $composableBuilder(
    column: $table.timelapses,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawQrData =>
      $composableBuilder(column: $table.rawQrData, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AttendancesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttendancesTableTable,
          AttendancesTableData,
          $$AttendancesTableTableFilterComposer,
          $$AttendancesTableTableOrderingComposer,
          $$AttendancesTableTableAnnotationComposer,
          $$AttendancesTableTableCreateCompanionBuilder,
          $$AttendancesTableTableUpdateCompanionBuilder,
          (
            AttendancesTableData,
            BaseReferences<
              _$AppDatabase,
              $AttendancesTableTable,
              AttendancesTableData
            >,
          ),
          AttendancesTableData,
          PrefetchHooks Function()
        > {
  $$AttendancesTableTableTableManager(
    _$AppDatabase db,
    $AttendancesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttendancesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttendancesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttendancesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> studentId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<DateTime?> entryTime = const Value.absent(),
                Value<DateTime?> exitTime = const Value.absent(),
                Value<String> timelapses = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String> rawQrData = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttendancesTableCompanion(
                id: id,
                studentId: studentId,
                date: date,
                entryTime: entryTime,
                exitTime: exitTime,
                timelapses: timelapses,
                status: status,
                syncStatus: syncStatus,
                rawQrData: rawQrData,
                retryCount: retryCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String studentId,
                required DateTime date,
                Value<DateTime?> entryTime = const Value.absent(),
                Value<DateTime?> exitTime = const Value.absent(),
                required String timelapses,
                required String status,
                required String syncStatus,
                required String rawQrData,
                Value<int> retryCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttendancesTableCompanion.insert(
                id: id,
                studentId: studentId,
                date: date,
                entryTime: entryTime,
                exitTime: exitTime,
                timelapses: timelapses,
                status: status,
                syncStatus: syncStatus,
                rawQrData: rawQrData,
                retryCount: retryCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AttendancesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttendancesTableTable,
      AttendancesTableData,
      $$AttendancesTableTableFilterComposer,
      $$AttendancesTableTableOrderingComposer,
      $$AttendancesTableTableAnnotationComposer,
      $$AttendancesTableTableCreateCompanionBuilder,
      $$AttendancesTableTableUpdateCompanionBuilder,
      (
        AttendancesTableData,
        BaseReferences<
          _$AppDatabase,
          $AttendancesTableTable,
          AttendancesTableData
        >,
      ),
      AttendancesTableData,
      PrefetchHooks Function()
    >;
typedef $$StudentsTableCreateCompanionBuilder =
    StudentsCompanion Function({
      required String studentId,
      required String name,
      Value<String?> phone,
      required String className,
      required String grade,
      Value<String?> photoUrl,
      required String address,
      required String guardianName,
      required String guardianPhone,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$StudentsTableUpdateCompanionBuilder =
    StudentsCompanion Function({
      Value<String> studentId,
      Value<String> name,
      Value<String?> phone,
      Value<String> className,
      Value<String> grade,
      Value<String?> photoUrl,
      Value<String> address,
      Value<String> guardianName,
      Value<String> guardianPhone,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$StudentsTableFilterComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get className => $composableBuilder(
    column: $table.className,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get guardianName => $composableBuilder(
    column: $table.guardianName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get guardianPhone => $composableBuilder(
    column: $table.guardianPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StudentsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get className => $composableBuilder(
    column: $table.className,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get guardianName => $composableBuilder(
    column: $table.guardianName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get guardianPhone => $composableBuilder(
    column: $table.guardianPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get className =>
      $composableBuilder(column: $table.className, builder: (column) => column);

  GeneratedColumn<String> get grade =>
      $composableBuilder(column: $table.grade, builder: (column) => column);

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get guardianName => $composableBuilder(
    column: $table.guardianName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get guardianPhone => $composableBuilder(
    column: $table.guardianPhone,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$StudentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudentsTable,
          Student,
          $$StudentsTableFilterComposer,
          $$StudentsTableOrderingComposer,
          $$StudentsTableAnnotationComposer,
          $$StudentsTableCreateCompanionBuilder,
          $$StudentsTableUpdateCompanionBuilder,
          (Student, BaseReferences<_$AppDatabase, $StudentsTable, Student>),
          Student,
          PrefetchHooks Function()
        > {
  $$StudentsTableTableManager(_$AppDatabase db, $StudentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> studentId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String> className = const Value.absent(),
                Value<String> grade = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> guardianName = const Value.absent(),
                Value<String> guardianPhone = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudentsCompanion(
                studentId: studentId,
                name: name,
                phone: phone,
                className: className,
                grade: grade,
                photoUrl: photoUrl,
                address: address,
                guardianName: guardianName,
                guardianPhone: guardianPhone,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String studentId,
                required String name,
                Value<String?> phone = const Value.absent(),
                required String className,
                required String grade,
                Value<String?> photoUrl = const Value.absent(),
                required String address,
                required String guardianName,
                required String guardianPhone,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => StudentsCompanion.insert(
                studentId: studentId,
                name: name,
                phone: phone,
                className: className,
                grade: grade,
                photoUrl: photoUrl,
                address: address,
                guardianName: guardianName,
                guardianPhone: guardianPhone,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StudentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudentsTable,
      Student,
      $$StudentsTableFilterComposer,
      $$StudentsTableOrderingComposer,
      $$StudentsTableAnnotationComposer,
      $$StudentsTableCreateCompanionBuilder,
      $$StudentsTableUpdateCompanionBuilder,
      (Student, BaseReferences<_$AppDatabase, $StudentsTable, Student>),
      Student,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AttendancesTableTableTableManager get attendancesTable =>
      $$AttendancesTableTableTableManager(_db, _db.attendancesTable);
  $$StudentsTableTableManager get students =>
      $$StudentsTableTableManager(_db, _db.students);
}
