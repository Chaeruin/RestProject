package heart.project.repository.mybatis;

import heart.project.domain.DailyRecommendation;
import heart.project.repository.dailyrecommendation.DailyRecommendationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
@RequiredArgsConstructor
public class MyBatisDailyRecommendationRepository implements DailyRecommendationRepository {

    private final DailyRecommendationMapper dailyRecommendationMapper;

    @Override
    public void insertDailyRecommendation(DailyRecommendation dailyRecommendation) {
        dailyRecommendationMapper.insertDailyRecommendation(dailyRecommendation);
    }

    @Override
    public List<DailyRecommendation> findDailyRecommendations(String memberId, String emotionType, LocalDate recommendationDate) {
        return dailyRecommendationMapper.selectDailyRecommendations(memberId, emotionType, recommendationDate);
    }
}
