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

    <div class="slide-features">
      <div class="feature-card fc1">
        <div class="feature-icon">🏠</div>
        <div class="feature-text">부천 지역 전문</div>
      </div>
      <div class="feature-card fc2">
        <div class="feature-icon">🛡️</div>
        <div class="feature-text">안심 거래 보장</div>
      </div>
      <div class="feature-card fc3">
        <div class="feature-icon">📊</div>
        <div class="feature-text">무료 시세 분석</div>
      </div>
    </div>

    <div class="slide-content">
      <div class="slide-text">
        <div class="slide-badge">부천 중동 프리머스타워 1층</div>
        <h1>부천의 부동산,<br><em>프리머스</em>에 맡기세요</h1>
        <p>아파트, 오피스텔, 상가, 사무실까지<br>부천 지역 전문 공인중개사가 함께합니다.</p>
        <div class="slide-actions">
          <a href="${ctx}/property/viewPropertyList" class="btn-primary-primus">매물 안내</a>
          <a href="${ctx}/bbs/viewBbsQna" class="btn-outline-hero">상담 신청</a>
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

    <div class="slide-features">
      <div class="feature-card fc1">
        <div class="feature-icon">📋</div>
        <div class="feature-text">권리분석 무료</div>
      </div>
      <div class="feature-card fc2">
        <div class="feature-icon">🤝</div>
        <div class="feature-text">사후관리 책임</div>
      </div>
      <div class="feature-card fc3">
        <div class="feature-icon">💬</div>
        <div class="feature-text">친절한 상담</div>
      </div>
    </div>

    <div class="slide-content">
      <div class="slide-text">
        <div class="slide-badge">매매 · 전세 · 월세</div>
        <h1>믿을 수 있는<br><em>부동산 파트너</em></h1>
        <p>풍부한 경험과 정확한 시세 분석으로<br>최적의 선택을 도와드립니다.</p>
        <div class="slide-actions">
          <a href="${ctx}/about/viewAbout" class="btn-primary-primus">회사 소개</a>
          <a href="${ctx}/locGuide/viewLocGuide" class="btn-outline-hero">오시는 길</a>
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

    <div class="slide-features">
      <div class="feature-card fc1">
        <div class="feature-icon">🏢</div>
        <div class="feature-text">아파트</div>
      </div>
      <div class="feature-card fc2">
        <div class="feature-icon">🏪</div>
        <div class="feature-text">상가</div>
      </div>
      <div class="feature-card fc3">
        <div class="feature-icon">🏬</div>
        <div class="feature-text">오피스텔</div>
      </div>
    </div>

    <div class="slide-content">
      <div class="slide-text">
        <div class="slide-badge">무료 상담 접수 중</div>
        <h1>부동산 고민,<br><em>지금 바로</em> 상담하세요</h1>
        <p>매매, 전세, 월세 무엇이든 편하게 문의해 주세요.<br>빠르고 친절하게 답변드리겠습니다.</p>
        <div class="slide-actions">
          <a href="${ctx}/bbs/viewBbsQna" class="btn-primary-primus">온라인 문의</a>
          <a href="tel:032-327-1277" class="btn-outline-hero">전화 상담</a>
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

<!-- ===== 서비스 소개 ===== -->
<section class="trust-section">
  <div class="trust-inner">
    <div class="trust-header reveal">
      <div class="section-label">OUR SERVICE</div>
      <h2 class="section-title">프리머스 부동산<br>전문 서비스</h2>
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
      <div class="trust-card reveal">
        <div class="trust-card-icon">🏪</div>
        <h3 class="trust-card-title">상가 전문 컨설팅</h3>
        <p class="trust-card-desc">업종별 상권 분석과 수익률 검토를 통해 최적의 상가 매물을 추천해 드립니다.</p>
      </div>
      <div class="trust-card reveal reveal-delay-1">
        <div class="trust-card-icon">📋</div>
        <h3 class="trust-card-title">임대차 관리</h3>
        <p class="trust-card-desc">임대인/임차인 모두를 위한 체계적인 임대차 계약 관리 서비스입니다.</p>
      </div>
      <div class="trust-card reveal reveal-delay-2">
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

