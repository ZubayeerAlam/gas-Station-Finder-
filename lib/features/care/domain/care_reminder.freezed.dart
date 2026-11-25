// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'care_reminder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CareReminder {

 String get id; String get vehicleId; CareType get type;/// User's own name; required for [CareType.custom], optional otherwise.
 String? get title; DateTime? get dueDate; double? get dueOdometerKm;/// Repeat after "Mark done" (null = one-off).
 int? get repeatMonths; double? get repeatKm; DateTime? get lastDoneAt; double? get lastDoneKm; int get notifyDaysBefore; String? get note; DateTime get createdAt;
/// Create a copy of CareReminder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareReminderCopyWith<CareReminder> get copyWith => _$CareReminderCopyWithImpl<CareReminder>(this as CareReminder, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CareReminder;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareReminder&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.vehicleId, _this.vehicleId) || other.vehicleId == _this.vehicleId)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.dueDate, _this.dueDate) || other.dueDate == _this.dueDate)&&(identical(other.dueOdometerKm, _this.dueOdometerKm) || other.dueOdometerKm == _this.dueOdometerKm)&&(identical(other.repeatMonths, _this.repeatMonths) || other.repeatMonths == _this.repeatMonths)&&(identical(other.repeatKm, _this.repeatKm) || other.repeatKm == _this.repeatKm)&&(identical(other.lastDoneAt, _this.lastDoneAt) || other.lastDoneAt == _this.lastDoneAt)&&(identical(other.lastDoneKm, _this.lastDoneKm) || other.lastDoneKm == _this.lastDoneKm)&&(identical(other.notifyDaysBefore, _this.notifyDaysBefore) || other.notifyDaysBefore == _this.notifyDaysBefore)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}


@override
int get hashCode {
  final _this = this as CareReminder;
  return Object.hash(runtimeType,_this.id,_this.vehicleId,_this.type,_this.title,_this.dueDate,_this.dueOdometerKm,_this.repeatMonths,_this.repeatKm,_this.lastDoneAt,_this.lastDoneKm,_this.notifyDaysBefore,_this.note,_this.createdAt);
}

