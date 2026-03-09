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
            <!-- 이미지 수에 따른 갤러리 레이아웃 -->
            <div class="prop-gallery-grid prop-gallery-count-${imgCnt > 4 ? 'many' : imgCnt}" id="propGalleryGrid">

              <!-- 메인 이미지 -->
              <div class="prop-gallery-main" onclick="openGallerySlider(0)">
                <img src="/upload/${imgList[0].imgPath}" alt="매물 대표 이미지" />
                <c:choose>
                  <c:when test="${prop.soldYn eq 'Y'}">
                    <span class="prop-card-badge" style="background:var(--gray-400);">거래완료</span>
                    <div class="prop-gallery-sold-overlay"><span>거래완료</span></div>
                  </c:when>
                  <c:when test="${prop.badgeType eq 'URGENT'}">
                    <span class="prop-card-badge" style="background:#dc3545;">급매</span>
                  </c:when>
                  <c:when test="${prop.badgeType eq 'RECOMMEND'}">
                    <span class="prop-card-badge">추천</span>
                  </c:when>
                </c:choose>
              </div>

              <!-- 우측 썸네일 (2장 이상일 때만) -->
              <c:if test="${imgCnt >= 2}">
                <div class="prop-gallery-side">
                  <c:forEach var="img" items="${imgList}" varStatus="vs">
                    <c:if test="${vs.index >= 1 and vs.index <= 3}">
                      <div class="prop-gallery-thumb" onclick="openGallerySlider(${vs.index})">
                        <img src="/upload/${img.imgPath}" alt="매물 이미지 ${vs.index + 1}" />
                        <!-- 4번째 썸네일(index=3)이고 이미지가 5장 이상이면 더보기 오버레이 -->
                        <c:if test="${vs.index == 3 and imgCnt > 4}">
                          <div class="prop-gallery-more-overlay">
                            <span class="more-count">+${imgCnt - 4}</span>
                            <span class="more-label">더보기</span>
                          </div>
                        </c:if>
                      </div>
                    </c:if>
                  </c:forEach>
                </div>
              </c:if>

              <!-- 전체보기 버튼 (항상 표시) -->
              <button class="prop-gallery-all-btn" onclick="openGallerySlider(0)">
                &#128247; 사진 전체보기 <span class="all-cnt">${imgCnt}</span>
              </button>
            </div>
          </c:when>
          <c:otherwise>
            <!-- 이미지 없을 때 기존 스타일 유지 -->
            <div class="prop-detail-img ${fn:toLowerCase(prop.propType)}" style="height:100%;min-height:300px;">
              <span class="prop-card-emoji" style="font-size:64px;">
                <c:choose>
                  <c:when test="${prop.propType eq 'APT'}">&#127970;</c:when>
                  <c:when test="${prop.propType eq 'OFFICETEL'}">&#127980;</c:when>
                  <c:when test="${prop.propType eq 'VILLA'}">&#127968;</c:when>
                  <c:when test="${prop.propType eq 'ONEROOM'}">&#128682;</c:when>
                  <c:when test="${prop.propType eq 'SHOP'}">&#127978;</c:when>
                  <c:when test="${prop.propType eq 'OFFICE'}">&#127963;</c:when>
                  <c:otherwise>&#127968;</c:otherwise>
                </c:choose>
              </span>
              <c:choose>
                <c:when test="${prop.soldYn eq 'Y'}">
                  <span class="prop-card-badge" style="background:var(--gray-400);">거래완료</span>
                  <div style="position:absolute;inset:0;background:rgba(0,0,0,0.35);display:flex;align-items:center;justify-content:center;">
                    <span style="color:white;font-size:24px;font-weight:800;letter-spacing:3px;">거래완료</span>
                  </div>
                </c:when>
                <c:when test="${prop.badgeType eq 'URGENT'}">
                  <span class="prop-card-badge" style="background:#dc3545;">급매</span>
                </c:when>
                <c:when test="${prop.badgeType eq 'RECOMMEND'}">
                  <span class="prop-card-badge">추천</span>
                </c:when>
              </c:choose>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
      <div class="prop-detail-summary">
        <div class="prop-detail-type">${prop.propTypeNm} &middot; ${prop.dealTypeNm}</div>
        <h2 class="prop-detail-title">${prop.propNm}</h2>
        <div class="prop-detail-loc">${prop.address}</div>
        <div class="prop-detail-price">
          <c:choose>
            <c:when test="${prop.dealType eq 'SELL'}"><fmt:formatNumber value="${prop.sellPrice}" pattern="#,###"/></c:when>
            <c:when test="${prop.dealType eq 'JEONSE'}"><fmt:formatNumber value="${prop.deposit}" pattern="#,###"/></c:when>
            <c:otherwise><fmt:formatNumber value="${prop.deposit}" pattern="#,###"/>/<fmt:formatNumber value="${prop.monthlyRent}" pattern="#,###"/></c:otherwise>
          </c:choose>
          <span>만원</span>
        </div>

        <div class="prop-detail-tags">
          <span class="prop-tag">${prop.propTypeNm}</span>
          <span class="prop-tag">${prop.dealTypeNm}</span>
          <c:if test="${not empty prop.direction}"><span class="prop-tag">${prop.direction}</span></c:if>
          <c:if test="${not empty prop.parking}"><span class="prop-tag">주차 ${prop.parking}</span></c:if>
        </div>

        <div class="prop-detail-quick">
          <div class="prop-quick-item">
            <div class="prop-quick-label">전용면적</div>
            <div class="prop-quick-value">${prop.areaExclusive}&#13217;</div>
          </div>
          <c:if test="${prop.roomCnt > 0}">
          <div class="prop-quick-item">
            <div class="prop-quick-label">방/욕실</div>
            <div class="prop-quick-value">${prop.roomCnt}룸<c:if test="${prop.bathCnt > 0}"> / ${prop.bathCnt}욕실</c:if></div>
          </div>
          </c:if>
          <c:if test="${not empty prop.floorNo}">
          <div class="prop-quick-item">
            <div class="prop-quick-label">해당층</div>
            <div class="prop-quick-value">${prop.floorNo}층<c:if test="${not empty prop.floorTotal}">/${prop.floorTotal}층</c:if></div>
          </div>
          </c:if>
          <c:if test="${not empty prop.moveInDate}">
          <div class="prop-quick-item">
            <div class="prop-quick-label">입주가능일</div>
            <div class="prop-quick-value">${prop.moveInDate}</div>
          </div>
          </c:if>
        </div>

        <c:if test="${prop.soldYn ne 'Y'}">
        <a href="javascript:fnGoPropertyConsult()" class="btn-primary-primus" style="margin-top:20px;padding:12px 28px;font-size:14px;">이 매물 문의하기</a>
        </c:if>
      </div>
    </div>

    <!-- 상세 정보 테이블 -->
    <div class="prop-detail-section">
      <h3 class="prop-detail-section-title">매물 정보</h3>
      <table class="prop-detail-table">
        <tr><th>매물유형</th><td>${prop.propTypeNm}</td><th>거래유형</th><td>${prop.dealTypeNm}</td></tr>
        <tr>
          <th>가격</th>
          <td>
            <c:choose>
              <c:when test="${prop.dealType eq 'SELL'}">매매 <fmt:formatNumber value="${prop.sellPrice}" pattern="#,###"/>만원</c:when>
              <c:when test="${prop.dealType eq 'JEONSE'}">전세 <fmt:formatNumber value="${prop.deposit}" pattern="#,###"/>만원</c:when>
              <c:otherwise>보증금 <fmt:formatNumber value="${prop.deposit}" pattern="#,###"/> / 월세 <fmt:formatNumber value="${prop.monthlyRent}" pattern="#,###"/>만원</c:otherwise>
            </c:choose>
          </td>
          <th>관리비</th><td><c:choose><c:when test="${prop.mgmtCost > 0}">월 <fmt:formatNumber value="${prop.mgmtCost}" pattern="#,###"/>만원</c:when><c:otherwise>-</c:otherwise></c:choose></td>
        </tr>
        <tr><th>전용면적</th><td>${prop.areaExclusive}&#13217;</td><th>공급면적</th><td><c:choose><c:when test="${not empty prop.areaSupply}">${prop.areaSupply}&#13217;</c:when><c:otherwise>-</c:otherwise></c:choose></td></tr>
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

    <!-- 매물 설명 -->
    <c:if test="${not empty prop.propDesc}">
    <div class="prop-detail-section">
      <h3 class="prop-detail-section-title">매물 설명</h3>
      <div class="prop-detail-desc">${prop.propDesc}</div>
    </div>
    </c:if>

    <!-- 위치 지도 -->
    <c:if test="${not empty prop.lat and not empty prop.lng}">
    <div class="prop-detail-section">
      <h3 class="prop-detail-section-title">위치</h3>
      <div style="width:100%;height:300px;border-radius:12px;overflow:hidden;border:1px solid var(--gray-200);">
        <div id="propMap" style="width:100%;height:100%;"></div>
      </div>
      <div style="margin-top:10px;font-size:13px;color:var(--gray-400);">
        ${prop.address}
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
          <img src="/upload/${img.imgPath}" alt="매물 이미지 ${vs.index + 1}" />
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
/* ── 갤러리 그리드 ─────────────────────────────── */
.prop-gallery-wrap {
  position: relative;
  border-radius: 16px;
  overflow: hidden;
  flex: 0 0 440px;
  width: 440px;
  min-width: 260px;
  align-self: stretch;
}

