package heart.project.controller.dailyrecommendation;

import heart.project.domain.DailyRecommendation;
import heart.project.service.dailyrecommendation.DailyRecommendationService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/daily-recommendations")
public class DailyRecommendationController {

    private final DailyRecommendationService dailyRecommendationService;

    /**
     * 감정 타입에 맞는 행동을 카테고리별로 각각 1개씩 랜덤으로 추천하는 엔드포인트
     */
    @GetMapping("/{memberId}/{emotionType}/{recommendationDate}")
    public List<DailyRecommendation> recommendActionsByCategory(
            @PathVariable("memberId") String memberId,
            @PathVariable("emotionType") String emotionType,
            @PathVariable("recommendationDate") String recommendationDate) {

        // 'yyyyMMdd' 포맷으로 날짜 문자열을 LocalDate로 변환
        LocalDate date = LocalDate.parse(recommendationDate, DateTimeFormatter.BASIC_ISO_DATE);

        return dailyRecommendationService.recommendDailyRecommendationsByCategory(memberId, emotionType, date);
    }
}
