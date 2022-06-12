import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final Function(String) onChange;
  final String hintText;

  const SearchField({ Key? key, required this.onChange, required this.hintText }) : super(key: key);

  @override
  State<SearchField> createState() => SearchFieldState();
}

class SearchFieldState extends State<SearchField> {
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
          hintText: widget.hintText
        ),
        cursorColor: Colors.black54,
        onChanged: widget.onChange,
      ),
    );
  }
}
