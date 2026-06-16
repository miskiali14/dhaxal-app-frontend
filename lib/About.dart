import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  AboutPage({super.key});

  static const Color primaryColor = Color(0xFF1E3A5F);
  static const Color accentColor = Color(0xFFD4AF37);
  static const Color backgroundColor = Color(0xFFF7F9FC);
  static const Color borderColor = Color(0xFFE1E8F0);

  final List<String> teamMembers = const [
    'Miski Ali Haashi - Mobile App Developer',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Ku Saabsan App-ka',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHeroCard(),
            const SizedBox(height: 16),
            _buildSectionCard(
              icon: Icons.info_outline_rounded,
              title: 'Hordhac',
              child: const Text(
                'Dhaxal App waa barnaamij loogu talagalay in uu fududeeyo xisaabinta saamiyada dhaxalka iyadoo la raacayo qawaaniinta dhaxalka Islaamka. App-ku wuxuu ka caawinayaa isticmaalaha inuu fahmo qaybaha dhaxlayaasha, natiijada xisaabinta, iyo daliillada Qur’aanka ee la xiriira.',
                style: _bodyStyle,
              ),
            ),
            const SizedBox(height: 14),
            _buildSectionCard(
              icon: Icons.star_outline_rounded,
              title: 'Astaamaha App-ka',
              child: Column(
                children: const [
                  _FeatureItem(
                    icon: Icons.calculate_rounded,
                    text: 'Xisaabinta saamiyada dhaxalka.',
                  ),
                  _FeatureItem(
                    icon: Icons.menu_book_rounded,
                    text: 'Daliillo Qur’aan ah oo la xiriira dhaxalka.',
                  ),
                  _FeatureItem(
                    icon: Icons.insert_chart_rounded,
                    text: 'Soo bandhigid natiijooyin cad oo faahfaahsan.',
                  ),
                  _FeatureItem(
                    icon: Icons.history_rounded,
                    text: 'Kaydinta iyo dib-u-eegista natiijooyinkii hore.',
                  ),
                  _FeatureItem(
                    icon: Icons.phone_android_rounded,
                    text: 'Naqshad fudud oo mobile-ka ku habboon.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _buildSectionCard(
              icon: Icons.settings_suggest_rounded,
              title: 'Sida uu u shaqeeyo',
              child: Column(
                children: const [
                  _StepItem(number: '1', text: 'Geli lacagta dhaxalka.'),
                  _StepItem(
                    number: '2',
                    text: 'Dooro qaraabada nool iyo tiradooda.',
                  ),
                  _StepItem(
                    number: '3',
                    text: 'Riix badhanka xisaabinta.',
                  ),
                  _StepItem(
                    number: '4',
                    text: 'Eeg saamiyada, chart-ka, iyo daliillada.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _buildQuranCard(),
            const SizedBox(height: 14),
            _buildSectionCard(
              icon: Icons.groups_rounded,
              title: 'Team',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: teamMembers
                    .map(
                      (member) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 17,
                              backgroundColor: accentColor.withOpacity(0.15),
                              child: const Icon(
                                Icons.person_rounded,
                                color: primaryColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                member,
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 14),
            _buildSectionCard(
              icon: Icons.contact_support_rounded,
              title: 'Contact Us',
              child: Column(
                children: const [
                  _InfoRow(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    value: 'miskiali491@gmail.com',
                  ),
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    title: 'Location',
                    value: 'Mogadishu, Somalia',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _buildSectionCard(
              icon: Icons.verified_rounded,
              title: 'App Information',
              child: Column(
                children: const [
                  _InfoRow(
                    icon: Icons.apps_rounded,
                    title: 'App Name',
                    value: 'Dhaxal App',
                  ),
                  _InfoRow(
                    icon: Icons.new_releases_outlined,
                    title: 'Version',
                    value: '1.0.0',
                  ),
                  _InfoRow(
                    icon: Icons.developer_mode_rounded,
                    title: 'Developer',
                    value: 'Miski Ali Haashi',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _buildPolicyCard(),
            const SizedBox(height: 14),
            _buildDisclaimerCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryColor, Color(0xFF2F5D8C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: const [
          CircleAvatar(
            radius: 34,
            backgroundColor: Color(0x33D4AF37),
            child: Icon(
              Icons.account_balance_rounded,
              color: accentColor,
              size: 38,
            ),
          ),
          SizedBox(height: 14),
          Text(
            'Dhaxal App',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Xisaabinta dhaxalka Islaamka si fudud, cad, oo la fahmi karo.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuranCard() {
    return _buildSectionCard(
      icon: Icons.menu_book_rounded,
      title: 'Tixraacyada Qur’aanka',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Qur’aanka Kariimka ah wuxuu si cad uga hadlay dhaxalka, gaar ahaan Suuradda An-Nisa.',
            style: _bodyStyle,
          ),
          SizedBox(height: 12),
          _QuranVerse(
            title: 'Suuradda An-Nisa (4:11)',
            arabic:
                'يُوصِيكُمُ اللَّهُ فِي أَوْلَادِكُمْ ۖ لِلذَّكَرِ مِثْلُ حَظِّ الأُنثَيَيْنِ',
          ),
          SizedBox(height: 12),
          _QuranVerse(
            title: 'Suuradda An-Nisa (4:12)',
            arabic:
                'وَلَكُمْ نِصْفُ مَا تَرَكَ أَزْوَاجُكُمْ إِنْ لَمْ يَكُنْ لَهُنَّ وَلَدٌ',
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyCard() {
    return _buildSectionCard(
      icon: Icons.privacy_tip_outlined,
      title: 'Privacy & Terms',
      child: const Text(
        'App-ku wuxuu kaydin karaa natiijooyinka xisaabinta si isticmaaluhu dib ugu eego. Xogta waxaa loo isticmaalaa oo keliya ujeeddada adeegga app-ka. Isticmaaluhu waa inuu hubiyaa xogta uu gelinayo kahor inta uusan natiijada isticmaalin.',
        style: _bodyStyle,
      ),
    );
  }

  Widget _buildDisclaimerCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accentColor.withOpacity(0.35)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: primaryColor, size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Fiiro gaar ah: App-kan wuxuu bixiyaa xisaabin guud. Arrimaha dhaxalka ee murugsan waxaa wanaagsan in lala tashado culimo ama qareen aqoon u leh dhaxalka Islaamka.',
              style: TextStyle(
                color: primaryColor,
                height: 1.5,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: accentColor.withOpacity(0.15),
                child: Icon(icon, color: primaryColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  static const TextStyle _bodyStyle = TextStyle(
    color: Colors.black87,
    fontSize: 14.5,
    height: 1.6,
    fontWeight: FontWeight.w500,
  );
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureItem({
    required this.icon,
    required this.text,
  });

  static const Color primaryColor = Color(0xFF1E3A5F);
  static const Color accentColor = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 21),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: primaryColor,
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String number;
  final String text;

  const _StepItem({
    required this.number,
    required this.text,
  });

  static const Color primaryColor = Color(0xFF1E3A5F);
  static const Color accentColor = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: accentColor,
            child: Text(
              number,
              style: const TextStyle(
                color: primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  static const Color primaryColor = Color(0xFF1E3A5F);
  static const Color accentColor = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: accentColor.withOpacity(0.15),
            child: Icon(icon, color: primaryColor, size: 19),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuranVerse extends StatelessWidget {
  final String title;
  final String arabic;

  const _QuranVerse({
    required this.title,
    required this.arabic,
  });

  static const Color primaryColor = Color(0xFF1E3A5F);
  static const Color backgroundColor = Color(0xFFF7F9FC);
  static const Color borderColor = Color(0xFFE1E8F0);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            arabic,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: primaryColor,
              fontSize: 18,
              height: 1.8,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
