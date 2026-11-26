// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CommunityPrice {

 String get fuelType; double get price; String get currencyCode; int get reportCount;/// 0..1 — agreement and number of reports behind the consensus.
 double get confidence; DateTime get lastReportAt;/// After this the price is stale and must not be used for ranking.
 DateTime get expiresAt;/// Distinct users who said the current price is wrong (server-counted).
 int get flagCount;/// Enough "wrong price" flags since the last report: shown with a warning
/// and never used for ranking until a new report replaces it.
 bool get disputed;
/// Create a copy of CommunityPrice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommunityPriceCopyWith<CommunityPrice> get copyWith => _$CommunityPriceCopyWithImpl<CommunityPrice>(this as CommunityPrice, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CommunityPrice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommunityPrice&&(identical(other.fuelType, _this.fuelType) || other.fuelType == _this.fuelType)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.currencyCode, _this.currencyCode) || other.currencyCode == _this.currencyCode)&&(identical(other.reportCount, _this.reportCount) || other.reportCount == _this.reportCount)&&(identical(other.confidence, _this.confidence) || other.confidence == _this.confidence)&&(identical(other.lastReportAt, _this.lastReportAt) || other.lastReportAt == _this.lastReportAt)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.flagCount, _this.flagCount) || other.flagCount == _this.flagCount)&&(identical(other.disputed, _this.disputed) || other.disputed == _this.disputed));
}


@override
int get hashCode {
  final _this = this as CommunityPrice;
  return Object.hash(runtimeType,_this.fuelType,_this.price,_this.currencyCode,_this.reportCount,_this.confidence,_this.lastReportAt,_this.expiresAt,_this.flagCount,_this.disputed);
}

@override
String toString() {
  final _this = this as CommunityPrice;
  return 'CommunityPrice(fuelType: ${_this.fuelType}, price: ${_this.price}, currencyCode: ${_this.currencyCode}, reportCount: ${_this.reportCount}, confidence: ${_this.confidence}, lastReportAt: ${_this.lastReportAt}, expiresAt: ${_this.expiresAt}, flagCount: ${_this.flagCount}, disputed: ${_this.disputed})';
}


}

/// @nodoc
abstract mixin class $CommunityPriceCopyWith<$Res>  {
  factory $CommunityPriceCopyWith(CommunityPrice value, $Res Function(CommunityPrice) _then) = _$CommunityPriceCopyWithImpl;
@useResult
$Res call({
 String fuelType, double price, String currencyCode, int reportCount, double confidence, DateTime lastReportAt, DateTime expiresAt, int flagCount, bool disputed
});




}
/// @nodoc
class _$CommunityPriceCopyWithImpl<$Res>
    implements $CommunityPriceCopyWith<$Res> {
  _$CommunityPriceCopyWithImpl(this._self, this._then);

  final CommunityPrice _self;
  final $Res Function(CommunityPrice) _then;

/// Create a copy of CommunityPrice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fuelType = null,Object? price = null,Object? currencyCode = null,Object? reportCount = null,Object? confidence = null,Object? lastReportAt = null,Object? expiresAt = null,Object? flagCount = null,Object? disputed = null,}) {
  return _then(CommunityPrice(
fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,reportCount: null == reportCount ? _self.reportCount : reportCount // ignore: cast_nullable_to_non_nullable
as int,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,lastReportAt: null == lastReportAt ? _self.lastReportAt : lastReportAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,flagCount: null == flagCount ? _self.flagCount : flagCount // ignore: cast_nullable_to_non_nullable
as int,disputed: null == disputed ? _self.disputed : disputed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CommunityPrice].
extension CommunityPricePatterns on CommunityPrice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommunityPrice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommunityPrice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommunityPrice value)  $default,){
final _that = this;
switch (_that) {
case _CommunityPrice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommunityPrice value)?  $default,){
final _that = this;
switch (_that) {
case _CommunityPrice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fuelType,  double price,  String currencyCode,  int reportCount,  double confidence,  DateTime lastReportAt,  DateTime expiresAt,  int flagCount,  bool disputed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommunityPrice() when $default != null:
return $default(_that.fuelType,_that.price,_that.currencyCode,_that.reportCount,_that.confidence,_that.lastReportAt,_that.expiresAt,_that.flagCount,_that.disputed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fuelType,  double price,  String currencyCode,  int reportCount,  double confidence,  DateTime lastReportAt,  DateTime expiresAt,  int flagCount,  bool disputed)  $default,) {final _that = this;
switch (_that) {
case _CommunityPrice():
return $default(_that.fuelType,_that.price,_that.currencyCode,_that.reportCount,_that.confidence,_that.lastReportAt,_that.expiresAt,_that.flagCount,_that.disputed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fuelType,  double price,  String currencyCode,  int reportCount,  double confidence,  DateTime lastReportAt,  DateTime expiresAt,  int flagCount,  bool disputed)?  $default,) {final _that = this;
switch (_that) {
case _CommunityPrice() when $default != null:
return $default(_that.fuelType,_that.price,_that.currencyCode,_that.reportCount,_that.confidence,_that.lastReportAt,_that.expiresAt,_that.flagCount,_that.disputed);case _:
  return null;

}
}

}

/// @nodoc


class _CommunityPrice extends CommunityPrice {
  const _CommunityPrice({required this.fuelType, required this.price, required this.currencyCode, required this.reportCount, required this.confidence, required this.lastReportAt, required this.expiresAt, this.flagCount = 0, this.disputed = false}): super._();
  

@override final  String fuelType;
@override final  double price;
@override final  String currencyCode;
@override final  int reportCount;
/// 0..1 — agreement and number of reports behind the consensus.
@override final  double confidence;
@override final  DateTime lastReportAt;
/// After this the price is stale and must not be used for ranking.
@override final  DateTime expiresAt;
/// Distinct users who said the current price is wrong (server-counted).
@override@JsonKey() final  int flagCount;
/// Enough "wrong price" flags since the last report: shown with a warning
/// and never used for ranking until a new report replaces it.
@override@JsonKey() final  bool disputed;

/// Create a copy of CommunityPrice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommunityPriceCopyWith<_CommunityPrice> get copyWith => __$CommunityPriceCopyWithImpl<_CommunityPrice>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommunityPrice&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.price, price) || other.price == price)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.reportCount, reportCount) || other.reportCount == reportCount)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.lastReportAt, lastReportAt) || other.lastReportAt == lastReportAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.flagCount, flagCount) || other.flagCount == flagCount)&&(identical(other.disputed, disputed) || other.disputed == disputed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,fuelType,price,currencyCode,reportCount,confidence,lastReportAt,expiresAt,flagCount,disputed);
}

@override
String toString() {
    return 'CommunityPrice(fuelType: $fuelType, price: $price, currencyCode: $currencyCode, reportCount: $reportCount, confidence: $confidence, lastReportAt: $lastReportAt, expiresAt: $expiresAt, flagCount: $flagCount, disputed: $disputed)';
}


}

