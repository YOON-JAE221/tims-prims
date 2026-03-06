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

    <!-- 상단: 이미지 + 기본정보 -->
    <div class="prop-detail-top">
      <div class="prop-detail-img ${fn:toLowerCase(prop.propType)}">
        <c:choose>
          <c:when test="${not empty prop.thumbPath}">
            <img src="/upload/${prop.thumbPath}" style="width:100%;height:100%;object-fit:cover;" />
          </c:when>
          <c:otherwise>
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
          </c:otherwise>
        </c:choose>
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
      <div class="prop-detail-summary">
        <div class="prop-detail-type">${prop.propTypeNm} &middot; ${prop.dealTypeNm}</div>
        <h2 class="prop-detail-title">${prop.propNm}</h2>
        <div class="prop-detail-loc">${prop.address}<c:if test="${not empty prop.addressDtl}"> ${prop.addressDtl}</c:if></div>
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
        <a href="${ctx}/bbs/viewBbsWriteQna?brdCd=3ccd942dfcbf11f08771908d6ec6e544" class="btn-primary-primus" style="margin-top:20px;padding:12px 28px;font-size:14px;">이 매물 문의하기</a>
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
        <tr><th>난방방식</th><td>${not empty prop.heating ? prop.heating : '-'}</td><th>건축년도</th><td>${not empty prop.buildYear ? prop.buildYear : '-'}</td></tr>
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
        ${prop.address}<c:if test="${not empty prop.addressDtl}"> ${prop.addressDtl}</c:if>
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
          <a href="${ctx}/bbs/viewBbsWriteQna?brdCd=3ccd942dfcbf11f08771908d6ec6e544" class="btn-primary-primus" style="padding:11px 24px;font-size:14px;">온라인 문의</a>
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
</c:if>

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>
</body>
</html>
