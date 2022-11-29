import 'package:flutter/material.dart';

class Collect extends StatefulWidget {
  const Collect({Key? key}) : super(key: key);

  @override
  State<Collect> createState() => _CollectState();
}

class _CollectState extends State<Collect> {
  @override
  Widget build(BuildContext context) {
    print("Collect page");

    return Container(
      child: const Text("Collect"),
    );
  }
}
