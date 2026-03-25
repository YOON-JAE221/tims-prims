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
      <input type="hidden" name="priceMin" id="priceMinInput" value="${priceMin}" />
      <input type="hidden" name="priceMax" id="priceMaxInput" value="${priceMax}" />
      <input type="hidden" name="rentMin" id="rentMinInput" value="${rentMin}" />
      <input type="hidden" name="rentMax" id="rentMaxInput" value="${rentMax}" />

      <%-- 중분류가 있을 때만 분류 필터 표시 --%>
      <c:if test="${not empty midCatList}">
        <div class="prop-filter-category">
          <span class="filter-category-label">상세 분류</span>
          <select name="midCatCd" id="midCatCdSelect" onchange="fnMidCatChange()">
            <option value="">중분류 전체</option>
            <c:forEach var="midCat" items="${midCatList}">
              <option value="${midCat.midCatCd}" <c:if test="${midCatCd eq midCat.midCatCd}">selected</c:if>>${midCat.catNm}</option>
            </c:forEach>
          </select>
          <c:if test="${not empty subCatList}">
            <select name="subCatCd" id="subCatCdSelect" onchange="fnFilter()">
              <option value="">소분류 전체</option>
              <c:forEach var="subCat" items="${subCatList}">
                <option value="${subCat.subCatCd}" <c:if test="${subCatCd eq subCat.subCatCd}">selected</c:if>>${subCat.catNm}</option>
              </c:forEach>
            </select>
          </c:if>
        </div>
      </c:if>

      <div class="prop-filter">
        <select name="type" class="mo-only" onchange="fnTypeChange(this.value)">
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
        <!-- 층수 필터 -->
        <select name="floorType" onchange="fnFilter()">
          <option value="">전체층</option>
          <option value="1" ${floorType eq '1' ? 'selected' : ''}>1층</option>
          <option value="upper" ${floorType eq 'upper' ? 'selected' : ''}>지상(2층~)</option>
          <option value="under" ${floorType eq 'under' ? 'selected' : ''}>지하</option>
        </select>
        <!-- 가격/월세/면적 필터 버튼 -->
        <div class="filter-popup-btn-group">
          <button type="button" class="filter-popup-btn ${(not empty priceMin and priceMin ne '') or (not empty priceMax and priceMax ne '') ? 'active' : ''}" onclick="openPricePopup()">
            <span id="priceFilterLabel">
              <c:choose>
                <c:when test="${(not empty priceMin and priceMin ne '') and (not empty priceMax and priceMax ne '')}">${priceMin}~${priceMax}만</c:when>
                <c:when test="${not empty priceMin and priceMin ne ''}">${priceMin}만~</c:when>
                <c:when test="${not empty priceMax and priceMax ne ''}">~${priceMax}만</c:when>
                <c:otherwise>가격</c:otherwise>
              </c:choose>
            </span>
            <span class="filter-arrow">▼</span>
          </button>
          <button type="button" class="filter-popup-btn ${(not empty rentMin and rentMin ne '') or (not empty rentMax and rentMax ne '') ? 'active' : ''}" onclick="openRentPopup()">
            <span id="rentFilterLabel">
              <c:choose>
                <c:when test="${(not empty rentMin and rentMin ne '') and (not empty rentMax and rentMax ne '')}">${rentMin}~${rentMax}만</c:when>
                <c:when test="${not empty rentMin and rentMin ne ''}">${rentMin}만~</c:when>
                <c:when test="${not empty rentMax and rentMax ne ''}">~${rentMax}만</c:when>
                <c:otherwise>월세</c:otherwise>
              </c:choose>
            </span>
            <span class="filter-arrow">▼</span>
          </button>
          <button type="button" class="filter-popup-btn ${(not empty areaMin and areaMin ne '') or (not empty areaMax and areaMax ne '') ? 'active' : ''}" onclick="openAreaPopup()">
            <span id="areaFilterLabel">
              <c:choose>
                <c:when test="${(not empty areaMin and areaMin ne '') and (not empty areaMax and areaMax ne '')}">${areaMin}~${areaMax}평</c:when>
                <c:when test="${not empty areaMin and areaMin ne ''}">${areaMin}평~</c:when>
                <c:when test="${not empty areaMax and areaMax ne ''}">~${areaMax}평</c:when>
                <c:otherwise>면적</c:otherwise>
              </c:choose>
            </span>
            <span class="filter-arrow">▼</span>
          </button>
        </div>
        <input type="text" name="keyword" value="${keyword}" placeholder="매물번호/매물명 검색" />
        <div class="prop-filter-btns">
          <button type="submit" class="prop-filter-btn">검색</button>
          <button type="button" class="prop-filter-reset" onclick="fnReset()">초기화</button>
        </div>
      </div>
    </form>

    <!-- 가격 필터 팝업 (매매가/전세가/보증금) -->
    <div id="pricePopup" class="filter-popup" style="display:none;">
      <div class="filter-popup-header">
        <span class="filter-popup-title">매매가 / 전세가 / 보증금</span>
        <button type="button" class="filter-popup-close" onclick="closePricePopup()">×</button>
      </div>
      <div class="filter-popup-body">
        <div class="filter-input-row">
          <div class="filter-input-group">
            <input type="number" id="priceMinDirect" value="${priceMin}" placeholder="최소" />
            <span class="filter-input-unit">만원</span>
          </div>
          <span class="filter-input-sep">~</span>
          <div class="filter-input-group">
            <input type="number" id="priceMaxDirect" value="${priceMax}" placeholder="최대" />
            <span class="filter-input-unit">만원</span>
          </div>
        </div>
        <div class="filter-popup-btns">
          <button type="button" class="filter-reset-btn" onclick="resetPriceFilter()">초기화</button>
          <button type="button" class="filter-apply-btn" onclick="applyPriceFilter()">적용</button>
        </div>
      </div>
    </div>

    <!-- 월세 필터 팝업 -->
    <div id="rentPopup" class="filter-popup" style="display:none;">
      <div class="filter-popup-header">
        <span class="filter-popup-title">월세</span>
        <button type="button" class="filter-popup-close" onclick="closeRentPopup()">×</button>
      </div>
      <div class="filter-popup-body">
        <div class="filter-input-row">
          <div class="filter-input-group">
            <input type="number" id="rentMinDirect" value="${rentMin}" placeholder="최소" />
            <span class="filter-input-unit">만원</span>
          </div>
          <span class="filter-input-sep">~</span>
          <div class="filter-input-group">
            <input type="number" id="rentMaxDirect" value="${rentMax}" placeholder="최대" />
            <span class="filter-input-unit">만원</span>
          </div>
        </div>
        <div class="filter-popup-btns">
          <button type="button" class="filter-reset-btn" onclick="resetRentFilter()">초기화</button>
          <button type="button" class="filter-apply-btn" onclick="applyRentFilter()">적용</button>
        </div>
      </div>
    </div>

    <!-- 면적 필터 팝업 -->
    <div id="areaPopup" class="filter-popup" style="display:none;">
      <div class="filter-popup-header">
        <span class="filter-popup-title">전용면적 (평)</span>
        <button type="button" class="filter-popup-close" onclick="closeAreaPopup()">×</button>
      </div>
      <div class="filter-popup-body">
        <div class="filter-input-row">
          <div class="filter-input-group">
            <input type="number" id="areaMinDirect" value="${areaMin}" placeholder="최소" />
            <span class="filter-input-unit">평</span>
          </div>
          <span class="filter-input-sep">~</span>
          <div class="filter-input-group">
            <input type="number" id="areaMaxDirect" value="${areaMax}" placeholder="최대" />
            <span class="filter-input-unit">평</span>
          </div>
        </div>
        <div class="filter-popup-btns">
          <button type="button" class="filter-reset-btn" onclick="resetAreaFilter()">초기화</button>
          <button type="button" class="filter-apply-btn" onclick="applyAreaFilter()">적용</button>
        </div>
      </div>
    </div>

    <!-- 팝업 오버레이 -->
    <div id="filterPopupOverlay" class="filter-popup-overlay" style="display:none;" onclick="closeAllPopup()"></div>

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
      <c:forEach var="prop" items="${list}" varStatus="status">
        <div class="prop-card ${prop.soldYn eq 'Y' ? 'sold-card' : ''}" onclick="fnGoDetail('${prop.catCd}','${prop.propCd}')">
          <div class="prop-card-img ${fn:toLowerCase(prop.catCd)}">
            <c:choose>
              <c:when test="${not empty prop.thumbPath}">
                <img src="/upload/${prop.thumbPath}" alt="${prop.propNm}"
                     class="prop-thumb-img"
                     loading="${status.index < 6 ? 'eager' : 'lazy'}"
                     decoding="async"
                     onload="this.classList.add('loaded')"
                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                <span class="prop-card-emoji" style="display:none;">
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
            <c:if test="${prop.soldYn eq 'Y'}">
              <span class="prop-card-badge" style="background:var(--gray-400);">거래완료</span>
              <div style="position:absolute; inset:0; background:rgba(0,0,0,0.35); display:flex; align-items:center; justify-content:center;">
                <span style="color:white; font-size:18px; font-weight:800; letter-spacing:2px;">거래완료</span>
              </div>
            </c:if>
          </div>
          <div class="prop-card-body">
            <div class="prop-card-type">${prop.catNm}<c:if test="${not empty prop.midCatNm}"> &gt; ${prop.midCatNm}</c:if><c:if test="${not empty prop.subCatNm}"> &gt; ${prop.subCatNm}</c:if></div>
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
            <c:if test="${not empty prop.areaExclusive and prop.areaExclusive > 0}">
              <div class="prop-card-area">
                <span>🏠 ${prop.areaExclusive}㎡ / <fmt:formatNumber value="${prop.areaExclusive * 0.3025}" pattern="#,##0.#"/>평</span>
                <c:if test="${not empty prop.floorNo}">
                  <span style="margin-left:10px;">📐 ${prop.floorNo}층<c:if test="${not empty prop.floorTotal}">/${prop.floorTotal}층</c:if></span>
                </c:if>
              </div>
            </c:if>
          </div>
        </div>
      </c:forEach>
    </div>

    <!-- 페이징 -->
    <c:if test="${totalPage > 0}">
      <c:set var="startPage" value="${((pageNo - 1) - ((pageNo - 1) mod 10)) + 1}" />
      <c:set var="endPage" value="${startPage + 9 > totalPage ? totalPage : startPage + 9}" />
      <div class="board-paging">
        <a href="javascript:fnGoPage(${pageNo - 1})" class="${pageNo <= 1 ? 'disabled' : ''}">이전</a>
        <c:forEach var="p" begin="${startPage}" end="${endPage}">
          <a href="javascript:fnGoPage(${p})" class="${p == pageNo ? 'active' : ''}">${p}</a>
        </c:forEach>
        <a href="javascript:fnGoPage(${pageNo + 1})" class="${pageNo >= totalPage ? 'disabled' : ''}">다음</a>
      </div>
    </c:if>

  </div>
