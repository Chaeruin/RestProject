import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

class Chat extends StatefulWidget {
  const Chat({super.key, this.memberId});

  final String? memberId;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String? memberId = '0';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: memberId != null
          ? ChatScreen(memberId: memberId!)
          : const Scaffold(
              body: Center(
                child: Text('로그인이 필요합니다.'),
              ),
            ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String? memberId;

  const ChatScreen({super.key, required this.memberId});

  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  late String? memberId;
  int chatId = 0;
  bool _isLoading = false;

  ChatScreenState({this.memberId});

  @override
  void initState() {
    super.initState();
    memberId = widget.memberId;
    enterChatRoom();
  }

  Future<void> enterChatRoom() async {
    const String springUrl = 'http://54.79.110.239:8080/api/chat/newChatRoom';

    final http.Response response = await http.post(
      Uri.parse(springUrl),
      body: {'flutterRequest': '채팅방 요청'},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      setState(() {
        chatId = responseData['chatId'];
      });
      print('채팅방이 생성되었습니다. chatId: $chatId');
    } else {
      print('채팅방 생성에 실패했습니다. 에러 코드: ${response.statusCode}');
    }
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = ChatMessage(
      text: text,
      isUser: true,
    );
    setState(() {
      _messages.insert(0, message);
      sendMessage(chatId, text, memberId!);
    });
  }

  Future<void> sendMessage(int chatId, String message, String? memberId) async {
    if (memberId == null) {
      print('Error: memberId is null');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final String springUrl =
        'http://54.79.110.239:8080/api/chat/requestMessageFromFlutter/$chatId';

    final Map<String, dynamic> chat = {
      'chatId': chatId.toString(),
      'memberId': memberId,
      'chatContent': message,
    };

    final http.Response response = await http.post(Uri.parse(springUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(chat));

    print('Spring 서버 응답 Status Code: ${response.statusCode}');
    print('Spring 서버 응답 Body: ${utf8.decode(response.bodyBytes)}');

    if (response.statusCode == 200) {
      print('Spring으로 메세지가 성공적으로 전달되었습니다');
      final springResponseBody = jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> categoryList = springResponseBody['category'];
      final receivedMessage = springResponseBody['response'];
      // 카테고리 받아오기
      final String receiveCategory =
          categoryList.isNotEmpty ? categoryList[0] : 'Unknown';
      print('Category: $receiveCategory'); // 감정/자살충동

      if (receiveCategory == "감정/자살충동" ||
          receiveCategory == "감정/살인욕구" ||
          receiveCategory == "증상/자살시도" ||
          receiveCategory == "증상/자해") // 등등 여러가지
      {
        setState(() {
          _messages.insert(
            0,
            ChatMessage(
              image: Image.asset('lib/assets/images/SuicidePrevention.png'),
              text: receivedMessage,
              isUser: false,
            ),
          );
          _isLoading = false;
        });
      } else {
        setState(() {
          _messages.insert(
            0,
            ChatMessage(
              text: receivedMessage,
              isUser: false,
            ),
          );
          _isLoading = false;
        });
      }
    } else {
      print('Spring으로 메세지 전송에 실패했습니다. Error: ${response.reasonPhrase}');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          textAlign: TextAlign.center,
          '마음이',
          style: TextStyle(
            color: Color.fromARGB(255, 89, 181, 81),
            fontSize: 25,
            fontFamily: 'single_day',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return const Chat();
                },
              ),
            );
          },
        ),
        backgroundColor: const Color(0xFFFFFBA0),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(5.0),
          child: Container(
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 250, 248, 205),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (_, int index) => _messages[index],
              ),
            ),
            const Divider(height: 1.0),
            const SizedBox(height: 20),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Container(
                        height: 40.0,
                        width: 100.0,
                        color: Colors.white,
                        child: const SpinKitThreeBounce(
                          color: Colors.black,
                          size: 10.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(width: 8, height: 20),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: _buildTextComposer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return Builder(
      builder: (BuildContext context) {
        return IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: TextField(
                    controller: _textController,
                    onSubmitted: _handleSubmitted,
                    decoration:
                        const InputDecoration.collapsed(hintText: '메시지를 입력하세요'),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'single_day',
                    ),
                    keyboardAppearance: Brightness.light,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _handleSubmitted(_textController.text),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final Image? image;
  static const String suicideText = "자살 방지 문구(임시)";

  const ChatMessage(
      {super.key, required this.text, required this.isUser, this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment:
                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              // 사용자가 보낸게 아니면 (기룡이가 답변하는 채팅일 경우)
              if (!isUser)
                Container(
                  margin: const EdgeInsets.only(
                      right: 10.0, left: 10.0, bottom: 10),
                  child: const CircleAvatar(
                    backgroundImage:
                        AssetImage('lib/assets/images/giryong.png'),
                    radius: 20,
                  ),
                ),
              // 사용자가 보내는 메세지일 경우
              if (isUser)
                Container(
                  margin: const EdgeInsets.only(right: 10.0, left: 10.0),
                  child: const Text('나'),
                ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.5,
                ),
                margin: const EdgeInsets.only(right: 10.0, left: 10.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'single_day',
                    fontSize: 20.0,
                  ),
                ),
              ),
              // 이미지가 있는 경우
              if (image != null)
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.5,
                  ),
                  margin: const EdgeInsets.only(right: 10.0, left: 10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        child: image,
                      ),
                      const Text(
                        suicideText,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'single_day',
                          fontSize: 20.0,
                        ),
                      ),
                      // OutlineButton 추가
                      OutlinedButton(
                        onPressed: () {
                          // pubspec.yaml에 url_launcher: ^6.0.9 추가
                          launchUrl(Uri.parse("https://www.lifeline.or.kr/"));
                        },
                        child: const Text('자살 예방 상담하기'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
