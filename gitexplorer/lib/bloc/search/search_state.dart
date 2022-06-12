part of 'search_cubit.dart';

class SearchState extends Equatable {
  final String query;
  final int page;

  const SearchState({
    this.query = '',
    this.page = 1
  });

  SearchState copyWith({
    String? query,
    int? page
  }) => SearchState(
    query: query ?? this.query,
    page: page ?? this.page);

  @override
  List<Object?> get props => [query, page];
}
