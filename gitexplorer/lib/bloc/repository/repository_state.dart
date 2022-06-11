part of 'repository_bloc.dart';

abstract class RepositoryState {
  const RepositoryState();
}

class RepositoryStateInitial extends RepositoryState {}

class RepositoryStateLoading extends RepositoryState {}

class RepositoryStateRepositoriesLoaded extends RepositoryState {
    final Repositories response;
    RepositoryStateRepositoriesLoaded(this.response);
}

class RepositoryStateRepositoryLoaded extends RepositoryState {
  final Repository response;
  RepositoryStateRepositoryLoaded(this.response);
}

class RepositoryStateFailed extends RepositoryState {
    final String error;
    RepositoryStateFailed(this.error);
}
