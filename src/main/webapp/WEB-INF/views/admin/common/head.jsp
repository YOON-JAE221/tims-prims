<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.prims.common.constant.Constant" %>
<%@ include file="/WEB-INF/views/common/taglibs.jsp" %>

<!DOCTYPE html>
<!--
This is a starter template page. Use this page to start your new project from
scratch. This page gets rid of all links and provides the needed markup only.
-->
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>프리머스 부동산 관리자</title>
  
  <!-- 모바일 접근 차단 -->
  <script>
  (function() {
    var isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) || window.innerWidth < 1024;
    if (isMobile) {
      document.write('\
        <!DOCTYPE html>\
        <html lang="ko">\
        <head>\
          <meta charset="utf-8">\
          <meta name="viewport" content="width=device-width, initial-scale=1">\
          <title>접근 불가</title>\
          <style>\
            * { margin:0; padding:0; box-sizing:border-box; }\
            body { font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,sans-serif; background:#f5f5f5; min-height:100vh; display:flex; align-items:center; justify-content:center; padding:20px; }\
            .block-wrap { background:#fff; border-radius:16px; padding:40px 30px; text-align:center; max-width:360px; box-shadow:0 4px 20px rgba(0,0,0,0.08); }\
            .block-icon { font-size:60px; margin-bottom:20px; }\
            .block-title { font-size:20px; font-weight:700; color:#1a2332; margin-bottom:12px; }\
            .block-msg { font-size:14px; color:#666; line-height:1.6; margin-bottom:24px; }\
            .block-btn { display:inline-block; padding:12px 28px; background:#E8830C; color:#fff; border-radius:8px; text-decoration:none; font-weight:600; font-size:14px; }\
          </style>\
        </head>\
        <body>\
          <div class="block-wrap">\
            <div class="block-icon">🖥️</div>\
            <div class="block-title">PC에서 접속해주세요</div>\
            <div class="block-msg">관리자 페이지는 PC 환경에서만<br>이용하실 수 있습니다.</div>\
            <a href="/" class="block-btn">메인으로 이동</a>\
          </div>\
        </body>\
        </html>\
      ');
      document.close();
      throw new Error('Mobile blocked');
    }
  })();
  </script>

  <c:set var="ctx" value="${pageContext.request.contextPath}" />
  
  <!-- Favicons -->
  <link rel="icon" sizes="any" href="${ctx}/resources/front/img/favicon/favicon.ico?v=20260305">
  <link rel="icon" type="image/png" sizes="16x16" href="${ctx}/resources/front/img/favicon/favicon-16x16.png?v=20260305">
  <link rel="icon" type="image/png" sizes="32x32" href="${ctx}/resources/front/img/favicon/favicon-32x32.png?v=20260305">

  	<!-- Font Awesome Icons - 제거 (약 400KB 절약) -->
  	<!-- <link rel="stylesheet" href="${ctx}/resources/admin/plugins/fontawesome-free/css/all.min.css"> -->
  	<!-- Theme style -->
  	<link rel="stylesheet" href="${ctx}/resources/admin/dist/css/adminlte.min.css">
  
	  <!-- jQuery -->
	<script src="${ctx}/resources/admin/plugins/jquery/jquery.min.js" charset="UTF-8"></script>
	<!-- Bootstrap 4 -->
	<script src="${ctx}/resources/admin/plugins/bootstrap/js/bootstrap.bundle.min.js" charset="UTF-8"></script>
	<!-- AdminLTE App -->
	<script src="${ctx}/resources/admin/dist/js/adminlte.min.js" charset="UTF-8"></script>
	
	
	<!-- Tabulator (CDN / Bootstrap4 theme) -->
	<link rel="stylesheet" href="${ctx}/resources/common/tabulator/css/tabulator_bootstrap4.min.css"/>
	<script src="${ctx}/resources/common/tabulator/js/tabulator.min.js" charset="UTF-8"></script>
	
	<!-- summernote - 필요한 페이지에서 개별 로드 -->
	<!--
	<link rel="stylesheet" href="${ctx}/resources/common/summernote/css/admin/summernote-bs4.min.css" />
	<script src="${ctx}/resources/common/summernote/js/admin/summernote-bs4.min.js" charset="UTF-8"></script>
	<script src="${ctx}/resources/common/summernote/js/summernote-ko-KR.min.js" charset="UTF-8"></script>
	<script src="${ctx}/resources/common/summernote/js/summernote-editor-common.js" charset="UTF-8"></script>
	-->
	
	<!-- common -->
	<link rel="stylesheet" href="${ctx}/resources/admin/dist/css/common.css">
	<script src="${ctx}/resources/common/util/js/tabulatorGrid.js" charset="UTF-8"></script>
	<script src="${ctx}/resources/common/util/js/common.js?v=202503100001" charset="UTF-8"></script>
</head>

<body class="hold-transition layout-top-nav">

