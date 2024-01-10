part of 'status_bloc.dart';

@immutable
abstract class StatusEvent {}

class FetchStatus extends StatusEvent{

  final String username;
  FetchStatus(this.username);

}

class FetchRecord extends StatusEvent{

  final String pid;
  final String sk;
  FetchRecord(this.pid, this.sk);

}

