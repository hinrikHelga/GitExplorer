part of 'repository_bloc.dart';

abstract class RepositoryState {
  const RepositoryState();
}

class RepositoryStateEmpty extends RepositoryState {}

class RepositoryStateLoading extends RepositoryState {}

class RepositoryStateRepositoriesLoaded extends RepositoryState {
    final Repositories repositories;
    RepositoryStateRepositoriesLoaded(this.repositories);
}

class RepositoryStateRepositoryLoaded extends RepositoryState {
  final Repository repository;
  RepositoryStateRepositoryLoaded(this.repository);
}

class RepositoryStateFailed extends RepositoryState {
    final String error;
    RepositoryStateFailed(this.error);
}
