<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>

<section class="login-section">
  <div class="login-box">

    <div class="login-box-logo">
      <img src="${ctx}/resources/front/img/logo/primus-logo.png" alt="프리머스 부동산" style="height:44px;">
    </div>
    <p class="login-box-sub">관리자 로그인</p>

    <form id="loginForm" method="POST" action="${ctx}/login/doLogin" novalidate onsubmit="return fnLogin();">
      <input type="hidden" name="returnUrl" value="${returnUrl}" />

      <div class="login-field">
        <label for="loginId">아이디</label>
        <input type="text" id="loginId" name="loginId" placeholder="아이디를 입력해 주세요."
               value="${not empty cookie.savedLoginId.value ? cookie.savedLoginId.value : 'admin'}">
      </div>

      <div class="login-field">
        <label for="loginPw">비밀번호</label>
        <input type="password" id="loginPw" name="loginPw" placeholder="비밀번호를 입력해 주세요." value="1">
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