</div>

<script>
  // ========== 팝업 제어 ==========
  function closeAllPopup() {
    $('#pricePopup, #rentPopup, #areaPopup').hide();
    $('#filterPopupOverlay').hide();
  }
  function openPricePopup() {
    closeAllPopup();
    $('#pricePopup').show();
    $('#filterPopupOverlay').show();
  }
  function closePricePopup() {
    $('#pricePopup').hide();
    $('#filterPopupOverlay').hide();
  }
  function openRentPopup() {
    closeAllPopup();
    $('#rentPopup').show();
    $('#filterPopupOverlay').show();
  }
  function closeRentPopup() {
    $('#rentPopup').hide();
    $('#filterPopupOverlay').hide();
  }
  function openAreaPopup() {
    closeAllPopup();
    $('#areaPopup').show();
    $('#filterPopupOverlay').show();
  }
  function closeAreaPopup() {
    $('#areaPopup').hide();
    $('#filterPopupOverlay').hide();
  }

  // ========== 가격 필터 (매매가/전세가/보증금) ==========
  function applyPriceFilter() {
    $('#priceMinInput').val($('#priceMinDirect').val());
    $('#priceMaxInput').val($('#priceMaxDirect').val());
    closePricePopup();
    fnFilter();
  }
  function resetPriceFilter() {
    $('#priceMinDirect, #priceMaxDirect').val('');
    $('#priceMinInput, #priceMaxInput').val('');
  }

  // ========== 월세 필터 ==========
  function applyRentFilter() {
    $('#rentMinInput').val($('#rentMinDirect').val());
    $('#rentMaxInput').val($('#rentMaxDirect').val());
    closeRentPopup();
    fnFilter();
  }
  function resetRentFilter() {
    $('#rentMinDirect, #rentMaxDirect').val('');
    $('#rentMinInput, #rentMaxInput').val('');
  }

  // ========== 면적 필터 ==========
  function applyAreaFilter() {
    $('#areaMinInput').val($('#areaMinDirect').val());
    $('#areaMaxInput').val($('#areaMaxDirect').val());
    closeAreaPopup();
    fnFilter();
  }
  function resetAreaFilter() {
    $('#areaMinDirect, #areaMaxDirect').val('');
    $('#areaMinInput, #areaMaxInput').val('');
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
    $('#filterForm').find('select[name="floorType"]').val('');
    $('#filterForm').find('select[name="midCatCd"]').val('');
    $('#filterForm').find('select[name="subCatCd"]').val('');
    $('#filterForm').find('input[name="keyword"]').val('');
    $('#areaMinInput, #areaMaxInput').val('');
    $('#priceMinInput, #priceMaxInput, #rentMinInput, #rentMaxInput').val('');
    $('#pageNoInput').val(1);
    $('#filterForm').submit();
  }
  // 대분류(type) 변경 시 - 페이지 이동 (중분류/소분류 초기화)
  function fnTypeChange(typeVal) {
    $('#pageNoInput').val(1);
    if ($('#midCatCdSelect').length) $('#midCatCdSelect').val('');
    if ($('#subCatCdSelect').length) $('#subCatCdSelect').val('');
    $('#filterForm').submit();
  }
  // 중분류 변경 시 - 소분류 초기화 후 검색
  function fnMidCatChange() {
    $('#subCatCdSelect').val('');
    fnFilter();
  }
  function fnGoAdmin() {
    var foType = '${type}';
    var catCd = (foType && foType !== 'all') ? foType.toUpperCase() : '';
    var dealType = $('select[name="dealType"]').val() || '';
    window.open('${ctx}/propertyMng/viewPropertyMng?catCd=' + encodeURIComponent(catCd) + '&dealType=' + encodeURIComponent(dealType), '_blank');
  }

  // ESC 키로 닫기
  $(document).on('keydown', function(e) {
    if (e.key === 'Escape') closeAllPopup();
  });
</script>

<form id="goDetailForm" action="${ctx}/property/viewPropertyDetail" method="post">
  <input type="hidden" name="type" id="detailType" />
  <input type="hidden" name="id" id="detailId" />
</form>

<script>
  function fnGoDetail(type, propCd) {
    document.getElementById('detailType').value = type;
    document.getElementById('detailId').value = propCd;
    document.getElementById('goDetailForm').submit();
  }
</script>

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>
</body>
</html>
