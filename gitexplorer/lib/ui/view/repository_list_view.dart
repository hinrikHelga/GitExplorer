import 'package:flutter/material.dart';

class RepositoryListView extends StatelessWidget {
  const RepositoryListView({ Key? key }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          const SizedBox(height: 100.0,),
          _buildHeading()
        ],
      ),
    );
  }
}
