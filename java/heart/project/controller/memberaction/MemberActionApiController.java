package heart.project.controller.memberaction;

import heart.project.domain.MemberAction;
import heart.project.notifier.SlackNotifier;
import heart.project.repository.memberaction.MemberActionUpdateApiDto;
import heart.project.service.memberaction.MemberActionService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/member-actions")
public class MemberActionApiController {

    private final MemberActionService memberActionService;

    /**
     * 새로운 멤버 행동을 저장하고, 기본 상태를 '진행중'으로 설정하여 반환하는 엔드포인트
     */
    @PostMapping("/add")
    public ResponseEntity<?> saveMemberAction(@RequestBody MemberAction memberAction) {
        MemberAction savedMemberAction = memberActionService.save(memberAction);

        // Slack 알림 메시지 생성
        String slackMessage = String.format("새로운 멤버 행동이 저장되었습니다:\n- 멤버행동 ID: %s\n- 행동 ID: %s\n- 멤버 ID: %s\n- 행동 내용: %s\n- 상태: %s\n- 행동하기 이전 감정: %s\n- 행동하기 이후 감정: %s\n- 행동 추천 날짜: %s",
                savedMemberAction.getMemberActionId(), savedMemberAction.getActionId(), savedMemberAction.getMemberId(), savedMemberAction.getAction(), savedMemberAction.getStatus(), savedMemberAction.getBeforeEmotion(), savedMemberAction.getAfterEmotion(), savedMemberAction.getRecommendationDate());

        // Slack 알림 전송
        SlackNotifier.logAndNotifyMemberAction(slackMessage);

        Map<String, Object> responseData = new LinkedHashMap<>();
        responseData.put("message", "행동이 저장되었습니다");
        responseData.put("savedMemberAction", savedMemberAction);

        return ResponseEntity.status(HttpStatus.CREATED).body(responseData);
    }

    /**
     * 행동 후 감정 변화를 갱신하고, 상태를 '완료'로 바꾸는 엔드포인트
     */
    @PutMapping("{memberActionId}/complete")
    public ResponseEntity<?> completeMemberAction(
            @PathVariable("memberActionId") Integer memberActionId,
            @RequestBody MemberActionUpdateApiDto updateParam) {

        MemberAction completedMemberAction = memberActionService.completeMemberAction(memberActionId, updateParam);

        // Slack 알림 메시지 생성
        String slackMessage = String.format("멤버 행동이 완료되었습니다:\n- 멤버행동 ID: %s\n- 행동 ID: %s\n- 멤버 ID: %s\n- 행동 내용: %s\n- 상태: %s\n- 행동하기 이전 감정: %s\n- 행동하기 이후 감정: %s\n- 행동 추천 날짜: %s",
                completedMemberAction.getMemberActionId(), completedMemberAction.getActionId(), completedMemberAction.getMemberId(), completedMemberAction.getAction(), completedMemberAction.getStatus(), completedMemberAction.getBeforeEmotion(), completedMemberAction.getAfterEmotion(), completedMemberAction.getRecommendationDate());

        // Slack 알림 전송
        SlackNotifier.logAndNotifyMemberAction(slackMessage);

        Map<String, Object> responseData = new LinkedHashMap<>();
        responseData.put("message", "행동이 완료되었습니다");
        responseData.put("completedMemberAction", completedMemberAction);

        return ResponseEntity.status(HttpStatus.CREATED).body(responseData);
    }

    /**
     * 특정 멤버의 상태가 '진행중'인 행동을 조회하는 엔드포인트
     */
    @GetMapping("/{memberId}/ongoing")
    public ResponseEntity<List<MemberAction>> getOngoingActionsByMemberId(@PathVariable("memberId") String memberId) {
        List<MemberAction> actions = memberActionService.getOngoingActionsByMemberId(memberId);
        return ResponseEntity.ok(actions);
    }

    /**
     * 특정 멤버의 상태가 '완료'인 행동을 조회하는 엔드포인트
     */
    @GetMapping("/{memberId}/completed")
    public ResponseEntity<List<MemberAction>> getCompletedActionsByMemberId(@PathVariable("memberId") String memberId) {
        List<MemberAction> actions = memberActionService.getCompletedActionsByMemberId(memberId);
        return ResponseEntity.ok(actions);
    }

    /**
     * 특정 멤버의 기분을 나아지게 한 행동 2개를 조회하는 엔드포인트
     */
    @GetMapping("/{memberId}/feel-better")
    public ResponseEntity<List<MemberAction>> getFeelBetterActions(@PathVariable("memberId") String memberId) {
        List<MemberAction> actions = memberActionService.getFeelBetterActions(memberId);
        return ResponseEntity.ok(actions);
    }

}
