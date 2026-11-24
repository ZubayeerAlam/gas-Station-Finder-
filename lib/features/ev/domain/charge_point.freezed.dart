// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'charge_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChargePoint {

 String get id; String get name; GeoPoint get location; String? get address; String? get operatorName; List<ChargeConnector> get connectors; int? get numberOfPoints;/// Null = status unknown.
 bool? get isOperational; String? get statusLabel;/// Operator's free-text cost (e.g. "0,39 €/kWh"). Never parsed into a price.
 String? get usageCost; DateTime? get lastVerified; DateTime? get lastStatusUpdate;
/// Create a copy of ChargePoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChargePointCopyWith<ChargePoint> get copyWith => _$ChargePointCopyWithImpl<ChargePoint>(this as ChargePoint, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ChargePoint;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChargePoint&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.operatorName, _this.operatorName) || other.operatorName == _this.operatorName)&&const DeepCollectionEquality().equals(other.connectors, _this.connectors)&&(identical(other.numberOfPoints, _this.numberOfPoints) || other.numberOfPoints == _this.numberOfPoints)&&(identical(other.isOperational, _this.isOperational) || other.isOperational == _this.isOperational)&&(identical(other.statusLabel, _this.statusLabel) || other.statusLabel == _this.statusLabel)&&(identical(other.usageCost, _this.usageCost) || other.usageCost == _this.usageCost)&&(identical(other.lastVerified, _this.lastVerified) || other.lastVerified == _this.lastVerified)&&(identical(other.lastStatusUpdate, _this.lastStatusUpdate) || other.lastStatusUpdate == _this.lastStatusUpdate));
}


@override
int get hashCode {
  final _this = this as ChargePoint;
  return Object.hash(runtimeType,_this.id,_this.name,_this.location,_this.address,_this.operatorName,const DeepCollectionEquality().hash(_this.connectors),_this.numberOfPoints,_this.isOperational,_this.statusLabel,_this.usageCost,_this.lastVerified,_this.lastStatusUpdate);
}

@override
String toString() {
  final _this = this as ChargePoint;
  return 'ChargePoint(id: ${_this.id}, name: ${_this.name}, location: ${_this.location}, address: ${_this.address}, operatorName: ${_this.operatorName}, connectors: ${_this.connectors}, numberOfPoints: ${_this.numberOfPoints}, isOperational: ${_this.isOperational}, statusLabel: ${_this.statusLabel}, usageCost: ${_this.usageCost}, lastVerified: ${_this.lastVerified}, lastStatusUpdate: ${_this.lastStatusUpdate})';
}


}

