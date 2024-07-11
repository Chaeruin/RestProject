import 'package:flutter/material.dart';
import 'package:heart/drawer/signUp.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _idController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '아이디',
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
            TextFormField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: 'Id',
                floatingLabelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF98dfff),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            const Text(
              '비밀번호',
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                floatingLabelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF98dfff),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF98dfff),
                fixedSize: const Size(400, 45),
              ),
              onPressed: () async {
                // String id = _idController.text;
                // String password = _passwordController.text;
                // // 로그인 요청
                // Member? loggedInUser = await loginUser(id, password);
                // if (loggedInUser != null) {
                //   await storage.write(
                //     key: 'memberId',
                //     value: loggedInUser.memberId,
                //   );
                //   // await prefs.setBool(key, value);
                //   // 로그인 성공 시 환영 페이지로 이동
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => LoginedMain(
                //         memberId: id,
                //         selectedDate: DateTime.now().toString(),
                //       ),
                //     ),
                //   );
                // } else {
                //   // 로그인 실패 처리
                //   showDialog(
                //     context: context,
                //     builder: (BuildContext context) {
                //       return AlertDialog(
                //         title: const Text('로그인 실패'),
                //         content: const Text('아이디 또는 비밀번호가 올바르지 않습니다.'),
                //         actions: [
                //           TextButton(
                //             onPressed: () {
                //               Navigator.pop(context);
                //             },
                //             child: const Text('확인'),
                //           ),
                //         ],
                //       );
                //     },
                //   );
                // }
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text(
                '로그인',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF98dfff),
                fixedSize: const Size(400, 45),
              ),
              onPressed: () async {
                setState(() {});
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUp(),
                    ));
              },
              child: const Text(
                '회원가입',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
