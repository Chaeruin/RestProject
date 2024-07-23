package heart.project.repository.dailyrecommendation;

import heart.project.domain.DailyRecommendation;

import java.time.LocalDate;
import java.util.List;

public interface DailyRecommendationRepository {

    void insertDailyRecommendation(DailyRecommendation dailyRecommendation);

    List<DailyRecommendation> findDailyRecommendations(String memberId, String emotionType, LocalDate recommendationDate);
}
