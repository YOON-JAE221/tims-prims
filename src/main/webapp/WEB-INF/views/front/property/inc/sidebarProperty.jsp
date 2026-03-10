<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<aside class="side-nav">
  <h3 class="side-nav-title">매물유형</h3>
  <ul class="side-nav-menu">
    <li class="${empty type or type eq 'all' ? 'active' : ''}">
      <a href="javascript:fnGoType('all')">전체매물</a>
    </li>
    <c:forEach var="cat" items="${catList}">
      <li class="${fn:toLowerCase(type) eq fn:toLowerCase(cat.CAT_CD) ? 'active' : ''}">
        <a href="javascript:fnGoType('${fn:toLowerCase(cat.CAT_CD)}')">${cat.CAT_NM}</a>
      </li>
    </c:forEach>
  </ul>

  <div class="side-cs">
    <h4 class="side-cs-title">매물 문의</h4>
    <p class="side-cs-desc">원하시는 매물이 없으시면 전화 또는 온라인으로 문의해 주세요.</p>
    <p class="side-cs-tel">032-327-1277</p>
    <a href="javascript:fnGoConsult()" class="side-cs-btn">상담 신청하기</a>
  </div>
</aside>

<form id="goTypeForm" action="${ctx}/property/viewPropertyList" method="post">
  <input type="hidden" name="type" id="goTypeVal" />
</form>

<script>
  function fnGoType(t) {
    $('#goTypeVal').val(t);
    $('#goTypeForm').submit();
  }
</script>
