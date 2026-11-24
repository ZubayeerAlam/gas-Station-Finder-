// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ranking_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StationOffer {

 String get stationId; String get name;/// Extra driving distance caused by stopping here (vs. not stopping).
/// Along a route: route-via-station minus direct route.
/// Nearby mode: drive there and back.
 double get detourMeters;/// Extra driving time, if known.
 double? get detourSeconds;/// Driving distance from the current position to the station, if known
/// (used for reachability on the current tank/charge).
 double? get distanceToStationMeters;/// Price per litre (fuel) or per kWh (EV). Null = unknown — never guessed.
 double? get pricePerUnit; String? get currencyCode; PriceSource? get priceSource; DateTime? get priceUpdatedAt;/// Null = unknown.
 bool? get openNow;/// 0..1 community/data reliability score, null = unknown (Phase 1.7).
 double? get reliability;
/// Create a copy of StationOffer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StationOfferCopyWith<StationOffer> get copyWith => _$StationOfferCopyWithImpl<StationOffer>(this as StationOffer, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StationOffer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StationOffer&&(identical(other.stationId, _this.stationId) || other.stationId == _this.stationId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.detourMeters, _this.detourMeters) || other.detourMeters == _this.detourMeters)&&(identical(other.detourSeconds, _this.detourSeconds) || other.detourSeconds == _this.detourSeconds)&&(identical(other.distanceToStationMeters, _this.distanceToStationMeters) || other.distanceToStationMeters == _this.distanceToStationMeters)&&(identical(other.pricePerUnit, _this.pricePerUnit) || other.pricePerUnit == _this.pricePerUnit)&&(identical(other.currencyCode, _this.currencyCode) || other.currencyCode == _this.currencyCode)&&(identical(other.priceSource, _this.priceSource) || other.priceSource == _this.priceSource)&&(identical(other.priceUpdatedAt, _this.priceUpdatedAt) || other.priceUpdatedAt == _this.priceUpdatedAt)&&(identical(other.openNow, _this.openNow) || other.openNow == _this.openNow)&&(identical(other.reliability, _this.reliability) || other.reliability == _this.reliability));
}


@override
int get hashCode {
  final _this = this as StationOffer;
  return Object.hash(runtimeType,_this.stationId,_this.name,_this.detourMeters,_this.detourSeconds,_this.distanceToStationMeters,_this.pricePerUnit,_this.currencyCode,_this.priceSource,_this.priceUpdatedAt,_this.openNow,_this.reliability);
}

@override
String toString() {
  final _this = this as StationOffer;
  return 'StationOffer(stationId: ${_this.stationId}, name: ${_this.name}, detourMeters: ${_this.detourMeters}, detourSeconds: ${_this.detourSeconds}, distanceToStationMeters: ${_this.distanceToStationMeters}, pricePerUnit: ${_this.pricePerUnit}, currencyCode: ${_this.currencyCode}, priceSource: ${_this.priceSource}, priceUpdatedAt: ${_this.priceUpdatedAt}, openNow: ${_this.openNow}, reliability: ${_this.reliability})';
}


}

