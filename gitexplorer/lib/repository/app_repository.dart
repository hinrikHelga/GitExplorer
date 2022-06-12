import 'package:dio/dio.dart';
import 'package:gitexplorer/model/repository.dart';

class AppRepository {
  final Dio dio;
  AppRepository(this.dio);

  Repositories _repos = const Repositories.empty();
  int _page = 1;

  /// Fetch data on GitHub repositories.
  /// 
  /// Throws a [DioError] for a failed response.
  Future<Repositories> getRepositories(int page, String? search) async {
    /**
     * If the pages requested
     */
    if (_repos.isNotEmpty && _page == page) {
      return _repos; // return cached repos without any additions.
    } else {
      try {
        final response = await dio. get("/search/repositories",
            queryParameters: {
              "page": page,
              'per_page': 30,
              'q': search,
            }
        );
        if (response.data != null) {
          if (response.statusCode == 200 || response.statusCode == 201) {
            if (_repos.isNotEmpty) {
              // fetches next pagination and add result to cahced repos.
              _repos.items!.addAll(Repositories.fromJson(response.data).items!.toList());
              _page = page;
            } else {
              // fresh search
              _page = page;
              _repos = Repositories.fromJson(response.data);
            }
          }
        }
        return _repos;
      } on DioError catch (e) {
        throw Exception(e.response ?? 'Something went wrong');
      }
    }
  }

  clearCache() {
    _repos = const Repositories.empty();
    _page = 0;
  }
}
