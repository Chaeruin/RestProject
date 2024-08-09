package heart.project.controller.diary;

import heart.project.domain.Diary;
import heart.project.domain.Emotion;
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

        diaryService.update(diaryId, updateParam);

        return ResponseEntity.ok("일기가 수정되었습니다");
    }

    /**
     * 특정 일기를 삭제하는 엔드포인트
     */
    @PutMapping("/{diaryId}/delete")
    public ResponseEntity<String> deleteDiary(@PathVariable("diaryId") Integer diaryId) {
        diaryService.delete(diaryId);
        emotionService.delete(diaryId);
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
