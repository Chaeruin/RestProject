import os
import chatbot as ko_electra
from flask import Flask, request, jsonify
from werkzeug.exceptions import BadRequest
import jsons
from flask import Flask, request, jsonify
from werkzeug.exceptions import BadRequest
from music.emotion import Emotion
from music.recomm import recommandMusics
import boto3
from flask_cors import CORS  # Install flask-cors package
import threading  # 이 줄을 추가합니다.


app = Flask(__name__)
CORS(app)
app.config['JSON_AS_ASCII'] = False #UTF-8 설정하려고 추가한 부분! 이거 없으면 스프링으로 응답 보낼 때 유니코드로 나옴

emotion = Emotion()


@app.route('/')
def isRunning():
    return "server is running"


@app.route('/chatbot/<int:chat_id>', methods=['POST']) #chat_id에 맞게 채팅방 생성, 밑에 매개변수에 꼭 있어야 함
# def reactKobertChatBot(chat_id):
def reactKoElectraChatBot(chat_id):

    # POST 요청의 본문을 추출
    message_data = request.json

    if message_data and 'messageFromFlutter' in message_data:
        message = message_data['messageFromFlutter']

        print(f"\n😀 사용자 : {message}\n")

    sentence = request.args.get("s")
    if message is None or len(message) == 0 or sentence == '\n':
        return jsonify({
            "response": "듣고 있어요. 더 말씀해주세요~"
        })

    chatbot_answer, category = ko_electra.chat(message)
    
    return jsonify({
        "response": chatbot_answer,
        "category": category
        })


# music recommand & aws comprehend

def comprehend_sentiment(text):
    # AWS CLI에서 구성된 자격 증명을 사용하여 Comprehend 클라이언트 생성
    comprehend = boto3.client('comprehend')

    # # 텍스트 감정 분석
    response = comprehend.detect_sentiment(Text=text, LanguageCode='en')
    sentiment = response['SentimentScore']

    return sentiment


@app.route('/analyze', methods=['POST'])
def analyze():
    text = request.json['text']  # Get the text from the JSON request body
    # flutter 에서 json 형식으로 key 'text', value 일기 내용 으로 넘어와야 함
    sentiment = comprehend_sentiment(text)
    result = sentiment
    return jsonify(result)



@app.route('/music/recommendation', methods=["POST"])
def recommendMusic():
    # 감정이 상수 혹은 string으로 들어와야 함(emotion.py 참고)
    data = request.json
    emotionI = data['emotion']
    print(f"\n📍 감정 : {emotionI}")

    if emotionI is None:        # 입력 베이스 감정이 없을 때
        print(emotionI)
        return None

    empathy_tracks, overcome_tracks = recommandMusics(emotionI)

    # 공감형 트랙
    empathy_results = [
    {'artist': empathy_tracks[0]['artists'][0]['name'], 'name': empathy_tracks[0]['name'], 'image': empathy_tracks[0]['album']['images'][2]['url']},
    {'artist': empathy_tracks[1]['artists'][0]['name'], 'name': empathy_tracks[1]['name'], 'image': empathy_tracks[1]['album']['images'][2]['url']},
    {'artist': empathy_tracks[2]['artists'][0]['name'], 'name': empathy_tracks[2]['name'], 'image': empathy_tracks[2]['album']['images'][2]['url']},
    {'artist': empathy_tracks[3]['artists'][0]['name'], 'name': empathy_tracks[3]['name'], 'image': empathy_tracks[3]['album']['images'][2]['url']},
    {'artist': empathy_tracks[4]['artists'][0]['name'], 'name': empathy_tracks[4]['name'], 'image': empathy_tracks[4]['album']['images'][2]['url']}
]

    # 극복형 트랙 (제 2 트랙)
    overcome_results = [
        {'artist': overcome_tracks[0]['artists'][0]['name'], 'name': overcome_tracks[0]['name'], 'image': overcome_tracks[0]['album']['images'][2]['url']},
        {'artist': overcome_tracks[1]['artists'][0]['name'], 'name': overcome_tracks[1]['name'], 'image': overcome_tracks[1]['album']['images'][2]['url']},
        {'artist': overcome_tracks[2]['artists'][0]['name'], 'name': overcome_tracks[2]['name'], 'image': overcome_tracks[2]['album']['images'][2]['url']},
        {'artist': overcome_tracks[3]['artists'][0]['name'], 'name': overcome_tracks[3]['name'], 'image': overcome_tracks[3]['album']['images'][2]['url']},
        {'artist': overcome_tracks[4]['artists'][0]['name'], 'name': overcome_tracks[4]['name'], 'image': overcome_tracks[4]['album']['images'][2]['url']}
     ]

    print(f"\n🎵 공감형 트랙 : {empathy_results}\n")
    print(f"\n🎵 극복형 트랙 : {overcome_results}\n")

    # 전체 결과 (데이터 전송용)
    return jsonify({
        'empathy': empathy_results,
        'overcome' : overcome_results
    })

    # 데이터 전송 형태 json -> { 키 : 리스트[{ 키 : 밸류 }, ...], 키 : 리스트[{ 키 : 밸류 }, ... ] }

if __name__ == '__main__':
    app.run(debug=False,host="0.0.0.0",port=int(os.environ.get("PORT", 8081)))