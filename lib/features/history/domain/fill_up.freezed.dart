// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fill_up.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FillUp {

 String get id; String get vehicleId; DateTime get date; double get amount; double get totalCost; String get currencyCode;/// Odometer reading in km; needed for consumption / cost-per-km.
 double? get odometerKm;/// Filled to full (tank full / charged to the usual target). Consumption
/// is computed full-to-full, so partial fills are added to the next one.
 bool get isFull; String? get stationName;
/// Create a copy of FillUp
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FillUpCopyWith<FillUp> get copyWith => _$FillUpCopyWithImpl<FillUp>(this as FillUp, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FillUp;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FillUp&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.vehicleId, _this.vehicleId) || other.vehicleId == _this.vehicleId)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.totalCost, _this.totalCost) || other.totalCost == _this.totalCost)&&(identical(other.currencyCode, _this.currencyCode) || other.currencyCode == _this.currencyCode)&&(identical(other.odometerKm, _this.odometerKm) || other.odometerKm == _this.odometerKm)&&(identical(other.isFull, _this.isFull) || other.isFull == _this.isFull)&&(identical(other.stationName, _this.stationName) || other.stationName == _this.stationName));
}


@override
int get hashCode {
  final _this = this as FillUp;
  return Object.hash(runtimeType,_this.id,_this.vehicleId,_this.date,_this.amount,_this.totalCost,_this.currencyCode,_this.odometerKm,_this.isFull,_this.stationName);
}

@override
String toString() {
  final _this = this as FillUp;
  return 'FillUp(id: ${_this.id}, vehicleId: ${_this.vehicleId}, date: ${_this.date}, amount: ${_this.amount}, totalCost: ${_this.totalCost}, currencyCode: ${_this.currencyCode}, odometerKm: ${_this.odometerKm}, isFull: ${_this.isFull}, stationName: ${_this.stationName})';
}


}

/// @nodoc
abstract mixin class $FillUpCopyWith<$Res>  {
  factory $FillUpCopyWith(FillUp value, $Res Function(FillUp) _then) = _$FillUpCopyWithImpl;
@useResult
$Res call({
 String id, String vehicleId, DateTime date, double amount, double totalCost, String currencyCode, double? odometerKm, bool isFull, String? stationName
});




}
/// @nodoc
class _$FillUpCopyWithImpl<$Res>
    implements $FillUpCopyWith<$Res> {
  _$FillUpCopyWithImpl(this._self, this._then);

  final FillUp _self;
  final $Res Function(FillUp) _then;

/// Create a copy of FillUp
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vehicleId = null,Object? date = null,Object? amount = null,Object? totalCost = null,Object? currencyCode = null,Object? odometerKm = freezed,Object? isFull = null,Object? stationName = freezed,}) {
  return _then(FillUp(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,totalCost: null == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as double,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,odometerKm: freezed == odometerKm ? _self.odometerKm : odometerKm // ignore: cast_nullable_to_non_nullable
as double?,isFull: null == isFull ? _self.isFull : isFull // ignore: cast_nullable_to_non_nullable
as bool,stationName: freezed == stationName ? _self.stationName : stationName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FillUp].
extension FillUpPatterns on FillUp {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FillUp value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FillUp() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FillUp value)  $default,){
final _that = this;
switch (_that) {
case _FillUp():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FillUp value)?  $default,){
final _that = this;
switch (_that) {
case _FillUp() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String vehicleId,  DateTime date,  double amount,  double totalCost,  String currencyCode,  double? odometerKm,  bool isFull,  String? stationName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FillUp() when $default != null:
return $default(_that.id,_that.vehicleId,_that.date,_that.amount,_that.totalCost,_that.currencyCode,_that.odometerKm,_that.isFull,_that.stationName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String vehicleId,  DateTime date,  double amount,  double totalCost,  String currencyCode,  double? odometerKm,  bool isFull,  String? stationName)  $default,) {final _that = this;
switch (_that) {
case _FillUp():
return $default(_that.id,_that.vehicleId,_that.date,_that.amount,_that.totalCost,_that.currencyCode,_that.odometerKm,_that.isFull,_that.stationName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String vehicleId,  DateTime date,  double amount,  double totalCost,  String currencyCode,  double? odometerKm,  bool isFull,  String? stationName)?  $default,) {final _that = this;
switch (_that) {
case _FillUp() when $default != null:
return $default(_that.id,_that.vehicleId,_that.date,_that.amount,_that.totalCost,_that.currencyCode,_that.odometerKm,_that.isFull,_that.stationName);case _:
  return null;

}
}

}

/// @nodoc


class _FillUp extends FillUp {
  const _FillUp({required this.id, required this.vehicleId, required this.date, required this.amount, required this.totalCost, required this.currencyCode, this.odometerKm, this.isFull = true, this.stationName}): assert(amount > 0, 'amount must be positive'),assert(totalCost >= 0, 'totalCost must not be negative'),super._();
  

@override final  String id;
@override final  String vehicleId;
@override final  DateTime date;
@override final  double amount;
@override final  double totalCost;
@override final  String currencyCode;
/// Odometer reading in km; needed for consumption / cost-per-km.
@override final  double? odometerKm;
/// Filled to full (tank full / charged to the usual target). Consumption
/// is computed full-to-full, so partial fills are added to the next one.
@override@JsonKey() final  bool isFull;
@override final  String? stationName;

/// Create a copy of FillUp
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FillUpCopyWith<_FillUp> get copyWith => __$FillUpCopyWithImpl<_FillUp>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FillUp&&(identical(other.id, id) || other.id == id)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.totalCost, totalCost) || other.totalCost == totalCost)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.odometerKm, odometerKm) || other.odometerKm == odometerKm)&&(identical(other.isFull, isFull) || other.isFull == isFull)&&(identical(other.stationName, stationName) || other.stationName == stationName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,vehicleId,date,amount,totalCost,currencyCode,odometerKm,isFull,stationName);
}

@override
String toString() {
    return 'FillUp(id: $id, vehicleId: $vehicleId, date: $date, amount: $amount, totalCost: $totalCost, currencyCode: $currencyCode, odometerKm: $odometerKm, isFull: $isFull, stationName: $stationName)';
}


}

/// @nodoc
abstract mixin class _$FillUpCopyWith<$Res> implements $FillUpCopyWith<$Res> {
  factory _$FillUpCopyWith(_FillUp value, $Res Function(_FillUp) _then) = __$FillUpCopyWithImpl;
@override @useResult
$Res call({
 String id, String vehicleId, DateTime date, double amount, double totalCost, String currencyCode, double? odometerKm, bool isFull, String? stationName
});




}
/// @nodoc
class __$FillUpCopyWithImpl<$Res>
    implements _$FillUpCopyWith<$Res> {
  __$FillUpCopyWithImpl(this._self, this._then);

  final _FillUp _self;
  final $Res Function(_FillUp) _then;

/// Create a copy of FillUp
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vehicleId = null,Object? date = null,Object? amount = null,Object? totalCost = null,Object? currencyCode = null,Object? odometerKm = freezed,Object? isFull = null,Object? stationName = freezed,}) {
  return _then(_FillUp(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,totalCost: null == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as double,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,odometerKm: freezed == odometerKm ? _self.odometerKm : odometerKm // ignore: cast_nullable_to_non_nullable
as double?,isFull: null == isFull ? _self.isFull : isFull // ignore: cast_nullable_to_non_nullable
as bool,stationName: freezed == stationName ? _self.stationName : stationName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
