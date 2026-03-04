<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>

 <!-- ======= Hero Section ======= -->
  <section id="hero" class="hero">

    <div class="info d-flex align-items-center">
	  <div class="container">
	    <div class="row justify-content-center">
	      <div class="col-lg-10 text-center">
			<h2 data-aos="fade-down">
			  <span class="hero-strong">강한</span>건축구조기술사사무소
			</h2>
	        <p data-aos="fade-up" style="margin-top:-25px;">
	          강한구조 · 강한책임 · 강한기술력으로<br>
	          건축구조의 본질을 설계합니다.<br>
	          내일의 안전을 책임지겠습니다.
	        </p>
			<a data-aos="fade-up" data-aos-delay="200" href="${pageContext.request.contextPath}/bbs/viewBbsQna" class="btn-get-started"> 상담 문의 </a>
	      </div>
	    </div>
	  </div>
	</div>

    <div id="hero-carousel" class="carousel slide carousel-fade" data-bs-ride="carousel" data-bs-interval="5000">

      <div class="carousel-item active" style="background-image: url(${ctx}/resources/front/img/main/mainBg1.png)"></div>
      <div class="carousel-item" style="background-image: url(${ctx}/resources/front/img/main/mainBg2.png)"></div>
      <div class="carousel-item" style="background-image: url(${ctx}/resources/front/img/main/mainBg3.png)"></div>
      <div class="carousel-item" style="background-image: url(${ctx}/resources/front/img/main/mainBg4.png)"></div>
      <div class="carousel-item" style="background-image: url(${ctx}/resources/front/img/main/mainBg5.png)"></div>

    </div>

  </section><!-- End Hero Section -->

  <main id="main">
  
    <!-- ======= Alt Services Section ======= -->
    <section id="alt-services" class="alt-services">
      <div class="container">

       <div class="row justify-content-around gy-4">
          <div class="col-lg-6 img-bg" style="background-image: url(${ctx}/resources/front/img/logo/officeLogo.jpg);"></div>

          <div class="col-lg-5 d-flex flex-column justify-content-center">

			    <h3 class="text-uppercase fw-bold mb-2">ENGINEERING SERVICE</h3>
			    <p class="text-secondary lh-lg mb-0">
			      강한건축구조기술사무소는 <span class="fw-semibold text-dark">구조설계 · 구조검토 · 안전진단</span>까지<br>
			      건축 전 과정에 필요한 기술 서비스를 제공합니다.<br>
			      현장 조건과 관련 기준을 바탕으로 최적의 구조 해법을 제안하고,
			      안전성과 경제성을 함께 고려해 신뢰할 수 있는 결과를 드립니다.
			    </p>
			
			  <div class="icon-box d-flex gap-3 position-relative">
			    <div class="flex-shrink-0 d-flex align-items-start pt-1">
			      <i class="bi bi-diagram-3 fs-4 text-secondary"></i>
			    </div>
			    <div>
			      <h4 class="fw-bold mb-1">구조설계</h4>
			      <p class="text-secondary mb-0">
			        구조 기준과 하중 조건을 반영해 안전하고 경제적인 구조 시스템을 계획합니다.
			        도면·수량 검토까지 연계하여 시공성과 완성도를 높입니다.
			      </p>
			    </div>
			  </div>

			  <div class="icon-box d-flex gap-3 position-relative">
			    <div class="flex-shrink-0 d-flex align-items-start pt-1">
			      <i class="bi bi-clipboard-check fs-4 text-secondary"></i>
			    </div>
			    <div>
			      <h4 class="fw-bold mb-1">구조검토</h4>
			      <p class="text-secondary mb-0">
			        기존 도면과 구조계산서를 기준으로 안전성·적정성을 면밀히 검토합니다.
			        보완 사항과 대안을 제시해 인허가 및 시공 단계의 리스크를 줄입니다.
			      </p>
			    </div>
			  </div>

			  <div class="icon-box d-flex gap-3 position-relative">
			    <div class="flex-shrink-0 d-flex align-items-start pt-1">
			      <i class="bi bi-shield-check fs-4 text-secondary"></i>
			    </div>
			    <div>
			      <h4 class="fw-bold mb-1">안전진단</h4>
			      <p class="text-secondary mb-0">
			        현장 조사와 점검을 통해 구조적 결함과 안전 위험 요소를 진단합니다.
			        원인 분석과 보강 방안을 제안하여 안전 확보와 유지관리 효율을 높입니다.
			      </p>
			    </div>
			  </div>
        	</div>
		</div>
      </div>
    </section><!-- End Alt Services Section -->
  	

    

    <!-- ======= Features Section ======= -->
    <section id="features" class="features section-bg">
      <div class="container">

        <ul class="nav nav-tabs row  g-2 d-flex">

          <li class="nav-item col-3">
            <a class="nav-link active show" data-bs-toggle="tab" data-bs-target="#tab-1">
              <h4>내진성능평가</h4>
            </a>
          </li><!-- End tab nav item -->

          <li class="nav-item col-3">
            <a class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-2">
              <h4>비구조요소 내진설계</h4>
            </a><!-- End tab nav item -->

          <li class="nav-item col-3">
            <a class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-3">
              <h4>구조실무상식</h4>
            </a>
          </li><!-- End tab nav item -->

          <li class="nav-item col-3">
            <a class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-4">
              <h4>구조기준</h4>
            </a>
          </li><!-- End tab nav item -->

        </ul>

        <div class="tab-content">

          <div class="tab-pane active show" id="tab-1">
            <div class="row">
              <div class="col-lg-6 order-2 order-lg-1 mt-3 mt-lg-0 d-flex flex-column justify-content-center">
                <h3>내진성능평가 안내</h3>
                <p class="fst-italic">
                  건축물의 내진 성능을 현행 기준에 따라 평가하여 지진 시 안전 수준을 확인하고,<br>
        		  필요한 경우 합리적인 보강 방향을 제시합니다.
                </p>
                <ul>
			      <li><i class="bi bi-check2-all"></i> 기존 도면·구조자료 분석 및 현장 조사 기반으로 취약 요소를 진단합니다.</li>
			      <li><i class="bi bi-check2-all"></i> 내진 기준에 따른 성능평가로 안전성 확보 여부를 명확히 판단합니다.</li>
			      <li><i class="bi bi-check2-all"></i> 평가 결과에 따라 경제성과 시공성을 고려한 보강 대안을 제안합니다.</li>
			    </ul>
              </div>
              <div class="col-lg-6 order-1 order-lg-2 text-center">
                <img src="${ctx}/resources/front/img/main/features1.png" alt="" class="img-fluid">
              </div>
            </div>
          </div><!-- End tab content item -->

          <div class="tab-pane" id="tab-2">
            <div class="row">
              <div class="col-lg-6 order-2 order-lg-1 mt-3 mt-lg-0 d-flex flex-column justify-content-center">
                <h3>비구조요소 내진설계 안내</h3>
                <p class="fst-italic">
				  천장재, 외장재, 설비배관, 가구 등 비구조요소의 내진 성능을 확보하여
				  지진 발생 시 낙하·전도·파손으로 인한 피해를 줄입니다.
				</p>
                <ul>
		        	<li><i class="bi bi-check2-all"></i> 대상 비구조요소를 분류하고 위험 요소(낙하·전도·이탈)를 사전 점검합니다.</li>
		        	<li><i class="bi bi-check2-all"></i> 앵커·브레이싱 등 지지/고정 방식과 상세를 기준에 맞게 설계합니다.</li>
		        	<li><i class="bi bi-check2-all"></i> 설비·배관·덕트의 변위와 간섭을 고려해 안전한 지지 계획을 수립합니다.</li>
		        	<li><i class="bi bi-check2-all"></i> 시공성과 유지관리를 함께 고려한 합리적인 상세와 도면을 제공합니다.</li>
		      	</ul>
              </div>
              <div class="col-lg-6 order-1 order-lg-2 text-center">
                <img src="${ctx}/resources/front/img/main/features2.png" alt="" class="img-fluid">
              </div>
            </div>
          </div><!-- End tab content item -->

          <div class="tab-pane" id="tab-3">
            <div class="row">
              <div class="col-lg-6 order-2 order-lg-1 mt-3 mt-lg-0 d-flex flex-column justify-content-center">
                <h3>구조실무상식 가이드</h3>
                <ul>
		        	<li><i class="bi bi-check2-all"></i> 하중 흐름과 구조체 역할(기둥·보·전단벽)을 이해하면 설계·시공 판단이 쉬워집니다.</li>
		        	<li><i class="bi bi-check2-all"></i> 균열은 원인(건조수축·온도·침하·하중)에 따라 대응 방법이 달라집니다.</li>
		        	<li><i class="bi bi-check2-all"></i> 개구부·설비 관통부는 보강 검토가 필요하며, 간섭과 시공성을 함께 확인합니다.</li>
		        </ul>
                <p class="fst-italic">
		          현장에서 자주 발생하는 구조 관련 이슈를 핵심만 정리해 안내합니다.
		          도면 확인 포인트와 기본 원리를 함께 설명해 불필요한 재시공과 안전 리스크를 줄일 수 있습니다.
		        </p>
              </div>
              <div class="col-lg-6 order-1 order-lg-2 text-center">
                <img src="${ctx}/resources/front/img/main/features3.png" alt="" class="img-fluid">
              </div>
            </div>
          </div><!-- End tab content item -->

          <div class="tab-pane" id="tab-4">
            <div class="row">
              <div class="col-lg-6 order-2 order-lg-1 mt-3 mt-lg-0 d-flex flex-column justify-content-center">
                <h3>구조기준</h3>
                <p class="fst-italic">
		         현행 구조 관련 기준과 법규를 바탕으로 설계·검토의 기준을 명확히 적용합니다.
		         프로젝트 조건에 맞는 해석과 적용 범위를 정리해 안전성과 적정성을 확보합니다.
		        </p>
                <ul>
		        	<li><i class="bi bi-check2-all"></i> KDS 등 관련 기준을 근거로 하중·재료·내진 요구사항을 체계적으로 검토합니다.</li>
		        	<li><i class="bi bi-check2-all"></i> 적용 기준, 가정 조건, 검토 결과를 문서화하여 인허가 및 협의에 활용합니다.</li>
		        	<li><i class="bi bi-check2-all"></i> 설계 변경·현장 이슈 발생 시 기준에 맞는 대안과 보완 방향을 제시합니다.</li>
		      	</ul>
              </div>
              <div class="col-lg-6 order-1 order-lg-2 text-center">
                <img src="${ctx}/resources/front/img/main/features4.png" alt="" class="img-fluid">
              </div>
            </div>
          </div><!-- End tab content item -->

        </div>

      </div>
    </section><!-- End Features Section -->

    <!-- ======= Our Projects Section ======= -->
    <section id="projects" class="projects">
      <div class="container">

        <div class="section-header">
          <h2>ENGINEERING SERVICE</h2>
          <p>구조설계부터 구조검토, 내진설계·안전진단까지 건축 구조 엔지니어링 서비스를 제공합니다.</p>
        </div>

        <div class="portfolio-custom" data-portfolio-filter="*" data-portfolio-layout="masonry"
          data-portfolio-sort="original-order">

          <ul class="portfolio-flters">
            <li data-filter="*" class="filter-active">전체</li>
            <li data-filter=".filter-stra">구조설계</li>
            <li data-filter=".filter-stre">구조검토</li>
            <li data-filter=".filter-dise">해체검토</li>
            <li data-filter=".filter-safe">안전진단</li>
            <li data-filter=".filter-spfe">내진성능평가</li>
            <li data-filter=".filter-tere">가설재설계</li>
            <li data-filter=".filter-vera">VE설계</li>
            <li data-filter=".filter-sdse">비구조요소 내진설계</li>
          </ul><!-- End Projects Filters -->

          <div class="row gy-4 portfolio-container" style="min-height:200px;">

            <c:forEach var="row" items="${engList}">
              <c:set var="filterClass" value="" />
              <c:choose>
                <c:when test="${row.brdCd == BRD_CD_STRA}"><c:set var="filterClass" value="filter-stra" /></c:when>
                <c:when test="${row.brdCd == BRD_CD_STRE}"><c:set var="filterClass" value="filter-stre" /></c:when>
                <c:when test="${row.brdCd == BRD_CD_DISE}"><c:set var="filterClass" value="filter-dise" /></c:when>
                <c:when test="${row.brdCd == BRD_CD_SAFE}"><c:set var="filterClass" value="filter-safe" /></c:when>
                <c:when test="${row.brdCd == BRD_CD_SPFE}"><c:set var="filterClass" value="filter-spfe" /></c:when>
                <c:when test="${row.brdCd == BRD_CD_TERE}"><c:set var="filterClass" value="filter-tere" /></c:when>
                <c:when test="${row.brdCd == BRD_CD_VERA}"><c:set var="filterClass" value="filter-vera" /></c:when>
                <c:when test="${row.brdCd == BRD_CD_SDSE}"><c:set var="filterClass" value="filter-sdse" /></c:when>
              </c:choose>

              <div class="col-lg-4 col-md-6 portfolio-item ${filterClass}" data-view-cnt="${row.viewCnt}" style="display:none;">
                <div class="portfolio-content h-100" style="cursor:pointer;" onclick="fnGoEngDetail('${row.brdCd}', '${row.pstCd}')">
                  <c:choose>
                    <c:when test="${not empty row.thumbUrl}">
                      <img src="${row.thumbUrl}" class="img-fluid" alt="${row.pstNm}">
                    </c:when>
                    <c:otherwise>
                      <div class="img-fluid d-flex align-items-center justify-content-center" style="height:220px;background:#e9ecef;color:#999;font-size:14px;">${row.brdNm}</div>
                    </c:otherwise>
                  </c:choose>
                  <div class="portfolio-info">
                    <h4>${row.pstNm}</h4>
                    <p>${row.brdNm}</p>
                  </div>
                </div>
              </div><!-- End Projects Item -->
            </c:forEach>

            <c:if test="${empty engList}">
              <div class="col-12 text-center py-5">
                <p class="text-muted">등록된 게시글이 없습니다.</p>
              </div>
            </c:if>

          </div><!-- End Projects Container -->

        </div>

      </div>
    </section><!-- End Our Projects Section -->

    <!-- 엔지니어링 상세 이동 폼 -->
    <form id="goEngDetailForm" action="${ctx}/bbs/viewBbsDetail" method="post" style="display:none;">
      <input type="hidden" name="brdCd" id="engBrdCd" />
      <input type="hidden" name="pstCd" id="engPstCd" />
      <input type="hidden" name="pageNo" value="1" />
    </form>

  </main><!-- End #main -->

  <!-- 플로팅 버튼 -->


