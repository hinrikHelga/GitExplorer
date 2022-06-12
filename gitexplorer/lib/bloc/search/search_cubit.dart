import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchState());

  void search(String query) => emit(state.copyWith(query: query));
  void loadMoreRepositories(int page) => emit(state.copyWith(page: page));
  void resetPage() => emit(state.copyWith(page: 1));
}
