import 'package:flutter/material.dart';

class RepositoryListView extends StatefulWidget {
  const RepositoryListView({ Key? key }) : super(key: key);

  @override
  State<RepositoryListView> createState() => _RepositoryListViewState();
}

class _RepositoryListViewState extends State<RepositoryListView> {
  late String search;

  @override
  void initState() {
    super.initState();
    search = '';
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

  @override
  Widget build(BuildContext context) {
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
            ],
          ),
        ),
        if (search.length < 3)
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
