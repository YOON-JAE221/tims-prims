<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<aside class="lnb">
  <h3 class="lnb-title">회사소개</h3>
  <ul class="lnb-menu">
    <li class="${activeLnb eq 'greeting' ? 'active' : ''}">
      <a href="${ctx}/greeting/viewGreeting">인사말</a>
    </li>
    <li class="${activeLnb eq 'comHistory' ? 'active' : ''}">
      <a href="${ctx}/comHistory/viewComHistory">연혁</a>
    </li>
    <li class="${activeLnb eq 'locGuide' ? 'active' : ''}">
      <a href="${ctx}/locGuide/viewLocGuide">찾아오시는길</a>
    </li>
  </ul>

  <div class="lnb-cs">
    <h4 class="lnb-csTitle">Customer Center</h4>
    <p class="lnb-csDesc">구조설계 및 안전진단에 관한 문의사항이 있으시면 언제든지 연락 주시기 바랍니다.</p>
    <div class="lnb-csInfo">
      <p class="lnb-csTel"><strong>HP : 010-5093-1443</strong></p>
      <p class="lnb-csTel"><strong>TEL : 070-7640-1002</strong></p>
      <p class="lnb-csFax"><strong>FAX : 070-7640-1003</strong></p>
      <p class="lnb-csEmail">kanghanstr@naver.com</p>
      <p class="lnb-csTime">운영시간 : 09:00 ~ 18:00</p>
    </div>
  </div>
</aside>
