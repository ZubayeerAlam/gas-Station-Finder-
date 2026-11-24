// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'station.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Station {

 String get id; String get name; GeoPoint get location; String? get address;
/// Create a copy of Station
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StationCopyWith<Station> get copyWith => _$StationCopyWithImpl<Station>(this as Station, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Station;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Station&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.address, _this.address) || other.address == _this.address));
}


@override
int get hashCode {
  final _this = this as Station;
  return Object.hash(runtimeType,_this.id,_this.name,_this.location,_this.address);
}

@override
String toString() {
  final _this = this as Station;
  return 'Station(id: ${_this.id}, name: ${_this.name}, location: ${_this.location}, address: ${_this.address})';
}


}

/// @nodoc
abstract mixin class $StationCopyWith<$Res>  {
  factory $StationCopyWith(Station value, $Res Function(Station) _then) = _$StationCopyWithImpl;
@useResult
$Res call({
 String id, String name, GeoPoint location, String? address
});


$GeoPointCopyWith<$Res> get location;

}
/// @nodoc
class _$StationCopyWithImpl<$Res>
    implements $StationCopyWith<$Res> {
  _$StationCopyWithImpl(this._self, this._then);

  final Station _self;
  final $Res Function(Station) _then;

/// Create a copy of Station
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? location = null,Object? address = freezed,}) {
  return _then(Station(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Station
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res> get location {
  
  return $GeoPointCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// Adds pattern-matching-related methods to [Station].
extension StationPatterns on Station {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Station value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Station() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Station value)  $default,){
final _that = this;
switch (_that) {
case _Station():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Station value)?  $default,){
final _that = this;
switch (_that) {
case _Station() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  GeoPoint location,  String? address)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Station() when $default != null:
return $default(_that.id,_that.name,_that.location,_that.address);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  GeoPoint location,  String? address)  $default,) {final _that = this;
switch (_that) {
case _Station():
return $default(_that.id,_that.name,_that.location,_that.address);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  GeoPoint location,  String? address)?  $default,) {final _that = this;
switch (_that) {
case _Station() when $default != null:
return $default(_that.id,_that.name,_that.location,_that.address);case _:
  return null;

}
}

}

/// @nodoc


class _Station implements Station {
  const _Station({required this.id, required this.name, required this.location, this.address});
  

@override final  String id;
@override final  String name;
@override final  GeoPoint location;
@override final  String? address;

/// Create a copy of Station
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StationCopyWith<_Station> get copyWith => __$StationCopyWithImpl<_Station>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Station&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.location, location) || other.location == location)&&(identical(other.address, address) || other.address == address));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,location,address);
}

@override
String toString() {
    return 'Station(id: $id, name: $name, location: $location, address: $address)';
}


}

/// @nodoc
abstract mixin class _$StationCopyWith<$Res> implements $StationCopyWith<$Res> {
  factory _$StationCopyWith(_Station value, $Res Function(_Station) _then) = __$StationCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, GeoPoint location, String? address
});