/// @nodoc
abstract mixin class $StationOfferCopyWith<$Res>  {
  factory $StationOfferCopyWith(StationOffer value, $Res Function(StationOffer) _then) = _$StationOfferCopyWithImpl;
@useResult
$Res call({
 String stationId, String name, double detourMeters, double? detourSeconds, double? distanceToStationMeters, double? pricePerUnit, String? currencyCode, PriceSource? priceSource, DateTime? priceUpdatedAt, bool? openNow, double? reliability
});




}
/// @nodoc
class _$StationOfferCopyWithImpl<$Res>
    implements $StationOfferCopyWith<$Res> {
  _$StationOfferCopyWithImpl(this._self, this._then);

  final StationOffer _self;
  final $Res Function(StationOffer) _then;

/// Create a copy of StationOffer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stationId = null,Object? name = null,Object? detourMeters = null,Object? detourSeconds = freezed,Object? distanceToStationMeters = freezed,Object? pricePerUnit = freezed,Object? currencyCode = freezed,Object? priceSource = freezed,Object? priceUpdatedAt = freezed,Object? openNow = freezed,Object? reliability = freezed,}) {
  return _then(StationOffer(
stationId: null == stationId ? _self.stationId : stationId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,detourMeters: null == detourMeters ? _self.detourMeters : detourMeters // ignore: cast_nullable_to_non_nullable
as double,detourSeconds: freezed == detourSeconds ? _self.detourSeconds : detourSeconds // ignore: cast_nullable_to_non_nullable
as double?,distanceToStationMeters: freezed == distanceToStationMeters ? _self.distanceToStationMeters : distanceToStationMeters // ignore: cast_nullable_to_non_nullable
as double?,pricePerUnit: freezed == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as double?,currencyCode: freezed == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String?,priceSource: freezed == priceSource ? _self.priceSource : priceSource // ignore: cast_nullable_to_non_nullable
as PriceSource?,priceUpdatedAt: freezed == priceUpdatedAt ? _self.priceUpdatedAt : priceUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,openNow: freezed == openNow ? _self.openNow : openNow // ignore: cast_nullable_to_non_nullable
as bool?,reliability: freezed == reliability ? _self.reliability : reliability // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [StationOffer].
extension StationOfferPatterns on StationOffer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StationOffer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StationOffer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StationOffer value)  $default,){
final _that = this;
switch (_that) {
case _StationOffer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StationOffer value)?  $default,){
final _that = this;
switch (_that) {
case _StationOffer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String stationId,  String name,  double detourMeters,  double? detourSeconds,  double? distanceToStationMeters,  double? pricePerUnit,  String? currencyCode,  PriceSource? priceSource,  DateTime? priceUpdatedAt,  bool? openNow,  double? reliability)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StationOffer() when $default != null:
return $default(_that.stationId,_that.name,_that.detourMeters,_that.detourSeconds,_that.distanceToStationMeters,_that.pricePerUnit,_that.currencyCode,_that.priceSource,_that.priceUpdatedAt,_that.openNow,_that.reliability);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String stationId,  String name,  double detourMeters,  double? detourSeconds,  double? distanceToStationMeters,  double? pricePerUnit,  String? currencyCode,  PriceSource? priceSource,  DateTime? priceUpdatedAt,  bool? openNow,  double? reliability)  $default,) {final _that = this;
switch (_that) {
case _StationOffer():
return $default(_that.stationId,_that.name,_that.detourMeters,_that.detourSeconds,_that.distanceToStationMeters,_that.pricePerUnit,_that.currencyCode,_that.priceSource,_that.priceUpdatedAt,_that.openNow,_that.reliability);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String stationId,  String name,  double detourMeters,  double? detourSeconds,  double? distanceToStationMeters,  double? pricePerUnit,  String? currencyCode,  PriceSource? priceSource,  DateTime? priceUpdatedAt,  bool? openNow,  double? reliability)?  $default,) {final _that = this;
switch (_that) {
case _StationOffer() when $default != null:
return $default(_that.stationId,_that.name,_that.detourMeters,_that.detourSeconds,_that.distanceToStationMeters,_that.pricePerUnit,_that.currencyCode,_that.priceSource,_that.priceUpdatedAt,_that.openNow,_that.reliability);case _:
  return null;

}
}

}

/// @nodoc


class _StationOffer implements StationOffer {
  const _StationOffer({required this.stationId, required this.name, required this.detourMeters, this.detourSeconds, this.distanceToStationMeters, this.pricePerUnit, this.currencyCode, this.priceSource, this.priceUpdatedAt, this.openNow, this.reliability});
  

@override final  String stationId;
@override final  String name;
/// Extra driving distance caused by stopping here (vs. not stopping).
/// Along a route: route-via-station minus direct route.
/// Nearby mode: drive there and back.
@override final  double detourMeters;
/// Extra driving time, if known.
@override final  double? detourSeconds;
/// Driving distance from the current position to the station, if known
/// (used for reachability on the current tank/charge).
@override final  double? distanceToStationMeters;
/// Price per litre (fuel) or per kWh (EV). Null = unknown — never guessed.
@override final  double? pricePerUnit;
@override final  String? currencyCode;
@override final  PriceSource? priceSource;
@override final  DateTime? priceUpdatedAt;
/// Null = unknown.
@override final  bool? openNow;
/// 0..1 community/data reliability score, null = unknown (Phase 1.7).
@override final  double? reliability;

/// Create a copy of StationOffer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StationOfferCopyWith<_StationOffer> get copyWith => __$StationOfferCopyWithImpl<_StationOffer>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StationOffer&&(identical(other.stationId, stationId) || other.stationId == stationId)&&(identical(other.name, name) || other.name == name)&&(identical(other.detourMeters, detourMeters) || other.detourMeters == detourMeters)&&(identical(other.detourSeconds, detourSeconds) || other.detourSeconds == detourSeconds)&&(identical(other.distanceToStationMeters, distanceToStationMeters) || other.distanceToStationMeters == distanceToStationMeters)&&(identical(other.pricePerUnit, pricePerUnit) || other.pricePerUnit == pricePerUnit)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.priceSource, priceSource) || other.priceSource == priceSource)&&(identical(other.priceUpdatedAt, priceUpdatedAt) || other.priceUpdatedAt == priceUpdatedAt)&&(identical(other.openNow, openNow) || other.openNow == openNow)&&(identical(other.reliability, reliability) || other.reliability == reliability));
}


