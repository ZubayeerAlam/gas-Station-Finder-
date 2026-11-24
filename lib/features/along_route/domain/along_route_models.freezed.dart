// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'along_route_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlaceSuggestion {

 String get placeId; String get primaryText; String? get secondaryText;
/// Create a copy of PlaceSuggestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaceSuggestionCopyWith<PlaceSuggestion> get copyWith => _$PlaceSuggestionCopyWithImpl<PlaceSuggestion>(this as PlaceSuggestion, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PlaceSuggestion;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaceSuggestion&&(identical(other.placeId, _this.placeId) || other.placeId == _this.placeId)&&(identical(other.primaryText, _this.primaryText) || other.primaryText == _this.primaryText)&&(identical(other.secondaryText, _this.secondaryText) || other.secondaryText == _this.secondaryText));
}


@override
int get hashCode {
  final _this = this as PlaceSuggestion;
  return Object.hash(runtimeType,_this.placeId,_this.primaryText,_this.secondaryText);
}

@override
String toString() {
  final _this = this as PlaceSuggestion;
  return 'PlaceSuggestion(placeId: ${_this.placeId}, primaryText: ${_this.primaryText}, secondaryText: ${_this.secondaryText})';
}


}

/// @nodoc
abstract mixin class $PlaceSuggestionCopyWith<$Res>  {
  factory $PlaceSuggestionCopyWith(PlaceSuggestion value, $Res Function(PlaceSuggestion) _then) = _$PlaceSuggestionCopyWithImpl;
@useResult
$Res call({
 String placeId, String primaryText, String? secondaryText
});




}
/// @nodoc
class _$PlaceSuggestionCopyWithImpl<$Res>
    implements $PlaceSuggestionCopyWith<$Res> {
  _$PlaceSuggestionCopyWithImpl(this._self, this._then);

  final PlaceSuggestion _self;
  final $Res Function(PlaceSuggestion) _then;

/// Create a copy of PlaceSuggestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? placeId = null,Object? primaryText = null,Object? secondaryText = freezed,}) {
  return _then(PlaceSuggestion(
placeId: null == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as String,primaryText: null == primaryText ? _self.primaryText : primaryText // ignore: cast_nullable_to_non_nullable
as String,secondaryText: freezed == secondaryText ? _self.secondaryText : secondaryText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlaceSuggestion].
extension PlaceSuggestionPatterns on PlaceSuggestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlaceSuggestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlaceSuggestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlaceSuggestion value)  $default,){
final _that = this;
switch (_that) {
case _PlaceSuggestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlaceSuggestion value)?  $default,){
final _that = this;
switch (_that) {
case _PlaceSuggestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String placeId,  String primaryText,  String? secondaryText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlaceSuggestion() when $default != null:
return $default(_that.placeId,_that.primaryText,_that.secondaryText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String placeId,  String primaryText,  String? secondaryText)  $default,) {final _that = this;
switch (_that) {
case _PlaceSuggestion():
return $default(_that.placeId,_that.primaryText,_that.secondaryText);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String placeId,  String primaryText,  String? secondaryText)?  $default,) {final _that = this;
switch (_that) {
case _PlaceSuggestion() when $default != null:
return $default(_that.placeId,_that.primaryText,_that.secondaryText);case _:
  return null;

}
}

}

/// @nodoc


class _PlaceSuggestion implements PlaceSuggestion {
  const _PlaceSuggestion({required this.placeId, required this.primaryText, this.secondaryText});
  

@override final  String placeId;
@override final  String primaryText;
@override final  String? secondaryText;

/// Create a copy of PlaceSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaceSuggestionCopyWith<_PlaceSuggestion> get copyWith => __$PlaceSuggestionCopyWithImpl<_PlaceSuggestion>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaceSuggestion&&(identical(other.placeId, placeId) || other.placeId == placeId)&&(identical(other.primaryText, primaryText) || other.primaryText == primaryText)&&(identical(other.secondaryText, secondaryText) || other.secondaryText == secondaryText));
}


@override
int get hashCode {
    return Object.hash(runtimeType,placeId,primaryText,secondaryText);
}

@override
String toString() {
    return 'PlaceSuggestion(placeId: $placeId, primaryText: $primaryText, secondaryText: $secondaryText)';
}


}