/// @nodoc
abstract mixin class $ChargePointCopyWith<$Res>  {
  factory $ChargePointCopyWith(ChargePoint value, $Res Function(ChargePoint) _then) = _$ChargePointCopyWithImpl;
@useResult
$Res call({
 String id, String name, GeoPoint location, String? address, String? operatorName, List<ChargeConnector> connectors, int? numberOfPoints, bool? isOperational, String? statusLabel, String? usageCost, DateTime? lastVerified, DateTime? lastStatusUpdate
});


$GeoPointCopyWith<$Res> get location;

}
/// @nodoc
class _$ChargePointCopyWithImpl<$Res>
    implements $ChargePointCopyWith<$Res> {
  _$ChargePointCopyWithImpl(this._self, this._then);

  final ChargePoint _self;
  final $Res Function(ChargePoint) _then;

/// Create a copy of ChargePoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? location = null,Object? address = freezed,Object? operatorName = freezed,Object? connectors = null,Object? numberOfPoints = freezed,Object? isOperational = freezed,Object? statusLabel = freezed,Object? usageCost = freezed,Object? lastVerified = freezed,Object? lastStatusUpdate = freezed,}) {
  return _then(ChargePoint(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,operatorName: freezed == operatorName ? _self.operatorName : operatorName // ignore: cast_nullable_to_non_nullable
as String?,connectors: null == connectors ? _self.connectors : connectors // ignore: cast_nullable_to_non_nullable
as List<ChargeConnector>,numberOfPoints: freezed == numberOfPoints ? _self.numberOfPoints : numberOfPoints // ignore: cast_nullable_to_non_nullable
as int?,isOperational: freezed == isOperational ? _self.isOperational : isOperational // ignore: cast_nullable_to_non_nullable
as bool?,statusLabel: freezed == statusLabel ? _self.statusLabel : statusLabel // ignore: cast_nullable_to_non_nullable
as String?,usageCost: freezed == usageCost ? _self.usageCost : usageCost // ignore: cast_nullable_to_non_nullable
as String?,lastVerified: freezed == lastVerified ? _self.lastVerified : lastVerified // ignore: cast_nullable_to_non_nullable
as DateTime?,lastStatusUpdate: freezed == lastStatusUpdate ? _self.lastStatusUpdate : lastStatusUpdate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of ChargePoint
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res> get location {
  
  return $GeoPointCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChargePoint].
extension ChargePointPatterns on ChargePoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChargePoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChargePoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChargePoint value)  $default,){
final _that = this;
switch (_that) {
case _ChargePoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChargePoint value)?  $default,){
final _that = this;
switch (_that) {
case _ChargePoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  GeoPoint location,  String? address,  String? operatorName,  List<ChargeConnector> connectors,  int? numberOfPoints,  bool? isOperational,  String? statusLabel,  String? usageCost,  DateTime? lastVerified,  DateTime? lastStatusUpdate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChargePoint() when $default != null:
return $default(_that.id,_that.name,_that.location,_that.address,_that.operatorName,_that.connectors,_that.numberOfPoints,_that.isOperational,_that.statusLabel,_that.usageCost,_that.lastVerified,_that.lastStatusUpdate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  GeoPoint location,  String? address,  String? operatorName,  List<ChargeConnector> connectors,  int? numberOfPoints,  bool? isOperational,  String? statusLabel,  String? usageCost,  DateTime? lastVerified,  DateTime? lastStatusUpdate)  $default,) {final _that = this;
switch (_that) {
case _ChargePoint():
return $default(_that.id,_that.name,_that.location,_that.address,_that.operatorName,_that.connectors,_that.numberOfPoints,_that.isOperational,_that.statusLabel,_that.usageCost,_that.lastVerified,_that.lastStatusUpdate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  GeoPoint location,  String? address,  String? operatorName,  List<ChargeConnector> connectors,  int? numberOfPoints,  bool? isOperational,  String? statusLabel,  String? usageCost,  DateTime? lastVerified,  DateTime? lastStatusUpdate)?  $default,) {final _that = this;
switch (_that) {
case _ChargePoint() when $default != null:
return $default(_that.id,_that.name,_that.location,_that.address,_that.operatorName,_that.connectors,_that.numberOfPoints,_that.isOperational,_that.statusLabel,_that.usageCost,_that.lastVerified,_that.lastStatusUpdate);case _:
  return null;

}
}

}

/// @nodoc


class _ChargePoint extends ChargePoint {
  const _ChargePoint({required this.id, required this.name, required this.location, this.address, this.operatorName,  List<ChargeConnector> connectors = const <ChargeConnector>[], this.numberOfPoints, this.isOperational, this.statusLabel, this.usageCost, this.lastVerified, this.lastStatusUpdate}): _connectors = connectors,super._();
  

@override final  String id;
@override final  String name;
@override final  GeoPoint location;
@override final  String? address;
@override final  String? operatorName;
 final  List<ChargeConnector> _connectors;
@override@JsonKey() List<ChargeConnector> get connectors {
  if (_connectors is EqualUnmodifiableListView) return _connectors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_connectors);
}

@override final  int? numberOfPoints;
/// Null = status unknown.
@override final  bool? isOperational;
@override final  String? statusLabel;
/// Operator's free-text cost (e.g. "0,39 €/kWh"). Never parsed into a price.
@override final  String? usageCost;
@override final  DateTime? lastVerified;
@override final  DateTime? lastStatusUpdate;

/// Create a copy of ChargePoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChargePointCopyWith<_ChargePoint> get copyWith => __$ChargePointCopyWithImpl<_ChargePoint>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChargePoint&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.location, location) || other.location == location)&&(identical(other.address, address) || other.address == address)&&(identical(other.operatorName, operatorName) || other.operatorName == operatorName)&&const DeepCollectionEquality().equals(other.connectors, _connectors)&&(identical(other.numberOfPoints, numberOfPoints) || other.numberOfPoints == numberOfPoints)&&(identical(other.isOperational, isOperational) || other.isOperational == isOperational)&&(identical(other.statusLabel, statusLabel) || other.statusLabel == statusLabel)&&(identical(other.usageCost, usageCost) || other.usageCost == usageCost)&&(identical(other.lastVerified, lastVerified) || other.lastVerified == lastVerified)&&(identical(other.lastStatusUpdate, lastStatusUpdate) || other.lastStatusUpdate == lastStatusUpdate));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,location,address,operatorName,const DeepCollectionEquality().hash(_connectors),numberOfPoints,isOperational,statusLabel,usageCost,lastVerified,lastStatusUpdate);
}

@override
String toString() {
    return 'ChargePoint(id: $id, name: $name, location: $location, address: $address, operatorName: $operatorName, connectors: $connectors, numberOfPoints: $numberOfPoints, isOperational: $isOperational, statusLabel: $statusLabel, usageCost: $usageCost, lastVerified: $lastVerified, lastStatusUpdate: $lastStatusUpdate)';
}


}

