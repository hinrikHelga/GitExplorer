part of 'repository_bloc.dart';

abstract class RepositoryEvent {}

class FetchRepositoriesEvent extends RepositoryEvent {
  final String? query; // in case we use cached repos
  FetchRepositoriesEvent({this.query});
}

class FetchRepositoryEvent extends RepositoryEvent {
  final Repository repo;
  FetchRepositoryEvent({required this.repo});
}

class ClearCachedRepositoriesEvent extends RepositoryEvent {}
