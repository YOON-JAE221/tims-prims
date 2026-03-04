<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>

<main id="main">

  <!-- ======= Breadcrumbs ======= -->
  <div class="breadcrumbs d-flex align-items-center">
    <div class="container position-relative d-flex flex-column align-items-center">
      <h2>인사말</h2>
      <ol>
        <li>회사소개</li>
      </ol>
    </div>
  </div><!-- End Breadcrumbs -->

  <!-- ======= 2컬럼 레이아웃 ======= -->
  <c:set var="activeLnb" value="greeting" scope="request" />
  <div class="lnb-layout">
    <%@ include file="/WEB-INF/views/front/common/inc/sidebarCompany.jsp" %>

    <div class="lnb-content">

      <c:if test="${not empty sessionScope.loginUser}">
        <div class="d-flex justify-content-end mb-3">
          <a href="/greetingMng/viewGreetingMng" class="btn btn-admin-mng"><i class="bi bi-gear-fill"></i> 관리</a>
        </div>
      </c:if>

      <div class="greeting-wrap">
        <!-- 상단 이미지 배너 -->
        <div class="greeting-banner">
          <img src="${ctx}/resources/front/img/office/officeTitle6.jpg" alt="강한건축구조기술사사무소">
          <div class="greeting-bannerOverlay">
            <span class="greeting-bannerText">KANGHAN STRUCTURAL ENGINEERING</span>
          </div>
        </div>

        <!-- 본문 + 서명 -->
        <div class="greeting-inner">
          <div class="greeting-bodyText">
            <c:out value="${pstCnts}" escapeXml="false"/>
          </div>
          <div class="greeting-sign">
            <span class="greeting-sign-company">강한건축구조기술사사무소</span>
            <span class="greeting-sign-ceo">대표 <strong>송 대 룡</strong></span>
          </div>
        </div>
      </div>

    </div><!-- /lnb-content -->
  </div><!-- /lnb-layout -->

</main><!-- End #main -->

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>
