package heart.project.controller.member;

import heart.project.domain.Member;
import heart.project.service.member.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/members")
public class MemberController {

    private final MemberService memberService;

    // 회원 목록을 보여주는 엔드포인트
    @GetMapping
    public String members(@ModelAttribute("member") Member member, Model model) {
        List<Member> members = memberService.findMembers(member);
        model.addAttribute("members", members);
        return "member/members";
    }
}
