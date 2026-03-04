<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>
<%@ include file="/WEB-INF/views/front/bbs/bbsCommon/inc/bbsPagingVars.jspf" %>
<main id="main">

  <!-- ======= Breadcrumbs ======= -->
  <div class="breadcrumbs d-flex align-items-center">
    <div class="container position-relative d-flex flex-column align-items-center">
      <h2>공지사항</h2>
      <ol>
        <li>고객지원</li>
      </ol>
    </div>
  </div><!-- End Breadcrumbs -->

  <!-- ======= 2컬럼 레이아웃 ======= -->
  <c:set var="activeLnb" value="notice" scope="request" />
  <div class="lnb-layout">
    <%@ include file="/WEB-INF/views/front/bbs/inc/sidebarSupport.jsp" %>

    <div class="lnb-content">
      <div class="lnb-contentHeader">
        <span class="bbsCommon-total">TOTAL : <span class="bbsCommon-totalNum">${totalCnt + noticeList.size()}</span> 건</span>
        <c:if test="${not empty sessionScope.loginUser}">
          <div class="lnb-contentBtns">
            <form action="${ctx}/bbsComMng/viewBbsComMng" method="POST" style="display:inline;">
              <input type="hidden" name="brdCd" value="${brdCd}" />
              <button type="submit" class="btn btn-admin-mng"><i class="bi bi-gear-fill"></i> 관리</button>
            </form>
            <form action="${ctx}/bbs/viewBbsWrite" method="POST" style="display:inline;">
              <input type="hidden" name="brdCd" value="${brdCd}" />
              <input type="hidden" name="pageNo" value="${pageNo}" />
              <button type="submit" class="btn btn-admin-mng"><i class="bi bi-pencil-fill"></i> 글쓰기</button>
            </form>
          </div>
        </c:if>
      </div>

      <div class="bbsCommon">

        <div class="bbsCommon-tableWrap">
          <table class="bbsCommon-table">
            <colgroup>
              <col style="width:80px;"><col><col style="width:120px;"><col style="width:140px;"><col style="width:100px;">
            </colgroup>
            <thead>
              <tr><th>번호</th><th class="txt-left">제목</th><th>작성자</th><th>등록일</th><th>조회수</th></tr>
            </thead>
            <tbody>
              <c:if test="${empty noticeList and empty list}">
                <tr><td colspan="5" class="bbsCommon-emptyTd">등록된 게시물이 없습니다.</td></tr>
              </c:if>
              <c:forEach var="row" items="${noticeList}">
                <tr class="bbsCommon-row" onclick="fnGoDetail('${row.pstCd}')">
                  <td><span class="bbsCommon-badge">공지</span></td>
                  <td class="txt-left"><span class="bbsCommon-ttl">${row.pstNm}</span></td>
                  <td class="muted">${row.rgtUsrNm}</td><td class="muted">${row.rgtDtm}</td><td class="muted">${row.viewCnt}</td>
                </tr>
              </c:forEach>
              <c:forEach var="row" items="${list}" varStatus="st">
                <tr class="bbsCommon-row" onclick="fnGoDetail('${row.pstCd}')">
                  <td>${totalCnt - offset - st.index}</td>
                  <td class="txt-left"><span class="bbsCommon-ttl">${row.pstNm}</span></td>
                  <td class="muted">${row.rgtUsrNm}</td><td class="muted">${row.rgtDtm}</td><td class="muted">${row.viewCnt}</td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>

        <div class="bbsCommon-paging">
          <ul class="bbsCommon-pages">
            <li class="${pageNo <= 1 ? 'disabled' : ''}"><a href="javascript:fnGoPage(${pageNo - 1})">이전</a></li>
            <c:forEach var="p" begin="${startPage}" end="${endPage}">
              <li class="${p == pageNo ? 'active' : ''}"><a href="javascript:fnGoPage(${p})">${p}</a></li>
            </c:forEach>
            <li class="${pageNo >= totalPage ? 'disabled' : ''}"><a href="javascript:fnGoPage(${pageNo + 1})">다음</a></li>
          </ul>
        </div>

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

        <div class="bbsCommon-searchRow">
          <form class="bbsCommon-searchForm" method="post" action="${ctx}/bbs/viewBbsNotice">
            <input type="hidden" name="brdCd" value="${brdCd}" />
            <select name="searchType" class="bbsCommon-select">
              <option value="title" ${param.searchType eq 'title' ? 'selected' : ''}>제목</option>
              <option value="content" ${param.searchType eq 'content' ? 'selected' : ''}>내용</option>
            </select>
            <input type="text" name="keyword" value="${param.keyword}" placeholder="검색어를 입력해 주세요." class="bbsCommon-input"/>
            <button type="submit" class="bbsCommon-searchBtn2">검색</button>
          </form>
        </div>
      </div><!-- /bbsCommon -->

    </div><!-- /lnb-content -->
  </div><!-- /lnb-layout -->

</main><!-- End #main -->

<script>
  function fnGoPage(no) {
    $('#pageNo').val(no);
    $('#pagingForm').submit();
  }
  function fnGoDetail(pstCd) {
    $('#detailPstCd').val(pstCd);
    $('#goDetailForm').submit();
  }
</script>


<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>
