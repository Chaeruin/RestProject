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

    // 멤버 정보를 저장하는 메서드
    @Override
    public Member save(Member member) {
        memberMapper.save(member);
        return memberMapper.findNewMember();
    }

    // 멤버 정보를 수정하는 메서드
    @Override
    public void update(Integer id, MemberUpdateApiDto updateParam) {
        memberMapper.update(id, updateParam);
    }

    // 주어진 ID에 해당하는 멤버를 조회하는 메서드
    @Override
    public Optional<Member> findById(Integer id) {
        return memberMapper.findById(id);
    }

    // 주어진 멤버 객체를 사용하여 멤버들을 조회하는 메서드
    @Override
    public List<Member> findAll(Member member) {
        return memberMapper.findAll(member);
    }

    // 주어진 회원 ID에 해당하는 멤버를 조회하는 메서드
    @Override
    public Optional<Member> findByMemberId(String memberId) {
        return memberMapper.findByMemberId(memberId);
    }
}
