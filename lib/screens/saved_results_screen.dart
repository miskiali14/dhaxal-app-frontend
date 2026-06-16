import 'package:flutter/material.dart';
import 'package:project_graduated/screens/result_screen.dart';
import 'api_service.dart';

class SavedResultsScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

  SavedResultsScreen({super.key});

  static const Color primaryColor = Color(0xFF1E3A5F);
  static const Color accentColor = Color(0xFFD4AF37);
  static const Color backgroundColor = Color(0xFFF7F9FC);
  static const Color borderColor = Color(0xFFE1E8F0);

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
          future: apiService.getResults(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: accentColor),
              );
            }

            if (snapshot.hasError) {
              return _buildStateCard(
                icon: Icons.error_outline_rounded,
                iconColor: Colors.red,
                title: 'Cilad ayaa dhacday',
                message: '${snapshot.error}',
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildStateCard(
                icon: Icons.folder_open_rounded,
                iconColor: accentColor,
                title: 'Wax natiijo ah lama helin',
                message: 'Wali ma jiraan natiijooyin dhaxal oo la keydiyay.',
              );
            }

            final results = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final item = results[index];
                final result = item['result'] ?? item;

                final double totalAmount =
                    double.tryParse('${result['totalAmount'] ?? 0}') ?? 0.0;

                final String gender = '${result['gender'] ?? 'Lama yaqaan'}';

                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 14),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: const BorderSide(color: borderColor),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: accentColor.withOpacity(0.15),
                      child: const Icon(
                        Icons.calculate_rounded,
                        color: primaryColor,
                      ),
                    ),
                    title: Text(
                      'Natiijo ${index + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: primaryColor,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        'Lacagta Guud: ${totalAmount.toStringAsFixed(2)}\nJinsiga: $gender',
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.5,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    isThreeLine: true,
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                      color: primaryColor,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultScreen(result: result),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildStateCard({
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
