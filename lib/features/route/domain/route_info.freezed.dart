// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RouteInfo {

 double get distanceMeters; double get durationSeconds; List<GeoPoint> get points;
/// Create a copy of RouteInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteInfoCopyWith<RouteInfo> get copyWith => _$RouteInfoCopyWithImpl<RouteInfo>(this as RouteInfo, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RouteInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteInfo&&(identical(other.distanceMeters, _this.distanceMeters) || other.distanceMeters == _this.distanceMeters)&&(identical(other.durationSeconds, _this.durationSeconds) || other.durationSeconds == _this.durationSeconds)&&const DeepCollectionEquality().equals(other.points, _this.points));
}


@override
int get hashCode {
  final _this = this as RouteInfo;
  return Object.hash(runtimeType,_this.distanceMeters,_this.durationSeconds,const DeepCollectionEquality().hash(_this.points));
}

@override
String toString() {
  final _this = this as RouteInfo;
  return 'RouteInfo(distanceMeters: ${_this.distanceMeters}, durationSeconds: ${_this.durationSeconds}, points: ${_this.points})';
}


}

/// @nodoc
abstract mixin class $RouteInfoCopyWith<$Res>  {
  factory $RouteInfoCopyWith(RouteInfo value, $Res Function(RouteInfo) _then) = _$RouteInfoCopyWithImpl;
@useResult
$Res call({
 double distanceMeters, double durationSeconds, List<GeoPoint> points
});




}
/// @nodoc
class _$RouteInfoCopyWithImpl<$Res>
    implements $RouteInfoCopyWith<$Res> {
  _$RouteInfoCopyWithImpl(this._self, this._then);

  final RouteInfo _self;
  final $Res Function(RouteInfo) _then;

/// Create a copy of RouteInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? distanceMeters = null,Object? durationSeconds = null,Object? points = null,}) {
  return _then(RouteInfo(
distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as double,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<GeoPoint>,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteInfo].
extension RouteInfoPatterns on RouteInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteInfo value)  $default,){
final _that = this;
switch (_that) {
case _RouteInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteInfo value)?  $default,){
final _that = this;
switch (_that) {
case _RouteInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double distanceMeters,  double durationSeconds,  List<GeoPoint> points)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteInfo() when $default != null:
return $default(_that.distanceMeters,_that.durationSeconds,_that.points);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double distanceMeters,  double durationSeconds,  List<GeoPoint> points)  $default,) {final _that = this;
switch (_that) {
case _RouteInfo():
return $default(_that.distanceMeters,_that.durationSeconds,_that.points);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double distanceMeters,  double durationSeconds,  List<GeoPoint> points)?  $default,) {final _that = this;
switch (_that) {
case _RouteInfo() when $default != null:
return $default(_that.distanceMeters,_that.durationSeconds,_that.points);case _:
  return null;

}
}

}

/// @nodoc


class _RouteInfo extends RouteInfo {
  const _RouteInfo({required this.distanceMeters, required this.durationSeconds, required  List<GeoPoint> points}): _points = points,super._();
  

@override final  double distanceMeters;
@override final  double durationSeconds;
 final  List<GeoPoint> _points;
@override List<GeoPoint> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}


/// Create a copy of RouteInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteInfoCopyWith<_RouteInfo> get copyWith => __$RouteInfoCopyWithImpl<_RouteInfo>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteInfo&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&const DeepCollectionEquality().equals(other.points, _points));
}


@override
int get hashCode {
    return Object.hash(runtimeType,distanceMeters,durationSeconds,const DeepCollectionEquality().hash(_points));
}

@override
String toString() {
    return 'RouteInfo(distanceMeters: $distanceMeters, durationSeconds: $durationSeconds, points: $points)';
}


}

/// @nodoc
abstract mixin class _$RouteInfoCopyWith<$Res> implements $RouteInfoCopyWith<$Res> {
  factory _$RouteInfoCopyWith(_RouteInfo value, $Res Function(_RouteInfo) _then) = __$RouteInfoCopyWithImpl;
@override @useResult
$Res call({
 double distanceMeters, double durationSeconds, List<GeoPoint> points
});




}
/// @nodoc
class __$RouteInfoCopyWithImpl<$Res>
    implements _$RouteInfoCopyWith<$Res> {
  __$RouteInfoCopyWithImpl(this._self, this._then);

  final _RouteInfo _self;
  final $Res Function(_RouteInfo) _then;

/// Create a copy of RouteInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? distanceMeters = null,Object? durationSeconds = null,Object? points = null,}) {
  return _then(_RouteInfo(
distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as double,points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<GeoPoint>,
  ));
}


}

// dart format on
