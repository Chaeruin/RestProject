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

    // 일일 추천 행동을 저장하는 메서드
    @Override
    public void insertDailyRecommendation(DailyRecommendation dailyRecommendation) {
        dailyRecommendationMapper.insertDailyRecommendation(dailyRecommendation);
    }

    // 주어진 회원 ID, 감정 타입, 추천한 날짜에 해당하는 일일 추천 행동 목록을 반환하는 메서드
    @Override
    public List<DailyRecommendation> findDailyRecommendations(String memberId, String emotionType, LocalDate recommendationDate) {
        return dailyRecommendationMapper.selectDailyRecommendations(memberId, emotionType, recommendationDate);
    }
}
