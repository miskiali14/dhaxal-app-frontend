import 'package:flutter/material.dart';
import 'package:project_graduated/forgetpassword/forget_password_screen.dart';
import 'package:project_graduated/screens/Singup_screen.dart';
import 'package:project_graduated/dashboard.dart';
import 'package:project_graduated/provide/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigIn extends StatefulWidget {
  const SigIn({super.key});

  @override
  State<SigIn> createState() => _SigInState();
}

class _SigInState extends State<SigIn> {
  final _formSignupKey = GlobalKey<FormState>();

  bool agreePersonalData = false;
  bool _isHiddenPassword = true;
  bool _isLoading = false;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  static const Color primaryColor = Color(0xFF1E3A5F);
  static const Color accentColor = Color(0xFFD4AF37);
  static const Color backgroundColor = Color(0xFFF7F9FC);
  static const Color borderColor = Color(0xFFE1E8F0);

  @override
  void initState() {
    super.initState();
    _loadRememberedLogin();
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _loadRememberedLogin() async {
    final prefs = await SharedPreferences.getInstance();

    final rememberMe = prefs.getBool('remember_me') ?? false;
    final savedEmail = prefs.getString('saved_email') ?? '';
    final savedPassword = prefs.getString('saved_password') ?? '';

    if (!mounted) return;

    if (rememberMe) {
      setState(() {
        agreePersonalData = true;
        emailController.text = savedEmail;
        passwordController.text = savedPassword;
      });
    }
  }

  Future<void> _saveRememberedLogin({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (agreePersonalData) {
      await prefs.setBool('remember_me', true);
      await prefs.setString('saved_email', email);
      await prefs.setString('saved_password', password);
    } else {
      await prefs.setBool('remember_me', false);
      await prefs.remove('saved_email');
      await prefs.remove('saved_password');
    }
  }

  void _togglePasswordView() {
    setState(() {
      _isHiddenPassword = !_isHiddenPassword;
    });
  }

  void _loginUser(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      bool isSuccess = await Provider.of<UserProvider>(context, listen: false)
          .login(email.toLowerCase().trim(), password);

      if (!mounted) return;

      if (isSuccess) {
        await _saveRememberedLogin(
          email: email.toLowerCase().trim(),
          password: password,
        );

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (e) => const Dashboard(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Soo galistu way fashilantay. Fadlan hubi xogtaada.'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Soo galistu way fashilantay: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: primaryColor),
      suffixIcon: suffixIcon,
      labelStyle: const TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.w600,
      ),
      hintStyle: const TextStyle(color: Colors.black38),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: accentColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
          child: Form(
            key: _formSignupKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 22),
                _buildFormCard(),
                const SizedBox(height: 18),
                _buildSignUpLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: const Column(
        children: [
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
            'Ku Soo Dhawoow',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Soo gal si aad u isticmaasho Dhaxal App una aragto natiijooyinkaaga.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Fadlan geli email-kaaga.';
              }

              if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$")
                  .hasMatch(value.trim())) {
                return 'Fadlan geli email sax ah.';
              }

              return null;
            },
            decoration: _inputDecoration(
              label: 'Email',
              hint: 'Geli email-kaaga',
              icon: Icons.email_outlined,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: passwordController,
            obscureText: _isHiddenPassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Fadlan geli erayga sirta ah.';
              }

              if (value.length < 6) {
                return 'Erayga sirta ah waa inuu ahaadaa ugu yaraan 6 xaraf.';
              }

              return null;
            },
            decoration: _inputDecoration(
              label: 'Erayga Sirta ah',
              hint: 'Geli erayga sirta ah',
              icon: Icons.lock_outline_rounded,
              suffixIcon: IconButton(
                icon: Icon(
                  _isHiddenPassword
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: primaryColor,
                ),
                onPressed: _togglePasswordView,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: TextButton(
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => const ForgetPassword()),
          //       );
          //     },
          //     child: const Text(
          //       'Ma illowday erayga sirta ah?',
          //       style: TextStyle(
          //         color: primaryColor,
          //         fontWeight: FontWeight.w700,
          //       ),
          //     ),
          //   ),
          // ),
          Row(
            children: [
              Checkbox(
                value: agreePersonalData,
                activeColor: accentColor,
                checkColor: primaryColor,
                onChanged: (bool? value) {
                  setState(() {
                    agreePersonalData = value ?? false;
                  });
                },
              ),
              const Expanded(
                child: Text(
                  'Xusuusnow xogtayda',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      if (_formSignupKey.currentState!.validate()) {
                        _loginUser(
                          emailController.text.trim(),
                          passwordController.text,
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: primaryColor,
                disabledBackgroundColor: accentColor.withOpacity(0.5),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: primaryColor,
                        strokeWidth: 2.4,
                      ),
                    )
                  : const Text(
                      'Soo Gal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Ma haysatid koonto? ',
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (e) => const SignUp(),
              ),
            );
          },
          child: const Text(
            'Diiwaangeli',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