/// @nodoc
abstract mixin class _$CommunityPriceCopyWith<$Res> implements $CommunityPriceCopyWith<$Res> {
  factory _$CommunityPriceCopyWith(_CommunityPrice value, $Res Function(_CommunityPrice) _then) = __$CommunityPriceCopyWithImpl;
@override @useResult
$Res call({
 String fuelType, double price, String currencyCode, int reportCount, double confidence, DateTime lastReportAt, DateTime expiresAt, int flagCount, bool disputed
});




}
/// @nodoc
class __$CommunityPriceCopyWithImpl<$Res>
    implements _$CommunityPriceCopyWith<$Res> {
  __$CommunityPriceCopyWithImpl(this._self, this._then);

  final _CommunityPrice _self;
  final $Res Function(_CommunityPrice) _then;

/// Create a copy of CommunityPrice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fuelType = null,Object? price = null,Object? currencyCode = null,Object? reportCount = null,Object? confidence = null,Object? lastReportAt = null,Object? expiresAt = null,Object? flagCount = null,Object? disputed = null,}) {
  return _then(_CommunityPrice(
fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,reportCount: null == reportCount ? _self.reportCount : reportCount // ignore: cast_nullable_to_non_nullable
as int,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,lastReportAt: null == lastReportAt ? _self.lastReportAt : lastReportAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,flagCount: null == flagCount ? _self.flagCount : flagCount // ignore: cast_nullable_to_non_nullable
as int,disputed: null == disputed ? _self.disputed : disputed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$PriceHistoryDay {

 DateTime get day; String get fuelType; String get currencyCode; double get close; double get min; double get max; int get samples;
/// Create a copy of PriceHistoryDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceHistoryDayCopyWith<PriceHistoryDay> get copyWith => _$PriceHistoryDayCopyWithImpl<PriceHistoryDay>(this as PriceHistoryDay, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PriceHistoryDay;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceHistoryDay&&(identical(other.day, _this.day) || other.day == _this.day)&&(identical(other.fuelType, _this.fuelType) || other.fuelType == _this.fuelType)&&(identical(other.currencyCode, _this.currencyCode) || other.currencyCode == _this.currencyCode)&&(identical(other.close, _this.close) || other.close == _this.close)&&(identical(other.min, _this.min) || other.min == _this.min)&&(identical(other.max, _this.max) || other.max == _this.max)&&(identical(other.samples, _this.samples) || other.samples == _this.samples));
}


@override
int get hashCode {
  final _this = this as PriceHistoryDay;
  return Object.hash(runtimeType,_this.day,_this.fuelType,_this.currencyCode,_this.close,_this.min,_this.max,_this.samples);
}

@override
String toString() {
  final _this = this as PriceHistoryDay;
  return 'PriceHistoryDay(day: ${_this.day}, fuelType: ${_this.fuelType}, currencyCode: ${_this.currencyCode}, close: ${_this.close}, min: ${_this.min}, max: ${_this.max}, samples: ${_this.samples})';
}


}

/// @nodoc
abstract mixin class $PriceHistoryDayCopyWith<$Res>  {
  factory $PriceHistoryDayCopyWith(PriceHistoryDay value, $Res Function(PriceHistoryDay) _then) = _$PriceHistoryDayCopyWithImpl;
@useResult
$Res call({
 DateTime day, String fuelType, String currencyCode, double close, double min, double max, int samples
});




}
/// @nodoc
class _$PriceHistoryDayCopyWithImpl<$Res>
    implements $PriceHistoryDayCopyWith<$Res> {
  _$PriceHistoryDayCopyWithImpl(this._self, this._then);

  final PriceHistoryDay _self;
  final $Res Function(PriceHistoryDay) _then;

/// Create a copy of PriceHistoryDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? fuelType = null,Object? currencyCode = null,Object? close = null,Object? min = null,Object? max = null,Object? samples = null,}) {
  return _then(PriceHistoryDay(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as String,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,close: null == close ? _self.close : close // ignore: cast_nullable_to_non_nullable
as double,min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as double,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as double,samples: null == samples ? _self.samples : samples // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PriceHistoryDay].
extension PriceHistoryDayPatterns on PriceHistoryDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceHistoryDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceHistoryDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceHistoryDay value)  $default,){
final _that = this;
switch (_that) {
case _PriceHistoryDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceHistoryDay value)?  $default,){
final _that = this;
switch (_that) {
case _PriceHistoryDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime day,  String fuelType,  String currencyCode,  double close,  double min,  double max,  int samples)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PriceHistoryDay() when $default != null:
return $default(_that.day,_that.fuelType,_that.currencyCode,_that.close,_that.min,_that.max,_that.samples);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime day,  String fuelType,  String currencyCode,  double close,  double min,  double max,  int samples)  $default,) {final _that = this;
switch (_that) {
case _PriceHistoryDay():
return $default(_that.day,_that.fuelType,_that.currencyCode,_that.close,_that.min,_that.max,_that.samples);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime day,  String fuelType,  String currencyCode,  double close,  double min,  double max,  int samples)?  $default,) {final _that = this;
switch (_that) {
case _PriceHistoryDay() when $default != null:
return $default(_that.day,_that.fuelType,_that.currencyCode,_that.close,_that.min,_that.max,_that.samples);case _:
  return null;

}
}

}

/// @nodoc


class _PriceHistoryDay implements PriceHistoryDay {
  const _PriceHistoryDay({required this.day, required this.fuelType, required this.currencyCode, required this.close, required this.min, required this.max, required this.samples});
  

@override final  DateTime day;
@override final  String fuelType;
@override final  String currencyCode;
@override final  double close;
@override final  double min;
@override final  double max;
@override final  int samples;

/// Create a copy of PriceHistoryDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceHistoryDayCopyWith<_PriceHistoryDay> get copyWith => __$PriceHistoryDayCopyWithImpl<_PriceHistoryDay>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceHistoryDay&&(identical(other.day, day) || other.day == day)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.close, close) || other.close == close)&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max)&&(identical(other.samples, samples) || other.samples == samples));
}


@override
int get hashCode {
    return Object.hash(runtimeType,day,fuelType,currencyCode,close,min,max,samples);
}

@override
String toString() {
    return 'PriceHistoryDay(day: $day, fuelType: $fuelType, currencyCode: $currencyCode, close: $close, min: $min, max: $max, samples: $samples)';
}


}