<div class="wrapper">

  <!-- Navbar -->
  <nav class="main-header navbar navbar-expand-md navbar-light navbar-white">
    <div class="container">
        <a href="${ctx}/admin/viewAdminMain" class="navbar-brand">
          <span class="brand-text font-weight-bold" style="font-size:18px;color:#1B2A4A;">
            <span style="color:#E8830C;">프리머스</span> 부동산 관리자
          </span>
        </a>

      <button class="navbar-toggler order-1" type="button" data-toggle="collapse" data-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>

      <div class="collapse navbar-collapse order-3" id="navbarCollapse">
        <ul class="navbar-nav">
          <li class="nav-item">
            <a href="/" class="nav-link">Home</a>
          </li>
          <li class="nav-item dropdown">
            <a id="dropdownSubMenu2" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" class="nav-link dropdown-toggle">매물관리</a>
            <ul aria-labelledby="dropdownSubMenu2" class="dropdown-menu border-0 shadow">
              <li><a href="${ctx}/propCatMng/viewPropCatMng" class="dropdown-item">카테고리관리</a></li>
              <li><a href="${ctx}/propertyMng/viewPropertyMng" class="dropdown-item">매물관리</a></li>
            </ul>
          </li>
          <li class="nav-item dropdown">
            <a id="dropdownSubMenu3" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" class="nav-link dropdown-toggle">고객지원</a>
            <ul aria-labelledby="dropdownSubMenu3" class="dropdown-menu border-0 shadow">
              <li><a href="javascript:fnGoMng('<%=Constant.BRD_CD_NOTICE%>')" class="dropdown-item">공지사항</a></li>
              <li><a href="javascript:fnGoMng('<%=Constant.BRD_CD_FAQ%>')" class="dropdown-item">FAQ</a></li>
              <li><a href="${ctx}/bbsComQnaMng/viewBbsComQnaMng" class="dropdown-item">문의게시판</a></li>
            </ul>
          </li>
          <li class="nav-item dropdown">
            <a id="dropdownSubMenu5" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" class="nav-link dropdown-toggle">전시관리</a>
            <ul aria-labelledby="dropdownSubMenu5" class="dropdown-menu border-0 shadow">
              <li><a href="${ctx}/popMng/viewPopMng" class="dropdown-item">팝업공지관리</a></li>
              <li><a href="${ctx}/newsMng/viewNewsMng" class="dropdown-item">부동산뉴스관리</a></li>
            </ul>
          </li>
          <li class="nav-item dropdown">
            <a id="dropdownSubMenu4" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" class="nav-link dropdown-toggle">시스템관리</a>
            <ul aria-labelledby="dropdownSubMenu4" class="dropdown-menu border-0 shadow">
              <li><a href="${ctx}/sysMenuMng/viewSysMenuMng" class="dropdown-item">메뉴관리</a></li>
              <li><a href="${ctx}/usrMng/viewUsrMng" class="dropdown-item">회원관리</a></li>
              <li><a href="${ctx}/batMng/viewBatMng" class="dropdown-item">배치관리</a></li>
              <li><a href="${ctx}/bbsBrdMng/viewBbsBrdMng" class="dropdown-item">게시판관리</a></li>
              <li><a href="${ctx}/sendLogMng/viewSendLogMng" class="dropdown-item">발송내역</a></li>
              <li><a href="${ctx}/accessCodeMng/viewAccessCodeMng" class="dropdown-item">환경설정</a></li>
            </ul>
          </li>
          <li class="nav-item">
            <a href="javascript:fnOpenPwdModal()" class="nav-link">비밀번호변경</a>
          </li>
          <li class="nav-item">
            <a href="${ctx}/login/doLogout" class="nav-link">LOGOUT</a>
          </li>
        </ul>
      </div>

    </div>
  </nav>
  <!-- /.navbar -->

	 <!-- BO 메뉴 이동용 -->
	<form id="goMngForm" method="post">
	  <input type="hidden" name="brdCd" id="mngBrdCd" />
	</form>

  <!-- 비밀번호 변경 모달 -->
  <div class="modal fade" id="pwdChangeModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-sm" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">비밀번호 변경</h5>
          <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label>현재 비밀번호 <span class="text-danger">*</span></label>
            <input type="password" id="currentPwd" class="form-control form-control-sm" />
          </div>
          <div class="form-group">
            <label>새 비밀번호 <span class="text-danger">*</span></label>
            <input type="password" id="newPwd" class="form-control form-control-sm" />
          </div>
          <div class="form-group mb-0">
            <label>새 비밀번호 확인 <span class="text-danger">*</span></label>
            <input type="password" id="confirmPwd" class="form-control form-control-sm" />
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary btn-sm" data-dismiss="modal">취소</button>
          <button type="button" class="btn btn-primary btn-sm" onclick="fnChangePassword()">변경</button>
        </div>
      </div>
    </div>
  </div>

  <!-- /.content-wrapper -->
</div>
<!-- ./wrapper -->

<script>
  function fnGoMng(brdCd) {
    $('#mngBrdCd').val(brdCd);
    $('#goMngForm').attr('action', '${ctx}/bbsComMng/viewBbsComMng');
    $('#goMngForm').submit();
  }

  function fnOpenPwdModal() {
    $('#currentPwd').val('');
    $('#newPwd').val('');
    $('#confirmPwd').val('');
    $('#pwdChangeModal').modal('show');
  }

  function fnChangePassword() {
    var currentPwd = $('#currentPwd').val().trim();
    var newPwd = $('#newPwd').val().trim();
    var confirmPwd = $('#confirmPwd').val().trim();

    if (!currentPwd) {
      alert('현재 비밀번호를 입력해주세요.');
      $('#currentPwd').focus();
      return;
    }
    if (!newPwd) {
      alert('새 비밀번호를 입력해주세요.');
      $('#newPwd').focus();
      return;
    }
    if (newPwd.length < 4) {
      alert('새 비밀번호는 4자 이상 입력해주세요.');
      $('#newPwd').focus();
      return;
    }
    if (newPwd !== confirmPwd) {
      alert('새 비밀번호가 일치하지 않습니다.');
      $('#confirmPwd').focus();
      return;
    }

    var res = ajaxCall('${ctx}/usrMng/changeMyPassword', {
      currentPwd: currentPwd,
      newPwd: newPwd
    }, false);

    if (res && res.result === 'OK') {
      alert('비밀번호가 변경되었습니다.');
      $('#pwdChangeModal').modal('hide');
    } else {
      alert(res.message || '비밀번호 변경에 실패했습니다.');
    }
  }
</script>

</body>
</html>
