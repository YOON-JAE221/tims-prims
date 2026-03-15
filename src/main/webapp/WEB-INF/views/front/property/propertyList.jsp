<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>

<%-- 대분류명 동적 설정 --%>
<c:set var="typeNm" value="전체매물" />
<c:if test="${not empty type and type ne 'all'}">
  <c:forEach var="cat" items="${catList}">
    <c:if test="${fn:toLowerCase(cat.catCd) eq fn:toLowerCase(type)}">
      <c:set var="typeNm" value="${cat.catNm}" />
    </c:if>
  </c:forEach>
</c:if>

<div class="page-header">
  <h2>${typeNm}</h2>
</div>

<div class="content-layout">
  <%@ include file="/WEB-INF/views/front/property/inc/sidebarProperty.jsp" %>

  <div class="content-main">

    <!-- 검색 필터 -->
    <form id="filterForm" method="post" action="${ctx}/property/viewPropertyList">
      <input type="hidden" name="pageNo" id="pageNoInput" value="${pageNo}" />
      <input type="hidden" name="areaMin" id="areaMinInput" value="${areaMin}" />
      <input type="hidden" name="areaMax" id="areaMaxInput" value="${areaMax}" />
      <input type="hidden" name="areaUnit" id="areaUnitInput" value="${empty areaUnit ? 'pyeong' : areaUnit}" />
      <input type="hidden" name="priceMin" id="priceMinInput" value="${priceMin}" />
      <input type="hidden" name="priceMax" id="priceMaxInput" value="${priceMax}" />
      <input type="hidden" name="rentMin" id="rentMinInput" value="${rentMin}" />
      <input type="hidden" name="rentMax" id="rentMaxInput" value="${rentMax}" />
      <div class="prop-filter">
        <select name="type" class="mo-only" onchange="fnFilter()">
          <option value="all">전체매물</option>
          <c:forEach var="cat" items="${catList}">
            <option value="${fn:toLowerCase(cat.catCd)}" ${fn:toLowerCase(type) eq fn:toLowerCase(cat.catCd) ? 'selected' : ''}>${cat.catNm}</option>
          </c:forEach>
        </select>
        <select name="dealType" id="dealTypeSelect" onchange="fnFilter()">
          <option value="">전체거래</option>
          <option value="SELL" ${dealType eq 'SELL' ? 'selected' : ''}>매매</option>
          <option value="JEONSE" ${dealType eq 'JEONSE' ? 'selected' : ''}>전세</option>
          <option value="WOLSE" ${dealType eq 'WOLSE' ? 'selected' : ''}>월세</option>
          <option value="RENT" ${dealType eq 'RENT' ? 'selected' : ''}>임대</option>
        </select>
        <!-- 가격대 필터 버튼 -->
        <button type="button" class="filter-popup-btn ${not empty priceMin or not empty priceMax or not empty rentMin or not empty rentMax ? 'active' : ''}" onclick="openPricePopup()">
          <span id="priceFilterLabel">
            <c:choose>
              <c:when test="${not empty priceMin or not empty priceMax or not empty rentMin or not empty rentMax}">가격설정</c:when>
              <c:otherwise>가격대</c:otherwise>
            </c:choose>
          </span>
          <span class="filter-arrow">▼</span>
        </button>
        <!-- 면적 필터 버튼 -->
        <button type="button" class="filter-popup-btn ${not empty areaMin or not empty areaMax ? 'active' : ''}" onclick="openAreaPopup()">
          <span id="areaFilterLabel">
            <c:choose>
              <c:when test="${not empty areaMin and not empty areaMax}">${areaMin}~${areaMax}${areaUnit eq 'm2' ? '㎡' : '평'}</c:when>
              <c:when test="${not empty areaMin}">${areaMin}${areaUnit eq 'm2' ? '㎡' : '평'}~</c:when>
              <c:when test="${not empty areaMax}">~${areaMax}${areaUnit eq 'm2' ? '㎡' : '평'}</c:when>
              <c:otherwise>면적</c:otherwise>
            </c:choose>
          </span>
          <span class="filter-arrow">▼</span>
        </button>
        <input type="text" name="keyword" value="${keyword}" placeholder="매물명 검색" />
        <div class="prop-filter-btns">
          <button type="submit" class="prop-filter-btn">검색</button>
          <button type="button" class="prop-filter-reset" onclick="fnReset()">초기화</button>
        </div>
      </div>
    </form>

    <!-- 가격대 필터 팝업 -->
    <div id="pricePopup" class="filter-popup" style="display:none;">
      <div class="filter-popup-header">
        <span class="filter-popup-title">매매가/전세가/보증금</span>
        <button type="button" class="filter-popup-close" onclick="closePricePopup()">×</button>
      </div>
      <div class="filter-popup-body">
        <!-- 범위 표시 -->
        <div class="filter-range-display">
          <span id="priceRangeText">전체</span>
        </div>
        <!-- 빠른 선택 버튼 -->
        <div class="filter-quick-btns price-btns" id="priceBtns">
          <button type="button" class="filter-quick-btn" data-min="0" data-max="10000">1억</button>
          <button type="button" class="filter-quick-btn" data-min="10000" data-max="20000">2억</button>
          <button type="button" class="filter-quick-btn" data-min="20000" data-max="30000">3억</button>
          <button type="button" class="filter-quick-btn" data-min="30000" data-max="40000">4억</button>
          <button type="button" class="filter-quick-btn" data-min="40000" data-max="50000">5억</button>
          <button type="button" class="filter-quick-btn" data-min="50000" data-max="60000">6억</button>
          <button type="button" class="filter-quick-btn" data-min="60000" data-max="70000">7억</button>
          <button type="button" class="filter-quick-btn" data-min="70000" data-max="80000">8억</button>
          <button type="button" class="filter-quick-btn" data-min="80000" data-max="90000">9억</button>
          <button type="button" class="filter-quick-btn" data-min="90000" data-max="100000">10억</button>
          <button type="button" class="filter-quick-btn" data-min="100000" data-max="150000">15억</button>
          <button type="button" class="filter-quick-btn" data-min="150000" data-max="200000">20억</button>
          <button type="button" class="filter-quick-btn" data-min="200000" data-max="300000">30억</button>
          <button type="button" class="filter-quick-btn" data-min="300000" data-max="400000">40억</button>
          <button type="button" class="filter-quick-btn" data-min="400000" data-max="500000">50억</button>
          <button type="button" class="filter-quick-btn" data-min="500000" data-max="">50억~</button>
        </div>
        <!-- 직접 입력 -->
        <div class="filter-input-row">
          <div class="filter-input-group">
            <span class="filter-input-label">최소</span>
            <input type="number" id="priceMinDirect" placeholder="만원" />
          </div>
          <span class="filter-input-sep">~</span>
          <div class="filter-input-group">
            <span class="filter-input-label">최대</span>
            <input type="number" id="priceMaxDirect" placeholder="만원" />
          </div>
          <button type="button" class="filter-input-apply" onclick="applyPriceDirect()">적용</button>
        </div>

        <!-- 월세 섹션 -->
        <div class="filter-section-title">월세</div>
        <div class="filter-range-display">
          <span id="rentRangeText">전체</span>
        </div>
        <div class="filter-quick-btns rent-btns" id="rentBtns">
          <button type="button" class="filter-quick-btn" data-min="0" data-max="10">10만</button>
          <button type="button" class="filter-quick-btn" data-min="10" data-max="20">20만</button>
          <button type="button" class="filter-quick-btn" data-min="20" data-max="30">30만</button>
          <button type="button" class="filter-quick-btn" data-min="30" data-max="40">40만</button>
          <button type="button" class="filter-quick-btn" data-min="40" data-max="50">50만</button>
          <button type="button" class="filter-quick-btn" data-min="50" data-max="60">60만</button>
          <button type="button" class="filter-quick-btn" data-min="60" data-max="70">70만</button>
          <button type="button" class="filter-quick-btn" data-min="70" data-max="80">80만</button>
          <button type="button" class="filter-quick-btn" data-min="80" data-max="90">90만</button>
          <button type="button" class="filter-quick-btn" data-min="90" data-max="100">100만</button>
          <button type="button" class="filter-quick-btn" data-min="100" data-max="200">200만</button>
          <button type="button" class="filter-quick-btn" data-min="200" data-max="">200만~</button>
        </div>
        <!-- 월세 직접 입력 -->
        <div class="filter-input-row">
          <div class="filter-input-group">
            <span class="filter-input-label">최소</span>
            <input type="number" id="rentMinDirect" placeholder="만원" />
          </div>
          <span class="filter-input-sep">~</span>
          <div class="filter-input-group">
            <span class="filter-input-label">최대</span>
            <input type="number" id="rentMaxDirect" placeholder="만원" />
          </div>
          <button type="button" class="filter-input-apply" onclick="applyRentDirect()">적용</button>
        </div>

        <!-- 조건 삭제 -->
        <div class="filter-popup-footer">
          <button type="button" class="filter-reset-btn" onclick="resetPriceFilter()">↺ 조건삭제</button>
        </div>
      </div>
    </div>

    <!-- 면적 필터 팝업 -->
    <div id="areaPopup" class="area-popup" style="display:none;">
      <div class="area-popup-header">
        <span class="area-popup-title">면적</span>
        <div class="area-unit-tabs">
          <button type="button" class="area-unit-tab" data-unit="m2">㎡</button>
          <button type="button" class="area-unit-tab active" data-unit="pyeong">평</button>
        </div>
        <button type="button" class="area-popup-close" onclick="closeAreaPopup()">×</button>
      </div>
      <div class="area-popup-body">
        <!-- 범위 표시 -->
        <div class="area-range-display">
          <span id="areaRangeText">전체</span>
        </div>
        <!-- 슬라이더 -->
        <div class="area-slider-wrap">
          <div id="areaSlider"></div>
        </div>
        <!-- 빠른 선택 버튼 (평) -->
        <div class="area-quick-btns" id="areaBtnsPyeong">
          <button type="button" class="area-quick-btn" data-min="" data-max="50">~50평</button>
          <button type="button" class="area-quick-btn" data-min="50" data-max="100">100평</button>
          <button type="button" class="area-quick-btn" data-min="100" data-max="200">200평</button>
          <button type="button" class="area-quick-btn" data-min="200" data-max="300">300평</button>
          <button type="button" class="area-quick-btn" data-min="300" data-max="400">400평</button>
          <button type="button" class="area-quick-btn" data-min="400" data-max="500">500평</button>
          <button type="button" class="area-quick-btn" data-min="500" data-max="600">600평</button>
          <button type="button" class="area-quick-btn" data-min="600" data-max="700">700평</button>
          <button type="button" class="area-quick-btn" data-min="700" data-max="800">800평</button>
          <button type="button" class="area-quick-btn" data-min="800" data-max="900">900평</button>
          <button type="button" class="area-quick-btn" data-min="900" data-max="1000">1000평</button>
          <button type="button" class="area-quick-btn" data-min="1000" data-max="">1000평~</button>
        </div>
        <!-- 빠른 선택 버튼 (㎡) -->
        <div class="area-quick-btns" id="areaBtnsM2" style="display:none;">
          <button type="button" class="area-quick-btn" data-min="" data-max="165">~165㎡</button>
          <button type="button" class="area-quick-btn" data-min="165" data-max="331">331㎡</button>
          <button type="button" class="area-quick-btn" data-min="331" data-max="661">661㎡</button>
          <button type="button" class="area-quick-btn" data-min="661" data-max="992">992㎡</button>
          <button type="button" class="area-quick-btn" data-min="992" data-max="1322">1322㎡</button>
          <button type="button" class="area-quick-btn" data-min="1322" data-max="1653">1653㎡</button>
          <button type="button" class="area-quick-btn" data-min="1653" data-max="1983">1983㎡</button>
          <button type="button" class="area-quick-btn" data-min="1983" data-max="2314">2314㎡</button>
          <button type="button" class="area-quick-btn" data-min="2314" data-max="2645">2645㎡</button>
          <button type="button" class="area-quick-btn" data-min="2645" data-max="2975">2975㎡</button>
          <button type="button" class="area-quick-btn" data-min="2975" data-max="3306">3306㎡</button>
          <button type="button" class="area-quick-btn" data-min="3306" data-max="">3306㎡~</button>
        </div>
        <!-- 조건 삭제 -->
        <div class="area-popup-footer">
          <button type="button" class="area-reset-btn" onclick="resetAreaFilter()">↺ 조건삭제</button>
        </div>
      </div>
    </div>

    <!-- 결과 건수 -->
    <div class="board-header">
      <p class="board-total">총 <strong>${totalCnt}</strong>건의 매물</p>
      <c:if test="${not empty sessionScope.loginUser}">
        <div class="board-admin-btns">
          <button type="button" class="btn-admin" onclick="fnGoAdmin()">⚙ 관리</button>
        </div>
      </c:if>
    </div>

    <!-- 매물 카드 그리드 -->
    <div class="prop-grid">
      <c:if test="${empty list}">
        <div style="grid-column:1/-1; text-align:center; padding:60px 0; color:var(--gray-400); font-size:14px;">
          등록된 매물이 없습니다.
        </div>
      </c:if>
      <c:forEach var="prop" items="${list}">
        <div class="prop-card ${prop.soldYn eq 'Y' ? 'sold-card' : ''}" onclick="fnGoDetail('${prop.catCd}','${prop.propCd}')">
          <div class="prop-card-img ${fn:toLowerCase(prop.catCd)}">
            <c:choose>
              <c:when test="${not empty prop.thumbPath}">
                <img src="/upload/${prop.thumbPath}" alt="${prop.propNm}" style="width:100%; height:100%; object-fit:cover;" />
              </c:when>
              <c:otherwise>
                <span class="prop-card-emoji">
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
              </c:otherwise>
            </c:choose>
            <%-- 거래완료 뱃지 --%>
            <c:if test="${prop.soldYn eq 'Y'}">
              <span class="prop-card-badge" style="background:var(--gray-400);">거래완료</span>
            </c:if>
            <c:if test="${prop.soldYn eq 'Y'}">
              <div style="position:absolute; inset:0; background:rgba(0,0,0,0.35); display:flex; align-items:center; justify-content:center;">
                <span style="color:white; font-size:18px; font-weight:800; letter-spacing:2px;">거래완료</span>
              </div>
            </c:if>
          </div>
          <div class="prop-card-body">
            <div class="prop-card-type">${prop.catNm}</div>
            <div class="prop-card-title">${prop.propNm}</div>
            <div class="prop-card-price">
              <span class="prop-deal-label">${prop.dealTypeNm}</span>
              <span class="price-format" data-deal-type="${prop.dealType}" data-sell="${prop.sellPrice}" data-deposit="${prop.deposit}" data-rent="${prop.monthlyRent}">
                <c:choose>
                  <c:when test="${prop.dealType eq 'SELL'}"><fmt:formatNumber value="${prop.sellPrice}" pattern="#,###"/>만</c:when>
                  <c:when test="${prop.dealType eq 'JEONSE'}"><fmt:formatNumber value="${prop.deposit}" pattern="#,###"/>만</c:when>
                  <c:otherwise><fmt:formatNumber value="${prop.deposit}" pattern="#,###"/>/<fmt:formatNumber value="${prop.monthlyRent}" pattern="#,###"/>만</c:otherwise>
                </c:choose>
              </span>
            </div>
            <c:if test="${not empty prop.areaExclusive}">
              <div class="prop-card-area">${prop.areaExclusive}㎡</div>
            </c:if>
          </div>
        </div>
      </c:forEach>
    </div>

    <!-- 페이징 -->
    <c:if test="${totalPage > 0}">
      <div class="board-paging">
        <a href="javascript:fnGoPage(${pageNo - 1})" class="${pageNo <= 1 ? 'disabled' : ''}">이전</a>
        <c:forEach var="p" begin="1" end="${totalPage}">
          <c:if test="${p >= ((pageNo - 1) / 10 * 10 + 1) and p <= ((pageNo - 1) / 10 * 10 + 10)}">
            <a href="javascript:fnGoPage(${p})" class="${p == pageNo ? 'active' : ''}">${p}</a>
          </c:if>
        </c:forEach>
        <a href="javascript:fnGoPage(${pageNo + 1})" class="${pageNo >= totalPage ? 'disabled' : ''}">다음</a>
      </div>
    </c:if>

  </div>
