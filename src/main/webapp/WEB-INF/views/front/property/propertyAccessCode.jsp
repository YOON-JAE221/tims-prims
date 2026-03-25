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
      <div class="access-icon">🏠</div>
      <div class="access-title">매물 접근코드</div>
      <div class="access-desc">매물 페이지는 접근코드가 필요합니다.<br>안내받은 코드를 입력해 주세요.</div>

      <input type="hidden" id="codeType" value="${codeType}" />
      <input type="hidden" id="returnUrl" value="${returnUrl}" />

      <div class="access-input-wrap">
        <input type="password" id="accessCode" class="access-input"
               placeholder="접근코드" maxlength="20" autocomplete="off"
               onkeydown="if(event.keyCode===13) fnVerify()" />
      </div>
      <div class="access-error" id="errorMsg">접근코드가 일치하지 않습니다.</div>
      <button type="button" class="access-btn" id="verifyBtn" onclick="fnVerify()">확인</button>

      <div class="access-back">
        <a href="${ctx}/">← 메인으로 돌아가기</a>
      </div>
    </div>

    <div class="access-footer">&copy; 2026 프리머스 부동산. All rights reserved.</div>
  </div>

  <script>
    function fnVerify() {
      var code = $('#accessCode').val().trim();
      var codeType = $('#codeType').val();

      if (!code) {
        $('#accessCode').addClass('error').focus();
        setTimeout(function() { $('#accessCode').removeClass('error'); }, 500);
        return;
      }

      $('#verifyBtn').prop('disabled', true).text('확인 중...');

      $.ajax({
        url: '${ctx}/property/verifyAccessCode',
        type: 'POST',
        data: { codeType: codeType, accessCode: code },
        dataType: 'json',
        success: function(res) {
          if (res.result === 'OK') {
            // 인증 성공 → 원래 페이지로
            var returnUrl = $('#returnUrl').val();
            if (returnUrl === 'SEARCH') {
              location.href = '${ctx}/property/viewPropertySearch';
            } else {
              location.href = '${ctx}/property/viewPropertyList';
            }
          } else {
            $('#accessCode').addClass('error').val('').focus();
            $('#errorMsg').show();
            setTimeout(function() {
              $('#accessCode').removeClass('error');
              $('#errorMsg').fadeOut(300);
            }, 2000);
            $('#verifyBtn').prop('disabled', false).text('확인');
          }
        },
        error: function() {
          alert('오류가 발생했습니다.');
          $('#verifyBtn').prop('disabled', false).text('확인');
        }
      });
    }

    $(function() {
      $('#accessCode').focus();
    });
  </script>
</body>
</html>
