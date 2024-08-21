package heart.project.repository.mybatis;

import heart.project.domain.Diary;
import heart.project.repository.diary.DiaryUpdateApiDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Optional;

@Mapper
public interface DiaryMapper {

    // 동일한 회원과 날짜에 공개 일기가 있으면 비공개로 변경하여 중복 저장을 방지하는 메서드
    void preSave(Diary diary);

    // 일기를 저장하는 메서드
    void save(Diary diary);

    // 방금 저장된 일기를 조회하여 반환하는 메서드
    Diary findNewDiary();

    // 일기를 수정하는 메서드
    void update(@Param("diaryId") Integer diaryId, @Param("updateParam") DiaryUpdateApiDto updateParam);

    // 일기를 삭제하는 메서드
    void delete(Integer diaryId);

    // 주어진 일기 ID에 해당하는 일기를 찾아 반환하는 메서드
    Optional<Diary> findById(Integer diaryId);

    // 주어진 일기 정보에 해당하는 모든 일기를 반환하는 메서드
    List<Diary> findAll(Diary diary);

    // 주어진 회원 ID에 해당하는 모든 일기를 반환하는 메서드
    List<Diary> findByMemberId(String memberId);

    // 주어진 회원 ID와 작성 날짜에 해당하는 일기를 반환하는 메서드
    Optional<Diary> findByMemberIdAndWriteDate(@Param("memberId") String memberId, @Param("writeDate") String writeDate);

    // 주어진 회원 ID에 해당하는 가장 최근 작성한 일기를 반환하는 메서드
    Optional<Diary> findLatestDiaryByMemberId(@Param("memberId") String memberId);
}
