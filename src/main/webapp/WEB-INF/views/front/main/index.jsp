<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>

<!-- ===== HERO SLIDER ===== -->
<section class="hero">

  <!-- Slide 1 -->
  <div class="hero-slide active">
    <div class="slide-bg s1"></div>
    <div class="slide-grid"></div>
    <div class="slide-orb orb-a"></div>
    <div class="slide-orb orb-b"></div>
    <div class="slide-shape sh1"></div>
    <div class="slide-shape sh3"></div>
    <div class="slide-shape sh5"></div>
    <div class="slide-overlay"></div>

    <div class="slide-visual">
      <div class="visual-card">
        <div class="vc-header"><div class="vc-badge">추천 매물</div><div class="vc-type">아파트 · 매매</div></div>
        <div class="vc-img i1">🏢</div>
        <div class="vc-title">프리머스타워 32평</div>
        <div class="vc-loc">📍 부천시 길주로 280</div>
        <div class="vc-price">5억 2,000 <small>만원</small></div>
        <div class="vc-stats"><span>🏠 32평</span><span>🚪 3룸</span><span>📐 15층</span></div>
      </div>
    </div>

    <div class="float-card" style="right:38%;bottom:14%;">
      <div class="fc-icon">🛡️</div>
      <div class="fc-text">안심 거래 보장</div>
      <div class="fc-sub">권리분석 무료 제공</div>
    </div>

    <div class="slide-content">
      <div class="slide-text">
        <div class="slide-badge">부천 중동 프리머스타워 1층</div>
        <h1>부천의 부동산,<br><em>프리머스</em>에 맡기세요</h1>
        <p>아파트, 오피스텔, 상가, 사무실까지<br>부천 지역 전문 공인중개사가 함께합니다.</p>
        <div class="slide-actions">
          <a href="${ctx}/property/viewPropertyList" class="btn-primary-primus">매물 둘러보기</a>
          <a href="${ctx}/bbs/viewBbsWriteQna?brdCd=3ccd942dfcbf11f08771908d6ec6e544" class="btn-outline-hero">상담 신청</a>
          <div class="slide-phone"><div class="slide-phone-icon">📞</div>032-327-1277</div>
        </div>
      </div>
    </div>
  </div>

  <!-- Slide 2 -->
  <div class="hero-slide">
    <div class="slide-bg s2"></div>
    <div class="slide-grid"></div>
    <div class="slide-orb orb-c"></div>
    <div class="slide-orb orb-d"></div>
    <div class="slide-shape sh2"></div>
    <div class="slide-shape sh4"></div>
    <div class="slide-overlay"></div>

    <div class="slide-visual">
      <div class="visual-card">
        <div class="vc-header"><div class="vc-badge">신규 매물</div><div class="vc-type">오피스텔 · 월세</div></div>
        <div class="vc-img i2">🏬</div>
        <div class="vc-title">중동역 스카이뷰</div>
        <div class="vc-loc">📍 부천시 중동로 45</div>
        <div class="vc-price">500/60 <small>만원</small></div>
        <div class="vc-stats"><span>🏠 12평</span><span>🚪 원룸</span><span>📐 8층</span></div>
      </div>
    </div>

    <div class="float-card" style="right:36%;bottom:12%;animation-delay:1s;">
      <div class="fc-icon">🔑</div>
      <div class="fc-text">즉시 입주 가능</div>
      <div class="fc-sub">입주 상담 접수 중</div>
    </div>

    <div class="slide-content">
      <div class="slide-text">
        <div class="slide-badge">매매 · 전세 · 월세</div>
        <h1>믿을 수 있는<br><em>부동산 파트너</em></h1>
        <p>풍부한 경험과 정확한 시세 분석으로<br>최적의 매물을 추천해 드립니다.</p>
        <div class="slide-actions">
          <a href="${ctx}/property/viewPropertyList" class="btn-primary-primus">추천매물 보기</a>
          <a href="${ctx}/about/viewAbout" class="btn-outline-hero">회사소개</a>
        </div>
      </div>
    </div>
  </div>

  <!-- Slide 3 -->
  <div class="hero-slide">
    <div class="slide-bg s3"></div>
    <div class="slide-grid"></div>
    <div class="slide-orb orb-e"></div>
    <div class="slide-orb orb-b" style="left:30%;"></div>
    <div class="slide-shape sh1" style="top:15%;right:20%;width:160px;height:160px;"></div>
    <div class="slide-shape sh2" style="bottom:25%;right:40%;"></div>
    <div class="slide-overlay"></div>

    <div class="slide-visual">
      <div class="visual-card">
        <div class="vc-header"><div class="vc-badge">급매</div><div class="vc-type">상가 · 월세</div></div>
        <div class="vc-img" style="background:linear-gradient(135deg,rgba(58,122,106,0.4),rgba(91,181,160,0.25));">🏪</div>
        <div class="vc-title">신중동역 로데오 상가</div>
        <div class="vc-loc">📍 부천시 부천로 98</div>
        <div class="vc-price">3,000/180 <small>만원</small></div>
        <div class="vc-stats"><span>🏠 18평</span><span>🚪 1층</span><span>📐 코너</span></div>
      </div>
    </div>

    <div class="float-card" style="right:30%;top:18%;animation-delay:0.5s;">
      <div class="fc-icon">💬</div>
      <div class="fc-text">24시간 접수 가능</div>
      <div class="fc-sub">온라인 상담</div>
    </div>
    <div class="float-card" style="right:32%;bottom:22%;animation-delay:1.5s;">
      <div class="fc-icon">🏠</div>
      <div class="fc-text">맞춤 매물 추천</div>
      <div class="fc-sub">무료 상담</div>
    </div>

    <div class="slide-content">
      <div class="slide-text">
        <div class="slide-badge">무료 상담 접수 중</div>
        <h1>부동산 고민,<br><em>지금 바로</em> 상담하세요</h1>
        <p>매매, 전세, 월세 무엇이든 편하게 문의해 주세요.<br>빠르고 친절하게 답변드리겠습니다.</p>
        <div class="slide-actions">
          <a href="${ctx}/bbs/viewBbsQna" class="btn-primary-primus">온라인 문의하기</a>
          <a href="${ctx}/locGuide/viewLocGuide" class="btn-outline-hero">오시는 길</a>
          <div class="slide-phone"><div class="slide-phone-icon">📞</div>032-327-1277</div>
        </div>
      </div>
    </div>
  </div>

  <button class="slider-arrow prev" onclick="slideMove(-1)">‹</button>
  <button class="slider-arrow next" onclick="slideMove(1)">›</button>
  <div class="slider-dots">
    <button class="slider-dot active" onclick="slideTo(0)"></button>
    <button class="slider-dot" onclick="slideTo(1)"></button>
    <button class="slider-dot" onclick="slideTo(2)"></button>
  </div>
