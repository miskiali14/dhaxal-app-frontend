import 'package:flutter/material.dart';

class InheritanceCalculationScreen extends StatelessWidget {
  final Map<String, double> shares;

  InheritanceCalculationScreen({required this.shares});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inheritance Calculation'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: shares.length,
          itemBuilder: (context, index) {
            String heir = shares.keys.elementAt(index);
            double share = shares[heir]!;
            return ListTile(
              title: Text('$heir: \$${share.toStringAsFixed(2)}'),
            );
          },
        ),
      ),
    );
  }
}
