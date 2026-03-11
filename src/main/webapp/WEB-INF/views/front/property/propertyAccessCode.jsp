<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>

<style>
.access-wrap {
  min-height: calc(100vh - 72px - 200px);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
}
.access-box {
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 10px 40px rgba(0,0,0,0.1);
  padding: 50px 40px;
  max-width: 420px;
  width: 100%;
  text-align: center;
}
.access-icon {
  width: 80px;
  height: 80px;
  background: linear-gradient(135deg, #E8830C 0%, #ff9f43 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 24px;
  font-size: 36px;
  color: #fff;
}
.access-title {
  font-size: 22px;
  font-weight: 700;
  color: #1a2332;
  margin-bottom: 10px;
}
.access-desc {
  font-size: 14px;
  color: #888;
  margin-bottom: 30px;
  line-height: 1.6;
}
.access-input {
  width: 100%;
  padding: 16px 20px;
  font-size: 16px;
  border: 2px solid #e0e0e0;
  border-radius: 10px;
  text-align: center;
  letter-spacing: 3px;
  transition: border-color 0.3s;
}
.access-input:focus {
  outline: none;
  border-color: #E8830C;
}
.access-input.error {
  border-color: #e53935;
  animation: shake 0.3s;
}
@keyframes shake {
  0%, 100% { transform: translateX(0); }
  25% { transform: translateX(-5px); }
  75% { transform: translateX(5px); }
}
.access-btn {
  width: 100%;
  padding: 16px;
  font-size: 16px;
  font-weight: 600;
  color: #fff;
  background: linear-gradient(135deg, #E8830C 0%, #ff9f43 100%);
  border: none;
  border-radius: 10px;
  cursor: pointer;
  margin-top: 16px;
  transition: transform 0.2s, box-shadow 0.2s;
}
.access-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(232, 131, 12, 0.4);
}
.access-btn:active {
  transform: translateY(0);
}
.access-error {
  color: #e53935;
  font-size: 13px;
  margin-top: 12px;
  display: none;
}
.access-contact {
  margin-top: 30px;
  padding-top: 20px;
  border-top: 1px solid #f0f0f0;
  font-size: 13px;
  color: #888;
}
.access-contact a {
  color: #E8830C;
  font-weight: 600;
  text-decoration: none;
}
.access-back {
  display: inline-block;
  margin-top: 20px;
  font-size: 13px;
  color: #888;
  text-decoration: none;
}
.access-back:hover {
  color: #E8830C;
}
</style>

<div class="access-wrap">
  <div class="access-box">
    <div class="access-icon">
      <i class="fas fa-lock"></i>
    </div>
    <h2 class="access-title">비공개 페이지</h2>
    <p class="access-desc">
      이 페이지는 접근코드가 필요합니다.<br>
      담당자에게 받은 코드를 입력해주세요.
    </p>

    <input type="password" id="accessCode" class="access-input" 
           placeholder="접근코드 입력" maxlength="20" autocomplete="off"
           onkeypress="if(event.keyCode==13) fnVerify();" />

    <p class="access-error" id="errorMsg">접근코드가 일치하지 않습니다.</p>

    <button type="button" class="access-btn" onclick="fnVerify()">
      <i class="fas fa-unlock mr-2"></i>확인
    </button>

    <div class="access-contact">
      접근코드 문의: <a href="tel:032-327-1277">032-327-1277</a>
    </div>

    <a href="${ctx}/" class="access-back">
      <i class="fas fa-arrow-left mr-1"></i>홈으로 돌아가기
    </a>
  </div>
</div>

<input type="hidden" id="codeType" value="${codeType}" />

<script>
$(function() {
  $('#accessCode').focus();
});

function fnVerify() {
  var code = $('#accessCode').val().trim();
  if (!code) {
    $('#accessCode').addClass('error').focus();
    setTimeout(function() { $('#accessCode').removeClass('error'); }, 300);
    return;
  }

  var codeType = $('#codeType').val();

  $.ajax({
    url: ctx + '/property/verifyAccessCode',
    type: 'POST',
    data: { codeType: codeType, accessCode: code },
    dataType: 'json',
    success: function(res) {
      if (res.result === 'OK') {
        // 인증 성공 → 원래 페이지로 이동
        if (codeType === 'PROP_SEARCH') {
          location.href = ctx + '/property/viewPropertySearch';
        } else {
          location.href = ctx + '/property/viewPropertyList';
        }
      } else {
        $('#accessCode').addClass('error').val('').focus();
        $('#errorMsg').show();
        setTimeout(function() { 
          $('#accessCode').removeClass('error'); 
          $('#errorMsg').hide();
        }, 2000);
      }
    },
    error: function() {
      alert('오류가 발생했습니다.');
    }
  });
}
</script>

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>
</body>
</html>
