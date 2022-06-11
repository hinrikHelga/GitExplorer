import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitexplorer/bloc/repository/repository_bloc.dart';
import 'package:gitexplorer/landing_screen.dart';
import 'package:gitexplorer/repository/app_repository.dart';
import 'package:gitexplorer/repository/dio_client.dart';

void main() {
  runApp(const MyApp());
}

AppRepository _createAppRepository() {
  return AppRepository(
    DioClient(ApiUrl.baseUrl).dio
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RepositoryBloc>(
      create: (context) => RepositoryBloc(repository: _createAppRepository()),
      child: const MaterialApp(
          home: LandingScreen(),
        ),
    );
  }
}
