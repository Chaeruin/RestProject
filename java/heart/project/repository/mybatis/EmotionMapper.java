package heart.project.repository.mybatis;

import heart.project.domain.Emotion;
import heart.project.repository.emotion.EmotionUpdateApiDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Optional;

@Mapper
public interface EmotionMapper {

    void preSave(Emotion emotion);

    void save(Emotion emotion);

    Emotion findNewEmotion();

    void update(@Param("diaryId") Integer diaryId, @Param("updateParam") EmotionUpdateApiDto updateParam);

    void delete(Integer diaryId);

    Optional<Emotion> findByDiaryId(Integer diaryId);

    LinkedHashMap<String, Object> getMonthlyEmotionStatistics(@Param("memberId") String memberId, @Param("month") String month);

    List<LinkedHashMap<String, Object>> getTopEmotionsByMonth(@Param("memberId") String memberId, @Param("month") String month);

    List<LinkedHashMap<String, Object>> getHourlyEmotion(@Param("memberId") String memberId);

}
