package heart.project.service.emotion;

import heart.project.domain.Emotion;
import heart.project.repository.emotion.EmotionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class EmotionService {

    private final EmotionRepository emotionRepository;

    // 감정을 저장하는 메서드
    public Emotion save(Emotion emotion) {
        return emotionRepository.save(emotion);
    }

    // 감정을 삭제하는 메서드
    public void delete(Integer diaryId) {
        emotionRepository.delete(diaryId);
    }

    // 일기 ID로 감정을 조회하는 메서드
    public Optional<Emotion> findByDiaryId(Integer diaryId) {
        return emotionRepository.findByDiaryId(diaryId);
    }

    // 회원의 월별 감정 통계를 조회하는 메서드
    public LinkedHashMap<String, Object> getMonthlyEmotionStatistics(String memberId, String month) {
        return emotionRepository.getMonthlyEmotionStatistics(memberId, month);
    }

    // 회원의 특정 월의 상위 3개의 감정을 조회하는 메서드
    public List<LinkedHashMap<String, Object>> getTopEmotionsByMonth(String memberId, String month) {
        return emotionRepository.getTopEmotionsByMonth(memberId, month);
    }

    // 회원의 시간별 감정을 조회하는 메서드
    public List<LinkedHashMap<String, Object>> getHourlyEmotion(String memberId) {
        return emotionRepository.getHourlyEmotion(memberId);
    }

}