</section>

<!-- ===== 추천매물 ===== -->
<section class="property-section">
  <div class="section-header">
    <div>
      <div class="section-label">추천 매물</div>
      <h2 class="section-title">지금 주목할 매물</h2>
      <p class="section-desc">프리머스 부동산이 엄선한 최신 매물을 확인하세요.</p>
    </div>
    <a href="${ctx}/property/viewPropertyList" class="view-all">전체보기 →</a>
  </div>
  <div class="property-grid">
    <div class="property-card reveal">
      <div class="card-img"><div class="card-img-placeholder apt">🏢</div><div class="card-badge">추천</div></div>
      <div class="card-body">
        <div class="card-type">아파트</div>
        <div class="card-title">부천 중동 프리머스타워</div>
        <div class="card-location">📍 부천시 길주로 280</div>
        <div class="card-price">매매 5억 2,000<span>만원</span></div>
        <div class="card-info"><div class="card-info-item">🏠 32평</div><div class="card-info-item">🚪 3룸</div><div class="card-info-item">📐 15층</div></div>
      </div>
    </div>
    <div class="property-card reveal reveal-delay-1">
      <div class="card-img"><div class="card-img-placeholder officetel">🏬</div><div class="card-badge">신규</div></div>
      <div class="card-body">
        <div class="card-type">오피스텔</div>
        <div class="card-title">중동역 스카이뷰 오피스텔</div>
        <div class="card-location">📍 부천시 중동로 45</div>
        <div class="card-price">월세 500/60<span>만원</span></div>
        <div class="card-info"><div class="card-info-item">🏠 12평</div><div class="card-info-item">🚪 원룸</div><div class="card-info-item">📐 8층</div></div>
      </div>
    </div>
    <div class="property-card reveal reveal-delay-2">
      <div class="card-img"><div class="card-img-placeholder shop">🏪</div><div class="card-badge">급매</div></div>
      <div class="card-body">
        <div class="card-type">상가</div>
        <div class="card-title">신중동역 로데오 상가 1층</div>
        <div class="card-location">📍 부천시 부천로 98</div>
        <div class="card-price">보증금 3,000/180<span>만원</span></div>
        <div class="card-info"><div class="card-info-item">🏠 18평</div><div class="card-info-item">🚪 1층</div><div class="card-info-item">📐 코너</div></div>
      </div>
    </div>
  </div>
