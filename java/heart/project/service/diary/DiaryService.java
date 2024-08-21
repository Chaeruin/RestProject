package heart.project.service.diary;

import heart.project.domain.Diary;
import heart.project.repository.diary.DiaryRepository;
import heart.project.repository.diary.DiaryUpdateApiDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class DiaryService {

    private final DiaryRepository diaryRepository;

    // 일기를 저장하는 메서드
    public Diary save(Diary diary) {
        return diaryRepository.save(diary);
    }

    // 일기를 수정하는 메서드
    public void update(Integer diaryId, DiaryUpdateApiDto updateParam) {
        diaryRepository.update(diaryId, updateParam);
    }

    // 일기를 삭제하는 메서드
    public void delete(Integer diaryId) {
        diaryRepository.delete(diaryId);
    }

    // 주어진 일기 ID에 해당하는 일기를 찾아 반환하는 메서드
    public Optional<Diary> findById(Integer diaryId) {
        return diaryRepository.findById(diaryId);
    }

    // 주어진 일기 정보에 해당하는 모든 일기를 반환하는 메서드
    public List<Diary> findDiaries(Diary diary) {
        return diaryRepository.findAll(diary);
    }

    // 주어진 회원 ID에 해당하는 모든 일기를 반환하는 메서드
    public List<Diary> findByMemberId(String memberId) {
        return diaryRepository.findByMemberId(memberId);
    }

    // 주어진 회원 ID와 작성 날짜에 해당하는 일기를 반환하는 메서드
    public Optional<Diary> findByMemberIdAndWriteDate(String memberId, String writeDate) {
        return diaryRepository.findByMemberIdAndWriteDate(memberId, writeDate);
    }

    // 주어진 회원 ID에 해당하는 가장 최근 작성한 일기를 반환하는 메서드
    public Optional<Diary> findLatestDiaryByMemberId(String memberId) {
        return diaryRepository.findLatestDiaryByMemberId(memberId);
    }
}