/// @nodoc
abstract mixin class _$PlaceSuggestionCopyWith<$Res> implements $PlaceSuggestionCopyWith<$Res> {
  factory _$PlaceSuggestionCopyWith(_PlaceSuggestion value, $Res Function(_PlaceSuggestion) _then) = __$PlaceSuggestionCopyWithImpl;
@override @useResult
$Res call({
 String placeId, String primaryText, String? secondaryText
});




}
/// @nodoc
class __$PlaceSuggestionCopyWithImpl<$Res>
    implements _$PlaceSuggestionCopyWith<$Res> {
  __$PlaceSuggestionCopyWithImpl(this._self, this._then);

  final _PlaceSuggestion _self;
  final $Res Function(_PlaceSuggestion) _then;

/// Create a copy of PlaceSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? placeId = null,Object? primaryText = null,Object? secondaryText = freezed,}) {
  return _then(_PlaceSuggestion(
placeId: null == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as String,primaryText: null == primaryText ? _self.primaryText : primaryText // ignore: cast_nullable_to_non_nullable
as String,secondaryText: freezed == secondaryText ? _self.secondaryText : secondaryText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$Destination {

 String get name; GeoPoint get location; String? get placeId; String? get address;
/// Create a copy of Destination
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DestinationCopyWith<Destination> get copyWith => _$DestinationCopyWithImpl<Destination>(this as Destination, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Destination;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Destination&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.placeId, _this.placeId) || other.placeId == _this.placeId)&&(identical(other.address, _this.address) || other.address == _this.address));
}


@override
int get hashCode {
  final _this = this as Destination;
  return Object.hash(runtimeType,_this.name,_this.location,_this.placeId,_this.address);
}

@override
String toString() {
  final _this = this as Destination;
  return 'Destination(name: ${_this.name}, location: ${_this.location}, placeId: ${_this.placeId}, address: ${_this.address})';
}


}

/// @nodoc
abstract mixin class $DestinationCopyWith<$Res>  {
  factory $DestinationCopyWith(Destination value, $Res Function(Destination) _then) = _$DestinationCopyWithImpl;
@useResult
$Res call({
 String name, GeoPoint location, String? placeId, String? address
});


$GeoPointCopyWith<$Res> get location;

}
/// @nodoc
class _$DestinationCopyWithImpl<$Res>
    implements $DestinationCopyWith<$Res> {
  _$DestinationCopyWithImpl(this._self, this._then);

  final Destination _self;
  final $Res Function(Destination) _then;

/// Create a copy of Destination
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? location = null,Object? placeId = freezed,Object? address = freezed,}) {
  return _then(Destination(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint,placeId: freezed == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Destination
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res> get location {
  
  return $GeoPointCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// Adds pattern-matching-related methods to [Destination].
extension DestinationPatterns on Destination {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Destination value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Destination() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Destination value)  $default,){
final _that = this;
switch (_that) {
case _Destination():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Destination value)?  $default,){
final _that = this;
switch (_that) {
case _Destination() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  GeoPoint location,  String? placeId,  String? address)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Destination() when $default != null:
return $default(_that.name,_that.location,_that.placeId,_that.address);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  GeoPoint location,  String? placeId,  String? address)  $default,) {final _that = this;
switch (_that) {
case _Destination():
return $default(_that.name,_that.location,_that.placeId,_that.address);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  GeoPoint location,  String? placeId,  String? address)?  $default,) {final _that = this;
switch (_that) {
case _Destination() when $default != null:
return $default(_that.name,_that.location,_that.placeId,_that.address);case _:
  return null;

}
}

}

/// @nodoc


class _Destination implements Destination {
  const _Destination({required this.name, required this.location, this.placeId, this.address});
  

@override final  String name;
@override final  GeoPoint location;
@override final  String? placeId;
@override final  String? address;

/// Create a copy of Destination
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DestinationCopyWith<_Destination> get copyWith => __$DestinationCopyWithImpl<_Destination>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Destination&&(identical(other.name, name) || other.name == name)&&(identical(other.location, location) || other.location == location)&&(identical(other.placeId, placeId) || other.placeId == placeId)&&(identical(other.address, address) || other.address == address));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,location,placeId,address);
}

@override
String toString() {
    return 'Destination(name: $name, location: $location, placeId: $placeId, address: $address)';
}


}

