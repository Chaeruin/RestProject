import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Api/login_apis.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              '환영합니다~',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
      body: const SingleChildScrollView(child: SignUpForm()),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

enum Gender { male, female }

class _SignUpFormState extends State<SignUpForm> {
  String _email = '';
  String _password = '';
  String _nickname = '';
  String _gender = ''; // 'male', 'female'
  String _birthdate = '';
  bool focus = true;
  DateTime initialDay = DateTime.now();
  var gender;
  bool _isEmailValid = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '아이디',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          TextFormField(
            onChanged: (value) {
              setState(() {
                _email = value;
              });
            },
            decoration: const InputDecoration(
              labelText: 'example@email.com',
              floatingLabelStyle: TextStyle(
                color: Colors.grey,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF98dfff),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF98dfff),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              String message = await checkEmailDuplicate(_email);
              if (message == '이미 사용 중인 아이디입니다.') {
                setState(() {
                  _isEmailValid = false;
                });
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        '아이디 중복',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 83, 83),
                          fontSize: 20,
                        ),
                      ),
                      content: const Text(
                        '이미 사용 중인 아이디입니다.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            '확인',
                            style: TextStyle(
                              color: Color.fromARGB(255, 48, 155, 248),
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else if (message == '사용 가능한 아이디입니다.') {
                setState(() {
                  _isEmailValid = true;
                });
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        '아이디 사용 가능',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 83, 83),
                          fontSize: 20,
                        ),
                      ),
                      content: const Text(
                        '사용 가능한 아이디입니다.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            '확인',
                            style: TextStyle(
                              color: Color.fromARGB(255, 48, 155, 248),
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else if (message == '올바른 이메일 형식이 아닙니다.') {
                setState(() {
                  _isEmailValid = false;
                });
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        '아이디 형식 오류',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 83, 83),
                          fontSize: 20,
                        ),
                      ),
                      content: const Text(
                        '올바른 아이디 형식이 아닙니다.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            '확인',
                            style: TextStyle(
                              color: Color.fromARGB(255, 48, 155, 248),
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: const Text(
              '중복 확인',
              style: TextStyle(
                color: Color.fromARGB(255, 253, 98, 134),
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            '비밀번호',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          TextFormField(
            onChanged: (value) {
              setState(() {
                _password = value;
              });
            },
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              floatingLabelStyle: TextStyle(
                color: Colors.grey,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF98dfff),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF98dfff),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            '닉네임',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          TextFormField(
            onChanged: (value) {
              setState(() {
                _nickname = value;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Nickname',
              floatingLabelStyle: TextStyle(
                color: Colors.grey,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF98dfff),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF98dfff),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text('성별',
              style: TextStyle(
                fontSize: 20,
              )),
          Column(
            children: [
              RadioListTile(
                activeColor: const Color(0xFF98dfff),
                title: const Text('남자'),
                value: Gender.male,
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value;
                    _gender = '남자';
                  });
                },
              ),
              RadioListTile(
                activeColor: const Color(0xFF98dfff),
                title: const Text('여자'),
                value: Gender.female,
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value;
                    _gender = '여자';
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            '생년월일',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              fixedSize: const Size(400, 45),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                side: BorderSide(color: Color(0xFF98dfff)),
              ),
            ),
            onPressed: () async {
              final DateTime? dateTime = await showDatePicker(
                context: context,
                initialDate: initialDay,
                firstDate: DateTime(1900),
                lastDate: DateTime(2200),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color(0xFF98dfff),
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF98dfff),
                          textStyle: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (dateTime != null) {
                setState(() {
                  initialDay = dateTime;
                  _birthdate =
                      DateFormat('yyyyMMdd').format(initialDay).toString();
                });
              }
            },
            child: Text(
              _birthdate.isEmpty ? "여기를 눌러서 입력하세요!" : _birthdate,
              style: const TextStyle(
                color: Color(0xFF98dfff),
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF98dfff),
              fixedSize: const Size(400, 45),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            onPressed: () async {
              if (_email.isEmpty ||
                  _password.isEmpty ||
                  _nickname.isEmpty ||
                  _gender.isEmpty ||
                  _birthdate.isEmpty) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        '입력 오류',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 98, 98),
                          fontSize: 20,
                        ),
                      ),
                      content: const Text(
                        '모든 항목을 입력해주세요.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            '확인',
                            style: TextStyle(
                              color: Color.fromARGB(255, 76, 144, 255),
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
                return;
              }

              if (!_isEmailValid) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('아이디 중복'),
                      content: const Text('이미 사용 중인 아이디입니다.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('확인'),
                        ),
                      ],
                    );
                  },
                );
                return;
              }

              Navigator.pop(context);
            },
            child: const Text(
              '회원가입 하기',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
