<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="/WEB-INF/views/front/common/floating-btns.jsp" %>

<!-- ======= Footer ======= -->
<footer id="footer" class="footer footer-kanghan">

  <div class="footer-content position-relative">
    <div class="container">
      <div class="row justify-content-center">
        <div class="col-12">

          <div class="footer-center text-center">

            <!-- 로고/타이틀 -->
            <div class="footer-brand"> <img src="${ctx}/resources/front/img/logo/logo-footer.png" alt="강한건축구조기술사무소" class="footer-logo"> </div>

            <!-- 연락처 라인들 -->
            <div class="footer-lines">
              <div class="footer-contact-line">
                <span class="item">
                  <span class="label">모바일</span>
                  <span class="value">010-5093-1443</span>
                </span>
                <span class="sep">|</span>
                <span class="item">
                  <span class="label">대표번호</span>
                  <span class="value">070-7640-1002</span>
                </span>
                <span class="sep">|</span>
                <span class="item">
                  <span class="label">팩스</span>
                  <span class="value">070-7640-1003</span>
                </span>
              </div>

              <div class="footer-contact-line">
                <span class="item">
                  <span class="label">이메일</span>
                  <span class="value">kanghanstr@naver.com</span>
                </span>
                <span class="sep">|</span>
                <span class="item">
                  <span class="label">운영시간</span>
                  <span class="value">09:00 - 18:00(주말, 공휴일 휴무)</span>
                </span>
              </div>

              <div class="footer-contact-line">
                <span class="item">
                  <span class="label">주소</span>
                  <span class="value">서울시 강서구 마곡중앙로 161-1306호 (마곡동, 두산더랜드파크)</span>
                </span>
              </div>
            </div>
		</div><!-- /footer-center -->

        </div>
      </div>
    </div>
  </div>

  <div class="footer-legal text-center position-relative">
    <div class="container">
      <div class="footer-legal-links">
        <a href="${ctx}/greeting/viewGreeting" class="footer-legal-link">COMPANY</a>
        <span class="footer-legal-sep">|</span>
        <a href="javascript:void(0);" onclick="fnOpenPrivacyModal()" class="footer-legal-link footer-privacy">개인정보처리방침</a>
        <span class="footer-legal-sep">|</span>
        <a href="${ctx}/locGuide/viewLocGuide" class="footer-legal-link">찾아오시는길</a>
        <span class="footer-legal-sep">|</span>
        <c:choose>
          <c:when test="${not empty sessionScope.loginUser}">
            <a href="${ctx}/admin/viewAdminMain" class="footer-legal-link">관리자</a>
          </c:when>
          <c:otherwise>
            <a href="javascript:void(0);" onclick="fnOpenSitemapModal()" class="footer-legal-link">사이트맵</a>
          </c:otherwise>
        </c:choose>
        <span class="footer-legal-sep">|</span>
        <c:choose>
          <c:when test="${not empty sessionScope.loginUser}">
            <a href="${ctx}/login/doLogout" class="footer-legal-link">LOGOUT</a>
          </c:when>
          <c:otherwise>
            <a href="${ctx}/login/loginView" class="footer-legal-link">LOGIN</a>
          </c:otherwise>
        </c:choose>
      </div>
      <div class="copyright">
        Copyright © <strong><span>강한건축구조기술사무소</span></strong>. All rights reserved.
      </div>
    </div>
  </div>

</footer>
<!-- End Footer -->

  <!-- TOP 버튼은 floating-btns.jsp 로 이관됨 -->

  <div id="preloader"></div>

  <!-- Vendor JS Files -->
  <script src="${ctx}/resources/front/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <script src="${ctx}/resources/front/vendor/aos/aos.js"></script>
  <script src="${ctx}/resources/front/vendor/glightbox/js/glightbox.min.js"></script>

  <!-- Template Main JS File -->
  <script src="${ctx}/resources/front/js/main.js"></script>

  <!-- 개인정보처리방침 모달 -->
  <div id="privacyModal" class="privacy-modal" style="display:none;">
    <div class="privacy-modal-overlay" onclick="fnClosePrivacyModal()"></div>
    <div class="privacy-modal-content">
      <div class="privacy-modal-header">
        <h3 class="privacy-modal-title">개인정보처리방침</h3>
        <button type="button" class="privacy-modal-close" onclick="fnClosePrivacyModal()">&times;</button>
      </div>
      <div class="privacy-modal-body">강한건축구조기술사사무소(이하 '회사')는 개인정보보호법에 따라 이용자의 개인정보 보호 및 권익을 보호하고, 개인정보와 관련한 이용자의 고충을 원활하게 처리할 수 있도록 다음과 같이 개인정보를 수집·이용합니다.

1. 개인정보의 수집 및 이용 목적
회사는 수집한 개인정보를 다음의 목적을 위해 활용합니다. 수집한 개인정보는 다음의 목적 이외의 용도로는 사용되지 않으며, 이용 목적이 변경될 경우에는 사전에 동의를 구할 예정입니다.
- 온라인 문의 접수 및 답변 처리
- 문의 내용에 대한 확인 및 사실조사를 위한 연락·통지
- 처리 결과 통보 및 서비스 관련 상담 처리