</div>

<script>
  // ========== 면적 필터 변수 ==========
  var areaUnit = '${empty areaUnit ? "pyeong" : areaUnit}';
  var areaMin = '${areaMin}' || '';
  var areaMax = '${areaMax}' || '';

  // ========== 가격 필터 변수 ==========
  var priceMin = '${priceMin}' || '';
  var priceMax = '${priceMax}' || '';
  var rentMin = '${rentMin}' || '';
  var rentMax = '${rentMax}' || '';

  // ========== 가격 팝업 ==========
  function openPricePopup() {
    closeAreaPopup();
    $('#pricePopup').show();
    $('#filterPopupOverlay').show();
    updatePriceDisplay();
    updateRentDisplay();
  }

  function closePricePopup() {
    $('#pricePopup').hide();
    $('#filterPopupOverlay').hide();
  }

  // 가격 버튼 클릭
  $(document).on('click', '#priceBtns .filter-quick-btn', function() {
    var $btn = $(this);
    if ($btn.hasClass('active')) {
      $btn.removeClass('active');
      if ($('#priceBtns .filter-quick-btn.active').length === 0) {
        priceMin = '';
        priceMax = '';
      } else {
        recalculatePriceRange();
      }
    } else {
      $btn.addClass('active');
      recalculatePriceRange();
    }
    updatePriceDisplay();
    applyPriceFilter();
  });

  // 월세 버튼 클릭
  $(document).on('click', '#rentBtns .filter-quick-btn', function() {
    var $btn = $(this);
    if ($btn.hasClass('active')) {
      $btn.removeClass('active');
      if ($('#rentBtns .filter-quick-btn.active').length === 0) {
        rentMin = '';
        rentMax = '';
      } else {
        recalculateRentRange();
      }
    } else {
      $btn.addClass('active');
      recalculateRentRange();
    }
    updateRentDisplay();
    applyPriceFilter();
  });

  function recalculatePriceRange() {
    var activeBtns = $('#priceBtns .filter-quick-btn.active');
    if (activeBtns.length === 0) {
      priceMin = '';
      priceMax = '';
      return;
    }
    var mins = [], maxs = [];
    activeBtns.each(function() {
      var m = $(this).data('min');
      var x = $(this).data('max');
      if (m !== '' && m !== undefined) mins.push(parseInt(m));
      if (x !== '' && x !== undefined) maxs.push(parseInt(x));
    });
    priceMin = mins.length > 0 ? Math.min.apply(null, mins) : '';
    priceMax = maxs.length > 0 ? Math.max.apply(null, maxs) : '';
  }

  function recalculateRentRange() {
    var activeBtns = $('#rentBtns .filter-quick-btn.active');
    if (activeBtns.length === 0) {
      rentMin = '';
      rentMax = '';
      return;
    }
    var mins = [], maxs = [];
    activeBtns.each(function() {
      var m = $(this).data('min');
      var x = $(this).data('max');
      if (m !== '' && m !== undefined) mins.push(parseInt(m));
      if (x !== '' && x !== undefined) maxs.push(parseInt(x));
    });
    rentMin = mins.length > 0 ? Math.min.apply(null, mins) : '';
    rentMax = maxs.length > 0 ? Math.max.apply(null, maxs) : '';
  }

  function formatPriceText(min, max, unit) {
    unit = unit || '만원';
    if (!min && !max) return '전체';

    function toDisplay(val) {
      if (val >= 10000) return (val / 10000) + '억';
      return val + '만';
    }

    if (min && max) return toDisplay(min) + '~' + toDisplay(max);
    if (min) return toDisplay(min) + '~';
    return '~' + toDisplay(max);
  }

  function updatePriceDisplay() {
    var text = formatPriceText(priceMin, priceMax);
    $('#priceRangeText').text(text);
    updatePriceLabel();
  }

  function updateRentDisplay() {
    var text = '전체';
    if (rentMin || rentMax) {
      if (rentMin && rentMax) text = rentMin + '만~' + rentMax + '만';
      else if (rentMin) text = rentMin + '만~';
      else text = '~' + rentMax + '만';
    }
    $('#rentRangeText').text(text);
    updatePriceLabel();
  }

  function updatePriceLabel() {
    if (priceMin || priceMax || rentMin || rentMax) {
      $('#priceFilterLabel').text('가격설정');
      $('.filter-popup-btn').first().addClass('active');
    } else {
      $('#priceFilterLabel').text('가격대');
      $('.filter-popup-btn').first().removeClass('active');
    }
  }

  function applyPriceDirect() {
    var min = $('#priceMinDirect').val();
    var max = $('#priceMaxDirect').val();
    if (min) priceMin = parseInt(min);
    if (max) priceMax = parseInt(max);
    $('#priceBtns .filter-quick-btn').removeClass('active');
    updatePriceDisplay();
    applyPriceFilter();
  }

  function applyRentDirect() {
    var min = $('#rentMinDirect').val();
    var max = $('#rentMaxDirect').val();
    if (min) rentMin = parseInt(min);
    if (max) rentMax = parseInt(max);
    $('#rentBtns .filter-quick-btn').removeClass('active');
    updateRentDisplay();
    applyPriceFilter();
  }

  function applyPriceFilter() {
    $('#priceMinInput').val(priceMin);
    $('#priceMaxInput').val(priceMax);
    $('#rentMinInput').val(rentMin);
    $('#rentMaxInput').val(rentMax);
  }

  function resetPriceFilter() {
    priceMin = '';
    priceMax = '';
    rentMin = '';
    rentMax = '';
    $('#priceBtns .filter-quick-btn').removeClass('active');
    $('#rentBtns .filter-quick-btn').removeClass('active');
    $('#priceMinDirect, #priceMaxDirect, #rentMinDirect, #rentMaxDirect').val('');
    updatePriceDisplay();
    updateRentDisplay();
    applyPriceFilter();
  }

  // ========== 면적 팝업 ==========
  function openAreaPopup() {
    closePricePopup();
    $('#areaPopup').show();
    $('#filterPopupOverlay').show();
    updateAreaDisplay();
  }

  function closeAreaPopup() {
    $('#areaPopup').hide();
    $('#filterPopupOverlay').hide();
  }

  // 단위 전환
  $(document).on('click', '.area-unit-tab', function() {
    $('.area-unit-tab').removeClass('active');
    $(this).addClass('active');
    areaUnit = $(this).data('unit');

    if (areaUnit === 'm2') {
      $('#areaBtnsPyeong').hide();
      $('#areaBtnsM2').show();
      if (areaMin) areaMin = Math.round(parseFloat(areaMin) * 3.3058);
      if (areaMax) areaMax = Math.round(parseFloat(areaMax) * 3.3058);
    } else {
      $('#areaBtnsPyeong').show();
      $('#areaBtnsM2').hide();
      if (areaMin) areaMin = Math.round(parseFloat(areaMin) / 3.3058);
      if (areaMax) areaMax = Math.round(parseFloat(areaMax) / 3.3058);
    }
    updateAreaDisplay();
    updateQuickBtnState();
  });

  // 면적 버튼 클릭
  $(document).on('click', '.area-quick-btn', function() {
    var $btn = $(this);
    var min = $btn.data('min');
    var max = $btn.data('max');

    if ($btn.hasClass('active')) {
      $btn.removeClass('active');
      if ($('.area-quick-btn.active').length === 0) {
        areaMin = '';
        areaMax = '';
      } else {
        recalculateRange();
      }
    } else {
      $btn.addClass('active');
      recalculateRange();
    }

    updateAreaDisplay();
    applyAreaFilter();
  });

  function recalculateRange() {
    var activeBtns = $('.area-quick-btns:visible .area-quick-btn.active');
    if (activeBtns.length === 0) {
      areaMin = '';
      areaMax = '';
      return;
    }

    var mins = [], maxs = [];
    activeBtns.each(function() {
      var m = $(this).data('min');
      var x = $(this).data('max');
      if (m !== '' && m !== undefined) mins.push(parseInt(m));
      if (x !== '' && x !== undefined) maxs.push(parseInt(x));
    });

    areaMin = mins.length > 0 ? Math.min.apply(null, mins) : '';
    areaMax = maxs.length > 0 ? Math.max.apply(null, maxs) : '';
  }

  function updateAreaDisplay() {
    var unitStr = areaUnit === 'm2' ? '㎡' : '평';
    var text = '전체';

    if (areaMin && areaMax) {
      text = areaMin + unitStr + '~' + areaMax + unitStr;
    } else if (areaMin) {
      text = areaMin + unitStr + '~';
    } else if (areaMax) {
      text = '~' + areaMax + unitStr;
    }

    $('#areaRangeText').text(text);

    if (areaMin || areaMax) {
      var label = '';
      if (areaMin && areaMax) label = areaMin + '~' + areaMax + unitStr;
      else if (areaMin) label = areaMin + unitStr + '~';
      else label = '~' + areaMax + unitStr;
      $('#areaFilterLabel').text(label);
      $('.filter-popup-btn').last().addClass('active');
    } else {
      $('#areaFilterLabel').text('면적');
      $('.filter-popup-btn').last().removeClass('active');
    }
  }

  function updateQuickBtnState() {
    $('.area-quick-btn').removeClass('active');
    if (areaMin || areaMax) {
      $('.area-quick-btns:visible .area-quick-btn').each(function() {
        var btnMin = $(this).data('min');
        var btnMax = $(this).data('max');

        if (btnMin === '' && areaMin === '' && btnMax == areaMax) {
          $(this).addClass('active');
        } else if (btnMax === '' && areaMax === '' && btnMin == areaMin) {
          $(this).addClass('active');
        } else if (btnMin == areaMin && btnMax == areaMax) {
          $(this).addClass('active');
        }
      });
    }
  }

  function applyAreaFilter() {
    $('#areaMinInput').val(areaMin);
    $('#areaMaxInput').val(areaMax);
    $('#areaUnitInput').val(areaUnit);
  }

  function resetAreaFilter() {
    areaMin = '';
    areaMax = '';
    $('.area-quick-btn').removeClass('active');
    updateAreaDisplay();
    applyAreaFilter();
  }

  // ========== 공통 ==========
  function fnGoPage(no) {
    if (no < 1 || no > ${totalPage}) return;
    $('#pageNoInput').val(no);
    $('#filterForm').submit();
  }
  function fnFilter() {
    $('#pageNoInput').val(1);
    $('#filterForm').submit();
  }
  function fnReset() {
    $('#filterForm').find('select[name="dealType"]').val('');
    $('#filterForm').find('input[name="keyword"]').val('');
    // 면적 초기화
    $('#areaMinInput').val('');
    $('#areaMaxInput').val('');
    areaMin = '';
    areaMax = '';
    $('.area-quick-btn').removeClass('active');
    // 가격 초기화
    $('#priceMinInput, #priceMaxInput, #rentMinInput, #rentMaxInput').val('');
    priceMin = '';
    priceMax = '';
    rentMin = '';
    rentMax = '';
    $('#priceBtns .filter-quick-btn, #rentBtns .filter-quick-btn').removeClass('active');

    updateAreaDisplay();
    updatePriceDisplay();
    updateRentDisplay();
    $('#pageNoInput').val(1);
    $('#filterForm').submit();
  }
  function fnGoDetail(propType, propCd) {
    $('#detailType').val(propType);
    $('#detailId').val(propCd);
    $('#goDetailForm').submit();
  }
  function fnGoAdmin() {
    var foType = '${type}';
    var catCd = (foType && foType !== 'all') ? foType.toUpperCase() : '';
    var dealType = $('select[name="dealType"]').val() || '';

    $('#adminCatCd').val(catCd);
    $('#adminDealType').val(dealType);
    $('#goAdminForm').submit();
  }

  // 초기화
  $(function() {
    updateAreaDisplay();
    updateQuickBtnState();
    updatePriceDisplay();
    updateRentDisplay();

    // ESC 키로 닫기
    $(document).on('keydown', function(e) {
      if (e.key === 'Escape') {
        closeAreaPopup();
        closePricePopup();
      }
    });
  });
