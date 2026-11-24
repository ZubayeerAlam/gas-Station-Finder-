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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VehiclesTable vehicles = $VehiclesTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $FillUpsTable fillUps = $FillUpsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    vehicles,
    settings,
    fillUps,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db, _db.vehicles);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$FillUpsTableTableManager get fillUps =>
      $$FillUpsTableTableManager(_db, _db.fillUps);
}
