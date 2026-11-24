// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_analytics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MonthlySummary {

 int get year; int get month; String get currencyCode; double get totalCost; double get totalAmount; int get count;
/// Create a copy of MonthlySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlySummaryCopyWith<MonthlySummary> get copyWith => _$MonthlySummaryCopyWithImpl<MonthlySummary>(this as MonthlySummary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MonthlySummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlySummary&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.currencyCode, _this.currencyCode) || other.currencyCode == _this.currencyCode)&&(identical(other.totalCost, _this.totalCost) || other.totalCost == _this.totalCost)&&(identical(other.totalAmount, _this.totalAmount) || other.totalAmount == _this.totalAmount)&&(identical(other.count, _this.count) || other.count == _this.count));
}


@override
int get hashCode {
  final _this = this as MonthlySummary;
  return Object.hash(runtimeType,_this.year,_this.month,_this.currencyCode,_this.totalCost,_this.totalAmount,_this.count);
}

@override
String toString() {
  final _this = this as MonthlySummary;
  return 'MonthlySummary(year: ${_this.year}, month: ${_this.month}, currencyCode: ${_this.currencyCode}, totalCost: ${_this.totalCost}, totalAmount: ${_this.totalAmount}, count: ${_this.count})';
}


}

/// @nodoc
abstract mixin class $MonthlySummaryCopyWith<$Res>  {
  factory $MonthlySummaryCopyWith(MonthlySummary value, $Res Function(MonthlySummary) _then) = _$MonthlySummaryCopyWithImpl;
@useResult
$Res call({
 int year, int month, String currencyCode, double totalCost, double totalAmount, int count
});




}
/// @nodoc
class _$MonthlySummaryCopyWithImpl<$Res>
    implements $MonthlySummaryCopyWith<$Res> {
  _$MonthlySummaryCopyWithImpl(this._self, this._then);

  final MonthlySummary _self;
  final $Res Function(MonthlySummary) _then;

/// Create a copy of MonthlySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? month = null,Object? currencyCode = null,Object? totalCost = null,Object? totalAmount = null,Object? count = null,}) {
  return _then(MonthlySummary(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,totalCost: null == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlySummary].
extension MonthlySummaryPatterns on MonthlySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlySummary value)  $default,){
final _that = this;
switch (_that) {
case _MonthlySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlySummary value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  int month,  String currencyCode,  double totalCost,  double totalAmount,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlySummary() when $default != null:
return $default(_that.year,_that.month,_that.currencyCode,_that.totalCost,_that.totalAmount,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  int month,  String currencyCode,  double totalCost,  double totalAmount,  int count)  $default,) {final _that = this;
switch (_that) {
case _MonthlySummary():
return $default(_that.year,_that.month,_that.currencyCode,_that.totalCost,_that.totalAmount,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  int month,  String currencyCode,  double totalCost,  double totalAmount,  int count)?  $default,) {final _that = this;
switch (_that) {
case _MonthlySummary() when $default != null:
return $default(_that.year,_that.month,_that.currencyCode,_that.totalCost,_that.totalAmount,_that.count);case _:
  return null;

}
}

}

/// @nodoc


class _MonthlySummary implements MonthlySummary {
  const _MonthlySummary({required this.year, required this.month, required this.currencyCode, required this.totalCost, required this.totalAmount, required this.count});
  

@override final  int year;
@override final  int month;
@override final  String currencyCode;
@override final  double totalCost;
@override final  double totalAmount;
@override final  int count;

/// Create a copy of MonthlySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlySummaryCopyWith<_MonthlySummary> get copyWith => __$MonthlySummaryCopyWithImpl<_MonthlySummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlySummary&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.totalCost, totalCost) || other.totalCost == totalCost)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.count, count) || other.count == count));
}


@override
int get hashCode {
    return Object.hash(runtimeType,year,month,currencyCode,totalCost,totalAmount,count);
}

@override
String toString() {
    return 'MonthlySummary(year: $year, month: $month, currencyCode: $currencyCode, totalCost: $totalCost, totalAmount: $totalAmount, count: $count)';
}


}

