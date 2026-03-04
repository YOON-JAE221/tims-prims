<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<aside class="lnb">
  <h3 class="lnb-title">ENGINEERING</h3>
  <ul class="lnb-menu">
    <li class="${activeLnb eq 'stra' ? 'active' : ''}">
      <a href="${ctx}/bbs/viewBbsStra">구조설계</a>
    </li>
    <li class="${activeLnb eq 'stre' ? 'active' : ''}">
      <a href="${ctx}/bbs/viewBbsStre">구조검토</a>
    </li>
    <li class="${activeLnb eq 'dise' ? 'active' : ''}">
      <a href="${ctx}/bbs/viewBbsDise">해체검토</a>
    </li>
    <li class="${activeLnb eq 'safe' ? 'active' : ''}">
      <a href="${ctx}/bbs/viewBbsSafe">안전진단</a>
    </li>
    <li class="${activeLnb eq 'spfe' ? 'active' : ''}">
      <a href="${ctx}/bbs/viewBbsSpfe">내진성능평가</a>
    </li>
    <li class="${activeLnb eq 'tere' ? 'active' : ''}">
      <a href="${ctx}/bbs/viewBbsTere">가설재설계</a>
    </li>
    <li class="${activeLnb eq 'vera' ? 'active' : ''}">
      <a href="${ctx}/bbs/viewBbsVera">VE설계</a>
    </li>
    <li class="${activeLnb eq 'sdse' ? 'active' : ''}">
      <a href="${ctx}/bbs/viewBbsSdse">비구조요소 내진설계</a>
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
