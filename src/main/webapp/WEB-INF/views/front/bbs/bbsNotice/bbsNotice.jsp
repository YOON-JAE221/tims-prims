<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>
<%@ include file="/WEB-INF/views/front/bbs/bbsCommon/inc/bbsPagingVars.jspf" %>

<!-- 페이지 헤더 -->
<div class="page-header">
  <h2>공지사항</h2>
  <p class="page-breadcrumb">홈 &gt; <span>고객지원</span> &gt; 공지사항</p>
</div>

<!-- 2컬럼 레이아웃 -->
<c:set var="activeLnb" value="notice" scope="request" />
<div class="content-layout">
  <%@ include file="/WEB-INF/views/front/bbs/inc/sidebarSupport.jsp" %>

  <div class="content-main">

    <!-- 상단 (총건수 + 관리자 버튼) -->
    <div class="board-header">
      <p class="board-total">전체 <strong>${totalCnt + noticeList.size()}</strong>건</p>
      <c:if test="${not empty sessionScope.loginUser}">
        <div class="board-admin-btns">
          <button type="button" class="btn-admin" onclick="fnGoMng()">⚙ 관리</button>
          <button type="button" class="btn-admin" onclick="fnGoWrite()">✏ 글쓰기</button>
        </div>
      </c:if>
    </div>

    <!-- 테이블 -->
    <table class="board-table">
      <colgroup>
        <col style="width:70px;"><col><col style="width:100px;"><col style="width:120px;"><col style="width:80px;">
      </colgroup>
      <thead>
        <tr>
          <th>번호</th>
          <th class="td-left">제목</th>
          <th>작성자</th>
          <th>등록일</th>
          <th>조회</th>
        </tr>
      </thead>
      <tbody>
        <c:if test="${empty noticeList and empty list}">
          <tr><td colspan="5" class="board-empty">등록된 게시물이 없습니다.</td></tr>
        </c:if>
        <c:forEach var="row" items="${noticeList}">
          <tr onclick="fnGoDetail('${row.pstCd}')">
            <td><span class="board-badge-notice">공지</span></td>
            <td class="td-left td-title">${row.pstNm}</td>
            <td class="td-muted">${row.rgtUsrNm}</td>
            <td class="td-muted">${row.rgtDtm}</td>
            <td class="td-muted">${row.viewCnt}</td>
          </tr>
        </c:forEach>
        <c:forEach var="row" items="${list}" varStatus="st">
          <tr onclick="fnGoDetail('${row.pstCd}')">
            <td>${totalCnt - offset - st.index}</td>
            <td class="td-left td-title">${row.pstNm}</td>
            <td class="td-muted">${row.rgtUsrNm}</td>
            <td class="td-muted">${row.rgtDtm}</td>
            <td class="td-muted">${row.viewCnt}</td>
          </tr>
        </c:forEach>
      </tbody>
    </table>

    <!-- 페이징 -->
    <div class="board-paging">
      <a href="javascript:fnGoPage(${pageNo - 1})" class="${pageNo <= 1 ? 'disabled' : ''}">이전</a>
      <c:forEach var="p" begin="${startPage}" end="${endPage}">
        <a href="javascript:fnGoPage(${p})" class="${p == pageNo ? 'active' : ''}">${p}</a>
      </c:forEach>
      <a href="javascript:fnGoPage(${pageNo + 1})" class="${pageNo >= totalPage ? 'disabled' : ''}">다음</a>
    </div>

    <!-- 검색 -->
    <form class="board-search" method="post" action="${ctx}/bbs/viewBbsNotice">
      <input type="hidden" name="brdCd" value="${brdCd}" />
      <select name="searchType">
        <option value="title" ${param.searchType eq 'title' ? 'selected' : ''}>제목</option>
        <option value="content" ${param.searchType eq 'content' ? 'selected' : ''}>내용</option>
      </select>
      <input type="text" name="keyword" value="${param.keyword}" placeholder="검색어를 입력해 주세요."/>
      <button type="submit">검색</button>
    </form>

    <!-- hidden forms -->
    <form id="goDetailForm" action="${ctx}/bbs/viewBbsDetail" method="post">
      <input type="hidden" name="brdCd" value="${brdCd}" />
      <input type="hidden" name="pstCd" id="detailPstCd" />
      <input type="hidden" name="pageNo" value="${pageNo}" />
    </form>
    <form id="pagingForm" action="${ctx}/bbs/viewBbsNotice" method="post">
      <input type="hidden" name="brdCd" value="${brdCd}" />
      <input type="hidden" name="pageNo" id="pageNo" value="${pageNo}" />
      <input type="hidden" name="searchType" value="${param.searchType}" />
      <input type="hidden" name="keyword" value="${param.keyword}" />
    </form>
    <form id="goBoForm" method="post" target="_blank">
      <input type="hidden" name="brdCd" value="" />
    </form>

  </div><!-- /content-main -->
</div><!-- /content-layout -->

<script>
  function fnGoPage(no) {
    $('#pageNo').val(no);
    $('#pagingForm').submit();
  }
  function fnGoDetail(pstCd) {
    $('#detailPstCd').val(pstCd);
    $('#goDetailForm').submit();
  }
  function fnGoMng() {
    $('#goBoForm input[name="brdCd"]').val('${brdCd}');
    $('#goBoForm').attr('action', '${ctx}/bbsComMng/viewBbsComMng');
    $('#goBoForm').submit();
  }
  function fnGoWrite() {
    $('#goBoForm input[name="brdCd"]').val('${brdCd}');
    $('#goBoForm').attr('action', '${ctx}/bbsComMng/viewBbsComWrite');
    $('#goBoForm').submit();
  }
</script>

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>

</body>
</html>