@override
int get hashCode {
    return Object.hash(runtimeType,stationId,name,detourMeters,detourSeconds,distanceToStationMeters,pricePerUnit,currencyCode,priceSource,priceUpdatedAt,openNow,reliability);
}

@override
String toString() {
    return 'StationOffer(stationId: $stationId, name: $name, detourMeters: $detourMeters, detourSeconds: $detourSeconds, distanceToStationMeters: $distanceToStationMeters, pricePerUnit: $pricePerUnit, currencyCode: $currencyCode, priceSource: $priceSource, priceUpdatedAt: $priceUpdatedAt, openNow: $openNow, reliability: $reliability)';
}


}

/// @nodoc
abstract mixin class _$StationOfferCopyWith<$Res> implements $StationOfferCopyWith<$Res> {
  factory _$StationOfferCopyWith(_StationOffer value, $Res Function(_StationOffer) _then) = __$StationOfferCopyWithImpl;
@override @useResult
$Res call({
 String stationId, String name, double detourMeters, double? detourSeconds, double? distanceToStationMeters, double? pricePerUnit, String? currencyCode, PriceSource? priceSource, DateTime? priceUpdatedAt, bool? openNow, double? reliability
});




}
/// @nodoc
class __$StationOfferCopyWithImpl<$Res>
    implements _$StationOfferCopyWith<$Res> {
  __$StationOfferCopyWithImpl(this._self, this._then);

  final _StationOffer _self;
  final $Res Function(_StationOffer) _then;

/// Create a copy of StationOffer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stationId = null,Object? name = null,Object? detourMeters = null,Object? detourSeconds = freezed,Object? distanceToStationMeters = freezed,Object? pricePerUnit = freezed,Object? currencyCode = freezed,Object? priceSource = freezed,Object? priceUpdatedAt = freezed,Object? openNow = freezed,Object? reliability = freezed,}) {
  return _then(_StationOffer(
stationId: null == stationId ? _self.stationId : stationId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,detourMeters: null == detourMeters ? _self.detourMeters : detourMeters // ignore: cast_nullable_to_non_nullable
as double,detourSeconds: freezed == detourSeconds ? _self.detourSeconds : detourSeconds // ignore: cast_nullable_to_non_nullable
as double?,distanceToStationMeters: freezed == distanceToStationMeters ? _self.distanceToStationMeters : distanceToStationMeters // ignore: cast_nullable_to_non_nullable
as double?,pricePerUnit: freezed == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as double?,currencyCode: freezed == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String?,priceSource: freezed == priceSource ? _self.priceSource : priceSource // ignore: cast_nullable_to_non_nullable
as PriceSource?,priceUpdatedAt: freezed == priceUpdatedAt ? _self.priceUpdatedAt : priceUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,openNow: freezed == openNow ? _self.openNow : openNow // ignore: cast_nullable_to_non_nullable
as bool?,reliability: freezed == reliability ? _self.reliability : reliability // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc
mixin _$RankedStation {

 StationOffer get offer;/// Units bought (L or kWh). Null in [CostMode.unitPriceOnly].
 double? get purchaseUnits; double? get purchaseCost;/// Units (bought) needed to cover the detour itself.
 double? get detourUnits; double? get detourCost;/// purchaseCost + detourCost.
 double? get totalCost;/// Positive = cheaper than the nearest priced station (same currency).
 double? get savingsVsNearest;/// Heuristic best-value score, 0..1, bigger is better. Computed for every
/// eligible station (open/unknown and reachable); null otherwise.
 double? get valueScore; Set<RankingBadge> get badges; Set<Caveat> get caveats;
/// Create a copy of RankedStation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankedStationCopyWith<RankedStation> get copyWith => _$RankedStationCopyWithImpl<RankedStation>(this as RankedStation, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RankedStation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RankedStation&&(identical(other.offer, _this.offer) || other.offer == _this.offer)&&(identical(other.purchaseUnits, _this.purchaseUnits) || other.purchaseUnits == _this.purchaseUnits)&&(identical(other.purchaseCost, _this.purchaseCost) || other.purchaseCost == _this.purchaseCost)&&(identical(other.detourUnits, _this.detourUnits) || other.detourUnits == _this.detourUnits)&&(identical(other.detourCost, _this.detourCost) || other.detourCost == _this.detourCost)&&(identical(other.totalCost, _this.totalCost) || other.totalCost == _this.totalCost)&&(identical(other.savingsVsNearest, _this.savingsVsNearest) || other.savingsVsNearest == _this.savingsVsNearest)&&(identical(other.valueScore, _this.valueScore) || other.valueScore == _this.valueScore)&&const DeepCollectionEquality().equals(other.badges, _this.badges)&&const DeepCollectionEquality().equals(other.caveats, _this.caveats));
}


@override
int get hashCode {
  final _this = this as RankedStation;
  return Object.hash(runtimeType,_this.offer,_this.purchaseUnits,_this.purchaseCost,_this.detourUnits,_this.detourCost,_this.totalCost,_this.savingsVsNearest,_this.valueScore,const DeepCollectionEquality().hash(_this.badges),const DeepCollectionEquality().hash(_this.caveats));
}

@override
String toString() {
  final _this = this as RankedStation;
  return 'RankedStation(offer: ${_this.offer}, purchaseUnits: ${_this.purchaseUnits}, purchaseCost: ${_this.purchaseCost}, detourUnits: ${_this.detourUnits}, detourCost: ${_this.detourCost}, totalCost: ${_this.totalCost}, savingsVsNearest: ${_this.savingsVsNearest}, valueScore: ${_this.valueScore}, badges: ${_this.badges}, caveats: ${_this.caveats})';
}


}

/// @nodoc
abstract mixin class $RankedStationCopyWith<$Res>  {
  factory $RankedStationCopyWith(RankedStation value, $Res Function(RankedStation) _then) = _$RankedStationCopyWithImpl;
@useResult
$Res call({
 StationOffer offer, double? purchaseUnits, double? purchaseCost, double? detourUnits, double? detourCost, double? totalCost, double? savingsVsNearest, double? valueScore, Set<RankingBadge> badges, Set<Caveat> caveats
});


$StationOfferCopyWith<$Res> get offer;

}
/// @nodoc
class _$RankedStationCopyWithImpl<$Res>
    implements $RankedStationCopyWith<$Res> {
  _$RankedStationCopyWithImpl(this._self, this._then);

  final RankedStation _self;
  final $Res Function(RankedStation) _then;

/// Create a copy of RankedStation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? offer = null,Object? purchaseUnits = freezed,Object? purchaseCost = freezed,Object? detourUnits = freezed,Object? detourCost = freezed,Object? totalCost = freezed,Object? savingsVsNearest = freezed,Object? valueScore = freezed,Object? badges = null,Object? caveats = null,}) {
  return _then(RankedStation(
offer: null == offer ? _self.offer : offer // ignore: cast_nullable_to_non_nullable
as StationOffer,purchaseUnits: freezed == purchaseUnits ? _self.purchaseUnits : purchaseUnits // ignore: cast_nullable_to_non_nullable
as double?,purchaseCost: freezed == purchaseCost ? _self.purchaseCost : purchaseCost // ignore: cast_nullable_to_non_nullable
as double?,detourUnits: freezed == detourUnits ? _self.detourUnits : detourUnits // ignore: cast_nullable_to_non_nullable
as double?,detourCost: freezed == detourCost ? _self.detourCost : detourCost // ignore: cast_nullable_to_non_nullable
as double?,totalCost: freezed == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as double?,savingsVsNearest: freezed == savingsVsNearest ? _self.savingsVsNearest : savingsVsNearest // ignore: cast_nullable_to_non_nullable
as double?,valueScore: freezed == valueScore ? _self.valueScore : valueScore // ignore: cast_nullable_to_non_nullable
as double?,badges: null == badges ? _self.badges : badges // ignore: cast_nullable_to_non_nullable
as Set<RankingBadge>,caveats: null == caveats ? _self.caveats : caveats // ignore: cast_nullable_to_non_nullable
as Set<Caveat>,
  ));
}
/// Create a copy of RankedStation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationOfferCopyWith<$Res> get offer {
  
  return $StationOfferCopyWith<$Res>(_self.offer, (value) {
    return _then(_self.copyWith(offer: value));
  });
}
}


