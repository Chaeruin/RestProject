package heart.project.controller.emotion;

import heart.project.service.emotion.EmotionService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/emotion")
public class EmotionApiController {

    private final EmotionService emotionService;

    /**
     * 특정 멤버의 특정 월에 대한 감정 통계를 조회하는 엔드포인트
     */
    @GetMapping("/statistics/{memberId}")
    public ResponseEntity<LinkedHashMap<String, Object>> getMonthlyEmotionStatistics(
            @PathVariable("memberId") String memberId,
            @RequestParam("month") String month) {

        LinkedHashMap<String, Object> statistics = emotionService.getMonthlyEmotionStatistics(memberId, month);
        return ResponseEntity.ok(statistics);
    }

    /**
     * 특정 멤버의 특정 월에 가장 많이 나타난 상위 3개의 감정을 조회하는 엔드포인트
     */
    @GetMapping("/top3/{memberId}")
    public ResponseEntity<List<LinkedHashMap<String, Object>>> getTopEmotionsByMonth(
            @PathVariable("memberId") String memberId,
            @RequestParam("month") String month) {

        List<LinkedHashMap<String, Object>> statistics = emotionService.getTopEmotionsByMonth(memberId, month);
        return ResponseEntity.ok(statistics);
    }

    /**
     * 특정 멤버의 시간대별로 나타난 감정 통계를 조회하는 엔드포인트
     */
    @GetMapping("/hourly/{memberId}")
    public ResponseEntity<List<LinkedHashMap<String, Object>>> getHourlyEmotion(
            @PathVariable("memberId") String memberId) {

        List<LinkedHashMap<String, Object>> statistics = emotionService.getHourlyEmotion(memberId);
        return ResponseEntity.ok(statistics);
    }
}