</section>

<!-- ===== 왜 프리머스인가 ===== -->
<section class="trust-section">
  <div class="trust-inner">
    <div class="trust-header reveal">
      <div class="section-label">WHY PRIMUS</div>
      <h2 class="section-title">프리머스 부동산을<br>선택해야 하는 이유</h2>
      <p class="section-desc">고객의 소중한 자산, 전문가의 눈으로 지켜드립니다.</p>
    </div>
    <div class="trust-grid">
      <div class="trust-card reveal">
        <div class="trust-card-icon">🏠</div>
        <h3 class="trust-card-title">부천 지역 전문</h3>
        <p class="trust-card-desc">부천 중동을 중심으로 오랜 현장 경험과 지역 시장에 대한 깊은 이해를 바탕으로 최적의 매물을 추천합니다.</p>
      </div>
      <div class="trust-card reveal reveal-delay-1">
        <div class="trust-card-icon">🛡️</div>
        <h3 class="trust-card-title">안심 거래 보장</h3>
        <p class="trust-card-desc">계약 전 등기부등본 분석, 권리관계 검토를 무료로 제공하여 안전한 거래를 보장합니다.</p>
      </div>
      <div class="trust-card reveal reveal-delay-2">
        <div class="trust-card-icon">📊</div>
        <h3 class="trust-card-title">투명한 시세 분석</h3>
        <p class="trust-card-desc">실거래가 데이터 기반의 정확한 시세 분석으로 합리적인 가격에 거래할 수 있도록 도와드립니다.</p>
      </div>
      <div class="trust-card reveal reveal-delay-3">
        <div class="trust-card-icon">🤝</div>
        <h3 class="trust-card-title">사후관리까지 책임</h3>
        <p class="trust-card-desc">계약 완료 후에도 입주·이사·하자 등 사후관리까지 끝까지 책임지고 함께합니다.</p>
      </div>
    </div>
  </div>
</section>

<!-- 슬라이더 JS -->
<script>
  var currentSlide = 0;
  var slides = document.querySelectorAll('.hero-slide');
  var dots = document.querySelectorAll('.slider-dot');
  var sliderTimer;

  function slideTo(i) {
    slides[currentSlide].classList.remove('active');
    dots[currentSlide].classList.remove('active');
    currentSlide = i;
    slides[currentSlide].classList.add('active');
    dots[currentSlide].classList.add('active');
  }

  function slideMove(dir) {
    var next = (currentSlide + dir + slides.length) % slides.length;
    slideTo(next);
    resetSliderTimer();
  }

  function resetSliderTimer() {
    clearInterval(sliderTimer);
    sliderTimer = setInterval(function() { slideMove(1); }, 5000);
  }
  resetSliderTimer();
</script>

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>

</body>
</html>
