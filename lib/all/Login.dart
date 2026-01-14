import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled5/all/list.dart';
import 'package:untitled5/all/map.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordHidden = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _checkSavedLogin();
  }

  Future<void> _checkSavedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? isLoggedIn = prefs.getBool('isLoggedIn');
    final String? savedId = prefs.getString('idu');
    final String? savedName = prefs.getString('nameu');

    if (isLoggedIn == true && savedId != null && savedName != null) {
      _navigateToMain(savedId, savedName);
    }
  }

  Future<void> _saveLoginSession(String id, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('idu', id);
    await prefs.setString('nameu', name);
  }

  void _navigateToMain(String id, String name) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainNavigationScreen(
          idu: id,
          nameu: name,
        ),
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final pass = _passwordController.text.trim();
      bool found = false;

      for (var element in user) {
        if (name == element['nameu'] && pass == element['pasu']) {
          found = true;
          
          await _saveLoginSession(element['idu'], element['nameu']);
          
          _navigateToMain(element['idu'], element['nameu']);
          break;
        }
      }

      if (!found) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('اسم المستخدم أو كلمة المرور غير صحيحة', textAlign: TextAlign.right),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'نظام المخالفات المرورية',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'images/IMG-20260106-WA0007.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.shield, size: 80, color: Colors.blue),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'تسجيل دخول الموظف',
                      style: TextStyle(
                        color: Colors.amber, 
                        fontFamily: 'MyCustomFont',
                        fontWeight: FontWeight.w700, 
                        fontSize: 18
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, spreadRadius: 2),
                  ],
                ),
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      label: 'اسم المستخدم',
                      icon: Icons.person,
                      validator: (value) => value!.isEmpty ? 'أدخل اسم المستخدم' : null,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      keyboardType: TextInputType.number,
                      controller: _passwordController,
                      label: 'كلمة المرور',
                      icon: Icons.lock,
                      isPassword: true,
                      validator: (value) => value!.length < 4 ? 'كلمة المرور قصيرة جداً' : null,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[900],
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: _login,
                            child: const Text('دخول', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 15),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => SystemNavigator.pop(),
                          child: const Text('خروج', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword ? _isPasswordHidden : false,
          textAlign: TextAlign.right,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: isPassword
                ? IconButton(
                    icon: Icon(_isPasswordHidden ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _isPasswordHidden = !_isPasswordHidden),
                  )
                : Icon(icon),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
      ],
    );
  }
}
