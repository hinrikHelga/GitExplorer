import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitexplorer/bloc/index.dart';
import 'package:gitexplorer/model/repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gitexplorer/ui/view/repository_detail_view.dart';
import 'package:gitexplorer/ui/widget/search_field.dart';

final bucketGlobal = PageStorageBucket();

class RepositoryListView extends StatefulWidget {
  const RepositoryListView({ Key? key }) : super(key: key);

  @override
  State<RepositoryListView> createState() => _RepositoryListViewState();
}

class _RepositoryListViewState extends State<RepositoryListView> {
  Timer? debouncer;
  late ScrollController _scrollController;
  late bool _showSpinner;

  @override
  void initState() {
    super.initState();
    _showSpinner = false;
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    _scrollController.dispose();
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
    var height = MediaQuery.of(context).size.height;

    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 200.0
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height / 5,
            ),
            Image.asset('assets/images/empty_folder.png'),
            _buildEmptySearchMainText(),
            _buildEmptySearchSecondaryText()
          ],
        ),
      ),
    );
  }

  Widget _buildRepositoryListItem(Repository repo) {
    return InkWell(
      onTap: () {
        context.read<RepositoryBloc>().add(FetchRepositoryEvent(repo: repo));
      },
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            repo.owner?.avatarUrl != null 
              ? SizedBox(width: 50, child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(fit: BoxFit.scaleDown, imageUrl: repo.owner!.avatarUrl!,)
                  )) 
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
      ),
    );
  }

  Widget _buildRepositoryList() {
    final repoBloc = context.read<RepositoryBloc>().state as RepositoryStateRepositoriesLoaded;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${repoBloc.repositories.totalCount} results', style: const TextStyle(color: Color.fromRGBO(153, 157, 168, 1)),),
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: NotificationListener(
                onNotification: (noty) {
                  if (noty is ScrollEndNotification && _scrollController.position.extentAfter == 0) {
                    debugPrint('$noty');
                    var cubit = context.read<SearchCubit>();
                    cubit.loadMoreRepositories(cubit.state.page + 1);
                  }
                  return false;
                },
                child: PageStorage(
                  bucket: bucketGlobal,
                  child: ListView.builder(
                    key: const PageStorageKey<String>('repositoryPage'),
                    controller: _scrollController,
                    itemCount: (repoBloc.repositories.items?.length ?? 0),
                    itemBuilder: ((context, index) {
                      return _buildRepositoryListItem(repoBloc.repositories.items![index]);
                    }),
                  ),
                ),
              ),
            ),
          ),
          if (_showSpinner) const Center(child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),)
        ],
      ),
    );
  }

  // give user a bit of time to finish typing a query before fetching from the API
  void debounce(VoidCallback callback, { Duration duration = const Duration(milliseconds: 1000) }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  void queryRepos() => debounce(() {
    final cubit = context.read<SearchCubit>();
    context.read<RepositoryBloc>().add(FetchRepositoriesEvent(query: cubit.state.query, page: cubit.state.page));
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return BlocConsumer<SearchCubit, SearchState>(
      listenWhen: (previous, current) {
        /**
         *  Clear cached repositories in case of a new query.
         *  If this condition isn't met, then the listener to fetch more repositories will not be invoked,
         *  and the app will use the cached repositories from a previous request to display for the user.
         */
        if (previous.query != current.query) {
          context.read<RepositoryBloc>().add(ClearCachedRepositoriesEvent());
          return true;
        }

        // fetch next batch of repositories
        if (previous.page < current.page) {
          setState(() {
            _showSpinner = true;
          });
          return true;
        }

        return false;
      },
      listener: ((context, state) {
        if (state.query!.length >= 3) {
          queryRepos();
        }
      }),
      builder: ((context, state) => Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height / 15),
                  _buildHeading(),
                  SearchField(
                    hintText: 'Search for repository',
                    onChange: (value) {
                      context.read<SearchCubit>().search(value);
                    },
                  ),
                    BlocConsumer<RepositoryBloc, RepositoryState>(
                      listener: ((context, state) {
                         /**
                         * If the spinner is on, it means that the user has already attmepted to load more repositories.
                         * If the current state is 'RepositoriesLoaded', it means the app has fetched more repos to state so the spinner can be closed.
                         */
                        if (_showSpinner && state is RepositoryStateRepositoriesLoaded) {
                          setState(() {
                            _showSpinner = false;
                          });
                        }
                        // navigate the user to new screen if he tabs on a specific repository
                        if (state is RepositoryStateRepositoryLoaded) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return BlocProvider.value(
                                  value: BlocProvider.of<RepositoryBloc>(context),  // get the existing instance of the bloc with the repository to show to the user.
                                  child: const RepositoryDetailView(),
                                );
                              },
                            ),
                          );
                        }
                      }),
                      builder: (context, state) {
                        if (state is RepositoryStateEmpty || context.read<SearchCubit>().state.query!.length < 3) {
                          return _buildEmptyColumn();
                        } else if (state is RepositoryStateLoading) {
                          return const Expanded(child: Center(child: CircularProgressIndicator()));
                        } else if (state is RepositoryStateRepositoriesLoaded) {
                          return _buildRepositoryList();
                        } else if (state is RepositoryStateFailed) {
                          return Expanded(child: Center(child: Text('Something went wrong: ${state.error}'),));
                        } else {
                          return const Expanded(child: Center(child: Text('No result'),));
                        }
                      }
                    )
                ],
              ),
            ),
          ],
      )
    ));
  }
}