/// @nodoc
abstract mixin class _$DestinationCopyWith<$Res> implements $DestinationCopyWith<$Res> {
  factory _$DestinationCopyWith(_Destination value, $Res Function(_Destination) _then) = __$DestinationCopyWithImpl;
@override @useResult
$Res call({
 String name, GeoPoint location, String? placeId, String? address
});


@override $GeoPointCopyWith<$Res> get location;

}
/// @nodoc
class __$DestinationCopyWithImpl<$Res>
    implements _$DestinationCopyWith<$Res> {
  __$DestinationCopyWithImpl(this._self, this._then);

  final _Destination _self;
  final $Res Function(_Destination) _then;

/// Create a copy of Destination
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? location = null,Object? placeId = freezed,Object? address = freezed,}) {
  return _then(_Destination(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint,placeId: freezed == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Destination
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
mixin _$StopDetour {

/// Driving distance/time origin → station.
 double get toStationMeters; double? get toStationSeconds;/// (origin → station → destination) − (origin → destination), ≥ 0.
 double get detourMeters; double? get detourSeconds;
/// Create a copy of StopDetour
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StopDetourCopyWith<StopDetour> get copyWith => _$StopDetourCopyWithImpl<StopDetour>(this as StopDetour, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StopDetour;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StopDetour&&(identical(other.toStationMeters, _this.toStationMeters) || other.toStationMeters == _this.toStationMeters)&&(identical(other.toStationSeconds, _this.toStationSeconds) || other.toStationSeconds == _this.toStationSeconds)&&(identical(other.detourMeters, _this.detourMeters) || other.detourMeters == _this.detourMeters)&&(identical(other.detourSeconds, _this.detourSeconds) || other.detourSeconds == _this.detourSeconds));
}


@override
int get hashCode {
  final _this = this as StopDetour;
  return Object.hash(runtimeType,_this.toStationMeters,_this.toStationSeconds,_this.detourMeters,_this.detourSeconds);
}

@override
String toString() {
  final _this = this as StopDetour;
  return 'StopDetour(toStationMeters: ${_this.toStationMeters}, toStationSeconds: ${_this.toStationSeconds}, detourMeters: ${_this.detourMeters}, detourSeconds: ${_this.detourSeconds})';
}


}

/// @nodoc
abstract mixin class $StopDetourCopyWith<$Res>  {
  factory $StopDetourCopyWith(StopDetour value, $Res Function(StopDetour) _then) = _$StopDetourCopyWithImpl;
@useResult
$Res call({
 double toStationMeters, double? toStationSeconds, double detourMeters, double? detourSeconds
});




}
/// @nodoc
class _$StopDetourCopyWithImpl<$Res>
    implements $StopDetourCopyWith<$Res> {
  _$StopDetourCopyWithImpl(this._self, this._then);

  final StopDetour _self;
  final $Res Function(StopDetour) _then;

/// Create a copy of StopDetour
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? toStationMeters = null,Object? toStationSeconds = freezed,Object? detourMeters = null,Object? detourSeconds = freezed,}) {
  return _then(StopDetour(
toStationMeters: null == toStationMeters ? _self.toStationMeters : toStationMeters // ignore: cast_nullable_to_non_nullable
as double,toStationSeconds: freezed == toStationSeconds ? _self.toStationSeconds : toStationSeconds // ignore: cast_nullable_to_non_nullable
as double?,detourMeters: null == detourMeters ? _self.detourMeters : detourMeters // ignore: cast_nullable_to_non_nullable
as double,detourSeconds: freezed == detourSeconds ? _self.detourSeconds : detourSeconds // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [StopDetour].
extension StopDetourPatterns on StopDetour {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StopDetour value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StopDetour() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StopDetour value)  $default,){
final _that = this;
switch (_that) {
case _StopDetour():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StopDetour value)?  $default,){
final _that = this;
switch (_that) {
case _StopDetour() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double toStationMeters,  double? toStationSeconds,  double detourMeters,  double? detourSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StopDetour() when $default != null:
return $default(_that.toStationMeters,_that.toStationSeconds,_that.detourMeters,_that.detourSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double toStationMeters,  double? toStationSeconds,  double detourMeters,  double? detourSeconds)  $default,) {final _that = this;
switch (_that) {
case _StopDetour():
return $default(_that.toStationMeters,_that.toStationSeconds,_that.detourMeters,_that.detourSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double toStationMeters,  double? toStationSeconds,  double detourMeters,  double? detourSeconds)?  $default,) {final _that = this;
switch (_that) {
case _StopDetour() when $default != null:
return $default(_that.toStationMeters,_that.toStationSeconds,_that.detourMeters,_that.detourSeconds);case _:
  return null;

}
}

}

/// @nodoc


class _StopDetour implements StopDetour {
  const _StopDetour({required this.toStationMeters, this.toStationSeconds, required this.detourMeters, this.detourSeconds});
  

/// Driving distance/time origin → station.
@override final  double toStationMeters;
@override final  double? toStationSeconds;
/// (origin → station → destination) − (origin → destination), ≥ 0.
@override final  double detourMeters;
@override final  double? detourSeconds;

/// Create a copy of StopDetour
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StopDetourCopyWith<_StopDetour> get copyWith => __$StopDetourCopyWithImpl<_StopDetour>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StopDetour&&(identical(other.toStationMeters, toStationMeters) || other.toStationMeters == toStationMeters)&&(identical(other.toStationSeconds, toStationSeconds) || other.toStationSeconds == toStationSeconds)&&(identical(other.detourMeters, detourMeters) || other.detourMeters == detourMeters)&&(identical(other.detourSeconds, detourSeconds) || other.detourSeconds == detourSeconds));
}


@override
int get hashCode {
    return Object.hash(runtimeType,toStationMeters,toStationSeconds,detourMeters,detourSeconds);
}

@override
String toString() {
    return 'StopDetour(toStationMeters: $toStationMeters, toStationSeconds: $toStationSeconds, detourMeters: $detourMeters, detourSeconds: $detourSeconds)';
}


}

/// @nodoc
abstract mixin class _$StopDetourCopyWith<$Res> implements $StopDetourCopyWith<$Res> {
  factory _$StopDetourCopyWith(_StopDetour value, $Res Function(_StopDetour) _then) = __$StopDetourCopyWithImpl;
@override @useResult
$Res call({
 double toStationMeters, double? toStationSeconds, double detourMeters, double? detourSeconds
});




}
/// @nodoc
class __$StopDetourCopyWithImpl<$Res>
    implements _$StopDetourCopyWith<$Res> {
  __$StopDetourCopyWithImpl(this._self, this._then);

  final _StopDetour _self;
  final $Res Function(_StopDetour) _then;

/// Create a copy of StopDetour
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? toStationMeters = null,Object? toStationSeconds = freezed,Object? detourMeters = null,Object? detourSeconds = freezed,}) {
  return _then(_StopDetour(
toStationMeters: null == toStationMeters ? _self.toStationMeters : toStationMeters // ignore: cast_nullable_to_non_nullable
as double,toStationSeconds: freezed == toStationSeconds ? _self.toStationSeconds : toStationSeconds // ignore: cast_nullable_to_non_nullable
as double?,detourMeters: null == detourMeters ? _self.detourMeters : detourMeters // ignore: cast_nullable_to_non_nullable
as double,detourSeconds: freezed == detourSeconds ? _self.detourSeconds : detourSeconds // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc
mixin _$RouteStop {

 Station get station; double get alongMeters; double get offRouteMeters;/// Null when the routing service could not compute it.
 StopDetour? get detour;/// Price for the vehicle's fuel (from a real source) — null = unknown.
 FuelPrice? get price; PriceSource? get priceSource; bool? get openNow;/// 0..1 community data-reliability score; null = unknown.
 double? get reliability;
/// Create a copy of RouteStop
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteStopCopyWith<RouteStop> get copyWith => _$RouteStopCopyWithImpl<RouteStop>(this as RouteStop, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RouteStop;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteStop&&(identical(other.station, _this.station) || other.station == _this.station)&&(identical(other.alongMeters, _this.alongMeters) || other.alongMeters == _this.alongMeters)&&(identical(other.offRouteMeters, _this.offRouteMeters) || other.offRouteMeters == _this.offRouteMeters)&&(identical(other.detour, _this.detour) || other.detour == _this.detour)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.priceSource, _this.priceSource) || other.priceSource == _this.priceSource)&&(identical(other.openNow, _this.openNow) || other.openNow == _this.openNow)&&(identical(other.reliability, _this.reliability) || other.reliability == _this.reliability));
}


@override
int get hashCode {
  final _this = this as RouteStop;
  return Object.hash(runtimeType,_this.station,_this.alongMeters,_this.offRouteMeters,_this.detour,_this.price,_this.priceSource,_this.openNow,_this.reliability);
}

@override
String toString() {
  final _this = this as RouteStop;
  return 'RouteStop(station: ${_this.station}, alongMeters: ${_this.alongMeters}, offRouteMeters: ${_this.offRouteMeters}, detour: ${_this.detour}, price: ${_this.price}, priceSource: ${_this.priceSource}, openNow: ${_this.openNow}, reliability: ${_this.reliability})';
}


}

/// @nodoc
abstract mixin class $RouteStopCopyWith<$Res>  {
  factory $RouteStopCopyWith(RouteStop value, $Res Function(RouteStop) _then) = _$RouteStopCopyWithImpl;
@useResult
$Res call({
 Station station, double alongMeters, double offRouteMeters, StopDetour? detour, FuelPrice? price, PriceSource? priceSource, bool? openNow, double? reliability
});


$StationCopyWith<$Res> get station;$StopDetourCopyWith<$Res>? get detour;$FuelPriceCopyWith<$Res>? get price;

}
/// @nodoc
class _$RouteStopCopyWithImpl<$Res>
    implements $RouteStopCopyWith<$Res> {
  _$RouteStopCopyWithImpl(this._self, this._then);

  final RouteStop _self;
  final $Res Function(RouteStop) _then;

/// Create a copy of RouteStop
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? station = null,Object? alongMeters = null,Object? offRouteMeters = null,Object? detour = freezed,Object? price = freezed,Object? priceSource = freezed,Object? openNow = freezed,Object? reliability = freezed,}) {
  return _then(RouteStop(
station: null == station ? _self.station : station // ignore: cast_nullable_to_non_nullable
as Station,alongMeters: null == alongMeters ? _self.alongMeters : alongMeters // ignore: cast_nullable_to_non_nullable
as double,offRouteMeters: null == offRouteMeters ? _self.offRouteMeters : offRouteMeters // ignore: cast_nullable_to_non_nullable
as double,detour: freezed == detour ? _self.detour : detour // ignore: cast_nullable_to_non_nullable
as StopDetour?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as FuelPrice?,priceSource: freezed == priceSource ? _self.priceSource : priceSource // ignore: cast_nullable_to_non_nullable
as PriceSource?,openNow: freezed == openNow ? _self.openNow : openNow // ignore: cast_nullable_to_non_nullable
as bool?,reliability: freezed == reliability ? _self.reliability : reliability // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}
/// Create a copy of RouteStop
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationCopyWith<$Res> get station {
  
  return $StationCopyWith<$Res>(_self.station, (value) {
    return _then(_self.copyWith(station: value));
  });
}/// Create a copy of RouteStop
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StopDetourCopyWith<$Res>? get detour {
    if (_self.detour == null) {
    return null;
  }

  return $StopDetourCopyWith<$Res>(_self.detour!, (value) {
    return _then(_self.copyWith(detour: value));
  });
}/// Create a copy of RouteStop
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FuelPriceCopyWith<$Res>? get price {
    if (_self.price == null) {
    return null;
  }

  return $FuelPriceCopyWith<$Res>(_self.price!, (value) {
    return _then(_self.copyWith(price: value));
  });
}
}


/// Adds pattern-matching-related methods to [RouteStop].
extension RouteStopPatterns on RouteStop {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteStop value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteStop() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteStop value)  $default,){
final _that = this;
switch (_that) {
case _RouteStop():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteStop value)?  $default,){
final _that = this;
switch (_that) {
case _RouteStop() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Station station,  double alongMeters,  double offRouteMeters,  StopDetour? detour,  FuelPrice? price,  PriceSource? priceSource,  bool? openNow,  double? reliability)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteStop() when $default != null:
return $default(_that.station,_that.alongMeters,_that.offRouteMeters,_that.detour,_that.price,_that.priceSource,_that.openNow,_that.reliability);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Station station,  double alongMeters,  double offRouteMeters,  StopDetour? detour,  FuelPrice? price,  PriceSource? priceSource,  bool? openNow,  double? reliability)  $default,) {final _that = this;
switch (_that) {
case _RouteStop():
return $default(_that.station,_that.alongMeters,_that.offRouteMeters,_that.detour,_that.price,_that.priceSource,_that.openNow,_that.reliability);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Station station,  double alongMeters,  double offRouteMeters,  StopDetour? detour,  FuelPrice? price,  PriceSource? priceSource,  bool? openNow,  double? reliability)?  $default,) {final _that = this;
switch (_that) {
case _RouteStop() when $default != null:
return $default(_that.station,_that.alongMeters,_that.offRouteMeters,_that.detour,_that.price,_that.priceSource,_that.openNow,_that.reliability);case _:
  return null;

}
}

}

