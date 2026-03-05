<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<aside class="side-nav">
  <h3 class="side-nav-title">매물유형</h3>
  <ul class="side-nav-menu">
    <li class="${type eq 'all' ? 'active' : ''}">
      <a href="javascript:fnGoType('all')">전체매물</a>
    </li>
    <li class="${type eq 'apt' ? 'active' : ''}">
      <a href="javascript:fnGoType('apt')">아파트</a>
    </li>
    <li class="${type eq 'officetel' ? 'active' : ''}">
      <a href="javascript:fnGoType('officetel')">오피스텔</a>
    </li>
    <li class="${type eq 'shop' ? 'active' : ''}">
      <a href="javascript:fnGoType('shop')">상가</a>
    </li>
    <li class="${type eq 'office' ? 'active' : ''}">
      <a href="javascript:fnGoType('office')">사무실</a>
    </li>
  </ul>

  <div class="side-cs">
    <h4 class="side-cs-title">매물 문의</h4>
    <p class="side-cs-desc">원하시는 매물이 없으시면 전화 또는 온라인으로 문의해 주세요.</p>
    <p class="side-cs-tel">032-327-1277</p>
    <div class="side-cs-info">
      FAX : 032-327-1279<br>
      운영시간 : 09:00 ~ 18:00<br>
      (주말·공휴일 휴무)
    </div>
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
