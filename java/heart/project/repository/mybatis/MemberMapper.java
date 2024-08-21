package heart.project.repository.mybatis;

import heart.project.domain.Member;
import heart.project.repository.member.MemberUpdateApiDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Optional;

@Mapper
public interface MemberMapper {

    // 멤버 정보를 저장하는 메서드
    void save(Member member);

    // 방금 저장된 멤버를 조회하여 반환하는 메서드
    Member findNewMember();

    // 멤버 정보를 수정하는 메서드
    void update(@Param("id") Integer id, @Param("updateParam") MemberUpdateApiDto updateParam);

    // 주어진 ID에 해당하는 멤버를 조회하는 메서드
    Optional<Member> findById(Integer id);

    // 주어진 멤버 객체를 사용하여 멤버들을 조회하는 메서드
    List<Member> findAll(Member member);

    // 주어진 회원 ID에 해당하는 멤버를 조회하는 메서드
    Optional<Member> findByMemberId(String memberId);
}
