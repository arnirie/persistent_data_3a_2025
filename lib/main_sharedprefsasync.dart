import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;

  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  late SharedPreferences prefs;

  Future<void> fetchPrefs() async {
    prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username');
    if (username != null) {
      usernameCtrl.text = username;
      isChecked = true;
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPrefs();
  }

  @override
  Widget build(BuildContext context) {
    print(isChecked);
    return Scaffold(
      body: Column(
        children: [
          Image.network(
              'https://upload.wikimedia.org/wikipedia/en/7/75/Pangasinan_State_University_logo.png'),
          TextField(
            controller: usernameCtrl,
          ),
          TextField(
            controller: passwordCtrl,
          ),
          Row(
            children: [
              Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    print(value);
                    isChecked = value ?? false;
                    setState(() {});
                  }),
              const Text('Remember me'),
            ],
          ),
          ElevatedButton(
            onPressed: login,
            child: const Text('Login'),
          ),
          // Checkbox.adaptive(value: value, onChanged: onChanged)
        ],
      ),
    );
  }

  void login() {
    if (isChecked) {
      prefs.setString('username', usernameCtrl.text);
    } else {
      prefs.remove('username');
    }
  }
}
