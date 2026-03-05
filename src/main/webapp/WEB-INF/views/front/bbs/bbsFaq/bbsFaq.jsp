<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>

<!-- 페이지 헤더 -->
<div class="page-header">
  <h2>FAQ</h2>
  <p class="page-breadcrumb">홈 &gt; <span>고객지원</span> &gt; FAQ</p>
</div>

<!-- 2컬럼 레이아웃 -->
<c:set var="activeLnb" value="faq" scope="request" />
<div class="content-layout">
  <%@ include file="/WEB-INF/views/front/bbs/inc/sidebarSupport.jsp" %>

  <div class="content-main">

    <!-- 상단 -->
    <div class="board-header">
      <p class="board-total">전체 <strong>${list.size()}</strong>건</p>
      <c:if test="${not empty sessionScope.loginUser}">
        <div class="board-admin-btns">
          <button type="button" class="btn-admin" onclick="fnGoMng()">⚙ 관리</button>
          <button type="button" class="btn-admin" onclick="fnGoWrite()">✏ 등록</button>
        </div>
      </c:if>
    </div>

    <!-- FAQ 아코디언 -->
    <div class="faq-list">
      <c:choose>
        <c:when test="${not empty list}">
          <c:forEach var="item" items="${list}">
            <div class="faq-item">
              <div class="faq-question" onclick="fnToggleFaq(this)">
                <div>
                  <span class="faq-q-badge">Q.</span>${item.pstNm}
                </div>
                <span class="faq-arrow">▾</span>
              </div>
              <div class="faq-answer">
                <div class="faq-answer-inner">
                  <span class="faq-a-badge">A.</span>${item.pstCnts}
                </div>
              </div>
            </div>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <div class="board-empty" style="padding:60px 0;">등록된 FAQ가 없습니다.</div>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- BO 새창용 -->
    <form id="goBoForm" method="post" target="_blank">
      <input type="hidden" name="brdCd" value="${brdCd}" />
    </form>

  </div><!-- /content-main -->
</div><!-- /content-layout -->

<script>
  function fnToggleFaq(el) {
    var item = el.closest('.faq-item');
    document.querySelectorAll('.faq-item.open').forEach(function(other) {
      if (other !== item) other.classList.remove('open');
    });
    item.classList.toggle('open');
  }

  function fnGoMng() {
    $('#goBoForm').attr('action', '${ctx}/bbsComMng/viewBbsComMng');
    $('#goBoForm').submit();
  }
  function fnGoWrite() {
    $('#goBoForm').attr('action', '${ctx}/bbsComMng/viewBbsComWrite');
    $('#goBoForm').submit();
  }
</script>

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>

</body>
</html>
