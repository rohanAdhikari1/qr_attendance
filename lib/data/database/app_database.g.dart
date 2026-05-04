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
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
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
  static const VerificationMeta _studentNameMeta = const VerificationMeta(
    'studentName',
  );
  @override
  late final GeneratedColumn<String> studentName = GeneratedColumn<String>(
    'student_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    studentId,
    timestamp,
    syncStatus,
    rawQrData,
    studentName,
    className,
    grade,
    retryCount,
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
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
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
    if (data.containsKey('student_name')) {
      context.handle(
        _studentNameMeta,
        studentName.isAcceptableOrUnknown(
          data['student_name']!,
          _studentNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_studentNameMeta);
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
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {studentId, timestamp},
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
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      rawQrData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_qr_data'],
      )!,
      studentName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_name'],
      )!,
      className: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}class_name'],
      )!,
      grade: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grade'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
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
  final DateTime timestamp;
  final String syncStatus;
  final String rawQrData;
  final String studentName;
  final String className;
  final String grade;
  final int retryCount;
  const AttendancesTableData({
    required this.id,
    required this.studentId,
    required this.timestamp,
    required this.syncStatus,
    required this.rawQrData,
    required this.studentName,
    required this.className,
    required this.grade,
    required this.retryCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_id'] = Variable<String>(studentId);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['sync_status'] = Variable<String>(syncStatus);
    map['raw_qr_data'] = Variable<String>(rawQrData);
    map['student_name'] = Variable<String>(studentName);
    map['class_name'] = Variable<String>(className);
    map['grade'] = Variable<String>(grade);
    map['retry_count'] = Variable<int>(retryCount);
    return map;
  }

  AttendancesTableCompanion toCompanion(bool nullToAbsent) {
    return AttendancesTableCompanion(
      id: Value(id),
      studentId: Value(studentId),
      timestamp: Value(timestamp),
      syncStatus: Value(syncStatus),
      rawQrData: Value(rawQrData),
      studentName: Value(studentName),
      className: Value(className),
      grade: Value(grade),
      retryCount: Value(retryCount),
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
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      rawQrData: serializer.fromJson<String>(json['rawQrData']),
      studentName: serializer.fromJson<String>(json['studentName']),
      className: serializer.fromJson<String>(json['className']),
      grade: serializer.fromJson<String>(json['grade']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String>(studentId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'rawQrData': serializer.toJson<String>(rawQrData),
      'studentName': serializer.toJson<String>(studentName),
      'className': serializer.toJson<String>(className),
      'grade': serializer.toJson<String>(grade),
      'retryCount': serializer.toJson<int>(retryCount),
    };
  }

  AttendancesTableData copyWith({
    String? id,
    String? studentId,
    DateTime? timestamp,
    String? syncStatus,
    String? rawQrData,
    String? studentName,
    String? className,
    String? grade,
    int? retryCount,
  }) => AttendancesTableData(
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
  AttendancesTableData copyWithCompanion(AttendancesTableCompanion data) {
    return AttendancesTableData(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      rawQrData: data.rawQrData.present ? data.rawQrData.value : this.rawQrData,
      studentName: data.studentName.present
          ? data.studentName.value
          : this.studentName,
      className: data.className.present ? data.className.value : this.className,
      grade: data.grade.present ? data.grade.value : this.grade,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttendancesTableData(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('timestamp: $timestamp, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rawQrData: $rawQrData, ')
          ..write('studentName: $studentName, ')
          ..write('className: $className, ')
          ..write('grade: $grade, ')
          ..write('retryCount: $retryCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    studentId,
    timestamp,
    syncStatus,
    rawQrData,
    studentName,
    className,
    grade,
    retryCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttendancesTableData &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.timestamp == this.timestamp &&
          other.syncStatus == this.syncStatus &&
          other.rawQrData == this.rawQrData &&
          other.studentName == this.studentName &&
          other.className == this.className &&
          other.grade == this.grade &&
          other.retryCount == this.retryCount);
}

class AttendancesTableCompanion extends UpdateCompanion<AttendancesTableData> {
  final Value<String> id;
  final Value<String> studentId;
  final Value<DateTime> timestamp;
  final Value<String> syncStatus;
  final Value<String> rawQrData;
  final Value<String> studentName;
  final Value<String> className;
  final Value<String> grade;
  final Value<int> retryCount;
  final Value<int> rowid;
  const AttendancesTableCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rawQrData = const Value.absent(),
    this.studentName = const Value.absent(),
    this.className = const Value.absent(),
    this.grade = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttendancesTableCompanion.insert({
    required String id,
    required String studentId,
    required DateTime timestamp,
    required String syncStatus,
    required String rawQrData,
    required String studentName,
    required String className,
    required String grade,
    this.retryCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       studentId = Value(studentId),
       timestamp = Value(timestamp),
       syncStatus = Value(syncStatus),
       rawQrData = Value(rawQrData),
       studentName = Value(studentName),
       className = Value(className),
       grade = Value(grade);
  static Insertable<AttendancesTableData> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<DateTime>? timestamp,
    Expression<String>? syncStatus,
    Expression<String>? rawQrData,
    Expression<String>? studentName,
    Expression<String>? className,
    Expression<String>? grade,
    Expression<int>? retryCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (timestamp != null) 'timestamp': timestamp,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rawQrData != null) 'raw_qr_data': rawQrData,
      if (studentName != null) 'student_name': studentName,
      if (className != null) 'class_name': className,
      if (grade != null) 'grade': grade,
      if (retryCount != null) 'retry_count': retryCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttendancesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? studentId,
    Value<DateTime>? timestamp,
    Value<String>? syncStatus,
    Value<String>? rawQrData,
    Value<String>? studentName,
    Value<String>? className,
    Value<String>? grade,
    Value<int>? retryCount,
    Value<int>? rowid,
  }) {
    return AttendancesTableCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      timestamp: timestamp ?? this.timestamp,
      syncStatus: syncStatus ?? this.syncStatus,
      rawQrData: rawQrData ?? this.rawQrData,
      studentName: studentName ?? this.studentName,
      className: className ?? this.className,
      grade: grade ?? this.grade,
      retryCount: retryCount ?? this.retryCount,
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
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rawQrData.present) {
      map['raw_qr_data'] = Variable<String>(rawQrData.value);
    }
    if (studentName.present) {
      map['student_name'] = Variable<String>(studentName.value);
    }
    if (className.present) {
      map['class_name'] = Variable<String>(className.value);
    }
    if (grade.present) {
      map['grade'] = Variable<String>(grade.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
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
          ..write('timestamp: $timestamp, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rawQrData: $rawQrData, ')
          ..write('studentName: $studentName, ')
          ..write('className: $className, ')
          ..write('grade: $grade, ')
          ..write('retryCount: $retryCount, ')
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
  final DateTime cachedAt;
  const Student({
    required this.studentId,
    required this.name,
    this.phone,
    required this.className,
    required this.grade,
    this.photoUrl,
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
    DateTime? cachedAt,
  }) => Student(
    studentId: studentId ?? this.studentId,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    className: className ?? this.className,
    grade: grade ?? this.grade,
    photoUrl: photoUrl.present ? photoUrl.value : this.photoUrl,
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
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(studentId, name, phone, className, grade, photoUrl, cachedAt);
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
          other.cachedAt == this.cachedAt);
}

class StudentsCompanion extends UpdateCompanion<Student> {
  final Value<String> studentId;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String> className;
  final Value<String> grade;
  final Value<String?> photoUrl;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const StudentsCompanion({
    this.studentId = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.className = const Value.absent(),
    this.grade = const Value.absent(),
    this.photoUrl = const Value.absent(),
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
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : studentId = Value(studentId),
       name = Value(name),
       className = Value(className),
       grade = Value(grade),
       cachedAt = Value(cachedAt);
  static Insertable<Student> custom({
    Expression<String>? studentId,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? className,
    Expression<String>? grade,
    Expression<String>? photoUrl,
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
      required DateTime timestamp,
      required String syncStatus,
      required String rawQrData,
      required String studentName,
      required String className,
      required String grade,
      Value<int> retryCount,
      Value<int> rowid,
    });
typedef $$AttendancesTableTableUpdateCompanionBuilder =
    AttendancesTableCompanion Function({
      Value<String> id,
      Value<String> studentId,
      Value<DateTime> timestamp,
      Value<String> syncStatus,
      Value<String> rawQrData,
      Value<String> studentName,
      Value<String> className,
      Value<String> grade,
      Value<int> retryCount,
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

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
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

  ColumnFilters<String> get studentName => $composableBuilder(
    column: $table.studentName,
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

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
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

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
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

  ColumnOrderings<String> get studentName => $composableBuilder(
    column: $table.studentName,
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

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
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

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawQrData =>
      $composableBuilder(column: $table.rawQrData, builder: (column) => column);

  GeneratedColumn<String> get studentName => $composableBuilder(
    column: $table.studentName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get className =>
      $composableBuilder(column: $table.className, builder: (column) => column);

  GeneratedColumn<String> get grade =>
      $composableBuilder(column: $table.grade, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );
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
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String> rawQrData = const Value.absent(),
                Value<String> studentName = const Value.absent(),
                Value<String> className = const Value.absent(),
                Value<String> grade = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttendancesTableCompanion(
                id: id,
                studentId: studentId,
                timestamp: timestamp,
                syncStatus: syncStatus,
                rawQrData: rawQrData,
                studentName: studentName,
                className: className,
                grade: grade,
                retryCount: retryCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String studentId,
                required DateTime timestamp,
                required String syncStatus,
                required String rawQrData,
                required String studentName,
                required String className,
                required String grade,
                Value<int> retryCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttendancesTableCompanion.insert(
                id: id,
                studentId: studentId,
                timestamp: timestamp,
                syncStatus: syncStatus,
                rawQrData: rawQrData,
                studentName: studentName,
                className: className,
                grade: grade,
                retryCount: retryCount,
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
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudentsCompanion(
                studentId: studentId,
                name: name,
                phone: phone,
                className: className,
                grade: grade,
                photoUrl: photoUrl,
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
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => StudentsCompanion.insert(
                studentId: studentId,
                name: name,
                phone: phone,
                className: className,
                grade: grade,
                photoUrl: photoUrl,
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
