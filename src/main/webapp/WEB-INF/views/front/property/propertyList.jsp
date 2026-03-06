<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>

<c:set var="typeNm" value="전체매물" />
<c:if test="${type eq 'apt'}"><c:set var="typeNm" value="아파트" /></c:if>
<c:if test="${type eq 'officetel'}"><c:set var="typeNm" value="오피스텔" /></c:if>
<c:if test="${type eq 'villa'}"><c:set var="typeNm" value="빌라/주택" /></c:if>
<c:if test="${type eq 'oneroom'}"><c:set var="typeNm" value="원룸/투룸" /></c:if>
<c:if test="${type eq 'shop'}"><c:set var="typeNm" value="상가" /></c:if>
<c:if test="${type eq 'office'}"><c:set var="typeNm" value="사무실" /></c:if>

<div class="page-header">
  <h2>${typeNm}</h2>
</div>

<div class="content-layout">
  <%@ include file="/WEB-INF/views/front/property/inc/sidebarProperty.jsp" %>

  <div class="content-main">

    <!-- 검색 필터 -->
    <form id="filterForm" method="post" action="${ctx}/property/viewPropertyList">
      <input type="hidden" name="type" value="${type}" />
      <input type="hidden" name="pageNo" id="pageNoInput" value="${pageNo}" />
      <div class="prop-filter">
        <select name="dealType" onchange="fnFilter()">
          <option value="">전체거래</option>
          <option value="SELL" ${dealType eq 'SELL' ? 'selected' : ''}>매매</option>
          <option value="JEONSE" ${dealType eq 'JEONSE' ? 'selected' : ''}>전세</option>
          <option value="WOLSE" ${dealType eq 'WOLSE' ? 'selected' : ''}>월세</option>
          <option value="RENT" ${dealType eq 'RENT' ? 'selected' : ''}>임대</option>
        </select>
        <input type="text" name="keyword" value="${keyword}" placeholder="매물명 또는 주소 검색" />
        <button type="submit" class="prop-filter-btn">검색</button>
        <button type="button" class="prop-filter-reset" onclick="location.href='${ctx}/property/viewPropertyList?type=${type}'">초기화</button>
      </div>
    </form>

    <!-- 결과 건수 -->
    <div class="prop-result-info">
      <div class="prop-result-cnt">총 <strong>${totalCnt}</strong>건의 매물</div>
    </div>

    <!-- 매물 카드 그리드 -->
    <div class="prop-grid">
      <c:if test="${empty list}">
        <div style="grid-column:1/-1; text-align:center; padding:60px 0; color:var(--gray-400); font-size:14px;">
          등록된 매물이 없습니다.
        </div>
      </c:if>
      <c:forEach var="prop" items="${list}">
        <div class="prop-card ${prop.soldYn eq 'Y' ? 'sold-card' : ''}" onclick="fnGoDetail('${prop.propType}','${prop.propCd}')">
          <div class="prop-card-img ${fn:toLowerCase(prop.propType)}">
            <c:choose>
              <c:when test="${not empty prop.thumbPath}">
                <img src="/upload/${prop.thumbPath}" alt="${prop.propNm}" style="width:100%; height:100%; object-fit:cover;" />
              </c:when>
              <c:otherwise>
                <span class="prop-card-emoji">
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
            <%-- 뱃지: 거래완료 > 급매 > 추천 > 신규(7일) --%>
            <c:choose>
              <c:when test="${prop.soldYn eq 'Y'}">
                <span class="prop-card-badge" style="background:var(--gray-400);">거래완료</span>
              </c:when>
              <c:when test="${prop.badgeType eq 'URGENT'}">
                <span class="prop-card-badge" style="background:#dc3545;">급매</span>
              </c:when>
              <c:when test="${prop.badgeType eq 'RECOMMEND'}">
                <span class="prop-card-badge">추천</span>
              </c:when>
            </c:choose>
            <c:if test="${prop.soldYn eq 'Y'}">
              <div style="position:absolute; inset:0; background:rgba(0,0,0,0.35); display:flex; align-items:center; justify-content:center;">
                <span style="color:white; font-size:18px; font-weight:800; letter-spacing:2px;">거래완료</span>
              </div>
            </c:if>
          </div>
          <div class="prop-card-body">
            <div class="prop-card-type">${prop.propTypeNm} · ${prop.dealTypeNm}</div>
            <div class="prop-card-title">${prop.propNm}</div>
            <div class="prop-card-loc">${prop.address}</div>
            <div class="prop-card-price">
              <c:choose>
                <c:when test="${prop.dealType eq 'SELL'}">
                  <fmt:formatNumber value="${prop.sellPrice}" pattern="#,###"/> <span>만원</span>
                </c:when>
                <c:when test="${prop.dealType eq 'JEONSE'}">
                  <fmt:formatNumber value="${prop.deposit}" pattern="#,###"/> <span>만원</span>
                </c:when>
                <c:otherwise>
                  <fmt:formatNumber value="${prop.deposit}" pattern="#,###"/>/<fmt:formatNumber value="${prop.monthlyRent}" pattern="#,###"/> <span>만원</span>
                </c:otherwise>
              </c:choose>
            </div>
            <div class="prop-card-info">
              <span>${prop.areaExclusive}&#13217;</span>
              <c:if test="${prop.roomCnt > 0}"><span>${prop.roomCnt}룸</span></c:if>
              <c:if test="${not empty prop.floorNo}"><span>${prop.floorNo}층</span></c:if>
            </div>
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
  function fnGoPage(no) {
    if (no < 1 || no > ${totalPage}) return;
    $('#pageNoInput').val(no);
    $('#filterForm').submit();
  }
  function fnFilter() {
    $('#pageNoInput').val(1);
    $('#filterForm').submit();
  }
  function fnGoDetail(propType, propCd) {
    $('#detailType').val(propType);
    $('#detailId').val(propCd);
    $('#goDetailForm').submit();
  }
</script>

<form id="goDetailForm" action="${ctx}/property/viewPropertyDetail" method="post">
  <input type="hidden" name="type" id="detailType" />
  <input type="hidden" name="id" id="detailId" />
</form>

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>
</body>
</html>