</script>

<!-- 필터 팝업 오버레이 -->
<div id="filterPopupOverlay" class="filter-popup-overlay" style="display:none;" onclick="closeAreaPopup();closePricePopup();"></div>

<!-- 필터 스타일 -->
<style>
/* 필터 버튼 공통 */
.filter-popup-btn {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 14px;
  background: white;
  border: 1px solid var(--gray-200);
  border-radius: 6px;
  font-size: 14px;
  color: var(--gray-600);
  cursor: pointer;
  transition: all 0.2s;
  white-space: nowrap;
}
.filter-popup-btn:hover { border-color: var(--navy); }
.filter-popup-btn.active {
  background: var(--navy);
  color: white;
  border-color: var(--navy);
}
.filter-arrow { font-size: 10px; opacity: 0.6; }

/* 팝업 오버레이 */
.filter-popup-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.3);
  z-index: 999;
}

/* 필터 팝업 공통 */
.filter-popup, .area-popup {
  position: absolute;
  top: 100%;
  left: 0;
  margin-top: 8px;
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 24px rgba(0,0,0,0.15);
  z-index: 1000;
  width: 420px;
  max-width: 95vw;
  max-height: 80vh;
  overflow-y: auto;
}

.filter-popup-header, .area-popup-header {
  display: flex;
  align-items: center;
  padding: 16px 20px;
  border-bottom: 1px solid var(--gray-100);
  position: sticky;
  top: 0;
  background: white;
  z-index: 1;
}
.filter-popup-title, .area-popup-title {
  font-size: 16px;
  font-weight: 700;
  color: var(--navy);
  margin-right: auto;
}
.filter-popup-close, .area-popup-close {
  background: none;
  border: none;
  font-size: 20px;
  color: var(--gray-400);
  cursor: pointer;
  padding: 4px 8px;
}
.filter-popup-close:hover, .area-popup-close:hover { color: var(--gray-600); }