/// @nodoc


class _RouteStop implements RouteStop {
  const _RouteStop({required this.station, required this.alongMeters, required this.offRouteMeters, this.detour, this.price, this.priceSource, this.openNow, this.reliability});
  

@override final  Station station;
@override final  double alongMeters;
@override final  double offRouteMeters;
/// Null when the routing service could not compute it.
@override final  StopDetour? detour;
/// Price for the vehicle's fuel (from a real source) — null = unknown.
@override final  FuelPrice? price;
@override final  PriceSource? priceSource;
@override final  bool? openNow;
/// 0..1 community data-reliability score; null = unknown.
@override final  double? reliability;

/// Create a copy of RouteStop
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteStopCopyWith<_RouteStop> get copyWith => __$RouteStopCopyWithImpl<_RouteStop>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteStop&&(identical(other.station, station) || other.station == station)&&(identical(other.alongMeters, alongMeters) || other.alongMeters == alongMeters)&&(identical(other.offRouteMeters, offRouteMeters) || other.offRouteMeters == offRouteMeters)&&(identical(other.detour, detour) || other.detour == detour)&&(identical(other.price, price) || other.price == price)&&(identical(other.priceSource, priceSource) || other.priceSource == priceSource)&&(identical(other.openNow, openNow) || other.openNow == openNow)&&(identical(other.reliability, reliability) || other.reliability == reliability));
}


