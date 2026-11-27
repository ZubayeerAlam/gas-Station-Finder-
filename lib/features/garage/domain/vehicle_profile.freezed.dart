// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VehicleProfile {

 String get id; String get name; EnergyType get energyType; double get consumptionPer100Km; double get capacity;/// Places fuel type code this vehicle uses, e.g. `DIESEL`, `REGULAR_UNLEADED`.
/// Null for EVs.
 String? get preferredFuelType;/// Share of bought energy that reaches the battery (charging losses).
/// Defaults to 1.0 (no assumption); set e.g. 0.9 if the user knows it.
 double get chargingEfficiency;/// Dual-fuel vehicles (e.g. petrol converted to CNG): the second fuel's
/// Places code. Null for single-fuel vehicles and EVs.
 String? get secondaryFuelType;/// Consumption on [secondaryFuelType], per 100 km in that fuel's purchase
/// unit (m³ for CNG, L otherwise). See `purchaseUnitForFuel`.
 double? get secondaryConsumptionPer100Km;
/// Create a copy of VehicleProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleProfileCopyWith<VehicleProfile> get copyWith => _$VehicleProfileCopyWithImpl<VehicleProfile>(this as VehicleProfile, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as VehicleProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleProfile&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.energyType, _this.energyType) || other.energyType == _this.energyType)&&(identical(other.consumptionPer100Km, _this.consumptionPer100Km) || other.consumptionPer100Km == _this.consumptionPer100Km)&&(identical(other.capacity, _this.capacity) || other.capacity == _this.capacity)&&(identical(other.preferredFuelType, _this.preferredFuelType) || other.preferredFuelType == _this.preferredFuelType)&&(identical(other.chargingEfficiency, _this.chargingEfficiency) || other.chargingEfficiency == _this.chargingEfficiency)&&(identical(other.secondaryFuelType, _this.secondaryFuelType) || other.secondaryFuelType == _this.secondaryFuelType)&&(identical(other.secondaryConsumptionPer100Km, _this.secondaryConsumptionPer100Km) || other.secondaryConsumptionPer100Km == _this.secondaryConsumptionPer100Km));
}


@override
int get hashCode {
  final _this = this as VehicleProfile;
  return Object.hash(runtimeType,_this.id,_this.name,_this.energyType,_this.consumptionPer100Km,_this.capacity,_this.preferredFuelType,_this.chargingEfficiency,_this.secondaryFuelType,_this.secondaryConsumptionPer100Km);
}

@override
String toString() {
  final _this = this as VehicleProfile;
  return 'VehicleProfile(id: ${_this.id}, name: ${_this.name}, energyType: ${_this.energyType}, consumptionPer100Km: ${_this.consumptionPer100Km}, capacity: ${_this.capacity}, preferredFuelType: ${_this.preferredFuelType}, chargingEfficiency: ${_this.chargingEfficiency}, secondaryFuelType: ${_this.secondaryFuelType}, secondaryConsumptionPer100Km: ${_this.secondaryConsumptionPer100Km})';
}


}

