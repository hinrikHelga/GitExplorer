part of 'repository_bloc.dart';

abstract class RepositoryEvent {}

class FetchRepositoriesEvent extends RepositoryEvent {
  final int page;
  final String? query; // nullable in case we use cached repos
  FetchRepositoriesEvent({required this.page, this.query});
}

class FetchRepositoryEvent extends RepositoryEvent {
  final Repository repo;
  FetchRepositoryEvent({required this.repo});
}

class ClearCachedRepositoriesEvent extends RepositoryEvent {}

class EmptyRepositoriesEvent extends RepositoryEvent {}