/* 메인 + 사이드 2열 레이아웃 */
.prop-gallery-grid {
  display: flex;
  gap: 4px;
  width: 100%;
  height: 100%;
  min-height: 300px;
  border-radius: 16px;
  overflow: hidden;
  position: relative;
}

/* 좌측 메인 이미지 */
.prop-gallery-main {
  position: relative;
  flex: 2;
  overflow: hidden;
  cursor: pointer;
  background: #e8e8e8;
  min-height: 300px;
}

/* 1장: 메인이 100% 차지 */
.prop-gallery-count-1 .prop-gallery-main {
  flex: 1;
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

/* 우측 썸네일 열 */
.prop-gallery-side {
  display: flex;
  flex-direction: column;
  gap: 4px;
  flex: 1;
  position: relative;
  min-width: 0;
}

.prop-gallery-thumb {
  position: relative;
  flex: 1;
  overflow: hidden;
  cursor: pointer;
  background: #e8e8e8;
  min-height: 0;
}
.prop-gallery-thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.4s ease;
  display: block;
}
.prop-gallery-thumb:hover img {
  transform: scale(1.05);
}

/* 더보기 오버레이 */
.prop-gallery-more-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0,0,0,0.55);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: #fff;
  pointer-events: none;
}
.more-count { font-size: 26px; font-weight: 800; line-height: 1; }
.more-label { font-size: 12px; margin-top: 4px; opacity: 0.9; }