/// @nodoc
abstract mixin class $VehicleProfileCopyWith<$Res>  {
  factory $VehicleProfileCopyWith(VehicleProfile value, $Res Function(VehicleProfile) _then) = _$VehicleProfileCopyWithImpl;
@useResult
$Res call({
 String id, String name, EnergyType energyType, double consumptionPer100Km, double capacity, String? preferredFuelType, double chargingEfficiency, String? secondaryFuelType, double? secondaryConsumptionPer100Km
});




}
/// @nodoc
class _$VehicleProfileCopyWithImpl<$Res>
    implements $VehicleProfileCopyWith<$Res> {
  _$VehicleProfileCopyWithImpl(this._self, this._then);

  final VehicleProfile _self;
  final $Res Function(VehicleProfile) _then;

/// Create a copy of VehicleProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? energyType = null,Object? consumptionPer100Km = null,Object? capacity = null,Object? preferredFuelType = freezed,Object? chargingEfficiency = null,Object? secondaryFuelType = freezed,Object? secondaryConsumptionPer100Km = freezed,}) {
  return _then(VehicleProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,energyType: null == energyType ? _self.energyType : energyType // ignore: cast_nullable_to_non_nullable
as EnergyType,consumptionPer100Km: null == consumptionPer100Km ? _self.consumptionPer100Km : consumptionPer100Km // ignore: cast_nullable_to_non_nullable
as double,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as double,preferredFuelType: freezed == preferredFuelType ? _self.preferredFuelType : preferredFuelType // ignore: cast_nullable_to_non_nullable
as String?,chargingEfficiency: null == chargingEfficiency ? _self.chargingEfficiency : chargingEfficiency // ignore: cast_nullable_to_non_nullable
as double,secondaryFuelType: freezed == secondaryFuelType ? _self.secondaryFuelType : secondaryFuelType // ignore: cast_nullable_to_non_nullable
as String?,secondaryConsumptionPer100Km: freezed == secondaryConsumptionPer100Km ? _self.secondaryConsumptionPer100Km : secondaryConsumptionPer100Km // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [VehicleProfile].
extension VehicleProfilePatterns on VehicleProfile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VehicleProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VehicleProfile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VehicleProfile value)  $default,){
final _that = this;
switch (_that) {
case _VehicleProfile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VehicleProfile value)?  $default,){
final _that = this;
switch (_that) {
case _VehicleProfile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  EnergyType energyType,  double consumptionPer100Km,  double capacity,  String? preferredFuelType,  double chargingEfficiency,  String? secondaryFuelType,  double? secondaryConsumptionPer100Km)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VehicleProfile() when $default != null:
return $default(_that.id,_that.name,_that.energyType,_that.consumptionPer100Km,_that.capacity,_that.preferredFuelType,_that.chargingEfficiency,_that.secondaryFuelType,_that.secondaryConsumptionPer100Km);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  EnergyType energyType,  double consumptionPer100Km,  double capacity,  String? preferredFuelType,  double chargingEfficiency,  String? secondaryFuelType,  double? secondaryConsumptionPer100Km)  $default,) {final _that = this;
switch (_that) {
case _VehicleProfile():
return $default(_that.id,_that.name,_that.energyType,_that.consumptionPer100Km,_that.capacity,_that.preferredFuelType,_that.chargingEfficiency,_that.secondaryFuelType,_that.secondaryConsumptionPer100Km);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  EnergyType energyType,  double consumptionPer100Km,  double capacity,  String? preferredFuelType,  double chargingEfficiency,  String? secondaryFuelType,  double? secondaryConsumptionPer100Km)?  $default,) {final _that = this;
switch (_that) {
case _VehicleProfile() when $default != null:
return $default(_that.id,_that.name,_that.energyType,_that.consumptionPer100Km,_that.capacity,_that.preferredFuelType,_that.chargingEfficiency,_that.secondaryFuelType,_that.secondaryConsumptionPer100Km);case _:
  return null;

}
}

}

/// @nodoc


