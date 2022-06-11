import 'package:dio/dio.dart';
import 'package:gitexplorer/model/repository.dart';

class AppRepository {
  final Dio dio;
  AppRepository(this.dio);

  Repositories? _repos;

  getRepositories(String? search) async {
    if (_repos != null) {
      return _repos;
    } else {
      try {
        final response = await dio. get("/search/repositories",
            queryParameters: {
              'q': search,
            }
        );
        if (response.data != null) {
          if (response.statusCode == 200 || response.statusCode == 201) {
            _repos = Repositories.fromJson(response.data);
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
  }
}