/// @nodoc
abstract mixin class _$ChargePointCopyWith<$Res> implements $ChargePointCopyWith<$Res> {
  factory _$ChargePointCopyWith(_ChargePoint value, $Res Function(_ChargePoint) _then) = __$ChargePointCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, GeoPoint location, String? address, String? operatorName, List<ChargeConnector> connectors, int? numberOfPoints, bool? isOperational, String? statusLabel, String? usageCost, DateTime? lastVerified, DateTime? lastStatusUpdate
});


@override $GeoPointCopyWith<$Res> get location;

}
/// @nodoc
class __$ChargePointCopyWithImpl<$Res>
    implements _$ChargePointCopyWith<$Res> {
  __$ChargePointCopyWithImpl(this._self, this._then);

  final _ChargePoint _self;
  final $Res Function(_ChargePoint) _then;

/// Create a copy of ChargePoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? location = null,Object? address = freezed,Object? operatorName = freezed,Object? connectors = null,Object? numberOfPoints = freezed,Object? isOperational = freezed,Object? statusLabel = freezed,Object? usageCost = freezed,Object? lastVerified = freezed,Object? lastStatusUpdate = freezed,}) {
  return _then(_ChargePoint(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,operatorName: freezed == operatorName ? _self.operatorName : operatorName // ignore: cast_nullable_to_non_nullable
as String?,connectors: null == connectors ? _self._connectors : connectors // ignore: cast_nullable_to_non_nullable
as List<ChargeConnector>,numberOfPoints: freezed == numberOfPoints ? _self.numberOfPoints : numberOfPoints // ignore: cast_nullable_to_non_nullable
as int?,isOperational: freezed == isOperational ? _self.isOperational : isOperational // ignore: cast_nullable_to_non_nullable
as bool?,statusLabel: freezed == statusLabel ? _self.statusLabel : statusLabel // ignore: cast_nullable_to_non_nullable
as String?,usageCost: freezed == usageCost ? _self.usageCost : usageCost // ignore: cast_nullable_to_non_nullable
as String?,lastVerified: freezed == lastVerified ? _self.lastVerified : lastVerified // ignore: cast_nullable_to_non_nullable
as DateTime?,lastStatusUpdate: freezed == lastStatusUpdate ? _self.lastStatusUpdate : lastStatusUpdate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of ChargePoint
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res> get location {
  
  return $GeoPointCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}

/// @nodoc
mixin _$ChargeConnector {

 String get type; double? get powerKw; int? get quantity; bool? get isDc; bool? get isOperational;
/// Create a copy of ChargeConnector
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChargeConnectorCopyWith<ChargeConnector> get copyWith => _$ChargeConnectorCopyWithImpl<ChargeConnector>(this as ChargeConnector, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ChargeConnector;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChargeConnector&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.powerKw, _this.powerKw) || other.powerKw == _this.powerKw)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.isDc, _this.isDc) || other.isDc == _this.isDc)&&(identical(other.isOperational, _this.isOperational) || other.isOperational == _this.isOperational));
}


