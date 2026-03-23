<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>

<div class="page-header">
  <h2>매물 상세</h2>
</div>

<c:if test="${empty prop}">
<div style="max-width:1200px;margin:0 auto;padding:80px 24px;text-align:center;color:var(--gray-400);">
  매물 정보를 찾을 수 없습니다.
  <br><br>
  <button type="button" class="btn-primary-primus" onclick="history.back()">돌아가기</button>
</div>
</c:if>

<c:if test="${not empty prop}">
<%-- 사이드바 대분류 매핑을 위해 type 설정 --%>
<c:set var="type" value="${fn:toLowerCase(prop.catCd)}" />
<div class="content-layout">
  <%@ include file="/WEB-INF/views/front/property/inc/sidebarProperty.jsp" %>

  <div class="content-main">

    <!-- 상단: 이미지 갤러리 + 기본정보 -->
    <div class="prop-detail-top">
      <!-- 이미지 갤러리 영역 -->
      <div class="prop-gallery-wrap">
        <c:choose>
          <c:when test="${not empty imgList}">
            <c:set var="imgCnt" value="${fn:length(imgList)}" />
            <!-- 메인 이미지 1장만 표시 -->
            <div class="prop-gallery-single" id="propGalleryGrid">
              <div class="prop-gallery-main" onclick="openGallerySlider(0)">
                <img src="/upload/${imgList[0].imgPath}" alt="매물 대표 이미지"
                     class="prop-detail-img-main"
                     loading="eager"
                     decoding="async"
                     onload="this.classList.add('loaded')" />
                <c:if test="${prop.soldYn eq 'Y'}">
                  <span class="prop-card-badge" style="background:var(--gray-400);">거래완료</span>
                  <div class="prop-gallery-sold-overlay"><span>거래완료</span></div>
                </c:if>
              </div>

              <!-- 전체보기 버튼 (이미지 2장 이상일 때) -->
              <c:if test="${imgCnt >= 2}">
                <button class="prop-gallery-all-btn" onclick="openGallerySlider(0)">
                  📷 사진 전체보기 <span class="all-cnt">${imgCnt}</span>
                </button>
              </c:if>
            </div>
          </c:when>
          <c:otherwise>
            <!-- 이미지 없을 때 - 우측 영역에 맞춤 -->
            <div class="prop-detail-img ${fn:toLowerCase(prop.catCd)}">
              <span class="prop-card-emoji" style="font-size:64px;">
                <c:choose>
                  <c:when test="${prop.catCd eq 'APT'}">&#127970;</c:when>
                  <c:when test="${prop.catCd eq 'OFFICETEL'}">&#127980;</c:when>
                  <c:when test="${prop.catCd eq 'VILLA'}">&#127968;</c:when>
                  <c:when test="${prop.catCd eq 'ONEROOM'}">&#128682;</c:when>
                  <c:when test="${prop.catCd eq 'SHOP'}">&#127978;</c:when>
                  <c:when test="${prop.catCd eq 'OFFICE'}">&#127963;</c:when>
                  <c:otherwise>&#127968;</c:otherwise>
                </c:choose>
              </span>
              <c:if test="${prop.soldYn eq 'Y'}">
                  <span class="prop-card-badge" style="background:var(--gray-400);">거래완료</span>
                  <div style="position:absolute;inset:0;background:rgba(0,0,0,0.35);display:flex;align-items:center;justify-content:center;">
                    <span style="color:white;font-size:24px;font-weight:800;letter-spacing:3px;">거래완료</span>
                  </div>
                </c:if>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
      <div class="prop-detail-summary">
        <div class="prop-detail-type">
          ${prop.catNm}<c:if test="${not empty prop.midCatNm}"> &gt; ${prop.midCatNm}</c:if><c:if test="${not empty prop.subCatNm}"> &gt; ${prop.subCatNm}</c:if>
        </div>
        <h2 class="prop-detail-title">${prop.propNm}</h2>
        <div class="prop-detail-price">
          <span class="price-format" data-deal-type="${prop.dealType}" data-sell="${prop.sellPrice}" data-deposit="${prop.deposit}" data-rent="${prop.monthlyRent}">
            <c:choose>
              <c:when test="${prop.dealType eq 'SELL'}"><fmt:formatNumber value="${prop.sellPrice}" pattern="#,###"/>만</c:when>
              <c:when test="${prop.dealType eq 'JEONSE'}"><fmt:formatNumber value="${prop.deposit}" pattern="#,###"/>만</c:when>
              <c:otherwise><fmt:formatNumber value="${prop.deposit}" pattern="#,###"/>/<fmt:formatNumber value="${prop.monthlyRent}" pattern="#,###"/>만</c:otherwise>
            </c:choose>
          </span>
        </div>

        <div class="prop-detail-quick">
          <div class="prop-quick-item">
            <div class="prop-quick-label">전용면적 / 평수</div>
            <div class="prop-quick-value" style="white-space:nowrap;"><c:choose><c:when test="${not empty prop.areaExclusive and prop.areaExclusive > 0}"><fmt:formatNumber value="${prop.areaExclusive}" pattern="#,##0.##"/>㎡ / <fmt:formatNumber value="${prop.areaExclusive * 0.3025}" pattern="#,##0.#"/>평</c:when><c:otherwise>-</c:otherwise></c:choose></div>
          </div>
          <div class="prop-quick-item">
            <div class="prop-quick-label">해당층 / 총층</div>
            <div class="prop-quick-value" style="white-space:nowrap;">${not empty prop.floorNo ? prop.floorNo : '-'}층 / ${not empty prop.floorTotal ? prop.floorTotal : '-'}층</div>
          </div>
        </div>

        <c:choose>
          <c:when test="${prop.soldYn eq 'Y'}">
            <a href="javascript:void(0)" class="btn-primary-primus btn-disabled" style="margin-top:20px;padding:12px 28px;font-size:14px;pointer-events:none;opacity:0.5;">거래완료 매물</a>
          </c:when>
          <c:otherwise>
            <a href="javascript:fnGoPropertyConsult()" class="btn-primary-primus" style="margin-top:20px;padding:12px 28px;font-size:14px;">이 매물 문의하기</a>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

    <!-- 상세 정보 테이블 -->
    <div class="prop-detail-section">
      <h3 class="prop-detail-section-title">매물 정보</h3>
      <table class="prop-detail-table">
        <tr><th>매물유형</th><td>${prop.catNm}</td><th>거래유형</th><td>${prop.dealTypeNm}</td></tr>
        <tr>
          <th>가격</th>
          <td>
            <span class="price-format" data-deal-type="${prop.dealType}" data-sell="${prop.sellPrice}" data-deposit="${prop.deposit}" data-rent="${prop.monthlyRent}">
              <c:choose>
                <c:when test="${prop.dealType eq 'SELL'}">매매 <fmt:formatNumber value="${prop.sellPrice}" pattern="#,###"/>만</c:when>
                <c:when test="${prop.dealType eq 'JEONSE'}">전세 <fmt:formatNumber value="${prop.deposit}" pattern="#,###"/>만</c:when>
                <c:otherwise>보증금 <fmt:formatNumber value="${prop.deposit}" pattern="#,###"/> / 월세 <fmt:formatNumber value="${prop.monthlyRent}" pattern="#,###"/>만</c:otherwise>
              </c:choose>
            </span>
          </td>
          <th>관리비</th><td><c:choose><c:when test="${prop.mgmtCost > 0}">월 <fmt:formatNumber value="${prop.mgmtCost}" pattern="#,###"/>만</c:when><c:otherwise>-</c:otherwise></c:choose></td>
        </tr>
        <c:if test="${not empty prop.premium and prop.premium > 0}">
        <tr><th>권리금</th><td colspan="3"><fmt:formatNumber value="${prop.premium}" pattern="#,###"/>만</td></tr>
        </c:if>
        <tr><th>전용면적</th><td>${prop.areaExclusive}&#13217; <c:if test="${not empty prop.areaExclusive and prop.areaExclusive > 0}">(<fmt:formatNumber value="${prop.areaExclusive * 0.3025}" pattern="#,##0.#"/>평)</c:if></td><th>공급면적</th><td><c:choose><c:when test="${not empty prop.areaSupply and prop.areaSupply > 0}">${prop.areaSupply}&#13217; (<fmt:formatNumber value="${prop.areaSupply * 0.3025}" pattern="#,##0.#"/>평)</c:when><c:otherwise>-</c:otherwise></c:choose></td></tr>
        <c:if test="${prop.roomCnt > 0 or not empty prop.floorNo}">
        <tr><th>방수/욕실수</th><td>${prop.roomCnt > 0 ? prop.roomCnt : '-'}룸 / ${prop.bathCnt > 0 ? prop.bathCnt : '-'}욕실</td><th>해당층/총층</th><td>${not empty prop.floorNo ? prop.floorNo : '-'}층 / ${not empty prop.floorTotal ? prop.floorTotal : '-'}층</td></tr>
        </c:if>
        <c:if test="${not empty prop.direction or not empty prop.entranceType}">
        <tr><th>방향</th><td>${not empty prop.direction ? prop.direction : '-'}</td><th>현관구조</th><td>${not empty prop.entranceType ? prop.entranceType : '-'}</td></tr>
        </c:if>
        <c:if test="${not empty prop.moveInDate or not empty prop.parking}">
        <tr><th>입주가능일</th><td>${not empty prop.moveInDate ? prop.moveInDate : '-'}</td><th>주차</th><td>${not empty prop.parking ? prop.parking : '-'}</td></tr>
        </c:if>
        <c:if test="${not empty prop.heating or not empty prop.buildYear}">
        <tr><th>난방방식</th><td>${not empty prop.heating ? prop.heating : '-'}</td><th>사용승인일</th><td>${not empty prop.buildYear ? prop.buildYear : '-'}</td></tr>
        </c:if>
      </table>
    </div>

    <!-- 매물 설명 (BO 상세정보 에디터 내용) -->
    <c:if test="${not empty prop.detailCnts}">
    <div class="prop-detail-section">
      <h3 class="prop-detail-section-title">매물 설명</h3>
      <div class="prop-detail-desc-box">
        ${prop.detailCnts}
      </div>
    </div>
    </c:if>

    <!-- 위치 지도 -->
    <c:if test="${not empty prop.lat and not empty prop.lng}">
    <div class="prop-detail-section">
      <h3 class="prop-detail-section-title">위치</h3>
      <div style="width:100%;height:300px;border-radius:12px;overflow:hidden;border:1px solid var(--gray-200);">
        <div id="propMap" style="width:100%;height:100%;"></div>
      </div>
    </div>
    </c:if>

    <!-- 문의 안내 -->
    <c:if test="${prop.soldYn ne 'Y'}">
    <div class="prop-detail-section">
      <div class="prop-detail-cta">
        <div>
          <div style="font-size:16px;font-weight:700;color:var(--navy);margin-bottom:6px;">이 매물이 마음에 드시나요?</div>
          <div style="font-size:14px;color:var(--gray-500);">방문 상담 예약 또는 온라인 문의를 통해 자세한 안내를 받으실 수 있습니다.</div>
        </div>
        <div style="display:flex;gap:10px;align-items:center;">
          <div style="font-size:22px;font-weight:800;color:var(--navy);">032-327-1277</div>
          <a href="javascript:fnGoPropertyConsult()" class="btn-primary-primus" style="padding:11px 24px;font-size:14px;">온라인 문의</a>
        </div>
      </div>
    </div>
    </c:if>

    <!-- 버튼 -->
    <div class="board-detail-btns">
      <button type="button" class="board-btn board-btn-list" onclick="history.back()">목록</button>
      <c:if test="${not empty ssnUsrCd}">
        <button type="button" class="board-btn board-btn-list" onclick="fnGoEdit()">수정</button>
      </c:if>
    </div>

  </div>