@override
int get hashCode {
    return Object.hash(runtimeType,station,alongMeters,offRouteMeters,detour,price,priceSource,openNow,reliability);
}

@override
String toString() {
    return 'RouteStop(station: $station, alongMeters: $alongMeters, offRouteMeters: $offRouteMeters, detour: $detour, price: $price, priceSource: $priceSource, openNow: $openNow, reliability: $reliability)';
}


}

/// @nodoc
abstract mixin class _$RouteStopCopyWith<$Res> implements $RouteStopCopyWith<$Res> {
  factory _$RouteStopCopyWith(_RouteStop value, $Res Function(_RouteStop) _then) = __$RouteStopCopyWithImpl;
@override @useResult
$Res call({
 Station station, double alongMeters, double offRouteMeters, StopDetour? detour, FuelPrice? price, PriceSource? priceSource, bool? openNow, double? reliability
});


@override $StationCopyWith<$Res> get station;@override $StopDetourCopyWith<$Res>? get detour;@override $FuelPriceCopyWith<$Res>? get price;

}
/// @nodoc
class __$RouteStopCopyWithImpl<$Res>
    implements _$RouteStopCopyWith<$Res> {
  __$RouteStopCopyWithImpl(this._self, this._then);

  final _RouteStop _self;
  final $Res Function(_RouteStop) _then;

/// Create a copy of RouteStop
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? station = null,Object? alongMeters = null,Object? offRouteMeters = null,Object? detour = freezed,Object? price = freezed,Object? priceSource = freezed,Object? openNow = freezed,Object? reliability = freezed,}) {
  return _then(_RouteStop(
station: null == station ? _self.station : station // ignore: cast_nullable_to_non_nullable
as Station,alongMeters: null == alongMeters ? _self.alongMeters : alongMeters // ignore: cast_nullable_to_non_nullable
as double,offRouteMeters: null == offRouteMeters ? _self.offRouteMeters : offRouteMeters // ignore: cast_nullable_to_non_nullable
as double,detour: freezed == detour ? _self.detour : detour // ignore: cast_nullable_to_non_nullable
as StopDetour?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as FuelPrice?,priceSource: freezed == priceSource ? _self.priceSource : priceSource // ignore: cast_nullable_to_non_nullable
as PriceSource?,openNow: freezed == openNow ? _self.openNow : openNow // ignore: cast_nullable_to_non_nullable
as bool?,reliability: freezed == reliability ? _self.reliability : reliability // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

/// Create a copy of RouteStop
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationCopyWith<$Res> get station {
  
  return $StationCopyWith<$Res>(_self.station, (value) {
    return _then(_self.copyWith(station: value));
  });
}/// Create a copy of RouteStop
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StopDetourCopyWith<$Res>? get detour {
    if (_self.detour == null) {
    return null;
  }

  return $StopDetourCopyWith<$Res>(_self.detour!, (value) {
    return _then(_self.copyWith(detour: value));
  });
}/// Create a copy of RouteStop
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FuelPriceCopyWith<$Res>? get price {
    if (_self.price == null) {
    return null;
  }

  return $FuelPriceCopyWith<$Res>(_self.price!, (value) {
    return _then(_self.copyWith(price: value));
  });
}
}

/// @nodoc
mixin _$AlongRoutePlan {

 GeoPoint get origin; Destination get destination; RouteInfo get route; List<RouteStop> get stops;/// Places fuel code that prices refer to; null = none (EV or no vehicle fuel).
 String? get fuelType;/// True when detours are straight-line estimates (routing table failed).
 bool get detoursApproximate;/// Stations beyond the detour/price budget (listed, not priced/routed).
 int get skippedForDetour;
/// Create a copy of AlongRoutePlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlongRoutePlanCopyWith<AlongRoutePlan> get copyWith => _$AlongRoutePlanCopyWithImpl<AlongRoutePlan>(this as AlongRoutePlan, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AlongRoutePlan;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlongRoutePlan&&(identical(other.origin, _this.origin) || other.origin == _this.origin)&&(identical(other.destination, _this.destination) || other.destination == _this.destination)&&(identical(other.route, _this.route) || other.route == _this.route)&&const DeepCollectionEquality().equals(other.stops, _this.stops)&&(identical(other.fuelType, _this.fuelType) || other.fuelType == _this.fuelType)&&(identical(other.detoursApproximate, _this.detoursApproximate) || other.detoursApproximate == _this.detoursApproximate)&&(identical(other.skippedForDetour, _this.skippedForDetour) || other.skippedForDetour == _this.skippedForDetour));
}


@override
int get hashCode {
  final _this = this as AlongRoutePlan;
  return Object.hash(runtimeType,_this.origin,_this.destination,_this.route,const DeepCollectionEquality().hash(_this.stops),_this.fuelType,_this.detoursApproximate,_this.skippedForDetour);
}

@override
String toString() {
  final _this = this as AlongRoutePlan;
  return 'AlongRoutePlan(origin: ${_this.origin}, destination: ${_this.destination}, route: ${_this.route}, stops: ${_this.stops}, fuelType: ${_this.fuelType}, detoursApproximate: ${_this.detoursApproximate}, skippedForDetour: ${_this.skippedForDetour})';
}


}

/// @nodoc
abstract mixin class $AlongRoutePlanCopyWith<$Res>  {
  factory $AlongRoutePlanCopyWith(AlongRoutePlan value, $Res Function(AlongRoutePlan) _then) = _$AlongRoutePlanCopyWithImpl;
@useResult
$Res call({
 GeoPoint origin, Destination destination, RouteInfo route, List<RouteStop> stops, String? fuelType, bool detoursApproximate, int skippedForDetour
});


$GeoPointCopyWith<$Res> get origin;$DestinationCopyWith<$Res> get destination;$RouteInfoCopyWith<$Res> get route;

}
/// @nodoc
class _$AlongRoutePlanCopyWithImpl<$Res>
    implements $AlongRoutePlanCopyWith<$Res> {
  _$AlongRoutePlanCopyWithImpl(this._self, this._then);

  final AlongRoutePlan _self;
  final $Res Function(AlongRoutePlan) _then;

/// Create a copy of AlongRoutePlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? origin = null,Object? destination = null,Object? route = null,Object? stops = null,Object? fuelType = freezed,Object? detoursApproximate = null,Object? skippedForDetour = null,}) {
  return _then(AlongRoutePlan(
origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as GeoPoint,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as Destination,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as RouteInfo,stops: null == stops ? _self.stops : stops // ignore: cast_nullable_to_non_nullable
as List<RouteStop>,fuelType: freezed == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as String?,detoursApproximate: null == detoursApproximate ? _self.detoursApproximate : detoursApproximate // ignore: cast_nullable_to_non_nullable
as bool,skippedForDetour: null == skippedForDetour ? _self.skippedForDetour : skippedForDetour // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of AlongRoutePlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res> get origin {
  
  return $GeoPointCopyWith<$Res>(_self.origin, (value) {
    return _then(_self.copyWith(origin: value));
  });
}/// Create a copy of AlongRoutePlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DestinationCopyWith<$Res> get destination {
  
  return $DestinationCopyWith<$Res>(_self.destination, (value) {
    return _then(_self.copyWith(destination: value));
  });
}/// Create a copy of AlongRoutePlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteInfoCopyWith<$Res> get route {
  
  return $RouteInfoCopyWith<$Res>(_self.route, (value) {
    return _then(_self.copyWith(route: value));
  });
}
}


