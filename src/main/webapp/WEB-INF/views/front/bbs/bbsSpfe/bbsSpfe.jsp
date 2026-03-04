<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>
<%@ include file="/WEB-INF/views/front/bbs/bbsCommon/inc/bbsPagingVars.jspf" %>

<main id="main">
  <div class="breadcrumbs d-flex align-items-center">
    <div class="container position-relative d-flex flex-column align-items-center">
      <h2>내진성능평가</h2>
      <ol>
        <li>ENGINEERING</li>
      </ol>
    </div>
  </div>

  <c:set var="activeLnb" value="spfe" scope="request" />
  <div class="lnb-layout">
    <%@ include file="/WEB-INF/views/front/bbs/inc/sidebarEngineering.jsp" %>
    <div class="lnb-content">
      <div class="lnb-contentHeader">
        <span class="bbsCommon-total">TOTAL : <span class="bbsCommon-totalNum">${totalCnt}</span> 건</span>
        <c:if test="${not empty sessionScope.loginUser}">
          <div class="lnb-contentBtns">
            <form action="${ctx}/bbsComMng/viewBbsComMng" method="POST" style="display:inline;"><input type="hidden" name="brdCd" value="${brdCd}" /><button type="submit" class="btn btn-admin-mng"><i class="bi bi-gear-fill"></i> 관리</button></form>
            <form action="${ctx}/bbs/viewBbsWrite" method="POST" style="display:inline;"><input type="hidden" name="brdCd" value="${brdCd}" /><input type="hidden" name="pageNo" value="${pageNo}" /><button type="submit" class="btn btn-admin-mng"><i class="bi bi-pencil-fill"></i> 글쓰기</button></form>
          </div>
        </c:if>
      </div>
      <div class="bbsCard">
        <div class="bbsCard-grid">
          <c:if test="${empty noticeList and empty list}"><div class="bbsCard-empty">등록된 게시물이 없습니다.</div></c:if>
          <c:forEach var="row" items="${list}">
            <div class="bbsCard-item" onclick="fnGoDetail('${row.pstCd}')">
              <c:choose><c:when test="${not empty row.thumbUrl}"><div class="bbsCard-thumb"><img src="${row.thumbUrl}" alt=""></div></c:when><c:otherwise><div class="bbsCard-thumbEmpty"><i class="bi bi-image"></i></div></c:otherwise></c:choose>
              <div class="bbsCard-body"><h4 class="bbsCard-title">${row.pstNm}</h4><div class="bbsCard-meta"><span>${row.rgtUsrNm}</span><span>${row.rgtDtm}</span><span>조회 ${row.viewCnt}</span></div></div>
            </div>
          </c:forEach>
        </div>
        <div class="bbsCard-paging"><ul class="bbsCard-pages"><li class="${pageNo <= 1 ? 'disabled' : ''}"><a href="javascript:fnGoPage(${pageNo - 1})">이전</a></li><c:forEach var="p" begin="${startPage}" end="${endPage}"><li class="${p == pageNo ? 'active' : ''}"><a href="javascript:fnGoPage(${p})">${p}</a></li></c:forEach><li class="${pageNo >= totalPage ? 'disabled' : ''}"><a href="javascript:fnGoPage(${pageNo + 1})">다음</a></li></ul></div>
      </div>
      <form id="goDetailForm" action="${ctx}/bbs/viewBbsDetail" method="post"><input type="hidden" name="brdCd" value="${brdCd}" /><input type="hidden" name="pstCd" id="detailPstCd" /><input type="hidden" name="pageNo" value="${pageNo}" /></form>
      <form id="pagingForm" action="${ctx}${listUrl}" method="post"><input type="hidden" name="brdCd" value="${brdCd}" /><input type="hidden" name="pageNo" id="pageNo" value="${pageNo}" /></form>
    </div>
  </div>
</main>
<script>function fnGoPage(no){$('#pageNo').val(no);$('#pagingForm').submit();}function fnGoDetail(pstCd){$('#detailPstCd').val(pstCd);$('#goDetailForm').submit();}</script>

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>
