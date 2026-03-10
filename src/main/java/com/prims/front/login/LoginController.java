package com.prims.front.login;

import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;



@Controller
@RequestMapping("/login")  
public class LoginController {
	
	@Inject
    @Named("LoginService")
    private LoginService loginService;

    // LOGIN.jsp
	@RequestMapping(value = "/loginView", method = RequestMethod.POST)
    public String loginView(@RequestParam(value = "returnUrl", required = false) String returnUrl,
                            HttpServletRequest request, Model model) {
        // returnUrl 파라미터가 없으면 Referer 헤더에서 경로만 추출
        if (returnUrl == null || returnUrl.isEmpty()) {
            String referer = request.getHeader("Referer");
            if (referer != null && !referer.contains("/login")) {
                try {
                    java.net.URI uri = new java.net.URI(referer);
                    String path = uri.getPath();
                    String query = uri.getQuery();
                    returnUrl = path + (query != null ? "?" + query : "");
                } catch (Exception e) {
                    returnUrl = null;
                }
            }
        }
        model.addAttribute("returnUrl", returnUrl);
        return "front/login/login";
    }
	
	@RequestMapping(value = "/doLogin", method = RequestMethod.POST)
	public String doLogin(HttpSession session,
	                      @RequestParam Map<String, Object> paramMap,
	                      RedirectAttributes ra,
	                      HttpServletResponse response) {

	    String loginId = String.valueOf(paramMap.get("loginId"));
	    boolean remember = paramMap.containsKey("rememberId"); // 체크박스 체크 시 파라미터 존재

	    try {
	        Map<String, Object> ssnUser = loginService.getSelectUserOne(paramMap);

	        if (ssnUser != null && !ssnUser.isEmpty()) {
	            // 로그인 성공
	        	session.setAttribute("ssnUsrCd", ssnUser.get("usrCd").toString());
	        	session.setAttribute("ssnUsrNm", ssnUser.get("usrNm").toString());
	        	session.setAttribute("ssnLoginId", ssnUser.get("loginId").toString());
	            session.setAttribute("loginUser", ssnUser);
	            loginService.updateUserLoginInfo(ssnUser);

	            // 성공시에만 "저장" 처리
	            if (remember) {
	                Cookie idCookie = new Cookie("savedLoginId", loginId);
	                idCookie.setPath("/");
	                idCookie.setMaxAge(60 * 60 * 24 * 30); // 30일
	                response.addCookie(idCookie);
	            } else {
	                // 성공했지만 체크 안 했으면 기존 쿠키 삭	제
	                Cookie idCookie = new Cookie("savedLoginId", "");
	                idCookie.setPath("/");
	                idCookie.setMaxAge(0);
	                response.addCookie(idCookie);
	            }

	            // returnUrl이 있으면 해당 페이지로, 없으면 홈으로 (내부 경로만 허용)
	            String returnUrl = String.valueOf(paramMap.getOrDefault("returnUrl", ""));
	            if (returnUrl != null && !returnUrl.isEmpty() && !"null".equals(returnUrl)
	                    && returnUrl.startsWith("/") && !returnUrl.startsWith("//")) {
	                return "redirect:" + returnUrl;
	            }
	            return "redirect:/"; // 홈으로
	        }

	        // 로그인 실패: 쿠키는 "저장하지 않음" (기존 쿠키는 그대로 유지)
	        ra.addFlashAttribute("loginFailMsg", "아이디 또는 비밀번호가 일치하지 않습니다.");
	        return "redirect:/login/loginView";

	    } catch (Exception e) {
	        e.printStackTrace();
	        ra.addFlashAttribute("loginFailMsg", "시스템 오류가 발생했습니다. 관리자에게 문의해주세요.");
	        return "redirect:/login";
	    }
	}
	
	@RequestMapping(value = "/doLogout", method = RequestMethod.POST)
	public String logout(HttpSession session) {
	    // 로그인 세션 제거
	    session.invalidate(); // 전체 세션 초기화
	    return "redirect:/"; // 홈으로 이동
	}
	
	
	
}
