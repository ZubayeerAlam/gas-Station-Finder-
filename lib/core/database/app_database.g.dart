// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $VehiclesTable extends Vehicles with TableInfo<$VehiclesTable, Vehicle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _energyTypeMeta = const VerificationMeta(
    'energyType',
  );
  @override
  late final GeneratedColumn<int> energyType = GeneratedColumn<int>(
    'energy_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _consumptionPer100KmMeta =
      const VerificationMeta('consumptionPer100Km');
  @override
  late final GeneratedColumn<double> consumptionPer100Km =
      GeneratedColumn<double>(
        'consumption_per100_km',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _capacityMeta = const VerificationMeta(
    'capacity',
  );
  @override
  late final GeneratedColumn<double> capacity = GeneratedColumn<double>(
    'capacity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _preferredFuelTypeMeta = const VerificationMeta(
    'preferredFuelType',
  );
  @override
  late final GeneratedColumn<String> preferredFuelType =
      GeneratedColumn<String>(
        'preferred_fuel_type',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _chargingEfficiencyMeta =
      const VerificationMeta('chargingEfficiency');
  @override
  late final GeneratedColumn<double> chargingEfficiency =
      GeneratedColumn<double>(
        'charging_efficiency',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(1.0),
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    energyType,
    consumptionPer100Km,
    capacity,
    preferredFuelType,
    chargingEfficiency,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Vehicle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('energy_type')) {
      context.handle(
        _energyTypeMeta,
        energyType.isAcceptableOrUnknown(data['energy_type']!, _energyTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_energyTypeMeta);
    }
    if (data.containsKey('consumption_per100_km')) {
      context.handle(
        _consumptionPer100KmMeta,
        consumptionPer100Km.isAcceptableOrUnknown(
          data['consumption_per100_km']!,
          _consumptionPer100KmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_consumptionPer100KmMeta);
    }
    if (data.containsKey('capacity')) {
      context.handle(
        _capacityMeta,
        capacity.isAcceptableOrUnknown(data['capacity']!, _capacityMeta),
      );
    } else if (isInserting) {
      context.missing(_capacityMeta);
    }
    if (data.containsKey('preferred_fuel_type')) {
      context.handle(
        _preferredFuelTypeMeta,
        preferredFuelType.isAcceptableOrUnknown(
          data['preferred_fuel_type']!,
          _preferredFuelTypeMeta,
        ),
      );
    }
    if (data.containsKey('charging_efficiency')) {
      context.handle(
        _chargingEfficiencyMeta,
        chargingEfficiency.isAcceptableOrUnknown(
          data['charging_efficiency']!,
          _chargingEfficiencyMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vehicle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vehicle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      energyType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}energy_type'],
      )!,
      consumptionPer100Km: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}consumption_per100_km'],
      )!,
      capacity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}capacity'],
      )!,
      preferredFuelType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_fuel_type'],
      ),
      chargingEfficiency: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}charging_efficiency'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $VehiclesTable createAlias(String alias) {
    return $VehiclesTable(attachedDatabase, alias);
  }
}

class Vehicle extends DataClass implements Insertable<Vehicle> {
  final String id;
  final String name;

