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
      <c:if test="${not empty sliderProp}">
      <div class="visual-card" style="cursor:pointer;" onclick="fnGoSliderDetail()">
        <div class="vc-header"><div class="vc-badge">${sliderProp.badgeType eq 'RECOMMEND' ? '추천 매물' : sliderProp.badgeType eq 'URGENT' ? '급매' : '추천 매물'}</div><div class="vc-type">${sliderProp.catNm} &middot; ${sliderProp.dealTypeNm}</div></div>
        <div class="vc-img i1">
          <c:choose>
            <c:when test="${not empty sliderProp.thumbPath}"><img src="/upload/${sliderProp.thumbPath}" style="width:100%;height:100%;object-fit:cover;border-radius:12px;" /></c:when>
            <c:otherwise>&#127970;</c:otherwise>
          </c:choose>
        </div>
        <div class="vc-title">${sliderProp.propNm}</div>
        <div class="vc-loc">${sliderProp.address}</div>
        <div class="vc-price">
          <span class="price-format" data-deal-type="${sliderProp.dealType}" data-sell="${sliderProp.sellPrice}" data-deposit="${sliderProp.deposit}" data-rent="${sliderProp.monthlyRent}"></span>
        </div>
        <div class="vc-stats"><span>${sliderProp.areaExclusive}&#13217;</span><c:if test="${sliderProp.roomCnt > 0}"><span>${sliderProp.roomCnt}룸</span></c:if><c:if test="${not empty sliderProp.floorNo}"><span>${sliderProp.floorNo}층</span></c:if></div>
      </div>
      </c:if>
      <c:if test="${empty sliderProp}">
      <div class="visual-card">
        <div class="vc-header"><div class="vc-badge">추천 매물</div><div class="vc-type">아파트 &middot; 매매</div></div>
        <div class="vc-img i1">&#127970;</div>
        <div class="vc-title">매물 준비중</div>
        <div class="vc-loc">프리머스 부동산</div>
        <div class="vc-price">- <small>만원</small></div>
        <div class="vc-stats"><span>-</span></div>
      </div>
      </c:if>
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
          <a href="javascript:fnGoConsult()" class="btn-outline-hero">상담 신청</a>
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
      <c:if test="${not empty latestProp}">
      <div class="visual-card" style="cursor:pointer;" onclick="fnGoLatestDetail()">
        <div class="vc-header"><div class="vc-badge" style="background:#0052A4;">인기 매물</div><div class="vc-type">${latestProp.catNm} &middot; ${latestProp.dealTypeNm}</div></div>
        <div class="vc-img i2">
          <c:choose>
            <c:when test="${not empty latestProp.thumbPath}"><img src="/upload/${latestProp.thumbPath}" style="width:100%;height:100%;object-fit:cover;border-radius:12px;" /></c:when>
            <c:otherwise>&#127980;</c:otherwise>
          </c:choose>
        </div>
        <div class="vc-title">${latestProp.propNm}</div>
        <div class="vc-loc">${latestProp.address}</div>
        <div class="vc-price">
          <span class="price-format" data-deal-type="${latestProp.dealType}" data-sell="${latestProp.sellPrice}" data-deposit="${latestProp.deposit}" data-rent="${latestProp.monthlyRent}"></span>
        </div>
        <div class="vc-stats"><span>${latestProp.areaExclusive}&#13217;</span><c:if test="${latestProp.roomCnt > 0}"><span>${latestProp.roomCnt}룸</span></c:if><c:if test="${not empty latestProp.floorNo}"><span>${latestProp.floorNo}층</span></c:if></div>
      </div>
      </c:if>
      <c:if test="${empty latestProp}">
      <div class="visual-card">
        <div class="vc-header"><div class="vc-badge" style="background:#0052A4;">인기 매물</div><div class="vc-type">아파트 &middot; 매매</div></div>
        <div class="vc-img i2">&#127980;</div>
        <div class="vc-title">매물 준비중</div>
        <div class="vc-loc">프리머스 부동산</div>
        <div class="vc-price">- <small>만원</small></div>
        <div class="vc-stats"><span>-</span></div>
      </div>
      </c:if>
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
      <c:if test="${not empty urgentProp}">
      <div class="visual-card" style="cursor:pointer;" onclick="fnGoUrgentDetail()">
        <div class="vc-header"><div class="vc-badge" style="background:#dc3545;">&#44553;&#47588;</div><div class="vc-type">${urgentProp.catNm} &middot; ${urgentProp.dealTypeNm}</div></div>
        <div class="vc-img" style="background:linear-gradient(135deg,rgba(58,122,106,0.4),rgba(91,181,160,0.25));">
          <c:choose>
            <c:when test="${not empty urgentProp.thumbPath}"><img src="/upload/${urgentProp.thumbPath}" style="width:100%;height:100%;object-fit:cover;border-radius:12px;" /></c:when>
            <c:otherwise>&#127978;</c:otherwise>
          </c:choose>
        </div>
        <div class="vc-title">${urgentProp.propNm}</div>
        <div class="vc-loc">${urgentProp.address}</div>
        <div class="vc-price">
          <span class="price-format" data-deal-type="${urgentProp.dealType}" data-sell="${urgentProp.sellPrice}" data-deposit="${urgentProp.deposit}" data-rent="${urgentProp.monthlyRent}"></span>
        </div>
        <div class="vc-stats"><span>${urgentProp.areaExclusive}&#13217;</span><c:if test="${urgentProp.roomCnt > 0}"><span>${urgentProp.roomCnt}룸</span></c:if><c:if test="${not empty urgentProp.floorNo}"><span>${urgentProp.floorNo}층</span></c:if></div>
      </div>
      </c:if>
      <c:if test="${empty urgentProp}">
      <div class="visual-card">
        <div class="vc-header"><div class="vc-badge" style="background:#dc3545;">급매</div><div class="vc-type">아파트 &middot; 매매</div></div>
        <div class="vc-img i3">&#127968;</div>
        <div class="vc-title">매물 준비중</div>
        <div class="vc-loc">프리머스 부동산</div>
        <div class="vc-price">- <small>만원</small></div>
        <div class="vc-stats"><span>-</span></div>
      </div>
      </c:if>
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
    <a href="javascript:fnGoPropertyType('all')" class="view-all">전체보기 &rarr;</a>
  </div>
  <div class="property-grid">
    <c:if test="${empty featuredList}">
      <div style="grid-column:1/-1; text-align:center; padding:40px 0; color:var(--gray-400);">추천 매물이 없습니다.</div>
    </c:if>
    <c:forEach var="fp" items="${featuredList}" varStatus="st">
      <div class="property-card reveal ${st.index == 1 ? 'reveal-delay-1' : ''} ${st.index == 2 ? 'reveal-delay-2' : ''}" style="cursor:pointer;" onclick="fnGoFeaturedDetail('${fp.catCd}','${fp.propCd}')">
        <div class="card-img">
          <c:choose>
            <c:when test="${not empty fp.thumbPath}">
              <img src="/upload/${fp.thumbPath}" style="width:100%;height:100%;object-fit:cover;" />
            </c:when>
            <c:otherwise>
              <div class="card-img-placeholder ${fn:toLowerCase(fp.catCd)}">
                <c:choose>
                  <c:when test="${fp.catCd eq 'APT'}">&#127970;</c:when>
                  <c:when test="${fp.catCd eq 'OFFICETEL'}">&#127980;</c:when>
                  <c:when test="${fp.catCd eq 'VILLA'}">&#127968;</c:when>
                  <c:when test="${fp.catCd eq 'ONEROOM'}">&#128682;</c:when>
                  <c:when test="${fp.catCd eq 'SHOP'}">&#127978;</c:when>
                  <c:when test="${fp.catCd eq 'OFFICE'}">&#127963;</c:when>
                  <c:otherwise>&#127968;</c:otherwise>
                </c:choose>
              </div>
            </c:otherwise>
          </c:choose>
          <div class="card-badge">
            <c:choose>
              <c:when test="${fp.badgeType eq 'RECOMMEND'}">추천</c:when>
              <c:when test="${fp.badgeType eq 'URGENT'}">급매</c:when>
              <c:otherwise>신규</c:otherwise>
            </c:choose>
          </div>
        </div>
        <div class="card-body">
          <div class="card-type">${fp.catNm}</div>
          <div class="card-title">${fp.propNm}</div>
          <div class="card-location">${fp.address}</div>
          <div class="card-price">
            ${fp.dealTypeNm}
            <span class="price-format" data-deal-type="${fp.dealType}" data-sell="${fp.sellPrice}" data-deposit="${fp.deposit}" data-rent="${fp.monthlyRent}"></span>
          </div>
          <div class="card-info">
            <div class="card-info-item">${fp.areaExclusive}&#13217;</div>
            <c:if test="${fp.roomCnt > 0}"><div class="card-info-item">${fp.roomCnt}룸</div></c:if>
            <c:if test="${not empty fp.floorNo}"><div class="card-info-item">${fp.floorNo}층</div></c:if>
          </div>
        </div>
      </div>
    </c:forEach>
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
<form id="sliderDetailForm" action="${ctx}/property/viewPropertyDetail" method="post" style="display:none;">
  <input type="hidden" name="type" value="${sliderProp.catCd}" />
  <input type="hidden" name="id" value="${sliderProp.propCd}" />
