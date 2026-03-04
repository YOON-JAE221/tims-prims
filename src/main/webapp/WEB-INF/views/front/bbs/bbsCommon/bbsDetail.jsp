<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<link href="${ctx}/resources/front/css/bbsDetail.css" rel="stylesheet">

<c:set var="isSupport" value="${brdMenuNm eq '고객지원'}" />
<c:set var="isEngineering" value="${brdMenuNm eq 'ENGINEERING'}" />
<c:set var="hasSidebar" value="${isSupport or isEngineering}" />

<main id="main">

  <!-- ======= Breadcrumbs ======= -->
  <div class="breadcrumbs d-flex align-items-center">
    <div class="container position-relative d-flex flex-column align-items-center">
      <h2>${brd.brdNm}</h2>
      <ol>
        <li>${brdMenuNm}</li>
      </ol>
    </div>
  </div><!-- End Breadcrumbs -->

  <%-- 2컬럼 사이드바 레이아웃 --%>
  <c:if test="${hasSidebar}">
    <c:choose>
      <%-- 고객지원 --%>
      <c:when test="${isSupport}">
        <c:choose>
          <c:when test="${fn:contains(listUrl, 'Notice')}"><c:set var="activeLnb" value="notice" scope="request" /></c:when>
          <c:when test="${fn:contains(listUrl, 'DataRoom')}"><c:set var="activeLnb" value="dataroom" scope="request" /></c:when>
          <c:otherwise><c:set var="activeLnb" value="notice" scope="request" /></c:otherwise>
        </c:choose>
        <div class="lnb-layout">
          <%@ include file="/WEB-INF/views/front/bbs/inc/sidebarSupport.jsp" %>
          <div class="lnb-content">
      </c:when>
      <%-- ENGINEERING --%>
      <c:when test="${isEngineering}">
        <c:choose>
          <c:when test="${fn:contains(listUrl, 'Stra')}"><c:set var="activeLnb" value="stra" scope="request" /></c:when>
          <c:when test="${fn:contains(listUrl, 'Stre')}"><c:set var="activeLnb" value="stre" scope="request" /></c:when>
          <c:when test="${fn:contains(listUrl, 'Dise')}"><c:set var="activeLnb" value="dise" scope="request" /></c:when>
          <c:when test="${fn:contains(listUrl, 'Safe')}"><c:set var="activeLnb" value="safe" scope="request" /></c:when>
          <c:when test="${fn:contains(listUrl, 'Spfe')}"><c:set var="activeLnb" value="spfe" scope="request" /></c:when>
          <c:when test="${fn:contains(listUrl, 'Tere')}"><c:set var="activeLnb" value="tere" scope="request" /></c:when>
          <c:when test="${fn:contains(listUrl, 'Vera')}"><c:set var="activeLnb" value="vera" scope="request" /></c:when>
          <c:when test="${fn:contains(listUrl, 'Sdse')}"><c:set var="activeLnb" value="sdse" scope="request" /></c:when>
          <c:otherwise><c:set var="activeLnb" value="stra" scope="request" /></c:otherwise>
        </c:choose>
        <div class="lnb-layout">
          <%@ include file="/WEB-INF/views/front/bbs/inc/sidebarEngineering.jsp" %>
          <div class="lnb-content">
      </c:when>
    </c:choose>
  </c:if>

  <!-- ======= Detail ======= -->
  <section id="bbsDetail" class="bbsDetail">
    <div class="container">

      <!-- 제목 영역 -->
      <div class="bbsDetail-header">
        <c:if test="${pst.noticeYn eq 'Y'}">
          <span class="bbsCommon-badge">공지</span>
        </c:if>
        <h3 class="bbsDetail-title">${pst.pstNm}</h3>
        <div class="bbsDetail-meta">
          <span>작성자 : ${pst.rgtUsrNm}</span>
          <span>등록일 : ${pst.rgtDtm}</span>
          <span>조회수 : ${pst.viewCnt}</span>
        </div>
      </div>

      <!-- 내용 영역 -->
      <div class="bbsDetail-content">
        <c:out value="${pst.pstCnts}" escapeXml="false"/>
      </div>

      <!-- 첨부파일 영역 -->
      <c:if test="${not empty fileList}">
        <div class="bbsDetail-atch">
          <span class="bbsDetail-atchLabel">첨부파일</span>
          <ul class="bbsDetail-atchList">
            <c:forEach var="file" items="${fileList}">
              <li>
                <a href="${ctx}/file/download?upldFileCd=${file.upldFileCd}&fileSeq=${file.fileSeq}">
                  <i class="bi bi-paperclip"></i> ${file.fileNm}
                </a>
              </li>
            </c:forEach>
          </ul>
        </div>
      </c:if>

      <!-- 버튼 -->
      <div class="bbsDetail-btnRow">
        <button type="button" class="bbsDetail-btn bbsDetail-btn--list" onclick="fnGoList()">목록</button>
        <c:if test="${not empty sessionScope.loginUser}">
          <button type="button" class="bbsDetail-btn bbsDetail-btn--edit" onclick="fnEdit()">수정</button>
          <button type="button" class="bbsDetail-btn bbsDetail-btn--edit" onclick="fnDelete()">삭제</button>
        </c:if>
      </div>

      <!-- 목록 이동용 -->
      <form id="goListForm" action="${ctx}${listUrl}" method="post">
        <input type="hidden" name="brdCd" value="${brdCd}" />
        <input type="hidden" name="pageNo" value="${pageNo}" />
      </form>

      <!-- 수정 이동용 -->
      <form id="goEditForm" action="${ctx}/bbs/viewBbsWrite" method="post">
        <input type="hidden" name="brdCd" value="${brdCd}" />
        <input type="hidden" name="pstCd" value="${pst.pstCd}" />
      </form>

    </div>
  </section>

  <%-- 레이아웃 닫기 --%>
  <c:if test="${hasSidebar}">
      </div><!-- /lnb-content -->
    </div><!-- /lnb-layout -->
  </c:if>

</main><!-- End #main -->


<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>

<script>
  function fnGoList() { $('#goListForm').submit(); }
  function fnEdit() { $('#goEditForm').submit(); }
  function fnDelete() {
    if (!confirm('삭제하시겠습니까?')) return;
    var res = ajaxCall("${ctx}/bbs/deleteBbsPst", { brdCd: '${brdCd}', pstCd: '${pst.pstCd}' }, false);
    if (res && res.result === 'OK') { alert('삭제되었습니다.'); fnGoList(); }
    else { alert('삭제 실패'); }
  }
</script>
