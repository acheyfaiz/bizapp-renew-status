part of 'status_bloc.dart';

@immutable
abstract class StatusState {
  const StatusState();
}

/// do initial state
class StatusInitial extends StatusState {

  // @override
  // List<Object?> get props => [];

}

/// do loading state
class StatusLoading extends StatusState {

  // @override
  // List<Object?> get props => [];
}

/// do loaded state
class StatusLoaded extends StatusState {

  final Profile profile;
  final Statistik statistik;
  const StatusLoaded(this.profile, this.statistik);

  // @override
  // List<Object?> get props => [profile];
}

class RecordLoaded extends StatusState {

  // final TotalRekodTempahan rekodTempahan;
  final String pid;
  final String sk;
  const RecordLoaded(this.pid, this.sk);

  // @override
  // List<Object?> get props => [profile];
}

/// do error state
class StatusError extends StatusState {

  final String message;
  const StatusError(this.message);

  // @override
  // List<Object?> get props => [message];

}
