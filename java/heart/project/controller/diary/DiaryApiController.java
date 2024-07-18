package heart.project.controller.diary;

import heart.project.domain.Diary;
import heart.project.domain.Emotion;
import heart.project.repository.diary.DiaryUpdateApiDto;
import heart.project.repository.emotion.EmotionUpdateApiDto;
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
        String emotionType = diary.getEmotionType();

        Diary savedDiary = diaryService.save(diary);

        // 감정 객체 생성
        Emotion emotion = new Emotion();
        emotion.setDiaryId(savedDiary.getDiaryId());
        emotion.setMemberId(savedDiary.getMemberId());
        emotion.setEmotionType(emotionType);

        // 감정 저장
        emotionService.save(emotion);

        // 응답에 emotionType 정보 추가
        savedDiary.setEmotionType(emotionType);

        Map<String, Object> responseData = new HashMap<>();
        responseData.put("message", "일기가 저장되었습니다");
        responseData.put("savedDiary", savedDiary);

        return ResponseEntity.status(HttpStatus.CREATED).body(responseData);
    }

    /**
     * 특정 일기를 수정하는 엔드포인트
     */
    @PutMapping("/{diaryId}/edit")
    public ResponseEntity<String> editDiary(@PathVariable("diaryId") Integer diaryId, @RequestBody DiaryUpdateApiDto updateParam) {
        String emotionType = updateParam.getEmotionType();

        diaryService.update(diaryId, updateParam);

        // 감정 수정
        Optional<Emotion> existingEmotion = emotionService.findByDiaryId(diaryId);
        if (existingEmotion.isEmpty()) {
            // 해당 diaryId에 대한 감정이 없으면 새로 추가
            Emotion emotion = new Emotion();
            emotion.setDiaryId(diaryId);
            emotion.setMemberId(updateParam.getMemberId());
            emotion.setEmotionType(emotionType);
            emotionService.save(emotion);
        } else {
            // 해당 diaryId에 대한 감정이 이미 존재하면 업데이트
            EmotionUpdateApiDto emotionUpdateDto = new EmotionUpdateApiDto(emotionType);
            emotionService.update(diaryId, emotionUpdateDto);
        }

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

}
