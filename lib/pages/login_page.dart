import 'package:flutter/material.dart';
import 'home_page.dart';
import 'regis_page.dart';
import '../models/User.dart';
import '../services/dbhelper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordHidden = true;

  void _showPassword() {
    setState(() {
      passwordHidden = !passwordHidden;
    });
  }

  Future<bool> login() async {
    return await DBHelper()
        .authUser(usernameController.text, passwordController.text);
  }

  Future<User> getUser() async {
    return await DBHelper()
        .fetchUser(usernameController.text, passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: ListView(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 80, bottom: 150),
          children: [
            Container(
              margin: const EdgeInsets.only(top: 100),
              child: const Text(
                'Log In',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 50, bottom: 10),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: usernameController,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Username',
                  contentPadding:
                      const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: TextFormField(
                controller: passwordController,
                autofocus: false,
                obscureText: passwordHidden,
                decoration: InputDecoration(
                  hintText: 'Password',
                  suffixIcon: TextButton(
                    onPressed: () {
                      _showPassword();
                    },
                    child: (passwordHidden)
                        ? const Text(
                            'Show',
                            style: TextStyle(color: Colors.black),
                          )
                        : const Text(
                            'Hide',
                            style: TextStyle(color: Colors.black),
                          ),
                  ),
                  contentPadding:
                      const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5),
              child: TextButton(
                child: const Text(
                  'Create an account',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const RegisPage();
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.black),
                borderRadius: const BorderRadius.all(
                  Radius.circular(50),
                ),
              ),
              child: ListTile(
                title: const Text(
                  "Log In",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  (usernameController.text == "" ||
                          passwordController.text == "")
                      ? showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text(
                                  'Username atau Password tidak boleh kosong'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        )
                      : login().then(
                          (value) {
                            if (value) {
                              getUser().then(
                                (value) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(
                                        user: value,
                                      ),
                                    ),
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Login Berhasil'),
                                        content: const Text('Selamat Datang!'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Error'),
                                    content: const Text(
                                        'Username atau Password salah'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
