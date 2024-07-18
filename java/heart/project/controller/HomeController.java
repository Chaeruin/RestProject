package heart.project.controller;

import heart.project.service.member.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@RequiredArgsConstructor
public class HomeController {

    private final MemberService memberService;

    // 기본 페이지를 보여주는 엔드포인트
    @GetMapping("/")
    public String home(){
        return "springhome";
    }
}