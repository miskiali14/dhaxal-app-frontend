import 'package:flutter/material.dart';
import 'package:project_graduated/screens/estate_screen.dart';

class Hairscreen extends StatefulWidget {
  const Hairscreen({super.key});

  @override
  State<Hairscreen> createState() => _HairscreenState();
}

class _HairscreenState extends State<Hairscreen> {
  @override
  Widget build(BuildContext context) {
    return InheritanceCalculator();
  }
}