</div>

<!-- 이미지 슬라이더 모달 -->
<c:if test="${not empty imgList}">
<div id="galleryModal" class="gallery-modal" style="display:none;" onclick="closeGalleryOnBg(event)">
  <div class="gallery-modal-inner">
    <button class="gallery-close-btn" onclick="closeGallerySlider()">&#10005;</button>
    <div class="gallery-counter" id="galleryCounter">1 / ${fn:length(imgList)}</div>
    <button class="gallery-nav-btn gallery-prev" onclick="slideGallery(-1)">&#10094;</button>
    <div class="gallery-slider" id="gallerySlider">
      <c:forEach var="img" items="${imgList}" varStatus="vs">
        <div class="gallery-slide">
          <div class="gallery-spinner"></div>
          <img data-src="/upload/${img.imgPath}" alt="매물 이미지 ${vs.index + 1}"
               class="gallery-slide-img"
               decoding="async" />
        </div>
      </c:forEach>
    </div>
    <button class="gallery-nav-btn gallery-next" onclick="slideGallery(1)">&#10095;</button>
    <div class="gallery-dots" id="galleryDots">
      <c:forEach var="img" items="${imgList}" varStatus="vs">
        <span class="gallery-dot ${vs.index == 0 ? 'active' : ''}" onclick="goToSlide(${vs.index})"></span>
      </c:forEach>
    </div>
  </div>
