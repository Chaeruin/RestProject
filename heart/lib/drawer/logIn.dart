//로그인 페이지
import 'package:flutter/material.dart'; // Flutter의 기본 위젯 및 머티리얼 디자인 컴포넌트를 사용하기 위해 가져옴
import 'package:heart/Api/login_apis.dart'; // 로그인 API 기능을 불러옴
import 'package:heart/auth_provider.dart'; // 인증 공급자를 불러옴
import 'package:provider/provider.dart'; // 상태 관리를 위한 provider 패키지를 불러옴

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState(); // Login 상태를 관리하는 _LoginState 생성.
}

// _LoginState 클래스는 실제로 UI를 렌더링하고, 사용자 상호작용을 처리
class _LoginState extends State<Login> {
  // ID와 비밀번호를 입력받기 위한 텍스트 컨트롤러 생성.
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar: 페이지 상단에 표시되는 제목 바
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // 뒤로가기 버튼 아이콘
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 버튼 클릭 시 이전 화면으로 돌아감.
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
      // SingleChildScrollView: 화면 크기를 초과하는 내용이 있을 경우 스크롤 가능하도록 함.
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0), // 화면 여백 설정
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // 자식 위젯들을 상단 정렬
            crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯들을 왼쪽 정렬
            children: [
              // 로고 이미지 중앙 정렬
              Center(
                child: Image.asset(
                  'lib/assets/image/4.png',
                  width: 200,
                  height: 200,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '아이디', // "아이디" 텍스트 라벨
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23,
                  fontFamily: 'single_day',
                ),
              ),
              // 아이디 입력 필드
              TextFormField(
                controller: _idController, // ID 입력 컨트롤러 연결
                decoration: const InputDecoration(
                  labelText: 'Id', // "Id" 텍스트 라벨
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
                '비밀번호', // "비밀번호" 텍스트 라벨
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23,
                  fontFamily: 'single_day',
                ),
              ),
              // 비밀번호 입력 필드
              TextFormField(
                controller: _passwordController, // 비밀번호 입력 컨트롤러 연결
                obscureText: true, // 입력한 텍스트가 보이지 않도록 설정 (비밀번호 형태)
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
              // 로그인 버튼 중앙 정렬
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 89, 181, 81), 
                    fixedSize: const Size(300, 50), 
                  ),
                  // 로그인 버튼 클릭 시 실행되는 로직
                  onPressed: () async {
                    String id = _idController.text; // 입력된 ID 가져오기
                    String password = _passwordController.text; // 입력된 비밀번호 가져오기

                    final String? nickName = await loginUser(id, password); // 로그인 API 호출
                    if (nickName != null) {
                      // 로그인 성공 시
                      context.read<AuthProvider>().login(id, nickName); // AuthProvider를 통해 로그인 상태 업데이트
                      Navigator.pop(context); // 이전 화면으로 돌아감
                    } else {
                      // 로그인 실패 시 경고 창 표시
                      showAdaptiveDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              '로그인 실패', // 경고 창 제목
                               textAlign: TextAlign.center,
                               style: TextStyle(
                                color: Color.fromARGB(255, 89, 181, 81),
                                fontSize: 23,
                                fontFamily: 'single_day',
                              ),
                              ),
                            content: const Text(
                              '아이디 또는 비밀번호가\n올바르지 않습니다.', // 경고 창 내용
                              textAlign: TextAlign.center,
                               style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'single_day',
                              ),
                              ),
                            actions: [
                              // 경고 창 확인 버튼
                              IconButton.filledTonal(
                                onPressed: () => Navigator.pop(context), // 확인 버튼 클릭 시 경고 창 닫기
                                icon: const Icon(Icons.check),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text(
                    '로그인', // 버튼의 텍스트
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
