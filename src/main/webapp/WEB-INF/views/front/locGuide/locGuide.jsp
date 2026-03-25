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
        <span class="loc-subway-num" style="background:#747F00;">7</span>
        신중동역 3번출구 도보 4분
      </span>
      <span class="loc-subway">
        <span class="loc-subway-num" style="background:#747F00;">7</span>
        부천시청역 5번출구 도보 7분
      </span>
    </div>

    <div class="loc-section-title">주변 정류장</div>
    <div class="loc-section-body">
      <span class="loc-stop"><span class="loc-stop-num">1</span> 롯데시네마부천점</span>
      <span class="loc-stop"><span class="loc-stop-num">2</span> 부천시청역</span>
      <span class="loc-stop"><span class="loc-stop-num">3</span> 롯데백화점</span>
    </div>

    <div class="loc-section-title">자가용</div>
    <div class="loc-section-body">
      <span style="font-size:14px; color:var(--gray-600);">롯데시네마 부천점 건물 1층 / 건물 내 주차 가능 (방문 시 주차 안내)</span>
    </div>

  </div>

</div>

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>

<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=<%= Constant.KAKAO_MAP_API_KEY %>"></script>
<script>
  $(function () {
    kakao.maps.load(function () {
      var lat = 37.5029;
      var lng = 126.7732;
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