<!-- ===== 모달 팝업 ===== -->
<c:if test="${not empty popupList}">
<c:forEach var="pop" items="${popupList}" varStatus="st">
<div class="primus-popup-overlay" data-pop-cd="${pop.popCd}" style="display:none;"
     data-x="${pop.popXLoc}" data-y="${pop.popYLoc}">
  <div class="primus-popup-modal"
       style="width:${not empty pop.popWidth ? pop.popWidth : 520}px;
              <c:if test="${not empty pop.popHgt && pop.popHgt > 0}">height:${pop.popHgt}px;</c:if>
              max-height:90vh;">
    <div class="primus-popup-header">
      <span class="primus-popup-title">${pop.popNm}</span>
      <button type="button" class="primus-popup-close" onclick="fnClosePopup('${pop.popCd}')">&times;</button>
    </div>
    <div class="primus-popup-body">${pop.popCnts}</div>
    <div class="primus-popup-footer">
      <label class="primus-popup-today">
        <input type="checkbox" class="pop-today-chk" data-pop-cd="${pop.popCd}" />
        <span>오늘 하루 보지 않기</span>
      </label>
      <button type="button" class="primus-popup-close-btn" onclick="fnClosePopup('${pop.popCd}')">닫기</button>
    </div>
  </div>
</div>
</c:forEach>
</c:if>

<style>
.primus-popup-overlay {
  position: fixed; inset: 0; z-index: 9999;
  background: rgba(0,0,0,0.45); backdrop-filter: blur(3px);
  display: flex; align-items: center; justify-content: center;
  padding: 20px;
  animation: popOverlayIn 0.25s ease;
}
@keyframes popOverlayIn { from { opacity: 0; } to { opacity: 1; } }

.primus-popup-modal {
  background: #fff; border-radius: 16px;
  box-shadow: 0 12px 48px rgba(0,0,0,0.2);
  display: flex; flex-direction: column;
  overflow: hidden; max-width: 100%;
  animation: popModalIn 0.3s ease;
}
@keyframes popModalIn { from { opacity: 0; transform: translateY(24px) scale(0.97); } to { opacity: 1; transform: none; } }

