<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>

<main id="main">

  <!-- ======= Breadcrumbs ======= -->
  <div class="breadcrumbs d-flex align-items-center">
    <div class="container position-relative d-flex flex-column align-items-center">
      <h2>등록 및 면허</h2>
      <ol>
        <li>등록 및 면허</li>
      </ol>
    </div>
  </div><!-- End Breadcrumbs -->

  <!-- ======= 2컬럼 레이아웃 ======= -->
  <c:set var="activeLnb" value="license" scope="request" />
  <div class="lnb-layout">
    <%@ include file="/WEB-INF/views/front/common/inc/sidebarLicense.jsp" %>

    <div class="lnb-content">

      <section id="license" class="license">
        <div class="container">

          <c:if test="${not empty sessionScope.loginUser}">
            <div class="d-flex justify-content-end mb-3">
              <a href="${ctx}/licenseMng/viewLicenseMng" class="btn btn-admin-mng"><i class="bi bi-gear-fill"></i> 관리</a>
            </div>
          </c:if>

          <div class="license-grid">
            <c:forEach var="row" items="${licenseList}" varStatus="st">
              <article class="license-item">
                <a class="license-thumb glightbox" href="${row.fileFullPath}" data-gallery="license-gallery">
                  <img src="${row.fileFullPath}" alt="${row.liceTitle}">
                </a>
                <div class="license-caption">
                  <h3 class="license-name">${row.liceTitle}</h3>
                </div>
              </article>
            </c:forEach>
          </div>

        </div>
      </section>

    </div><!-- /lnb-content -->
  </div><!-- /lnb-layout -->

</main><!-- End #main -->

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>

<script>
  document.addEventListener('DOMContentLoaded', function() {
    const lightbox = GLightbox({
      selector: '.glightbox',
      touchNavigation: true,
      loop: true,
      autoplayVideos: false,
      closeButton: true,
      zoomable: true,
      draggable: true
    });
  });
</script>