</form>
<form id="latestDetailForm" action="${ctx}/property/viewPropertyDetail" method="post" style="display:none;">
  <input type="hidden" name="type" value="${latestProp.catCd}" />
  <input type="hidden" name="id" value="${latestProp.propCd}" />
</form>
<form id="urgentDetailForm" action="${ctx}/property/viewPropertyDetail" method="post" style="display:none;">
  <input type="hidden" name="type" value="${urgentProp.catCd}" />
  <input type="hidden" name="id" value="${urgentProp.propCd}" />
</form>
<form id="featuredDetailForm" action="${ctx}/property/viewPropertyDetail" method="post" style="display:none;">
  <input type="hidden" name="type" id="featuredType" />
  <input type="hidden" name="id" id="featuredId" />
</form>

<script>
  function fnGoSliderDetail() {
    <c:if test="${not empty sliderProp}">
    document.getElementById('sliderDetailForm').submit();
    </c:if>
  }

  function fnGoLatestDetail() {
    <c:if test="${not empty latestProp}">
    document.getElementById('latestDetailForm').submit();
    </c:if>
  }

  function fnGoUrgentDetail() {
    <c:if test="${not empty urgentProp}">
    document.getElementById('urgentDetailForm').submit();
    </c:if>
  }

  function fnGoFeaturedDetail(propType, propCd) {
    document.getElementById('featuredType').value = propType;
    document.getElementById('featuredId').value = propCd;
    document.getElementById('featuredDetailForm').submit();
  }

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
.primus-popup-header .drag-hint {
  font-size: 11px; color: #ccc; margin-right: 8px;
}
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

