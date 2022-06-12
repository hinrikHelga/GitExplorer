import 'package:flutter/material.dart';
import 'package:gitexplorer/ui/view/repository_list_view.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: RepositoryListView(),
      ),
    );
  }
}
