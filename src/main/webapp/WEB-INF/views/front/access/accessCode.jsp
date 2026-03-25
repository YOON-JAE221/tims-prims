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
  <link rel="stylesheet" href="${ctx}/resources/front/css/common.css">
  <script src="${ctx}/resources/common/util/js/jquery-4.0.0.min.js" charset="UTF-8"></script>
</head>
<body class="access-body">
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
