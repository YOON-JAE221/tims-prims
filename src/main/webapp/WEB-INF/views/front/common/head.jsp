<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.prims.common.constant.Constant" %>
<%@ include file="/WEB-INF/views/common/taglibs.jsp" %>

<!DOCTYPE html>
<html lang="ko">

<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">

  <title>프리머스 부동산</title>

  <c:set var="ctx" value="${pageContext.request.contextPath}" />

  <meta content="부천 중동 전문 공인중개사 프리머스 부동산 - 아파트, 오피스텔, 상가, 사무실" name="description">
  <meta content="프리머스부동산,부천부동산,중동부동산,아파트,오피스텔,상가,사무실" name="keywords">

  <!-- Open Graph -->
  <meta property="og:type" content="website" />
  <meta property="og:title" content="프리머스 부동산" />
  <meta property="og:description" content="부천 중동 전문 공인중개사 - 아파트, 오피스텔, 상가, 사무실" />
  <meta property="og:url" content="http://mwkim-dev.com" />
  <meta property="og:image" content="http://mwkim-dev.com/resources/front/img/og-image.png" />
  <meta property="og:image:width" content="1200" />
  <meta property="og:image:height" content="630" />

  <!-- Kakao -->
  <meta property="og:site_name" content="프리머스 부동산" />
  <meta name="twitter:card" content="summary_large_image" />
  <meta name="twitter:title" content="프리머스 부동산" />
  <meta name="twitter:description" content="부천 중동 전문 공인중개사 - 아파트, 오피스텔, 상가, 사무실" />
  <meta name="twitter:image" content="http://mwkim-dev.com/resources/front/img/og-image.png" />

  <!-- Favicons -->
  <link rel="icon" sizes="any" href="${ctx}/resources/front/img/favicon/favicon.ico?v=20260305">
  <link rel="icon" type="image/png" sizes="16x16" href="${ctx}/resources/front/img/favicon/favicon-16x16.png?v=20260305">
  <link rel="icon" type="image/png" sizes="32x32" href="${ctx}/resources/front/img/favicon/favicon-32x32.png?v=20260305">
  <link rel="apple-touch-icon" sizes="180x180" href="${ctx}/resources/front/img/favicon/apple-touch-icon.png?v=20260305">

  <!-- jQuery -->
  <script src="${ctx}/resources/common/util/js/jquery-4.0.0.min.js" charset="UTF-8"></script>

  <!-- Pretendard Font -->
  <link href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" rel="stylesheet">

  <!-- CSS -->
  <link href="${ctx}/resources/front/css/common.css?v=202503120010" rel="stylesheet">
  <link href="${ctx}/resources/front/css/main.css?v=202503110006" rel="stylesheet">

  <!-- Common JS -->
  <script src="${ctx}/resources/common/util/js/common.js?v=202503100005" charset="UTF-8"></script>

  <!-- Global Config -->
  <script>
    var KAKAO_MAP_API_KEY = '<%= Constant.KAKAO_MAP_API_KEY %>';
  </script>

</head>

<body>

  <!-- ======= Navigation ======= -->
  <nav class="primus-nav" id="primusNav">
    <div class="nav-inner">
      <a href="/" class="nav-logo">
        <img src="${ctx}/resources/front/img/logo/primus-logo.png" alt="프리머스 부동산" style="height:40px;">
      </a>
      <ul class="nav-links">
        <li class="nav-item"><a href="${ctx}/about/viewAbout">회사소개</a></li>
        <li class="nav-item"><a href="${ctx}/property/viewPropertySearch">매물검색</a></li>
        <li class="nav-item"><a href="${ctx}/property/viewPropertyList">매물안내</a></li>
        <li class="nav-item">
          <a href="#">고객지원 ▾</a>
          <div class="nav-dropdown">
            <a href="${ctx}/bbs/viewBbsNotice">공지사항</a>
            <a href="${ctx}/bbs/viewBbsFaq">FAQ</a>
            <a href="${ctx}/bbs/viewBbsQna">문의하기</a>
          </div>
        </li>
        <li class="nav-item"><a href="${ctx}/locGuide/viewLocGuide">오시는길</a></li>
      </ul>
      <div class="nav-right">
        <div class="nav-phone-num">
          <small>대표전화</small>
          032-327-1277
        </div>
        <a href="javascript:fnGoConsult()" class="nav-cta">상담신청</a>
        <c:if test="${not empty sessionScope.loginUser}">
          <a href="${ctx}/admin/viewAdminMain" class="nav-admin-btn" target="_blank">관리자</a>
        </c:if>
        <button class="nav-mobile-toggle" onclick="fnToggleMobileNav()">☰</button>
      </div>
    </div>
  </nav>

  <!-- 매물유형 이동 -->
  <form id="goPropertyTypeForm" action="${ctx}/property/viewPropertyList" method="post">
    <input type="hidden" name="type" id="navPropertyType" />
  </form>

  <!-- 매물 뱃지별 이동 -->
  <form id="goPropListBadgeForm" action="${ctx}/property/viewPropertyList" method="post">
    <input type="hidden" name="badgeType" id="navBadgeType" />
  </form>

  <!-- 상담신청 이동 -->
  <form id="goConsultForm" action="${ctx}/bbs/viewBbsWriteQna" method="post">
    <input type="hidden" name="brdCd" value="3ccd942dfcbf11f08771908d6ec6e544" />
  </form>

  <script>
    window.addEventListener('scroll', function() {
      document.getElementById('primusNav').classList.toggle('scrolled', window.scrollY > 10);
    });

    function fnToggleMobileNav() {
      var links = document.querySelector('.nav-links');
      links.classList.toggle('mobile-open');
    }

    function fnGoPropertyType(t) {
      document.getElementById('navPropertyType').value = t;
      document.getElementById('goPropertyTypeForm').submit();
    }

    function fnGoPropListBadge(badgeType) {
      document.getElementById('navBadgeType').value = badgeType;
      document.getElementById('goPropListBadgeForm').submit();
    }

    function fnGoConsult() {
      document.getElementById('goConsultForm').submit();
    }

    // 고객지원 드롭다운 모바일 토글
    document.querySelectorAll('.nav-item > a').forEach(function(a) {
      a.addEventListener('click', function(e) {
        if (window.innerWidth <= 768 && this.nextElementSibling && this.nextElementSibling.classList.contains('nav-dropdown')) {
          e.preventDefault();
          this.parentElement.classList.toggle('mobile-dropdown-open');
        }
      });
    });
  </script>
