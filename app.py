import os
import jsons
from flask import Flask, request, jsonify
from werkzeug.exceptions import BadRequest
from flask import Flask, request, jsonify
from werkzeug.exceptions import BadRequest
import threading


from model.emotion import Emotion
from model.musicgen import generate_music

import model.chatbot1 as ko_electra

import boto3
from flask_cors import CORS  # Install flask-cors package
import threading  # 이 줄을 추가합니다.


# Slack
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError


# Slack key
from key import SLACK_TOKEN, SLACK_CHANNEL_SERVER, SLACK_CHANNEL_CHATBOT, SLACK_CHANNEL_MUSIC


# Slack 클라이언트 초기화
slack_client = WebClient(token=SLACK_TOKEN)


def send_slack_message(channel, message):
    try:
        response = slack_client.chat_postMessage(
            channel=channel,
            text=message
        )
    except SlackApiError as e:
        print(f"Error sending message: {e}")

def send_slack(channel, message):
    print(message)
    send_slack_message(channel, message)


# 사용 예시
def print_and_slack_CB(message):
    send_slack(SLACK_CHANNEL_CHATBOT, message)s

def print_and_slack_M(message):
    send_slack(SLACK_CHANNEL_MUSIC, message)


app = Flask(__name__)
CORS(app)
app.config['JSON_AS_ASCII'] = False #UTF-8 설정하려고 추가한 부분! 이거 없으면 스프링으로 응답 보낼 때 유니코드로 나옴

emotion = Emotion()


@app.route('/')
def isRunning():
    return "server is running"
    print_and_slack("server is running")


@app.route('/chatbot/<int:chat_id>', methods=['POST']) #chat_id에 맞게 채팅방 생성, 밑에 매개변수에 꼭 있어야 함
# def reactKobertChatBot(chat_id):
def reactKoElectraChatBot(chat_id):

    # POST 요청의 본문을 추출
    message_data = request.json

    if message_data and 'messageFromFlutter' in message_data:
        message = message_data['messageFromFlutter']

        print_and_slack_CB(f"\n👾 채팅 로그\n")
        print_and_slack_CB(f"\n😀 사용자 : {message}\n")

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




def generate_music_async(memberID, emotionI):
    try:
        generate_music(memberID, emotionI)
        print_and_slack_M(f"🎵 음악 생성 완료 : ID {memberID}, 감정 {emotionI}")
    except Exception as e:
        print_and_slack_M(f"❌ 음악 생성 실패 : ID {memberID}, 감정 {emotionI}, 에러: {str(e)}")


@app.route('/music/recommendation', methods=["POST"])

def recommendMusic():
    data = request.json

    memberID = data.get('memberId')
    emotionI = data.get('afterEmotion')

    print_and_slack_M(f"\n📍 음악 생성 로그 ")
    print_and_slack_M(f"\n📍 ID : {memberID}")
    print_and_slack_M(f"\n📍 감정 : {emotionI}")

    if not memberID:
        return jsonify({'❌ error': 'memberId 값이 없습니다.'}), 400

    if not emotionI:
        return jsonify({'❌ error': 'afterEmotion 값이 없습니다.'}), 400

    # 비동기로 음악 생성 작업 실행
    thread = threading.Thread(target=generate_music_async, args=(memberID, emotionI))
    thread.start()

    return jsonify({'message': '음악 생성이 시작되었습니다. 백그라운드에서 처리됩니다.'}), 202

        

if __name__ == '__main__':
    app.run(debug=False,host="0.0.0.0",port=int(os.environ.get("PORT", 8081)))