@override $GeoPointCopyWith<$Res> get location;

}
/// @nodoc
class __$StationCopyWithImpl<$Res>
    implements _$StationCopyWith<$Res> {
  __$StationCopyWithImpl(this._self, this._then);

  final _Station _self;
  final $Res Function(_Station) _then;

/// Create a copy of Station
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? location = null,Object? address = freezed,}) {
  return _then(_Station(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Station
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
mixin _$StationDetails {

 String get id; String get name; GeoPoint get location; String? get address; String? get phone; double? get rating; int? get userRatingCount; bool? get openNow; List<String> get weekdayHours; List<FuelPrice> get fuelPrices; EvChargeInfo? get evCharge; String? get googleMapsUri;
/// Create a copy of StationDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StationDetailsCopyWith<StationDetails> get copyWith => _$StationDetailsCopyWithImpl<StationDetails>(this as StationDetails, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StationDetails;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StationDetails&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.userRatingCount, _this.userRatingCount) || other.userRatingCount == _this.userRatingCount)&&(identical(other.openNow, _this.openNow) || other.openNow == _this.openNow)&&const DeepCollectionEquality().equals(other.weekdayHours, _this.weekdayHours)&&const DeepCollectionEquality().equals(other.fuelPrices, _this.fuelPrices)&&(identical(other.evCharge, _this.evCharge) || other.evCharge == _this.evCharge)&&(identical(other.googleMapsUri, _this.googleMapsUri) || other.googleMapsUri == _this.googleMapsUri));
}


@override
int get hashCode {
  final _this = this as StationDetails;
  return Object.hash(runtimeType,_this.id,_this.name,_this.location,_this.address,_this.phone,_this.rating,_this.userRatingCount,_this.openNow,const DeepCollectionEquality().hash(_this.weekdayHours),const DeepCollectionEquality().hash(_this.fuelPrices),_this.evCharge,_this.googleMapsUri);
}

@override
String toString() {
  final _this = this as StationDetails;
  return 'StationDetails(id: ${_this.id}, name: ${_this.name}, location: ${_this.location}, address: ${_this.address}, phone: ${_this.phone}, rating: ${_this.rating}, userRatingCount: ${_this.userRatingCount}, openNow: ${_this.openNow}, weekdayHours: ${_this.weekdayHours}, fuelPrices: ${_this.fuelPrices}, evCharge: ${_this.evCharge}, googleMapsUri: ${_this.googleMapsUri})';
}


}

/// @nodoc
abstract mixin class $StationDetailsCopyWith<$Res>  {
  factory $StationDetailsCopyWith(StationDetails value, $Res Function(StationDetails) _then) = _$StationDetailsCopyWithImpl;
@useResult
$Res call({
 String id, String name, GeoPoint location, String? address, String? phone, double? rating, int? userRatingCount, bool? openNow, List<String> weekdayHours, List<FuelPrice> fuelPrices, EvChargeInfo? evCharge, String? googleMapsUri
});


$GeoPointCopyWith<$Res> get location;$EvChargeInfoCopyWith<$Res>? get evCharge;

}
/// @nodoc
class _$StationDetailsCopyWithImpl<$Res>
    implements $StationDetailsCopyWith<$Res> {
  _$StationDetailsCopyWithImpl(this._self, this._then);

  final StationDetails _self;
  final $Res Function(StationDetails) _then;

/// Create a copy of StationDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? location = null,Object? address = freezed,Object? phone = freezed,Object? rating = freezed,Object? userRatingCount = freezed,Object? openNow = freezed,Object? weekdayHours = null,Object? fuelPrices = null,Object? evCharge = freezed,Object? googleMapsUri = freezed,}) {
  return _then(StationDetails(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,userRatingCount: freezed == userRatingCount ? _self.userRatingCount : userRatingCount // ignore: cast_nullable_to_non_nullable
as int?,openNow: freezed == openNow ? _self.openNow : openNow // ignore: cast_nullable_to_non_nullable
as bool?,weekdayHours: null == weekdayHours ? _self.weekdayHours : weekdayHours // ignore: cast_nullable_to_non_nullable
as List<String>,fuelPrices: null == fuelPrices ? _self.fuelPrices : fuelPrices // ignore: cast_nullable_to_non_nullable
as List<FuelPrice>,evCharge: freezed == evCharge ? _self.evCharge : evCharge // ignore: cast_nullable_to_non_nullable
as EvChargeInfo?,googleMapsUri: freezed == googleMapsUri ? _self.googleMapsUri : googleMapsUri // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of StationDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res> get location {
  
  return $GeoPointCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}/// Create a copy of StationDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EvChargeInfoCopyWith<$Res>? get evCharge {
    if (_self.evCharge == null) {
    return null;
  }

  return $EvChargeInfoCopyWith<$Res>(_self.evCharge!, (value) {
    return _then(_self.copyWith(evCharge: value));
  });
}
}


/// Adds pattern-matching-related methods to [StationDetails].
extension StationDetailsPatterns on StationDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StationDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StationDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StationDetails value)  $default,){
final _that = this;
switch (_that) {
case _StationDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StationDetails value)?  $default,){
final _that = this;
switch (_that) {
case _StationDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  GeoPoint location,  String? address,  String? phone,  double? rating,  int? userRatingCount,  bool? openNow,  List<String> weekdayHours,  List<FuelPrice> fuelPrices,  EvChargeInfo? evCharge,  String? googleMapsUri)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StationDetails() when $default != null:
return $default(_that.id,_that.name,_that.location,_that.address,_that.phone,_that.rating,_that.userRatingCount,_that.openNow,_that.weekdayHours,_that.fuelPrices,_that.evCharge,_that.googleMapsUri);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  GeoPoint location,  String? address,  String? phone,  double? rating,  int? userRatingCount,  bool? openNow,  List<String> weekdayHours,  List<FuelPrice> fuelPrices,  EvChargeInfo? evCharge,  String? googleMapsUri)  $default,) {final _that = this;
switch (_that) {
case _StationDetails():
return $default(_that.id,_that.name,_that.location,_that.address,_that.phone,_that.rating,_that.userRatingCount,_that.openNow,_that.weekdayHours,_that.fuelPrices,_that.evCharge,_that.googleMapsUri);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  GeoPoint location,  String? address,  String? phone,  double? rating,  int? userRatingCount,  bool? openNow,  List<String> weekdayHours,  List<FuelPrice> fuelPrices,  EvChargeInfo? evCharge,  String? googleMapsUri)?  $default,) {final _that = this;
switch (_that) {
case _StationDetails() when $default != null:
return $default(_that.id,_that.name,_that.location,_that.address,_that.phone,_that.rating,_that.userRatingCount,_that.openNow,_that.weekdayHours,_that.fuelPrices,_that.evCharge,_that.googleMapsUri);case _:
  return null;

}
}

}

