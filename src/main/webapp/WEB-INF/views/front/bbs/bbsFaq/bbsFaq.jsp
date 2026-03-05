<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>
<link href="${ctx}/resources/front/css/common.css?v=202503050001" rel="stylesheet">

<div style="margin-top:72px; max-width:1200px; margin-left:auto; margin-right:auto; padding:60px 24px 100px;">

  <div class="section-label">고객지원</div>
  <h2 class="section-title">FAQ</h2>
  <p class="section-desc" style="margin-bottom:48px;">자주 묻는 질문을 확인하세요.</p>

  <!-- FAQ 리스트 -->
  <c:choose>
    <c:when test="${not empty list}">
      <c:forEach var="item" items="${list}" varStatus="st">
        <div style="border:1px solid #E5E7EB; border-radius:12px; margin-bottom:12px; overflow:hidden;">
          <div onclick="this.parentElement.classList.toggle('open')"
               style="padding:20px 24px; cursor:pointer; display:flex; justify-content:space-between; align-items:center; font-size:16px; font-weight:600; color:#1B2A4A;">
            <span>Q. ${item.pstTitle}</span>
            <span style="color:#9CA3AF; font-size:20px;">▾</span>
          </div>
          <div class="faq-answer" style="display:none; padding:0 24px 20px; font-size:15px; color:#6B7280; line-height:1.8; border-top:1px solid #F3F4F6;">
            <div style="padding-top:16px;">${item.pstContent}</div>
          </div>
        </div>
      </c:forEach>
    </c:when>
    <c:otherwise>
      <div style="text-align:center; padding:80px 0; color:#9CA3AF; font-size:15px;">
        등록된 FAQ가 없습니다.
      </div>
    </c:otherwise>
  </c:choose>

</div>

<style>
  .open .faq-answer { display:block !important; }
  .open span:last-child { transform:rotate(180deg); }
</style>

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>
</body>
</html>
