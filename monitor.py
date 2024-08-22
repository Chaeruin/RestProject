import schedule
import time
import subprocess
import os
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError
from datetime import datetime
import pytz

# Slack key
from key import SLACK_TOKEN, SLACK_CHANNEL_SERVER, SLACK_CHANNEL_CHATBOT, SLACK_CHANNEL_MUSIC

# Slack 설정
slack_client = WebClient(token=SLACK_TOKEN)

# Flask 애플리케이션 프로세스 이름 (예: python app.py)
PROCESS_NAME = "python app.py"

# 한국 시간대 설정
KST = pytz.timezone('Asia/Seoul')

def send_slack_message(message):
    try:
        response = slack_client.chat_postMessage(
            channel=SLACK_CHANNEL_SERVER,
            text=message
        )
    except SlackApiError as e:
        print(f"Error sending message: {e}")

def get_current_time():
    return datetime.now(KST).strftime("%Y-%m-%d %H:%M:%S")

def check_server_status():
    try:
        # ps 명령어를 사용하여 프로세스 확인
        result = subprocess.run(["ps", "aux"], capture_output=True, text=True)
        current_time = get_current_time()
        if PROCESS_NAME in result.stdout:
            send_slack_message(f"Flask 서버가 정상적으로 실행 중입니다. - {current_time}")
        else:
            send_slack_message(f"Flask 서버 프로세스를 찾을 수 없습니다. 서버가 종료되었을 수 있습니다. - {current_time}")

            # 옵션: 서버가 종료된 경우 자동으로 재시작
            os.system(f"nohup {PROCESS_NAME} &")
            send_slack_message(f"Flask 서버를 재시작했습니다. - {current_time}")

    except Exception as e:
        send_slack_message(f"서버 상태 확인 중 오류 발생: {str(e)} - {get_current_time()}")

def run_scheduler():
    send_slack_message(f"서버 모니터링을 시작합니다. - {get_current_time()}")
    schedule.every(1).hour.do(check_server_status)
    while True:
        schedule.run_pending()
        time.sleep(1)

if __name__ == "__main__":
    run_scheduler()

# 이 스크립트를 nohup으로 실행하려면 다음 명령어를 사용하세요:
# nohup python 이_스크립트_이름.py &
