<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이동 중...</title>
</head>
<body>
<p style="text-align:center; padding:50px; color:#666;">잠시만 기다려 주세요...</p>

<form id="postRedirectForm" method="post" action="${pageContext.request.contextPath}${lastViewPage.url}">
  <c:if test="${not empty lastViewPage.type}">
    <input type="hidden" name="type" value="${lastViewPage.type}" />
  </c:if>
  <c:if test="${not empty lastViewPage.id}">
    <input type="hidden" name="id" value="${lastViewPage.id}" />
  </c:if>
  <c:if test="${not empty lastViewPage.brdCd}">
    <input type="hidden" name="brdCd" value="${lastViewPage.brdCd}" />
  </c:if>
  <c:if test="${not empty lastViewPage.pstCd}">
    <input type="hidden" name="pstCd" value="${lastViewPage.pstCd}" />
  </c:if>
  <c:if test="${not empty lastViewPage.pageNo}">
    <input type="hidden" name="pageNo" value="${lastViewPage.pageNo}" />
  </c:if>
</form>

<script>
  document.getElementById('postRedirectForm').submit();
</script>
</body>
</html>
