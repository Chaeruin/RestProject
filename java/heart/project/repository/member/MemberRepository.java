package heart.project.repository.member;

import heart.project.domain.Member;

import java.util.List;
import java.util.Optional;

public interface MemberRepository {

    // 멤버 정보를 저장하는 메서드
    Member save(Member member);

    // 멤버 정보를 수정하는 메서드
    void update(Integer id, MemberUpdateApiDto updateParam);

    // 주어진 ID에 해당하는 멤버를 조회하는 메서드
    Optional<Member> findById(Integer id);

    // 주어진 멤버 객체를 사용하여 멤버들을 조회하는 메서드
    List<Member> findAll(Member member);

    // 주어진 회원 ID에 해당하는 멤버를 조회하는 메서드
    Optional<Member> findByMemberId(String memberId);
}
