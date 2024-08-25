package heart.project.controller.diary;

import heart.project.domain.Diary;
import heart.project.domain.Emotion;
import heart.project.notifier.SlackNotifier;
import heart.project.repository.diary.DiaryUpdateApiDto;
import heart.project.service.diary.DiaryService;
import heart.project.service.emotion.EmotionService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;


@RestController
@RequiredArgsConstructor
@RequestMapping("/api/diaries")
public class DiaryApiController {

    private final DiaryService diaryService;
    private final EmotionService emotionService;

    /**
     * 특정 일기 ID로 일기를 조회하는 엔드포인트
     */
    @GetMapping("/{diaryId}")
    public ResponseEntity<Diary> getDiaryById(@PathVariable("diaryId") Integer diaryId) {
        return diaryService.findById(diaryId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * 새로운 일기를 저장하는 엔드포인트
     */
    @PostMapping("/add")
    public ResponseEntity<?> saveDiary(@RequestBody Diary diary) {
        String beforeEmotion = diary.getBeforeEmotion();
        String afterEmotion = diary.getAfterEmotion();

        Diary savedDiary = diaryService.save(diary);

        // 감정 객체 생성
        Emotion emotion = new Emotion();
        emotion.setDiaryId(savedDiary.getDiaryId());
        emotion.setMemberId(savedDiary.getMemberId());
        emotion.setBeforeEmotion(beforeEmotion);
        emotion.setAfterEmotion(afterEmotion);

        // 감정 저장
        emotionService.save(emotion);

        // 응답에 emotion 정보 추가
        savedDiary.setBeforeEmotion(beforeEmotion);
        savedDiary.setAfterEmotion(afterEmotion);

        // Slack 알림 메시지 생성
        String slackMessage = String.format("새로운 일기가 저장되었습니다:\n- 일기 ID: %s\n- 회원 ID: %s\n- 작성 일자: %s\n- 작성 내용: %s\n- 일기 작성 이전 감정: %s\n- 일기 작성 이후 감정: %s",
                savedDiary.getDiaryId(), savedDiary.getMemberId(), savedDiary.getWriteDate(), savedDiary.getContent(), beforeEmotion, afterEmotion);

        // Slack 알림 전송
        SlackNotifier.logAndNotifyDiary(slackMessage);

        Map<String, Object> responseData = new HashMap<>();
        responseData.put("message", "일기가 저장되었습니다");
        responseData.put("savedDiary", savedDiary);

        return ResponseEntity.status(HttpStatus.CREATED).body(responseData);
    }

    /**
     * 특정 일기의 내용을 수정하는 엔드포인트
     */
    @PutMapping("/{diaryId}/edit")
    public ResponseEntity<String> editDiary(@PathVariable("diaryId") Integer diaryId, @RequestBody DiaryUpdateApiDto updateParam) {

        // 일기 수정
        diaryService.update(diaryId, updateParam);

        // 수정된 일기 조회
        Diary updatedDiary = diaryService.findById(diaryId)
                .orElseThrow(() -> new IllegalArgumentException("해당 Diary ID의 일기를 찾을 수 없습니다."));

        // Slack 알림 메시지 생성
        String slackMessage = String.format("일기가 수정되었습니다:\n- 일기 ID: %s\n- 회원 ID: %s\n- 작성 일자: %s\n- 작성 내용: %s\n- 일기 작성 이전 감정: %s\n- 일기 작성 이후 감정: %s",
                updatedDiary.getDiaryId(), updatedDiary.getMemberId(), updatedDiary.getWriteDate(), updatedDiary.getContent(), updatedDiary.getBeforeEmotion(), updatedDiary.getAfterEmotion());

        // Slack 알림 전송
        SlackNotifier.logAndNotifyDiary(slackMessage);

        return ResponseEntity.ok("일기가 수정되었습니다");
    }

    /**
     * 특정 일기를 삭제하는 엔드포인트
     */
    @PutMapping("/{diaryId}/delete")
    public ResponseEntity<String> deleteDiary(@PathVariable("diaryId") Integer diaryId) {
        diaryService.delete(diaryId);
        emotionService.delete(diaryId);

        // Slack 알림 메시지 생성
        String slackMessage = String.format("일기가 삭제되었습니다:\n- 일기 ID: %s\n", diaryId);

        // Slack 알림 전송
        SlackNotifier.logAndNotifyDiary(slackMessage);

        return ResponseEntity.ok("일기가 삭제되었습니다");
    }

    /**
     * 특정 멤버의 모든 일기를 조회하는 엔드포인트
     */
    @GetMapping("/member/{memberId}")
    public ResponseEntity<List<Diary>> getDiariesByMemberId(@PathVariable("memberId") String memberId) {
        List<Diary> diaries = diaryService.findByMemberId(memberId);
        return ResponseEntity.ok(diaries);
    }

    /**
     * 특정 멤버의 특정 날짜에 작성된 일기를 조회하는 엔드포인트
     */
    @GetMapping("/{memberId}/{writeDate}")
    public ResponseEntity<Diary> getDiaryByMemberIdAndWriteDate(
            @PathVariable("memberId") String memberId,
            @PathVariable("writeDate") String writeDate) {
        return diaryService.findByMemberIdAndWriteDate(memberId, writeDate)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * 특정 멤버의 가장 최근 작성한 일기를 조회하는 엔드포인트
     */
    @GetMapping("/{memberId}/latest-diary")
    public ResponseEntity<Diary> getLatestDiaryByMemberId(@PathVariable("memberId") String memberId) {
        return diaryService.findLatestDiaryByMemberId(memberId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
}
