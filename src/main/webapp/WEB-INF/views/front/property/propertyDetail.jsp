<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>

<div class="page-header">
  <h2>매물 상세</h2>
</div>

<div class="content-layout">
  <%@ include file="/WEB-INF/views/front/property/inc/sidebarProperty.jsp" %>

  <div class="content-main">

    <!-- 상단: 이미지 + 기본정보 -->
    <div class="prop-detail-top">
      <div class="prop-detail-img apt">
        <span class="prop-card-emoji">🏢</span>
        <span class="prop-card-badge">추천</span>
      </div>
      <div class="prop-detail-summary">
        <div class="prop-detail-type">아파트 · 매매</div>
        <h2 class="prop-detail-title">프리머스타워 32평</h2>
        <div class="prop-detail-loc">📍 경기도 부천시 길주로 280 프리머스 부천타워</div>
        <div class="prop-detail-price">5억 2,000 <span>만원</span></div>

        <div class="prop-detail-tags">
          <span class="prop-tag">아파트</span>
          <span class="prop-tag">매매</span>
          <span class="prop-tag">중동역 도보 5분</span>
          <span class="prop-tag">주차 가능</span>
        </div>

        <div class="prop-detail-quick">
          <div class="prop-quick-item">
            <div class="prop-quick-label">전용면적</div>
            <div class="prop-quick-value">32평</div>
          </div>
          <div class="prop-quick-item">
            <div class="prop-quick-label">방/욕실</div>
            <div class="prop-quick-value">3룸 / 2욕실</div>
          </div>
          <div class="prop-quick-item">
            <div class="prop-quick-label">해당층</div>
            <div class="prop-quick-value">15층</div>
          </div>
          <div class="prop-quick-item">
            <div class="prop-quick-label">입주가능일</div>
            <div class="prop-quick-value">즉시입주</div>
          </div>
        </div>

        <a href="${ctx}/bbs/viewBbsWriteQna?brdCd=3ccd942dfcbf11f08771908d6ec6e544" class="btn-primary-primus" style="margin-top:20px; padding:12px 28px; font-size:14px;">이 매물 문의하기</a>
      </div>
    </div>

    <!-- 상세 정보 테이블 -->
    <div class="prop-detail-section">
      <h3 class="prop-detail-section-title">매물 정보</h3>
      <table class="prop-detail-table">
        <tr><th>매물유형</th><td>아파트</td><th>거래유형</th><td>매매</td></tr>
        <tr><th>매매가</th><td>5억 2,000만원</td><th>관리비</th><td>월 15만원</td></tr>
        <tr><th>전용면적</th><td>105.6㎡ (32평)</td><th>공급면적</th><td>132㎡ (40평)</td></tr>
        <tr><th>방수/욕실수</th><td>3룸 / 2욕실</td><th>해당층/총층</th><td>15층 / 25층</td></tr>
        <tr><th>방향</th><td>남향</td><th>현관구조</th><td>복도식</td></tr>
        <tr><th>입주가능일</th><td>즉시 입주 가능</td><th>주차</th><td>세대당 1대</td></tr>
        <tr><th>난방방식</th><td>개별난방 (도시가스)</td><th>건축년도</th><td>2020년</td></tr>
      </table>
    </div>

    <!-- 매물 설명 -->
    <div class="prop-detail-section">
      <h3 class="prop-detail-section-title">매물 설명</h3>
      <div class="prop-detail-desc">
        <p>부천 중동 프리머스타워 32평형 매매 매물입니다.</p>
        <p>중동역 도보 5분 거리의 초역세권 아파트로, 남향 채광이 뛰어나며 3룸 2욕실의 넓은 평면 구조입니다.</p>
        <p>단지 내 주차장, 피트니스센터, 어린이놀이터 등 커뮤니티 시설이 잘 갖춰져 있으며, 인근에 롯데시네마, 대형마트 등 생활 편의시설이 풍부합니다.</p>
        <p>깔끔한 올수리 상태로 입주 시 별도 인테리어 비용 없이 바로 생활 가능합니다.</p>
        <br>
        <p><strong>주요 특징:</strong></p>
        <p>· 중동역 도보 5분, 신중동역 도보 10분 초역세권</p>
        <p>· 남향 채광, 3룸 2욕실, 넓은 거실</p>
        <p>· 올수리 완료 (2024년), 즉시 입주 가능</p>
        <p>· 세대당 주차 1대, 관리비 월 15만원</p>
        <p>· 인근 학교: 중동초, 중동중, 중원고</p>
      </div>
    </div>

    <!-- 위치 지도 -->
    <div class="prop-detail-section">
      <h3 class="prop-detail-section-title">위치</h3>
      <div style="width:100%; height:300px; border-radius:12px; overflow:hidden; border:1px solid var(--gray-200);">
        <div id="propMap" style="width:100%; height:100%;"></div>
      </div>
      <div style="margin-top:10px; font-size:13px; color:var(--gray-400);">
        📍 경기도 부천시 길주로 280 프리머스 부천타워
      </div>
    </div>

    <!-- 문의 안내 -->
    <div class="prop-detail-section">
      <div class="prop-detail-cta">
        <div>
          <div style="font-size:16px; font-weight:700; color:var(--navy); margin-bottom:6px;">이 매물이 마음에 드시나요?</div>
          <div style="font-size:14px; color:var(--gray-500);">방문 상담 예약 또는 온라인 문의를 통해 자세한 안내를 받으실 수 있습니다.</div>
        </div>
        <div style="display:flex; gap:10px; align-items:center;">
          <div style="font-size:22px; font-weight:800; color:var(--navy);">📞 032-327-1277</div>
          <a href="${ctx}/bbs/viewBbsWriteQna?brdCd=3ccd942dfcbf11f08771908d6ec6e544" class="btn-primary-primus" style="padding:11px 24px; font-size:14px;">온라인 문의</a>
        </div>
      </div>
    </div>

    <!-- 버튼 -->
    <div class="board-detail-btns">
      <button type="button" class="board-btn board-btn-list" onclick="history.back()">목록</button>
    </div>

  </div>
</div>

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>

<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=d644274bbbb3fccf96aeed95241bcfab"></script>
<script>
  $(function () {
    kakao.maps.load(function () {
      var lat = 37.5038, lng = 126.7656;
      var container = document.getElementById('propMap');
      var map = new kakao.maps.Map(container, { center: new kakao.maps.LatLng(lat, lng), level: 3 });
      var marker = new kakao.maps.Marker({ position: new kakao.maps.LatLng(lat, lng) });
      marker.setMap(map);
      var iw = new kakao.maps.InfoWindow({
        content: '<div style="padding:8px 14px; font-size:13px; font-weight:700; white-space:nowrap;">프리머스타워 32평</div>'
      });
      iw.open(map, marker);
    });
  });
</script>

</body>
</html>
