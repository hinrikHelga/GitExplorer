import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitexplorer/bloc/repository/repository_bloc.dart';
import 'package:gitexplorer/bloc/repository/search_cubit.dart';
import 'package:gitexplorer/landing_screen.dart';
import 'package:gitexplorer/repository/app_repository.dart';
import 'package:gitexplorer/repository/dio_client.dart';
import 'package:gitexplorer/utils/bloc_observer.dart';

void main() {
  BlocOverrides.runZoned(
    () {
      runApp(const MyApp());
    },
    blocObserver: AppBlocObserver()
  );
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<RepositoryBloc>(
          create: (context) => RepositoryBloc(repository: _createAppRepository()),),
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit()),
      ],
      child: const MaterialApp(
          home: LandingScreen(),
        ),
    );
  }
}