</div>
</c:if>

<style>
/* ── 이미지 로딩 최적화 ─────────────────────────── */
.prop-detail-img-main {
  width: 100%;
  height: 100%;
  object-fit: cover;
  opacity: 0;
  transition: opacity 0.3s ease;
}
.prop-detail-img-main.loaded {
  opacity: 1;
}
.gallery-slide-img {
  opacity: 0;
  transition: opacity 0.3s ease;
}
.gallery-slide-img.loaded {
  opacity: 1;
}

/* 슬라이더 로딩 스피너 */
.gallery-slide {
  position: relative;
  background: #1a1a1a;
}
.gallery-slide .gallery-spinner {
  position: absolute;
  top: 50%;
  left: 50%;
  width: 32px;
  height: 32px;
  margin: -16px 0 0 -16px;
  border: 3px solid rgba(255,255,255,0.2);
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}
@keyframes spin {
  to { transform: rotate(360deg); }
}

/* ── 상단 레이아웃 ─────────────────────────── */
.prop-detail-top {
  align-items: stretch;
}

.prop-detail-summary {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
}

/* ── 갤러리 - 1장만 표시 ─────────────────────────────── */
.prop-gallery-wrap {
  position: relative;
  border-radius: 16px;
  overflow: hidden;
  flex: 0 0 50%;
  max-width: 520px;
  min-width: 260px;
  min-height: 280px;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e8ec 100%);
}

