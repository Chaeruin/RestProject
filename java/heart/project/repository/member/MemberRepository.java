package heart.project.repository.member;

import heart.project.domain.Member;

import java.util.List;
import java.util.Optional;

public interface MemberRepository {

    Member save(Member member);

    void update(Integer id, MemberUpdateApiDto updateParam);

    Optional<Member> findById(Integer id);

    List<Member> findAll(Member member);

    Optional<Member> findByMemberId(String memberId);
}
