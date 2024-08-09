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

    @Override
    public Diary save(Diary diary) {
        diaryMapper.preSave(diary);
        diaryMapper.save(diary);
        return diaryMapper.findNewDiary();
    }

    @Override
    public void update(Integer diaryId, DiaryUpdateApiDto updateParam) {
        diaryMapper.update(diaryId, updateParam);
    }

    @Override
    public void delete(Integer diaryId) {
        diaryMapper.delete(diaryId);
    }

    @Override
    public Optional<Diary> findById(Integer diaryId) {
        return diaryMapper.findById(diaryId);
    }

    @Override
    public List<Diary> findAll(Diary diary) {
        return diaryMapper.findAll(diary);
    }

    @Override
    public List<Diary> findByMemberId(String memberId) {
        return diaryMapper.findByMemberId(memberId);
    }

    @Override
    public Optional<Diary> findByMemberIdAndWriteDate(String memberId, String writeDate) {
        return diaryMapper.findByMemberIdAndWriteDate(memberId, writeDate);
    }

    @Override
    public Optional<Diary> findLatestDiaryByMemberId(String memberId) {
        return diaryMapper.findLatestDiaryByMemberId(memberId);
    }
}
