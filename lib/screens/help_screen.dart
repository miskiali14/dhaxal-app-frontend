import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const Color primaryColor = Color(0xFF1E3A5F);
  static const Color accentColor = Color(0xFFD4AF37);
  static const Color backgroundColor = Color(0xFFF7F9FC);
  static const Color borderColor = Color(0xFFE1E8F0);

  final List<Map<String, String>> faqs = const [
    {
      'question': 'Waa maxay dhaxalka Islaamka?',
      'answer':
          'Dhaxalka Islaamka waa nidaam shareeco ah oo lagu qaybsado hantida qofka dhintay, iyadoo la raacayo xeerarka Qur’aanka iyo Sunnada.',
    },
    {
      'question': 'Yaa xaq u leh inuu dhaxlo?',
      'answer':
          'Dadka dhaxalka xaqa u leh waxaa ka mid ah carruurta, waalidka, xaaska ama ninka, iyo qaraabo kale iyadoo ku xiran xaaladda qoyska.',
    },
    {
      'question': 'Sidee loo qaybiyaa hantida qofka dhintay?',
      'answer':
          'Hantida waxaa loo qaybiyaa iyadoo la eegayo dhaxlayaasha jira, saamiyada Qur’aanka ku cad, iyo xeerarka dhaxalka Islaamka.',
    },
    {
      'question': 'Carruurtu sidee bay u dhaxlaan?',
      'answer':
          'Wiilku wuxuu helaa saamiga laba gabdhood. Tusaale ahaan, haddii ay jiraan wiil iyo gabar, wiilku wuxuu helayaa laba qaybood, gabadhuna hal qayb.',
    },
    {
      'question': 'Waalidku sidee bay u dhaxlaan?',
      'answer':
          'Haddii marxuumku carruur leeyahay, hooyada iyo aabbaha mid kasta wuxuu heli karaa lix meelood meel. Xaaladaha qaar saamigu wuu is beddeli karaa.',
    },
    {
      'question': 'Xaasku maxay dhaxashaa?',
      'answer':
          'Xaasku waxay helaysaa rubuc haddii uusan ninku carruur lahayn; haddii uu carruur leeyahayna waxay helaysaa siddeed meelood meel.',
    },
    {
      'question': 'Ninku maxuu dhaxlaa?',
      'answer':
          'Ninku wuxuu helayaa kala bar haddii xaaskiisu aysan carruur lahayn; haddii ay carruur leedahayna wuxuu helayaa rubuc.',
    },
    {
      'question': 'App-kan ma bixiyaa fatwo rasmi ah?',
      'answer':
          'Maya. App-kan wuxuu bixiyaa xisaabin guud. Arrimaha dhaxalka ee murugsan waxaa fiican in lala tashado culimo ama qareen aqoon u leh dhaxalka Islaamka.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAnswer(String question, String answer) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            question,
            style: const TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w900,
              fontSize: 17,
            ),
          ),
          content: Text(
            answer,
            style: const TextStyle(
              color: Colors.black87,
              height: 1.6,
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Xir',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(uri)) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link-ga lama furi karo. Fadlan mar kale isku day.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Xarunta Caawinta',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: accentColor,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.w800),
          tabs: const [
            Tab(text: 'Su’aalo'),
            Tab(text: 'Nala Soo Xiriir'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            buildFaqList(),
            buildContactUs(),
          ],
        ),
      ),
    );
  }

  Widget buildFaqList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeroCard(
          icon: Icons.help_outline_rounded,
          title: 'Su’aalaha Inta Badan La Isweydiiyo',
          subtitle:
              'Halkan waxaad ka heli kartaa jawaabo kooban oo ku saabsan dhaxalka Islaamka iyo isticmaalka app-ka.',
        ),
        const SizedBox(height: 16),
        ...faqs.map(
          (item) => buildFaqItem(
            item['question']!,
            item['answer']!,
          ),
        ),
      ],
    );
  }

  Widget buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _showAnswer(question, answer),
          splashColor: accentColor.withOpacity(0.10),
          highlightColor: accentColor.withOpacity(0.05),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: accentColor.withOpacity(0.15),
                  child: const Icon(
                    Icons.question_answer_rounded,
                    color: primaryColor,
                    size: 23,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: primaryColor,
                      height: 1.4,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: primaryColor,
                  size: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildContactUs() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeroCard(
          icon: Icons.support_agent_rounded,
          title: 'Nala Soo Xiriir',
          subtitle:
              'Haddii aad qabto su’aal ama aad u baahan tahay caawimaad, nala soo xiriir adigoo isticmaalaya kanaallada hoose.',
        ),
        const SizedBox(height: 16),
        buildContactButton(
          icon: CupertinoIcons.phone,
          label: 'Wac Telefoon',
          subtitle: '+252 617 372 514',
          onPressed: () => _launchURL('tel:+252617372514'),
        ),
        buildContactButton(
          icon: CupertinoIcons.mail,
          label: 'Email noo soo dir',
          subtitle: 'miskiali491@gmail.com',
          onPressed: () => _launchURL('mailto:miskiali491@gmail.com'),
        ),
        const SizedBox(height: 12),
        _buildNoticeCard(),
      ],
    );
  }

  Widget buildContactButton({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          splashColor: accentColor.withOpacity(0.10),
          highlightColor: accentColor.withOpacity(0.05),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: accentColor.withOpacity(0.15),
                  child: Icon(icon, color: primaryColor, size: 23),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: primaryColor,
                  size: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
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
            radius: 31,
            backgroundColor: accentColor.withOpacity(0.18),
            child: Icon(icon, color: accentColor, size: 34),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
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

  Widget _buildNoticeCard() {
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
              'Fiiro gaar ah: Jawaabaha caawintu waa kuwo guud. Haddii arrin dhaxal oo murugsan jirto, la tasho culimo ama qareen aqoon u leh dhaxalka Islaamka.',
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
}
