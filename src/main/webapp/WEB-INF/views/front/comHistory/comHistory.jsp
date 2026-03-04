<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>

<main id="main">

  <div class="breadcrumbs d-flex align-items-center">
    <div class="container position-relative d-flex flex-column align-items-center">
      <h2>연혁</h2>
      <ol>
        <li>회사소개</li>
      </ol>
    </div>
  </div>

  <!-- ======= 2컬럼 레이아웃 ======= -->
  <c:set var="activeLnb" value="comHistory" scope="request" />
  <div class="lnb-layout">
    <%@ include file="/WEB-INF/views/front/common/inc/sidebarCompany.jsp" %>

    <div class="lnb-content">

      <section id="comHistory" class="comHistory">
        <div class="container">

          <c:if test="${not empty sessionScope.loginUser}">
            <div class="d-flex justify-content-end mb-3">
              <a href="${ctx}/comHistoryMng/viewComHistoryMng" class="btn btn-admin-mng"><i class="bi bi-gear-fill"></i> 관리</a>
            </div>
          </c:if>

          <div class="comHistory-timeline">
            <c:if test="${empty comHstList}">
              <div class="text-center text-muted py-5">등록된 연혁이 없습니다.</div>
            </c:if>

            <c:if test="${not empty comHstList}">
              <c:set var="prevYear" value="" />
              <c:forEach var="row" items="${comHstList}" varStatus="st">
                <c:if test="${prevYear ne row.hstYr}">
                  <c:if test="${st.index ne 0}">
                      </ul>
                    </div>
                  </div>
                  </c:if>
                  <div class="comHistory-item">
                    <div class="comHistory-year">${row.hstYr}</div>
                    <div class="comHistory-card">
                      <ul class="comHistory-list">
                </c:if>
                <li>${row.hstCnts}</li>
                <c:set var="prevYear" value="${row.hstYr}" />
              </c:forEach>
                  </ul>
                </div>
              </div>
            </c:if>
          </div>

        </div>
      </section>

    </div><!-- /lnb-content -->
  </div><!-- /lnb-layout -->

</main><!-- End #main -->

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>
