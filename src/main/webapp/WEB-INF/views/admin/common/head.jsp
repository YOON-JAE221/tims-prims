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
  
  <c:set var="ctx" value="${pageContext.request.contextPath}" />
  
  <!-- Favicons -->
  <link rel="icon" sizes="any" href="${ctx}/resources/front/img/favicon/favicon.ico?v=20260305">
  <link rel="icon" type="image/png" sizes="16x16" href="${ctx}/resources/front/img/favicon/favicon-16x16.png?v=20260305">
  <link rel="icon" type="image/png" sizes="32x32" href="${ctx}/resources/front/img/favicon/favicon-32x32.png?v=20260305">

  	<!-- Font Awesome Icons -->
  	<link rel="stylesheet" href="${ctx}/resources/admin/plugins/fontawesome-free/css/all.min.css">
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
	
	<!-- summernote -->
	<link rel="stylesheet" href="${ctx}/resources/common/summernote/css/admin/summernote-bs4.min.css" />
	<script src="${ctx}/resources/common/summernote/js/admin/summernote-bs4.min.js" charset="UTF-8"></script>
	<script src="${ctx}/resources/common/summernote/js/summernote-ko-KR.min.js" charset="UTF-8"></script>
	<script src="${ctx}/resources/common/summernote/js/summernote-editor-common.js" charset="UTF-8"></script>
	
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
              <li><a href="${ctx}/propertyMng/viewPropertyMng" class="dropdown-item">매물관리</a></li>
              <li><a href="${ctx}/propCatMng/viewPropCatMng" class="dropdown-item">매물코드관리</a></li>
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
            <a id="dropdownSubMenu4" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" class="nav-link dropdown-toggle">시스템관리</a>
            <ul aria-labelledby="dropdownSubMenu4" class="dropdown-menu border-0 shadow">
              <li><a href="${ctx}/sysMenuMng/viewSysMenuMng" class="dropdown-item">메뉴관리</a></li>
              <li><a href="${ctx}/popMng/viewPopMng" class="dropdown-item">팝업관리</a></li>
              <li><a href="${ctx}/batMng/viewBatMng" class="dropdown-item">배치관리</a></li>
              <li><a href="${ctx}/bbsBrdMng/viewBbsBrdMng" class="dropdown-item">게시판관리</a></li>
              <li><a href="${ctx}/sendLogMng/viewSendLogMng" class="dropdown-item">발송내역</a></li>
              <li><a href="${ctx}/accessCodeMng/viewAccessCodeMng" class="dropdown-item">접속코드</a></li>
            </ul>
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

  <!-- /.content-wrapper -->
</div>
<!-- ./wrapper -->

<script>
  function fnGoMng(brdCd) {
    $('#mngBrdCd').val(brdCd);
    $('#goMngForm').attr('action', '${ctx}/bbsComMng/viewBbsComMng');
    $('#goMngForm').submit();
  }
</script>

</body>
</html>