@override
int get hashCode {
  final _this = this as ChargeConnector;
  return Object.hash(runtimeType,_this.type,_this.powerKw,_this.quantity,_this.isDc,_this.isOperational);
}

@override
String toString() {
  final _this = this as ChargeConnector;
  return 'ChargeConnector(type: ${_this.type}, powerKw: ${_this.powerKw}, quantity: ${_this.quantity}, isDc: ${_this.isDc}, isOperational: ${_this.isOperational})';
}


}

/// @nodoc
abstract mixin class $ChargeConnectorCopyWith<$Res>  {
  factory $ChargeConnectorCopyWith(ChargeConnector value, $Res Function(ChargeConnector) _then) = _$ChargeConnectorCopyWithImpl;
@useResult
$Res call({
 String type, double? powerKw, int? quantity, bool? isDc, bool? isOperational
});




}
/// @nodoc
class _$ChargeConnectorCopyWithImpl<$Res>
    implements $ChargeConnectorCopyWith<$Res> {
  _$ChargeConnectorCopyWithImpl(this._self, this._then);

  final ChargeConnector _self;
  final $Res Function(ChargeConnector) _then;

/// Create a copy of ChargeConnector
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? powerKw = freezed,Object? quantity = freezed,Object? isDc = freezed,Object? isOperational = freezed,}) {
  return _then(ChargeConnector(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,powerKw: freezed == powerKw ? _self.powerKw : powerKw // ignore: cast_nullable_to_non_nullable
as double?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int?,isDc: freezed == isDc ? _self.isDc : isDc // ignore: cast_nullable_to_non_nullable
as bool?,isOperational: freezed == isOperational ? _self.isOperational : isOperational // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChargeConnector].
extension ChargeConnectorPatterns on ChargeConnector {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChargeConnector value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChargeConnector() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChargeConnector value)  $default,){
final _that = this;
switch (_that) {
case _ChargeConnector():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChargeConnector value)?  $default,){
final _that = this;
switch (_that) {
case _ChargeConnector() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  double? powerKw,  int? quantity,  bool? isDc,  bool? isOperational)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChargeConnector() when $default != null:
return $default(_that.type,_that.powerKw,_that.quantity,_that.isDc,_that.isOperational);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  double? powerKw,  int? quantity,  bool? isDc,  bool? isOperational)  $default,) {final _that = this;
switch (_that) {
case _ChargeConnector():
return $default(_that.type,_that.powerKw,_that.quantity,_that.isDc,_that.isOperational);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  double? powerKw,  int? quantity,  bool? isDc,  bool? isOperational)?  $default,) {final _that = this;
switch (_that) {
case _ChargeConnector() when $default != null:
return $default(_that.type,_that.powerKw,_that.quantity,_that.isDc,_that.isOperational);case _:
  return null;

}
}

}

/// @nodoc


