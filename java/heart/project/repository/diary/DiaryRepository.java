package heart.project.repository.diary;

import heart.project.domain.Diary;

import java.util.List;
import java.util.Optional;

public interface DiaryRepository {

    // 일기를 저장하는 메서드
    Diary save(Diary diary);

    // 일기를 수정하는 메서드
    void update(Integer diaryId, DiaryUpdateApiDto updateParam);

    // 일기를 삭제하는 메서드
    void delete(Integer diaryId);

    // 주어진 일기 ID에 해당하는 일기를 찾아 반환하는 메서드
    Optional<Diary> findById(Integer diaryId);

    // 주어진 일기 정보에 해당하는 모든 일기를 반환하는 메서드
    List<Diary> findAll(Diary diary);

    // 주어진 회원 ID에 해당하는 모든 일기를 반환하는 메서드
    List<Diary> findByMemberId(String memberId);

    // 주어진 회원 ID와 작성 날짜에 해당하는 일기를 반환하는 메서드
    Optional<Diary> findByMemberIdAndWriteDate(String memberId, String writeDate);

    // 주어진 회원 ID에 해당하는 가장 최근 작성한 일기를 반환하는 메서드
    Optional<Diary> findLatestDiaryByMemberId(String memberId);
}