/* 모바일: 화면 고정 중앙 (위치/드래그 설정 무시) */
@media (max-width: 768px) {
  .primus-popup-overlay {
    padding: 16px;
    justify-content: center !important;
    align-items: center !important;
  }
  .primus-popup-modal {
    width: 100% !important;
    max-width: 100% !important;
    height: auto !important;
    max-height: 85vh !important;
    border-radius: 12px;
    margin: 0 !important;
    position: static !important;
    left: auto !important;
    top: auto !important;
  }
  .primus-popup-header { padding: 14px 16px; cursor: default; }
  .primus-popup-title { font-size: 15px; }
  .primus-popup-body { padding: 16px; max-height: 50vh; font-size: 13px; }
  .primus-popup-footer { padding: 10px 16px; }
  .primus-popup-today span { font-size: 12px; }
  .primus-popup-close-btn { padding: 7px 18px; font-size: 12px; }
}
</style>

<script>
/* 팝업 순차 표시 (한 번에 하나씩) */
$(function() {
  var popups = [];
  $('.primus-popup-overlay').each(function() {
    var popCd = $(this).data('pop-cd');
    if (!fnIsTodayHidden(popCd)) {
      popups.push(popCd);
    }
  });

  if (popups.length > 0) {
    // 첫 번째 팝업만 표시
    fnShowPopup(popups[0]);
    $('body').css('overflow', 'hidden');
  }
});

function fnShowPopup(popCd) {
  var $overlay = $('.primus-popup-overlay[data-pop-cd="' + popCd + '"]');
  var $modal = $overlay.find('.primus-popup-modal');
  var x = parseInt($overlay.data('x')) || 0;
  var y = parseInt($overlay.data('y')) || 0;

  // 모바일이 아닐 때만 위치 적용
  if ((x > 0 || y > 0) && window.innerWidth > 768) {
    $overlay.css({ 'justify-content': 'flex-start', 'align-items': 'flex-start' });
    $modal.css({ 'margin-left': x + 'px', 'margin-top': y + 'px' });
  }
  $overlay.show();

  // 드래그 가능하게 설정 (PC만)
  if (window.innerWidth > 768) {
    fnMakeDraggable($overlay, $modal);
  }
}

