import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project_graduated/provide/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:project_graduated/screens/result_screen.dart';
import 'package:project_graduated/service/inheritance_calculation.dart';
import 'package:provider/provider.dart';
import 'results_page.dart';
import 'package:project_graduated/utils/constants.dart';

class InheritanceCalculator extends StatefulWidget {
  const InheritanceCalculator({super.key});

  @override
  State<InheritanceCalculator> createState() => _InheritanceCalculatorState();
}

class _InheritanceCalculatorState extends State<InheritanceCalculator> {
  final TextEditingController _propertyValueController =
      TextEditingController();
  final TextEditingController _numSonsController = TextEditingController();
  final TextEditingController _numDaughtersController = TextEditingController();
  final TextEditingController _numBrothersController = TextEditingController();
  final TextEditingController _numSistersController = TextEditingController();
  final TextEditingController _numWivesController = TextEditingController();

  String _gender = "Dhadig/Dumar";
  bool _fatherPresent = false;
  bool _motherPresent = false;
  bool _paternalGrandmotherPresent = false;
  bool _paternalGrandfatherPresent = false;
  bool _husbandPresent = false;

  final Color primaryColor = const Color(0xFF1E3A5F);
  final Color accentColor = const Color(0xFFD4AF37);
  final Color backgroundColor = const Color(0xFFF7F9FC);

  @override
  void dispose() {
    _propertyValueController.dispose();
    _numSonsController.dispose();
    _numDaughtersController.dispose();
    _numBrothersController.dispose();
    _numSistersController.dispose();
    _numWivesController.dispose();
    super.dispose();
  }

  void _calculateAndNavigate() async {
    try {
      double propertyValue =
          double.tryParse(_propertyValueController.text) ?? -1;
      int numSons = int.tryParse(_numSonsController.text) ?? -1;
      int numDaughters = int.tryParse(_numDaughtersController.text) ?? -1;
      int numBrothers = int.tryParse(_numBrothersController.text) ?? -1;
      int numSisters = int.tryParse(_numSistersController.text) ?? -1;
      int numWives = _gender == "Lab/Rag"
          ? int.tryParse(_numWivesController.text) ?? -1
          : 0;

      if (propertyValue <= 0 ||
          numSons < 0 ||
          numDaughters < 0 ||
          numBrothers < 0 ||
          numSisters < 0 ||
          (_gender == "Lab/Rag" && numWives < 0)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Meel bannaan ayaa jirta. Fadlan xogta geli.'),
          ),
        );
        return;
      }

      if (_gender == "Lab/Rag" && numWives > 4) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tirada xaasaska ugu badnaan waa 4.'),
          ),
        );
        return;
      }

      var result = calculateInheritance(
        gender: _gender,
        propertyValue: propertyValue,
        numSons: numSons,
        numDaughters: numDaughters,
        numBrothers: numBrothers,
        numSisters: numSisters,
        numWives: numWives,
        fatherPresent: _fatherPresent,
        motherPresent: _motherPresent,
        paternalGrandmotherPresent: _paternalGrandmotherPresent,
        paternalGrandfatherPresent: _paternalGrandfatherPresent,
        husbandPresent: _husbandPresent,
      );

      var filteredShares = {};
      result['shares'].forEach((key, value) {
        if (value != 0) {
          filteredShares[key] = value;
        }
      });

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userEmail = userProvider.user?.email;

      // Saving history is an account feature. Guests (no email) still get
      // their result shown immediately, just without it being saved.
      if (userEmail == null || userEmail.isEmpty) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(result: result),
          ),
        );
        return;
      }

      var data = {
        'email': userEmail,
        'result': {
          'shares': filteredShares,
          'references': result['references'],
          'totalAmount': propertyValue,
          'gender': _gender,
        }
      };

      var response = await http.post(
        Uri.parse('$kEndpoint/results'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (!mounted) return;

      if (response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(result: result),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Natiijada lama keydin: ${response.body}')),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cilad ayaa dhacday: ${e.toString()}')),
      );
    }
  }

  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: primaryColor.withOpacity(0.85),
        fontWeight: FontWeight.w600,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE1E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: accentColor, width: 1.5),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _switchCard({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => onChanged(!value),
          splashColor: accentColor.withOpacity(0.10),
          highlightColor: accentColor.withOpacity(0.05),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE1E8F0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
                Switch(
                  value: value,
                  activeColor: accentColor,
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _spacing() => const SizedBox(height: 12);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Xisaabinta Dhaxalka',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () {
              if (user != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultsPage(email: '${user.email}'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User not logged in')),
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor,
                      const Color(0xFF2F5D8C),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Text(
                  'Geli xogta qoyska si app-ku u xisaabiyo saamiyada dhaxalka.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _sectionTitle('Xogta Marxuumka'),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE1E8F0)),
                ),
                child: DropdownButton<String>(
                  value: _gender,
                  isExpanded: true,
                  underline: const SizedBox(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _gender = newValue!;
                    });
                  },
                  items: <String>['Dhadig/Dumar', 'Lab/Rag']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              _spacing(),
              TextField(
                controller: _propertyValueController,
                decoration: _inputDecoration('Lacagta dhaxalka'),
                keyboardType: TextInputType.number,
              ),
              _sectionTitle('Carruurta'),
              TextField(
                controller: _numSonsController,
                decoration: _inputDecoration('Tirada wiilasha'),
                keyboardType: TextInputType.number,
              ),
              _spacing(),
              TextField(
                controller: _numDaughtersController,
                decoration: _inputDecoration('Tirada gabdhaha'),
                keyboardType: TextInputType.number,
              ),
              _sectionTitle('Walaalaha'),
              TextField(
                controller: _numBrothersController,
                decoration: _inputDecoration('Tirada walaalaha ragga ah'),
                keyboardType: TextInputType.number,
              ),
              _spacing(),
              TextField(
                controller: _numSistersController,
                decoration: _inputDecoration('Tirada walaalaha dumarka ah'),
                keyboardType: TextInputType.number,
              ),
              if (_gender == "Lab/Rag") ...[
                _sectionTitle('Xaasaska'),
                TextField(
                  controller: _numWivesController,
                  decoration: _inputDecoration('Tirada xaasaska'),
                  keyboardType: TextInputType.number,
                ),
              ],
              _sectionTitle('Waalidiin iyo Qaraabo'),
              _switchCard(
                title: "Aabbuhu ma nool yahay?",
                value: _fatherPresent,
                onChanged: (value) {
                  setState(() {
                    _fatherPresent = value;
                  });
                },
              ),
              _switchCard(
                title: "Hooyadu ma nooshahay?",
                value: _motherPresent,
                onChanged: (value) {
                  setState(() {
                    _motherPresent = value;
                  });
                },
              ),
              _switchCard(
                title: "Ayeeyadu ma nooshahay?",
                value: _paternalGrandmotherPresent,
                onChanged: (value) {
                  setState(() {
                    _paternalGrandmotherPresent = value;
                  });
                },
              ),
              _switchCard(
                title: "Awoowuhu ma nool yahay?",
                value: _paternalGrandfatherPresent,
                onChanged: (value) {
                  setState(() {
                    _paternalGrandfatherPresent = value;
                  });
                },
              ),
              if (_gender == "Dhadig/Dumar")
                _switchCard(
                  title: "Ninkeedu ma nool yahay?",
                  value: _husbandPresent,
                  onChanged: (value) {
                    setState(() {
                      _husbandPresent = value;
                    });
                  },
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _calculateAndNavigate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.calculate_rounded),
                  label: const Text(
                    'Xisaabi Dhaxalka',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