2. 수집하는 개인정보 항목
회사는 문의 접수를 위해 아래와 같은 개인정보를 수집합니다.
- 필수항목 : 성명, 연락처(휴대전화번호)
- 선택항목 : 이메일

3. 개인정보의 보유 및 이용 기간
회사는 개인정보 수집 및 이용 목적이 달성된 후에는 해당 정보를 지체 없이 파기합니다. 다만, 관련 법령에 따라 보존이 필요한 경우 해당 법령에서 정한 기간까지 보관합니다.
- 보유 기간 : 수집일로부터 3년
- 소비자의 불만 또는 분쟁처리에 관한 기록 : 3년 (전자상거래 등에서의 소비자보호에 관한 법률)
- 보유 기간 경과 시 해당 개인정보를 지체 없이 파기합니다.

4. 개인정보의 파기 절차 및 방법
회사는 원칙적으로 개인정보 처리 목적이 달성된 경우에는 지체 없이 해당 개인정보를 파기합니다.
- 파기 절차 : 이용자가 입력한 정보는 목적 달성 후 별도의 DB에 옮겨져 내부 방침 및 관련 법령에 따라 일정 기간 저장된 후 파기됩니다.
- 파기 방법 : 전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 파기합니다.

5. 동의 거부권 및 불이익 안내
이용자는 개인정보 수집·이용에 대한 동의를 거부할 권리가 있습니다. 다만, 필수항목에 대한 동의를 거부하실 경우 온라인 문의 접수 서비스 이용이 제한될 수 있습니다.

6. 개인정보 보호책임자
회사는 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 이용자의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.
- 성명 : 송대룡
- 직책 : 대표
- 연락처 : 010-5093-1443
- 이메일 : kanghanstr@naver.com
      </div>
    </div>
  </div>

  <script>
    function fnOpenPrivacyModal() { $('#privacyModal').show(); $('body').css('overflow','hidden'); }
    function fnClosePrivacyModal() { $('#privacyModal').hide(); $('body').css('overflow',''); }
    function fnOpenSitemapModal() { $('#sitemapModal').show(); $('body').css('overflow','hidden'); }
    function fnCloseSitemapModal() { $('#sitemapModal').hide(); $('body').css('overflow',''); }
    $(document).on('keydown', function(e) {
      if (e.keyCode === 27) {
        if ($('#privacyModal').is(':visible')) fnClosePrivacyModal();
        if ($('#sitemapModal').is(':visible')) fnCloseSitemapModal();
      }
    });
  </script>

  <!-- 사이트맵 모달 -->
  <div id="sitemapModal" class="privacy-modal" style="display:none;">
    <div class="privacy-modal-overlay" onclick="fnCloseSitemapModal()"></div>
    <div class="privacy-modal-content sitemap-modal-content">
      <div class="privacy-modal-header">
        <h3 class="privacy-modal-title">사이트맵</h3>
        <button type="button" class="privacy-modal-close" onclick="fnCloseSitemapModal()">&times;</button>
      </div>
      <div class="sitemap-body">
        <div class="sitemap-grid">
          <div class="sitemap-group">
            <h4 class="sitemap-group-title">회사소개</h4>
            <ul class="sitemap-list">
              <li><a href="${ctx}/greeting/viewGreeting">인사말</a></li>
              <li><a href="${ctx}/comHistory/viewComHistory">연혁</a></li>
              <li><a href="${ctx}/locGuide/viewLocGuide">찾아오시는길</a></li>
            </ul>
          </div>
          <div class="sitemap-group">
            <h4 class="sitemap-group-title">ENGINEERING</h4>
            <ul class="sitemap-list">
              <li><a href="${ctx}/bbs/viewBbsStra">구조설계</a></li>
              <li><a href="${ctx}/bbs/viewBbsStre">구조검토</a></li>
              <li><a href="${ctx}/bbs/viewBbsDise">해체검토</a></li>
              <li><a href="${ctx}/bbs/viewBbsSafe">안전진단</a></li>
              <li><a href="${ctx}/bbs/viewBbsSpfe">내진성능평가</a></li>
              <li><a href="${ctx}/bbs/viewBbsTere">가설재설계</a></li>
              <li><a href="${ctx}/bbs/viewBbsVera">VE설계</a></li>
              <li><a href="${ctx}/bbs/viewBbsSdse">비구조요소 내진설계</a></li>
            </ul>
          </div>
          <div class="sitemap-group">
            <h4 class="sitemap-group-title">등록 및 면허</h4>
            <ul class="sitemap-list">
              <li><a href="${ctx}/license/viewLicense">등록 및 면허</a></li>
            </ul>
          </div>
          <div class="sitemap-group">
            <h4 class="sitemap-group-title">고객지원</h4>
            <ul class="sitemap-list">
              <li><a href="${ctx}/bbs/viewBbsNotice">공지사항</a></li>
              <li><a href="${ctx}/bbs/viewBbsQna">문의게시판</a></li>
              <li><a href="${ctx}/bbs/viewBbsDataRoom">자료실</a></li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </div>
  
  <script>
//   	$(document).ready(function () {
//   	});
  </script>
  
  
