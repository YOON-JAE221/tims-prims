<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>

<div class="ps-wrap">

  <!-- 좌측: 지도 -->
  <div class="ps-map">
    <div id="searchMap" style="width:100%; height:100%;"></div>
  </div>

  <!-- 우측: 필터 + 리스트 -->
  <div class="ps-panel">

    <!-- 필터 -->
    <div class="ps-filter">
      <select id="psType" onchange="fnReload()">
        <option value="ALL">전체유형</option>
        <option value="APT">아파트</option>
        <option value="OFFICETEL">오피스텔</option>
        <option value="SHOP">상가</option>
        <option value="OFFICE">사무실</option>
      </select>
      <select id="psDeal" onchange="fnReload()">
        <option value="ALL">전체거래</option>
        <option value="SELL">매매</option>
        <option value="JEONSE">전세</option>
        <option value="WOLSE">월세</option>
        <option value="RENT">임대</option>
      </select>
    </div>

    <!-- 결과 건수 -->
    <div class="ps-result-info">
      <span id="psCount">매물 0건</span>
    </div>

    <!-- 매물 리스트 -->
    <div class="ps-list" id="psList">
      <div class="ps-empty">지도를 이동하여 매물을 검색하세요.</div>
    </div>

  </div>

</div>

<!-- 스타일 -->
<style>
.ps-wrap {
  display: flex; width: 100%;
  height: calc(100vh - 72px);
  margin-top: 72px;
}
.ps-map { flex: 1; min-width: 0; }
.ps-panel {
  width: 400px; flex-shrink: 0;
  display: flex; flex-direction: column;
  border-left: 1px solid var(--gray-200);
  background: white;
}
.ps-filter {
  display: flex; gap: 8px;
  padding: 14px 16px;
  border-bottom: 1px solid var(--gray-200);
}
.ps-filter select {
  flex: 1; padding: 9px 10px;
  border: 1px solid var(--gray-200); border-radius: 8px;
  font-size: 13px; font-family: inherit;
  color: var(--gray-700); outline: none;
}
.ps-filter select:focus { border-color: var(--orange); }
.ps-result-info {
  padding: 10px 16px;
  font-size: 13px; color: var(--gray-500);
  border-bottom: 1px solid var(--gray-100);
}
.ps-result-info span strong { color: var(--orange); font-weight: 800; }
.ps-list {
  flex: 1; overflow-y: auto;
}
.ps-empty {
  padding: 60px 20px; text-align: center;
  color: var(--gray-400); font-size: 14px;
}