/* 모달 드래그 이동 */
function fnMakeDraggable($overlay, $modal) {
  var $header = $modal.find('.primus-popup-header');
  var isDragging = false;
  var startX, startY, origLeft, origTop;

  // 드래그 시작 시 position 전환
  function initPosition() {
    if ($modal.css('position') !== 'absolute' && $modal.css('position') !== 'fixed') {
      var rect = $modal[0].getBoundingClientRect();
      $overlay.css({ 'justify-content': 'flex-start', 'align-items': 'flex-start' });
      $modal.css({
        'position': 'fixed',
        'left': rect.left + 'px',
        'top': rect.top + 'px',
        'margin': '0'
      });
    }
  }

  $header.on('mousedown', function(e) {
    if (e.target.closest('.primus-popup-close')) return; // X 버튼 클릭은 무시
    e.preventDefault();
    initPosition();
    isDragging = true;
    startX = e.clientX;
    startY = e.clientY;
    origLeft = parseInt($modal.css('left')) || 0;
    origTop = parseInt($modal.css('top')) || 0;
  });

  $(document).on('mousemove.popup', function(e) {
    if (!isDragging) return;
    var dx = e.clientX - startX;
    var dy = e.clientY - startY;
    $modal.css({ 'left': (origLeft + dx) + 'px', 'top': (origTop + dy) + 'px' });
  });

  $(document).on('mouseup.popup', function() {
    isDragging = false;
  });

  // 터치 지원 (태블릿)
  $header.on('touchstart', function(e) {
    if (e.target.closest('.primus-popup-close')) return;
    initPosition();
    isDragging = true;
    var touch = e.originalEvent.touches[0];
    startX = touch.clientX;
    startY = touch.clientY;
    origLeft = parseInt($modal.css('left')) || 0;
    origTop = parseInt($modal.css('top')) || 0;
  });

  $(document).on('touchmove.popup', function(e) {
    if (!isDragging) return;
    var touch = e.originalEvent.touches[0];
    var dx = touch.clientX - startX;
    var dy = touch.clientY - startY;
    $modal.css({ 'left': (origLeft + dx) + 'px', 'top': (origTop + dy) + 'px' });
  });

  $(document).on('touchend.popup', function() {
    isDragging = false;
  });
}

/* 팝업 닫기 → 체크박스 확인 후 쿠키 세팅 → 다음 팝업 표시 */
function fnClosePopup(popCd) {
  var $overlay = $('.primus-popup-overlay[data-pop-cd="' + popCd + '"]');

  // 오늘 하루 보지 않기 체크 여부 확인
  var $chk = $overlay.find('.pop-today-chk');
  if ($chk.length && $chk.is(':checked')) {
    var today = new Date();
    today.setHours(23, 59, 59, 999);
    document.cookie = 'popHide_' + popCd + '=Y; expires=' + today.toUTCString() + '; path=/';
  }

  $overlay.fadeOut(200, function() {
    $overlay.data('closed', true);

    // 다음 팝업 찾기
    var found = false;
    $('.primus-popup-overlay').each(function() {
      if (found) return;
      var cd = $(this).data('pop-cd');
      if (cd === popCd) return;
      if ($(this).data('closed')) return;
      if (!fnIsTodayHidden(cd)) {
        fnShowPopup(cd);
        found = true;
      }
    });

    if (!found) {
      $('body').css('overflow', '');
    }
  });
}

function fnIsTodayHidden(popCd) {
  return document.cookie.indexOf('popHide_' + popCd + '=Y') > -1;
}

/* ESC로 팝업 닫기 */
$(document).on('keydown', function(e) {
  if (e.keyCode === 27) {
    var $visible = $('.primus-popup-overlay:visible').last();
    if ($visible.length) fnClosePopup($visible.data('pop-cd'));
  }
});

/* 오버레이 클릭으로 닫기 (드래그 중이 아닐 때만) */
var popMouseDownTarget = null;
$(document).on('mousedown', '.primus-popup-overlay', function(e) { popMouseDownTarget = e.target; });
$(document).on('mouseup', '.primus-popup-overlay', function(e) {
  if (e.target === this && popMouseDownTarget === this) {
    fnClosePopup($(this).data('pop-cd'));
  }
  popMouseDownTarget = null;
});
</script>

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>

</body>
</html>