.filter-popup-body, .area-popup-body { padding: 20px; }

/* 범위 표시 */
.filter-range-display, .area-range-display {
  text-align: center;
  margin-bottom: 16px;
}
.filter-range-display span, .area-range-display span {
  font-size: 18px;
  font-weight: 700;
  color: #2db400;
}

/* 섹션 타이틀 */
.filter-section-title {
  font-size: 14px;
  font-weight: 700;
  color: var(--navy);
  margin: 24px 0 12px;
  padding-top: 16px;
  border-top: 1px solid var(--gray-100);
}

/* 빠른 선택 버튼 */
.filter-quick-btns, .area-quick-btns {
  display: grid;
  grid-template-columns: repeat(6, 1fr);
  gap: 8px;
}
.filter-quick-btn, .area-quick-btn {
  padding: 10px 6px;
  border: 1px solid var(--gray-200);
  background: white;
  border-radius: 6px;
  font-size: 13px;
  color: var(--gray-600);
  cursor: pointer;
  transition: all 0.2s;
  text-align: center;
}
.filter-quick-btn:hover, .area-quick-btn:hover {
  border-color: #2db400;
  color: #2db400;
}
.filter-quick-btn.active, .area-quick-btn.active {
  background: #2db400;
  border-color: #2db400;
  color: white;
  font-weight: 600;
}

