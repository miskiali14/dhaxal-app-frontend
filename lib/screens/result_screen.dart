import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'quran_reference_screen.dart';
import 'share_data.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  ResultScreen({super.key, required this.result});

  static const Color primaryColor = Color(0xFF1E3A5F);
  static const Color accentColor = Color(0xFFD4AF37);
  static const Color backgroundColor = Color(0xFFF7F9FC);
  static const Color borderColor = Color(0xFFE1E8F0);

  final Map<String, List<String>> quranicTexts = {
    "Xaasaska Qaybtooda": [
      "وَلَهُنَّ الرُّبُعُ مِمَّا تَرَكْتُمْ إِنْ لَمْ يَكُنْ لَكُمْ وَلَدٌ ۖ فَإِنْ كَانَ لَكُمْ وَلَدٌ فَلَهُنَّ الثُّمُنُ مِمَّا تَرَكْتُمْ...",
      "Xaasasku waxay leeyihiin rubuc haddii uusan marxuumku ilmo lahayn; haddii uu ilmo leeyahayna waxay leeyihiin siddeed meelood meel."
    ],
    "Ninka Qaybtiisa": [
      "وَلَكُمْ نِصْفُ مَا تَرَكَ أَزْوَاجُكُمْ إِنْ لَمْ يَكُنْ لَهُنَّ وَلَدٌ...",
      "Ninku wuxuu leeyahay kala bar waxa xaaskiisu ka tagtay haddii aysan ilmo lahayn; haddii ay ilmo leedahayna wuxuu leeyahay rubuc."
    ],
    "Aabaha qaybtiisa": [
      "وَلِأَبَوَيْهِ لِكُلِّ وَاحِدٍ مِنْهُمَا السُّدُسُ...",
      "Aabbaha iyo hooyada mid kasta wuxuu leeyahay lix meelood meel haddii marxuumku ilmo leeyahay."
    ],
    "Hooyada Qaybteeda": [
      "وَلِأَبَوَيْهِ لِكُلِّ وَاحِدٍ مِنْهُمَا السُّدُسُ...",
      "Hooyadu waxay leedahay lix meelood meel haddii marxuumku ilmo leeyahay."
    ],
    "Wilasha Qeebtoda": [
      "يُوصِيكُمُ اللَّهُ فِي أَوْلَادِكُمْ ۖ لِلذَّكَرِ مِثْلُ حَظِّ الأُنثَيَيْنِ...",
      "Wiilku wuxuu leeyahay saamiga laba gabdhood."
    ],
    "Gabdhaha Qaybtooda": [
      "يُوصِيكُمُ اللَّهُ فِي أَوْلَادِكُمْ...",
      "Gabdhuhu waxay leeyihiin saamigooda sida ku cad aayadaha dhaxalka."
    ],
    "Walaalaha Qeebtoda/Wilasha/Gabdhaha": [
      "وَإِن كَانَ رَجُلٌ يُورَثُ كَلَٰلَةً...",
      "Haddii walaalo dhaxlayaan, saamigoodu wuxuu ku xirnaanayaa xaaladda qoyska."
    ],
    "Awoowaha/Ayeeyo Qeebtooda": [
      "وَلِأَبَوَيْهِ لِكُلِّ وَاحِدٍ مِنْهُمَا السُّدُسُ...",
      "Awoowaha ama ayeeyadu waxay heli karaan saamiga waalidka marka xaaladdu sidaas noqoto."
    ],
    "Paternal Grandfather Share": [
      "وَلِأَبَوَيْهِ لِكُلِّ وَاحِدٍ مِنْهُمَا السُّدُسُ...",
      "Awoowaha wuxuu heli karaa saamiga waalidka marka shuruudaha la buuxiyo."
    ],
  };

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
      "Aabaha qaybtiisa": "Qaybta Aabbaha",
      "Hooyada Qaybteeda": "Qaybta Hooyada",
      "Wilasha Qeebtoda": "Qaybta Wiilasha",
      "Gabdhaha Qaybtooda": "Qaybta Gabdhaha",
      "Xaasaska Qaybtooda": "Qaybta Xaasaska",
      "Ninka Qaybtiisa": "Qaybta Ninka",
      "Walaalaha Qeebtoda/Wilasha/Gabdhaha": "Qaybta Walaalaha",
      "Awoowaha/Ayeeyo Qeebtooda": "Qaybta Awoowaha/Ayeeyada",
    };

    return labels[key] ?? key;
  }

  bool _isGeneralAmount(String key) {
    return key.toLowerCase().contains('lacagta guud');
  }

  @override
  Widget build(BuildContext context) {
    final shares = Map<String, dynamic>.from(result["shares"] ?? {});
    final references = Map<String, dynamic>.from(result["references"] ?? {});
    final totalAmount = _toDouble(result["totalAmount"]);

    final chartColors = [
      accentColor,
      primaryColor,
      const Color(0xFF2F5D8C),
      const Color(0xFF8E6B23),
      const Color(0xFF6C7A89),
      const Color(0xFF9B59B6),
      const Color(0xFFE67E22),
      const Color(0xFF16A085),
      const Color(0xFFC0392B),
      const Color(0xFF34495E),
    ];

    final chartEntries = shares.entries.where((entry) {
      final key = entry.key;
      final value = _toDouble(entry.value);

      return value > 0 &&
          !_isGeneralAmount(key) &&
          !key.toLowerCase().contains('walbo') &&
          !key.toLowerCase().contains('kasta');
    }).toList();

    final chartData = chartEntries.asMap().entries.map((item) {
      final index = item.key;
      final entry = item.value;

      return ShareData(
        _formatLabel(entry.key),
        _toDouble(entry.value),
        chartColors[index % chartColors.length],
      );
    }).toList();

    final totalShare = chartData.fold<double>(
      0,
      (sum, item) => sum + item.share,
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Natiijada Dhaxalka',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSummaryCard(totalAmount),
            const SizedBox(height: 18),
            _buildSectionTitle('Qaybaha la dhaxlayo'),
            const SizedBox(height: 10),
            ...shares.entries.where((entry) {
              return _toDouble(entry.value) > 0 && !_isGeneralAmount(entry.key);
            }).map((entry) {
              return _buildShareCard(
                title: _formatLabel(entry.key),
                amount: _toDouble(entry.value),
              );
            }).toList(),
            if (chartData.isNotEmpty) ...[
              const SizedBox(height: 18),
              _buildChartCard(chartData, totalShare),
            ],
            const SizedBox(height: 20),
            _buildSectionTitle('Daliilka Aayadaha Qur’aanka'),
            const SizedBox(height: 10),
            ...references.entries.map((entry) {
              return _buildReferenceCard(context, entry.key, '${entry.value}');
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(double totalAmount) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryColor, Color(0xFF2F5D8C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: accentColor,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lacagta Guud',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  totalAmount.toStringAsFixed(2),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: primaryColor,
        fontSize: 21,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _buildShareCard({
    required String title,
    required double amount,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: borderColor),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: accentColor.withOpacity(0.14),
          child: const Icon(Icons.pie_chart_rounded, color: primaryColor),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            color: primaryColor,
          ),
        ),
        trailing: Text(
          amount.toStringAsFixed(2),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 15,
            color: Color(0xFF8E6B23),
          ),
        ),
      ),
    );
  }

  Widget _buildChartCard(List<ShareData> chartData, double totalShare) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: SfCircularChart(
          title: ChartTitle(
            text: 'Qaabka loo kala dhaxlay',
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: primaryColor,
            ),
          ),
          legend: const Legend(
            isVisible: true,
            position: LegendPosition.bottom,
            overflowMode: LegendItemOverflowMode.wrap,
            textStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
          series: <PieSeries<ShareData, String>>[
            PieSeries<ShareData, String>(
              dataSource: chartData,
              xValueMapper: (ShareData data, _) => data.heir,
              yValueMapper: (ShareData data, _) => data.share,
              pointColorMapper: (ShareData data, _) => data.color,
              dataLabelMapper: (ShareData data, _) {
                if (totalShare == 0) return '0%';
                return '${(data.share / totalShare * 100).toStringAsFixed(1)}%';
              },
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelPosition: ChartDataLabelPosition.outside,
                textStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              explode: true,
              explodeIndex: 0,
              radius: '78%',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReferenceCard(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: borderColor),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: accentColor.withOpacity(0.14),
          child: const Icon(Icons.menu_book_rounded, color: primaryColor),
        ),
        title: Text(
          _formatLabel(title),
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: primaryColor,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 15,
          color: primaryColor,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuranReferenceScreen(
                referenceTitle: _formatLabel(title),
                referenceText: quranicTexts[title] != null
                    ? quranicTexts[title]!.join('\n\n')
                    : "Daliilka qoraalkiisa lama helin.",
              ),
            ),
          );
        },
      ),
    );
  }
}