/// Adds pattern-matching-related methods to [AlongRoutePlan].
extension AlongRoutePlanPatterns on AlongRoutePlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlongRoutePlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlongRoutePlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlongRoutePlan value)  $default,){
final _that = this;
switch (_that) {
case _AlongRoutePlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlongRoutePlan value)?  $default,){
final _that = this;
switch (_that) {
case _AlongRoutePlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GeoPoint origin,  Destination destination,  RouteInfo route,  List<RouteStop> stops,  String? fuelType,  bool detoursApproximate,  int skippedForDetour)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlongRoutePlan() when $default != null:
return $default(_that.origin,_that.destination,_that.route,_that.stops,_that.fuelType,_that.detoursApproximate,_that.skippedForDetour);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GeoPoint origin,  Destination destination,  RouteInfo route,  List<RouteStop> stops,  String? fuelType,  bool detoursApproximate,  int skippedForDetour)  $default,) {final _that = this;
switch (_that) {
case _AlongRoutePlan():
return $default(_that.origin,_that.destination,_that.route,_that.stops,_that.fuelType,_that.detoursApproximate,_that.skippedForDetour);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GeoPoint origin,  Destination destination,  RouteInfo route,  List<RouteStop> stops,  String? fuelType,  bool detoursApproximate,  int skippedForDetour)?  $default,) {final _that = this;
switch (_that) {
case _AlongRoutePlan() when $default != null:
return $default(_that.origin,_that.destination,_that.route,_that.stops,_that.fuelType,_that.detoursApproximate,_that.skippedForDetour);case _:
  return null;

}
}

}