<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>

  <script>
  	$(document).ready(function () {
  	  // 엔지니어링 서비스 필터 (최대 9건)
  	  var $container = $('.portfolio-container');
  	  var $items = $container.find('.portfolio-item');
  	  var MAX_SHOW = 9;

  	  function applyFilter(filterVal) {
  	    // 1) 전부 숨김
  	    $items.hide();

  	    // 2) 대상 필터링
  	    var $target;
  	    if (filterVal === '*') {
  	      // 전체: 조회수 높은 순 정렬
  	      $target = $items.toArray().sort(function(a, b) {
  	        return (parseInt($(b).data('view-cnt')) || 0) - (parseInt($(a).data('view-cnt')) || 0);
  	      });
  	      $target = $($target);
  	    } else {
  	      $target = $items.filter(filterVal);
  	    }

  	    // 3) 최대 9건만 표시
  	    $target.slice(0, MAX_SHOW).show();
  	  }

  	  // 초기 로드: 전체 9건
  	  applyFilter('*');

  	  // 탭 클릭 이벤트 (기존 isotope 대신)
  	  $('.portfolio-flters li').on('click', function() {
  	    $('.portfolio-flters li').removeClass('filter-active');
  	    $(this).addClass('filter-active');
  	    applyFilter($(this).attr('data-filter'));
  	  });
  	});

  	function fnGoEngDetail(brdCd, pstCd) {
  	  $('#engBrdCd').val(brdCd);
  	  $('#engPstCd').val(pstCd);
  	  $('#goEngDetailForm').submit();
  	}
  </script>

  <!-- ===== FO 팝업 (모달) ===== -->
  <c:if test="${not empty popupList}">

  <%-- 팝업 내용 hidden 저장 (HTML 안전 전달) --%>
  <c:forEach var="pop" items="${popupList}">
    <textarea id="_popCnts_${pop.popCd}" style="display:none;">${pop.popCnts}</textarea>
  </c:forEach>

  <style>
    .fo-pop-box {
      position: fixed;
      z-index: 99999;
      background: #fff;
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 8px 32px rgba(0,0,0,0.25);
      display: flex;
      flex-direction: column;
    }
    .fo-pop-body {
      flex: 1;
      overflow-y: auto;
      padding: 24px;
    }
    .fo-pop-body img {
      max-width: 100%;
      height: auto;
    }
    .fo-pop-footer {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 10px 16px;
      background: #f8f8f8;
      border-top: 1px solid #e0e0e0;
      font-size: 13px;
      color: #666;
    }
    .fo-pop-footer label {
      cursor: pointer;
      display: flex;
      align-items: center;
      gap: 6px;
      margin: 0;
    }
    .fo-pop-footer input[type=checkbox] {
      width: 15px;
      height: 15px;
      accent-color: #555;
    }
    .fo-pop-close {
      padding: 6px 20px;
      font-size: 13px;
      font-weight: 500;
      color: #fff;
      background: #333;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }
    .fo-pop-close:hover {
      background: #555;
    }
  </style>

  <script>
  $(function() {
    var popupList = [
      <c:forEach var="pop" items="${popupList}" varStatus="st">
      {
        popCd:    '${pop.popCd}',
        popNm:    '<c:out value="${pop.popNm}" />',
        popCnts:  '',
        popWidth: ${pop.popWidth != null ? pop.popWidth : 500},
        popHgt:   ${pop.popHgt != null ? pop.popHgt : 400},
        popXLoc:  ${pop.popXLoc != null ? pop.popXLoc : 100},
        popYLoc:  ${pop.popYLoc != null ? pop.popYLoc : 100}
      }<c:if test="${!st.last}">,</c:if>
      </c:forEach>
    ];

    <c:forEach var="pop" items="${popupList}" varStatus="st">
    popupList[${st.index}].popCnts = document.getElementById('_popCnts_${pop.popCd}').value;
    </c:forEach>

    for (var i = 0; i < popupList.length; i++) {
      fnOpenFoModal(popupList[i]);
    }
  });

  function fnGetCookie(name) {
    var v = document.cookie.match('(^|;)\\s*' + name + '\\s*=\\s*([^;]+)');
    return v ? v.pop() : '';
  }

  function fnOpenFoModal(pop) {
    var cookieName = 'pop_today_' + pop.popCd;
    if (fnGetCookie(cookieName) === 'Y') return;

    var w = pop.popWidth;
    var h = pop.popHgt;
    var x = pop.popXLoc;
    var y = pop.popYLoc;

    // 모바일: 화면 중앙 배치 + 크기 축소
    var maxW = window.innerWidth - 32;
    var maxH = window.innerHeight - 32;
    if (w > maxW) w = maxW;
    if (h > maxH) h = maxH;

    if (window.innerWidth <= 768) {
      x = Math.round((window.innerWidth - w) / 2);
      y = Math.round((window.innerHeight - h) / 2);
    }

    var box = document.createElement('div');
    box.className = 'fo-pop-box';
    box.setAttribute('data-pop-cd', pop.popCd);
    box.style.width = w + 'px';
    box.style.height = h + 'px';
    box.style.left = x + 'px';
    box.style.top = y + 'px';

    var body = document.createElement('div');
    body.className = 'fo-pop-body';
    body.innerHTML = pop.popCnts;

    var footer = document.createElement('div');
    footer.className = 'fo-pop-footer';

    var chkId = 'chkToday_' + pop.popCd;
    footer.innerHTML =
      '<label><input type="checkbox" id="' + chkId + '" /> 오늘 하루 보지 않기</label>' +
      '<button class="fo-pop-close" data-pop-cd="' + pop.popCd + '" data-chk-id="' + chkId + '">닫기</button>';

    box.appendChild(body);
    box.appendChild(footer);
    document.body.appendChild(box);

    footer.querySelector('.fo-pop-close').addEventListener('click', function() {
      var cd = this.getAttribute('data-pop-cd');
      var chk = document.getElementById(this.getAttribute('data-chk-id'));
      if (chk && chk.checked) {
        var d = new Date();
        d.setHours(23,59,59,0);
        document.cookie = 'pop_today_' + cd + '=Y; expires=' + d.toUTCString() + '; path=/';
      }
      var el = document.querySelector('.fo-pop-box[data-pop-cd="' + cd + '"]');
      if (el) el.remove();
    });
  }
  </script>
  </c:if>



