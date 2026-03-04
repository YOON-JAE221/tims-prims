<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>

<main id="main">

  <!-- ======= Breadcrumbs ======= -->
  <div class="breadcrumbs d-flex align-items-center">
    <div class="container position-relative d-flex flex-column align-items-center">
      <h2>찾아오시는길</h2>
      <ol>
        <li>회사소개</li>
      </ol>
    </div>
  </div><!-- End Breadcrumbs -->

  <!-- ======= 2컬럼 레이아웃 ======= -->
  <c:set var="activeLnb" value="locGuide" scope="request" />
  <div class="lnb-layout">
    <%@ include file="/WEB-INF/views/front/common/inc/sidebarCompany.jsp" %>

    <div class="lnb-content">

      <section id="locGuide" class="locGuide">
        <div class="container">

          <!-- 지도 -->
          <div class="locGuide-mapWrap">
            <div id="kakaoMap"></div>
          </div>

          <!-- 정보 영역 -->
          <div class="locGuide-info">
            <div class="locGuide-row">
              <span class="locGuide-label">주소</span>
              서울시 강서구 마곡중앙로 161-1306호 (마곡동, 두산더랜드파크)
            </div>
            <div class="locGuide-row">
              <span class="locGuide-label">전화</span>
              070-7640-1002
            </div>

            <div class="locGuide-section-title">주변 지하철</div>
            <div class="locGuide-section-body">
              <span class="locGuide-subway">
                <span class="locGuide-subway-num locGuide-subway-num--9">9</span>
                <span class="locGuide-subway-num locGuide-subway-num--air">공항</span>
                <span class="locGuide-subway-nm">마곡나루역 2번출구 도보 4분</span>
              </span>
              <span class="locGuide-subway">
                <span class="locGuide-subway-num locGuide-subway-num--9">9</span>
                <span class="locGuide-subway-nm">신방화역 4번출구 도보 15분</span>
              </span>
              <span class="locGuide-subway">
                <span class="locGuide-subway-num locGuide-subway-num--5">5</span>
                <span class="locGuide-subway-nm">마곡역 3번출구 도보 18분</span>
              </span>
            </div>

            <div class="locGuide-section-title">주변 정류장</div>
            <div class="locGuide-section-body">
              <span class="locGuide-stop"><span class="locGuide-stop-num">1</span> 마곡나루역2번출구</span>
              <span class="locGuide-stop"><span class="locGuide-stop-num">2</span> 마곡나루역</span>
              <span class="locGuide-stop"><span class="locGuide-stop-num">3</span> 마곡엠밸리4단지</span>
              <span class="locGuide-stop"><span class="locGuide-stop-num">4</span> 마곡나루역1번출구·웰튼병원</span>
              <span class="locGuide-stop"><span class="locGuide-stop-num">5</span> 롯데R&D센터</span>
              <span class="locGuide-stop"><span class="locGuide-stop-num">6</span> 마곡나루역1번출구</span>
            </div>

            <div class="locGuide-section-title">주변 버스</div>
            <div class="locGuide-section-body">
              <div class="locGuide-bus-row">
                <span class="locGuide-bus-type locGuide-bus-type--green">지선</span>
                <span class="locGuide-bus-no">6642</span>
                <span class="locGuide-bus-no">6645</span>
                <span class="locGuide-bus-no">6647</span>
                <span class="locGuide-bus-no">6648</span>
              </div>
              <div class="locGuide-bus-row">
                <span class="locGuide-bus-type locGuide-bus-type--red">좌석</span>
                <span class="locGuide-bus-no">9731</span>
              </div>
              <div class="locGuide-bus-row">
                <span class="locGuide-bus-type locGuide-bus-type--night">심야</span>
                <span class="locGuide-bus-no">N64</span>
              </div>
              <div class="locGuide-bus-row">
                <span class="locGuide-bus-type locGuide-bus-type--village">마을</span>
                <span class="locGuide-bus-no">강서05-1</span>
                <span class="locGuide-bus-no">강서07</span>
              </div>
            </div>
          </div><!-- End locGuide-info -->

        </div>
      </section>

    </div><!-- /lnb-content -->
  </div><!-- /lnb-layout -->

</main><!-- End #main -->

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>

<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=d644274bbbb3fccf96aeed95241bcfab"></script>
<script>
  $(function () {
    kakao.maps.load(function () {
      initKakaoMap();
    });
  });

  function initKakaoMap() {
    var lat = 37.5668;
    var lng = 126.8275;
    var container = document.getElementById('kakaoMap');
    var map = new kakao.maps.Map(container, {
      center: new kakao.maps.LatLng(lat, lng),
      level: 3
    });
    var marker = new kakao.maps.Marker({ position: new kakao.maps.LatLng(lat, lng) });
    marker.setMap(map);
    var infowindow = new kakao.maps.InfoWindow({
      content: '<div style="padding:8px 12px; font-size:13px; white-space:nowrap;">강한건축구조기술사사무소</div>'
    });
    infowindow.open(map, marker);
    map.addControl(new kakao.maps.ZoomControl(), kakao.maps.ControlPosition.RIGHT);
    map.addControl(new kakao.maps.MapTypeControl(), kakao.maps.ControlPosition.TOPRIGHT);
  }
</script>