/// @nodoc
abstract mixin class _$PriceHistoryDayCopyWith<$Res> implements $PriceHistoryDayCopyWith<$Res> {
  factory _$PriceHistoryDayCopyWith(_PriceHistoryDay value, $Res Function(_PriceHistoryDay) _then) = __$PriceHistoryDayCopyWithImpl;
@override @useResult
$Res call({
 DateTime day, String fuelType, String currencyCode, double close, double min, double max, int samples
});




}
/// @nodoc
class __$PriceHistoryDayCopyWithImpl<$Res>
    implements _$PriceHistoryDayCopyWith<$Res> {
  __$PriceHistoryDayCopyWithImpl(this._self, this._then);

  final _PriceHistoryDay _self;
  final $Res Function(_PriceHistoryDay) _then;

/// Create a copy of PriceHistoryDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? fuelType = null,Object? currencyCode = null,Object? close = null,Object? min = null,Object? max = null,Object? samples = null,}) {
  return _then(_PriceHistoryDay(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as String,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,close: null == close ? _self.close : close // ignore: cast_nullable_to_non_nullable
as double,min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as double,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as double,samples: null == samples ? _self.samples : samples // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$StationReliability {

 double? get score; int get openVotes; int get closedVotes; int get outOfStockVotes;
/// Create a copy of StationReliability
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StationReliabilityCopyWith<StationReliability> get copyWith => _$StationReliabilityCopyWithImpl<StationReliability>(this as StationReliability, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StationReliability;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StationReliability&&(identical(other.score, _this.score) || other.score == _this.score)&&(identical(other.openVotes, _this.openVotes) || other.openVotes == _this.openVotes)&&(identical(other.closedVotes, _this.closedVotes) || other.closedVotes == _this.closedVotes)&&(identical(other.outOfStockVotes, _this.outOfStockVotes) || other.outOfStockVotes == _this.outOfStockVotes));
}


@override
int get hashCode {
  final _this = this as StationReliability;
  return Object.hash(runtimeType,_this.score,_this.openVotes,_this.closedVotes,_this.outOfStockVotes);
}

@override
String toString() {
  final _this = this as StationReliability;
  return 'StationReliability(score: ${_this.score}, openVotes: ${_this.openVotes}, closedVotes: ${_this.closedVotes}, outOfStockVotes: ${_this.outOfStockVotes})';
}


}

/// @nodoc
abstract mixin class $StationReliabilityCopyWith<$Res>  {
  factory $StationReliabilityCopyWith(StationReliability value, $Res Function(StationReliability) _then) = _$StationReliabilityCopyWithImpl;
@useResult
$Res call({
 double? score, int openVotes, int closedVotes, int outOfStockVotes
});




}
/// @nodoc
class _$StationReliabilityCopyWithImpl<$Res>
    implements $StationReliabilityCopyWith<$Res> {
  _$StationReliabilityCopyWithImpl(this._self, this._then);

  final StationReliability _self;
  final $Res Function(StationReliability) _then;

/// Create a copy of StationReliability
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? score = freezed,Object? openVotes = null,Object? closedVotes = null,Object? outOfStockVotes = null,}) {
  return _then(StationReliability(
score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double?,openVotes: null == openVotes ? _self.openVotes : openVotes // ignore: cast_nullable_to_non_nullable
as int,closedVotes: null == closedVotes ? _self.closedVotes : closedVotes // ignore: cast_nullable_to_non_nullable
as int,outOfStockVotes: null == outOfStockVotes ? _self.outOfStockVotes : outOfStockVotes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StationReliability].
extension StationReliabilityPatterns on StationReliability {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StationReliability value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StationReliability() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StationReliability value)  $default,){
final _that = this;
switch (_that) {
case _StationReliability():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StationReliability value)?  $default,){
final _that = this;
switch (_that) {
case _StationReliability() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? score,  int openVotes,  int closedVotes,  int outOfStockVotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StationReliability() when $default != null:
return $default(_that.score,_that.openVotes,_that.closedVotes,_that.outOfStockVotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? score,  int openVotes,  int closedVotes,  int outOfStockVotes)  $default,) {final _that = this;
switch (_that) {
case _StationReliability():
return $default(_that.score,_that.openVotes,_that.closedVotes,_that.outOfStockVotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? score,  int openVotes,  int closedVotes,  int outOfStockVotes)?  $default,) {final _that = this;
switch (_that) {
case _StationReliability() when $default != null:
return $default(_that.score,_that.openVotes,_that.closedVotes,_that.outOfStockVotes);case _:
  return null;

}
}

}

/// @nodoc


class _StationReliability extends StationReliability {
  const _StationReliability({this.score, this.openVotes = 0, this.closedVotes = 0, this.outOfStockVotes = 0}): super._();
  

@override final  double? score;
@override@JsonKey() final  int openVotes;
@override@JsonKey() final  int closedVotes;
@override@JsonKey() final  int outOfStockVotes;

/// Create a copy of StationReliability
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StationReliabilityCopyWith<_StationReliability> get copyWith => __$StationReliabilityCopyWithImpl<_StationReliability>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StationReliability&&(identical(other.score, score) || other.score == score)&&(identical(other.openVotes, openVotes) || other.openVotes == openVotes)&&(identical(other.closedVotes, closedVotes) || other.closedVotes == closedVotes)&&(identical(other.outOfStockVotes, outOfStockVotes) || other.outOfStockVotes == outOfStockVotes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,score,openVotes,closedVotes,outOfStockVotes);
}

@override
String toString() {
    return 'StationReliability(score: $score, openVotes: $openVotes, closedVotes: $closedVotes, outOfStockVotes: $outOfStockVotes)';
}


}

/// @nodoc
abstract mixin class _$StationReliabilityCopyWith<$Res> implements $StationReliabilityCopyWith<$Res> {
  factory _$StationReliabilityCopyWith(_StationReliability value, $Res Function(_StationReliability) _then) = __$StationReliabilityCopyWithImpl;
@override @useResult
$Res call({
 double? score, int openVotes, int closedVotes, int outOfStockVotes
});




}
/// @nodoc
class __$StationReliabilityCopyWithImpl<$Res>
    implements _$StationReliabilityCopyWith<$Res> {
  __$StationReliabilityCopyWithImpl(this._self, this._then);

  final _StationReliability _self;
  final $Res Function(_StationReliability) _then;

/// Create a copy of StationReliability
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? score = freezed,Object? openVotes = null,Object? closedVotes = null,Object? outOfStockVotes = null,}) {
  return _then(_StationReliability(
score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double?,openVotes: null == openVotes ? _self.openVotes : openVotes // ignore: cast_nullable_to_non_nullable
as int,closedVotes: null == closedVotes ? _self.closedVotes : closedVotes // ignore: cast_nullable_to_non_nullable
as int,outOfStockVotes: null == outOfStockVotes ? _self.outOfStockVotes : outOfStockVotes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$PriceReportDraft {

 String get stationId; String? get stationName; GeoPoint get stationLocation; String get fuelType; double get price; String get currencyCode;
/// Create a copy of PriceReportDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceReportDraftCopyWith<PriceReportDraft> get copyWith => _$PriceReportDraftCopyWithImpl<PriceReportDraft>(this as PriceReportDraft, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PriceReportDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceReportDraft&&(identical(other.stationId, _this.stationId) || other.stationId == _this.stationId)&&(identical(other.stationName, _this.stationName) || other.stationName == _this.stationName)&&(identical(other.stationLocation, _this.stationLocation) || other.stationLocation == _this.stationLocation)&&(identical(other.fuelType, _this.fuelType) || other.fuelType == _this.fuelType)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.currencyCode, _this.currencyCode) || other.currencyCode == _this.currencyCode));
}


@override
int get hashCode {
  final _this = this as PriceReportDraft;
  return Object.hash(runtimeType,_this.stationId,_this.stationName,_this.stationLocation,_this.fuelType,_this.price,_this.currencyCode);
}

@override
String toString() {
  final _this = this as PriceReportDraft;
  return 'PriceReportDraft(stationId: ${_this.stationId}, stationName: ${_this.stationName}, stationLocation: ${_this.stationLocation}, fuelType: ${_this.fuelType}, price: ${_this.price}, currencyCode: ${_this.currencyCode})';
}


}

/// @nodoc
abstract mixin class $PriceReportDraftCopyWith<$Res>  {
  factory $PriceReportDraftCopyWith(PriceReportDraft value, $Res Function(PriceReportDraft) _then) = _$PriceReportDraftCopyWithImpl;
@useResult
$Res call({
 String stationId, String? stationName, GeoPoint stationLocation, String fuelType, double price, String currencyCode
});


$GeoPointCopyWith<$Res> get stationLocation;

}
/// @nodoc
class _$PriceReportDraftCopyWithImpl<$Res>
    implements $PriceReportDraftCopyWith<$Res> {
  _$PriceReportDraftCopyWithImpl(this._self, this._then);

  final PriceReportDraft _self;
  final $Res Function(PriceReportDraft) _then;

/// Create a copy of PriceReportDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stationId = null,Object? stationName = freezed,Object? stationLocation = null,Object? fuelType = null,Object? price = null,Object? currencyCode = null,}) {
  return _then(PriceReportDraft(
stationId: null == stationId ? _self.stationId : stationId // ignore: cast_nullable_to_non_nullable
as String,stationName: freezed == stationName ? _self.stationName : stationName // ignore: cast_nullable_to_non_nullable
as String?,stationLocation: null == stationLocation ? _self.stationLocation : stationLocation // ignore: cast_nullable_to_non_nullable
as GeoPoint,fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of PriceReportDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res> get stationLocation {
  
  return $GeoPointCopyWith<$Res>(_self.stationLocation, (value) {
    return _then(_self.copyWith(stationLocation: value));
  });
}
}


/// Adds pattern-matching-related methods to [PriceReportDraft].
extension PriceReportDraftPatterns on PriceReportDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceReportDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceReportDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceReportDraft value)  $default,){
final _that = this;
switch (_that) {
case _PriceReportDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceReportDraft value)?  $default,){
final _that = this;
switch (_that) {
case _PriceReportDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String stationId,  String? stationName,  GeoPoint stationLocation,  String fuelType,  double price,  String currencyCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PriceReportDraft() when $default != null:
return $default(_that.stationId,_that.stationName,_that.stationLocation,_that.fuelType,_that.price,_that.currencyCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String stationId,  String? stationName,  GeoPoint stationLocation,  String fuelType,  double price,  String currencyCode)  $default,) {final _that = this;
switch (_that) {
case _PriceReportDraft():
return $default(_that.stationId,_that.stationName,_that.stationLocation,_that.fuelType,_that.price,_that.currencyCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String stationId,  String? stationName,  GeoPoint stationLocation,  String fuelType,  double price,  String currencyCode)?  $default,) {final _that = this;
switch (_that) {
case _PriceReportDraft() when $default != null:
return $default(_that.stationId,_that.stationName,_that.stationLocation,_that.fuelType,_that.price,_that.currencyCode);case _:
  return null;

}
}

}

/// @nodoc


class _PriceReportDraft implements PriceReportDraft {
  const _PriceReportDraft({required this.stationId, this.stationName, required this.stationLocation, required this.fuelType, required this.price, required this.currencyCode});
  

@override final  String stationId;
@override final  String? stationName;
@override final  GeoPoint stationLocation;
@override final  String fuelType;
@override final  double price;
@override final  String currencyCode;

/// Create a copy of PriceReportDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceReportDraftCopyWith<_PriceReportDraft> get copyWith => __$PriceReportDraftCopyWithImpl<_PriceReportDraft>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceReportDraft&&(identical(other.stationId, stationId) || other.stationId == stationId)&&(identical(other.stationName, stationName) || other.stationName == stationName)&&(identical(other.stationLocation, stationLocation) || other.stationLocation == stationLocation)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.price, price) || other.price == price)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode));
}


@override
int get hashCode {
    return Object.hash(runtimeType,stationId,stationName,stationLocation,fuelType,price,currencyCode);
}

@override
String toString() {
    return 'PriceReportDraft(stationId: $stationId, stationName: $stationName, stationLocation: $stationLocation, fuelType: $fuelType, price: $price, currencyCode: $currencyCode)';
}


}

/// @nodoc
abstract mixin class _$PriceReportDraftCopyWith<$Res> implements $PriceReportDraftCopyWith<$Res> {
  factory _$PriceReportDraftCopyWith(_PriceReportDraft value, $Res Function(_PriceReportDraft) _then) = __$PriceReportDraftCopyWithImpl;
@override @useResult
$Res call({
 String stationId, String? stationName, GeoPoint stationLocation, String fuelType, double price, String currencyCode
});


@override $GeoPointCopyWith<$Res> get stationLocation;

}
/// @nodoc
class __$PriceReportDraftCopyWithImpl<$Res>
    implements _$PriceReportDraftCopyWith<$Res> {
  __$PriceReportDraftCopyWithImpl(this._self, this._then);

  final _PriceReportDraft _self;
  final $Res Function(_PriceReportDraft) _then;

/// Create a copy of PriceReportDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stationId = null,Object? stationName = freezed,Object? stationLocation = null,Object? fuelType = null,Object? price = null,Object? currencyCode = null,}) {
  return _then(_PriceReportDraft(
stationId: null == stationId ? _self.stationId : stationId // ignore: cast_nullable_to_non_nullable
as String,stationName: freezed == stationName ? _self.stationName : stationName // ignore: cast_nullable_to_non_nullable
as String?,stationLocation: null == stationLocation ? _self.stationLocation : stationLocation // ignore: cast_nullable_to_non_nullable
as GeoPoint,fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of PriceReportDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res> get stationLocation {
  
  return $GeoPointCopyWith<$Res>(_self.stationLocation, (value) {
    return _then(_self.copyWith(stationLocation: value));
  });
}
}

/// @nodoc
mixin _$StationVote {

 bool? get open; bool? get fuelAvailable;
/// Create a copy of StationVote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StationVoteCopyWith<StationVote> get copyWith => _$StationVoteCopyWithImpl<StationVote>(this as StationVote, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StationVote;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StationVote&&(identical(other.open, _this.open) || other.open == _this.open)&&(identical(other.fuelAvailable, _this.fuelAvailable) || other.fuelAvailable == _this.fuelAvailable));
}


@override
int get hashCode {
  final _this = this as StationVote;
  return Object.hash(runtimeType,_this.open,_this.fuelAvailable);
}

@override
String toString() {
  final _this = this as StationVote;
  return 'StationVote(open: ${_this.open}, fuelAvailable: ${_this.fuelAvailable})';
}


}

/// @nodoc
abstract mixin class $StationVoteCopyWith<$Res>  {
  factory $StationVoteCopyWith(StationVote value, $Res Function(StationVote) _then) = _$StationVoteCopyWithImpl;
@useResult
$Res call({
 bool? open, bool? fuelAvailable
});




}
/// @nodoc
class _$StationVoteCopyWithImpl<$Res>
    implements $StationVoteCopyWith<$Res> {
  _$StationVoteCopyWithImpl(this._self, this._then);

  final StationVote _self;
  final $Res Function(StationVote) _then;

/// Create a copy of StationVote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? open = freezed,Object? fuelAvailable = freezed,}) {
  return _then(StationVote(
open: freezed == open ? _self.open : open // ignore: cast_nullable_to_non_nullable
as bool?,fuelAvailable: freezed == fuelAvailable ? _self.fuelAvailable : fuelAvailable // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [StationVote].
extension StationVotePatterns on StationVote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StationVote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StationVote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StationVote value)  $default,){
final _that = this;
switch (_that) {
case _StationVote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StationVote value)?  $default,){
final _that = this;
switch (_that) {
case _StationVote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? open,  bool? fuelAvailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StationVote() when $default != null:
return $default(_that.open,_that.fuelAvailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? open,  bool? fuelAvailable)  $default,) {final _that = this;
switch (_that) {
case _StationVote():
return $default(_that.open,_that.fuelAvailable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? open,  bool? fuelAvailable)?  $default,) {final _that = this;
switch (_that) {
case _StationVote() when $default != null:
return $default(_that.open,_that.fuelAvailable);case _:
  return null;

}
}

}

/// @nodoc


class _StationVote implements StationVote {
  const _StationVote({this.open, this.fuelAvailable});
  

@override final  bool? open;
@override final  bool? fuelAvailable;

/// Create a copy of StationVote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StationVoteCopyWith<_StationVote> get copyWith => __$StationVoteCopyWithImpl<_StationVote>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StationVote&&(identical(other.open, open) || other.open == open)&&(identical(other.fuelAvailable, fuelAvailable) || other.fuelAvailable == fuelAvailable));
}


@override
int get hashCode {
    return Object.hash(runtimeType,open,fuelAvailable);
}

@override
String toString() {
    return 'StationVote(open: $open, fuelAvailable: $fuelAvailable)';
}


}

/// @nodoc
abstract mixin class _$StationVoteCopyWith<$Res> implements $StationVoteCopyWith<$Res> {
  factory _$StationVoteCopyWith(_StationVote value, $Res Function(_StationVote) _then) = __$StationVoteCopyWithImpl;
@override @useResult
$Res call({
 bool? open, bool? fuelAvailable
});




}
/// @nodoc
class __$StationVoteCopyWithImpl<$Res>
    implements _$StationVoteCopyWith<$Res> {
  __$StationVoteCopyWithImpl(this._self, this._then);

  final _StationVote _self;
  final $Res Function(_StationVote) _then;

/// Create a copy of StationVote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? open = freezed,Object? fuelAvailable = freezed,}) {
  return _then(_StationVote(
open: freezed == open ? _self.open : open // ignore: cast_nullable_to_non_nullable
as bool?,fuelAvailable: freezed == fuelAvailable ? _self.fuelAvailable : fuelAvailable // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

/// @nodoc
mixin _$PriceAlertRule {

 String get id; String get fuelType; String get currencyCode; double get maxPrice; GeoPoint get center; double get radiusKm; bool get enabled;/// Optional: only this station.
 String? get stationId; String? get stationName;
/// Create a copy of PriceAlertRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceAlertRuleCopyWith<PriceAlertRule> get copyWith => _$PriceAlertRuleCopyWithImpl<PriceAlertRule>(this as PriceAlertRule, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PriceAlertRule;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceAlertRule&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.fuelType, _this.fuelType) || other.fuelType == _this.fuelType)&&(identical(other.currencyCode, _this.currencyCode) || other.currencyCode == _this.currencyCode)&&(identical(other.maxPrice, _this.maxPrice) || other.maxPrice == _this.maxPrice)&&(identical(other.center, _this.center) || other.center == _this.center)&&(identical(other.radiusKm, _this.radiusKm) || other.radiusKm == _this.radiusKm)&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled)&&(identical(other.stationId, _this.stationId) || other.stationId == _this.stationId)&&(identical(other.stationName, _this.stationName) || other.stationName == _this.stationName));
}


@override
int get hashCode {
  final _this = this as PriceAlertRule;
  return Object.hash(runtimeType,_this.id,_this.fuelType,_this.currencyCode,_this.maxPrice,_this.center,_this.radiusKm,_this.enabled,_this.stationId,_this.stationName);
}

@override
String toString() {
  final _this = this as PriceAlertRule;
  return 'PriceAlertRule(id: ${_this.id}, fuelType: ${_this.fuelType}, currencyCode: ${_this.currencyCode}, maxPrice: ${_this.maxPrice}, center: ${_this.center}, radiusKm: ${_this.radiusKm}, enabled: ${_this.enabled}, stationId: ${_this.stationId}, stationName: ${_this.stationName})';
}


}

/// @nodoc
abstract mixin class $PriceAlertRuleCopyWith<$Res>  {
  factory $PriceAlertRuleCopyWith(PriceAlertRule value, $Res Function(PriceAlertRule) _then) = _$PriceAlertRuleCopyWithImpl;
@useResult
$Res call({
 String id, String fuelType, String currencyCode, double maxPrice, GeoPoint center, double radiusKm, bool enabled, String? stationId, String? stationName
});


$GeoPointCopyWith<$Res> get center;

}
/// @nodoc
class _$PriceAlertRuleCopyWithImpl<$Res>
    implements $PriceAlertRuleCopyWith<$Res> {
  _$PriceAlertRuleCopyWithImpl(this._self, this._then);

  final PriceAlertRule _self;
  final $Res Function(PriceAlertRule) _then;

/// Create a copy of PriceAlertRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fuelType = null,Object? currencyCode = null,Object? maxPrice = null,Object? center = null,Object? radiusKm = null,Object? enabled = null,Object? stationId = freezed,Object? stationName = freezed,}) {
  return _then(PriceAlertRule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as String,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,maxPrice: null == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as double,center: null == center ? _self.center : center // ignore: cast_nullable_to_non_nullable
as GeoPoint,radiusKm: null == radiusKm ? _self.radiusKm : radiusKm // ignore: cast_nullable_to_non_nullable
as double,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,stationId: freezed == stationId ? _self.stationId : stationId // ignore: cast_nullable_to_non_nullable
as String?,stationName: freezed == stationName ? _self.stationName : stationName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of PriceAlertRule
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res> get center {
  
  return $GeoPointCopyWith<$Res>(_self.center, (value) {
    return _then(_self.copyWith(center: value));
  });
}
}


/// Adds pattern-matching-related methods to [PriceAlertRule].
extension PriceAlertRulePatterns on PriceAlertRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceAlertRule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceAlertRule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceAlertRule value)  $default,){
final _that = this;
switch (_that) {
case _PriceAlertRule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceAlertRule value)?  $default,){
final _that = this;
switch (_that) {
case _PriceAlertRule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fuelType,  String currencyCode,  double maxPrice,  GeoPoint center,  double radiusKm,  bool enabled,  String? stationId,  String? stationName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PriceAlertRule() when $default != null:
return $default(_that.id,_that.fuelType,_that.currencyCode,_that.maxPrice,_that.center,_that.radiusKm,_that.enabled,_that.stationId,_that.stationName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fuelType,  String currencyCode,  double maxPrice,  GeoPoint center,  double radiusKm,  bool enabled,  String? stationId,  String? stationName)  $default,) {final _that = this;
switch (_that) {
case _PriceAlertRule():
return $default(_that.id,_that.fuelType,_that.currencyCode,_that.maxPrice,_that.center,_that.radiusKm,_that.enabled,_that.stationId,_that.stationName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fuelType,  String currencyCode,  double maxPrice,  GeoPoint center,  double radiusKm,  bool enabled,  String? stationId,  String? stationName)?  $default,) {final _that = this;
switch (_that) {
case _PriceAlertRule() when $default != null:
return $default(_that.id,_that.fuelType,_that.currencyCode,_that.maxPrice,_that.center,_that.radiusKm,_that.enabled,_that.stationId,_that.stationName);case _:
  return null;

}
}

}

/// @nodoc


class _PriceAlertRule implements PriceAlertRule {
  const _PriceAlertRule({required this.id, required this.fuelType, required this.currencyCode, required this.maxPrice, required this.center, required this.radiusKm, this.enabled = true, this.stationId, this.stationName});
  

@override final  String id;
@override final  String fuelType;
@override final  String currencyCode;
@override final  double maxPrice;
@override final  GeoPoint center;
@override final  double radiusKm;
@override@JsonKey() final  bool enabled;
/// Optional: only this station.
@override final  String? stationId;
@override final  String? stationName;

/// Create a copy of PriceAlertRule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceAlertRuleCopyWith<_PriceAlertRule> get copyWith => __$PriceAlertRuleCopyWithImpl<_PriceAlertRule>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceAlertRule&&(identical(other.id, id) || other.id == id)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.maxPrice, maxPrice) || other.maxPrice == maxPrice)&&(identical(other.center, center) || other.center == center)&&(identical(other.radiusKm, radiusKm) || other.radiusKm == radiusKm)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.stationId, stationId) || other.stationId == stationId)&&(identical(other.stationName, stationName) || other.stationName == stationName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,fuelType,currencyCode,maxPrice,center,radiusKm,enabled,stationId,stationName);
}

@override
String toString() {
    return 'PriceAlertRule(id: $id, fuelType: $fuelType, currencyCode: $currencyCode, maxPrice: $maxPrice, center: $center, radiusKm: $radiusKm, enabled: $enabled, stationId: $stationId, stationName: $stationName)';
}


}

/// @nodoc
abstract mixin class _$PriceAlertRuleCopyWith<$Res> implements $PriceAlertRuleCopyWith<$Res> {
  factory _$PriceAlertRuleCopyWith(_PriceAlertRule value, $Res Function(_PriceAlertRule) _then) = __$PriceAlertRuleCopyWithImpl;
@override @useResult
$Res call({
 String id, String fuelType, String currencyCode, double maxPrice, GeoPoint center, double radiusKm, bool enabled, String? stationId, String? stationName
});


@override $GeoPointCopyWith<$Res> get center;

}
/// @nodoc
class __$PriceAlertRuleCopyWithImpl<$Res>
    implements _$PriceAlertRuleCopyWith<$Res> {
  __$PriceAlertRuleCopyWithImpl(this._self, this._then);

  final _PriceAlertRule _self;
  final $Res Function(_PriceAlertRule) _then;

/// Create a copy of PriceAlertRule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fuelType = null,Object? currencyCode = null,Object? maxPrice = null,Object? center = null,Object? radiusKm = null,Object? enabled = null,Object? stationId = freezed,Object? stationName = freezed,}) {
  return _then(_PriceAlertRule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as String,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,maxPrice: null == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as double,center: null == center ? _self.center : center // ignore: cast_nullable_to_non_nullable
as GeoPoint,radiusKm: null == radiusKm ? _self.radiusKm : radiusKm // ignore: cast_nullable_to_non_nullable
as double,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,stationId: freezed == stationId ? _self.stationId : stationId // ignore: cast_nullable_to_non_nullable
as String?,stationName: freezed == stationName ? _self.stationName : stationName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of PriceAlertRule
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res> get center {
  
  return $GeoPointCopyWith<$Res>(_self.center, (value) {
    return _then(_self.copyWith(center: value));
  });
}
}

// dart format on
