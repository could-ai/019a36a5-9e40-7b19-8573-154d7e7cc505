import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Penatalaksanaan Bahaya Merokok',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: const SmokingCessationPage(),
    );
  }
}

class SmokingCessationPage extends StatefulWidget {
  const SmokingCessationPage({super.key});

  @override
  State<SmokingCessationPage> createState() => _SmokingCessationPageState();
}

class _SmokingCessationPageState extends State<SmokingCessationPage> {
  int _currentStep = 0;
  String? _statusPerokok;
  String? _tingkatKecanduan;
  bool? _siapBerhenti;

  String _getRecommendation() {
    if (_statusPerokok == 'bukan') {
      return "Lanjutkan hidup sehat, hindari paparan asap rokok.";
    }

    if (_siapBerhenti == true) {
      switch (_tingkatKecanduan) {
        case 'ringan':
          return "Mulai berhenti secara langsung, dapatkan dukungan penuh dari keluarga dan teman.";
        case 'sedang':
          return "Gunakan terapi pengganti nikotin (seperti permen atau patch) dan pertimbangkan untuk mengikuti konseling.";
        case 'berat':
          return "Sangat disarankan untuk merujuk ke tenaga medis profesional untuk mendapatkan program berhenti merokok yang terstruktur dan komprehensif.";
        default:
          return "Silakan pilih tingkat kecanduan Anda.";
      }
    } else {
      return "Terus tingkatkan motivasi dan kesadaran akan bahaya merokok. Lakukan edukasi secara intensif dan jangan ragu mencari bantuan saat Anda siap.";
    }
  }

  void _reset() {
    setState(() {
      _currentStep = 0;
      _statusPerokok = null;
      _tingkatKecanduan = null;
      _siapBerhenti = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penatalaksanaan Bahaya Merokok'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: _buildStepContent(),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildQuestionCard(
          'Identifikasi Status',
          'Apakah Anda seorang perokok?',
          [
            _buildAnswerButton('Ya, saya perokok', () {
              setState(() {
                _statusPerokok = 'perokok';
                _currentStep = 1;
              });
            }),
            const SizedBox(height: 12),
            _buildAnswerButton('Bukan perokok', () {
              setState(() {
                _statusPerokok = 'bukan';
                _currentStep = 4; // Langsung ke hasil
              });
            }),
          ],
        );
      case 1:
        return _buildInfoCard(
          'Edukasi Bahaya Merokok',
          'Merokok sangat berbahaya bagi kesehatan Anda. Beberapa risikonya antara lain penyakit kanker, serangan jantung, gangguan paru-paru kronis, dan berbagai masalah kesehatan lainnya.',
          'Lanjut',
          () {
            setState(() {
              _currentStep = 2;
            });
          },
        );
      case 2:
        return _buildQuestionCard(
          'Identifikasi Tingkat Kecanduan',
          'Bagaimana Anda mengkategorikan tingkat kecanduan merokok Anda?',
          [
            _buildAnswerButton('Ringan', () => _selectAddictionLevel('ringan')),
            const SizedBox(height: 12),
            _buildAnswerButton('Sedang', () => _selectAddictionLevel('sedang')),
            const SizedBox(height: 12),
            _buildAnswerButton('Berat', () => _selectAddictionLevel('berat')),
          ],
        );
      case 3:
        return _buildQuestionCard(
          'Kesiapan Berhenti',
          'Apakah Anda memiliki keinginan dan kesiapan untuk berhenti merokok saat ini?',
          [
            _buildAnswerButton('Ya, saya siap berhenti', () {
              setState(() {
                _siapBerhenti = true;
                _currentStep = 4;
              });
            }),
            const SizedBox(height: 12),
            _buildAnswerButton('Belum, saya belum siap', () {
              setState(() {
                _siapBerhenti = false;
                _currentStep = 4;
              });
            }),
          ],
        );
      case 4:
        return _buildResultCard();
      default:
        return const SizedBox.shrink();
    }
  }

  void _selectAddictionLevel(String level) {
    setState(() {
      _tingkatKecanduan = level;
      _currentStep = 3;
    });
  }

  Widget _buildQuestionCard(String title, String question, List<Widget> actions) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.blue, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(question, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ...actions,
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoCard(String title, String info, String buttonText, VoidCallback onNext) {
     return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.orange, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(info, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: onNext, child: Text(buttonText)),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Rekomendasi Untuk Anda', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.green, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(
              _getRecommendation(),
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              'Program penatalaksanaan selesai dijalankan.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _reset,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Ulangi Asesmen'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