.primus-popup-header {
  display: flex; align-items: center; justify-content: space-between;
  padding: 18px 24px; border-bottom: 1px solid #eee;
  flex-shrink: 0;
  cursor: grab; user-select: none;
}
.primus-popup-header:active { cursor: grabbing; }
.primus-popup-title {
  font-size: 16px; font-weight: 700; color: #1a2332;
  overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
}
.primus-popup-close {
  background: none; border: none; font-size: 24px; color: #999;
  cursor: pointer; line-height: 1; padding: 0 2px; flex-shrink: 0;
}
.primus-popup-close:hover { color: #333; }

.primus-popup-body {
  flex: 1; overflow-y: auto; padding: 24px;
  font-size: 14px; color: #444; line-height: 1.7;
  max-height: 60vh;
}
.primus-popup-body img { max-width: 100%; height: auto; border-radius: 8px; }

.primus-popup-footer {
  display: flex; align-items: center; justify-content: space-between;
  padding: 12px 24px; border-top: 1px solid #eee; background: #fafafa;
  flex-shrink: 0;
}
.primus-popup-today {
  display: flex; align-items: center; gap: 6px;
  font-size: 13px; color: #888; cursor: pointer;
}
.primus-popup-today input { width: 16px; height: 16px; accent-color: var(--orange); }
.primus-popup-close-btn {
  padding: 8px 24px; font-size: 13px; font-weight: 600;
  color: #fff; background: var(--navy); border: none; border-radius: 8px;
  cursor: pointer; font-family: inherit; transition: background 0.15s;
}
.primus-popup-close-btn:hover { background: #1a2a4a; }

@media (max-width: 768px) {
  .primus-popup-overlay { padding: 16px; justify-content: center !important; align-items: center !important; }
  .primus-popup-modal { width: 100% !important; max-width: 100% !important; height: auto !important; max-height: 85vh !important; border-radius: 12px; margin: 0 !important; position: static !important; }
  .primus-popup-header { padding: 14px 16px; cursor: default; }
  .primus-popup-title { font-size: 15px; }
  .primus-popup-body { padding: 16px; max-height: 50vh; font-size: 13px; }
  .primus-popup-footer { padding: 10px 16px; }
  .primus-popup-today span { font-size: 12px; }
  .primus-popup-close-btn { padding: 7px 18px; font-size: 12px; }
}
</style>

<script>
$(function() {
  var popups = [];
  $('.primus-popup-overlay').each(function() {
    var popCd = $(this).data('pop-cd');
    if (!fnIsTodayHidden(popCd)) popups.push(popCd);
  });
  if (popups.length > 0) {
    fnShowPopup(popups[0]);
    $('body').css('overflow', 'hidden');
  }
});

function fnShowPopup(popCd) {
  var $overlay = $('.primus-popup-overlay[data-pop-cd="' + popCd + '"]');
  var $modal = $overlay.find('.primus-popup-modal');
  var x = parseInt($overlay.data('x')) || 0;
  var y = parseInt($overlay.data('y')) || 0;
  if ((x > 0 || y > 0) && window.innerWidth > 768) {
    $overlay.css({ 'justify-content': 'flex-start', 'align-items': 'flex-start' });
    $modal.css({ 'margin-left': x + 'px', 'margin-top': y + 'px' });
  }
  $overlay.show();
  if (window.innerWidth > 768) fnMakeDraggable($overlay, $modal);
}

function fnMakeDraggable($overlay, $modal) {
  var $header = $modal.find('.primus-popup-header');
  var isDragging = false, startX, startY, origLeft, origTop;
  function initPosition() {
    if ($modal.css('position') !== 'absolute' && $modal.css('position') !== 'fixed') {
      var rect = $modal[0].getBoundingClientRect();
      $overlay.css({ 'justify-content': 'flex-start', 'align-items': 'flex-start' });
      $modal.css({ 'position': 'fixed', 'left': rect.left + 'px', 'top': rect.top + 'px', 'margin': '0' });
    }
  }
  $header.on('mousedown', function(e) {
    if (e.target.closest('.primus-popup-close')) return;
    e.preventDefault(); initPosition(); isDragging = true;
    startX = e.clientX; startY = e.clientY;
    origLeft = parseInt($modal.css('left')) || 0; origTop = parseInt($modal.css('top')) || 0;
  });
  $(document).on('mousemove.popup', function(e) {
    if (!isDragging) return;
    $modal.css({ 'left': (origLeft + e.clientX - startX) + 'px', 'top': (origTop + e.clientY - startY) + 'px' });
  });
  $(document).on('mouseup.popup', function() { isDragging = false; });
}

function fnClosePopup(popCd) {
  var $overlay = $('.primus-popup-overlay[data-pop-cd="' + popCd + '"]');
  var $chk = $overlay.find('.pop-today-chk');
  if ($chk.length && $chk.is(':checked')) {
    var today = new Date(); today.setHours(23, 59, 59, 999);
    document.cookie = 'popHide_' + popCd + '=Y; expires=' + today.toUTCString() + '; path=/';
  }
  $overlay.fadeOut(200, function() {
    $overlay.data('closed', true);
    var found = false;
    $('.primus-popup-overlay').each(function() {
      if (found) return;
      var cd = $(this).data('pop-cd');
      if (cd !== popCd && !$(this).data('closed') && !fnIsTodayHidden(cd)) { fnShowPopup(cd); found = true; }
    });
    if (!found) $('body').css('overflow', '');
  });
}

function fnIsTodayHidden(popCd) { return document.cookie.indexOf('popHide_' + popCd + '=Y') > -1; }

$(document).on('keydown', function(e) {
  if (e.keyCode === 27) {
    var $visible = $('.primus-popup-overlay:visible').last();
    if ($visible.length) fnClosePopup($visible.data('pop-cd'));
  }
});

var popMouseDownTarget = null;
$(document).on('mousedown', '.primus-popup-overlay', function(e) { popMouseDownTarget = e.target; });
$(document).on('mouseup', '.primus-popup-overlay', function(e) {
  if (e.target === this && popMouseDownTarget === this) fnClosePopup($(this).data('pop-cd'));
  popMouseDownTarget = null;
});
</script>

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>

</body>
</html>