/// @nodoc


class _AlongRoutePlan implements AlongRoutePlan {
  const _AlongRoutePlan({required this.origin, required this.destination, required this.route, required  List<RouteStop> stops, this.fuelType, this.detoursApproximate = false, this.skippedForDetour = 0}): _stops = stops;
  

@override final  GeoPoint origin;
@override final  Destination destination;
@override final  RouteInfo route;
 final  List<RouteStop> _stops;
@override List<RouteStop> get stops {
  if (_stops is EqualUnmodifiableListView) return _stops;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stops);
}

/// Places fuel code that prices refer to; null = none (EV or no vehicle fuel).
@override final  String? fuelType;
/// True when detours are straight-line estimates (routing table failed).
@override@JsonKey() final  bool detoursApproximate;
/// Stations beyond the detour/price budget (listed, not priced/routed).
@override@JsonKey() final  int skippedForDetour;

/// Create a copy of AlongRoutePlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlongRoutePlanCopyWith<_AlongRoutePlan> get copyWith => __$AlongRoutePlanCopyWithImpl<_AlongRoutePlan>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlongRoutePlan&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.route, route) || other.route == route)&&const DeepCollectionEquality().equals(other.stops, _stops)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.detoursApproximate, detoursApproximate) || other.detoursApproximate == detoursApproximate)&&(identical(other.skippedForDetour, skippedForDetour) || other.skippedForDetour == skippedForDetour));
}


