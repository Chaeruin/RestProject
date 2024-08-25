package heart.project.notifier;

import com.slack.api.Slack;
import com.slack.api.methods.MethodsClient;
import com.slack.api.methods.SlackApiException;
import com.slack.api.methods.request.chat.ChatPostMessageRequest;
import com.slack.api.methods.response.chat.ChatPostMessageResponse;

import java.io.IOException;

public class SlackNotifier {

    private static final Slack slack = Slack.getInstance();
    private static final MethodsClient methods = slack.methods(SLACK_TOKEN);

    // Slack 채널에 메시지를 전송하는 메소드
    private static void sendSlackMessage(String channel, String message) {
        try {
            ChatPostMessageRequest request = ChatPostMessageRequest.builder()
                    .channel(channel)
                    .text(message)
                    .build();

            ChatPostMessageResponse response = methods.chatPostMessage(request);

            if (!response.isOk()) {
                System.err.println("메시지 전송 오류: " + response.getError());
            }
        } catch (IOException | SlackApiException e) {
            System.err.println("메시지 전송 오류: " + e.getMessage());
        }
    }

    // Slack의 Diary 채널로 알림을 보내고 로그를 남기는 메소드
    public static void logAndNotifyDiary(String message) {
        System.out.println("Slack 알림 전송: " + message);
        sendSlackMessage(SLACK_CHANNEL_DIARY, message);
    }

    // Slack의 SignUp 채널로 알림을 보내고 로그를 남기는 메소드
    public static void logAndNotifySignUp(String message) {
        System.out.println("Slack 알림 전송: " + message);
        sendSlackMessage(SLACK_CHANNEL_SIGNUP, message);
    }

    // Slack의 MemberAction 채널로 알림을 보내고 로그를 남기는 메소드
    public static void logAndNotifyMemberAction(String message) {
        System.out.println("Slack 알림 전송: " + message);
        sendSlackMessage(SLACK_CHANNEL_MEMBERACTION, message);
    }
}
