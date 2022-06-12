import 'package:dio/dio.dart';
import 'package:gitexplorer/model/repository.dart';

class AppRepository {
  final Dio dio;
  AppRepository(this.dio);

  Repositories? _repos;
  int? _page;

  getRepositories(int? page, String? search) async {
    bool _reposExist = _repos != null;
    if (_reposExist && _page == (page ?? 1)) {
      return _repos;
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
            if (_reposExist) {
              // fetches next pagination
              _repos!.items!.addAll(Repositories.fromJson(response.data).items!.toList());
              _page = page;
            } else {
              // fresh search
              _page = page;
              _repos = Repositories.fromJson(response.data);
            }
            return _repos;
          }
        }
      } on DioError catch (e) {
        throw Exception(e.response ?? 'Something went wrong');
      }
    }
  }

  clearCache() {
    _repos = null;
    _page = 0;
  }
}
