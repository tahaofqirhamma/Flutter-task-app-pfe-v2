import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SigupView extends StatefulWidget {
  const SigupView({super.key});

  @override
  State<SigupView> createState() => _SigupViewState();
}

class _SigupViewState extends State<SigupView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign up")),
      body: const Text("HNA RADI YKON LOGIN"),
    );
  }
}
