package heart.project.repository.mybatis;

import heart.project.domain.Emotion;
import heart.project.repository.emotion.EmotionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class MyBatisEmotionRepository implements EmotionRepository {

    private final EmotionMapper emotionMapper;

    // 감정을 저장하는 메서드
    @Override
    public Emotion save(Emotion emotion) {
        emotionMapper.preSave(emotion);
        emotionMapper.save(emotion);
        return emotionMapper.findNewEmotion();
    }

    // 감정을 삭제하는 메서드
    @Override
    public void delete(Integer diaryId) {
        emotionMapper.delete(diaryId);
    }

    // 일기 ID로 감정을 조회하는 메서드
    @Override
    public Optional<Emotion> findByDiaryId(Integer diaryId) {
        return emotionMapper.findByDiaryId(diaryId);
    }

    // 회원의 월별 감정 통계를 조회하는 메서드
    @Override
    public LinkedHashMap<String, Object> getMonthlyEmotionStatistics(String memberId, String month) {
        return emotionMapper.getMonthlyEmotionStatistics(memberId, month);
    }

    // 회원의 특정 월의 상위 3개의 감정을 조회하는 메서드
    @Override
    public List<LinkedHashMap<String, Object>> getTopEmotionsByMonth(String memberId, String month) {
        return emotionMapper.getTopEmotionsByMonth(memberId, month);
    }

    // 회원의 시간별 감정을 조회하는 메서드
    @Override
    public List<LinkedHashMap<String, Object>> getHourlyEmotion(String memberId) {
        return emotionMapper.getHourlyEmotion(memberId);
    }
}
