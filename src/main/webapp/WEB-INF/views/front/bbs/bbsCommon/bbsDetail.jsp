<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- 메뉴명/사이드바 분기 --%>
<c:set var="isSupport" value="${brdMenuNm eq '고객지원'}" />

<%-- activeLnb 설정 --%>
<c:choose>
  <c:when test="${fn:contains(listUrl, 'Notice')}"><c:set var="activeLnb" value="notice" scope="request" /></c:when>
  <c:when test="${fn:contains(listUrl, 'Faq')}"><c:set var="activeLnb" value="faq" scope="request" /></c:when>
  <c:otherwise><c:set var="activeLnb" value="notice" scope="request" /></c:otherwise>
</c:choose>

<!-- 페이지 헤더 -->
<div class="page-header">
  <h2>${brd.brdNm}</h2>
</div>

<!-- 2컬럼 레이아웃 -->
<div class="content-layout">
  <c:if test="${isSupport}">
    <%@ include file="/WEB-INF/views/front/bbs/inc/sidebarSupport.jsp" %>
  </c:if>

  <div class="content-main">

    <!-- 제목 영역 -->
    <div class="board-detail-header">
      <c:if test="${pst.noticeYn eq 'Y'}">
        <span class="board-detail-badge">공지</span>
      </c:if>
      <h3 class="board-detail-title">${pst.pstNm}</h3>
      <div class="board-detail-meta">
        <span>작성자 : ${pst.rgtUsrNm}</span>
        <span>등록일 : ${pst.rgtDtm}</span>
        <span>조회수 : ${pst.viewCnt}</span>
      </div>
    </div>

    <!-- 첨부파일 -->
    <c:if test="${not empty fileList}">
      <div class="board-detail-attach">
        <span class="board-detail-attach-label">첨부파일</span>
        <ul class="board-detail-attach-list">
          <c:forEach var="file" items="${fileList}">
            <li>
              <a href="${ctx}/file/download?upldFileCd=${file.upldFileCd}&fileSeq=${file.fileSeq}">${file.fileNm}</a>
            </li>
          </c:forEach>
        </ul>
      </div>
    </c:if>

    <!-- 본문 -->
    <div class="board-detail-body">
      <c:out value="${pst.pstCnts}" escapeXml="false"/>
    </div>

    <!-- 버튼 -->
    <div class="board-detail-btns">
      <button type="button" class="board-btn board-btn-list" onclick="fnGoList()">목록</button>
      <c:if test="${not empty sessionScope.loginUser}">
        <button type="button" class="board-btn board-btn-edit" onclick="fnEdit()">수정</button>
        <button type="button" class="board-btn board-btn-delete" onclick="fnDelete()">삭제</button>
      </c:if>
    </div>

    <!-- hidden forms -->
    <form id="goListForm" action="${ctx}${listUrl}" method="post">
      <input type="hidden" name="brdCd" value="${brdCd}" />
      <input type="hidden" name="pageNo" value="${pageNo}" />
    </form>
    <form id="goEditForm" action="${ctx}/bbsComMng/viewBbsComWrite" method="post" target="_blank">
      <input type="hidden" name="brdCd" value="${brdCd}" />
      <input type="hidden" name="pstCd" value="${pst.pstCd}" />
    </form>
    <form id="goDetailForm" action="${ctx}/bbs/viewBbsDetail" method="post">
      <input type="hidden" name="brdCd" value="${brdCd}" />
      <input type="hidden" name="pstCd" id="detailPstCd" />
      <input type="hidden" name="pageNo" value="${pageNo}" />
    </form>

  </div><!-- /content-main -->
</div><!-- /content-layout -->

<script>
  function fnGoList() { $('#goListForm').submit(); }
  function fnEdit() { $('#goEditForm').submit(); }
  function fnGoDetail(pstCd) {
    $('#detailPstCd').val(pstCd);
    $('#goDetailForm').submit();
  }
  function fnDelete() {
    if (!confirm('삭제하시겠습니까?')) return;
    var res = ajaxCall("${ctx}/bbsComMng/deleteBbsPst", { brdCd: '${brdCd}', pstCd: '${pst.pstCd}' }, false);
    if (res && res.result === 'OK') { alert('삭제되었습니다.'); fnGoList(); }
    else { alert('삭제 실패'); }
  }
</script>

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>

</body>
</html>
