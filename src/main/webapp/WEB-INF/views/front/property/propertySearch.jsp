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
        <c:forEach var="cat" items="${catList}">
          <option value="${cat.catCd}">${cat.catNm}</option>
        </c:forEach>
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

<!-- 카카오맵 -->
<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=<%= Constant.KAKAO_MAP_API_KEY %>&autoload=false"></script>
<script>
var map, overlays = [];
var selectedId = null;
var skipReloadUntil = 0;
var ctx = '${ctx}';

kakao.maps.load(function() {
  var container = document.getElementById('searchMap');
  map = new kakao.maps.Map(container, {
    center: new kakao.maps.LatLng(37.5029, 126.7732),
    level: 5
  });

  map.addControl(new kakao.maps.ZoomControl(), kakao.maps.ControlPosition.RIGHT);

  // 지도 이동 완료 시 매물 조회
  kakao.maps.event.addListener(map, 'idle', function() {
    if (Date.now() < skipReloadUntil) return;
    fnReload();
  });

  // 최초 조회
  fnReload();
});

function fnReload() {
  if (!map) return;
  selectedId = null;
  var bounds = map.getBounds();
  var sw = bounds.getSouthWest();
  var ne = bounds.getNorthEast();

  $.ajax({
    url: ctx + '/property/getPropertyMapList',
    type: 'POST',
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
    if (isSold) continue;
    cnt++;

    var priceStr = fnPriceStr(d);
    var badgeHtml = fnBadgeHtml(d);
    var isActive = selectedId && selectedId == d.propCd;

    html += '<div class="ps-item' + (isActive ? ' active' : '') + '" data-id="' + d.propCd + '" onclick="fnGoDetail(\'' + d.propCd + '\')">';
    html += '  <div class="ps-item-top">';
    html += '    <span class="ps-item-type">' + fnCatPath(d) + '</span>';
    html += '    <span class="prop-no">' + (d.propNo || '') + '</span>';
    html += '    ' + badgeHtml;
    html += '  </div>';
    html += '  <div class="ps-item-name">' + d.propNm + '</div>';
    html += '  <div class="ps-item-price">' + priceStr + '</div>';
    html += '  <div class="ps-item-row">';
    html += '    <div class="ps-item-info">';
    html += '      <span>🏠 ' + fnAreaStr(d.areaExclusive) + '</span>';
    html += '      <span>📐 ' + fnFloorStr(d.floorNo, d.floorTotal) + '</span>';
    html += '    </div>';
    html += '    <button class="ps-item-detail-btn" onclick="event.stopPropagation(); fnGoDetail(\'' + d.propCd + '\')">매물 보러가기 →</button>';
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

  // 항상 클러스터 모드 (개수만 표시)
  fnRenderCluster(list);
}

/* 클러스터 렌더링 */
function fnRenderCluster(list) {
  var level = map.getLevel();
  var gridSize = 0.002;
  if (level >= 7) gridSize = 0.015;
  else if (level >= 6) gridSize = 0.01;
  else if (level >= 5) gridSize = 0.005;
  else if (level >= 4) gridSize = 0.003;

  var clusters = {};

  for (var i = 0; i < list.length; i++) {
    var d = list[i];
    if (!d.lat || !d.lng) continue;

    var gx = Math.floor(d.lat / gridSize);
    var gy = Math.floor(d.lng / gridSize);
    var key = gx + '_' + gy;

    if (!clusters[key]) {
      clusters[key] = { lat: 0, lng: 0, count: 0, items: [] };
    }
    clusters[key].lat += parseFloat(d.lat);
    clusters[key].lng += parseFloat(d.lng);
    clusters[key].count++;
    clusters[key].items.push(d);
  }

  for (var key in clusters) {
    var c = clusters[key];
    var avgLat = c.lat / c.count;
    var avgLng = c.lng / c.count;

    var size = c.count >= 10 ? 'lg' : (c.count >= 5 ? 'md' : 'sm');
    var content = '<div class="map-cluster ' + size + '" '
                + 'data-cluster-key="' + key + '" '
                + 'onclick="fnClusterClick(\'' + key + '\')">'
                + c.count
                + '</div>';

    var overlay = new kakao.maps.CustomOverlay({
      position: new kakao.maps.LatLng(avgLat, avgLng),
      content: content,
      yAnchor: 0.5
    });
    overlay.setMap(map);
    overlay.clusterKey = key;
    overlay.clusterItems = c.items;
    overlays.push(overlay);
  }
}

/* 클러스터 클릭 → 우측 리스트 해당 매물만 표시 */
function fnClusterClick(key) {
  // 해당 클러스터의 매물 찾기
  var items = null;
  for (var i = 0; i < overlays.length; i++) {
    if (overlays[i].clusterKey === key) {
      items = overlays[i].clusterItems;
      break;
    }
  }
  if (!items || items.length === 0) return;

  // 클러스터 활성화 표시
  $('.map-cluster').removeClass('active');
  $('.map-cluster[data-cluster-key="' + key + '"]').addClass('active');

  // 우측 리스트에 해당 매물만 표시
  fnRenderFilteredList(items);

  // 지도 중심 이동
  var avgLat = 0, avgLng = 0;
  for (var i = 0; i < items.length; i++) {
    avgLat += parseFloat(items[i].lat);
    avgLng += parseFloat(items[i].lng);
  }
  skipReloadUntil = Date.now() + 800;
  map.panTo(new kakao.maps.LatLng(avgLat / items.length, avgLng / items.length));
}

/* 필터된 매물 리스트 렌더링 */
function fnRenderFilteredList(items) {
  var html = '';
  var cnt = 0;

  for (var i = 0; i < items.length; i++) {
    var d = items[i];
    if (d.soldYn === 'Y') continue;
    cnt++;

    var priceStr = fnPriceStr(d);
    var badgeHtml = fnBadgeHtml(d);

    html += '<div class="ps-item" data-id="' + d.propCd + '" onclick="fnGoDetail(\'' + d.propCd + '\')">';
    html += '  <div class="ps-item-top">';
    html += '    <span class="ps-item-type">' + fnCatPath(d) + '</span>';
    html += '    <span class="prop-no">' + (d.propNo || '') + '</span>';
    html += '    ' + badgeHtml;
    html += '  </div>';
    html += '  <div class="ps-item-name">' + d.propNm + '</div>';
    html += '  <div class="ps-item-price">' + priceStr + '</div>';
    html += '  <div class="ps-item-row">';
    html += '    <div class="ps-item-info">';
    html += '      <span>🏠 ' + fnAreaStr(d.areaExclusive) + '</span>';
    html += '      <span>📐 ' + fnFloorStr(d.floorNo, d.floorTotal) + '</span>';
    html += '    </div>';
    html += '    <button class="ps-item-detail-btn" onclick="event.stopPropagation(); fnGoDetail(\'' + d.propCd + '\')">매물 보러가기 →</button>';
    html += '  </div>';
    html += '</div>';
  }

  if (cnt === 0) html = '<div class="ps-empty">매물이 없습니다.</div>';
  $('#psList').html(html);
  $('#psCount').html('매물 <strong>' + cnt + '</strong>건');
}

function fnPriceStr(d) {
  if (d.dealType === 'SELL') return '<strong>' + PriceUtil.formatPrice(d.sellPrice) + '</strong>';
  if (d.dealType === 'JEONSE') return '<strong>' + PriceUtil.formatPrice(d.deposit) + '</strong>';
  return '<strong>' + PriceUtil.formatPrice(d.deposit) + '/' + PriceUtil.formatPrice(d.monthlyRent) + '</strong>';
}

function fnCatPath(d) {
  var path = d.catNm || '';
  if (d.midCatNm) path += ' > ' + d.midCatNm;
  if (d.subCatNm) path += ' > ' + d.subCatNm;
  return path;
}

function fnPriceShort(d) {
  if (d.dealType === 'SELL') return PriceUtil.formatPrice(d.sellPrice);
  if (d.dealType === 'JEONSE') return PriceUtil.formatPrice(d.deposit);
  return PriceUtil.formatPrice(d.deposit) + '/' + PriceUtil.formatPrice(d.monthlyRent);
}

function fnFormatPrice(v) {
  return PriceUtil.formatPrice(v);
}

function fnFormatPriceShort(v) {
  return PriceUtil.formatPrice(v);
}

function fnGoDetail(propCd) {
  document.getElementById('searchDetailId').value = propCd;
  document.getElementById('searchDetailForm').submit();
}

function fnBadgeHtml(d) {
  if (d.soldYn === 'Y') return '<span class="ps-item-badge sold">거래완료</span>';
  return '';
}

/* 면적 표시: ㎡ / 평 */
function fnAreaStr(sqm) {
  if (!sqm) return '-';
  var pyeong = (parseFloat(sqm) * 0.3025).toFixed(1);
  return sqm + '㎡ / ' + pyeong + '평';
}

/* 층수 표시: 현재층/전체층 */
function fnFloorStr(floorNo, floorTotal) {
  if (!floorNo) return '-';
  if (!floorTotal) return floorNo + '층';
  return floorNo + '층/' + floorTotal + '층';
}
</script>

<form id="searchDetailForm" action="${ctx}/property/viewPropertyDetail" method="post" style="display:none;">
  <input type="hidden" name="id" id="searchDetailId" />
</form>

<script>document.body.style.overflow = 'hidden';</script>
</body>
</html>
