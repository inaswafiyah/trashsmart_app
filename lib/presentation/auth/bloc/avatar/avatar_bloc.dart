import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trashsmart/data/datasource/auth_remote_datasource.dart';
import 'package:trashsmart/data/model/response/auth_response_model.dart';

part 'avatar_event.dart';
part 'avatar_state.dart';
part 'avatar_bloc.freezed.dart';

class AvatarBloc extends Bloc<AvatarEvent, AvatarState> {
  final AuthRemoteDatasource _authRemoteDatasource;
  AvatarBloc(this._authRemoteDatasource) : super(_Initial()) {
    on<AvatarEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
