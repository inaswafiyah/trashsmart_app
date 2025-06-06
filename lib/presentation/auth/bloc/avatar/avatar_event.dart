part of 'avatar_bloc.dart';

@freezed
class AvatarEvent with _$AvatarEvent {
  const factory AvatarEvent.started() = _Started;
  const factory AvatarEvent.updateAvatar(int avatarId) = _UpdateAvatar;
}