/* 직접 입력 */
.filter-input-row {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 16px;
}
.filter-input-group {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 6px;
  background: var(--gray-50);
  border: 1px solid var(--gray-200);
  border-radius: 6px;
  padding: 6px 10px;
}
.filter-input-label {
  font-size: 12px;
  color: var(--gray-500);
  white-space: nowrap;
}
.filter-input-group input {
  flex: 1;
  border: none;
  background: transparent;
  font-size: 14px;
  width: 60px;
  text-align: right;
}
.filter-input-group input:focus { outline: none; }
.filter-input-sep {
  color: var(--gray-400);
  font-size: 14px;
}
.filter-input-apply {
  padding: 8px 14px;
  background: var(--navy);
  color: white;
  border: none;
  border-radius: 6px;
  font-size: 13px;
  cursor: pointer;
  white-space: nowrap;
}
.filter-input-apply:hover { opacity: 0.9; }

/* 조건 삭제 */
.filter-popup-footer, .area-popup-footer {
  margin-top: 16px;
  text-align: right;
}
.filter-reset-btn, .area-reset-btn {
  background: none;
  border: none;
  color: var(--gray-500);
  font-size: 13px;
  cursor: pointer;
  padding: 6px 12px;
}
.filter-reset-btn:hover, .area-reset-btn:hover { color: var(--gray-700); }

