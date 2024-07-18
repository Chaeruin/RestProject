package heart.project.repository.mybatis;

import heart.project.domain.Member;
import heart.project.repository.member.MemberRepository;
import heart.project.repository.member.MemberUpdateApiDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class MyBatisMemberRepository implements MemberRepository {

    private final MemberMapper memberMapper;

    @Override
    public Member save(Member member) {
        memberMapper.save(member);
        return memberMapper.findNewMember();
    }

    @Override
    public void update(Integer id, MemberUpdateApiDto updateParam) {
        memberMapper.update(id, updateParam);
    }

    @Override
    public Optional<Member> findById(Integer id) {
        return memberMapper.findById(id);
    }

    @Override
    public List<Member> findAll(Member member) {
        return memberMapper.findAll(member);
    }

    @Override
    public Optional<Member> findByMemberId(String memberId) {
        return memberMapper.findByMemberId(memberId);
    }
}
