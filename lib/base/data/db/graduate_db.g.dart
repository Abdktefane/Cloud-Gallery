// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graduate_db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Backup extends DataClass implements Insertable<Backup> {
  final String? path;
  final Uint8List thumbData;
  final String id;
  final String? title;
  final String? serverPath;
  final BackupStatus status;
  final BackupModifier modifier;
  final bool needRestore;
  final DateTime createdDate;
  Backup(
      {this.path,
      required this.thumbData,
      required this.id,
      this.title,
      this.serverPath,
      required this.status,
      required this.modifier,
      required this.needRestore,
      required this.createdDate});
  factory Backup.fromData(Map<String, dynamic> data, GeneratedDatabase db, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Backup(
      path: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}path']),
      thumbData: const BlobType().mapFromDatabaseResponse(data['${effectivePrefix}thumb_data'])!,
      id: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      title: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}title']),
      serverPath: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}server_path']),
      status: $BackupsTable.$converter0
          .mapToDart(const IntType().mapFromDatabaseResponse(data['${effectivePrefix}status']))!,
      modifier: $BackupsTable.$converter1
          .mapToDart(const IntType().mapFromDatabaseResponse(data['${effectivePrefix}modifier']))!,
      needRestore: const BoolType().mapFromDatabaseResponse(data['${effectivePrefix}need_restore'])!,
      createdDate: const DateTimeType().mapFromDatabaseResponse(data['${effectivePrefix}created_date'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || path != null) {
      map['path'] = Variable<String?>(path);
    }
    map['thumb_data'] = Variable<Uint8List>(thumbData);
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String?>(title);
    }
    if (!nullToAbsent || serverPath != null) {
      map['server_path'] = Variable<String?>(serverPath);
    }
    {
      final converter = $BackupsTable.$converter0;
      map['status'] = Variable<int>(converter.mapToSql(status)!);
    }
    {
      final converter = $BackupsTable.$converter1;
      map['modifier'] = Variable<int>(converter.mapToSql(modifier)!);
    }
    map['need_restore'] = Variable<bool>(needRestore);
    map['created_date'] = Variable<DateTime>(createdDate);
    return map;
  }

  BackupsCompanion toCompanion(bool nullToAbsent) {
    return BackupsCompanion(
      path: path == null && nullToAbsent ? const Value.absent() : Value(path),
      thumbData: Value(thumbData),
      id: Value(id),
      title: title == null && nullToAbsent ? const Value.absent() : Value(title),
      serverPath: serverPath == null && nullToAbsent ? const Value.absent() : Value(serverPath),
      status: Value(status),
      modifier: Value(modifier),
      needRestore: Value(needRestore),
      createdDate: Value(createdDate),
    );
  }

  factory Backup.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Backup(
      path: serializer.fromJson<String?>(json['path']),
      thumbData: serializer.fromJson<Uint8List>(json['thumbData']),
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String?>(json['title']),
      serverPath: serializer.fromJson<String?>(json['serverPath']),
      status: serializer.fromJson<BackupStatus>(json['status']),
      modifier: serializer.fromJson<BackupModifier>(json['modifier']),
      needRestore: serializer.fromJson<bool>(json['needRestore']),
      createdDate: serializer.fromJson<DateTime>(json['createdDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'path': serializer.toJson<String?>(path),
      'thumbData': serializer.toJson<Uint8List>(thumbData),
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String?>(title),
      'serverPath': serializer.toJson<String?>(serverPath),
      'status': serializer.toJson<BackupStatus>(status),
      'modifier': serializer.toJson<BackupModifier>(modifier),
      'needRestore': serializer.toJson<bool>(needRestore),
      'createdDate': serializer.toJson<DateTime>(createdDate),
    };
  }

  Backup copyWith(
          {String? path,
          Uint8List? thumbData,
          String? id,
          String? title,
          String? serverPath,
          BackupStatus? status,
          BackupModifier? modifier,
          bool? needRestore,
          DateTime? createdDate}) =>
      Backup(
        path: path ?? this.path,
        thumbData: thumbData ?? this.thumbData,
        id: id ?? this.id,
        title: title ?? this.title,
        serverPath: serverPath ?? this.serverPath,
        status: status ?? this.status,
        modifier: modifier ?? this.modifier,
        needRestore: needRestore ?? this.needRestore,
        createdDate: createdDate ?? this.createdDate,
      );
  @override
  String toString() {
    return (StringBuffer('Backup(')
          ..write('path: $path, ')
          ..write('thumbData: $thumbData, ')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('serverPath: $serverPath, ')
          ..write('status: $status, ')
          ..write('modifier: $modifier, ')
          ..write('needRestore: $needRestore, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      path.hashCode,
      $mrjc(
          thumbData.hashCode,
          $mrjc(
              id.hashCode,
              $mrjc(
                  title.hashCode,
                  $mrjc(
                      serverPath.hashCode,
                      $mrjc(status.hashCode,
                          $mrjc(modifier.hashCode, $mrjc(needRestore.hashCode, createdDate.hashCode)))))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Backup &&
          other.path == this.path &&
          // other.thumbData == this.thumbData &&
          other.id == this.id &&
          other.title == this.title &&
          other.serverPath == this.serverPath &&
          other.status == this.status &&
          other.modifier == this.modifier &&
          other.needRestore == this.needRestore &&
          other.createdDate == this.createdDate);
}

class BackupsCompanion extends UpdateCompanion<Backup> {
  final Value<String?> path;
  final Value<Uint8List> thumbData;
  final Value<String> id;
  final Value<String?> title;
  final Value<String?> serverPath;
  final Value<BackupStatus> status;
  final Value<BackupModifier> modifier;
  final Value<bool> needRestore;
  final Value<DateTime> createdDate;
  const BackupsCompanion({
    this.path = const Value.absent(),
    this.thumbData = const Value.absent(),
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.serverPath = const Value.absent(),
    this.status = const Value.absent(),
    this.modifier = const Value.absent(),
    this.needRestore = const Value.absent(),
    this.createdDate = const Value.absent(),
  });
  BackupsCompanion.insert({
    this.path = const Value.absent(),
    required Uint8List thumbData,
    required String id,
    this.title = const Value.absent(),
    this.serverPath = const Value.absent(),
    this.status = const Value.absent(),
    this.modifier = const Value.absent(),
    this.needRestore = const Value.absent(),
    this.createdDate = const Value.absent(),
  })  : thumbData = Value(thumbData),
        id = Value(id);
  static Insertable<Backup> custom({
    Expression<String?>? path,
    Expression<Uint8List>? thumbData,
    Expression<String>? id,
    Expression<String?>? title,
    Expression<String?>? serverPath,
    Expression<BackupStatus>? status,
    Expression<BackupModifier>? modifier,
    Expression<bool>? needRestore,
    Expression<DateTime>? createdDate,
  }) {
    return RawValuesInsertable({
      if (path != null) 'path': path,
      if (thumbData != null) 'thumb_data': thumbData,
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (serverPath != null) 'server_path': serverPath,
      if (status != null) 'status': status,
      if (modifier != null) 'modifier': modifier,
      if (needRestore != null) 'need_restore': needRestore,
      if (createdDate != null) 'created_date': createdDate,
    });
  }

  BackupsCompanion copyWith(
      {Value<String?>? path,
      Value<Uint8List>? thumbData,
      Value<String>? id,
      Value<String?>? title,
      Value<String?>? serverPath,
      Value<BackupStatus>? status,
      Value<BackupModifier>? modifier,
      Value<bool>? needRestore,
      Value<DateTime>? createdDate}) {
    return BackupsCompanion(
      path: path ?? this.path,
      thumbData: thumbData ?? this.thumbData,
      id: id ?? this.id,
      title: title ?? this.title,
      serverPath: serverPath ?? this.serverPath,
      status: status ?? this.status,
      modifier: modifier ?? this.modifier,
      needRestore: needRestore ?? this.needRestore,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (path.present) {
      map['path'] = Variable<String?>(path.value);
    }
    if (thumbData.present) {
      map['thumb_data'] = Variable<Uint8List>(thumbData.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String?>(title.value);
    }
    if (serverPath.present) {
      map['server_path'] = Variable<String?>(serverPath.value);
    }
    if (status.present) {
      final converter = $BackupsTable.$converter0;
      map['status'] = Variable<int>(converter.mapToSql(status.value)!);
    }
    if (modifier.present) {
      final converter = $BackupsTable.$converter1;
      map['modifier'] = Variable<int>(converter.mapToSql(modifier.value)!);
    }
    if (needRestore.present) {
      map['need_restore'] = Variable<bool>(needRestore.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<DateTime>(createdDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BackupsCompanion(')
          ..write('path: $path, ')
          ..write('thumbData: $thumbData, ')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('serverPath: $serverPath, ')
          ..write('status: $status, ')
          ..write('modifier: $modifier, ')
          ..write('needRestore: $needRestore, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }
}

class $BackupsTable extends Backups with TableInfo<$BackupsTable, Backup> {
  final GeneratedDatabase _db;
  final String? _alias;
  $BackupsTable(this._db, [this._alias]);
  final VerificationMeta _pathMeta = const VerificationMeta('path');
  late final GeneratedColumn<String?> path =
      GeneratedColumn<String?>('path', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _thumbDataMeta = const VerificationMeta('thumbData');
  late final GeneratedColumn<Uint8List?> thumbData =
      GeneratedColumn<Uint8List?>('thumb_data', aliasedName, false, typeName: 'BLOB', requiredDuringInsert: true);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String?> id =
      GeneratedColumn<String?>('id', aliasedName, false, typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>('title', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false, $customConstraints: 'UNIQUE');
  final VerificationMeta _serverPathMeta = const VerificationMeta('serverPath');
  late final GeneratedColumn<String?> serverPath =
      GeneratedColumn<String?>('server_path', aliasedName, true, typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  late final GeneratedColumnWithTypeConverter<BackupStatus, int?> status = GeneratedColumn<int?>(
          'status', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: false, defaultValue: Constant(BackupStatus.UPLOADED.index))
      .withConverter<BackupStatus>($BackupsTable.$converter0);
  final VerificationMeta _modifierMeta = const VerificationMeta('modifier');
  late final GeneratedColumnWithTypeConverter<BackupModifier, int?> modifier = GeneratedColumn<int?>(
          'modifier', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: false, defaultValue: Constant(BackupModifier.PRIVATE.index))
      .withConverter<BackupModifier>($BackupsTable.$converter1);
  final VerificationMeta _needRestoreMeta = const VerificationMeta('needRestore');
  late final GeneratedColumn<bool?> needRestore = GeneratedColumn<bool?>('need_restore', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (need_restore IN (0, 1))',
      defaultValue: const Constant(true));
  final VerificationMeta _createdDateMeta = const VerificationMeta('createdDate');
  late final GeneratedColumn<DateTime?> createdDate = GeneratedColumn<DateTime?>('created_date', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: false, defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [path, thumbData, id, title, serverPath, status, modifier, needRestore, createdDate];
  @override
  String get aliasedName => _alias ?? 'backups';
  @override
  String get actualTableName => 'backups';
  @override
  VerificationContext validateIntegrity(Insertable<Backup> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('path')) {
      context.handle(_pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    }
    if (data.containsKey('thumb_data')) {
      context.handle(_thumbDataMeta, thumbData.isAcceptableOrUnknown(data['thumb_data']!, _thumbDataMeta));
    } else if (isInserting) {
      context.missing(_thumbDataMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(_titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('server_path')) {
      context.handle(_serverPathMeta, serverPath.isAcceptableOrUnknown(data['server_path']!, _serverPathMeta));
    }
    context.handle(_statusMeta, const VerificationResult.success());
    context.handle(_modifierMeta, const VerificationResult.success());
    if (data.containsKey('need_restore')) {
      context.handle(_needRestoreMeta, needRestore.isAcceptableOrUnknown(data['need_restore']!, _needRestoreMeta));
    }
    if (data.containsKey('created_date')) {
      context.handle(_createdDateMeta, createdDate.isAcceptableOrUnknown(data['created_date']!, _createdDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Backup map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Backup.fromData(data, _db, prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $BackupsTable createAlias(String alias) {
    return $BackupsTable(_db, alias);
  }

  static TypeConverter<BackupStatus, int> $converter0 = const EnumIndexConverter<BackupStatus>(BackupStatus.values);
  static TypeConverter<BackupModifier, int> $converter1 =
      const EnumIndexConverter<BackupModifier>(BackupModifier.values);
}

class LastSyncRequest extends DataClass implements Insertable<LastSyncRequest> {
  final int id;
  final DateTime? lastSyncDate;
  LastSyncRequest({required this.id, this.lastSyncDate});
  factory LastSyncRequest.fromData(Map<String, dynamic> data, GeneratedDatabase db, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return LastSyncRequest(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      lastSyncDate: const DateTimeType().mapFromDatabaseResponse(data['${effectivePrefix}last_sync_date']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || lastSyncDate != null) {
      map['last_sync_date'] = Variable<DateTime?>(lastSyncDate);
    }
    return map;
  }

  LastSyncRequestsCompanion toCompanion(bool nullToAbsent) {
    return LastSyncRequestsCompanion(
      id: Value(id),
      lastSyncDate: lastSyncDate == null && nullToAbsent ? const Value.absent() : Value(lastSyncDate),
    );
  }

  factory LastSyncRequest.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return LastSyncRequest(
      id: serializer.fromJson<int>(json['id']),
      lastSyncDate: serializer.fromJson<DateTime?>(json['lastSyncDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lastSyncDate': serializer.toJson<DateTime?>(lastSyncDate),
    };
  }

  LastSyncRequest copyWith({int? id, DateTime? lastSyncDate}) => LastSyncRequest(
        id: id ?? this.id,
        lastSyncDate: lastSyncDate ?? this.lastSyncDate,
      );
  @override
  String toString() {
    return (StringBuffer('LastSyncRequest(')..write('id: $id, ')..write('lastSyncDate: $lastSyncDate')..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, lastSyncDate.hashCode));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LastSyncRequest && other.id == this.id && other.lastSyncDate == this.lastSyncDate);
}

class LastSyncRequestsCompanion extends UpdateCompanion<LastSyncRequest> {
  final Value<int> id;
  final Value<DateTime?> lastSyncDate;
  const LastSyncRequestsCompanion({
    this.id = const Value.absent(),
    this.lastSyncDate = const Value.absent(),
  });
  LastSyncRequestsCompanion.insert({
    this.id = const Value.absent(),
    this.lastSyncDate = const Value.absent(),
  });
  static Insertable<LastSyncRequest> custom({
    Expression<int>? id,
    Expression<DateTime?>? lastSyncDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lastSyncDate != null) 'last_sync_date': lastSyncDate,
    });
  }

  LastSyncRequestsCompanion copyWith({Value<int>? id, Value<DateTime?>? lastSyncDate}) {
    return LastSyncRequestsCompanion(
      id: id ?? this.id,
      lastSyncDate: lastSyncDate ?? this.lastSyncDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lastSyncDate.present) {
      map['last_sync_date'] = Variable<DateTime?>(lastSyncDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LastSyncRequestsCompanion(')
          ..write('id: $id, ')
          ..write('lastSyncDate: $lastSyncDate')
          ..write(')'))
        .toString();
  }
}

class $LastSyncRequestsTable extends LastSyncRequests with TableInfo<$LastSyncRequestsTable, LastSyncRequest> {
  final GeneratedDatabase _db;
  final String? _alias;
  $LastSyncRequestsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>('id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT',
      defaultValue: const Constant(0));
  final VerificationMeta _lastSyncDateMeta = const VerificationMeta('lastSyncDate');
  late final GeneratedColumn<DateTime?> lastSyncDate =
      GeneratedColumn<DateTime?>('last_sync_date', aliasedName, true, typeName: 'INTEGER', requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, lastSyncDate];
  @override
  String get aliasedName => _alias ?? 'last_sync_requests';
  @override
  String get actualTableName => 'last_sync_requests';
  @override
  VerificationContext validateIntegrity(Insertable<LastSyncRequest> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('last_sync_date')) {
      context.handle(_lastSyncDateMeta, lastSyncDate.isAcceptableOrUnknown(data['last_sync_date']!, _lastSyncDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LastSyncRequest map(Map<String, dynamic> data, {String? tablePrefix}) {
    return LastSyncRequest.fromData(data, _db, prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $LastSyncRequestsTable createAlias(String alias) {
    return $LastSyncRequestsTable(_db, alias);
  }
}

class Token extends DataClass implements Insertable<Token> {
  final int id;
  final String token;
  Token({required this.id, required this.token});
  factory Token.fromData(Map<String, dynamic> data, GeneratedDatabase db, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Token(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      token: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}token'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['token'] = Variable<String>(token);
    return map;
  }

  TokensCompanion toCompanion(bool nullToAbsent) {
    return TokensCompanion(
      id: Value(id),
      token: Value(token),
    );
  }

  factory Token.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Token(
      id: serializer.fromJson<int>(json['id']),
      token: serializer.fromJson<String>(json['token']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'token': serializer.toJson<String>(token),
    };
  }

  Token copyWith({int? id, String? token}) => Token(
        id: id ?? this.id,
        token: token ?? this.token,
      );
  @override
  String toString() {
    return (StringBuffer('Token(')..write('id: $id, ')..write('token: $token')..write(')')).toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, token.hashCode));
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Token && other.id == this.id && other.token == this.token);
}

class TokensCompanion extends UpdateCompanion<Token> {
  final Value<int> id;
  final Value<String> token;
  const TokensCompanion({
    this.id = const Value.absent(),
    this.token = const Value.absent(),
  });
  TokensCompanion.insert({
    this.id = const Value.absent(),
    required String token,
  }) : token = Value(token);
  static Insertable<Token> custom({
    Expression<int>? id,
    Expression<String>? token,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (token != null) 'token': token,
    });
  }

  TokensCompanion copyWith({Value<int>? id, Value<String>? token}) {
    return TokensCompanion(
      id: id ?? this.id,
      token: token ?? this.token,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TokensCompanion(')..write('id: $id, ')..write('token: $token')..write(')')).toString();
  }
}

class $TokensTable extends Tokens with TableInfo<$TokensTable, Token> {
  final GeneratedDatabase _db;
  final String? _alias;
  $TokensTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>('id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT',
      defaultValue: const Constant(0));
  final VerificationMeta _tokenMeta = const VerificationMeta('token');
  late final GeneratedColumn<String?> token =
      GeneratedColumn<String?>('token', aliasedName, false, typeName: 'TEXT', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, token];
  @override
  String get aliasedName => _alias ?? 'tokens';
  @override
  String get actualTableName => 'tokens';
  @override
  VerificationContext validateIntegrity(Insertable<Token> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('token')) {
      context.handle(_tokenMeta, token.isAcceptableOrUnknown(data['token']!, _tokenMeta));
    } else if (isInserting) {
      context.missing(_tokenMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Token map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Token.fromData(data, _db, prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TokensTable createAlias(String alias) {
    return $TokensTable(_db, alias);
  }
}

abstract class _$GraduateDB extends GeneratedDatabase {
  _$GraduateDB(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  _$GraduateDB.connect(DatabaseConnection c) : super.connect(c);
  late final $BackupsTable backups = $BackupsTable(this);
  late final $LastSyncRequestsTable lastSyncRequests = $LastSyncRequestsTable(this);
  late final $TokensTable tokens = $TokensTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [backups, lastSyncRequests, tokens];
}