class _ChargeConnector implements ChargeConnector {
  const _ChargeConnector({required this.type, this.powerKw, this.quantity, this.isDc, this.isOperational});
  

@override final  String type;
@override final  double? powerKw;
@override final  int? quantity;
@override final  bool? isDc;
@override final  bool? isOperational;

/// Create a copy of ChargeConnector
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChargeConnectorCopyWith<_ChargeConnector> get copyWith => __$ChargeConnectorCopyWithImpl<_ChargeConnector>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChargeConnector&&(identical(other.type, type) || other.type == type)&&(identical(other.powerKw, powerKw) || other.powerKw == powerKw)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.isDc, isDc) || other.isDc == isDc)&&(identical(other.isOperational, isOperational) || other.isOperational == isOperational));
}


@override
int get hashCode {
    return Object.hash(runtimeType,type,powerKw,quantity,isDc,isOperational);
}

@override
String toString() {
    return 'ChargeConnector(type: $type, powerKw: $powerKw, quantity: $quantity, isDc: $isDc, isOperational: $isOperational)';
}


}

/// @nodoc
abstract mixin class _$ChargeConnectorCopyWith<$Res> implements $ChargeConnectorCopyWith<$Res> {
  factory _$ChargeConnectorCopyWith(_ChargeConnector value, $Res Function(_ChargeConnector) _then) = __$ChargeConnectorCopyWithImpl;
@override @useResult
$Res call({
 String type, double? powerKw, int? quantity, bool? isDc, bool? isOperational
});




}
/// @nodoc
class __$ChargeConnectorCopyWithImpl<$Res>
    implements _$ChargeConnectorCopyWith<$Res> {
  __$ChargeConnectorCopyWithImpl(this._self, this._then);

  final _ChargeConnector _self;
  final $Res Function(_ChargeConnector) _then;

/// Create a copy of ChargeConnector
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? powerKw = freezed,Object? quantity = freezed,Object? isDc = freezed,Object? isOperational = freezed,}) {
  return _then(_ChargeConnector(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,powerKw: freezed == powerKw ? _self.powerKw : powerKw // ignore: cast_nullable_to_non_nullable
as double?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int?,isDc: freezed == isDc ? _self.isDc : isDc // ignore: cast_nullable_to_non_nullable
as bool?,isOperational: freezed == isOperational ? _self.isOperational : isOperational // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

/// @nodoc
mixin _$EvFilter {

 double get minPowerKw;/// Empty = any connector.
 Set<String> get connectorTypes; bool get operationalOnly;
/// Create a copy of EvFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EvFilterCopyWith<EvFilter> get copyWith => _$EvFilterCopyWithImpl<EvFilter>(this as EvFilter, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as EvFilter;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EvFilter&&(identical(other.minPowerKw, _this.minPowerKw) || other.minPowerKw == _this.minPowerKw)&&const DeepCollectionEquality().equals(other.connectorTypes, _this.connectorTypes)&&(identical(other.operationalOnly, _this.operationalOnly) || other.operationalOnly == _this.operationalOnly));
}


@override
int get hashCode {
  final _this = this as EvFilter;
  return Object.hash(runtimeType,_this.minPowerKw,const DeepCollectionEquality().hash(_this.connectorTypes),_this.operationalOnly);
}

@override
String toString() {
  final _this = this as EvFilter;
  return 'EvFilter(minPowerKw: ${_this.minPowerKw}, connectorTypes: ${_this.connectorTypes}, operationalOnly: ${_this.operationalOnly})';
}


}

/// @nodoc
abstract mixin class $EvFilterCopyWith<$Res>  {
  factory $EvFilterCopyWith(EvFilter value, $Res Function(EvFilter) _then) = _$EvFilterCopyWithImpl;
@useResult
$Res call({
 double minPowerKw, Set<String> connectorTypes, bool operationalOnly
});




}
/// @nodoc
class _$EvFilterCopyWithImpl<$Res>
    implements $EvFilterCopyWith<$Res> {
  _$EvFilterCopyWithImpl(this._self, this._then);

  final EvFilter _self;
  final $Res Function(EvFilter) _then;

/// Create a copy of EvFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? minPowerKw = null,Object? connectorTypes = null,Object? operationalOnly = null,}) {
  return _then(EvFilter(
minPowerKw: null == minPowerKw ? _self.minPowerKw : minPowerKw // ignore: cast_nullable_to_non_nullable
as double,connectorTypes: null == connectorTypes ? _self.connectorTypes : connectorTypes // ignore: cast_nullable_to_non_nullable
as Set<String>,operationalOnly: null == operationalOnly ? _self.operationalOnly : operationalOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EvFilter].
extension EvFilterPatterns on EvFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EvFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EvFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EvFilter value)  $default,){
final _that = this;
switch (_that) {
case _EvFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EvFilter value)?  $default,){
final _that = this;
switch (_that) {
case _EvFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double minPowerKw,  Set<String> connectorTypes,  bool operationalOnly)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EvFilter() when $default != null:
return $default(_that.minPowerKw,_that.connectorTypes,_that.operationalOnly);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double minPowerKw,  Set<String> connectorTypes,  bool operationalOnly)  $default,) {final _that = this;
switch (_that) {
case _EvFilter():
return $default(_that.minPowerKw,_that.connectorTypes,_that.operationalOnly);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double minPowerKw,  Set<String> connectorTypes,  bool operationalOnly)?  $default,) {final _that = this;
switch (_that) {
case _EvFilter() when $default != null:
return $default(_that.minPowerKw,_that.connectorTypes,_that.operationalOnly);case _:
  return null;

}
}

}

