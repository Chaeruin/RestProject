import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/Assets/Images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/Assets/Images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/Assets/Images/3.png',
                height: 350,
                width: 250,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFFFBA0),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.all(20),
                child: Text(
                  '오늘은 날씨가 선선하니 \n야외에서 30분 산책하기 \n어떠세요?^^',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 23,
                    fontFamily: 'single_day',
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
