package heart.project.repository.mybatis;

import heart.project.domain.Member;
import heart.project.repository.member.MemberUpdateApiDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Optional;

@Mapper
public interface MemberMapper {

    void save(Member member);

    Member findNewMember();

    void update(@Param("id") Integer id, @Param("updateParam") MemberUpdateApiDto updateParam);

    Optional<Member> findById(Integer id);

    List<Member> findAll(Member member);

    Optional<Member> findByMemberId(String memberId);
}
