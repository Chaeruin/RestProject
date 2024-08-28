import schedule
import time
import subprocess
import os
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError
from datetime import datetime
import pytz

# Slack 토큰과 채널 정보를 포함한 키 파일 임포트
from key import SLACK_TOKEN, SLACK_CHANNEL_SERVER, SLACK_CHANNEL_CHATBOT, SLACK_CHANNEL_MUSIC

# Slack 클라이언트 초기화
slack_client = WebClient(token=SLACK_TOKEN)

# 모니터링할 Flask 애플리케이션 프로세스 이름
PROCESS_NAME = "python app.py"

# 한국 시간대 설정
KST = pytz.timezone('Asia/Seoul')

# Slack으로 메시지를 보내는 함수
def send_slack_message(message):
    try:
        response = slack_client.chat_postMessage(
            channel=SLACK_CHANNEL_SERVER,
            text=message
        )
    except SlackApiError as e:
        print(f"Error sending message: {e}")

# 현재 시간을 한국 시간으로 반환하는 함수
def get_current_time():
    return datetime.now(KST).strftime("%Y-%m-%d %H:%M:%S")

# 서버 상태를 확인하고 Slack으로 보고하는 함수
def check_server_status():
    try:
        # ps 명령어를 사용하여 프로세스 확인
        result = subprocess.run(["ps", "aux"], capture_output=True, text=True)
        current_time = get_current_time()
        if PROCESS_NAME in result.stdout:
            send_slack_message(f"Flask 서버가 정상적으로 실행 중입니다. - {current_time}")
        else:
            send_slack_message(f"Flask 서버 프로세스를 찾을 수 없습니다. 서버가 종료되었을 수 있습니다. - {current_time}")

            # 서버가 종료된 경우 자동으로 재시작
            os.system(f"nohup {PROCESS_NAME} &")
            send_slack_message(f"Flask 서버를 재시작했습니다. - {current_time}")

    except Exception as e:
        send_slack_message(f"서버 상태 확인 중 오류 발생: {str(e)} - {get_current_time()}")

# 스케줄러를 실행하는 함수
def run_scheduler():
    send_slack_message(f"서버 모니터링을 시작합니다. - {get_current_time()}")
    # 1시간마다 서버 상태 확인 작업 스케줄링
    schedule.every(1).hour.do(check_server_status)
    while True:
        schedule.run_pending()
        time.sleep(1)

# 메인 실행 부분
if __name__ == "__main__":
    run_scheduler()

# 이 스크립트를 백그라운드에서 실행하기 위한 명령어:
# nohup python 이_스크립트_이름.py &
