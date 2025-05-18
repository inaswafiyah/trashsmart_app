// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'avatar_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AvatarEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AvatarEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AvatarEvent()';
}


}

/// @nodoc
class $AvatarEventCopyWith<$Res>  {
$AvatarEventCopyWith(AvatarEvent _, $Res Function(AvatarEvent) __);
}


/// @nodoc


class _Started implements AvatarEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AvatarEvent.started()';
}


}




/// @nodoc


class _UpdateAvatar implements AvatarEvent {
  const _UpdateAvatar(this.avatarId);
  

 final  int avatarId;

/// Create a copy of AvatarEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateAvatarCopyWith<_UpdateAvatar> get copyWith => __$UpdateAvatarCopyWithImpl<_UpdateAvatar>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateAvatar&&(identical(other.avatarId, avatarId) || other.avatarId == avatarId));
}


@override
int get hashCode => Object.hash(runtimeType,avatarId);

@override
String toString() {
  return 'AvatarEvent.updateAvatar(avatarId: $avatarId)';
}


}

/// @nodoc
abstract mixin class _$UpdateAvatarCopyWith<$Res> implements $AvatarEventCopyWith<$Res> {
  factory _$UpdateAvatarCopyWith(_UpdateAvatar value, $Res Function(_UpdateAvatar) _then) = __$UpdateAvatarCopyWithImpl;
@useResult
$Res call({
 int avatarId
});




}
/// @nodoc
class __$UpdateAvatarCopyWithImpl<$Res>
    implements _$UpdateAvatarCopyWith<$Res> {
  __$UpdateAvatarCopyWithImpl(this._self, this._then);

  final _UpdateAvatar _self;
  final $Res Function(_UpdateAvatar) _then;

/// Create a copy of AvatarEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? avatarId = null,}) {
  return _then(_UpdateAvatar(
null == avatarId ? _self.avatarId : avatarId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$AvatarState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AvatarState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AvatarState()';
}


}

/// @nodoc
class $AvatarStateCopyWith<$Res>  {
$AvatarStateCopyWith(AvatarState _, $Res Function(AvatarState) __);
}


/// @nodoc


class _Initial implements AvatarState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AvatarState.initial()';
}


}




/// @nodoc


class _Loading implements AvatarState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AvatarState.loading()';
}


}




/// @nodoc


class _Success implements AvatarState {
  const _Success(this.data);
  

 final  AuthResponseModel data;

/// Create a copy of AvatarState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessCopyWith<_Success> get copyWith => __$SuccessCopyWithImpl<_Success>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'AvatarState.success(data: $data)';
}


}

/// @nodoc
abstract mixin class _$SuccessCopyWith<$Res> implements $AvatarStateCopyWith<$Res> {
  factory _$SuccessCopyWith(_Success value, $Res Function(_Success) _then) = __$SuccessCopyWithImpl;
@useResult
$Res call({
 AuthResponseModel data
});




}
/// @nodoc
class __$SuccessCopyWithImpl<$Res>
    implements _$SuccessCopyWith<$Res> {
  __$SuccessCopyWithImpl(this._self, this._then);

  final _Success _self;
  final $Res Function(_Success) _then;

/// Create a copy of AvatarState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_Success(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AuthResponseModel,
  ));
}


}

/// @nodoc


class _Error implements AvatarState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of AvatarState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AvatarState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $AvatarStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of AvatarState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
