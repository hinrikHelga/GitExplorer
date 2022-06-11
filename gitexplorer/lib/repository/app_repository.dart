import 'package:dio/dio.dart';
import 'package:gitexplorer/model/repository.dart';

class AppRepository {
  final Dio dio;

  AppRepository(this.dio);

  getRepositories(String search) async {
    try {
      final response = await dio. get("/search/repositories",
          queryParameters: {
            'q': search,
          }
      );
      if (response.data != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          return Repositories.fromJson(response.data);
        }
      }
    } on DioError catch (e) {
      throw Exception(e.response ?? 'Something went wrong');
    }
  }
}
