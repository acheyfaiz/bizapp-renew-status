import 'package:bizapptrack/bloc_status/statistic_model.dart';
import 'package:bizapptrack/bloc_status/user_model.dart';
import 'package:bizapptrack/bloc_status/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'status_event.dart';
part 'status_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  StatusBloc() : super(StatusInitial()) {
    on<StatusEvent>((event, emit) async {
      // TODO: implement event handler
      await loginUser(emit, event);
    });
  }

  final StatusRepository statusRepository = StatusRepository();

  loginUser(Emitter<StatusState> emit, StatusEvent event) async {
    emit(StatusLoading());

    if(event is FetchStatus){
      emit(StatusLoading());
      try{
        final user = await statusRepository.loginServices(userid: event.username);
        final stats = await statusRepository.dedagangServices(pid: user.pid!);
        // final record = await statusRepository.recordServices(pid: user.pid!, sk: user.secretkey!);

        if(user != null){
          emit(StatusLoaded(user, stats));
        } else{
          emit(const StatusError("emit is null"));
        }
        /// todo: sambung sini buat loop FetchRecord

        // if(record != null){
        //   print('load record');
        //   emit(RecordLoaded(record));
        // } else {
        //   print('emit record is null');
        //   emit(StatusError("emit is null"));
        // }


      } catch (e) {
        emit(StatusError("Failed fetch login ${e.toString()}"));
      }
    }

  }

  // Stream<StatusState> mapEventToState(StatusEvent event) async* {
  //
  //   if(event is FetchStatus){
  //     yield StatusLoading();
  //     try{
  //       final user = await statusRepository.loginServices(userid: event.username);
  //       yield StatusLoaded(user);
  //     } catch (e) {
  //       yield const StatusError("Failed fetch login");
  //     }
  //   }
  // }

}
