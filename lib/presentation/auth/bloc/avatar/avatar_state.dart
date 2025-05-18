part of 'avatar_bloc.dart';

@freezed
class AvatarState with _$AvatarState {
  const factory AvatarState.initial() = _Initial;
  const factory AvatarState.loading() = _Loading;
  const factory AvatarState.success(AuthResponseModel data) = _Success;
  const factory AvatarState.error(String message) = _Error;
}