/// @nodoc


class _StationDetails extends StationDetails {
  const _StationDetails({required this.id, required this.name, required this.location, this.address, this.phone, this.rating, this.userRatingCount, this.openNow,  List<String> weekdayHours = const <String>[],  List<FuelPrice> fuelPrices = const <FuelPrice>[], this.evCharge, this.googleMapsUri}): _weekdayHours = weekdayHours,_fuelPrices = fuelPrices,super._();
  

@override final  String id;
@override final  String name;
@override final  GeoPoint location;
@override final  String? address;
@override final  String? phone;
@override final  double? rating;
@override final  int? userRatingCount;
@override final  bool? openNow;
 final  List<String> _weekdayHours;
@override@JsonKey() List<String> get weekdayHours {
  if (_weekdayHours is EqualUnmodifiableListView) return _weekdayHours;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weekdayHours);
}

 final  List<FuelPrice> _fuelPrices;
@override@JsonKey() List<FuelPrice> get fuelPrices {
  if (_fuelPrices is EqualUnmodifiableListView) return _fuelPrices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fuelPrices);
}

@override final  EvChargeInfo? evCharge;
@override final  String? googleMapsUri;

/// Create a copy of StationDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StationDetailsCopyWith<_StationDetails> get copyWith => __$StationDetailsCopyWithImpl<_StationDetails>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StationDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.location, location) || other.location == location)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.userRatingCount, userRatingCount) || other.userRatingCount == userRatingCount)&&(identical(other.openNow, openNow) || other.openNow == openNow)&&const DeepCollectionEquality().equals(other.weekdayHours, _weekdayHours)&&const DeepCollectionEquality().equals(other.fuelPrices, _fuelPrices)&&(identical(other.evCharge, evCharge) || other.evCharge == evCharge)&&(identical(other.googleMapsUri, googleMapsUri) || other.googleMapsUri == googleMapsUri));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,location,address,phone,rating,userRatingCount,openNow,const DeepCollectionEquality().hash(_weekdayHours),const DeepCollectionEquality().hash(_fuelPrices),evCharge,googleMapsUri);
}