.prop-gallery-single {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
}

.prop-gallery-main {
  position: relative;
  width: 100%;
  height: 100%;
  overflow: hidden;
  cursor: pointer;
  background: #e8e8e8;
}

.prop-gallery-main img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.4s ease;
  display: block;
}
.prop-gallery-main:hover img {
  transform: scale(1.03);
}

/* 전체보기 버튼 */
.prop-gallery-all-btn {
  position: absolute;
  bottom: 12px;
  right: 12px;
  background: rgba(255,255,255,0.95);
  color: #333;
  border: none;
  border-radius: 24px;
  padding: 8px 16px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  box-shadow: 0 2px 12px rgba(0,0,0,0.15);
  transition: all 0.2s;
  white-space: nowrap;
  z-index: 3;
}
.prop-gallery-all-btn:hover {
  background: #fff;
  transform: translateY(-1px);
  box-shadow: 0 4px 16px rgba(0,0,0,0.2);
}
.prop-gallery-all-btn .all-cnt {
  display: inline-block;
  background: var(--navy, #1a2e5a);
  color: #fff;
  border-radius: 12px;
  padding: 2px 8px;
  font-size: 12px;
  margin-left: 6px;
}

.prop-gallery-sold-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0,0,0,0.38);
  display: flex;
  align-items: center;
  justify-content: center;
  pointer-events: none;
}
.prop-gallery-sold-overlay span {
  color: white;
  font-size: 24px;
  font-weight: 800;
  letter-spacing: 3px;
}

/* 이미지 없을 때 */
.prop-gallery-wrap .prop-detail-img {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
}

