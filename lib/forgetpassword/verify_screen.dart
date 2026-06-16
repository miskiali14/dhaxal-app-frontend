import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:project_graduated/utils/constants.dart';
import 'create_newpass_screen.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;

  const VerifyCodeScreen({super.key, required this.email});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  String _code = "";

  bool _isLoading = false;
  Timer? _timer;
  int _start = 60;
  bool _canResend = false;

  static const Color primaryColor = Color(0xFF1E3A5F);
  static const Color accentColor = Color(0xFFD4AF37);
  static const Color backgroundColor = Color(0xFFF7F9FC);
  static const Color borderColor = Color(0xFFE1E8F0);

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer?.cancel();

    setState(() {
      _canResend = false;
      _start = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_start == 0) {
        setState(() => _canResend = true);
        timer.cancel();
      } else {
        setState(() => _start--);
      }
    });
  }

  Future<void> _verifyCode() async {
    final code = _code.trim();

    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fadlan geli code-ka 6-da lambar ah.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$kEndpoint/api/users/verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': widget.email,
          'code': code,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        _timer?.cancel();
        FocusScope.of(context).unfocus();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CreateNewPasswordScreen(
              email: widget.email,
              code: code,
            ),
          ),
        );
      } else {
        String message = 'Code-ka waa khaldan yahay ama wuu dhacay.';

        try {
          final responseData = json.decode(response.body);
          message = responseData['message'] ?? message;
        } catch (_) {}

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cilad ayaa dhacday. Hubi internet-ka ama backend-ka.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendCode() async {
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$kEndpoint/api/users/send-verification-code'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': widget.email}),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() => _code = "");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Code cusub ayaa laguugu diray email-kaaga.'),
          ),
        );

        startTimer();
      } else {
        String message = 'Code lama dirin. Fadlan mar kale isku day.';

        try {
          final responseData = json.decode(response.body);
          message = responseData['message'] ?? message;
        } catch (_) {}

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cilad ayaa dhacday. Hubi internet-ka ama backend-ka.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
        centerTitle: true,
        title: const Text(
          'Xaqiiji Code-ka',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
          child: Column(
            children: [
              _buildHeroCard(),
              const SizedBox(height: 22),
              _buildCodeCard(),
            ],
          ),
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
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 34,
            backgroundColor: Color(0x33D4AF37),
            child: Icon(
              Icons.verified_user_rounded,
              color: accentColor,
              size: 38,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Geli Code-ka Xaqiijinta',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Waxaan code 6-lambar ah u dirnay:\n${widget.email}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          PinCodeTextField(
            key: ValueKey(_code),
            appContext: context,
            length: 6,
            onChanged: (value) {
              _code = value;
            },
            enableActiveFill: true,
            keyboardType: TextInputType.number,
            animationType: AnimationType.fade,
            cursorColor: primaryColor,
            textStyle: const TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(14),
              fieldHeight: 52,
              fieldWidth: 42,
              borderWidth: 1,
              activeFillColor: backgroundColor,
              selectedFillColor: backgroundColor,
              inactiveFillColor: backgroundColor,
              activeColor: accentColor,
              selectedColor: accentColor,
              inactiveColor: borderColor,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _verifyCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: primaryColor)
                  : const Text(
                      'Xaqiiji Code-ka',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          _canResend
              ? TextButton(
                  onPressed: _isLoading ? null : _resendCode,
                  child: const Text(
                    'Mar kale dir code-ka',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                )
              : Text(
                  'Code cusub waad dalban kartaa $_start ilbiriqsi kadib',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ],
      ),
    );
  }
}