class _VehicleProfile extends VehicleProfile {
  const _VehicleProfile({required this.id, required this.name, required this.energyType, required this.consumptionPer100Km, required this.capacity, this.preferredFuelType, this.chargingEfficiency = 1.0, this.secondaryFuelType, this.secondaryConsumptionPer100Km}): assert(consumptionPer100Km > 0, 'consumption must be positive'),assert(capacity > 0, 'capacity must be positive'),assert(chargingEfficiency > 0 && chargingEfficiency <= 1, 'efficiency must be in (0, 1]'),assert(secondaryConsumptionPer100Km == null || secondaryConsumptionPer100Km > 0, 'secondary consumption must be positive'),super._();
  

@override final  String id;
@override final  String name;
@override final  EnergyType energyType;
@override final  double consumptionPer100Km;
@override final  double capacity;
/// Places fuel type code this vehicle uses, e.g. `DIESEL`, `REGULAR_UNLEADED`.
/// Null for EVs.
@override final  String? preferredFuelType;
/// Share of bought energy that reaches the battery (charging losses).
/// Defaults to 1.0 (no assumption); set e.g. 0.9 if the user knows it.
@override@JsonKey() final  double chargingEfficiency;
/// Dual-fuel vehicles (e.g. petrol converted to CNG): the second fuel's
/// Places code. Null for single-fuel vehicles and EVs.
@override final  String? secondaryFuelType;
/// Consumption on [secondaryFuelType], per 100 km in that fuel's purchase
/// unit (m³ for CNG, L otherwise). See `purchaseUnitForFuel`.
@override final  double? secondaryConsumptionPer100Km;

/// Create a copy of VehicleProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VehicleProfileCopyWith<_VehicleProfile> get copyWith => __$VehicleProfileCopyWithImpl<_VehicleProfile>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VehicleProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.energyType, energyType) || other.energyType == energyType)&&(identical(other.consumptionPer100Km, consumptionPer100Km) || other.consumptionPer100Km == consumptionPer100Km)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.preferredFuelType, preferredFuelType) || other.preferredFuelType == preferredFuelType)&&(identical(other.chargingEfficiency, chargingEfficiency) || other.chargingEfficiency == chargingEfficiency)&&(identical(other.secondaryFuelType, secondaryFuelType) || other.secondaryFuelType == secondaryFuelType)&&(identical(other.secondaryConsumptionPer100Km, secondaryConsumptionPer100Km) || other.secondaryConsumptionPer100Km == secondaryConsumptionPer100Km));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,energyType,consumptionPer100Km,capacity,preferredFuelType,chargingEfficiency,secondaryFuelType,secondaryConsumptionPer100Km);
}

@override
String toString() {
    return 'VehicleProfile(id: $id, name: $name, energyType: $energyType, consumptionPer100Km: $consumptionPer100Km, capacity: $capacity, preferredFuelType: $preferredFuelType, chargingEfficiency: $chargingEfficiency, secondaryFuelType: $secondaryFuelType, secondaryConsumptionPer100Km: $secondaryConsumptionPer100Km)';
}


}

/// @nodoc
abstract mixin class _$VehicleProfileCopyWith<$Res> implements $VehicleProfileCopyWith<$Res> {
  factory _$VehicleProfileCopyWith(_VehicleProfile value, $Res Function(_VehicleProfile) _then) = __$VehicleProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, EnergyType energyType, double consumptionPer100Km, double capacity, String? preferredFuelType, double chargingEfficiency, String? secondaryFuelType, double? secondaryConsumptionPer100Km
});




}
/// @nodoc
class __$VehicleProfileCopyWithImpl<$Res>
    implements _$VehicleProfileCopyWith<$Res> {
  __$VehicleProfileCopyWithImpl(this._self, this._then);

  final _VehicleProfile _self;
  final $Res Function(_VehicleProfile) _then;

/// Create a copy of VehicleProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? energyType = null,Object? consumptionPer100Km = null,Object? capacity = null,Object? preferredFuelType = freezed,Object? chargingEfficiency = null,Object? secondaryFuelType = freezed,Object? secondaryConsumptionPer100Km = freezed,}) {
  return _then(_VehicleProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,energyType: null == energyType ? _self.energyType : energyType // ignore: cast_nullable_to_non_nullable
as EnergyType,consumptionPer100Km: null == consumptionPer100Km ? _self.consumptionPer100Km : consumptionPer100Km // ignore: cast_nullable_to_non_nullable
as double,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as double,preferredFuelType: freezed == preferredFuelType ? _self.preferredFuelType : preferredFuelType // ignore: cast_nullable_to_non_nullable
as String?,chargingEfficiency: null == chargingEfficiency ? _self.chargingEfficiency : chargingEfficiency // ignore: cast_nullable_to_non_nullable
as double,secondaryFuelType: freezed == secondaryFuelType ? _self.secondaryFuelType : secondaryFuelType // ignore: cast_nullable_to_non_nullable
as String?,secondaryConsumptionPer100Km: freezed == secondaryConsumptionPer100Km ? _self.secondaryConsumptionPer100Km : secondaryConsumptionPer100Km // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
