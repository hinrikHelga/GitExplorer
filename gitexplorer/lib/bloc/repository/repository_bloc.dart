import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitexplorer/repository/app_repository.dart';
import 'package:gitexplorer/model/repository.dart';

part 'repository_event.dart';

part 'repository_state.dart';


class RepositoryBloc extends Bloc<RepositoryEvent, RepositoryState> {
  final AppRepository repository;

  RepositoryBloc({required this.repository}) : super(RepositoryStateInitial()) {
    on<RepositoryEvent>((event, emit) => _onEvent(event, emit));
  }

  FutureOr<void> _onEvent(RepositoryEvent event, Emitter<RepositoryState> state) async {
    if (event is FetchRepositoriesEvent) {
      state(RepositoryStateLoading());
      try {
        final response = await repository.getRepositories(event.query);
        state(RepositoryStateRepositoriesLoaded(response));
      } catch (e) {
        state(RepositoryStateFailed(e.toString()));
      }
    }

    if (event is ClearCachedRepositoriesEvent) {
      repository.clearCache();
    }

    if (event is FetchRepositoryEvent) {
      state(RepositoryStateRepositoryLoaded(event.repo));
    }
  }
}
