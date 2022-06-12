part of 'search_cubit.dart';

class SearchState extends Equatable {
  final String? query;
  final int? page;

  const SearchState({
    this.query,
    this.page 
  });

  SearchState copyWith({
    String? query,
    int? page
  }) => SearchState(
    query: query ?? this.query,
    page: page ?? 1);

  @override
  List<Object?> get props => [query, page];
}