/// @nodoc


class _EvFilter extends EvFilter {
  const _EvFilter({this.minPowerKw = 0,  Set<String> connectorTypes = const <String>{}, this.operationalOnly = false}): _connectorTypes = connectorTypes,super._();
  

@override@JsonKey() final  double minPowerKw;
/// Empty = any connector.
 final  Set<String> _connectorTypes;
/// Empty = any connector.
@override@JsonKey() Set<String> get connectorTypes {
  if (_connectorTypes is EqualUnmodifiableSetView) return _connectorTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_connectorTypes);
}

@override@JsonKey() final  bool operationalOnly;

/// Create a copy of EvFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EvFilterCopyWith<_EvFilter> get copyWith => __$EvFilterCopyWithImpl<_EvFilter>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EvFilter&&(identical(other.minPowerKw, minPowerKw) || other.minPowerKw == minPowerKw)&&const DeepCollectionEquality().equals(other.connectorTypes, _connectorTypes)&&(identical(other.operationalOnly, operationalOnly) || other.operationalOnly == operationalOnly));
}


@override
int get hashCode {
    return Object.hash(runtimeType,minPowerKw,const DeepCollectionEquality().hash(_connectorTypes),operationalOnly);
}

@override
String toString() {
    return 'EvFilter(minPowerKw: $minPowerKw, connectorTypes: $connectorTypes, operationalOnly: $operationalOnly)';
}


}

/// @nodoc
abstract mixin class _$EvFilterCopyWith<$Res> implements $EvFilterCopyWith<$Res> {
  factory _$EvFilterCopyWith(_EvFilter value, $Res Function(_EvFilter) _then) = __$EvFilterCopyWithImpl;
@override @useResult
$Res call({
 double minPowerKw, Set<String> connectorTypes, bool operationalOnly
});




}
/// @nodoc
class __$EvFilterCopyWithImpl<$Res>
    implements _$EvFilterCopyWith<$Res> {
  __$EvFilterCopyWithImpl(this._self, this._then);

  final _EvFilter _self;
  final $Res Function(_EvFilter) _then;

/// Create a copy of EvFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? minPowerKw = null,Object? connectorTypes = null,Object? operationalOnly = null,}) {
  return _then(_EvFilter(
minPowerKw: null == minPowerKw ? _self.minPowerKw : minPowerKw // ignore: cast_nullable_to_non_nullable
as double,connectorTypes: null == connectorTypes ? _self._connectorTypes : connectorTypes // ignore: cast_nullable_to_non_nullable
as Set<String>,operationalOnly: null == operationalOnly ? _self.operationalOnly : operationalOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
