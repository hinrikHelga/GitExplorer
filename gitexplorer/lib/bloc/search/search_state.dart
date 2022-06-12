part of 'search_cubit.dart';

class SearchState extends Equatable {
  final String query;

  const SearchState({
    required this.query
  });

  SearchState copyWith({
    required String query
  }) => SearchState(query: query);

  @override
  List<Object?> get props => [query];
}
