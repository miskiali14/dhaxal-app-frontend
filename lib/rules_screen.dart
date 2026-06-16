import 'package:flutter/material.dart';
import 'package:project_graduated/provide/language_provider.dart';
import 'package:provider/provider.dart';

class Rulesscreen extends StatelessWidget {
  Rulesscreen({super.key});

  static const Color primaryColor = Color(0xFF1E3A5F);
  static const Color accentColor = Color(0xFFD4AF37);
  static const Color backgroundColor = Color(0xFFF7F9FC);
  static const Color borderColor = Color(0xFFE1E8F0);

  final List<String> ruleKeys = const [
    'rule_1',
    'husband',
    'widow',
    'father',
    'mother',
    'daughter',
    'full_sister',
    'law_of_increase',
    'law_of_return',
    'residuaries',
  ];

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          languageProvider.getText('rules_of_inheritance'),
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: languageProvider.currentLanguage,
                icon: const Icon(Icons.language, color: Colors.white),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(14),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    languageProvider.changeLanguage(newValue);
                  }
                },
                items: <String>['en', 'so']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value.toUpperCase(),
                      style: const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHeroCard(languageProvider),
            const SizedBox(height: 18),
            const Text(
              'Xeerarka Muhiimka ah',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            ...ruleKeys.map((key) => _buildRuleCard(context, key)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(LanguageProvider languageProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryColor, Color(0xFF2F5D8C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.16),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: accentColor.withOpacity(0.18),
            child: const Icon(
              Icons.gavel_rounded,
              color: accentColor,
              size: 36,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            languageProvider.getText('rules_of_inheritance'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Baro xeerarka aasaasiga ah ee dhaxalka Islaamka si aad u fahanto sida saamiyada loo qaybiyo.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              height: 1.5,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleCard(BuildContext context, String ruleKey) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ExpansionTile(
            backgroundColor: Colors.transparent,
            collapsedBackgroundColor: Colors.transparent,
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 6,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            leading: CircleAvatar(
              radius: 22,
              backgroundColor: accentColor.withOpacity(0.15),
              child: const Icon(
                Icons.menu_book_rounded,
                color: primaryColor,
              ),
            ),
            iconColor: primaryColor,
            collapsedIconColor: primaryColor,
            title: Text(
              _getRuleTitle(ruleKey, languageProvider),
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w900,
                color: primaryColor,
              ),
            ),
            children: [
              const Divider(color: borderColor),
              Text(
                languageProvider.getText(ruleKey),
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRuleTitle(String key, LanguageProvider languageProvider) {
    final isSomali = languageProvider.currentLanguage == 'so';

    final soTitles = {
      'rule_1': 'Xeerka Guud',
      'husband': 'Qaybta Ninka',
      'widow': 'Qaybta Xaaska',
      'father': 'Qaybta Aabbaha',
      'mother': 'Qaybta Hooyada',
      'daughter': 'Qaybta Gabadha',
      'full_sister': 'Qaybta Walaasha',
      'law_of_increase': 'Xeerka Kordhinta',
      'law_of_return': 'Xeerka Celinta',
      'residuaries': 'Dhaxal-qaadayaasha Haray',
    };

    final enTitles = {
      'rule_1': 'General Rule',
      'husband': 'Husband Share',
      'widow': 'Wife Share',
      'father': 'Father Share',
      'mother': 'Mother Share',
      'daughter': 'Daughter Share',
      'full_sister': 'Full Sister Share',
      'law_of_increase': 'Law of Increase',
      'law_of_return': 'Law of Return',
      'residuaries': 'Residuaries',
    };

    return isSomali ? soTitles[key] ?? key : enTitles[key] ?? key;
  }
}