/* ── 슬라이더 모달 ────────────────────────────── */
.gallery-modal {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.88);
  z-index: 9999;
  display: flex;
  align-items: center;
  justify-content: center;
}
.gallery-modal-inner {
  position: relative;
  width: 100%;
  max-width: 860px;
  padding: 20px 60px;
  box-sizing: border-box;
}
.gallery-slider {
  display: flex;
  overflow: hidden;
  border-radius: 10px;
}
.gallery-slide {
  min-width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: none;
}
.gallery-slide img {
  max-width: 100%;
  max-height: 70vh;
  object-fit: contain;
  border-radius: 8px;
  user-select: none;
}
.gallery-nav-btn {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  background: rgba(255,255,255,0.18);
  border: none;
  color: #fff;
  font-size: 24px;
  padding: 14px 16px;
  border-radius: 50%;
  cursor: pointer;
  z-index: 10;
  transition: background 0.2s;
}
.gallery-nav-btn:hover { background: rgba(255,255,255,0.35); }
.gallery-prev { left: 10px; }
.gallery-next { right: 10px; }
.gallery-close-btn {
  position: absolute;
  top: -10px;
  right: 10px;
  background: transparent;
  border: none;
  color: #fff;
  font-size: 22px;
  cursor: pointer;
  z-index: 10;
  opacity: 0.8;
}
.gallery-close-btn:hover { opacity: 1; }
.gallery-counter {
  text-align: center;
  color: rgba(255,255,255,0.7);
  font-size: 13px;
  margin-bottom: 10px;
}
.gallery-dots {
  display: flex;
  justify-content: center;
  gap: 7px;
  margin-top: 14px;
  flex-wrap: wrap;
}
.gallery-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: rgba(255,255,255,0.35);
  cursor: pointer;
  transition: background 0.2s;
}
.gallery-dot.active { background: #fff; }

@media (max-width: 1024px) {
  .prop-gallery-wrap { flex: 0 0 45%; max-width: 420px; min-height: 240px; }
  .prop-gallery-side { flex: 0 0 100px; }
}

@media (max-width: 768px) {
  .prop-gallery-wrap { width: 100%; flex: none; max-width: none; min-height: 0; aspect-ratio: 16 / 9; }
  .prop-gallery-grid { position: relative; height: 100%; }
  .prop-gallery-side { flex: 0 0 80px; }
  .gallery-modal-inner { padding: 20px 44px; }

  .prop-detail-top { flex-direction: column; gap: 0; }
  .prop-detail-summary { padding-top: 16px; }

  /* 매물 정보 테이블 모바일 - 4칸 → 2칸 세로 정렬 */
  .prop-detail-table tr {
    display: flex; flex-wrap: wrap;
  }
  .prop-detail-table th,
  .prop-detail-table td {
    display: block; box-sizing: border-box;
  }
  .prop-detail-table th {
    width: 35%; font-size: 13px; padding: 10px 12px;
  }
  .prop-detail-table td {
    width: 65%; font-size: 13px; padding: 10px 12px;
  }

  /* 하단 CTA 세로 정렬 */
  .prop-detail-cta {
    flex-direction: column; text-align: center; gap: 16px; padding: 20px 16px;
  }
  .prop-detail-cta > div:last-child {
    flex-direction: column; width: 100%;
  }
  .prop-detail-cta > div:last-child .btn-primary-primus {
    width: 100%; text-align: center;
  }

  /* 위치 지도 높이 조절 */
  #propMap { min-height: 200px; }
}

/* ── 매물 설명 박스 스타일 ─────────────────────────── */
.prop-detail-desc-box {
  background: #fafbfc;
  border: 1px solid #e8eaed;
  border-radius: 12px;
  padding: 24px 28px;
  font-size: 15px;
  line-height: 1.8;
  color: #333;
}
.prop-detail-desc-box p {
  margin: 0 0 12px 0;
}
.prop-detail-desc-box p:last-child {
  margin-bottom: 0;
}
.prop-detail-desc-box img {
  max-width: 100%;
  height: auto;
  border-radius: 8px;
  margin: 12px 0;
}
.prop-detail-desc-box ul,
.prop-detail-desc-box ol {
  padding-left: 20px;
  margin: 12px 0;
}
.prop-detail-desc-box li {
  margin-bottom: 6px;
}
.prop-detail-desc-box table {
  width: 100%;
  border-collapse: collapse;
  margin: 12px 0;
}
.prop-detail-desc-box table td,
.prop-detail-desc-box table th {
  border: 1px solid #e0e0e0;
  padding: 8px 12px;
}
@media (max-width: 768px) {
  .prop-detail-desc-box {
    padding: 18px 16px;
    font-size: 14px;
  }
}
</style>

<script>
(function() {
  var currentIdx = 0;
  var totalSlides = ${fn:length(imgList)};
  var preloaded = false;

  // 페이지 로드 시 백그라운드에서 이미지 미리 로드 시작
  function preloadAllImages() {
    if (preloaded) return;
    preloaded = true;

    var slides = document.querySelectorAll('.gallery-slide img[data-src]');
    slides.forEach(function(img, idx) {
      if (img.dataset.src) {
        // 순차적 로드 (네트워크 부하 분산)
        setTimeout(function() {
          img.src = img.dataset.src;
          img.removeAttribute('data-src');
          img.onload = function() {
            this.classList.add('loaded');
            var spinner = this.parentElement.querySelector('.gallery-spinner');
            if (spinner) spinner.style.display = 'none';
          };
        }, idx * 50); // 50ms 간격으로 순차 로드
      }
    });
  }

  // 페이지 로드 완료 후 바로 프리로드 시작
  if (document.readyState === 'complete') {
    preloadAllImages();
  } else {
    window.addEventListener('load', preloadAllImages);
  }

  window.openGallerySlider = function(startIdx) {
    currentIdx = startIdx || 0;
    document.getElementById('galleryModal').style.display = 'flex';
    document.body.style.overflow = 'hidden';
    renderSlide();
  };

  window.closeGallerySlider = function() {
    document.getElementById('galleryModal').style.display = 'none';
    document.body.style.overflow = '';
  };

  window.closeGalleryOnBg = function(e) {
    if (e.target === document.getElementById('galleryModal')) {
      closeGallerySlider();
    }
  };

  window.slideGallery = function(dir) {
    currentIdx = (currentIdx + dir + totalSlides) % totalSlides;
    renderSlide();
  };

  window.goToSlide = function(idx) {
    currentIdx = idx;
    renderSlide();
  };

  function renderSlide() {
    var slides = document.querySelectorAll('.gallery-slide');
    slides.forEach(function(s, i) {
      s.style.display = i === currentIdx ? 'flex' : 'none';
    });
    var counter = document.getElementById('galleryCounter');
    if (counter) counter.textContent = (currentIdx + 1) + ' / ' + totalSlides;
    var dots = document.querySelectorAll('.gallery-dot');
    dots.forEach(function(d, i) {
      d.classList.toggle('active', i === currentIdx);
    });
  }

  // 키보드 방향키 지원
  document.addEventListener('keydown', function(e) {
    var modal = document.getElementById('galleryModal');
    if (!modal || modal.style.display === 'none') return;
    if (e.key === 'ArrowLeft') slideGallery(-1);
    else if (e.key === 'ArrowRight') slideGallery(1);
    else if (e.key === 'Escape') closeGallerySlider();
  });
})();
</script>

<c:if test="${not empty prop.lat and not empty prop.lng}">
<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=<%= Constant.KAKAO_MAP_API_KEY %>"></script>
<script>
  $(function () {
    kakao.maps.load(function () {
      var lat = ${prop.lat}, lng = ${prop.lng};
      var container = document.getElementById('propMap');
      var map = new kakao.maps.Map(container, { center: new kakao.maps.LatLng(lat, lng), level: 3 });
      var marker = new kakao.maps.Marker({ position: new kakao.maps.LatLng(lat, lng) });
      marker.setMap(map);
      var iw = new kakao.maps.InfoWindow({
        content: '<div style="padding:8px 14px;font-size:13px;font-weight:700;white-space:nowrap;">${prop.propNm}</div>'
      });
      iw.open(map, marker);
    });
  });
</script>
</c:if>
<!-- 매물 문의 전용 form -->
<form id="goPropertyConsultForm" action="${ctx}/bbs/viewBbsWriteQna" method="post" style="display:none;">
  <input type="hidden" name="brdCd" value="3ccd942dfcbf11f08771908d6ec6e544" />
  <input type="hidden" name="pstNm" id="consultPstNm" value="[매물문의] ${prop.propNm}" />
  <input type="hidden" name="propCd" value="${prop.propCd}" />
  <input type="hidden" name="inqType" value="PROPERTY" />
</form>
<!-- 매물 수정 전용 form -->
<form id="goPropertyEditForm" action="${ctx}/propertyMng/viewPropertyWrite" method="post" target="_blank" style="display:none;">
  <input type="hidden" name="propCd" value="${prop.propCd}" />
</form>
<script>
  function fnGoPropertyConsult() {
    document.getElementById('goPropertyConsultForm').submit();
  }
  function fnGoEdit() {
    document.getElementById('goPropertyEditForm').submit();
  }
</script>

</c:if>

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>
</body>
</html>