@override
String toString() {
    return 'StationDetails(id: $id, name: $name, location: $location, address: $address, phone: $phone, rating: $rating, userRatingCount: $userRatingCount, openNow: $openNow, weekdayHours: $weekdayHours, fuelPrices: $fuelPrices, evCharge: $evCharge, googleMapsUri: $googleMapsUri)';
}


}

/// @nodoc
abstract mixin class _$StationDetailsCopyWith<$Res> implements $StationDetailsCopyWith<$Res> {
  factory _$StationDetailsCopyWith(_StationDetails value, $Res Function(_StationDetails) _then) = __$StationDetailsCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, GeoPoint location, String? address, String? phone, double? rating, int? userRatingCount, bool? openNow, List<String> weekdayHours, List<FuelPrice> fuelPrices, EvChargeInfo? evCharge, String? googleMapsUri
});


@override $GeoPointCopyWith<$Res> get location;@override $EvChargeInfoCopyWith<$Res>? get evCharge;

}
/// @nodoc
class __$StationDetailsCopyWithImpl<$Res>
    implements _$StationDetailsCopyWith<$Res> {
  __$StationDetailsCopyWithImpl(this._self, this._then);

  final _StationDetails _self;
  final $Res Function(_StationDetails) _then;

/// Create a copy of StationDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? location = null,Object? address = freezed,Object? phone = freezed,Object? rating = freezed,Object? userRatingCount = freezed,Object? openNow = freezed,Object? weekdayHours = null,Object? fuelPrices = null,Object? evCharge = freezed,Object? googleMapsUri = freezed,}) {
  return _then(_StationDetails(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,userRatingCount: freezed == userRatingCount ? _self.userRatingCount : userRatingCount // ignore: cast_nullable_to_non_nullable
as int?,openNow: freezed == openNow ? _self.openNow : openNow // ignore: cast_nullable_to_non_nullable
as bool?,weekdayHours: null == weekdayHours ? _self._weekdayHours : weekdayHours // ignore: cast_nullable_to_non_nullable
as List<String>,fuelPrices: null == fuelPrices ? _self._fuelPrices : fuelPrices // ignore: cast_nullable_to_non_nullable
as List<FuelPrice>,evCharge: freezed == evCharge ? _self.evCharge : evCharge // ignore: cast_nullable_to_non_nullable
as EvChargeInfo?,googleMapsUri: freezed == googleMapsUri ? _self.googleMapsUri : googleMapsUri // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of StationDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res> get location {
  
  return $GeoPointCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}/// Create a copy of StationDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EvChargeInfoCopyWith<$Res>? get evCharge {
    if (_self.evCharge == null) {
    return null;
  }

  return $EvChargeInfoCopyWith<$Res>(_self.evCharge!, (value) {
    return _then(_self.copyWith(evCharge: value));
  });
}
}

