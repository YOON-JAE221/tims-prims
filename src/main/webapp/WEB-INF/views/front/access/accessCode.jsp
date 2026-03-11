<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">
  <title>프리머스 부동산</title>
  <link rel="icon" sizes="any" href="${ctx}/resources/front/img/favicon/favicon.ico?v=20260305">
  <link href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" rel="stylesheet">
  <script src="${ctx}/resources/common/util/js/jquery-4.0.0.min.js" charset="UTF-8"></script>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: 'Pretendard', sans-serif;
      background: linear-gradient(135deg, #1B2A4A 0%, #2D4A7A 100%);
      min-height: 100vh;
      display: flex; align-items: center; justify-content: center;
    }
    .access-wrap {
      text-align: center; padding: 20px;
    }
    .access-logo {
      display: flex; align-items: center; justify-content: center; gap: 10px;
      margin-bottom: 40px;
    }
    .access-logo img { height: 44px; }
    .access-logo-text {
      font-size: 22px; font-weight: 800; color: #fff;
    }
    .access-logo-text em { color: #E8830C; font-style: normal; }
    .access-card {
      background: #fff; border-radius: 20px; padding: 48px 40px;
      box-shadow: 0 20px 60px rgba(0,0,0,0.3);
      width: 420px; max-width: 100%;
    }
    .access-icon {
      width: 56px; height: 56px; border-radius: 14px;
      background: linear-gradient(135deg, #E8830C, #F5A623);
      display: flex; align-items: center; justify-content: center;
      margin: 0 auto 20px; font-size: 26px;
    }
    .access-title {
      font-size: 20px; font-weight: 800; color: #1B2A4A;
      margin-bottom: 8px;
    }
    .access-desc {
      font-size: 14px; color: #9CA3AF; margin-bottom: 32px;
      line-height: 1.6;
    }
    .access-input-wrap {
      position: relative; margin-bottom: 16px;
    }
    .access-input {
      width: 100%; padding: 14px 18px; font-size: 16px;
      border: 2px solid #E5E7EB; border-radius: 12px;
      font-family: inherit; outline: none;
      text-align: center; letter-spacing: 4px; font-weight: 700;
      color: #1B2A4A; transition: border-color 0.2s;
    }
    .access-input:focus { border-color: #E8830C; }
    .access-input.error { border-color: #dc3545; animation: shake 0.4s; }
    @keyframes shake {
      0%, 100% { transform: translateX(0); }
      25% { transform: translateX(-8px); }
      50% { transform: translateX(8px); }
      75% { transform: translateX(-4px); }
    }
    .access-error {
      font-size: 13px; color: #dc3545; margin-bottom: 16px;
      display: none;
    }
    .access-btn {
      width: 100%; padding: 14px; font-size: 15px; font-weight: 700;
      background: #1B2A4A; color: #fff; border: none; border-radius: 12px;
      cursor: pointer; font-family: inherit; transition: background 0.2s;
    }
    .access-btn:hover { background: #2D4A7A; }
    .access-btn:disabled { background: #9CA3AF; cursor: not-allowed; }
    .access-footer {
      margin-top: 32px; font-size: 12px; color: rgba(255,255,255,0.5);
    }

    @media (max-width: 480px) {
      .access-card { padding: 36px 24px; }
      .access-logo-text { font-size: 18px; }
    }
  </style>
</head>
<body>
  <div class="access-wrap">
    <div class="access-logo">
      <img src="${ctx}/resources/front/img/logo/primus-logo-white.png" alt="프리머스 부동산" onerror="this.style.display='none'">
      <div class="access-logo-text"><em>프리머스</em> 부동산</div>
    </div>

    <div class="access-card">
      <div class="access-icon">🔒</div>
      <div class="access-title">접속코드 입력</div>
      <div class="access-desc">이 사이트는 접속코드가 필요합니다.<br>안내받은 코드를 입력해 주세요.</div>

      <div class="access-input-wrap">
        <input type="text" id="accessCode" class="access-input"
               placeholder="접속코드" maxlength="20" autocomplete="off"
               onkeydown="if(event.keyCode===13) fnVerify()" />
      </div>
      <div class="access-error" id="errorMsg">접속코드가 올바르지 않습니다.</div>
      <button type="button" class="access-btn" id="verifyBtn" onclick="fnVerify()">입장하기</button>
    </div>

    <div class="access-footer">&copy; 2026 프리머스 부동산. All rights reserved.</div>
  </div>

  <script>
    function fnVerify() {
      var code = $('#accessCode').val().trim();
      if (!code) {
        $('#accessCode').addClass('error').focus();
        setTimeout(function() { $('#accessCode').removeClass('error'); }, 500);
        return;
      }

      $('#verifyBtn').prop('disabled', true).text('확인 중...');

      $.ajax({
        url: '${ctx}/verifyAccessCode',
        type: 'POST',
        data: { code: code },
        dataType: 'json',
        success: function(res) {
          if (res.result === 'OK') {
            location.href = '${ctx}/';
          } else {
            $('#accessCode').addClass('error').val('').focus();
            $('#errorMsg').show();
            setTimeout(function() {
              $('#accessCode').removeClass('error');
              $('#errorMsg').fadeOut(300);
            }, 2000);
            $('#verifyBtn').prop('disabled', false).text('입장하기');
          }
        },
        error: function() {
          alert('오류가 발생했습니다.');
          $('#verifyBtn').prop('disabled', false).text('입장하기');
        }
      });
    }

    // 포커스
    $(function() {
      $('#accessCode').focus();
    });
  </script>
</body>
</html>
