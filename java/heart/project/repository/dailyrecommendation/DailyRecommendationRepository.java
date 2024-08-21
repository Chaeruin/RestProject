package heart.project.repository.dailyrecommendation;

import heart.project.domain.DailyRecommendation;

import java.time.LocalDate;
import java.util.List;

public interface DailyRecommendationRepository {

    // 일일 추천 행동을 저장하는 메서드
    void insertDailyRecommendation(DailyRecommendation dailyRecommendation);

    // 주어진 회원 ID, 감정 타입, 추천한 날짜에 해당하는 일일 추천 행동 목록을 반환하는 메서드
    List<DailyRecommendation> findDailyRecommendations(String memberId, String emotionType, LocalDate recommendationDate);
}
