package heart.project.repository.mybatis;

import heart.project.domain.Diary;
import heart.project.repository.diary.DiaryRepository;
import heart.project.repository.diary.DiaryUpdateApiDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class MyBatisDiaryRepository implements DiaryRepository {

    private final DiaryMapper diaryMapper;

    // 일기를 저장하는 메서드
    @Override
    public Diary save(Diary diary) {
        diaryMapper.preSave(diary);
        diaryMapper.save(diary);
        return diaryMapper.findNewDiary();
    }

    // 일기를 수정하는 메서드
    @Override
    public void update(Integer diaryId, DiaryUpdateApiDto updateParam) {
        diaryMapper.update(diaryId, updateParam);
    }

    // 일기를 삭제하는 메서드
    @Override
    public void delete(Integer diaryId) {
        diaryMapper.delete(diaryId);
    }

    // 주어진 일기 ID에 해당하는 일기를 찾아 반환하는 메서드
    @Override
    public Optional<Diary> findById(Integer diaryId) {
        return diaryMapper.findById(diaryId);
    }

    // 주어진 일기 정보에 해당하는 모든 일기를 반환하는 메서드
    @Override
    public List<Diary> findAll(Diary diary) {
        return diaryMapper.findAll(diary);
    }

    // 주어진 회원 ID에 해당하는 모든 일기를 반환하는 메서드
    @Override
    public List<Diary> findByMemberId(String memberId) {
        return diaryMapper.findByMemberId(memberId);
    }

    // 주어진 회원 ID와 작성 날짜에 해당하는 일기를 반환하는 메서드
    @Override
    public Optional<Diary> findByMemberIdAndWriteDate(String memberId, String writeDate) {
        return diaryMapper.findByMemberIdAndWriteDate(memberId, writeDate);
    }

    // 주어진 회원 ID에 해당하는 가장 최근 작성한 일기를 반환하는 메서드
    @Override
    public Optional<Diary> findLatestDiaryByMemberId(String memberId) {
        return diaryMapper.findLatestDiaryByMemberId(memberId);
    }
}
