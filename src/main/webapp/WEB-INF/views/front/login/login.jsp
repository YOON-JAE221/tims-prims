<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>

<section class="login-section">
  <div class="login-box">

    <div class="login-box-logo">
      <img src="${ctx}/resources/front/img/logo/primus-logo.png" alt="프리머스 부동산" style="height:44px;">
    </div>
    <p class="login-box-sub">관리자 로그인</p>

    <form id="loginForm" method="POST" action="${ctx}/login/doLogin" novalidate onsubmit="return fnLogin();">
      <input type="hidden" name="returnUrl" id="returnUrlInput" value="" />

      <div class="login-field">
        <label for="loginId">아이디</label>
        <input type="text" id="loginId" name="loginId" placeholder="아이디를 입력해 주세요."
               value="${not empty cookie.savedLoginId.value ? cookie.savedLoginId.value : ''}">
      </div>

      <div class="login-field">
        <label for="loginPw">비밀번호</label>
        <input type="password" id="loginPw" name="loginPw" placeholder="비밀번호를 입력해 주세요.">
      </div>

      <div class="login-options">
        <label class="login-remember">
          <input type="checkbox" id="rememberId" name="rememberId"
                 <c:if test="${not empty cookie.savedLoginId.value}">checked</c:if>>
          아이디 저장
        </label>
      </div>

      <button type="submit" class="login-btn">로그인</button>
    </form>

    <a href="/" class="login-home">← 홈으로 돌아가기</a>

  </div>
</section>

<script>
  $(document).ready(function () {
    var msg = "${loginFailMsg}";
    if (msg && msg.trim() !== "") {
      alert(msg);
    }

    // returnUrl 설정: 서버 전달값 → referrer 순서로 체크
    var returnUrlInput = document.getElementById('returnUrlInput');
    var serverReturnUrl = "${returnUrl}";

    if (serverReturnUrl && serverReturnUrl.trim() !== '' && serverReturnUrl !== 'null') {
      // 서버에서 전달된 값 사용
      returnUrlInput.value = serverReturnUrl;
    } else if (document.referrer) {
      // 이전 페이지(referrer)에서 가져오기
      try {
        var refUrl = new URL(document.referrer);
        // 같은 사이트이고 로그인 페이지가 아닌 경우에만
        if (refUrl.hostname === location.hostname && !refUrl.pathname.includes('/login')) {
          returnUrlInput.value = refUrl.pathname + refUrl.search;
        }
      } catch(e) {}
    }
  });

  function fnLogin() {
    if ($("#loginId").val().trim() === "") {
      alert("아이디를 입력해주세요.");
      $("#loginId").focus();
      return false;
    }
    if ($("#loginPw").val().trim() === "") {
      alert("비밀번호를 입력해주세요.");
      $("#loginPw").focus();
      return false;
    }
    return true;
  }
</script>

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>

</body>
</html>
