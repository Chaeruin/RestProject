package heart.project.service.member;

import heart.project.domain.Member;
import heart.project.repository.member.MemberRepository;
import heart.project.repository.member.MemberUpdateApiDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class MemberService {

    private final MemberRepository memberRepository;

    // 멤버 정보를 저장하는 메서드
    @Transactional
    public Member save(Member member) {
        // 아이디 중복 확인
        Optional<Member> existingMemberId = memberRepository.findByMemberId(member.getMemberId());
        if (existingMemberId.isPresent()) {
            // 중복된 아이디가 이미 존재하는 경우 처리
            throw new IllegalArgumentException("이미 존재하는 아이디입니다.");
        }

        // 중복된 아이디가 없는 경우 멤버 저장
        return memberRepository.save(member);
    }

    // 멤버 정보를 수정하는 메서드
    public void update(Integer id, MemberUpdateApiDto updateParam) {
        memberRepository.update(id, updateParam);
    }

    // 주어진 ID에 해당하는 멤버를 조회하는 메서드
    public Optional<Member> findById(Integer id) {
        return memberRepository.findById(id);
    }

    // 주어진 멤버 객체를 사용하여 멤버들을 조회하는 메서드
    public List<Member> findMembers(Member member) {
        return memberRepository.findAll(member);
    }

    // 주어진 회원 ID에 해당하는 멤버를 조회하는 메서드
    public Optional<Member> findByMemberId(String memberId) {
        return memberRepository.findByMemberId(memberId);
    }

    // 아이디 중복 확인 메서드
    public boolean isMemberIdExists(String memberId) {
        return memberRepository.findByMemberId(memberId).isPresent();
    }
}