/* 매물 카드 */
.ps-item {
  padding: 16px; border-bottom: 1px solid var(--gray-100);
  cursor: pointer; transition: background 0.15s;
}
.ps-item:hover { background: var(--gray-50); }
.ps-item-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px; }
.ps-item-type { font-size: 12px; color: var(--orange); font-weight: 700; }
.ps-item-badge {
  font-size: 11px; font-weight: 700; padding: 2px 8px; border-radius: 4px; color: white;
}
.ps-item-badge.recommend { background: var(--orange); }
.ps-item-badge.urgent { background: #dc3545; }
.ps-item-badge.new { background: #0052A4; }
.ps-item-badge.sold { background: var(--gray-400); }
.ps-item-name { font-size: 15px; font-weight: 700; color: var(--navy); margin-bottom: 4px; }
.ps-item-addr { font-size: 12px; color: var(--gray-400); margin-bottom: 8px; }
.ps-item-price { font-size: 17px; font-weight: 800; color: var(--navy); }
.ps-item-price span { font-size: 12px; font-weight: 500; color: var(--gray-400); }
.ps-item-info { display: flex; gap: 10px; margin-top: 8px; font-size: 12px; color: var(--gray-500); }
.ps-item.sold { opacity: 0.5; }

/* 커스텀 오버레이 (가격 말풍선) */
.map-price-label {
  background: var(--navy); color: white;
  padding: 5px 10px; border-radius: 6px;
  font-size: 12px; font-weight: 700;
  white-space: nowrap; cursor: pointer;
  box-shadow: 0 2px 8px rgba(0,0,0,0.2);
  position: relative;
}
.map-price-label::after {
  content: ''; position: absolute; bottom: -6px; left: 50%; transform: translateX(-50%);
  border-left: 6px solid transparent; border-right: 6px solid transparent;
  border-top: 6px solid var(--navy);
}
.map-price-label.apt { background: #2c3e6b; }
.map-price-label.apt::after { border-top-color: #2c3e6b; }
.map-price-label.officetel { background: #5a4a8a; }
.map-price-label.officetel::after { border-top-color: #5a4a8a; }
.map-price-label.shop { background: #3a7a6a; }
.map-price-label.shop::after { border-top-color: #3a7a6a; }
.map-price-label.office { background: #5a6a3a; }
.map-price-label.office::after { border-top-color: #5a6a3a; }
.map-price-label.sold { background: var(--gray-400); }
.map-price-label.sold::after { border-top-color: var(--gray-400); }

@media (max-width: 768px) {
  .ps-wrap { flex-direction: column; }
  .ps-map { height: 50vh; }
  .ps-panel { width: 100%; height: 50vh; }
}
</style>

<!-- 카카오맵 -->
<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=d53f71f3d9ea4c5c59f5f63df52a5c0d&autoload=false"></script>
<script>
var map, overlays = [];
var ctx = '${ctx}';

kakao.maps.load(function() {
  var container = document.getElementById('searchMap');
  map = new kakao.maps.Map(container, {
    center: new kakao.maps.LatLng(37.5038, 126.7656),
    level: 5
  });

  map.addControl(new kakao.maps.ZoomControl(), kakao.maps.ControlPosition.RIGHT);

  // 지도 이동 완료 시 매물 조회
  kakao.maps.event.addListener(map, 'idle', function() {
    fnReload();
  });

  // 최초 조회
  fnReload();
});

function fnReload() {
  if (!map) return;
  var bounds = map.getBounds();
  var sw = bounds.getSouthWest();
  var ne = bounds.getNorthEast();

  $.ajax({
    url: ctx + '/property/getPropertyMapList',
    data: {
      swLat: sw.getLat(), swLng: sw.getLng(),
      neLat: ne.getLat(), neLng: ne.getLng(),
      propType: $('#psType').val(),
      dealType: $('#psDeal').val()
    },
    dataType: 'json',
    success: function(res) {
      if (res && res.DATA) {
        fnRenderList(res.DATA);
        fnRenderMarkers(res.DATA);
      }
    }
  });
}

function fnRenderList(list) {
  var html = '';
  var cnt = 0;

  for (var i = 0; i < list.length; i++) {
    var d = list[i];
    var isSold = d.soldYn === 'Y';
    if (isSold) continue; // 거래완료는 리스트에서 제외 (원하면 포함 가능)
    cnt++;

    var priceStr = fnPriceStr(d);
    var badgeHtml = fnBadgeHtml(d);

    html += '<div class="ps-item" onclick="fnFocusMap(' + d.lat + ',' + d.lng + ')">';
    html += '  <div class="ps-item-top">';
    html += '    <span class="ps-item-type">' + d.propTypeNm + ' · ' + d.dealTypeNm + '</span>';
    html += '    ' + badgeHtml;
    html += '  </div>';
    html += '  <div class="ps-item-name">' + d.propNm + '</div>';
    html += '  <div class="ps-item-addr">' + d.address + '</div>';
    html += '  <div class="ps-item-price">' + priceStr + '</div>';
    html += '  <div class="ps-item-info">';
    html += '    <span>🏠 ' + (d.areaExclusive || '-') + '㎡</span>';
    if (d.roomCnt > 0) html += '<span>🚪 ' + d.roomCnt + '룸</span>';
    if (d.floorNo) html += '<span>📐 ' + d.floorNo + '층</span>';
    html += '  </div>';
    html += '</div>';
  }

  if (cnt === 0) html = '<div class="ps-empty">현재 지도 영역에 매물이 없습니다.</div>';
  $('#psList').html(html);
  $('#psCount').html('매물 <strong>' + cnt + '</strong>건');
}

function fnRenderMarkers(list) {
  // 기존 오버레이 제거
  for (var i = 0; i < overlays.length; i++) { overlays[i].setMap(null); }
  overlays = [];

  for (var i = 0; i < list.length; i++) {
    var d = list[i];
    if (!d.lat || !d.lng) continue;

    var priceShort = fnPriceShort(d);
    var typeClass = d.propType ? d.propType.toLowerCase() : '';
    if (d.soldYn === 'Y') typeClass = 'sold';

    var content = '<div class="map-price-label ' + typeClass + '" '
                + 'onclick="fnFocusMap(' + d.lat + ',' + d.lng + ')">'
                + priceShort + '</div>';

    var overlay = new kakao.maps.CustomOverlay({
      position: new kakao.maps.LatLng(d.lat, d.lng),
      content: content,
      yAnchor: 1.3
    });
    overlay.setMap(map);
    overlays.push(overlay);
  }
}

function fnFocusMap(lat, lng) {
  map.setCenter(new kakao.maps.LatLng(lat, lng));
  map.setLevel(3);
}

function fnPriceStr(d) {
  if (d.dealType === 'SELL') return fnFormatPrice(d.sellPrice) + ' <span>만원</span>';
  if (d.dealType === 'JEONSE') return fnFormatPrice(d.deposit) + ' <span>만원</span>';
  return fnFormatPrice(d.deposit) + '/' + (d.monthlyRent || 0) + ' <span>만원</span>';
}

function fnPriceShort(d) {
  if (d.dealType === 'SELL') return fnFormatPriceShort(d.sellPrice);
  if (d.dealType === 'JEONSE') return fnFormatPriceShort(d.deposit);
  return fnFormatPriceShort(d.deposit) + '/' + (d.monthlyRent || 0);
}

function fnFormatPrice(v) {
  if (!v || v === 0) return '0';
  if (v >= 10000) return Math.floor(v / 10000) + '억 ' + (v % 10000 > 0 ? (v % 10000).toLocaleString() : '');
  return Number(v).toLocaleString();
}

function fnFormatPriceShort(v) {
  if (!v || v === 0) return '0';
  if (v >= 10000) return (v / 10000).toFixed(v % 10000 === 0 ? 0 : 1) + '억';
  return Number(v).toLocaleString();
}

function fnBadgeHtml(d) {
  if (d.soldYn === 'Y') return '<span class="ps-item-badge sold">거래완료</span>';
  if (d.badgeType === 'URGENT') return '<span class="ps-item-badge urgent">급매</span>';
  if (d.badgeType === 'RECOMMEND') return '<span class="ps-item-badge recommend">추천</span>';
  // 7일 이내 신규
  var rgtDate = new Date(d.rgtDtm);
  var now = new Date();
  var diff = (now - rgtDate) / (1000 * 60 * 60 * 24);
  if (diff <= 7) return '<span class="ps-item-badge new">신규</span>';
  return '';
}
</script>

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>
</body>
</html>