@override
String toString() {
  final _this = this as CareReminder;
  return 'CareReminder(id: ${_this.id}, vehicleId: ${_this.vehicleId}, type: ${_this.type}, title: ${_this.title}, dueDate: ${_this.dueDate}, dueOdometerKm: ${_this.dueOdometerKm}, repeatMonths: ${_this.repeatMonths}, repeatKm: ${_this.repeatKm}, lastDoneAt: ${_this.lastDoneAt}, lastDoneKm: ${_this.lastDoneKm}, notifyDaysBefore: ${_this.notifyDaysBefore}, note: ${_this.note}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $CareReminderCopyWith<$Res>  {
  factory $CareReminderCopyWith(CareReminder value, $Res Function(CareReminder) _then) = _$CareReminderCopyWithImpl;
@useResult
$Res call({
 String id, String vehicleId, CareType type, String? title, DateTime? dueDate, double? dueOdometerKm, int? repeatMonths, double? repeatKm, DateTime? lastDoneAt, double? lastDoneKm, int notifyDaysBefore, String? note, DateTime createdAt
});




}
/// @nodoc
class _$CareReminderCopyWithImpl<$Res>
    implements $CareReminderCopyWith<$Res> {
  _$CareReminderCopyWithImpl(this._self, this._then);

  final CareReminder _self;
  final $Res Function(CareReminder) _then;

/// Create a copy of CareReminder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vehicleId = null,Object? type = null,Object? title = freezed,Object? dueDate = freezed,Object? dueOdometerKm = freezed,Object? repeatMonths = freezed,Object? repeatKm = freezed,Object? lastDoneAt = freezed,Object? lastDoneKm = freezed,Object? notifyDaysBefore = null,Object? note = freezed,Object? createdAt = null,}) {
  return _then(CareReminder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CareType,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dueOdometerKm: freezed == dueOdometerKm ? _self.dueOdometerKm : dueOdometerKm // ignore: cast_nullable_to_non_nullable
as double?,repeatMonths: freezed == repeatMonths ? _self.repeatMonths : repeatMonths // ignore: cast_nullable_to_non_nullable
as int?,repeatKm: freezed == repeatKm ? _self.repeatKm : repeatKm // ignore: cast_nullable_to_non_nullable
as double?,lastDoneAt: freezed == lastDoneAt ? _self.lastDoneAt : lastDoneAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastDoneKm: freezed == lastDoneKm ? _self.lastDoneKm : lastDoneKm // ignore: cast_nullable_to_non_nullable
as double?,notifyDaysBefore: null == notifyDaysBefore ? _self.notifyDaysBefore : notifyDaysBefore // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CareReminder].
extension CareReminderPatterns on CareReminder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CareReminder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CareReminder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CareReminder value)  $default,){
final _that = this;
switch (_that) {
case _CareReminder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CareReminder value)?  $default,){
final _that = this;
switch (_that) {
case _CareReminder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String vehicleId,  CareType type,  String? title,  DateTime? dueDate,  double? dueOdometerKm,  int? repeatMonths,  double? repeatKm,  DateTime? lastDoneAt,  double? lastDoneKm,  int notifyDaysBefore,  String? note,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CareReminder() when $default != null:
return $default(_that.id,_that.vehicleId,_that.type,_that.title,_that.dueDate,_that.dueOdometerKm,_that.repeatMonths,_that.repeatKm,_that.lastDoneAt,_that.lastDoneKm,_that.notifyDaysBefore,_that.note,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String vehicleId,  CareType type,  String? title,  DateTime? dueDate,  double? dueOdometerKm,  int? repeatMonths,  double? repeatKm,  DateTime? lastDoneAt,  double? lastDoneKm,  int notifyDaysBefore,  String? note,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _CareReminder():
return $default(_that.id,_that.vehicleId,_that.type,_that.title,_that.dueDate,_that.dueOdometerKm,_that.repeatMonths,_that.repeatKm,_that.lastDoneAt,_that.lastDoneKm,_that.notifyDaysBefore,_that.note,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String vehicleId,  CareType type,  String? title,  DateTime? dueDate,  double? dueOdometerKm,  int? repeatMonths,  double? repeatKm,  DateTime? lastDoneAt,  double? lastDoneKm,  int notifyDaysBefore,  String? note,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CareReminder() when $default != null:
return $default(_that.id,_that.vehicleId,_that.type,_that.title,_that.dueDate,_that.dueOdometerKm,_that.repeatMonths,_that.repeatKm,_that.lastDoneAt,_that.lastDoneKm,_that.notifyDaysBefore,_that.note,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _CareReminder extends CareReminder {
  const _CareReminder({required this.id, required this.vehicleId, required this.type, this.title, this.dueDate, this.dueOdometerKm, this.repeatMonths, this.repeatKm, this.lastDoneAt, this.lastDoneKm, this.notifyDaysBefore = 7, this.note, required this.createdAt}): assert(notifyDaysBefore >= 0, 'notifyDaysBefore must not be negative'),super._();
  

@override final  String id;
@override final  String vehicleId;
@override final  CareType type;
/// User's own name; required for [CareType.custom], optional otherwise.
@override final  String? title;
@override final  DateTime? dueDate;
@override final  double? dueOdometerKm;
/// Repeat after "Mark done" (null = one-off).
@override final  int? repeatMonths;
@override final  double? repeatKm;
@override final  DateTime? lastDoneAt;
@override final  double? lastDoneKm;
@override@JsonKey() final  int notifyDaysBefore;
@override final  String? note;
@override final  DateTime createdAt;

/// Create a copy of CareReminder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CareReminderCopyWith<_CareReminder> get copyWith => __$CareReminderCopyWithImpl<_CareReminder>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CareReminder&&(identical(other.id, id) || other.id == id)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.dueOdometerKm, dueOdometerKm) || other.dueOdometerKm == dueOdometerKm)&&(identical(other.repeatMonths, repeatMonths) || other.repeatMonths == repeatMonths)&&(identical(other.repeatKm, repeatKm) || other.repeatKm == repeatKm)&&(identical(other.lastDoneAt, lastDoneAt) || other.lastDoneAt == lastDoneAt)&&(identical(other.lastDoneKm, lastDoneKm) || other.lastDoneKm == lastDoneKm)&&(identical(other.notifyDaysBefore, notifyDaysBefore) || other.notifyDaysBefore == notifyDaysBefore)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,vehicleId,type,title,dueDate,dueOdometerKm,repeatMonths,repeatKm,lastDoneAt,lastDoneKm,notifyDaysBefore,note,createdAt);
}

@override
String toString() {
    return 'CareReminder(id: $id, vehicleId: $vehicleId, type: $type, title: $title, dueDate: $dueDate, dueOdometerKm: $dueOdometerKm, repeatMonths: $repeatMonths, repeatKm: $repeatKm, lastDoneAt: $lastDoneAt, lastDoneKm: $lastDoneKm, notifyDaysBefore: $notifyDaysBefore, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CareReminderCopyWith<$Res> implements $CareReminderCopyWith<$Res> {
  factory _$CareReminderCopyWith(_CareReminder value, $Res Function(_CareReminder) _then) = __$CareReminderCopyWithImpl;
@override @useResult
$Res call({
 String id, String vehicleId, CareType type, String? title, DateTime? dueDate, double? dueOdometerKm, int? repeatMonths, double? repeatKm, DateTime? lastDoneAt, double? lastDoneKm, int notifyDaysBefore, String? note, DateTime createdAt
});




}
/// @nodoc
class __$CareReminderCopyWithImpl<$Res>
    implements _$CareReminderCopyWith<$Res> {
  __$CareReminderCopyWithImpl(this._self, this._then);

  final _CareReminder _self;
  final $Res Function(_CareReminder) _then;

/// Create a copy of CareReminder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vehicleId = null,Object? type = null,Object? title = freezed,Object? dueDate = freezed,Object? dueOdometerKm = freezed,Object? repeatMonths = freezed,Object? repeatKm = freezed,Object? lastDoneAt = freezed,Object? lastDoneKm = freezed,Object? notifyDaysBefore = null,Object? note = freezed,Object? createdAt = null,}) {
  return _then(_CareReminder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CareType,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dueOdometerKm: freezed == dueOdometerKm ? _self.dueOdometerKm : dueOdometerKm // ignore: cast_nullable_to_non_nullable
as double?,repeatMonths: freezed == repeatMonths ? _self.repeatMonths : repeatMonths // ignore: cast_nullable_to_non_nullable
as int?,repeatKm: freezed == repeatKm ? _self.repeatKm : repeatKm // ignore: cast_nullable_to_non_nullable
as double?,lastDoneAt: freezed == lastDoneAt ? _self.lastDoneAt : lastDoneAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastDoneKm: freezed == lastDoneKm ? _self.lastDoneKm : lastDoneKm // ignore: cast_nullable_to_non_nullable
as double?,notifyDaysBefore: null == notifyDaysBefore ? _self.notifyDaysBefore : notifyDaysBefore // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
