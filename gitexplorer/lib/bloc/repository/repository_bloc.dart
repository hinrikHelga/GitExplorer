import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitexplorer/repository/app_repository.dart';
import 'package:gitexplorer/model/repository.dart';

part 'repository_event.dart';

part 'repository_state.dart';


class RepositoryBloc extends Bloc<RepositoryEvent, RepositoryState> {
  final AppRepository repository;

  RepositoryBloc({required this.repository}) : super(RepositoryStateEmpty()) {
    on<RepositoryEvent>((event, emit) => _onEvent(event, emit));
  }

  FutureOr<void> _onEvent(RepositoryEvent event, Emitter<RepositoryState> state) async {
    if (event is FetchRepositoriesEvent) {
      if (event.page == 1) { state(RepositoryStateLoading()); } // trigger this state only for a fresh search, which is used by the blocbuilder
      try {
        final repositories = await repository.getRepositories(event.page, event.query);
        state(RepositoryStateRepositoriesLoaded(repositories));
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

    if (event is EmptyRepositoriesEvent) {
      state(RepositoryStateEmpty());
    }
  }
}
