import 'package:flutter/material.dart';
import 'package:heart/Api/login_apis.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nickNameController = TextEditingController();
  late SharedPreferences prefs;

  Future initPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    initPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'LOGIN',
          style: TextStyle(
            color: Colors.black,
            fontSize: 23,
            fontFamily: 'single_day',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'lib/assets/image/4.png',
                  width: 200,
                  height: 200,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '아이디',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23,
                  fontFamily: 'single_day',
                ),
              ),
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'Id',
                  floatingLabelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 89, 181, 81),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                '비밀번호',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23,
                  fontFamily: 'single_day',
                ),
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  floatingLabelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 89, 181, 81),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 89, 181, 81),
                    fixedSize: const Size(300, 50),
                  ),
                  onPressed: () async {
                    String id = _idController.text;
                    String password = _passwordController.text;
                    String nickname = _nickNameController.text;

                    var logInUser = await loginUser(id, password);
                    if (logInUser) {
                      //로그인 성공시
                      setState(() {
                        prefs.setString('ID', id);
                        prefs.setString('nickName', nickname);
                      });
                    } else {
                      showAdaptiveDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog.adaptive(
                            title: const Text('로그인 실패'),
                            content: const Text('아이디 또는 비밀번호가 올바르지 않습니다.'),
                            actions: [
                              IconButton.filledTonal(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.check),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    Navigator.pop(context);
                  },
                  child: const Text(
                    '로그인',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontFamily: 'single_day',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
