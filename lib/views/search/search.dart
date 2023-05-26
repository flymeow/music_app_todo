import 'package:flutter/material.dart';
import 'package:flutter_music/common/custom_bar/custom_bar.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomBar(
        height: 44,
        backgroundColor: Colors.white,
        autoFocus: true,
        actions: [],
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Open route'),
          onPressed: () {
          },
        ),
      ),
    );
  }
}