/// Adds pattern-matching-related methods to [RankedStation].
extension RankedStationPatterns on RankedStation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RankedStation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RankedStation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RankedStation value)  $default,){
final _that = this;
switch (_that) {
case _RankedStation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RankedStation value)?  $default,){
final _that = this;
switch (_that) {
case _RankedStation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StationOffer offer,  double? purchaseUnits,  double? purchaseCost,  double? detourUnits,  double? detourCost,  double? totalCost,  double? savingsVsNearest,  double? valueScore,  Set<RankingBadge> badges,  Set<Caveat> caveats)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RankedStation() when $default != null:
return $default(_that.offer,_that.purchaseUnits,_that.purchaseCost,_that.detourUnits,_that.detourCost,_that.totalCost,_that.savingsVsNearest,_that.valueScore,_that.badges,_that.caveats);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StationOffer offer,  double? purchaseUnits,  double? purchaseCost,  double? detourUnits,  double? detourCost,  double? totalCost,  double? savingsVsNearest,  double? valueScore,  Set<RankingBadge> badges,  Set<Caveat> caveats)  $default,) {final _that = this;
switch (_that) {
case _RankedStation():
return $default(_that.offer,_that.purchaseUnits,_that.purchaseCost,_that.detourUnits,_that.detourCost,_that.totalCost,_that.savingsVsNearest,_that.valueScore,_that.badges,_that.caveats);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StationOffer offer,  double? purchaseUnits,  double? purchaseCost,  double? detourUnits,  double? detourCost,  double? totalCost,  double? savingsVsNearest,  double? valueScore,  Set<RankingBadge> badges,  Set<Caveat> caveats)?  $default,) {final _that = this;
switch (_that) {
case _RankedStation() when $default != null:
return $default(_that.offer,_that.purchaseUnits,_that.purchaseCost,_that.detourUnits,_that.detourCost,_that.totalCost,_that.savingsVsNearest,_that.valueScore,_that.badges,_that.caveats);case _:
  return null;

}
}

}

