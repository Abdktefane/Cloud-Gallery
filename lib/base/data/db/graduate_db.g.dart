// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graduate_db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Backup extends DataClass implements Insertable<Backup> {
  final String path;
  final String mime;
  final Uint8List thumbData;
  final String assetId;
  final String? title;
  final BackupStatus status;
  Backup(
      {required this.path,
      required this.mime,
      required this.thumbData,
      required this.assetId,
      this.title,
      required this.status});
  factory Backup.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Backup(
      path: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}path'])!,
      mime: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}mime'])!,
      thumbData: const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}thumb_data'])!,
      assetId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}asset_id'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title']),
      status: $BackupsTable.$converter0.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}status']))!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['path'] = Variable<String>(path);
    map['mime'] = Variable<String>(mime);
    map['thumb_data'] = Variable<Uint8List>(thumbData);
    map['asset_id'] = Variable<String>(assetId);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String?>(title);
    }
    {
      final converter = $BackupsTable.$converter0;
      map['status'] = Variable<int>(converter.mapToSql(status)!);
    }
    return map;
  }

  BackupsCompanion toCompanion(bool nullToAbsent) {
    return BackupsCompanion(
      path: Value(path),
      mime: Value(mime),
      thumbData: Value(thumbData),
      assetId: Value(assetId),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      status: Value(status),
    );
  }

  factory Backup.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Backup(
      path: serializer.fromJson<String>(json['path']),
      mime: serializer.fromJson<String>(json['mime']),
      thumbData: serializer.fromJson<Uint8List>(json['thumbData']),
      assetId: serializer.fromJson<String>(json['assetId']),
      title: serializer.fromJson<String?>(json['title']),
      status: serializer.fromJson<BackupStatus>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'path': serializer.toJson<String>(path),
      'mime': serializer.toJson<String>(mime),
      'thumbData': serializer.toJson<Uint8List>(thumbData),
      'assetId': serializer.toJson<String>(assetId),
      'title': serializer.toJson<String?>(title),
      'status': serializer.toJson<BackupStatus>(status),
    };
  }

  Backup copyWith(
          {String? path,
          String? mime,
          Uint8List? thumbData,
          String? assetId,
          String? title,
          BackupStatus? status}) =>
      Backup(
        path: path ?? this.path,
        mime: mime ?? this.mime,
        thumbData: thumbData ?? this.thumbData,
        assetId: assetId ?? this.assetId,
        title: title ?? this.title,
        status: status ?? this.status,
      );
  @override
  String toString() {
    return (StringBuffer('Backup(')
          ..write('path: $path, ')
          ..write('mime: $mime, ')
          ..write('thumbData: $thumbData, ')
          ..write('assetId: $assetId, ')
          ..write('title: $title, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      path.hashCode,
      $mrjc(
          mime.hashCode,
          $mrjc(
              thumbData.hashCode,
              $mrjc(
                  assetId.hashCode, $mrjc(title.hashCode, status.hashCode))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Backup &&
          other.path == this.path &&
          other.mime == this.mime &&
          other.thumbData == this.thumbData &&
          other.assetId == this.assetId &&
          other.title == this.title &&
          other.status == this.status);
}

class BackupsCompanion extends UpdateCompanion<Backup> {
  final Value<String> path;
  final Value<String> mime;
  final Value<Uint8List> thumbData;
  final Value<String> assetId;
  final Value<String?> title;
  final Value<BackupStatus> status;
  const BackupsCompanion({
    this.path = const Value.absent(),
    this.mime = const Value.absent(),
    this.thumbData = const Value.absent(),
    this.assetId = const Value.absent(),
    this.title = const Value.absent(),
    this.status = const Value.absent(),
  });
  BackupsCompanion.insert({
    required String path,
    required String mime,
    required Uint8List thumbData,
    required String assetId,
    this.title = const Value.absent(),
    this.status = const Value.absent(),
  })  : path = Value(path),
        mime = Value(mime),
        thumbData = Value(thumbData),
        assetId = Value(assetId);
  static Insertable<Backup> custom({
    Expression<String>? path,
    Expression<String>? mime,
    Expression<Uint8List>? thumbData,
    Expression<String>? assetId,
    Expression<String?>? title,
    Expression<BackupStatus>? status,
  }) {
    return RawValuesInsertable({
      if (path != null) 'path': path,
      if (mime != null) 'mime': mime,
      if (thumbData != null) 'thumb_data': thumbData,
      if (assetId != null) 'asset_id': assetId,
      if (title != null) 'title': title,
      if (status != null) 'status': status,
    });
  }

  BackupsCompanion copyWith(
      {Value<String>? path,
      Value<String>? mime,
      Value<Uint8List>? thumbData,
      Value<String>? assetId,
      Value<String?>? title,
      Value<BackupStatus>? status}) {
    return BackupsCompanion(
      path: path ?? this.path,
      mime: mime ?? this.mime,
      thumbData: thumbData ?? this.thumbData,
      assetId: assetId ?? this.assetId,
      title: title ?? this.title,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (mime.present) {
      map['mime'] = Variable<String>(mime.value);
    }
    if (thumbData.present) {
      map['thumb_data'] = Variable<Uint8List>(thumbData.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (title.present) {
      map['title'] = Variable<String?>(title.value);
    }
    if (status.present) {
      final converter = $BackupsTable.$converter0;
      map['status'] = Variable<int>(converter.mapToSql(status.value)!);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BackupsCompanion(')
          ..write('path: $path, ')
          ..write('mime: $mime, ')
          ..write('thumbData: $thumbData, ')
          ..write('assetId: $assetId, ')
          ..write('title: $title, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $BackupsTable extends Backups with TableInfo<$BackupsTable, Backup> {
  final GeneratedDatabase _db;
  final String? _alias;
  $BackupsTable(this._db, [this._alias]);
  final VerificationMeta _pathMeta = const VerificationMeta('path');
  late final GeneratedColumn<String?> path = GeneratedColumn<String?>(
      'path', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _mimeMeta = const VerificationMeta('mime');
  late final GeneratedColumn<String?> mime = GeneratedColumn<String?>(
      'mime', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _thumbDataMeta = const VerificationMeta('thumbData');
  late final GeneratedColumn<Uint8List?> thumbData =
      GeneratedColumn<Uint8List?>('thumb_data', aliasedName, false,
          typeName: 'BLOB', requiredDuringInsert: true);
  final VerificationMeta _assetIdMeta = const VerificationMeta('assetId');
  late final GeneratedColumn<String?> assetId = GeneratedColumn<String?>(
      'asset_id', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  late final GeneratedColumnWithTypeConverter<BackupStatus, int?> status =
      GeneratedColumn<int?>('status', aliasedName, false,
              typeName: 'INTEGER',
              requiredDuringInsert: false,
              defaultValue: Constant(BackupStatus.PENDING.index))
          .withConverter<BackupStatus>($BackupsTable.$converter0);
  @override
  List<GeneratedColumn> get $columns =>
      [path, mime, thumbData, assetId, title, status];
  @override
  String get aliasedName => _alias ?? 'backups';
  @override
  String get actualTableName => 'backups';
  @override
  VerificationContext validateIntegrity(Insertable<Backup> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('mime')) {
      context.handle(
          _mimeMeta, mime.isAcceptableOrUnknown(data['mime']!, _mimeMeta));
    } else if (isInserting) {
      context.missing(_mimeMeta);
    }
    if (data.containsKey('thumb_data')) {
      context.handle(_thumbDataMeta,
          thumbData.isAcceptableOrUnknown(data['thumb_data']!, _thumbDataMeta));
    } else if (isInserting) {
      context.missing(_thumbDataMeta);
    }
    if (data.containsKey('asset_id')) {
      context.handle(_assetIdMeta,
          assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta));
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    context.handle(_statusMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {assetId};
  @override
  Backup map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Backup.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $BackupsTable createAlias(String alias) {
    return $BackupsTable(_db, alias);
  }

  static TypeConverter<BackupStatus, int> $converter0 =
      const EnumIndexConverter<BackupStatus>(BackupStatus.values);
}

abstract class _$GraduateDB extends GeneratedDatabase {
  _$GraduateDB(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  _$GraduateDB.connect(DatabaseConnection c) : super.connect(c);
  late final $BackupsTable backups = $BackupsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [backups];
}
