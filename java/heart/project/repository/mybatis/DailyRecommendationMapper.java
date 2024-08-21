package heart.project.repository.mybatis;

import heart.project.domain.DailyRecommendation;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface DailyRecommendationMapper {

    // 일일 추천 행동을 저장하는 메서드
    void insertDailyRecommendation(DailyRecommendation dailyRecommendation);

    // 주어진 회원 ID, 감정 타입, 추천한 날짜에 해당하는 일일 추천 행동 목록을 반환하는 메서드
    List<DailyRecommendation> selectDailyRecommendations(@Param("memberId") String memberId, @Param("emotionType") String emotionType, @Param("recommendationDate") LocalDate recommendationDate);
}