/// @nodoc


class _RankedStation implements RankedStation {
  const _RankedStation({required this.offer, this.purchaseUnits, this.purchaseCost, this.detourUnits, this.detourCost, this.totalCost, this.savingsVsNearest, this.valueScore,  Set<RankingBadge> badges = const <RankingBadge>{},  Set<Caveat> caveats = const <Caveat>{}}): _badges = badges,_caveats = caveats;
  

@override final  StationOffer offer;
/// Units bought (L or kWh). Null in [CostMode.unitPriceOnly].
@override final  double? purchaseUnits;
@override final  double? purchaseCost;
/// Units (bought) needed to cover the detour itself.
@override final  double? detourUnits;
@override final  double? detourCost;
/// purchaseCost + detourCost.
@override final  double? totalCost;
/// Positive = cheaper than the nearest priced station (same currency).
@override final  double? savingsVsNearest;
/// Heuristic best-value score, 0..1, bigger is better. Computed for every
/// eligible station (open/unknown and reachable); null otherwise.
@override final  double? valueScore;
 final  Set<RankingBadge> _badges;
@override@JsonKey() Set<RankingBadge> get badges {
  if (_badges is EqualUnmodifiableSetView) return _badges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_badges);
}

 final  Set<Caveat> _caveats;
@override@JsonKey() Set<Caveat> get caveats {
  if (_caveats is EqualUnmodifiableSetView) return _caveats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_caveats);
}