/// @nodoc
mixin _$FuelPrice {

/// Raw Places fuel type code, e.g. `DIESEL`, `REGULAR_UNLEADED`, `SP95_E10`.
 String get fuelType; double get amount; String get currencyCode; DateTime? get updatedAt;
/// Create a copy of FuelPrice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FuelPriceCopyWith<FuelPrice> get copyWith => _$FuelPriceCopyWithImpl<FuelPrice>(this as FuelPrice, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FuelPrice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FuelPrice&&(identical(other.fuelType, _this.fuelType) || other.fuelType == _this.fuelType)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.currencyCode, _this.currencyCode) || other.currencyCode == _this.currencyCode)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}


@override
int get hashCode {
  final _this = this as FuelPrice;
  return Object.hash(runtimeType,_this.fuelType,_this.amount,_this.currencyCode,_this.updatedAt);
}

@override
String toString() {
  final _this = this as FuelPrice;
  return 'FuelPrice(fuelType: ${_this.fuelType}, amount: ${_this.amount}, currencyCode: ${_this.currencyCode}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $FuelPriceCopyWith<$Res>  {
  factory $FuelPriceCopyWith(FuelPrice value, $Res Function(FuelPrice) _then) = _$FuelPriceCopyWithImpl;
@useResult
$Res call({
 String fuelType, double amount, String currencyCode, DateTime? updatedAt
});




}
/// @nodoc
class _$FuelPriceCopyWithImpl<$Res>
    implements $FuelPriceCopyWith<$Res> {
  _$FuelPriceCopyWithImpl(this._self, this._then);

  final FuelPrice _self;
  final $Res Function(FuelPrice) _then;

/// Create a copy of FuelPrice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fuelType = null,Object? amount = null,Object? currencyCode = null,Object? updatedAt = freezed,}) {
  return _then(FuelPrice(
fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FuelPrice].
extension FuelPricePatterns on FuelPrice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FuelPrice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FuelPrice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FuelPrice value)  $default,){
final _that = this;
switch (_that) {
case _FuelPrice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FuelPrice value)?  $default,){
final _that = this;
switch (_that) {
case _FuelPrice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fuelType,  double amount,  String currencyCode,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FuelPrice() when $default != null:
return $default(_that.fuelType,_that.amount,_that.currencyCode,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fuelType,  double amount,  String currencyCode,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _FuelPrice():
return $default(_that.fuelType,_that.amount,_that.currencyCode,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fuelType,  double amount,  String currencyCode,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _FuelPrice() when $default != null:
return $default(_that.fuelType,_that.amount,_that.currencyCode,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _FuelPrice extends FuelPrice {
  const _FuelPrice({required this.fuelType, required this.amount, required this.currencyCode, this.updatedAt}): super._();
  

/// Raw Places fuel type code, e.g. `DIESEL`, `REGULAR_UNLEADED`, `SP95_E10`.
@override final  String fuelType;
@override final  double amount;
@override final  String currencyCode;
@override final  DateTime? updatedAt;

/// Create a copy of FuelPrice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FuelPriceCopyWith<_FuelPrice> get copyWith => __$FuelPriceCopyWithImpl<_FuelPrice>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FuelPrice&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,fuelType,amount,currencyCode,updatedAt);
}

@override
String toString() {
    return 'FuelPrice(fuelType: $fuelType, amount: $amount, currencyCode: $currencyCode, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FuelPriceCopyWith<$Res> implements $FuelPriceCopyWith<$Res> {
  factory _$FuelPriceCopyWith(_FuelPrice value, $Res Function(_FuelPrice) _then) = __$FuelPriceCopyWithImpl;
@override @useResult
$Res call({
 String fuelType, double amount, String currencyCode, DateTime? updatedAt
});




}
/// @nodoc
class __$FuelPriceCopyWithImpl<$Res>
    implements _$FuelPriceCopyWith<$Res> {
  __$FuelPriceCopyWithImpl(this._self, this._then);

  final _FuelPrice _self;
  final $Res Function(_FuelPrice) _then;

/// Create a copy of FuelPrice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fuelType = null,Object? amount = null,Object? currencyCode = null,Object? updatedAt = freezed,}) {
  return _then(_FuelPrice(
fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$EvChargeInfo {

 int? get connectorCount; List<EvConnector> get connectors;
/// Create a copy of EvChargeInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EvChargeInfoCopyWith<EvChargeInfo> get copyWith => _$EvChargeInfoCopyWithImpl<EvChargeInfo>(this as EvChargeInfo, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as EvChargeInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EvChargeInfo&&(identical(other.connectorCount, _this.connectorCount) || other.connectorCount == _this.connectorCount)&&const DeepCollectionEquality().equals(other.connectors, _this.connectors));
}


@override
int get hashCode {
  final _this = this as EvChargeInfo;
  return Object.hash(runtimeType,_this.connectorCount,const DeepCollectionEquality().hash(_this.connectors));
}

@override
String toString() {
  final _this = this as EvChargeInfo;
  return 'EvChargeInfo(connectorCount: ${_this.connectorCount}, connectors: ${_this.connectors})';
}


}

/// @nodoc
abstract mixin class $EvChargeInfoCopyWith<$Res>  {
  factory $EvChargeInfoCopyWith(EvChargeInfo value, $Res Function(EvChargeInfo) _then) = _$EvChargeInfoCopyWithImpl;
@useResult
$Res call({
 int? connectorCount, List<EvConnector> connectors
});




}
/// @nodoc
class _$EvChargeInfoCopyWithImpl<$Res>
    implements $EvChargeInfoCopyWith<$Res> {
  _$EvChargeInfoCopyWithImpl(this._self, this._then);

  final EvChargeInfo _self;
  final $Res Function(EvChargeInfo) _then;

/// Create a copy of EvChargeInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? connectorCount = freezed,Object? connectors = null,}) {
  return _then(EvChargeInfo(
connectorCount: freezed == connectorCount ? _self.connectorCount : connectorCount // ignore: cast_nullable_to_non_nullable
as int?,connectors: null == connectors ? _self.connectors : connectors // ignore: cast_nullable_to_non_nullable
as List<EvConnector>,
  ));
}

}


/// Adds pattern-matching-related methods to [EvChargeInfo].
extension EvChargeInfoPatterns on EvChargeInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EvChargeInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EvChargeInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EvChargeInfo value)  $default,){
final _that = this;
switch (_that) {
case _EvChargeInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EvChargeInfo value)?  $default,){
final _that = this;
switch (_that) {
case _EvChargeInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? connectorCount,  List<EvConnector> connectors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EvChargeInfo() when $default != null:
return $default(_that.connectorCount,_that.connectors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? connectorCount,  List<EvConnector> connectors)  $default,) {final _that = this;
switch (_that) {
case _EvChargeInfo():
return $default(_that.connectorCount,_that.connectors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? connectorCount,  List<EvConnector> connectors)?  $default,) {final _that = this;
switch (_that) {
case _EvChargeInfo() when $default != null:
return $default(_that.connectorCount,_that.connectors);case _:
  return null;

}
}

}

/// @nodoc


class _EvChargeInfo implements EvChargeInfo {
  const _EvChargeInfo({this.connectorCount,  List<EvConnector> connectors = const <EvConnector>[]}): _connectors = connectors;
  

@override final  int? connectorCount;
 final  List<EvConnector> _connectors;
@override@JsonKey() List<EvConnector> get connectors {
  if (_connectors is EqualUnmodifiableListView) return _connectors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_connectors);
}


/// Create a copy of EvChargeInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EvChargeInfoCopyWith<_EvChargeInfo> get copyWith => __$EvChargeInfoCopyWithImpl<_EvChargeInfo>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EvChargeInfo&&(identical(other.connectorCount, connectorCount) || other.connectorCount == connectorCount)&&const DeepCollectionEquality().equals(other.connectors, _connectors));
}


@override
int get hashCode {
    return Object.hash(runtimeType,connectorCount,const DeepCollectionEquality().hash(_connectors));
}

@override
String toString() {
    return 'EvChargeInfo(connectorCount: $connectorCount, connectors: $connectors)';
}


}

/// @nodoc
abstract mixin class _$EvChargeInfoCopyWith<$Res> implements $EvChargeInfoCopyWith<$Res> {
  factory _$EvChargeInfoCopyWith(_EvChargeInfo value, $Res Function(_EvChargeInfo) _then) = __$EvChargeInfoCopyWithImpl;
@override @useResult
$Res call({
 int? connectorCount, List<EvConnector> connectors
});




}
/// @nodoc
class __$EvChargeInfoCopyWithImpl<$Res>
    implements _$EvChargeInfoCopyWith<$Res> {
  __$EvChargeInfoCopyWithImpl(this._self, this._then);

  final _EvChargeInfo _self;
  final $Res Function(_EvChargeInfo) _then;

/// Create a copy of EvChargeInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? connectorCount = freezed,Object? connectors = null,}) {
  return _then(_EvChargeInfo(
connectorCount: freezed == connectorCount ? _self.connectorCount : connectorCount // ignore: cast_nullable_to_non_nullable
as int?,connectors: null == connectors ? _self._connectors : connectors // ignore: cast_nullable_to_non_nullable
as List<EvConnector>,
  ));
}


}

/// @nodoc
mixin _$EvConnector {

 String get type; double? get maxChargeRateKw; int? get count;/// Reported by Google where supported; not guaranteed real-time.
 int? get availableCount; int? get outOfServiceCount; DateTime? get availabilityUpdatedAt;
/// Create a copy of EvConnector
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EvConnectorCopyWith<EvConnector> get copyWith => _$EvConnectorCopyWithImpl<EvConnector>(this as EvConnector, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as EvConnector;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EvConnector&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.maxChargeRateKw, _this.maxChargeRateKw) || other.maxChargeRateKw == _this.maxChargeRateKw)&&(identical(other.count, _this.count) || other.count == _this.count)&&(identical(other.availableCount, _this.availableCount) || other.availableCount == _this.availableCount)&&(identical(other.outOfServiceCount, _this.outOfServiceCount) || other.outOfServiceCount == _this.outOfServiceCount)&&(identical(other.availabilityUpdatedAt, _this.availabilityUpdatedAt) || other.availabilityUpdatedAt == _this.availabilityUpdatedAt));
}


@override
int get hashCode {
  final _this = this as EvConnector;
  return Object.hash(runtimeType,_this.type,_this.maxChargeRateKw,_this.count,_this.availableCount,_this.outOfServiceCount,_this.availabilityUpdatedAt);
}

@override
String toString() {
  final _this = this as EvConnector;
  return 'EvConnector(type: ${_this.type}, maxChargeRateKw: ${_this.maxChargeRateKw}, count: ${_this.count}, availableCount: ${_this.availableCount}, outOfServiceCount: ${_this.outOfServiceCount}, availabilityUpdatedAt: ${_this.availabilityUpdatedAt})';
}


}

