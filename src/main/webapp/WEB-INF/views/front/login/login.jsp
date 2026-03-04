<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>

  <main id="main">

    <div class="breadcrumbs d-flex align-items-center">
      <div class="container position-relative d-flex flex-column align-items-center">
        <h2>LOGIN</h2>
      </div>
    </div>

	<section id="loginMng" class="loginMng">
	    <div class="container">
	      <div class="row justify-content-center">
	        <div class="col-12 col-sm-10 col-md-7 col-lg-5">
	
	          <div class="login-card">
	            <div class="login-title">로그인</div>
	
	            <form id="loginForm" method="POST" action="/login/doLogin" novalidate onsubmit="return login();">
	              <input type="hidden" name="returnUrl" value="${returnUrl}" />
	              <div class="form-group">
<%-- 	                <input type="text" id="loginId" name="loginId" class="form-control" placeholder="아이디 입력" value="${cookie.savedLoginId.value}"> --%>
	                <input type="text" id="loginId" name="loginId" class="form-control" placeholder="아이디 입력" value="admin">
	              </div>
	
	              <div class="form-group">
	                <input type="password" id="loginPw" name="loginPw" class="form-control" placeholder="비밀번호 입력" value="1">
	              </div>
	              
	              <div class="login-save">
				    <label class="save-check">
				    <input type="checkbox" id="rememberId" name="rememberId" <c:if test="${not empty cookie.savedLoginId.value}">checked</c:if>>
				      <span class="box" aria-hidden="true"></span>
				      <span class="txt">아이디 저장</span>
				    </label>
				  </div>
	
	              <button type="submit" class="btn-login">로그인</button>
	            </form>
	          </div>
	
	        </div>
	      </div>
	    </div>
	</section>
		

  </main><!-- End #main -->

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>

	<script>
		$(document).ready(function () {
			const msg = "${loginFailMsg}";
		    if (msg && msg.trim() != "") {//로그인 실패시
		      alert(msg);
		    }
		});
		
		function login() {
			if ($("#loginId").val().trim() == "") {
		   		alert("아이디를 입력해주세요.");
		      	$("#loginId").focus();
		      	return false;
		    }
		    if ($("#loginPw").val().trim() == "") {
		      	alert("비밀번호를 입력해주세요.");
		      	$("#loginPw").focus();
		      	return false;
		    }
		    return true; // 통과 → submit 진행
		}
	</script>



