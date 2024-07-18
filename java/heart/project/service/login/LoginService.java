package heart.project.service.login;


import heart.project.domain.Member;
import heart.project.repository.member.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class LoginService {

    private final MemberRepository memberRepository;

    // 로그인을 수행하는 메서드
    public Member login(String loginId, String password) {
        Optional<Member> findMemberOptional = memberRepository.findByMemberId(loginId);
        if (findMemberOptional.isPresent()) {
            Member member = findMemberOptional.get();
            if (member.getPassword().equals(password)) {
                return member;
            }
        }
        return null; // 로그인 실패
    }
}