/// @nodoc
abstract mixin class $EvConnectorCopyWith<$Res>  {
  factory $EvConnectorCopyWith(EvConnector value, $Res Function(EvConnector) _then) = _$EvConnectorCopyWithImpl;
@useResult
$Res call({
 String type, double? maxChargeRateKw, int? count, int? availableCount, int? outOfServiceCount, DateTime? availabilityUpdatedAt
});




}
/// @nodoc
class _$EvConnectorCopyWithImpl<$Res>
    implements $EvConnectorCopyWith<$Res> {
  _$EvConnectorCopyWithImpl(this._self, this._then);

  final EvConnector _self;
  final $Res Function(EvConnector) _then;

/// Create a copy of EvConnector
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? maxChargeRateKw = freezed,Object? count = freezed,Object? availableCount = freezed,Object? outOfServiceCount = freezed,Object? availabilityUpdatedAt = freezed,}) {
  return _then(EvConnector(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,maxChargeRateKw: freezed == maxChargeRateKw ? _self.maxChargeRateKw : maxChargeRateKw // ignore: cast_nullable_to_non_nullable
as double?,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,availableCount: freezed == availableCount ? _self.availableCount : availableCount // ignore: cast_nullable_to_non_nullable
as int?,outOfServiceCount: freezed == outOfServiceCount ? _self.outOfServiceCount : outOfServiceCount // ignore: cast_nullable_to_non_nullable
as int?,availabilityUpdatedAt: freezed == availabilityUpdatedAt ? _self.availabilityUpdatedAt : availabilityUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [EvConnector].
extension EvConnectorPatterns on EvConnector {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EvConnector value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EvConnector() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EvConnector value)  $default,){
final _that = this;
switch (_that) {
case _EvConnector():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EvConnector value)?  $default,){
final _that = this;
switch (_that) {
case _EvConnector() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  double? maxChargeRateKw,  int? count,  int? availableCount,  int? outOfServiceCount,  DateTime? availabilityUpdatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EvConnector() when $default != null:
return $default(_that.type,_that.maxChargeRateKw,_that.count,_that.availableCount,_that.outOfServiceCount,_that.availabilityUpdatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  double? maxChargeRateKw,  int? count,  int? availableCount,  int? outOfServiceCount,  DateTime? availabilityUpdatedAt)  $default,) {final _that = this;
switch (_that) {
case _EvConnector():
return $default(_that.type,_that.maxChargeRateKw,_that.count,_that.availableCount,_that.outOfServiceCount,_that.availabilityUpdatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  double? maxChargeRateKw,  int? count,  int? availableCount,  int? outOfServiceCount,  DateTime? availabilityUpdatedAt)?  $default,) {final _that = this;
switch (_that) {
case _EvConnector() when $default != null:
return $default(_that.type,_that.maxChargeRateKw,_that.count,_that.availableCount,_that.outOfServiceCount,_that.availabilityUpdatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _EvConnector implements EvConnector {
  const _EvConnector({required this.type, this.maxChargeRateKw, this.count, this.availableCount, this.outOfServiceCount, this.availabilityUpdatedAt});
  

@override final  String type;
@override final  double? maxChargeRateKw;
@override final  int? count;
/// Reported by Google where supported; not guaranteed real-time.
@override final  int? availableCount;
@override final  int? outOfServiceCount;
@override final  DateTime? availabilityUpdatedAt;

/// Create a copy of EvConnector
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EvConnectorCopyWith<_EvConnector> get copyWith => __$EvConnectorCopyWithImpl<_EvConnector>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EvConnector&&(identical(other.type, type) || other.type == type)&&(identical(other.maxChargeRateKw, maxChargeRateKw) || other.maxChargeRateKw == maxChargeRateKw)&&(identical(other.count, count) || other.count == count)&&(identical(other.availableCount, availableCount) || other.availableCount == availableCount)&&(identical(other.outOfServiceCount, outOfServiceCount) || other.outOfServiceCount == outOfServiceCount)&&(identical(other.availabilityUpdatedAt, availabilityUpdatedAt) || other.availabilityUpdatedAt == availabilityUpdatedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,type,maxChargeRateKw,count,availableCount,outOfServiceCount,availabilityUpdatedAt);
}

@override
String toString() {
    return 'EvConnector(type: $type, maxChargeRateKw: $maxChargeRateKw, count: $count, availableCount: $availableCount, outOfServiceCount: $outOfServiceCount, availabilityUpdatedAt: $availabilityUpdatedAt)';
}


}

/// @nodoc
abstract mixin class _$EvConnectorCopyWith<$Res> implements $EvConnectorCopyWith<$Res> {
  factory _$EvConnectorCopyWith(_EvConnector value, $Res Function(_EvConnector) _then) = __$EvConnectorCopyWithImpl;
@override @useResult
$Res call({
 String type, double? maxChargeRateKw, int? count, int? availableCount, int? outOfServiceCount, DateTime? availabilityUpdatedAt
});




}
/// @nodoc
class __$EvConnectorCopyWithImpl<$Res>
    implements _$EvConnectorCopyWith<$Res> {
  __$EvConnectorCopyWithImpl(this._self, this._then);

  final _EvConnector _self;
  final $Res Function(_EvConnector) _then;

/// Create a copy of EvConnector
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? maxChargeRateKw = freezed,Object? count = freezed,Object? availableCount = freezed,Object? outOfServiceCount = freezed,Object? availabilityUpdatedAt = freezed,}) {
  return _then(_EvConnector(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,maxChargeRateKw: freezed == maxChargeRateKw ? _self.maxChargeRateKw : maxChargeRateKw // ignore: cast_nullable_to_non_nullable
as double?,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,availableCount: freezed == availableCount ? _self.availableCount : availableCount // ignore: cast_nullable_to_non_nullable
as int?,outOfServiceCount: freezed == outOfServiceCount ? _self.outOfServiceCount : outOfServiceCount // ignore: cast_nullable_to_non_nullable
as int?,availabilityUpdatedAt: freezed == availabilityUpdatedAt ? _self.availabilityUpdatedAt : availabilityUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