/// @nodoc
abstract mixin class _$MonthlySummaryCopyWith<$Res> implements $MonthlySummaryCopyWith<$Res> {
  factory _$MonthlySummaryCopyWith(_MonthlySummary value, $Res Function(_MonthlySummary) _then) = __$MonthlySummaryCopyWithImpl;
@override @useResult
$Res call({
 int year, int month, String currencyCode, double totalCost, double totalAmount, int count
});




}
/// @nodoc
class __$MonthlySummaryCopyWithImpl<$Res>
    implements _$MonthlySummaryCopyWith<$Res> {
  __$MonthlySummaryCopyWithImpl(this._self, this._then);

  final _MonthlySummary _self;
  final $Res Function(_MonthlySummary) _then;

/// Create a copy of MonthlySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? month = null,Object? currencyCode = null,Object? totalCost = null,Object? totalAmount = null,Object? count = null,}) {
  return _then(_MonthlySummary(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,totalCost: null == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$ConsumptionPoint {

 DateTime get date; double get distanceKm; double get amount;/// L/100 km or kWh/100 km (as bought, i.e. including charging losses).
 double get per100Km;/// Cost per km; null when the segment mixes currencies.
 double? get costPerKm; String? get currencyCode;
/// Create a copy of ConsumptionPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsumptionPointCopyWith<ConsumptionPoint> get copyWith => _$ConsumptionPointCopyWithImpl<ConsumptionPoint>(this as ConsumptionPoint, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ConsumptionPoint;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsumptionPoint&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.distanceKm, _this.distanceKm) || other.distanceKm == _this.distanceKm)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.per100Km, _this.per100Km) || other.per100Km == _this.per100Km)&&(identical(other.costPerKm, _this.costPerKm) || other.costPerKm == _this.costPerKm)&&(identical(other.currencyCode, _this.currencyCode) || other.currencyCode == _this.currencyCode));
}


@override
int get hashCode {
  final _this = this as ConsumptionPoint;
  return Object.hash(runtimeType,_this.date,_this.distanceKm,_this.amount,_this.per100Km,_this.costPerKm,_this.currencyCode);
}

@override
String toString() {
  final _this = this as ConsumptionPoint;
  return 'ConsumptionPoint(date: ${_this.date}, distanceKm: ${_this.distanceKm}, amount: ${_this.amount}, per100Km: ${_this.per100Km}, costPerKm: ${_this.costPerKm}, currencyCode: ${_this.currencyCode})';
}


}

/// @nodoc
abstract mixin class $ConsumptionPointCopyWith<$Res>  {
  factory $ConsumptionPointCopyWith(ConsumptionPoint value, $Res Function(ConsumptionPoint) _then) = _$ConsumptionPointCopyWithImpl;
@useResult
$Res call({
 DateTime date, double distanceKm, double amount, double per100Km, double? costPerKm, String? currencyCode
});




}
/// @nodoc
class _$ConsumptionPointCopyWithImpl<$Res>
    implements $ConsumptionPointCopyWith<$Res> {
  _$ConsumptionPointCopyWithImpl(this._self, this._then);

  final ConsumptionPoint _self;
  final $Res Function(ConsumptionPoint) _then;

/// Create a copy of ConsumptionPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? distanceKm = null,Object? amount = null,Object? per100Km = null,Object? costPerKm = freezed,Object? currencyCode = freezed,}) {
  return _then(ConsumptionPoint(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,per100Km: null == per100Km ? _self.per100Km : per100Km // ignore: cast_nullable_to_non_nullable
as double,costPerKm: freezed == costPerKm ? _self.costPerKm : costPerKm // ignore: cast_nullable_to_non_nullable
as double?,currencyCode: freezed == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsumptionPoint].
extension ConsumptionPointPatterns on ConsumptionPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsumptionPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsumptionPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsumptionPoint value)  $default,){
final _that = this;
switch (_that) {
case _ConsumptionPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsumptionPoint value)?  $default,){
final _that = this;
switch (_that) {
case _ConsumptionPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  double distanceKm,  double amount,  double per100Km,  double? costPerKm,  String? currencyCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsumptionPoint() when $default != null:
return $default(_that.date,_that.distanceKm,_that.amount,_that.per100Km,_that.costPerKm,_that.currencyCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  double distanceKm,  double amount,  double per100Km,  double? costPerKm,  String? currencyCode)  $default,) {final _that = this;
switch (_that) {
case _ConsumptionPoint():
return $default(_that.date,_that.distanceKm,_that.amount,_that.per100Km,_that.costPerKm,_that.currencyCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  double distanceKm,  double amount,  double per100Km,  double? costPerKm,  String? currencyCode)?  $default,) {final _that = this;
switch (_that) {
case _ConsumptionPoint() when $default != null:
return $default(_that.date,_that.distanceKm,_that.amount,_that.per100Km,_that.costPerKm,_that.currencyCode);case _:
  return null;

}
}

}

/// @nodoc


class _ConsumptionPoint implements ConsumptionPoint {
  const _ConsumptionPoint({required this.date, required this.distanceKm, required this.amount, required this.per100Km, this.costPerKm, this.currencyCode});
  

@override final  DateTime date;
@override final  double distanceKm;
@override final  double amount;
/// L/100 km or kWh/100 km (as bought, i.e. including charging losses).
@override final  double per100Km;
/// Cost per km; null when the segment mixes currencies.
@override final  double? costPerKm;
@override final  String? currencyCode;

/// Create a copy of ConsumptionPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsumptionPointCopyWith<_ConsumptionPoint> get copyWith => __$ConsumptionPointCopyWithImpl<_ConsumptionPoint>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsumptionPoint&&(identical(other.date, date) || other.date == date)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.per100Km, per100Km) || other.per100Km == per100Km)&&(identical(other.costPerKm, costPerKm) || other.costPerKm == costPerKm)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,distanceKm,amount,per100Km,costPerKm,currencyCode);
}

@override
String toString() {
    return 'ConsumptionPoint(date: $date, distanceKm: $distanceKm, amount: $amount, per100Km: $per100Km, costPerKm: $costPerKm, currencyCode: $currencyCode)';
}


}

/// @nodoc
abstract mixin class _$ConsumptionPointCopyWith<$Res> implements $ConsumptionPointCopyWith<$Res> {
  factory _$ConsumptionPointCopyWith(_ConsumptionPoint value, $Res Function(_ConsumptionPoint) _then) = __$ConsumptionPointCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double distanceKm, double amount, double per100Km, double? costPerKm, String? currencyCode
});




}
/// @nodoc
class __$ConsumptionPointCopyWithImpl<$Res>
    implements _$ConsumptionPointCopyWith<$Res> {
  __$ConsumptionPointCopyWithImpl(this._self, this._then);

  final _ConsumptionPoint _self;
  final $Res Function(_ConsumptionPoint) _then;

/// Create a copy of ConsumptionPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? distanceKm = null,Object? amount = null,Object? per100Km = null,Object? costPerKm = freezed,Object? currencyCode = freezed,}) {
  return _then(_ConsumptionPoint(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,per100Km: null == per100Km ? _self.per100Km : per100Km // ignore: cast_nullable_to_non_nullable
as double,costPerKm: freezed == costPerKm ? _self.costPerKm : costPerKm // ignore: cast_nullable_to_non_nullable
as double?,currencyCode: freezed == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
