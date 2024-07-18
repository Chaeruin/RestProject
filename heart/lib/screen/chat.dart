// // ignore_for_file: avoid_print, prefer_const_declarations, use_super_parameters, no_logic_in_create_state
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:http/http.dart' as http;

// class Chat extends StatefulWidget {
//   const Chat({super.key, this.memberId});

//   final String? memberId;

//   @override
//   State<Chat> createState() => _ChatState();
// }

// class _ChatState extends State<Chat> {
//   String? memberId = '0';
//   // final storage = const FlutterSecureStorage();

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   WidgetsBinding.instance.addPostFrameCallback((_) {
//   //     _asyncMethod();
//   //   });
//   // }

//   // _asyncMethod() async {
//   //   String? value = await storage.read(key: 'memberId');
//   //   setState(() {
//   //     memberId = value;
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: ChatScreen(memberId: memberId!));
//   }
// }

// class ChatScreen extends StatefulWidget {
//   final String? memberId;

//   const ChatScreen({Key? key, required this.memberId}) : super(key: key);

//   @override
//   State createState() => ChatScreenState(memberId: memberId);
// }

// class ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _textController = TextEditingController();
//   final List<ChatMessage> _messages = <ChatMessage>[];
//   late String? memberId;
//   int chatId = 0;
//   bool _isLoading = false;

//   ChatScreenState({this.memberId});

//   @override
//   void initState() {
//     super.initState();
//     memberId = widget.memberId;
//     enterChatRoom();
//   }

//   Future<void> enterChatRoom() async {
//     final String springUrl = 'http://54.79.110.239:8080/api/chat/newChatRoom';

//     final http.Response response = await http.post(
//       Uri.parse(springUrl),
//       body: {'flutterRequest': '채팅방 요청'},
//     );

//     if (response.statusCode == 200) {
//       Map<String, dynamic> responseData = jsonDecode(response.body);
//       setState(() {
//         chatId = responseData['chatId'];
//       });
//       print('채팅방이 생성되었습니다. chatId: $chatId');
//     } else {
//       print('채팅방 생성에 실패했습니다. 에러 코드: ${response.statusCode}');
//     }
//   }

//   void _handleSubmitted(String text) {
//     _textController.clear();
//     ChatMessage message = ChatMessage(
//       text: text,
//       isUser: true,
//     );
//     setState(() {
//       _messages.insert(0, message);
//       sendMessage(chatId, text, memberId!);
//     });
//   }

//   Future<void> sendMessage(int chatId, String message, String? memberId) async {
//     if (memberId == null) {
//       print('Error: memberId is null');
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     final String springUrl =
//         'http://54.79.110.239:8080/api/chat/requestMessageFromFlutter/$chatId';

//     final Map<String, dynamic> chat = {
//       'chatId': chatId.toString(),
//       'memberId': memberId,
//       'chatContent': message,
//     };

//     final http.Response response = await http.post(Uri.parse(springUrl),
//         headers: {'Content-Type': 'application/json'}, body: jsonEncode(chat));

//     print('Spring 서버 응답 Status Code: ${response.statusCode}');
//     print('Spring 서버 응답 Body: ${utf8.decode(response.bodyBytes)}');

//     if (response.statusCode == 200) {
//       print('Spring으로 메세지가 성공적으로 전달되었습니다');
//       final springResponseBody = jsonDecode(utf8.decode(response.bodyBytes));
//       final receivedMessage = springResponseBody['response'];

//       setState(() {
//         _messages.insert(
//           0,
//           ChatMessage(
//             text: receivedMessage,
//             isUser: false,
//           ),
//         );
//         _isLoading = false;
//       });
//     } else {
//       print('Spring으로 메세지 전송에 실패했습니다. Error: ${response.reasonPhrase}');
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text(
//           textAlign: TextAlign.center,
//           '기룡이',
//           style: TextStyle(
//             color: Color.fromARGB(255, 49, 135, 255),
//             fontSize: 25,
//             fontFamily: 'single_day',
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (BuildContext context) {
//                   return const Chat();
//                 },
//               ),
//             );
//           },
//         ),
//         backgroundColor: const Color(0xFF98DFFF),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(5.0),
//           child: Container(
//             height: 3.0,
//             color: const Color.fromARGB(255, 255, 255, 255),
//           ),
//         ),
//       ),
//       backgroundColor: const Color(0xFF98DFFF),
//       body: GestureDetector(
//         onTap: () {
//           FocusScope.of(context).unfocus();
//         },
//         child: Column(
//           children: <Widget>[
//             Flexible(
//               child: ListView.builder(
//                 reverse: true,
//                 itemCount: _messages.length,
//                 itemBuilder: (_, int index) => _messages[index],
//               ),
//             ),
//             const Divider(height: 1.0),
//             const SizedBox(height: 20),
//             if (_isLoading)
//               Padding(
//                 padding: const EdgeInsets.only(left: 12.0),
//                 child: Row(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(right: 5.0),
//                       child: Container(
//                         height: 40.0,
//                         width: 100.0,
//                         color: Colors.white,
//                         child: const SpinKitThreeBounce(
//                           color: Colors.black,
//                           size: 10.0,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             const SizedBox(width: 8, height: 20),
//             Container(
//               decoration: BoxDecoration(
//                 color: Theme.of(context).cardColor,
//               ),
//               child: _buildTextComposer(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextComposer() {
//     return Builder(
//       builder: (BuildContext context) {
//         return IconTheme(
//           data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
//           child: Container(
//             margin: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Row(
//               children: <Widget>[
//                 Flexible(
//                   child: TextField(
//                     controller: _textController,
//                     onSubmitted: _handleSubmitted,
//                     decoration:
//                         const InputDecoration.collapsed(hintText: '메시지를 입력하세요'),
//                     keyboardType: TextInputType.multiline,
//                     maxLines: null,
//                     textInputAction: TextInputAction.send,
//                     style: const TextStyle(
//                       fontSize: 20.0,
//                       fontFamily: 'single_day',
//                     ),
//                     keyboardAppearance: Brightness.light,
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 4.0),
//                   child: IconButton(
//                     icon: const Icon(Icons.send),
//                     onPressed: () => _handleSubmitted(_textController.text),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class ChatMessage extends StatelessWidget {
//   final String text;
//   final bool isUser;

//   const ChatMessage({super.key, required this.text, required this.isUser});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10.0),
//       child: Row(
//         mainAxisAlignment:
//             isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Column(
//             crossAxisAlignment:
//                 isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//             children: <Widget>[
//               if (!isUser)
//                 Container(
//                   margin: const EdgeInsets.only(
//                       right: 10.0, left: 10.0, bottom: 10),
//                   child: const CircleAvatar(
//                     backgroundImage:
//                         AssetImage('lib/assets/images/giryong.png'),
//                     radius: 20,
//                   ),
//                 ),
//               if (isUser)
//                 Container(
//                   margin: const EdgeInsets.only(right: 10.0, left: 10.0),
//                   child: const Text('나'),
//                 ),
//               Container(
//                 constraints: BoxConstraints(
//                   maxWidth: MediaQuery.of(context).size.width * 0.5,
//                 ),
//                 margin: const EdgeInsets.only(right: 10.0, left: 10.0),
//                 padding: const EdgeInsets.all(10.0),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 child: Text(
//                   text,
//                   style: const TextStyle(
//                     color: Colors.black,
//                     fontFamily: 'single_day',
//                     fontSize: 20.0,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: const Center(
        child: Text('Chat'),
      ),
    );
  }
}
