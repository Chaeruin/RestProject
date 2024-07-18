package heart.project.controller.login;

import heart.project.domain.Member;
import heart.project.service.login.LoginService;
import heart.project.service.member.MemberService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api")
public class LoginApiController {

    private final LoginService loginService;
    private final MemberService memberService;

    /**
     * 로그인을 처리하는 엔드포인트
     */
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody @Valid LoginApiForm form, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            return ResponseEntity.badRequest().body("입력값이 올바르지 않습니다");
        }

        Optional<Member> existingMemberOptional = memberService.findByMemberId(form.getLoginId());
        if (!existingMemberOptional.isPresent()) {
            // 아이디가 맞지 않는 경우
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("아이디가 틀립니다");
        }

        Member existingMember = existingMemberOptional.get();
        if (!existingMember.getPassword().equals(form.getPassword())) {
            // 아이디는 맞는데 비밀번호가 다른 경우
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("비밀번호가 다릅니다");
        }

        // 로그인 성공 시에는 사용자 정보와 "로그인 성공" 메시지를 함께 반환
        Map<String, Object> responseData = new HashMap<>();
        responseData.put("message", "로그인 성공");
        responseData.put("user", existingMember);
        return ResponseEntity.ok(responseData);
    }
}
