<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>

<c:set var="typeNm" value="전체매물" />
<c:if test="${type eq 'apt'}"><c:set var="typeNm" value="아파트" /></c:if>
<c:if test="${type eq 'officetel'}"><c:set var="typeNm" value="오피스텔" /></c:if>
<c:if test="${type eq 'shop'}"><c:set var="typeNm" value="상가" /></c:if>
<c:if test="${type eq 'office'}"><c:set var="typeNm" value="사무실" /></c:if>

<div class="page-header">
  <h2>${typeNm}</h2>
</div>

<div class="content-layout">
  <%@ include file="/WEB-INF/views/front/property/inc/sidebarProperty.jsp" %>

  <div class="content-main">

    <!-- 검색 필터 -->
    <div class="prop-filter">
      <select id="filterType">
        <option value="all" ${type eq 'all' ? 'selected' : ''}>전체유형</option>
        <option value="apt" ${type eq 'apt' ? 'selected' : ''}>아파트</option>
        <option value="officetel" ${type eq 'officetel' ? 'selected' : ''}>오피스텔</option>
        <option value="shop" ${type eq 'shop' ? 'selected' : ''}>상가</option>
        <option value="office" ${type eq 'office' ? 'selected' : ''}>사무실</option>
      </select>
      <select id="filterDeal">
        <option value="">거래유형</option>
        <option value="sell">매매</option>
        <option value="jeonse">전세</option>
        <option value="wolse">월세</option>
        <option value="rent">임대</option>
      </select>
      <select id="filterPrice">
        <option value="">가격대</option>
        <option value="~1">1억 이하</option>
        <option value="1~3">1억 ~ 3억</option>
        <option value="3~5">3억 ~ 5억</option>
        <option value="5~">5억 이상</option>
      </select>
      <select id="filterArea">
        <option value="">면적</option>
        <option value="~10">10평 이하</option>
        <option value="10~20">10평 ~ 20평</option>
        <option value="20~30">20평 ~ 30평</option>
        <option value="30~">30평 이상</option>
      </select>
      <input type="text" id="filterKeyword" placeholder="매물명 또는 주소 검색" />
      <button type="button" class="prop-filter-btn" onclick="fnSearch()">검색</button>
      <button type="button" class="prop-filter-reset" onclick="fnReset()">초기화</button>
    </div>

    <!-- 결과 건수 + 정렬 -->
    <div class="prop-result-info">
      <div class="prop-result-cnt">총 <strong>10</strong>건의 매물</div>
      <div class="prop-sort">
        <select>
          <option>최신순</option>
          <option>가격낮은순</option>
          <option>가격높은순</option>
          <option>면적넓은순</option>
        </select>
      </div>
    </div>

    <!-- 매물 카드 그리드 -->
    <div class="prop-grid">

      <c:if test="${type eq 'all' or type eq 'apt'}">
      <div class="prop-card" onclick="location.href='${ctx}/property/viewPropertyDetail?type=apt&id=1'">
        <div class="prop-card-img apt">
          <span class="prop-card-emoji">🏢</span>
          <span class="prop-card-badge">추천</span>
        </div>
        <div class="prop-card-body">
          <div class="prop-card-type">아파트 · 매매</div>
          <div class="prop-card-title">프리머스타워 32평</div>
          <div class="prop-card-loc">📍 부천시 길주로 280</div>
          <div class="prop-card-price">5억 2,000 <span>만원</span></div>
          <div class="prop-card-info">
            <span>🏠 32평</span><span>🚪 3룸</span><span>📐 15층</span>
          </div>
        </div>
      </div>

      <div class="prop-card">
        <div class="prop-card-img apt">
          <span class="prop-card-emoji">🏢</span>
          <span class="prop-card-badge" style="background:#0052A4;">신규</span>
        </div>
        <div class="prop-card-body">
          <div class="prop-card-type">아파트 · 전세</div>
          <div class="prop-card-title">부천 중동 센트럴파크</div>
          <div class="prop-card-loc">📍 부천시 중동로 120</div>
          <div class="prop-card-price">3억 5,000 <span>만원</span></div>
          <div class="prop-card-info">
            <span>🏠 28평</span><span>🚪 3룸</span><span>📐 8층</span>
          </div>
        </div>
      </div>

      <div class="prop-card">
        <div class="prop-card-img apt">
          <span class="prop-card-emoji">🏢</span>
        </div>
        <div class="prop-card-body">
          <div class="prop-card-type">아파트 · 월세</div>
          <div class="prop-card-title">중동 현대아파트 24평</div>
          <div class="prop-card-loc">📍 부천시 중동로 88</div>
          <div class="prop-card-price">1,000/80 <span>만원</span></div>
          <div class="prop-card-info">
            <span>🏠 24평</span><span>🚪 2룸</span><span>📐 12층</span>
          </div>
        </div>
      </div>
      </c:if>

      <c:if test="${type eq 'all' or type eq 'officetel'}">
      <div class="prop-card">
        <div class="prop-card-img officetel">
          <span class="prop-card-emoji">🏬</span>
          <span class="prop-card-badge" style="background:#0052A4;">신규</span>
        </div>
        <div class="prop-card-body">
          <div class="prop-card-type">오피스텔 · 월세</div>
          <div class="prop-card-title">중동역 스카이뷰</div>
          <div class="prop-card-loc">📍 부천시 중동로 45</div>
          <div class="prop-card-price">500/60 <span>만원</span></div>
          <div class="prop-card-info">
            <span>🏠 12평</span><span>🚪 원룸</span><span>📐 8층</span>
          </div>
        </div>
      </div>

      <div class="prop-card">
        <div class="prop-card-img officetel">
          <span class="prop-card-emoji">🏬</span>
        </div>
        <div class="prop-card-body">
          <div class="prop-card-type">오피스텔 · 전세</div>
          <div class="prop-card-title">부천 센트럴파크 오피스텔</div>
          <div class="prop-card-loc">📍 부천시 길주로 150</div>
          <div class="prop-card-price">1억 4,500 <span>만원</span></div>
          <div class="prop-card-info">
            <span>🏠 24평</span><span>🚪 1.5룸</span><span>📐 10층</span>
          </div>
        </div>
      </div>

      <div class="prop-card">
        <div class="prop-card-img officetel">
          <span class="prop-card-emoji">🏬</span>
          <span class="prop-card-badge">추천</span>
        </div>
        <div class="prop-card-body">
          <div class="prop-card-type">오피스텔 · 월세</div>
          <div class="prop-card-title">신중동역 원룸 오피스텔</div>
          <div class="prop-card-loc">📍 부천시 부천로 55</div>
          <div class="prop-card-price">300/45 <span>만원</span></div>
          <div class="prop-card-info">
            <span>🏠 8평</span><span>🚪 원룸</span><span>📐 5층</span>
          </div>
        </div>
      </div>
      </c:if>

      <c:if test="${type eq 'all' or type eq 'shop'}">
      <div class="prop-card">
        <div class="prop-card-img shop">
          <span class="prop-card-emoji">🏪</span>
          <span class="prop-card-badge" style="background:#dc3545;">급매</span>
        </div>
        <div class="prop-card-body">
          <div class="prop-card-type">상가 · 임대</div>
          <div class="prop-card-title">신중동역 로데오 상가 1층</div>
          <div class="prop-card-loc">📍 부천시 부천로 98</div>
          <div class="prop-card-price">3,000/180 <span>만원</span></div>
          <div class="prop-card-info">
            <span>🏠 18평</span><span>🚪 1층</span><span>📐 코너</span>
          </div>
        </div>
      </div>

      <div class="prop-card">
        <div class="prop-card-img shop">
          <span class="prop-card-emoji">🏪</span>
        </div>
        <div class="prop-card-body">
          <div class="prop-card-type">상가 · 매매</div>
          <div class="prop-card-title">중동역 먹자골목 상가</div>
          <div class="prop-card-loc">📍 부천시 중동로 33</div>
          <div class="prop-card-price">2억 8,000 <span>만원</span></div>
          <div class="prop-card-info">
            <span>🏠 15평</span><span>🚪 1층</span><span>📐 대로변</span>
          </div>
        </div>
      </div>
      </c:if>

      <c:if test="${type eq 'all' or type eq 'office'}">
      <div class="prop-card">
        <div class="prop-card-img office">
          <span class="prop-card-emoji">🏛️</span>
          <span class="prop-card-badge" style="background:#0052A4;">신규</span>
        </div>
        <div class="prop-card-body">
          <div class="prop-card-type">사무실 · 임대</div>
          <div class="prop-card-title">프리머스타워 사무실 A호</div>
          <div class="prop-card-loc">📍 부천시 길주로 280</div>
          <div class="prop-card-price">1,000/90 <span>만원</span></div>
          <div class="prop-card-info">
            <span>🏠 25평</span><span>🚪 3층</span><span>📐 주차가능</span>
          </div>
        </div>
      </div>

      <div class="prop-card">
        <div class="prop-card-img office">
          <span class="prop-card-emoji">🏛️</span>
        </div>
        <div class="prop-card-body">
          <div class="prop-card-type">사무실 · 임대</div>
          <div class="prop-card-title">중동역 오피스빌딩 502호</div>
          <div class="prop-card-loc">📍 부천시 중동로 60</div>
          <div class="prop-card-price">500/55 <span>만원</span></div>
          <div class="prop-card-info">
            <span>🏠 14평</span><span>🚪 5층</span><span>📐 역세권</span>
          </div>
        </div>
      </div>
      </c:if>

    </div><!-- /prop-grid -->

    <!-- 페이징 -->
    <div class="board-paging">
      <a href="javascript:void(0)" class="disabled">이전</a>
      <a href="javascript:void(0)" class="active">1</a>
      <a href="javascript:void(0)">2</a>
      <a href="javascript:void(0)">3</a>
      <a href="javascript:void(0)">4</a>
      <a href="javascript:void(0)">5</a>
      <a href="javascript:void(0)">다음</a>
    </div>

  </div><!-- /content-main -->
</div><!-- /content-layout -->

<script>
  function fnSearch() {
    var type = $('#filterType').val();
    location.href = '${ctx}/property/viewPropertyList?type=' + type;
  }
  function fnReset() {
    location.href = '${ctx}/property/viewPropertyList?type=all';
  }
  // 유형 select 변경 시 사이드바랑 동기화
  $('#filterType').on('change', function() {
    fnSearch();
  });
</script>

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>

</body>
</html>
