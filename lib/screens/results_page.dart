import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project_graduated/utils/constants.dart';

class ResultsPage extends StatefulWidget {
  final String email;

  const ResultsPage({super.key, required this.email});

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  static const Color primaryColor = Color(0xFF1E3A5F);
  static const Color accentColor = Color(0xFFD4AF37);
  static const Color backgroundColor = Color(0xFFF7F9FC);
  static const Color borderColor = Color(0xFFE1E8F0);

  Future<List<Map<String, dynamic>>> fetchResults() async {
    final url = '$kEndpoint/results?email=${widget.email}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Cilad ayaa dhacday: ${response.body}');
    }
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  String _formatLabel(String key) {
    final labels = {
      "lacagta guud": "Lacagta Guud",
      "dhamaan wilasha la dhalay": "Dhammaan Wiilasha",
      "dhammaan wilasha la dhalay": "Dhammaan Wiilasha",
      "Dhamaan Gabdhaha la dhalay": "Dhammaan Gabdhaha",
      "Wiil Walbo": "Wiil Kasta",
      "inan Walbo": "Gabar Kasta",
      "Aabe": "Aabbe",
      "Hooyo": "Hooyo",
    };

    return labels[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Natiijooyinka La Keydiyay',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchResults(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: accentColor),
              );
            }

            if (snapshot.hasError) {
              return _buildMessageCard(
                icon: Icons.error_outline_rounded,
                iconColor: Colors.red,
                title: 'Cilad ayaa dhacday',
                message: snapshot.error.toString(),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildMessageCard(
                icon: Icons.folder_open_rounded,
                iconColor: accentColor,
                title: 'Wax natiijo ah lama helin',
                message: 'Wali ma jiraan natiijooyin dhaxal oo kuu keydsan.',
              );
            }

            final results = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final savedItem = results[index];
                final result = savedItem['result'] ?? {};

                final shares = Map<String, dynamic>.from(
                  result['shares'] ?? {},
                );

                final totalAmount = _toDouble(result['totalAmount']);
                final gender = result['gender'] ?? 'Lama yaqaan';

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.05),
                        blurRadius: 14,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: accentColor.withOpacity(0.15),
                              child: const Icon(
                                Icons.insert_chart_rounded,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Natiijo ${index + 1}',
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w900,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Divider(height: 1, color: borderColor),
                        const SizedBox(height: 14),
                        _buildInfoRow(
                          icon: Icons.account_balance_wallet_rounded,
                          title: 'Lacagta Guud',
                          value: totalAmount.toStringAsFixed(2),
                        ),
                        const SizedBox(height: 10),
                        _buildInfoRow(
                          icon: Icons.person_rounded,
                          title: 'Jinsiga',
                          value: '$gender',
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Qaybaha Dhaxalka',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...shares.entries.map<Widget>((entry) {
                          final value = _toDouble(entry.value);

                          if (value == 0) return const SizedBox.shrink();

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: borderColor),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.arrow_right_rounded,
                                  color: accentColor,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    _formatLabel(entry.key),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                                Text(
                                  value.toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF8E6B23),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: accentColor.withOpacity(0.12),
          child: Icon(icon, size: 19, color: primaryColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: primaryColor,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: borderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: iconColor.withOpacity(0.12),
                  child: Icon(icon, color: iconColor, size: 34),
                ),
                const SizedBox(height: 14),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