@override
int get hashCode {
    return Object.hash(runtimeType,origin,destination,route,const DeepCollectionEquality().hash(_stops),fuelType,detoursApproximate,skippedForDetour);
}

@override
String toString() {
    return 'AlongRoutePlan(origin: $origin, destination: $destination, route: $route, stops: $stops, fuelType: $fuelType, detoursApproximate: $detoursApproximate, skippedForDetour: $skippedForDetour)';
}


}

/// @nodoc
abstract mixin class _$AlongRoutePlanCopyWith<$Res> implements $AlongRoutePlanCopyWith<$Res> {
  factory _$AlongRoutePlanCopyWith(_AlongRoutePlan value, $Res Function(_AlongRoutePlan) _then) = __$AlongRoutePlanCopyWithImpl;
@override @useResult
$Res call({
 GeoPoint origin, Destination destination, RouteInfo route, List<RouteStop> stops, String? fuelType, bool detoursApproximate, int skippedForDetour
});


@override $GeoPointCopyWith<$Res> get origin;@override $DestinationCopyWith<$Res> get destination;@override $RouteInfoCopyWith<$Res> get route;

}
/// @nodoc
class __$AlongRoutePlanCopyWithImpl<$Res>
    implements _$AlongRoutePlanCopyWith<$Res> {
  __$AlongRoutePlanCopyWithImpl(this._self, this._then);

  final _AlongRoutePlan _self;
  final $Res Function(_AlongRoutePlan) _then;

/// Create a copy of AlongRoutePlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? origin = null,Object? destination = null,Object? route = null,Object? stops = null,Object? fuelType = freezed,Object? detoursApproximate = null,Object? skippedForDetour = null,}) {
  return _then(_AlongRoutePlan(
origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as GeoPoint,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as Destination,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as RouteInfo,stops: null == stops ? _self._stops : stops // ignore: cast_nullable_to_non_nullable
as List<RouteStop>,fuelType: freezed == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as String?,detoursApproximate: null == detoursApproximate ? _self.detoursApproximate : detoursApproximate // ignore: cast_nullable_to_non_nullable
as bool,skippedForDetour: null == skippedForDetour ? _self.skippedForDetour : skippedForDetour // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of AlongRoutePlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res> get origin {
  
  return $GeoPointCopyWith<$Res>(_self.origin, (value) {
    return _then(_self.copyWith(origin: value));
  });
}/// Create a copy of AlongRoutePlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DestinationCopyWith<$Res> get destination {
  
  return $DestinationCopyWith<$Res>(_self.destination, (value) {
    return _then(_self.copyWith(destination: value));
  });
}/// Create a copy of AlongRoutePlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteInfoCopyWith<$Res> get route {
  
  return $RouteInfoCopyWith<$Res>(_self.route, (value) {
    return _then(_self.copyWith(route: value));
  });
}
}

// dart format on