/* 전체보기 버튼 */
.prop-gallery-all-btn {
  position: absolute;
  bottom: 10px;
  right: 10px;
  background: rgba(255,255,255,0.92);
  color: #333;
  border: none;
  border-radius: 20px;
  padding: 5px 12px;
  font-size: 12px;
  font-weight: 600;
  cursor: pointer;
  box-shadow: 0 2px 8px rgba(0,0,0,0.18);
  transition: background 0.2s;
  white-space: nowrap;
  z-index: 3;
}
.prop-gallery-all-btn:hover { background: #fff; }
.prop-gallery-all-btn .all-cnt {
  display: inline-block;
  background: var(--navy, #1a2e5a);
  color: #fff;
  border-radius: 10px;
  padding: 1px 7px;
  font-size: 11px;
  margin-left: 4px;
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

@media (max-width: 768px) {
  .prop-gallery-wrap { width: 100%; flex: none; }
  .prop-gallery-grid { height: auto; min-height: 220px; }
  .prop-gallery-main { min-height: 220px; }
  .prop-gallery-side { flex: 0 0 80px; }
  .gallery-modal-inner { padding: 20px 44px; }

  .prop-detail-top { flex-direction: column; gap: 0; }
  .prop-detail-summary { padding-top: 16px; }
}
</style>

<script>
(function() {
  var currentIdx = 0;
  var totalSlides = ${fn:length(imgList)};

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
<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=d53f71f3d9ea4c5c59f5f63df52a5c0d"></script>
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
</form>
<script>
  function fnGoPropertyConsult() {
    document.getElementById('goPropertyConsultForm').submit();
  }
</script>

</c:if>

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>
</body>
</html>
