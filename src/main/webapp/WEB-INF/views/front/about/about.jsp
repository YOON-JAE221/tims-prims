<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>

<!-- 페이지 헤더 -->
<div class="page-header" style="padding:40px 24px;">
  <h2>회사소개</h2>
</div>

<!-- ===== 회사소개 (메인에 있던 그대로) ===== -->
<section class="about-section" style="padding-top:60px;">
  <div class="about-inner">
    <div class="about-img reveal" style="background:none; overflow:hidden;">
      <img src="${ctx}/resources/front/img/logo/primus-brand.png" alt="PRIMUS PROPERTY" style="width:100%; height:100%; object-fit:cover; border-radius:20px;" />
      <div class="about-img-badge">Since 2022</div>
    </div>
    <div class="about-content reveal reveal-delay-1">
      <div class="section-label">회사소개</div>
      <h2 class="section-title">신뢰와 전문성으로<br>고객과 함께합니다</h2>
      <p class="about-text">프리머스 부동산은 부천 중동을 중심으로 아파트, 오피스텔, 상가, 사무실 등 다양한 부동산 거래를 전문으로 하는 공인중개사 사무소입니다.</p>
      <p class="about-text">오랜 현장 경험과 지역 시장에 대한 깊은 이해를 바탕으로, 고객 한 분 한 분께 맞춤형 부동산 솔루션을 제공합니다. 단순한 중개를 넘어 계약 전 시세 분석부터 계약 후 입주·사후관리까지 전 과정을 책임지고 함께합니다.</p>
      <p class="about-text">'정직한 거래, 투명한 정보'를 경영 원칙으로 삼아 고객의 소중한 자산을 안전하게 지켜드리겠습니다.</p>
      <div class="about-features">
        <div class="about-feature"><div class="about-feature-icon">✓</div>부천 지역 전문</div>
        <div class="about-feature"><div class="about-feature-icon">✓</div>투명한 시세 분석</div>
        <div class="about-feature"><div class="about-feature-icon">✓</div>정직한 거래</div>
        <div class="about-feature"><div class="about-feature-icon">✓</div>사후 관리 책임</div>
      </div>
      <div class="about-ceo">
        <div class="about-ceo-avatar">박</div>
        <div class="about-ceo-info"><div class="name">박세환 대표</div><div class="role">공인중개사 · 프리머스 부동산 대표</div></div>
      </div>
    </div>
  </div>
</section>

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>

</body>
</html>
