<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<footer class="primus-footer">

  <div class="footer-main">
    <div class="footer-left">
      <div class="footer-logo-row">
        <div class="footer-logo-icon">P</div>
        <div class="footer-logo-name"><span>프리머스</span> 부동산</div>
      </div>
      <div class="footer-info">
        대표 : 박세환 | 등록번호 : 제41190-2022-00040호<br>
        경기도 부천시 길주로 280 프리머스 부천타워 1층 (중동 1141-2 롯데시네마 건물 1층)<br>
        TEL 032-327-1277 | FAX 032-327-1279<br>
        영업시간 : 평일 09:00 ~ 18:00 (토요일·공휴일 휴무)
      </div>
    </div>

    <div class="footer-right">
      <div class="footer-nav-col">
        <h4>주거매물</h4>
        <ul>
          <li><a href="javascript:fnFooterType('apt')">아파트</a></li>
          <li><a href="javascript:fnFooterType('officetel')">오피스텔</a></li>
          <li><a href="javascript:fnFooterType('villa')">빌라/주택</a></li>
          <li><a href="javascript:fnFooterType('oneroom')">원룸/투룸</a></li>
        </ul>
      </div>
      <div class="footer-nav-col">
        <h4>상업매물</h4>
        <ul>
          <li><a href="javascript:fnFooterType('shop')">상가</a></li>
          <li><a href="javascript:fnFooterType('office')">사무실</a></li>
        </ul>
      </div>
      <div class="footer-nav-col">
        <h4>서비스</h4>
        <ul>
          <li><a href="${ctx}/about/viewAbout">회사소개</a></li>
          <li><a href="${ctx}/property/viewPropertySearch">매물검색</a></li>
          <li><a href="${ctx}/locGuide/viewLocGuide">오시는길</a></li>
        </ul>
      </div>
      <div class="footer-nav-col">
        <h4>고객지원</h4>
        <ul>
          <li><a href="${ctx}/bbs/viewBbsNotice">공지사항</a></li>
          <li><a href="${ctx}/bbs/viewBbsFaq">FAQ</a></li>
          <li><a href="${ctx}/bbs/viewBbsQna">문의하기</a></li>
        </ul>
      </div>
    </div>
  </div>

  <div class="footer-bottom">
    <div class="footer-bottom-links">
      <a href="javascript:void(0);" class="footer-privacy" onclick="fnOpenPrivacyModal()">개인정보처리방침</a>
      <span class="footer-bottom-sep">|</span>
      <c:choose>
        <c:when test="${not empty sessionScope.loginUser}">
          <a href="${ctx}/login/doLogout">로그아웃</a>
        </c:when>
        <c:otherwise>
          <a href="${ctx}/login/loginView">관리자</a>
        </c:otherwise>
      </c:choose>
    </div>
    <div class="footer-copyright">&copy; 2026 프리머스 부동산. All rights reserved.</div>
  </div>

</footer>

<div id="privacyModal" class="privacy-modal" style="display:none;">
  <div class="privacy-modal-overlay" onclick="fnClosePrivacyModal()"></div>
  <div class="privacy-modal-content">
    <div class="privacy-modal-header">
      <h3 class="privacy-modal-title">개인정보처리방침</h3>
      <button type="button" class="privacy-modal-close" onclick="fnClosePrivacyModal()">&times;</button>
    </div>
    <div class="privacy-modal-body">프리머스 부동산(이하 '회사')은 개인정보보호법에 따라 이용자의 개인정보 보호 및 권익을 보호하고, 개인정보와 관련한 이용자의 고충을 원활하게 처리할 수 있도록 다음과 같이 개인정보를 수집·이용합니다.

1. 개인정보의 수집 및 이용 목적
- 온라인 문의 접수 및 답변 처리
- 매물 상담 신청 처리

2. 수집하는 개인정보 항목
- 필수항목 : 성명, 연락처(휴대전화번호)
- 선택항목 : 이메일

3. 개인정보의 보유 및 이용 기간
- 보유 기간 : 수집일로부터 3년

4. 개인정보 보호책임자
- 성명 : 박세환
- 연락처 : 032-327-1277
    </div>
  </div>
</div>

<script>
  function fnOpenPrivacyModal() { $('#privacyModal').show(); $('body').css('overflow','hidden'); }
  function fnClosePrivacyModal() { $('#privacyModal').hide(); $('body').css('overflow',''); }
  $(document).on('keydown', function(e) {
    if (e.keyCode === 27 && $('#privacyModal').is(':visible')) fnClosePrivacyModal();
  });

  function fnFooterType(t) {
    document.getElementById('footerTypeVal').value = t;
    document.getElementById('footerTypeForm').submit();
  }
</script>

<form id="footerTypeForm" action="${ctx}/property/viewPropertyList" method="post" style="display:none;">
  <input type="hidden" name="type" id="footerTypeVal" />
</form>
<script>
  var revealObserver = new IntersectionObserver(function(entries) {
    entries.forEach(function(entry) {
      if (entry.isIntersecting) entry.target.classList.add('visible');
    });
  }, { threshold: 0.1 });
  document.querySelectorAll('.reveal').forEach(function(el) { revealObserver.observe(el); });
</script>