/// Create a copy of RankedStation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankedStationCopyWith<_RankedStation> get copyWith => __$RankedStationCopyWithImpl<_RankedStation>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RankedStation&&(identical(other.offer, offer) || other.offer == offer)&&(identical(other.purchaseUnits, purchaseUnits) || other.purchaseUnits == purchaseUnits)&&(identical(other.purchaseCost, purchaseCost) || other.purchaseCost == purchaseCost)&&(identical(other.detourUnits, detourUnits) || other.detourUnits == detourUnits)&&(identical(other.detourCost, detourCost) || other.detourCost == detourCost)&&(identical(other.totalCost, totalCost) || other.totalCost == totalCost)&&(identical(other.savingsVsNearest, savingsVsNearest) || other.savingsVsNearest == savingsVsNearest)&&(identical(other.valueScore, valueScore) || other.valueScore == valueScore)&&const DeepCollectionEquality().equals(other.badges, _badges)&&const DeepCollectionEquality().equals(other.caveats, _caveats));
}


@override
int get hashCode {
    return Object.hash(runtimeType,offer,purchaseUnits,purchaseCost,detourUnits,detourCost,totalCost,savingsVsNearest,valueScore,const DeepCollectionEquality().hash(_badges),const DeepCollectionEquality().hash(_caveats));
}

@override
String toString() {
    return 'RankedStation(offer: $offer, purchaseUnits: $purchaseUnits, purchaseCost: $purchaseCost, detourUnits: $detourUnits, detourCost: $detourCost, totalCost: $totalCost, savingsVsNearest: $savingsVsNearest, valueScore: $valueScore, badges: $badges, caveats: $caveats)';
}


}

/// @nodoc
abstract mixin class _$RankedStationCopyWith<$Res> implements $RankedStationCopyWith<$Res> {
  factory _$RankedStationCopyWith(_RankedStation value, $Res Function(_RankedStation) _then) = __$RankedStationCopyWithImpl;
@override @useResult
$Res call({
 StationOffer offer, double? purchaseUnits, double? purchaseCost, double? detourUnits, double? detourCost, double? totalCost, double? savingsVsNearest, double? valueScore, Set<RankingBadge> badges, Set<Caveat> caveats
});


@override $StationOfferCopyWith<$Res> get offer;

}
/// @nodoc
class __$RankedStationCopyWithImpl<$Res>
    implements _$RankedStationCopyWith<$Res> {
  __$RankedStationCopyWithImpl(this._self, this._then);

  final _RankedStation _self;
  final $Res Function(_RankedStation) _then;

/// Create a copy of RankedStation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? offer = null,Object? purchaseUnits = freezed,Object? purchaseCost = freezed,Object? detourUnits = freezed,Object? detourCost = freezed,Object? totalCost = freezed,Object? savingsVsNearest = freezed,Object? valueScore = freezed,Object? badges = null,Object? caveats = null,}) {
  return _then(_RankedStation(
offer: null == offer ? _self.offer : offer // ignore: cast_nullable_to_non_nullable
as StationOffer,purchaseUnits: freezed == purchaseUnits ? _self.purchaseUnits : purchaseUnits // ignore: cast_nullable_to_non_nullable
as double?,purchaseCost: freezed == purchaseCost ? _self.purchaseCost : purchaseCost // ignore: cast_nullable_to_non_nullable
as double?,detourUnits: freezed == detourUnits ? _self.detourUnits : detourUnits // ignore: cast_nullable_to_non_nullable
as double?,detourCost: freezed == detourCost ? _self.detourCost : detourCost // ignore: cast_nullable_to_non_nullable
as double?,totalCost: freezed == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as double?,savingsVsNearest: freezed == savingsVsNearest ? _self.savingsVsNearest : savingsVsNearest // ignore: cast_nullable_to_non_nullable
as double?,valueScore: freezed == valueScore ? _self.valueScore : valueScore // ignore: cast_nullable_to_non_nullable
as double?,badges: null == badges ? _self._badges : badges // ignore: cast_nullable_to_non_nullable
as Set<RankingBadge>,caveats: null == caveats ? _self._caveats : caveats // ignore: cast_nullable_to_non_nullable
as Set<Caveat>,
  ));
}

