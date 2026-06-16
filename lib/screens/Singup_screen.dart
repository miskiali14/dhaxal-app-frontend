import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_graduated/screens/Sigin_screen.dart';
import 'package:project_graduated/dashboard.dart';
import 'package:project_graduated/model/user_model.dart';
import 'package:project_graduated/provide/user_provider.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formSignupKey = GlobalKey<FormState>();

  bool agreePersonalData = false;
  bool _isHiddenPassword = true;
  bool _isHiddenConfirmPassword = true;
  bool _isLoading = false;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();

  final String _defaultImageUrl =
      'https://st3.depositphotos.com/9998432/13335/v/450/depositphotos_133352156-stock-illustration-default-placeholder-profile-icon.jpg';

  String? _gender;

  static const Color primaryColor = Color(0xFF1E3A5F);
  static const Color accentColor = Color(0xFFD4AF37);
  static const Color backgroundColor = Color(0xFFF7F9FC);
  static const Color borderColor = Color(0xFFE1E8F0);

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
    fullNameController.dispose();
    super.dispose();
  }

  void _togglePasswordView() {
    setState(() {
      _isHiddenPassword = !_isHiddenPassword;
    });
  }

  void _toggleConfirmPasswordView() {
    setState(() {
      _isHiddenConfirmPassword = !_isHiddenConfirmPassword;
    });
  }

  void _resetForm() {
    _formSignupKey.currentState?.reset();
    passwordController.clear();
    confirmPasswordController.clear();
    emailController.clear();
    fullNameController.clear();
    setState(() {
      agreePersonalData = false;
      _gender = null;
    });
  }

  void _registerUser(
    String fullName,
    String email,
    String password,
    String gender,
  ) async {
    if (_formSignupKey.currentState!.validate() && agreePersonalData) {
      try {
        setState(() {
          _isLoading = true;
        });

        User newUser = User(
          id: '',
          name: fullName,
          email: email,
          password: password,
          image: _defaultImageUrl,
          gender: gender,
        );

        User? registeredUser =
            await Provider.of<UserProvider>(context, listen: false)
                .createUser(newUser);

        if (!mounted) return;

        if (registeredUser != null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Dashboard()),
            (Route<dynamic> route) => false,
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Diiwaangelintu way fashilantay: ${e.toString()}'),
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else if (!agreePersonalData) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fadlan ogolow habka macluumaadka shakhsiga ah.'),
        ),
      );
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
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          child: Form(
            key: _formSignupKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 22),
                _buildFormCard(),
                const SizedBox(height: 18),
                _buildLoginLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(_defaultImageUrl),
          ),
          const SizedBox(height: 14),
          const Text(
            'Abuur Koonto Cusub',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Diiwaangeli si aad u isticmaasho Dhaxal App una keydiso natiijooyinkaaga.',
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
            controller: fullNameController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Fadlan geli magaca buuxa.';
              }
              if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value.trim())) {
                return 'Magacu ha ka koobnaado xarfo iyo boos keliya.';
              }
              return null;
            },
            decoration: _inputDecoration(
              label: 'Magaca Buuxa',
              hint: 'Geli magacaaga buuxa',
              icon: Iconsax.user,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Fadlan geli email.';
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
              icon: Iconsax.sms,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _gender,
            decoration: _inputDecoration(
              label: 'Jinsiga',
              hint: 'Dooro jinsigaaga',
              icon: Iconsax.profile_2user,
            ),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(16),
            items: const [
              DropdownMenuItem(value: 'Male', child: Text('Lab')),
              DropdownMenuItem(value: 'Female', child: Text('Dhedig')),
            ],
            onChanged: (value) {
              setState(() {
                _gender = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Fadlan dooro jinsigaaga.';
              }
              return null;
            },
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
              icon: Iconsax.lock,
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
          const SizedBox(height: 16),
          TextFormField(
            controller: confirmPasswordController,
            obscureText: _isHiddenConfirmPassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Fadlan xaqiiji erayga sirta ah.';
              }
              if (value != passwordController.text) {
                return 'Erayga sirta ahi isma waafaqayo.';
              }
              return null;
            },
            decoration: _inputDecoration(
              label: 'Xaqiiji Erayga Sirta ah',
              hint: 'Mar kale geli erayga sirta ah',
              icon: Iconsax.lock_1,
              suffixIcon: IconButton(
                icon: Icon(
                  _isHiddenConfirmPassword
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: primaryColor,
                ),
                onPressed: _toggleConfirmPasswordView,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                child: Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    'Waan oggolahay habka macluumaadka shakhsiga ah.',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      if (_formSignupKey.currentState!.validate() &&
                          agreePersonalData) {
                        _registerUser(
                          fullNameController.text.trim(),
                          emailController.text.trim(),
                          passwordController.text,
                          _gender!,
                        );
                      } else if (!agreePersonalData) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Fadlan ogolow habka macluumaadka shakhsiga ah.',
                            ),
                          ),
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
                      'Diiwaangeli',
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

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Hore ayaan koonto u lahaa? ',
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (e) => const SigIn()),
            );
          },
          child: const Text(
            'Soo gal',
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
