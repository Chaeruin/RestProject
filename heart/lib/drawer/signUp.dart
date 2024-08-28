
import 'package:flutter/material.dart';
import 'package:heart/Model/login_model.dart';
import 'package:intl/intl.dart';
import '../Api/login_apis.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'SignUp',
              style: TextStyle(
                color: Colors.black,
                fontSize: 23,
                fontFamily: 'single_day',
              ),
            ),
          ],
        ),
      ),
      body: const SingleChildScrollView(child: SignUpForm()),
    );
  }
}
//회원가입 폼을 구성
class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  SignUpFormState createState() => SignUpFormState();
}

enum Gender { male, female }

//SignUpForm의 상태를 관리
class SignUpFormState extends State<SignUpForm> {
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
          //아이디 입력 필드
          const Text(
            '아이디',
            style: TextStyle(
              color: Colors.black,
              fontSize: 23,
              fontFamily: 'single_day',
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
                  color: Color.fromARGB(255, 89, 181, 81),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 89, 181, 81),
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
                          color: Colors.black,
                          fontSize: 23,
                          fontFamily: 'single_day',
                        ),
                      ),
                      content: const Text(
                        '이미 사용 중인 아이디입니다.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontFamily: 'single_day',
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
                              color: Colors.black,
                              fontSize: 23,
                              fontFamily: 'single_day',
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
                          color: Colors.black,
                          fontSize: 23,
                          fontFamily: 'single_day',
                        ),
                      ),
                      content: const Text(
                        '사용 가능한 아이디입니다.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontFamily: 'single_day',
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
                              color: Colors.black,
                              fontSize: 23,
                              fontFamily: 'single_day',
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
                          color: Color.fromARGB(255, 89, 181, 81),
                          fontSize: 23,
                          fontFamily: 'single_day',
                        ),
                      ),
                      content: const Text(
                        '올바른 아이디 형식이 아닙니다.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontFamily: 'single_day',
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
                              color: Color.fromARGB(255, 89, 181, 81),
                              fontSize: 23,
                              fontFamily: 'single_day',
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
                color: Color.fromARGB(255, 89, 181, 81),
                fontSize: 20,
                fontFamily: 'single_day',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          //비밀번호 입력 필드
          const Text(
            '비밀번호',
            style: TextStyle(
              color: Colors.black,
              fontSize: 23,
              fontFamily: 'single_day',
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
                  color: Color.fromARGB(255, 89, 181, 81),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 89, 181, 81),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          //닉네임 입력 필드
          const Text(
            '닉네임',
            style: TextStyle(
              color: Colors.black,
              fontSize: 23,
              fontFamily: 'single_day',
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
                  color: Color.fromARGB(255, 89, 181, 81),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 89, 181, 81),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          //성별 입력 필드
          const Text(
            '성별',
            style: TextStyle(
              color: Colors.black,
              fontSize: 23,
              fontFamily: 'single_day',
            ),
          ),
          Column(
            children: [
              RadioListTile(
                activeColor: const Color.fromARGB(255, 89, 181, 81),
                title: const Text(
                  '남자',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 23,
                    fontFamily: 'single_day',
                  ),
                ),
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
                activeColor: const Color.fromARGB(255, 89, 181, 81),
                title: const Text(
                  '여자',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 23,
                    fontFamily: 'single_day',
                  ),
                ),
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
          //생년월일 입력 필드
          const Text(
            '생년월일',
            style: TextStyle(
              color: Colors.black,
              fontSize: 23,
              fontFamily: 'single_day',
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              fixedSize: const Size(400, 45),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                side: BorderSide(
                  color: Color.fromARGB(255, 89, 181, 81),
                ),
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
                        primary: Color.fromARGB(255, 89, 181, 81),
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor:
                              const Color.fromARGB(255, 89, 181, 81),
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
                color: Colors.black,
                fontSize: 23,
                fontFamily: 'single_day',
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 89, 181, 81),
              fixedSize: const Size(400, 45),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
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
                          color: Color.fromARGB(255, 89, 181, 81),
                          fontSize: 23,
                          fontFamily: 'single_day',
                        ),
                      ),
                      content: const Text(
                        '모든 항목을 입력해주세요.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontFamily: 'single_day',
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
                              color: Color.fromARGB(255, 89, 181, 81),
                              fontSize: 23,
                              fontFamily: 'single_day',
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
                      title: const Text(
                        '아이디 중복',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontFamily: 'single_day',
                        ),
                      ),
                      content: const Text(
                        '이미 사용 중인 아이디입니다.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontFamily: 'single_day',
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
                              color: Colors.black,
                              fontSize: 23,
                              fontFamily: 'single_day',
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
                return;
              }

              //회원가입 정보 전송
              LoginModel newMember = LoginModel(
                memberId: _email,
                password: _password,
                nickname: _nickname,
                gender: _gender,
                birthdate: _birthdate,
              );
              var saveCheck = saveUser(newMember);
              if (await saveCheck) {
                Navigator.pop(context);
              } else {
                showAdaptiveDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog.adaptive(
                        title: Text('회원가입 실패!'),
                        content: Text('다시한번 시도해주세요.'),
                      );
                    });
              }
            },
            child: const Text(
              '회원가입 하기',
              style: TextStyle(
                color: Colors.black,
                fontSize: 23,
                fontFamily: 'single_day',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
