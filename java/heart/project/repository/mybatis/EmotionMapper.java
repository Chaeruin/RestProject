package heart.project.repository.mybatis;

import heart.project.domain.Emotion;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Optional;

@Mapper
public interface EmotionMapper {

    // 동일한 회원과 날짜에 공개 감정이 있으면 비공개로 변경하여 중복 저장을 방지하는 메서드
    void preSave(Emotion emotion);

    // 감정을 저장하는 메서드
    void save(Emotion emotion);

    // 방금 저장된 감정을 조회하여 반환하는 메서드
    Emotion findNewEmotion();

    // 감정을 삭제하는 메서드
    void delete(Integer diaryId);

    // 일기 ID로 감정을 조회하는 메서드
    Optional<Emotion> findByDiaryId(Integer diaryId);

    // 회원의 월별 감정 통계를 조회하는 메서드
    LinkedHashMap<String, Object> getMonthlyEmotionStatistics(@Param("memberId") String memberId, @Param("month") String month);

    // 회원의 특정 월의 상위 3개의 감정을 조회하는 메서드
    List<LinkedHashMap<String, Object>> getTopEmotionsByMonth(@Param("memberId") String memberId, @Param("month") String month);

    // 회원의 시간별 감정을 조회하는 메서드
    List<LinkedHashMap<String, Object>> getHourlyEmotion(@Param("memberId") String memberId);

}