/// Create a copy of RankedStation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationOfferCopyWith<$Res> get offer {
  
  return $StationOfferCopyWith<$Res>(_self.offer, (value) {
    return _then(_self.copyWith(offer: value));
  });
}
}

/// @nodoc
mixin _$RankingResult {

 CostMode get mode; RankingStrategy get strategy;/// Currency all comparable prices share (null if no prices).
 String? get currencyCode;/// Comparable stations (priced, same currency), best first.
/// Closed/unreachable ones are kept but sorted after the rest.
 List<RankedStation> get ranked;/// Stations that cannot be priced honestly (unknown price or other
/// currency), ordered by detour.
 List<RankedStation> get unpriced;/// The nearest (smallest-detour) priced station used for savings.
 String? get nearestStationId;
/// Create a copy of RankingResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankingResultCopyWith<RankingResult> get copyWith => _$RankingResultCopyWithImpl<RankingResult>(this as RankingResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RankingResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RankingResult&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.strategy, _this.strategy) || other.strategy == _this.strategy)&&(identical(other.currencyCode, _this.currencyCode) || other.currencyCode == _this.currencyCode)&&const DeepCollectionEquality().equals(other.ranked, _this.ranked)&&const DeepCollectionEquality().equals(other.unpriced, _this.unpriced)&&(identical(other.nearestStationId, _this.nearestStationId) || other.nearestStationId == _this.nearestStationId));
}


@override
int get hashCode {
  final _this = this as RankingResult;
  return Object.hash(runtimeType,_this.mode,_this.strategy,_this.currencyCode,const DeepCollectionEquality().hash(_this.ranked),const DeepCollectionEquality().hash(_this.unpriced),_this.nearestStationId);
}

@override
String toString() {
  final _this = this as RankingResult;
  return 'RankingResult(mode: ${_this.mode}, strategy: ${_this.strategy}, currencyCode: ${_this.currencyCode}, ranked: ${_this.ranked}, unpriced: ${_this.unpriced}, nearestStationId: ${_this.nearestStationId})';
}


}

/// @nodoc
abstract mixin class $RankingResultCopyWith<$Res>  {
  factory $RankingResultCopyWith(RankingResult value, $Res Function(RankingResult) _then) = _$RankingResultCopyWithImpl;
@useResult
$Res call({
 CostMode mode, RankingStrategy strategy, String? currencyCode, List<RankedStation> ranked, List<RankedStation> unpriced, String? nearestStationId
});




}
/// @nodoc
class _$RankingResultCopyWithImpl<$Res>
    implements $RankingResultCopyWith<$Res> {
  _$RankingResultCopyWithImpl(this._self, this._then);

  final RankingResult _self;
  final $Res Function(RankingResult) _then;

/// Create a copy of RankingResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? strategy = null,Object? currencyCode = freezed,Object? ranked = null,Object? unpriced = null,Object? nearestStationId = freezed,}) {
  return _then(RankingResult(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as CostMode,strategy: null == strategy ? _self.strategy : strategy // ignore: cast_nullable_to_non_nullable
as RankingStrategy,currencyCode: freezed == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String?,ranked: null == ranked ? _self.ranked : ranked // ignore: cast_nullable_to_non_nullable
as List<RankedStation>,unpriced: null == unpriced ? _self.unpriced : unpriced // ignore: cast_nullable_to_non_nullable
as List<RankedStation>,nearestStationId: freezed == nearestStationId ? _self.nearestStationId : nearestStationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RankingResult].
extension RankingResultPatterns on RankingResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RankingResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RankingResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RankingResult value)  $default,){
final _that = this;
switch (_that) {
case _RankingResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RankingResult value)?  $default,){
final _that = this;
switch (_that) {
case _RankingResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CostMode mode,  RankingStrategy strategy,  String? currencyCode,  List<RankedStation> ranked,  List<RankedStation> unpriced,  String? nearestStationId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RankingResult() when $default != null:
return $default(_that.mode,_that.strategy,_that.currencyCode,_that.ranked,_that.unpriced,_that.nearestStationId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CostMode mode,  RankingStrategy strategy,  String? currencyCode,  List<RankedStation> ranked,  List<RankedStation> unpriced,  String? nearestStationId)  $default,) {final _that = this;
switch (_that) {
case _RankingResult():
return $default(_that.mode,_that.strategy,_that.currencyCode,_that.ranked,_that.unpriced,_that.nearestStationId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CostMode mode,  RankingStrategy strategy,  String? currencyCode,  List<RankedStation> ranked,  List<RankedStation> unpriced,  String? nearestStationId)?  $default,) {final _that = this;
switch (_that) {
case _RankingResult() when $default != null:
return $default(_that.mode,_that.strategy,_that.currencyCode,_that.ranked,_that.unpriced,_that.nearestStationId);case _:
  return null;

}
}

}

/// @nodoc


class _RankingResult implements RankingResult {
  const _RankingResult({required this.mode, required this.strategy, this.currencyCode, required  List<RankedStation> ranked, required  List<RankedStation> unpriced, this.nearestStationId}): _ranked = ranked,_unpriced = unpriced;
  

@override final  CostMode mode;
@override final  RankingStrategy strategy;
/// Currency all comparable prices share (null if no prices).
@override final  String? currencyCode;
/// Comparable stations (priced, same currency), best first.
/// Closed/unreachable ones are kept but sorted after the rest.
 final  List<RankedStation> _ranked;
/// Comparable stations (priced, same currency), best first.
/// Closed/unreachable ones are kept but sorted after the rest.
@override List<RankedStation> get ranked {
  if (_ranked is EqualUnmodifiableListView) return _ranked;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ranked);
}

/// Stations that cannot be priced honestly (unknown price or other
/// currency), ordered by detour.
 final  List<RankedStation> _unpriced;
/// Stations that cannot be priced honestly (unknown price or other
/// currency), ordered by detour.
@override List<RankedStation> get unpriced {
  if (_unpriced is EqualUnmodifiableListView) return _unpriced;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_unpriced);
}

