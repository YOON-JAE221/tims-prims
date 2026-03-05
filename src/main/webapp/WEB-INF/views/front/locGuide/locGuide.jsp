<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>

<div class="page-header">
  <h2>오시는길</h2>
</div>

<div class="loc-wrap">

  <!-- 카카오맵 -->
  <div class="loc-map">
    <div id="kakaoMap" style="width:100%; height:100%;"></div>
  </div>

  <!-- 정보 영역 -->
  <div class="loc-info">

    <div class="loc-row">
      <span class="loc-label">주소</span>
      <span class="loc-value">경기도 부천시 길주로 280 프리머스 부천타워 1층 (중동 1141-2 롯데시네마 건물 1층)</span>
    </div>
    <div class="loc-row">
      <span class="loc-label">전화</span>
      <span class="loc-value">032-327-1277</span>
    </div>

    <div class="loc-section-title">주변 지하철</div>
    <div class="loc-section-body">
      <span class="loc-subway">
        <span class="loc-subway-num" style="background:#0052A4;">1</span>
        중동역 1번출구 도보 5분
      </span>
      <span class="loc-subway">
        <span class="loc-subway-num" style="background:#747F00;">7</span>
        신중동역 3번출구 도보 10분
      </span>
    </div>

    <div class="loc-section-title">주변 정류장</div>
    <div class="loc-section-body">
      <span class="loc-stop"><span class="loc-stop-num">1</span> 중동역</span>
      <span class="loc-stop"><span class="loc-stop-num">2</span> 롯데시네마부천점</span>
      <span class="loc-stop"><span class="loc-stop-num">3</span> 부천시청</span>
      <span class="loc-stop"><span class="loc-stop-num">4</span> 중동역사거리</span>
    </div>

    <div class="loc-section-title">주변 버스</div>
    <div class="loc-section-body loc-bus-area">
      <div class="loc-bus-row">
        <span class="loc-bus-type" style="background:#33A23D;">지선</span>
        <span class="loc-bus-no">52</span>
        <span class="loc-bus-no">57</span>
        <span class="loc-bus-no">60-2</span>
      </div>
      <div class="loc-bus-row">
        <span class="loc-bus-type" style="background:#E60012;">간선</span>
        <span class="loc-bus-no">88</span>
      </div>
    </div>

    <div class="loc-section-title">자가용</div>
    <div class="loc-section-body">
      <span style="font-size:14px; color:var(--gray-600);">롯데시네마 부천점 건물 1층 / 건물 내 주차 가능 (방문 시 주차 안내)</span>
    </div>

  </div>

</div>

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>

<!-- 오시는길 전용 CSS -->
<style>
.loc-wrap { max-width:1200px; margin:0 auto; padding:48px 24px 80px; }
.loc-map { width:100%; height:450px; border:1px solid var(--gray-200); margin-bottom:0; }

.loc-info { border-top:2px solid var(--navy); }
.loc-row {
  display:flex; align-items:center;
  padding:14px 16px; border-bottom:1px solid var(--gray-100);
  font-size:14px; color:var(--gray-700);
}
.loc-label {
  width:80px; flex-shrink:0;
  font-weight:700; color:var(--gray-500);
}
.loc-value { flex:1; }

.loc-section-title {
  padding:16px 16px 10px;
  font-size:14px; font-weight:700; color:var(--gray-700);
  border-bottom:1px solid var(--gray-100);
}
.loc-section-body {
  display:flex; flex-wrap:wrap; gap:10px 24px;
  padding:14px 16px;
  border-bottom:1px solid var(--gray-100);
  font-size:14px; color:var(--gray-600);
}

/* 지하철 */
.loc-subway { display:inline-flex; align-items:center; gap:8px; }
.loc-subway-num {
  display:inline-flex; align-items:center; justify-content:center;
  width:22px; height:22px; border-radius:50%;
  color:white; font-size:11px; font-weight:700;
}

/* 정류장 */
.loc-stop { display:inline-flex; align-items:center; gap:6px; }
.loc-stop-num {
  display:inline-flex; align-items:center; justify-content:center;
  width:20px; height:20px; border-radius:50%;
  background:var(--gray-400); color:white;
  font-size:11px; font-weight:600;
}

/* 버스 */
.loc-bus-area { flex-direction:column; gap:10px; }
.loc-bus-row { display:flex; align-items:center; gap:12px; }
.loc-bus-type {
  display:inline-block; padding:2px 10px; border-radius:4px;
  color:white; font-size:11px; font-weight:700;
  min-width:36px; text-align:center;
}
.loc-bus-no { font-size:14px; color:var(--gray-700); font-weight:500; }

@media (max-width: 768px) {
  .loc-map { height:280px; }
  .loc-row { flex-direction:column; align-items:flex-start; gap:4px; }
  .loc-label { width:auto; }
}
</style>

<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=d53f71f3d9ea4c5c59f5f63df52a5c0d"></script>
<script>
  $(function () {
    kakao.maps.load(function () {
      var lat = 37.5038;
      var lng = 126.7656;
      var container = document.getElementById('kakaoMap');
      var map = new kakao.maps.Map(container, {
        center: new kakao.maps.LatLng(lat, lng),
        level: 3
      });
      var marker = new kakao.maps.Marker({ position: new kakao.maps.LatLng(lat, lng) });
      marker.setMap(map);
      var infowindow = new kakao.maps.InfoWindow({
        content: '<div style="padding:10px 16px; font-size:14px; font-weight:700; white-space:nowrap; color:#1B2A4A;">프리머스 부동산</div>'
      });
      infowindow.open(map, marker);
      map.addControl(new kakao.maps.ZoomControl(), kakao.maps.ControlPosition.RIGHT);
    });
  });
</script>

</body>
</html>
