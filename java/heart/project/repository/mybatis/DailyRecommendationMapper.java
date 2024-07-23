package heart.project.repository.mybatis;

import heart.project.domain.DailyRecommendation;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface DailyRecommendationMapper {

    void insertDailyRecommendation(DailyRecommendation dailyRecommendation);

    List<DailyRecommendation> selectDailyRecommendations(@Param("memberId") String memberId, @Param("emotionType") String emotionType, @Param("recommendationDate") LocalDate recommendationDate);
}