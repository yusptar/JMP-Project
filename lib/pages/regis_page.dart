import 'package:flutter/material.dart';
import 'package:lsp_mobile/models/User.dart';
import '../services/dbhelper.dart';
import 'login_page.dart';

class RegisPage extends StatefulWidget {
  const RegisPage({Key? key}) : super(key: key);

  @override
  State<RegisPage> createState() => _RegisPage();
}

class _RegisPage extends State<RegisPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController telpController = TextEditingController();

  final User _user = User();

  Future<bool> register() async {
    _user.username = usernameController.text;
    _user.password = passwordController.text;
    _user.nama = nameController.text;
    _user.nomorHP = telpController.text;
    return await DBHelper().registerUser(_user);
  }

  bool passwordHidden = true;
  bool isChecked = false;

  void _showPassword() {
    setState(() {
      passwordHidden = !passwordHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Center(
          child: ListView(
            padding: const EdgeInsets.only(
                left: 24, right: 24, top: 80, bottom: 150),
            children: [
              Container(
                margin: const EdgeInsets.only(top: 100),
                child: const Text(
                  'Sign Up',
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
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: nameController,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Nama',
                    contentPadding:
                        const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: telpController,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'No Telepon',
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
                child: Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                    const Text(
                      'I would like to receive your information',
                    ),
                  ],
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
                    "Sign Up",
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
                        : register().then(
                            (value) {
                              if (value) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Registrasi Berhasil'),
                                      content: const Text(
                                          'Silahkan mengisi username dan password untuk melakukan login'),
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
      ),
    );
  }
}