/* 면적 팝업 추가 스타일 */
.area-unit-tabs {
  display: flex;
  background: var(--gray-100);
  border-radius: 6px;
  padding: 3px;
}
.area-unit-tab {
  padding: 6px 14px;
  border: none;
  background: transparent;
  font-size: 13px;
  color: var(--gray-500);
  cursor: pointer;
  border-radius: 4px;
  transition: all 0.2s;
}
.area-unit-tab.active {
  background: white;
  color: var(--navy);
  font-weight: 600;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}
.area-quick-btns {
  grid-template-columns: repeat(4, 1fr);
}

/* 모바일 대응 */
@media (max-width: 768px) {
  .filter-popup, .area-popup {
    position: fixed;
    top: auto;
    bottom: 0;
    left: 0;
    right: 0;
    margin: 0;
    width: 100%;
    max-width: 100%;
    border-radius: 16px 16px 0 0;
    max-height: 80vh;
  }
  .filter-quick-btns {
    grid-template-columns: repeat(4, 1fr);
  }
  .area-quick-btns {
    grid-template-columns: repeat(3, 1fr);
  }
  .prop-filter {
    flex-wrap: wrap;
  }
}
</style>

<form id="goDetailForm" action="${ctx}/property/viewPropertyDetail" method="post">
  <input type="hidden" name="type" id="detailType" />
  <input type="hidden" name="id" id="detailId" />
</form>

<form id="goAdminForm" action="${ctx}/propertyMng/viewPropertyMng" method="post" target="_blank">
  <input type="hidden" name="catCd" id="adminCatCd" />
  <input type="hidden" name="dealType" id="adminDealType" />
</form>

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>
</body>
</html>
