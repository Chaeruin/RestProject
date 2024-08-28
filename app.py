# 필요한 라이브러리 및 모듈 임포트
import os
import jsons
import asyncio
from flask import Flask, request, jsonify
from werkzeug.exceptions import BadRequest
from flask_cors import CORS
import threading
import boto3
from functools import wraps
from flask import current_app
from concurrent.futures import ThreadPoolExecutor

import asyncio
from asyncio import Queue

from model.emotion import Emotion
from model.musicgen import generate_music
import model.chatbot1 as ko_electra

from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

from key import SLACK_TOKEN, SLACK_CHANNEL_SERVER, SLACK_CHANNEL_CHATBOT, SLACK_CHANNEL_MUSIC

# Flask 앱 초기화
app = Flask(__name__)
CORS(app)
app.config['JSON_AS_ASCII'] = False

emotion = Emotion()

# Slack 클라이언트 초기화
slack_client = WebClient(token=SLACK_TOKEN)

# Slack 메시지 전송 함수
def send_slack_message(channel, message):
    try:
        response = slack_client.chat_postMessage(
            channel=channel,
            text=message
        )
    except SlackApiError as e:
        print(f"Error sending message: {e}")

# Slack 메시지 전송 및 콘솔 출력 함수
def send_slack(channel, message):
    print(message)
    send_slack_message(channel, message)

# 채팅봇 관련 Slack 메시지 전송
def print_and_slack_CB(message):
    send_slack(SLACK_CHANNEL_CHATBOT, message)

# 음악 생성 관련 Slack 메시지 전송
def print_and_slack_M(message):
    send_slack(SLACK_CHANNEL_MUSIC, message)

# 서버 상태 확인 라우트
@app.route('/')
def isRunning():
    message = "server is running"
    # send_slack(SLACK_CHANNEL_SERVER, message)
    return message

# 비동기 라우트 데코레이터
def async_route(f):
    @wraps(f)
    def wrapped(*args, **kwargs):
        return asyncio.run(f(*args, **kwargs))
    return wrapped

# 채팅봇 응답 라우트
@app.route('/chatbot/<int:chat_id>', methods=['POST'])
@async_route
async def reactKoElectraChatBot(chat_id):
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

    # 채팅봇 응답 생성
    chatbot_answer, category = await asyncio.to_thread(ko_electra.chat, message)

    return jsonify({
        "response": chatbot_answer,
        "category": category
    })

# 비동기 음악 생성 함수
async def generate_music_async(memberID, emotionI):
    try:
        await asyncio.to_thread(generate_music, memberID, emotionI)
        print_and_slack_M(f"🎵 음악 생성 완료 : ID {memberID}, 감정 {emotionI}")
    except Exception as e:
        print_and_slack_M(f"❌ 음악 생성 실패 : ID {memberID}, 감정 {emotionI}, 에러: {str(e)}")

# 비동기 작업 실행 함수
def run_async_task(app, memberID, emotionI):
    with app.app_context():
        asyncio.run(generate_music_async(memberID, emotionI))

# 음악 추천 라우트
@app.route('/music/<string:memberId>', methods=["POST"])
def recommendMusic(memberId):
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

    # 백그라운드에서 음악 생성 작업을 실행
    thread = threading.Thread(target=run_async_task, args=(current_app._get_current_object(), memberID, emotionI))
    thread.start()

    print_and_slack_M(f"🎶 음악 생성 시작 -> 백그라운드 처리중.")
    return jsonify({'message': '음악 생성 시작 -> 백그라운드 처리중'}), 202

# 메인 실행 부분
if __name__ == '__main__':
    app.run(debug=False, host="0.0.0.0", port=int(os.environ.get("PORT", 8081)))

