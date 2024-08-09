package heart.project.repository.mybatis;

import heart.project.domain.Diary;
import heart.project.repository.diary.DiaryUpdateApiDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Optional;

@Mapper
public interface DiaryMapper {

    void preSave(Diary diary);

    void save(Diary diary);

    Diary findNewDiary();

    void update(@Param("diaryId") Integer diaryId, @Param("updateParam") DiaryUpdateApiDto updateParam);

    void delete(Integer diaryId);

    Optional<Diary> findById(Integer diaryId);

    List<Diary> findAll(Diary diary);

    List<Diary> findByMemberId(String memberId);

    Optional<Diary> findByMemberIdAndWriteDate(@Param("memberId") String memberId, @Param("writeDate") String writeDate);

    Optional<Diary> findLatestDiaryByMemberId(@Param("memberId") String memberId);
}
