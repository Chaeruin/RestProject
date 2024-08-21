package heart.project.repository.emotion;

import heart.project.domain.Emotion;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Optional;

public interface EmotionRepository {

    // 감정을 저장하는 메서드
    Emotion save(Emotion emotion);

    // 감정을 삭제하는 메서드
    void delete(Integer diaryId);

    // 일기 ID로 감정을 조회하는 메서드
    Optional<Emotion> findByDiaryId(Integer diaryId);

    // 회원의 월별 감정 통계를 조회하는 메서드
    LinkedHashMap<String, Object> getMonthlyEmotionStatistics(String memberId, String month);

    // 회원의 특정 월의 상위 3개의 감정을 조회하는 메서드
    List<LinkedHashMap<String, Object>> getTopEmotionsByMonth(String memberId, String month);

    // 회원의 시간별 감정을 조회하는 메서드
    List<LinkedHashMap<String, Object>> getHourlyEmotion(String memberId);
}
