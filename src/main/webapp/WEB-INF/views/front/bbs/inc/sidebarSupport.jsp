<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<aside class="side-nav">
  <h3 class="side-nav-title">고객지원</h3>
  <ul class="side-nav-menu">
    <li class="${activeLnb eq 'notice' ? 'active' : ''}">
      <a href="${ctx}/bbs/viewBbsNotice">공지사항</a>
    </li>
    <li class="${activeLnb eq 'faq' ? 'active' : ''}">
      <a href="${ctx}/bbs/viewBbsFaq">FAQ</a>
    </li>
    <li class="${activeLnb eq 'inquiry' ? 'active' : ''}">
      <a href="${ctx}/inquiry/viewInquiry">문의하기</a>
    </li>
  </ul>

  <div class="side-cs">
    <h4 class="side-cs-title">상담 안내</h4>
    <p class="side-cs-desc">부동산에 관한 궁금한 점이 있으시면 언제든지 연락 주세요.</p>
    <p class="side-cs-tel">032-327-1277</p>
    <div class="side-cs-info">
      FAX : 032-327-1279<br>
      운영시간 : 09:00 ~ 18:00<br>
      (주말·공휴일 휴무)
    </div>
  </div>
</aside>