  /// `EnergyType.index`.
  final int energyType;
  final double consumptionPer100Km;
  final double capacity;
  final String? preferredFuelType;
  final double chargingEfficiency;
  final DateTime createdAt;
  const Vehicle({
    required this.id,
    required this.name,
    required this.energyType,
    required this.consumptionPer100Km,
    required this.capacity,
    this.preferredFuelType,
    required this.chargingEfficiency,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['energy_type'] = Variable<int>(energyType);
    map['consumption_per100_km'] = Variable<double>(consumptionPer100Km);
    map['capacity'] = Variable<double>(capacity);
    if (!nullToAbsent || preferredFuelType != null) {
      map['preferred_fuel_type'] = Variable<String>(preferredFuelType);
    }
    map['charging_efficiency'] = Variable<double>(chargingEfficiency);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  VehiclesCompanion toCompanion(bool nullToAbsent) {
    return VehiclesCompanion(
      id: Value(id),
      name: Value(name),
      energyType: Value(energyType),
      consumptionPer100Km: Value(consumptionPer100Km),
      capacity: Value(capacity),
      preferredFuelType: preferredFuelType == null && nullToAbsent
          ? const Value.absent()
          : Value(preferredFuelType),
      chargingEfficiency: Value(chargingEfficiency),
      createdAt: Value(createdAt),
    );
  }

  factory Vehicle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vehicle(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      energyType: serializer.fromJson<int>(json['energyType']),
      consumptionPer100Km: serializer.fromJson<double>(
        json['consumptionPer100Km'],
      ),
      capacity: serializer.fromJson<double>(json['capacity']),
      preferredFuelType: serializer.fromJson<String?>(
        json['preferredFuelType'],
      ),
      chargingEfficiency: serializer.fromJson<double>(
        json['chargingEfficiency'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'energyType': serializer.toJson<int>(energyType),
      'consumptionPer100Km': serializer.toJson<double>(consumptionPer100Km),
      'capacity': serializer.toJson<double>(capacity),
      'preferredFuelType': serializer.toJson<String?>(preferredFuelType),
      'chargingEfficiency': serializer.toJson<double>(chargingEfficiency),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Vehicle copyWith({
    String? id,
    String? name,
    int? energyType,
    double? consumptionPer100Km,
    double? capacity,
    Value<String?> preferredFuelType = const Value.absent(),
    double? chargingEfficiency,
    DateTime? createdAt,
  }) => Vehicle(
    id: id ?? this.id,
    name: name ?? this.name,
    energyType: energyType ?? this.energyType,
    consumptionPer100Km: consumptionPer100Km ?? this.consumptionPer100Km,
    capacity: capacity ?? this.capacity,
    preferredFuelType: preferredFuelType.present
        ? preferredFuelType.value
        : this.preferredFuelType,
    chargingEfficiency: chargingEfficiency ?? this.chargingEfficiency,
    createdAt: createdAt ?? this.createdAt,
  );
  Vehicle copyWithCompanion(VehiclesCompanion data) {
    return Vehicle(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      energyType: data.energyType.present
          ? data.energyType.value
          : this.energyType,
      consumptionPer100Km: data.consumptionPer100Km.present
          ? data.consumptionPer100Km.value
          : this.consumptionPer100Km,
      capacity: data.capacity.present ? data.capacity.value : this.capacity,
      preferredFuelType: data.preferredFuelType.present
          ? data.preferredFuelType.value
          : this.preferredFuelType,
      chargingEfficiency: data.chargingEfficiency.present
          ? data.chargingEfficiency.value
          : this.chargingEfficiency,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vehicle(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('energyType: $energyType, ')
          ..write('consumptionPer100Km: $consumptionPer100Km, ')
          ..write('capacity: $capacity, ')
          ..write('preferredFuelType: $preferredFuelType, ')
          ..write('chargingEfficiency: $chargingEfficiency, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    energyType,
    consumptionPer100Km,
    capacity,
    preferredFuelType,
    chargingEfficiency,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vehicle &&
          other.id == this.id &&
          other.name == this.name &&
          other.energyType == this.energyType &&
          other.consumptionPer100Km == this.consumptionPer100Km &&
          other.capacity == this.capacity &&
          other.preferredFuelType == this.preferredFuelType &&
          other.chargingEfficiency == this.chargingEfficiency &&
          other.createdAt == this.createdAt);
}

class VehiclesCompanion extends UpdateCompanion<Vehicle> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> energyType;
  final Value<double> consumptionPer100Km;
  final Value<double> capacity;
  final Value<String?> preferredFuelType;
  final Value<double> chargingEfficiency;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const VehiclesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.energyType = const Value.absent(),
    this.consumptionPer100Km = const Value.absent(),
    this.capacity = const Value.absent(),
    this.preferredFuelType = const Value.absent(),
    this.chargingEfficiency = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VehiclesCompanion.insert({
    required String id,
    required String name,
    required int energyType,
    required double consumptionPer100Km,
    required double capacity,
    this.preferredFuelType = const Value.absent(),
    this.chargingEfficiency = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       energyType = Value(energyType),
       consumptionPer100Km = Value(consumptionPer100Km),
       capacity = Value(capacity),
       createdAt = Value(createdAt);
  static Insertable<Vehicle> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? energyType,
    Expression<double>? consumptionPer100Km,
    Expression<double>? capacity,
    Expression<String>? preferredFuelType,
    Expression<double>? chargingEfficiency,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (energyType != null) 'energy_type': energyType,
      if (consumptionPer100Km != null)
        'consumption_per100_km': consumptionPer100Km,
      if (capacity != null) 'capacity': capacity,
      if (preferredFuelType != null) 'preferred_fuel_type': preferredFuelType,
      if (chargingEfficiency != null) 'charging_efficiency': chargingEfficiency,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VehiclesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? energyType,
    Value<double>? consumptionPer100Km,
    Value<double>? capacity,
    Value<String?>? preferredFuelType,
    Value<double>? chargingEfficiency,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return VehiclesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      energyType: energyType ?? this.energyType,
      consumptionPer100Km: consumptionPer100Km ?? this.consumptionPer100Km,
      capacity: capacity ?? this.capacity,
      preferredFuelType: preferredFuelType ?? this.preferredFuelType,
      chargingEfficiency: chargingEfficiency ?? this.chargingEfficiency,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (energyType.present) {
      map['energy_type'] = Variable<int>(energyType.value);
    }
    if (consumptionPer100Km.present) {
      map['consumption_per100_km'] = Variable<double>(
        consumptionPer100Km.value,
      );
    }
    if (capacity.present) {
      map['capacity'] = Variable<double>(capacity.value);
    }
    if (preferredFuelType.present) {
      map['preferred_fuel_type'] = Variable<String>(preferredFuelType.value);
    }
    if (chargingEfficiency.present) {
      map['charging_efficiency'] = Variable<double>(chargingEfficiency.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehiclesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('energyType: $energyType, ')
          ..write('consumptionPer100Km: $consumptionPer100Km, ')
          ..write('capacity: $capacity, ')
          ..write('preferredFuelType: $preferredFuelType, ')
          ..write('chargingEfficiency: $chargingEfficiency, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FillUpsTable extends FillUps with TableInfo<$FillUpsTable, FillUpRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FillUpsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
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
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCostMeta = const VerificationMeta(
    'totalCost',
  );
  @override
  late final GeneratedColumn<double> totalCost = GeneratedColumn<double>(
    'total_cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 8,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _odometerKmMeta = const VerificationMeta(
    'odometerKm',
  );
  @override
  late final GeneratedColumn<double> odometerKm = GeneratedColumn<double>(
    'odometer_km',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFullMeta = const VerificationMeta('isFull');
  @override
  late final GeneratedColumn<bool> isFull = GeneratedColumn<bool>(
    'is_full',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_full" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _stationNameMeta = const VerificationMeta(
    'stationName',
  );
  @override
  late final GeneratedColumn<String> stationName = GeneratedColumn<String>(
    'station_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    date,
    amount,
    totalCost,
    currencyCode,
    odometerKm,
    isFull,
    stationName,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fill_ups';
  @override
  VerificationContext validateIntegrity(
    Insertable<FillUpRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('total_cost')) {
      context.handle(
        _totalCostMeta,
        totalCost.isAcceptableOrUnknown(data['total_cost']!, _totalCostMeta),
      );
    } else if (isInserting) {
      context.missing(_totalCostMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('odometer_km')) {
      context.handle(
        _odometerKmMeta,
        odometerKm.isAcceptableOrUnknown(data['odometer_km']!, _odometerKmMeta),
      );
    }
    if (data.containsKey('is_full')) {
      context.handle(
        _isFullMeta,
        isFull.isAcceptableOrUnknown(data['is_full']!, _isFullMeta),
      );
    }
    if (data.containsKey('station_name')) {
      context.handle(
        _stationNameMeta,
        stationName.isAcceptableOrUnknown(
          data['station_name']!,
          _stationNameMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FillUpRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FillUpRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      totalCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_cost'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      odometerKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}odometer_km'],
      ),
      isFull: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_full'],
      )!,
      stationName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}station_name'],
      ),
    );
  }

  @override
  $FillUpsTable createAlias(String alias) {
    return $FillUpsTable(attachedDatabase, alias);
  }
}

class FillUpRow extends DataClass implements Insertable<FillUpRow> {
  final String id;
  final String vehicleId;
  final DateTime date;
  final double amount;
  final double totalCost;
  final String currencyCode;
  final double? odometerKm;
  final bool isFull;
  final String? stationName;
  const FillUpRow({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.amount,
    required this.totalCost,
    required this.currencyCode,
    this.odometerKm,
    required this.isFull,
    this.stationName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vehicle_id'] = Variable<String>(vehicleId);
    map['date'] = Variable<DateTime>(date);
    map['amount'] = Variable<double>(amount);
    map['total_cost'] = Variable<double>(totalCost);
    map['currency_code'] = Variable<String>(currencyCode);
    if (!nullToAbsent || odometerKm != null) {
      map['odometer_km'] = Variable<double>(odometerKm);
    }
    map['is_full'] = Variable<bool>(isFull);
    if (!nullToAbsent || stationName != null) {
      map['station_name'] = Variable<String>(stationName);
    }
    return map;
  }

  FillUpsCompanion toCompanion(bool nullToAbsent) {
    return FillUpsCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      date: Value(date),
      amount: Value(amount),
      totalCost: Value(totalCost),
      currencyCode: Value(currencyCode),
      odometerKm: odometerKm == null && nullToAbsent
          ? const Value.absent()
          : Value(odometerKm),
      isFull: Value(isFull),
      stationName: stationName == null && nullToAbsent
          ? const Value.absent()
          : Value(stationName),
    );
  }

  factory FillUpRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FillUpRow(
      id: serializer.fromJson<String>(json['id']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      date: serializer.fromJson<DateTime>(json['date']),
      amount: serializer.fromJson<double>(json['amount']),
      totalCost: serializer.fromJson<double>(json['totalCost']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      odometerKm: serializer.fromJson<double?>(json['odometerKm']),
      isFull: serializer.fromJson<bool>(json['isFull']),
      stationName: serializer.fromJson<String?>(json['stationName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'date': serializer.toJson<DateTime>(date),
      'amount': serializer.toJson<double>(amount),
      'totalCost': serializer.toJson<double>(totalCost),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'odometerKm': serializer.toJson<double?>(odometerKm),
      'isFull': serializer.toJson<bool>(isFull),
      'stationName': serializer.toJson<String?>(stationName),
    };
  }

  FillUpRow copyWith({
    String? id,
    String? vehicleId,
    DateTime? date,
    double? amount,
    double? totalCost,
    String? currencyCode,
    Value<double?> odometerKm = const Value.absent(),
    bool? isFull,
    Value<String?> stationName = const Value.absent(),
  }) => FillUpRow(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    date: date ?? this.date,
    amount: amount ?? this.amount,
    totalCost: totalCost ?? this.totalCost,
    currencyCode: currencyCode ?? this.currencyCode,
    odometerKm: odometerKm.present ? odometerKm.value : this.odometerKm,
    isFull: isFull ?? this.isFull,
    stationName: stationName.present ? stationName.value : this.stationName,
  );
  FillUpRow copyWithCompanion(FillUpsCompanion data) {
    return FillUpRow(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      date: data.date.present ? data.date.value : this.date,
      amount: data.amount.present ? data.amount.value : this.amount,
      totalCost: data.totalCost.present ? data.totalCost.value : this.totalCost,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      odometerKm: data.odometerKm.present
          ? data.odometerKm.value
          : this.odometerKm,
      isFull: data.isFull.present ? data.isFull.value : this.isFull,
      stationName: data.stationName.present
          ? data.stationName.value
          : this.stationName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FillUpRow(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('totalCost: $totalCost, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('odometerKm: $odometerKm, ')
          ..write('isFull: $isFull, ')
          ..write('stationName: $stationName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleId,
    date,
    amount,
    totalCost,
    currencyCode,
    odometerKm,
    isFull,
    stationName,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FillUpRow &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.date == this.date &&
          other.amount == this.amount &&
          other.totalCost == this.totalCost &&
          other.currencyCode == this.currencyCode &&
          other.odometerKm == this.odometerKm &&
          other.isFull == this.isFull &&
          other.stationName == this.stationName);
}

class FillUpsCompanion extends UpdateCompanion<FillUpRow> {
  final Value<String> id;
  final Value<String> vehicleId;
  final Value<DateTime> date;
  final Value<double> amount;
  final Value<double> totalCost;
  final Value<String> currencyCode;
  final Value<double?> odometerKm;
  final Value<bool> isFull;
  final Value<String?> stationName;
  final Value<int> rowid;
  const FillUpsCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.date = const Value.absent(),
    this.amount = const Value.absent(),
    this.totalCost = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.odometerKm = const Value.absent(),
    this.isFull = const Value.absent(),
    this.stationName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FillUpsCompanion.insert({
    required String id,
    required String vehicleId,
    required DateTime date,
    required double amount,
    required double totalCost,
    required String currencyCode,
    this.odometerKm = const Value.absent(),
    this.isFull = const Value.absent(),
    this.stationName = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vehicleId = Value(vehicleId),
       date = Value(date),
       amount = Value(amount),
       totalCost = Value(totalCost),
       currencyCode = Value(currencyCode);
  static Insertable<FillUpRow> custom({
    Expression<String>? id,
    Expression<String>? vehicleId,
    Expression<DateTime>? date,
    Expression<double>? amount,
    Expression<double>? totalCost,
    Expression<String>? currencyCode,
    Expression<double>? odometerKm,
    Expression<bool>? isFull,
    Expression<String>? stationName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (date != null) 'date': date,
      if (amount != null) 'amount': amount,
      if (totalCost != null) 'total_cost': totalCost,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (odometerKm != null) 'odometer_km': odometerKm,
      if (isFull != null) 'is_full': isFull,
      if (stationName != null) 'station_name': stationName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FillUpsCompanion copyWith({
    Value<String>? id,
    Value<String>? vehicleId,
    Value<DateTime>? date,
    Value<double>? amount,
    Value<double>? totalCost,
    Value<String>? currencyCode,
    Value<double?>? odometerKm,
    Value<bool>? isFull,
    Value<String?>? stationName,
    Value<int>? rowid,
  }) {
    return FillUpsCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      totalCost: totalCost ?? this.totalCost,
      currencyCode: currencyCode ?? this.currencyCode,
      odometerKm: odometerKm ?? this.odometerKm,
      isFull: isFull ?? this.isFull,
      stationName: stationName ?? this.stationName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (totalCost.present) {
      map['total_cost'] = Variable<double>(totalCost.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (odometerKm.present) {
      map['odometer_km'] = Variable<double>(odometerKm.value);
    }
    if (isFull.present) {
      map['is_full'] = Variable<bool>(isFull.value);
    }
    if (stationName.present) {
      map['station_name'] = Variable<String>(stationName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FillUpsCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('totalCost: $totalCost, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('odometerKm: $odometerKm, ')
          ..write('isFull: $isFull, ')
          ..write('stationName: $stationName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlaceLocationsTable extends PlaceLocations
    with TableInfo<$PlaceLocationsTable, PlaceLocationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaceLocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _placeIdMeta = const VerificationMeta(
    'placeId',
  );
  @override
  late final GeneratedColumn<String> placeId = GeneratedColumn<String>(
    'place_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [placeId, lat, lng, fetchedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'place_locations';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlaceLocationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('place_id')) {
      context.handle(
        _placeIdMeta,
        placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_placeIdMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    } else if (isInserting) {
      context.missing(_lngMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {placeId};
  @override
  PlaceLocationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaceLocationRow(
      placeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_id'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      )!,
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $PlaceLocationsTable createAlias(String alias) {
    return $PlaceLocationsTable(attachedDatabase, alias);
  }
}

class PlaceLocationRow extends DataClass
    implements Insertable<PlaceLocationRow> {
  final String placeId;
  final double lat;
  final double lng;
  final DateTime fetchedAt;
  const PlaceLocationRow({
    required this.placeId,
    required this.lat,
    required this.lng,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['place_id'] = Variable<String>(placeId);
    map['lat'] = Variable<double>(lat);
    map['lng'] = Variable<double>(lng);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  PlaceLocationsCompanion toCompanion(bool nullToAbsent) {
    return PlaceLocationsCompanion(
      placeId: Value(placeId),
      lat: Value(lat),
      lng: Value(lng),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory PlaceLocationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaceLocationRow(
      placeId: serializer.fromJson<String>(json['placeId']),
      lat: serializer.fromJson<double>(json['lat']),
      lng: serializer.fromJson<double>(json['lng']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'placeId': serializer.toJson<String>(placeId),
      'lat': serializer.toJson<double>(lat),
      'lng': serializer.toJson<double>(lng),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  PlaceLocationRow copyWith({
    String? placeId,
    double? lat,
    double? lng,
    DateTime? fetchedAt,
  }) => PlaceLocationRow(
    placeId: placeId ?? this.placeId,
    lat: lat ?? this.lat,
    lng: lng ?? this.lng,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  PlaceLocationRow copyWithCompanion(PlaceLocationsCompanion data) {
    return PlaceLocationRow(
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaceLocationRow(')
          ..write('placeId: $placeId, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(placeId, lat, lng, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaceLocationRow &&
          other.placeId == this.placeId &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.fetchedAt == this.fetchedAt);
}

class PlaceLocationsCompanion extends UpdateCompanion<PlaceLocationRow> {
  final Value<String> placeId;
  final Value<double> lat;
  final Value<double> lng;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const PlaceLocationsCompanion({
    this.placeId = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaceLocationsCompanion.insert({
    required String placeId,
    required double lat,
    required double lng,
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  }) : placeId = Value(placeId),
       lat = Value(lat),
       lng = Value(lng),
       fetchedAt = Value(fetchedAt);
  static Insertable<PlaceLocationRow> custom({
    Expression<String>? placeId,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (placeId != null) 'place_id': placeId,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaceLocationsCompanion copyWith({
    Value<String>? placeId,
    Value<double>? lat,
    Value<double>? lng,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return PlaceLocationsCompanion(
      placeId: placeId ?? this.placeId,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (placeId.present) {
      map['place_id'] = Variable<String>(placeId.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaceLocationsCompanion(')
          ..write('placeId: $placeId, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CareRemindersTable extends CareReminders
    with TableInfo<$CareRemindersTable, CareReminderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CareRemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueOdometerKmMeta = const VerificationMeta(
    'dueOdometerKm',
  );
  @override
  late final GeneratedColumn<double> dueOdometerKm = GeneratedColumn<double>(
    'due_odometer_km',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repeatMonthsMeta = const VerificationMeta(
    'repeatMonths',
  );
  @override
  late final GeneratedColumn<int> repeatMonths = GeneratedColumn<int>(
    'repeat_months',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repeatKmMeta = const VerificationMeta(
    'repeatKm',
  );
  @override
  late final GeneratedColumn<double> repeatKm = GeneratedColumn<double>(
    'repeat_km',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastDoneAtMeta = const VerificationMeta(
    'lastDoneAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastDoneAt = GeneratedColumn<DateTime>(
    'last_done_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastDoneKmMeta = const VerificationMeta(
    'lastDoneKm',
  );
  @override
  late final GeneratedColumn<double> lastDoneKm = GeneratedColumn<double>(
    'last_done_km',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notifyDaysBeforeMeta = const VerificationMeta(
    'notifyDaysBefore',
  );
  @override
  late final GeneratedColumn<int> notifyDaysBefore = GeneratedColumn<int>(
    'notify_days_before',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(7),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    type,
    title,
    dueDate,
    dueOdometerKm,
    repeatMonths,
    repeatKm,
    lastDoneAt,
    lastDoneKm,
    notifyDaysBefore,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'care_reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<CareReminderRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('due_odometer_km')) {
      context.handle(
        _dueOdometerKmMeta,
        dueOdometerKm.isAcceptableOrUnknown(
          data['due_odometer_km']!,
          _dueOdometerKmMeta,
        ),
      );
    }
    if (data.containsKey('repeat_months')) {
      context.handle(
        _repeatMonthsMeta,
        repeatMonths.isAcceptableOrUnknown(
          data['repeat_months']!,
          _repeatMonthsMeta,
        ),
      );
    }
    if (data.containsKey('repeat_km')) {
      context.handle(
        _repeatKmMeta,
        repeatKm.isAcceptableOrUnknown(data['repeat_km']!, _repeatKmMeta),
      );
    }
    if (data.containsKey('last_done_at')) {
      context.handle(
        _lastDoneAtMeta,
        lastDoneAt.isAcceptableOrUnknown(
          data['last_done_at']!,
          _lastDoneAtMeta,
        ),
      );
    }
    if (data.containsKey('last_done_km')) {
      context.handle(
        _lastDoneKmMeta,
        lastDoneKm.isAcceptableOrUnknown(
          data['last_done_km']!,
          _lastDoneKmMeta,
        ),
      );
    }
    if (data.containsKey('notify_days_before')) {
      context.handle(
        _notifyDaysBeforeMeta,
        notifyDaysBefore.isAcceptableOrUnknown(
          data['notify_days_before']!,
          _notifyDaysBeforeMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CareReminderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CareReminderRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      dueOdometerKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}due_odometer_km'],
      ),
      repeatMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repeat_months'],
      ),
      repeatKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}repeat_km'],
      ),
      lastDoneAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_done_at'],
      ),
      lastDoneKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}last_done_km'],
      ),
      notifyDaysBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notify_days_before'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CareRemindersTable createAlias(String alias) {
    return $CareRemindersTable(attachedDatabase, alias);
  }
}

class CareReminderRow extends DataClass implements Insertable<CareReminderRow> {
  final String id;
  final String vehicleId;

  /// `CareType.name` (stable across enum reordering).
  final String type;
  final String? title;
  final DateTime? dueDate;
  final double? dueOdometerKm;
  final int? repeatMonths;
  final double? repeatKm;
  final DateTime? lastDoneAt;
  final double? lastDoneKm;
  final int notifyDaysBefore;
  final String? note;
  final DateTime createdAt;
  const CareReminderRow({
    required this.id,
    required this.vehicleId,
    required this.type,
    this.title,
    this.dueDate,
    this.dueOdometerKm,
    this.repeatMonths,
    this.repeatKm,
    this.lastDoneAt,
    this.lastDoneKm,
    required this.notifyDaysBefore,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vehicle_id'] = Variable<String>(vehicleId);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    if (!nullToAbsent || dueOdometerKm != null) {
      map['due_odometer_km'] = Variable<double>(dueOdometerKm);
    }
    if (!nullToAbsent || repeatMonths != null) {
      map['repeat_months'] = Variable<int>(repeatMonths);
    }
    if (!nullToAbsent || repeatKm != null) {
      map['repeat_km'] = Variable<double>(repeatKm);
    }
    if (!nullToAbsent || lastDoneAt != null) {
      map['last_done_at'] = Variable<DateTime>(lastDoneAt);
    }
    if (!nullToAbsent || lastDoneKm != null) {
      map['last_done_km'] = Variable<double>(lastDoneKm);
    }
    map['notify_days_before'] = Variable<int>(notifyDaysBefore);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CareRemindersCompanion toCompanion(bool nullToAbsent) {
    return CareRemindersCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      type: Value(type),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      dueOdometerKm: dueOdometerKm == null && nullToAbsent
          ? const Value.absent()
          : Value(dueOdometerKm),
      repeatMonths: repeatMonths == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatMonths),
      repeatKm: repeatKm == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatKm),
      lastDoneAt: lastDoneAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastDoneAt),
      lastDoneKm: lastDoneKm == null && nullToAbsent
          ? const Value.absent()
          : Value(lastDoneKm),
      notifyDaysBefore: Value(notifyDaysBefore),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory CareReminderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CareReminderRow(
      id: serializer.fromJson<String>(json['id']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String?>(json['title']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      dueOdometerKm: serializer.fromJson<double?>(json['dueOdometerKm']),
      repeatMonths: serializer.fromJson<int?>(json['repeatMonths']),
      repeatKm: serializer.fromJson<double?>(json['repeatKm']),
      lastDoneAt: serializer.fromJson<DateTime?>(json['lastDoneAt']),
      lastDoneKm: serializer.fromJson<double?>(json['lastDoneKm']),
      notifyDaysBefore: serializer.fromJson<int>(json['notifyDaysBefore']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String?>(title),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'dueOdometerKm': serializer.toJson<double?>(dueOdometerKm),
      'repeatMonths': serializer.toJson<int?>(repeatMonths),
      'repeatKm': serializer.toJson<double?>(repeatKm),
      'lastDoneAt': serializer.toJson<DateTime?>(lastDoneAt),
      'lastDoneKm': serializer.toJson<double?>(lastDoneKm),
      'notifyDaysBefore': serializer.toJson<int>(notifyDaysBefore),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CareReminderRow copyWith({
    String? id,
    String? vehicleId,
    String? type,
    Value<String?> title = const Value.absent(),
    Value<DateTime?> dueDate = const Value.absent(),
    Value<double?> dueOdometerKm = const Value.absent(),
    Value<int?> repeatMonths = const Value.absent(),
    Value<double?> repeatKm = const Value.absent(),
    Value<DateTime?> lastDoneAt = const Value.absent(),
    Value<double?> lastDoneKm = const Value.absent(),
    int? notifyDaysBefore,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => CareReminderRow(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    type: type ?? this.type,
    title: title.present ? title.value : this.title,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    dueOdometerKm: dueOdometerKm.present
        ? dueOdometerKm.value
        : this.dueOdometerKm,
    repeatMonths: repeatMonths.present ? repeatMonths.value : this.repeatMonths,
    repeatKm: repeatKm.present ? repeatKm.value : this.repeatKm,
    lastDoneAt: lastDoneAt.present ? lastDoneAt.value : this.lastDoneAt,
    lastDoneKm: lastDoneKm.present ? lastDoneKm.value : this.lastDoneKm,
    notifyDaysBefore: notifyDaysBefore ?? this.notifyDaysBefore,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  CareReminderRow copyWithCompanion(CareRemindersCompanion data) {
    return CareReminderRow(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      dueOdometerKm: data.dueOdometerKm.present
          ? data.dueOdometerKm.value
          : this.dueOdometerKm,
      repeatMonths: data.repeatMonths.present
          ? data.repeatMonths.value
          : this.repeatMonths,
      repeatKm: data.repeatKm.present ? data.repeatKm.value : this.repeatKm,
      lastDoneAt: data.lastDoneAt.present
          ? data.lastDoneAt.value
          : this.lastDoneAt,
      lastDoneKm: data.lastDoneKm.present
          ? data.lastDoneKm.value
          : this.lastDoneKm,
      notifyDaysBefore: data.notifyDaysBefore.present
          ? data.notifyDaysBefore.value
          : this.notifyDaysBefore,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CareReminderRow(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueOdometerKm: $dueOdometerKm, ')
          ..write('repeatMonths: $repeatMonths, ')
          ..write('repeatKm: $repeatKm, ')
          ..write('lastDoneAt: $lastDoneAt, ')
          ..write('lastDoneKm: $lastDoneKm, ')
          ..write('notifyDaysBefore: $notifyDaysBefore, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleId,
    type,
    title,
    dueDate,
    dueOdometerKm,
    repeatMonths,
    repeatKm,
    lastDoneAt,
    lastDoneKm,
    notifyDaysBefore,
    note,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CareReminderRow &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.type == this.type &&
          other.title == this.title &&
          other.dueDate == this.dueDate &&
          other.dueOdometerKm == this.dueOdometerKm &&
          other.repeatMonths == this.repeatMonths &&
          other.repeatKm == this.repeatKm &&
          other.lastDoneAt == this.lastDoneAt &&
          other.lastDoneKm == this.lastDoneKm &&
          other.notifyDaysBefore == this.notifyDaysBefore &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class CareRemindersCompanion extends UpdateCompanion<CareReminderRow> {
  final Value<String> id;
  final Value<String> vehicleId;
  final Value<String> type;
  final Value<String?> title;
  final Value<DateTime?> dueDate;
  final Value<double?> dueOdometerKm;
  final Value<int?> repeatMonths;
  final Value<double?> repeatKm;
  final Value<DateTime?> lastDoneAt;
  final Value<double?> lastDoneKm;
  final Value<int> notifyDaysBefore;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CareRemindersCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueOdometerKm = const Value.absent(),
    this.repeatMonths = const Value.absent(),
    this.repeatKm = const Value.absent(),
    this.lastDoneAt = const Value.absent(),
    this.lastDoneKm = const Value.absent(),
    this.notifyDaysBefore = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CareRemindersCompanion.insert({
    required String id,
    required String vehicleId,
    required String type,
    this.title = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueOdometerKm = const Value.absent(),
    this.repeatMonths = const Value.absent(),
    this.repeatKm = const Value.absent(),
    this.lastDoneAt = const Value.absent(),
    this.lastDoneKm = const Value.absent(),
    this.notifyDaysBefore = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vehicleId = Value(vehicleId),
       type = Value(type),
       createdAt = Value(createdAt);
  static Insertable<CareReminderRow> custom({
    Expression<String>? id,
    Expression<String>? vehicleId,
    Expression<String>? type,
    Expression<String>? title,
    Expression<DateTime>? dueDate,
    Expression<double>? dueOdometerKm,
    Expression<int>? repeatMonths,
    Expression<double>? repeatKm,
    Expression<DateTime>? lastDoneAt,
    Expression<double>? lastDoneKm,
    Expression<int>? notifyDaysBefore,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (dueDate != null) 'due_date': dueDate,
      if (dueOdometerKm != null) 'due_odometer_km': dueOdometerKm,
      if (repeatMonths != null) 'repeat_months': repeatMonths,
      if (repeatKm != null) 'repeat_km': repeatKm,
      if (lastDoneAt != null) 'last_done_at': lastDoneAt,
      if (lastDoneKm != null) 'last_done_km': lastDoneKm,
      if (notifyDaysBefore != null) 'notify_days_before': notifyDaysBefore,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CareRemindersCompanion copyWith({
    Value<String>? id,
    Value<String>? vehicleId,
    Value<String>? type,
    Value<String?>? title,
    Value<DateTime?>? dueDate,
    Value<double?>? dueOdometerKm,
    Value<int?>? repeatMonths,
    Value<double?>? repeatKm,
    Value<DateTime?>? lastDoneAt,
    Value<double?>? lastDoneKm,
    Value<int>? notifyDaysBefore,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CareRemindersCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      type: type ?? this.type,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      dueOdometerKm: dueOdometerKm ?? this.dueOdometerKm,
      repeatMonths: repeatMonths ?? this.repeatMonths,
      repeatKm: repeatKm ?? this.repeatKm,
      lastDoneAt: lastDoneAt ?? this.lastDoneAt,
      lastDoneKm: lastDoneKm ?? this.lastDoneKm,
      notifyDaysBefore: notifyDaysBefore ?? this.notifyDaysBefore,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (dueOdometerKm.present) {
      map['due_odometer_km'] = Variable<double>(dueOdometerKm.value);
    }
    if (repeatMonths.present) {
      map['repeat_months'] = Variable<int>(repeatMonths.value);
    }
    if (repeatKm.present) {
      map['repeat_km'] = Variable<double>(repeatKm.value);
    }
    if (lastDoneAt.present) {
      map['last_done_at'] = Variable<DateTime>(lastDoneAt.value);
    }
    if (lastDoneKm.present) {
      map['last_done_km'] = Variable<double>(lastDoneKm.value);
    }
    if (notifyDaysBefore.present) {
      map['notify_days_before'] = Variable<int>(notifyDaysBefore.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CareRemindersCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueOdometerKm: $dueOdometerKm, ')
          ..write('repeatMonths: $repeatMonths, ')
          ..write('repeatKm: $repeatKm, ')
          ..write('lastDoneAt: $lastDoneAt, ')
          ..write('lastDoneKm: $lastDoneKm, ')
          ..write('notifyDaysBefore: $notifyDaysBefore, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavedTripsTable extends SavedTrips
    with TableInfo<$SavedTripsTable, SavedTripRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedTripsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _placeIdMeta = const VerificationMeta(
    'placeId',
  );
  @override
  late final GeneratedColumn<String> placeId = GeneratedColumn<String>(
    'place_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coordsSavedAtMeta = const VerificationMeta(
    'coordsSavedAt',
  );
  @override
  late final GeneratedColumn<DateTime> coordsSavedAt =
      GeneratedColumn<DateTime>(
        'coords_saved_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastDistanceMetersMeta =
      const VerificationMeta('lastDistanceMeters');
  @override
  late final GeneratedColumn<double> lastDistanceMeters =
      GeneratedColumn<double>(
        'last_distance_meters',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastDurationSecondsMeta =
      const VerificationMeta('lastDurationSeconds');
  @override
  late final GeneratedColumn<double> lastDurationSeconds =
      GeneratedColumn<double>(
        'last_duration_seconds',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastUsedAtMeta = const VerificationMeta(
    'lastUsedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
    'last_used_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    label,
    placeId,
    lat,
    lng,
    coordsSavedAt,
    lastDistanceMeters,
    lastDurationSeconds,
    createdAt,
    lastUsedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_trips';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedTripRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('place_id')) {
      context.handle(
        _placeIdMeta,
        placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta),
      );
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    }
    if (data.containsKey('coords_saved_at')) {
      context.handle(
        _coordsSavedAtMeta,
        coordsSavedAt.isAcceptableOrUnknown(
          data['coords_saved_at']!,
          _coordsSavedAtMeta,
        ),
      );
    }
    if (data.containsKey('last_distance_meters')) {
      context.handle(
        _lastDistanceMetersMeta,
        lastDistanceMeters.isAcceptableOrUnknown(
          data['last_distance_meters']!,
          _lastDistanceMetersMeta,
        ),
      );
    }
    if (data.containsKey('last_duration_seconds')) {
      context.handle(
        _lastDurationSecondsMeta,
        lastDurationSeconds.isAcceptableOrUnknown(
          data['last_duration_seconds']!,
          _lastDurationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
        _lastUsedAtMeta,
        lastUsedAt.isAcceptableOrUnknown(
          data['last_used_at']!,
          _lastUsedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUsedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedTripRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedTripRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      placeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_id'],
      ),
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      ),
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      ),
      coordsSavedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}coords_saved_at'],
      ),
      lastDistanceMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}last_distance_meters'],
      ),
      lastDurationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}last_duration_seconds'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastUsedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_used_at'],
      )!,
    );
  }

  @override
  $SavedTripsTable createAlias(String alias) {
    return $SavedTripsTable(attachedDatabase, alias);
  }
}

class SavedTripRow extends DataClass implements Insertable<SavedTripRow> {
  final String id;
  final String label;
  final String? placeId;
  final double? lat;
  final double? lng;
  final DateTime? coordsSavedAt;
  final double? lastDistanceMeters;
  final double? lastDurationSeconds;
  final DateTime createdAt;
  final DateTime lastUsedAt;
  const SavedTripRow({
    required this.id,
    required this.label,
    this.placeId,
    this.lat,
    this.lng,
    this.coordsSavedAt,
    this.lastDistanceMeters,
    this.lastDurationSeconds,
    required this.createdAt,
    required this.lastUsedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || placeId != null) {
      map['place_id'] = Variable<String>(placeId);
    }
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lng != null) {
      map['lng'] = Variable<double>(lng);
    }
    if (!nullToAbsent || coordsSavedAt != null) {
      map['coords_saved_at'] = Variable<DateTime>(coordsSavedAt);
    }
    if (!nullToAbsent || lastDistanceMeters != null) {
      map['last_distance_meters'] = Variable<double>(lastDistanceMeters);
    }
    if (!nullToAbsent || lastDurationSeconds != null) {
      map['last_duration_seconds'] = Variable<double>(lastDurationSeconds);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    return map;
  }

  SavedTripsCompanion toCompanion(bool nullToAbsent) {
    return SavedTripsCompanion(
      id: Value(id),
      label: Value(label),
      placeId: placeId == null && nullToAbsent
          ? const Value.absent()
          : Value(placeId),
      lat: lat == null && nullToAbsent ? const Value.absent() : Value(lat),
      lng: lng == null && nullToAbsent ? const Value.absent() : Value(lng),
      coordsSavedAt: coordsSavedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(coordsSavedAt),
      lastDistanceMeters: lastDistanceMeters == null && nullToAbsent
          ? const Value.absent()
          : Value(lastDistanceMeters),
      lastDurationSeconds: lastDurationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(lastDurationSeconds),
      createdAt: Value(createdAt),
      lastUsedAt: Value(lastUsedAt),
    );
  }

  factory SavedTripRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedTripRow(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      placeId: serializer.fromJson<String?>(json['placeId']),
      lat: serializer.fromJson<double?>(json['lat']),
      lng: serializer.fromJson<double?>(json['lng']),
      coordsSavedAt: serializer.fromJson<DateTime?>(json['coordsSavedAt']),
      lastDistanceMeters: serializer.fromJson<double?>(
        json['lastDistanceMeters'],
      ),
      lastDurationSeconds: serializer.fromJson<double?>(
        json['lastDurationSeconds'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastUsedAt: serializer.fromJson<DateTime>(json['lastUsedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'placeId': serializer.toJson<String?>(placeId),
      'lat': serializer.toJson<double?>(lat),
      'lng': serializer.toJson<double?>(lng),
      'coordsSavedAt': serializer.toJson<DateTime?>(coordsSavedAt),
      'lastDistanceMeters': serializer.toJson<double?>(lastDistanceMeters),
      'lastDurationSeconds': serializer.toJson<double?>(lastDurationSeconds),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastUsedAt': serializer.toJson<DateTime>(lastUsedAt),
    };
  }

  SavedTripRow copyWith({
    String? id,
    String? label,
    Value<String?> placeId = const Value.absent(),
    Value<double?> lat = const Value.absent(),
    Value<double?> lng = const Value.absent(),
    Value<DateTime?> coordsSavedAt = const Value.absent(),
    Value<double?> lastDistanceMeters = const Value.absent(),
    Value<double?> lastDurationSeconds = const Value.absent(),
    DateTime? createdAt,
    DateTime? lastUsedAt,
  }) => SavedTripRow(
    id: id ?? this.id,
    label: label ?? this.label,
    placeId: placeId.present ? placeId.value : this.placeId,
    lat: lat.present ? lat.value : this.lat,
    lng: lng.present ? lng.value : this.lng,
    coordsSavedAt: coordsSavedAt.present
        ? coordsSavedAt.value
        : this.coordsSavedAt,
    lastDistanceMeters: lastDistanceMeters.present
        ? lastDistanceMeters.value
        : this.lastDistanceMeters,
    lastDurationSeconds: lastDurationSeconds.present
        ? lastDurationSeconds.value
        : this.lastDurationSeconds,
    createdAt: createdAt ?? this.createdAt,
    lastUsedAt: lastUsedAt ?? this.lastUsedAt,
  );
  SavedTripRow copyWithCompanion(SavedTripsCompanion data) {
    return SavedTripRow(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      coordsSavedAt: data.coordsSavedAt.present
          ? data.coordsSavedAt.value
          : this.coordsSavedAt,
      lastDistanceMeters: data.lastDistanceMeters.present
          ? data.lastDistanceMeters.value
          : this.lastDistanceMeters,
      lastDurationSeconds: data.lastDurationSeconds.present
          ? data.lastDurationSeconds.value
          : this.lastDurationSeconds,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastUsedAt: data.lastUsedAt.present
          ? data.lastUsedAt.value
          : this.lastUsedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedTripRow(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('placeId: $placeId, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('coordsSavedAt: $coordsSavedAt, ')
          ..write('lastDistanceMeters: $lastDistanceMeters, ')
          ..write('lastDurationSeconds: $lastDurationSeconds, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUsedAt: $lastUsedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    label,
    placeId,
    lat,
    lng,
    coordsSavedAt,
    lastDistanceMeters,
    lastDurationSeconds,
    createdAt,
    lastUsedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedTripRow &&
          other.id == this.id &&
          other.label == this.label &&
          other.placeId == this.placeId &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.coordsSavedAt == this.coordsSavedAt &&
          other.lastDistanceMeters == this.lastDistanceMeters &&
          other.lastDurationSeconds == this.lastDurationSeconds &&
          other.createdAt == this.createdAt &&
          other.lastUsedAt == this.lastUsedAt);
}

class SavedTripsCompanion extends UpdateCompanion<SavedTripRow> {
  final Value<String> id;
  final Value<String> label;
  final Value<String?> placeId;
  final Value<double?> lat;
  final Value<double?> lng;
  final Value<DateTime?> coordsSavedAt;
  final Value<double?> lastDistanceMeters;
  final Value<double?> lastDurationSeconds;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastUsedAt;
  final Value<int> rowid;
  const SavedTripsCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.placeId = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.coordsSavedAt = const Value.absent(),
    this.lastDistanceMeters = const Value.absent(),
    this.lastDurationSeconds = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavedTripsCompanion.insert({
    required String id,
    required String label,
    this.placeId = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.coordsSavedAt = const Value.absent(),
    this.lastDistanceMeters = const Value.absent(),
    this.lastDurationSeconds = const Value.absent(),
    required DateTime createdAt,
    required DateTime lastUsedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       label = Value(label),
       createdAt = Value(createdAt),
       lastUsedAt = Value(lastUsedAt);
  static Insertable<SavedTripRow> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<String>? placeId,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<DateTime>? coordsSavedAt,
    Expression<double>? lastDistanceMeters,
    Expression<double>? lastDurationSeconds,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastUsedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (placeId != null) 'place_id': placeId,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (coordsSavedAt != null) 'coords_saved_at': coordsSavedAt,
      if (lastDistanceMeters != null)
        'last_distance_meters': lastDistanceMeters,
      if (lastDurationSeconds != null)
        'last_duration_seconds': lastDurationSeconds,
      if (createdAt != null) 'created_at': createdAt,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavedTripsCompanion copyWith({
    Value<String>? id,
    Value<String>? label,
    Value<String?>? placeId,
    Value<double?>? lat,
    Value<double?>? lng,
    Value<DateTime?>? coordsSavedAt,
    Value<double?>? lastDistanceMeters,
    Value<double?>? lastDurationSeconds,
    Value<DateTime>? createdAt,
    Value<DateTime>? lastUsedAt,
    Value<int>? rowid,
  }) {
    return SavedTripsCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      placeId: placeId ?? this.placeId,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      coordsSavedAt: coordsSavedAt ?? this.coordsSavedAt,
      lastDistanceMeters: lastDistanceMeters ?? this.lastDistanceMeters,
      lastDurationSeconds: lastDurationSeconds ?? this.lastDurationSeconds,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (placeId.present) {
      map['place_id'] = Variable<String>(placeId.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (coordsSavedAt.present) {
      map['coords_saved_at'] = Variable<DateTime>(coordsSavedAt.value);
    }
    if (lastDistanceMeters.present) {
      map['last_distance_meters'] = Variable<double>(lastDistanceMeters.value);
    }
    if (lastDurationSeconds.present) {
      map['last_duration_seconds'] = Variable<double>(
        lastDurationSeconds.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedTripsCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('placeId: $placeId, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('coordsSavedAt: $coordsSavedAt, ')
          ..write('lastDistanceMeters: $lastDistanceMeters, ')
          ..write('lastDurationSeconds: $lastDurationSeconds, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VehiclesTable vehicles = $VehiclesTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $FillUpsTable fillUps = $FillUpsTable(this);
  late final $PlaceLocationsTable placeLocations = $PlaceLocationsTable(this);
  late final $CareRemindersTable careReminders = $CareRemindersTable(this);
  late final $SavedTripsTable savedTrips = $SavedTripsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    vehicles,
    settings,
    fillUps,
    placeLocations,
    careReminders,
    savedTrips,
  ];
}

typedef $$VehiclesTableCreateCompanionBuilder = VehiclesCompanion Function({
  required String id,
  required String name,
  required int energyType,
  required double consumptionPer100Km,
  required double capacity,
  Value<String?> preferredFuelType,
  Value<double> chargingEfficiency,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$VehiclesTableUpdateCompanionBuilder = VehiclesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> energyType,
  Value<double> consumptionPer100Km,
  Value<double> capacity,
  Value<String?> preferredFuelType,
  Value<double> chargingEfficiency,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$VehiclesTableFilterComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get energyType => $composableBuilder(
    column: $table.energyType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get consumptionPer100Km => $composableBuilder(
    column: $table.consumptionPer100Km,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get capacity => $composableBuilder(
    column: $table.capacity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredFuelType => $composableBuilder(
    column: $table.preferredFuelType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get chargingEfficiency => $composableBuilder(
    column: $table.chargingEfficiency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VehiclesTableOrderingComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get energyType => $composableBuilder(
    column: $table.energyType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get consumptionPer100Km => $composableBuilder(
    column: $table.consumptionPer100Km,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get capacity => $composableBuilder(
    column: $table.capacity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredFuelType => $composableBuilder(
    column: $table.preferredFuelType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get chargingEfficiency => $composableBuilder(
    column: $table.chargingEfficiency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VehiclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get energyType => $composableBuilder(
    column: $table.energyType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get consumptionPer100Km => $composableBuilder(
    column: $table.consumptionPer100Km,
    builder: (column) => column,
  );

  GeneratedColumn<double> get capacity =>
      $composableBuilder(column: $table.capacity, builder: (column) => column);

  GeneratedColumn<String> get preferredFuelType => $composableBuilder(
    column: $table.preferredFuelType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get chargingEfficiency => $composableBuilder(
    column: $table.chargingEfficiency,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$VehiclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VehiclesTable,
          Vehicle,
          $$VehiclesTableFilterComposer,
          $$VehiclesTableOrderingComposer,
          $$VehiclesTableAnnotationComposer,
          $$VehiclesTableCreateCompanionBuilder,
          $$VehiclesTableUpdateCompanionBuilder,
          (Vehicle, BaseReferences<_$AppDatabase, $VehiclesTable, Vehicle>),
          Vehicle,
          PrefetchHooks Function()
        > {
  $$VehiclesTableTableManager(_$AppDatabase db, $VehiclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehiclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehiclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehiclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> energyType = const Value.absent(),
                Value<double> consumptionPer100Km = const Value.absent(),
                Value<double> capacity = const Value.absent(),
                Value<String?> preferredFuelType = const Value.absent(),
                Value<double> chargingEfficiency = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VehiclesCompanion(
                id: id,
                name: name,
                energyType: energyType,
                consumptionPer100Km: consumptionPer100Km,
                capacity: capacity,
                preferredFuelType: preferredFuelType,
                chargingEfficiency: chargingEfficiency,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int energyType,
                required double consumptionPer100Km,
                required double capacity,
                Value<String?> preferredFuelType = const Value.absent(),
                Value<double> chargingEfficiency = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => VehiclesCompanion.insert(
                id: id,
                name: name,
                energyType: energyType,
                consumptionPer100Km: consumptionPer100Km,
                capacity: capacity,
                preferredFuelType: preferredFuelType,
                chargingEfficiency: chargingEfficiency,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VehiclesTable, Vehicle>(table),
                  BaseReferences<_$AppDatabase, $VehiclesTable, Vehicle>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VehiclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VehiclesTable,
      Vehicle,
      $$VehiclesTableFilterComposer,
      $$VehiclesTableOrderingComposer,
      $$VehiclesTableAnnotationComposer,
      $$VehiclesTableCreateCompanionBuilder,
      $$VehiclesTableUpdateCompanionBuilder,
      (Vehicle, BaseReferences<_$AppDatabase, $VehiclesTable, Vehicle>),
      Vehicle,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, Setting>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, Setting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$FillUpsTableCreateCompanionBuilder = FillUpsCompanion Function({
  required String id,
  required String vehicleId,
  required DateTime date,
  required double amount,
  required double totalCost,
  required String currencyCode,
  Value<double?> odometerKm,
  Value<bool> isFull,
  Value<String?> stationName,
  Value<int> rowid,
});
typedef $$FillUpsTableUpdateCompanionBuilder = FillUpsCompanion Function({
  Value<String> id,
  Value<String> vehicleId,
  Value<DateTime> date,
  Value<double> amount,
  Value<double> totalCost,
  Value<String> currencyCode,
  Value<double?> odometerKm,
  Value<bool> isFull,
  Value<String?> stationName,
  Value<int> rowid,
});

class $$FillUpsTableFilterComposer
    extends Composer<_$AppDatabase, $FillUpsTable> {
  $$FillUpsTableFilterComposer({
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

  ColumnFilters<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalCost => $composableBuilder(
    column: $table.totalCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get odometerKm => $composableBuilder(
    column: $table.odometerKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFull => $composableBuilder(
    column: $table.isFull,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stationName => $composableBuilder(
    column: $table.stationName,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FillUpsTableOrderingComposer
    extends Composer<_$AppDatabase, $FillUpsTable> {
  $$FillUpsTableOrderingComposer({
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

  ColumnOrderings<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalCost => $composableBuilder(
    column: $table.totalCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get odometerKm => $composableBuilder(
    column: $table.odometerKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFull => $composableBuilder(
    column: $table.isFull,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stationName => $composableBuilder(
    column: $table.stationName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FillUpsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FillUpsTable> {
  $$FillUpsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get vehicleId =>
      $composableBuilder(column: $table.vehicleId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get totalCost =>
      $composableBuilder(column: $table.totalCost, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<double> get odometerKm => $composableBuilder(
    column: $table.odometerKm,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFull =>
      $composableBuilder(column: $table.isFull, builder: (column) => column);

  GeneratedColumn<String> get stationName => $composableBuilder(
    column: $table.stationName,
    builder: (column) => column,
  );
}

class $$FillUpsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FillUpsTable,
          FillUpRow,
          $$FillUpsTableFilterComposer,
          $$FillUpsTableOrderingComposer,
          $$FillUpsTableAnnotationComposer,
          $$FillUpsTableCreateCompanionBuilder,
          $$FillUpsTableUpdateCompanionBuilder,
          (FillUpRow, BaseReferences<_$AppDatabase, $FillUpsTable, FillUpRow>),
          FillUpRow,
          PrefetchHooks Function()
        > {
  $$FillUpsTableTableManager(_$AppDatabase db, $FillUpsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FillUpsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FillUpsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FillUpsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vehicleId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<double> totalCost = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<double?> odometerKm = const Value.absent(),
                Value<bool> isFull = const Value.absent(),
                Value<String?> stationName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FillUpsCompanion(
                id: id,
                vehicleId: vehicleId,
                date: date,
                amount: amount,
                totalCost: totalCost,
                currencyCode: currencyCode,
                odometerKm: odometerKm,
                isFull: isFull,
                stationName: stationName,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vehicleId,
                required DateTime date,
                required double amount,
                required double totalCost,
                required String currencyCode,
                Value<double?> odometerKm = const Value.absent(),
                Value<bool> isFull = const Value.absent(),
                Value<String?> stationName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FillUpsCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                date: date,
                amount: amount,
                totalCost: totalCost,
                currencyCode: currencyCode,
                odometerKm: odometerKm,
                isFull: isFull,
                stationName: stationName,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FillUpsTable, FillUpRow>(table),
                  BaseReferences<_$AppDatabase, $FillUpsTable, FillUpRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FillUpsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FillUpsTable,
      FillUpRow,
      $$FillUpsTableFilterComposer,
      $$FillUpsTableOrderingComposer,
      $$FillUpsTableAnnotationComposer,
      $$FillUpsTableCreateCompanionBuilder,
      $$FillUpsTableUpdateCompanionBuilder,
      (FillUpRow, BaseReferences<_$AppDatabase, $FillUpsTable, FillUpRow>),
      FillUpRow,
      PrefetchHooks Function()
    >;
typedef $$PlaceLocationsTableCreateCompanionBuilder =
    PlaceLocationsCompanion Function({
      required String placeId,
      required double lat,
      required double lng,
      required DateTime fetchedAt,
      Value<int> rowid,
    });
typedef $$PlaceLocationsTableUpdateCompanionBuilder =
    PlaceLocationsCompanion Function({
      Value<String> placeId,
      Value<double> lat,
      Value<double> lng,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });

class $$PlaceLocationsTableFilterComposer
    extends Composer<_$AppDatabase, $PlaceLocationsTable> {
  $$PlaceLocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get placeId => $composableBuilder(
    column: $table.placeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlaceLocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaceLocationsTable> {
  $$PlaceLocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get placeId => $composableBuilder(
    column: $table.placeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlaceLocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaceLocationsTable> {
  $$PlaceLocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get placeId =>
      $composableBuilder(column: $table.placeId, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$PlaceLocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaceLocationsTable,
          PlaceLocationRow,
          $$PlaceLocationsTableFilterComposer,
          $$PlaceLocationsTableOrderingComposer,
          $$PlaceLocationsTableAnnotationComposer,
          $$PlaceLocationsTableCreateCompanionBuilder,
          $$PlaceLocationsTableUpdateCompanionBuilder,
          (
            PlaceLocationRow,
            BaseReferences<
              _$AppDatabase,
              $PlaceLocationsTable,
              PlaceLocationRow
            >,
          ),
          PlaceLocationRow,
          PrefetchHooks Function()
        > {
  $$PlaceLocationsTableTableManager(
    _$AppDatabase db,
    $PlaceLocationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaceLocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaceLocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaceLocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> placeId = const Value.absent(),
                Value<double> lat = const Value.absent(),
                Value<double> lng = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaceLocationsCompanion(
                placeId: placeId,
                lat: lat,
                lng: lng,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String placeId,
                required double lat,
                required double lng,
                required DateTime fetchedAt,
                Value<int> rowid = const Value.absent(),
              }) => PlaceLocationsCompanion.insert(
                placeId: placeId,
                lat: lat,
                lng: lng,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlaceLocationsTable, PlaceLocationRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PlaceLocationsTable,
                    PlaceLocationRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlaceLocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaceLocationsTable,
      PlaceLocationRow,
      $$PlaceLocationsTableFilterComposer,
      $$PlaceLocationsTableOrderingComposer,
      $$PlaceLocationsTableAnnotationComposer,
      $$PlaceLocationsTableCreateCompanionBuilder,
      $$PlaceLocationsTableUpdateCompanionBuilder,
      (
        PlaceLocationRow,
        BaseReferences<_$AppDatabase, $PlaceLocationsTable, PlaceLocationRow>,
      ),
      PlaceLocationRow,
      PrefetchHooks Function()
    >;
typedef $$CareRemindersTableCreateCompanionBuilder =
    CareRemindersCompanion Function({
      required String id,
      required String vehicleId,
      required String type,
      Value<String?> title,
      Value<DateTime?> dueDate,
      Value<double?> dueOdometerKm,
      Value<int?> repeatMonths,
      Value<double?> repeatKm,
      Value<DateTime?> lastDoneAt,
      Value<double?> lastDoneKm,
      Value<int> notifyDaysBefore,
      Value<String?> note,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$CareRemindersTableUpdateCompanionBuilder =
    CareRemindersCompanion Function({
      Value<String> id,
      Value<String> vehicleId,
      Value<String> type,
      Value<String?> title,
      Value<DateTime?> dueDate,
      Value<double?> dueOdometerKm,
      Value<int?> repeatMonths,
      Value<double?> repeatKm,
      Value<DateTime?> lastDoneAt,
      Value<double?> lastDoneKm,
      Value<int> notifyDaysBefore,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$CareRemindersTableFilterComposer
    extends Composer<_$AppDatabase, $CareRemindersTable> {
  $$CareRemindersTableFilterComposer({
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

  ColumnFilters<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get dueOdometerKm => $composableBuilder(
    column: $table.dueOdometerKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repeatMonths => $composableBuilder(
    column: $table.repeatMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get repeatKm => $composableBuilder(
    column: $table.repeatKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastDoneAt => $composableBuilder(
    column: $table.lastDoneAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lastDoneKm => $composableBuilder(
    column: $table.lastDoneKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notifyDaysBefore => $composableBuilder(
    column: $table.notifyDaysBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CareRemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $CareRemindersTable> {
  $$CareRemindersTableOrderingComposer({
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

  ColumnOrderings<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get dueOdometerKm => $composableBuilder(
    column: $table.dueOdometerKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repeatMonths => $composableBuilder(
    column: $table.repeatMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get repeatKm => $composableBuilder(
    column: $table.repeatKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastDoneAt => $composableBuilder(
    column: $table.lastDoneAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lastDoneKm => $composableBuilder(
    column: $table.lastDoneKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notifyDaysBefore => $composableBuilder(
    column: $table.notifyDaysBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CareRemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CareRemindersTable> {
  $$CareRemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get vehicleId =>
      $composableBuilder(column: $table.vehicleId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<double> get dueOdometerKm => $composableBuilder(
    column: $table.dueOdometerKm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repeatMonths => $composableBuilder(
    column: $table.repeatMonths,
    builder: (column) => column,
  );

  GeneratedColumn<double> get repeatKm =>
      $composableBuilder(column: $table.repeatKm, builder: (column) => column);

  GeneratedColumn<DateTime> get lastDoneAt => $composableBuilder(
    column: $table.lastDoneAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lastDoneKm => $composableBuilder(
    column: $table.lastDoneKm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get notifyDaysBefore => $composableBuilder(
    column: $table.notifyDaysBefore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CareRemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CareRemindersTable,
          CareReminderRow,
          $$CareRemindersTableFilterComposer,
          $$CareRemindersTableOrderingComposer,
          $$CareRemindersTableAnnotationComposer,
          $$CareRemindersTableCreateCompanionBuilder,
          $$CareRemindersTableUpdateCompanionBuilder,
          (
            CareReminderRow,
            BaseReferences<_$AppDatabase, $CareRemindersTable, CareReminderRow>,
          ),
          CareReminderRow,
          PrefetchHooks Function()
        > {
  $$CareRemindersTableTableManager(_$AppDatabase db, $CareRemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CareRemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CareRemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CareRemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vehicleId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<double?> dueOdometerKm = const Value.absent(),
                Value<int?> repeatMonths = const Value.absent(),
                Value<double?> repeatKm = const Value.absent(),
                Value<DateTime?> lastDoneAt = const Value.absent(),
                Value<double?> lastDoneKm = const Value.absent(),
                Value<int> notifyDaysBefore = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CareRemindersCompanion(
                id: id,
                vehicleId: vehicleId,
                type: type,
                title: title,
                dueDate: dueDate,
                dueOdometerKm: dueOdometerKm,
                repeatMonths: repeatMonths,
                repeatKm: repeatKm,
                lastDoneAt: lastDoneAt,
                lastDoneKm: lastDoneKm,
                notifyDaysBefore: notifyDaysBefore,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vehicleId,
                required String type,
                Value<String?> title = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<double?> dueOdometerKm = const Value.absent(),
                Value<int?> repeatMonths = const Value.absent(),
                Value<double?> repeatKm = const Value.absent(),
                Value<DateTime?> lastDoneAt = const Value.absent(),
                Value<double?> lastDoneKm = const Value.absent(),
                Value<int> notifyDaysBefore = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CareRemindersCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                type: type,
                title: title,
                dueDate: dueDate,
                dueOdometerKm: dueOdometerKm,
                repeatMonths: repeatMonths,
                repeatKm: repeatKm,
                lastDoneAt: lastDoneAt,
                lastDoneKm: lastDoneKm,
                notifyDaysBefore: notifyDaysBefore,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CareRemindersTable, CareReminderRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CareRemindersTable,
                    CareReminderRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CareRemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CareRemindersTable,
      CareReminderRow,
      $$CareRemindersTableFilterComposer,
      $$CareRemindersTableOrderingComposer,
      $$CareRemindersTableAnnotationComposer,
      $$CareRemindersTableCreateCompanionBuilder,
      $$CareRemindersTableUpdateCompanionBuilder,
      (
        CareReminderRow,
        BaseReferences<_$AppDatabase, $CareRemindersTable, CareReminderRow>,
      ),
      CareReminderRow,
      PrefetchHooks Function()
    >;
typedef $$SavedTripsTableCreateCompanionBuilder = SavedTripsCompanion Function({
  required String id,
  required String label,
  Value<String?> placeId,
  Value<double?> lat,
  Value<double?> lng,
  Value<DateTime?> coordsSavedAt,
  Value<double?> lastDistanceMeters,
  Value<double?> lastDurationSeconds,
  required DateTime createdAt,
  required DateTime lastUsedAt,
  Value<int> rowid,
});
typedef $$SavedTripsTableUpdateCompanionBuilder = SavedTripsCompanion Function({
  Value<String> id,
  Value<String> label,
  Value<String?> placeId,
  Value<double?> lat,
  Value<double?> lng,
  Value<DateTime?> coordsSavedAt,
  Value<double?> lastDistanceMeters,
  Value<double?> lastDurationSeconds,
  Value<DateTime> createdAt,
  Value<DateTime> lastUsedAt,
  Value<int> rowid,
});

class $$SavedTripsTableFilterComposer
    extends Composer<_$AppDatabase, $SavedTripsTable> {
  $$SavedTripsTableFilterComposer({
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

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placeId => $composableBuilder(
    column: $table.placeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get coordsSavedAt => $composableBuilder(
    column: $table.coordsSavedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lastDistanceMeters => $composableBuilder(
    column: $table.lastDistanceMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lastDurationSeconds => $composableBuilder(
    column: $table.lastDurationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavedTripsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedTripsTable> {
  $$SavedTripsTableOrderingComposer({
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

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placeId => $composableBuilder(
    column: $table.placeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get coordsSavedAt => $composableBuilder(
    column: $table.coordsSavedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lastDistanceMeters => $composableBuilder(
    column: $table.lastDistanceMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lastDurationSeconds => $composableBuilder(
    column: $table.lastDurationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavedTripsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedTripsTable> {
  $$SavedTripsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get placeId =>
      $composableBuilder(column: $table.placeId, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<DateTime> get coordsSavedAt => $composableBuilder(
    column: $table.coordsSavedAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lastDistanceMeters => $composableBuilder(
    column: $table.lastDistanceMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lastDurationSeconds => $composableBuilder(
    column: $table.lastDurationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => column,
  );
}

class $$SavedTripsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavedTripsTable,
          SavedTripRow,
          $$SavedTripsTableFilterComposer,
          $$SavedTripsTableOrderingComposer,
          $$SavedTripsTableAnnotationComposer,
          $$SavedTripsTableCreateCompanionBuilder,
          $$SavedTripsTableUpdateCompanionBuilder,
          (
            SavedTripRow,
            BaseReferences<_$AppDatabase, $SavedTripsTable, SavedTripRow>,
          ),
          SavedTripRow,
          PrefetchHooks Function()
        > {
  $$SavedTripsTableTableManager(_$AppDatabase db, $SavedTripsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedTripsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedTripsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedTripsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String?> placeId = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<DateTime?> coordsSavedAt = const Value.absent(),
                Value<double?> lastDistanceMeters = const Value.absent(),
                Value<double?> lastDurationSeconds = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastUsedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedTripsCompanion(
                id: id,
                label: label,
                placeId: placeId,
                lat: lat,
                lng: lng,
                coordsSavedAt: coordsSavedAt,
                lastDistanceMeters: lastDistanceMeters,
                lastDurationSeconds: lastDurationSeconds,
                createdAt: createdAt,
                lastUsedAt: lastUsedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String label,
                Value<String?> placeId = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<DateTime?> coordsSavedAt = const Value.absent(),
                Value<double?> lastDistanceMeters = const Value.absent(),
                Value<double?> lastDurationSeconds = const Value.absent(),
                required DateTime createdAt,
                required DateTime lastUsedAt,
                Value<int> rowid = const Value.absent(),
              }) => SavedTripsCompanion.insert(
                id: id,
                label: label,
                placeId: placeId,
                lat: lat,
                lng: lng,
                coordsSavedAt: coordsSavedAt,
                lastDistanceMeters: lastDistanceMeters,
                lastDurationSeconds: lastDurationSeconds,
                createdAt: createdAt,
                lastUsedAt: lastUsedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SavedTripsTable, SavedTripRow>(table),
                  BaseReferences<_$AppDatabase, $SavedTripsTable, SavedTripRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavedTripsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavedTripsTable,
      SavedTripRow,
      $$SavedTripsTableFilterComposer,
      $$SavedTripsTableOrderingComposer,
      $$SavedTripsTableAnnotationComposer,
      $$SavedTripsTableCreateCompanionBuilder,
      $$SavedTripsTableUpdateCompanionBuilder,
      (
        SavedTripRow,
        BaseReferences<_$AppDatabase, $SavedTripsTable, SavedTripRow>,
      ),
      SavedTripRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db, _db.vehicles);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$FillUpsTableTableManager get fillUps =>
      $$FillUpsTableTableManager(_db, _db.fillUps);
  $$PlaceLocationsTableTableManager get placeLocations =>
      $$PlaceLocationsTableTableManager(_db, _db.placeLocations);
  $$CareRemindersTableTableManager get careReminders =>
      $$CareRemindersTableTableManager(_db, _db.careReminders);
  $$SavedTripsTableTableManager get savedTrips =>
      $$SavedTripsTableTableManager(_db, _db.savedTrips);
}
