part of 'repository_bloc.dart';

abstract class RepositoryEvent {}

class FetchRepositoriesEvent extends RepositoryEvent {
  final String query;
  FetchRepositoriesEvent({required this.query});
}
