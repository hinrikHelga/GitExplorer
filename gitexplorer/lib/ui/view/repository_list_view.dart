import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitexplorer/bloc/repository/repository_bloc.dart';
import 'package:gitexplorer/model/repository.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RepositoryListView extends StatefulWidget {
  const RepositoryListView({ Key? key }) : super(key: key);

  @override
  State<RepositoryListView> createState() => _RepositoryListViewState();
}

class _RepositoryListViewState extends State<RepositoryListView> {
  late String search;
  Timer? debouncer;

  @override
  void initState() {
    super.initState();
    search = '';
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  Widget _buildHeading() {
    return const Text(
      'Repository library',
      style: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(51, 60, 82, 1)
      ),
    );
  }

  Widget _buildEmptySearchMainText() {
    return const Padding(
      padding: EdgeInsets.only(top: 30.0, bottom: 4.0),
      child: Text(
        'A little empty',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(51, 60, 82, 1)
        ),
      ),
    );
  }

  Widget _buildEmptySearchSecondaryText() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        'Search for a repository and save it as favourite',
        style: TextStyle(
          fontSize: 14.0,
          color: Color.fromRGBO(153, 157, 168, 1)
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildEmptyColumn() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 200.0
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/empty_folder.png'),
          _buildEmptySearchMainText(),
          _buildEmptySearchSecondaryText()
        ],
      ),
    );
  }

  Widget _buildRepositoryListItem(Repository repo) {
    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          repo.imgUrl != null 
            ? CachedNetworkImage(imageUrl: repo.imgUrl!,) 
            : Image.asset('assets/icons/default_folder_icon.png')
        ],
      ),
      title: FittedBox(
        fit: BoxFit.scaleDown, 
        alignment: Alignment.centerLeft, 
        child: Text(
          repo.fullName ?? '',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(51, 60, 82, 1)
      ),)),
      subtitle: Text(repo.description ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,),
    );
  }

  Widget _buildRepositoryList() {
    final repoBloc = context.read<RepositoryBloc>().state as RepositoryStateRepositoriesLoaded;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${repoBloc.response.totalCount} results', style: const TextStyle(color: Color.fromRGBO(153, 157, 168, 1)),),
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: ListView.builder(
                itemCount: repoBloc.response.items?.length ?? 0,
                itemBuilder: ((context, index) {
                  return _buildRepositoryListItem(repoBloc.response.items![index]);
                }),
              ),
            ),
          )
        ],
      ),
    );
  }

  void debounce(VoidCallback callback, { Duration duration = const Duration(milliseconds: 1000) }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  void queryRepos() => debounce(() {
    context.read<RepositoryBloc>().add(FetchRepositoriesEvent(query: search));
  });

  @override
  Widget build(BuildContext context) {
    final bool doSearch = search.length >= 3;
    if (doSearch) {
      queryRepos();
    }
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100.0,),
              _buildHeading(),
              _SearchField(
                onChange: (value) {
                  setState(() {
                    search = value;
                  });
                },
              ),
              if (doSearch)
                BlocBuilder<RepositoryBloc, RepositoryState>(
                  builder: (context, state) {
                    if (state is RepositoryStateLoading || state is RepositoryStateInitial) {
                      return const Expanded(child: const Center(child: CircularProgressIndicator()));
                    } else if (state is RepositoryStateRepositoriesLoaded) {
                      return _buildRepositoryList();
                    } else if (state is RepositoryStateFailed) {
                      return const Center(child: Text('No result'),);
                    } else {
                      return Container();
                    }
                  }
                )
            ],
          ),
        ),
        if (!doSearch)
          Align(
            alignment: Alignment.center,
            child: _buildEmptyColumn()
          ),
      ],
    );
  }
}

class _SearchField extends StatefulWidget {
  final Function(String) onChange;

  const _SearchField({ Key? key, required this.onChange }) : super(key: key);

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  late TextEditingController _searchRepoController;

  @override
  void initState() {
    super.initState();
    _searchRepoController = TextEditingController();
  }

  @override
  void dispose() {
    _searchRepoController.dispose();  
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: TextField(
        controller: _searchRepoController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(style: BorderStyle.none),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(style: BorderStyle.none),
          ),
          filled: true,
          fillColor: const Color.fromRGBO(242, 243, 247, 1),
          prefixIcon: Image.asset('assets/icons/search_icon.png'),
          hintText: 'Search for repository'
        ),
        cursorColor: Colors.black54,
        onChanged: widget.onChange,
      ),
    );
  }
}