/// The nearest (smallest-detour) priced station used for savings.
@override final  String? nearestStationId;

/// Create a copy of RankingResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankingResultCopyWith<_RankingResult> get copyWith => __$RankingResultCopyWithImpl<_RankingResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RankingResult&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.strategy, strategy) || other.strategy == strategy)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&const DeepCollectionEquality().equals(other.ranked, _ranked)&&const DeepCollectionEquality().equals(other.unpriced, _unpriced)&&(identical(other.nearestStationId, nearestStationId) || other.nearestStationId == nearestStationId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,mode,strategy,currencyCode,const DeepCollectionEquality().hash(_ranked),const DeepCollectionEquality().hash(_unpriced),nearestStationId);
}

@override
String toString() {
    return 'RankingResult(mode: $mode, strategy: $strategy, currencyCode: $currencyCode, ranked: $ranked, unpriced: $unpriced, nearestStationId: $nearestStationId)';
}


}

/// @nodoc
abstract mixin class _$RankingResultCopyWith<$Res> implements $RankingResultCopyWith<$Res> {
  factory _$RankingResultCopyWith(_RankingResult value, $Res Function(_RankingResult) _then) = __$RankingResultCopyWithImpl;
@override @useResult
$Res call({
 CostMode mode, RankingStrategy strategy, String? currencyCode, List<RankedStation> ranked, List<RankedStation> unpriced, String? nearestStationId
});




}
/// @nodoc
class __$RankingResultCopyWithImpl<$Res>
    implements _$RankingResultCopyWith<$Res> {
  __$RankingResultCopyWithImpl(this._self, this._then);

  final _RankingResult _self;
  final $Res Function(_RankingResult) _then;

/// Create a copy of RankingResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? strategy = null,Object? currencyCode = freezed,Object? ranked = null,Object? unpriced = null,Object? nearestStationId = freezed,}) {
  return _then(_RankingResult(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as CostMode,strategy: null == strategy ? _self.strategy : strategy // ignore: cast_nullable_to_non_nullable
as RankingStrategy,currencyCode: freezed == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String?,ranked: null == ranked ? _self._ranked : ranked // ignore: cast_nullable_to_non_nullable
as List<RankedStation>,unpriced: null == unpriced ? _self._unpriced : unpriced // ignore: cast_nullable_to_non_nullable
as List<RankedStation>,nearestStationId: freezed == nearestStationId ? _self.nearestStationId : nearestStationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
