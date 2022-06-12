import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitexplorer/bloc/index.dart';

class RepositoryDetailView extends StatelessWidget {
  const RepositoryDetailView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RepositoryBloc>().state as RepositoryStateRepositoryLoaded;
    final repo = bloc.response;

    Widget _buildBackButton() {
      return InkWell(
        onTap: () {
          context.read<RepositoryBloc>().add(FetchRepositoriesEvent());
          Navigator.pop(context);
        },
        child: Image.asset('assets/icons/arrow.png'),
      );
    }

    Widget _buildDetail(String title, String value) {
      return ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(51, 60, 82, 1)),),
        trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(51, 60, 82, 1)),),
      );
    }

    Widget _buildDivider() {
      return const Divider(
        color: Color.fromRGBO(230, 230, 230, 1),
        indent: 20,
        endIndent: 20,
        height: 4.0,
        thickness: 1,
      );
    }

    Widget _buildRepoDetails() {
      final height = MediaQuery.of(context).size.height;
      return SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height / 20),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 100, maxWidth: 100),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: CachedNetworkImage(fit: BoxFit.scaleDown, imageUrl: repo.owner!.avatarUrl!,)
                ),
            ),
            SizedBox(height: height / 50),
            Text(repo.fullName!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Color.fromRGBO(51, 60, 82, 1))),
            SizedBox(height: height / 100,),
            Text(repo.language!, style: const TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(153, 157, 168, 1))),
            SizedBox(height: height / 30),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromRGBO(230, 230, 230, 1), width: 1),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  _buildDetail('Forks', repo.forksCount.toString()),
                  _buildDivider(),
                  _buildDetail('Issues', repo.openIssuesCount.toString()),
                  _buildDivider(),
                  _buildDetail('Starred by', repo.stargazersCount.toString()),
                  _buildDivider(),
                  _buildDetail('Latest Release version', ''),
                ],
              ),
            )
          ],
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20,),
                _buildBackButton(),
                _buildRepoDetails()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
