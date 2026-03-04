<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglibs.jsp" %>

<!DOCTYPE html>
<html lang="ko">

<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">

  <title>강한건축구조기술사사무소</title>
  
  <c:set var="ctx" value="${pageContext.request.contextPath}" />
  
  <meta content="구조설계 · 구조검토 · 안전진단 전문 강한건축구조기술사사무소" name="description">
  <meta content="강한건축구조기술사사무소,구조설계,구조검토,안전진단,내진성능평가" name="keywords">

  <!-- Open Graph (카카오톡/SNS 링크 미리보기) -->
  <meta property="og:type" content="website" />
  <meta property="og:title" content="강한건축구조기술사사무소" />
  <meta property="og:description" content="강한구조 · 강한책임 · 강한기술력으로 건축구조의 본질을 설계합니다." />
  <meta property="og:image" content="http://mwkim-dev.com/resources/front/img/og-image.png" />
  <meta property="og:image:width" content="1200" />
  <meta property="og:image:height" content="630" />
  <meta property="og:url" content="http://mwkim-dev.com" />

  <!-- Favicons -->
  <link rel="icon" sizes="any" href="${ctx}/resources/front/img/favicon/favicon.ico?v=20260202">
  <link rel="icon" type="image/png" sizes="16x16" href="${ctx}/resources/front/img/favicon/favicon-16x16.png?v=20260202">
  <link rel="icon" type="image/png" sizes="32x32" href="${ctx}/resources/front/img/favicon/favicon-32x32.png?v=20260202">
  <link rel="apple-touch-icon" sizes="180x180" href="${ctx}/resources/front/img/favicon/apple-touch-icon.png?v=20260202">
  <link rel="icon" type="image/png" sizes="192x192" href="${ctx}/resources/front/img/favicon/android-chrome-192x192.png?v=20260202">
  <link rel="icon" type="image/png" sizes="512x512" href="${ctx}/resources/front/img/favicon/android-chrome-512x512.png?v=20260202">
  <link rel="manifest" href="${ctx}/resources/front/img/favicon/site.webmanifest?v=20260202">
  <meta name="theme-color" content="#ffffff">

  <!-- Vendor CSS Files -->
  <link href="${ctx}/resources/front/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="${ctx}/resources/front/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
  <link href="${ctx}/resources/front/vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
  <link href="${ctx}/resources/front/vendor/aos/aos.css" rel="stylesheet">
  <link href="${ctx}/resources/front/vendor/glightbox/css/glightbox.min.css" rel="stylesheet">

<!-- jQuery (이건 이미 절대경로라 OK, 통일하려면 아래처럼) -->
  <script src="${ctx}/resources/common/util/js/jquery-4.0.0.min.js" charset="UTF-8"></script>

  
  <!-- Template Main CSS File -->
  <link href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" rel="stylesheet">
  <link href="${ctx}/resources/front/css/main.css?v=202503040001" rel="stylesheet">
  <link href="${ctx}/resources/front/css/common.css?v=202502200001" rel="stylesheet">

  <!-- GLightbox Custom CSS -->
  <link href="${ctx}/resources/front/css/glightbox-custom.css" rel="stylesheet">

  <!-- FO MENU JS -->
  <script src="${ctx}/resources/front/js/navigator.js" charset="UTF-8"></script>

  <!-- jQuery 4.x 호환 shim (Summernote가 $.now 사용) -->
  <script>if (!$.now) { $.now = Date.now; }</script>
  <!-- summernote (lite - Bootstrap 의존 없음, FO용) -->
    <link rel="stylesheet" href="${ctx}/resources/common/summernote/css/front/summernote-lite.min.css" />
  	<script src="${ctx}/resources/common/summernote/js/front/summernote-lite.min.js" charset="UTF-8"></script>
  	<script src="${ctx}/resources/common/summernote/js/summernote-ko-KR.min.js" charset="UTF-8"></script>
  	<script src="${ctx}/resources/common/summernote/js/summernote-editor-common.js" charset="UTF-8"></script>
  <!-- common -->

  <script src="${ctx}/resources/common/util/js/common.js" charset="UTF-8"></script>
  
</head>

<body>

  <!-- ======= Header ======= -->
  <header id="header" class="header d-flex align-items-center">
    <div class="container-fluid container-xl d-flex align-items-center justify-content-between">

      <a href="/" class="logo d-flex align-items-center">
	    <img src="${ctx}/resources/front/img/logo/logo-main.png">
	  </a>
      
      <i class="mobile-nav-toggle mobile-nav-show bi bi-list"></i>
      <i class="mobile-nav-toggle mobile-nav-hide d-none bi bi-x"></i>
      <nav id="navbar" class="navbar">
        <ul>
          <li><a href="/">Home</a></li>
          
		  <li class="dropdown"><a href="#"><span>회사소개</span> <i
                class="bi bi-chevron-down dropdown-indicator"></i></a>
          	<ul>
			  <li><a href="${ctx}/greeting/viewGreeting">인사말</a></li>   
              <li><a href="${ctx}/comHistory/viewComHistory">연혁</a></li>
              <li><a href="${ctx}/locGuide/viewLocGuide">찾아오시는길</a></li>
            </ul>
          </li>          
          
          <li class="dropdown"><a href="#"><span>ENGINEERING</span> <i
                class="bi bi-chevron-down dropdown-indicator"></i></a>
            <ul>
			  <li><a href="/bbs/viewBbsStra">구조설계</a></li>
              <li><a href="/bbs/viewBbsStre">구조검토</a></li>
              <li><a href="/bbs/viewBbsDise">해체검토</a></li>
              <li><a href="/bbs/viewBbsSafe">안전진단</a></li>
              <li><a href="/bbs/viewBbsSpfe">내진성능평가</a></li>
              <li><a href="/bbs/viewBbsTere">가설재설계</a></li>
              <li><a href="/bbs/viewBbsVera">VE설계</a></li>
              <li><a href="/bbs/viewBbsSdse">비구조요소 내진설계</a></li>
            </ul>
          </li>

          <li class="dropdown"><a href="#"><span>등록 및 면허</span> <i
                class="bi bi-chevron-down dropdown-indicator"></i></a>
            <ul>
              <li><a href="${ctx}/license/viewLicense">등록 및 면허</a></li>
            </ul>
          </li>

          <li class="dropdown"><a href="#"><span>고객지원</span> <i
                class="bi bi-chevron-down dropdown-indicator"></i></a>
            <ul>
			  <li><a href="${ctx}/bbs/viewBbsNotice">공지사항</a></li>   
              <li><a href="${ctx}/bbs/viewBbsDataRoom">자료실</a></li>
              <li><a href="${ctx}/bbs/viewBbsQna">문의게시판</a></li>
            </ul>
          </li>

          <li> <a href="https://blog.naver.com/thdeofyd" target="_blank" rel="noopener noreferrer">Blog</a> </li>

<!--           <li><a href="contact.html">상담문의</a></li> -->
        </ul>
      </nav><!-- .navbar -->

    </div>
  </header><!-- End Header -->

</body>

</html>