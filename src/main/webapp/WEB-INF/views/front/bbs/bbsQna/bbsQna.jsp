<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>
<%@ include file="/WEB-INF/views/front/bbs/bbsCommon/inc/bbsPagingVars.jspf" %>

<div class="page-header">
  <h2>문의하기</h2>
</div>

<c:set var="activeLnb" value="qna" scope="request" />
<div class="content-layout">
  <%@ include file="/WEB-INF/views/front/bbs/inc/sidebarSupport.jsp" %>

  <div class="content-main">

    <div class="board-header">
      <p class="board-total">전체 <strong>${originalCnt}</strong>건</p>
      <div class="board-admin-btns">
        <c:if test="${not empty sessionScope.loginUser}">
          <button type="button" class="btn-admin" onclick="fnGoMng()">⚙ 관리</button>
        </c:if>
        <button type="button" class="btn-admin" onclick="fnGoWrite()">✏ 문의하기</button>
      </div>
    </div>

    <table class="board-table">
      <colgroup>
        <col><col style="width:100px;"><col style="width:120px;"><col style="width:80px;">
      </colgroup>
      <thead>
        <tr><th class="td-left">제목</th><th>글쓴이</th><th>등록일</th><th>조회</th></tr>
      </thead>
      <tbody>
        <c:if test="${empty list}">
          <tr><td colspan="4" class="board-empty">등록된 문의가 없습니다.</td></tr>
        </c:if>
        <c:forEach var="row" items="${list}">
          <tr <c:choose>
                <c:when test="${row.pstLvl == 0}">onclick="fnGoDetail('${row.pstCd}')"</c:when>
                <c:otherwise>onclick="fnGoDetail('${row.rotPstCd}')"</c:otherwise>
              </c:choose>>
            <td class="td-left td-title">
              <c:if test="${row.pstLvl > 0}"><span style="padding-left:16px; color:var(--orange);">↳ </span></c:if>
              ${row.pstNm}
              <c:if test="${row.pstLvl == 0}"><span style="color:var(--gray-400); font-size:12px; margin-left:4px;">🔒</span></c:if>
              <c:if test="${row.pstLvl == 0 and row.replyCnt > 0}"><span style="color:var(--orange); font-size:12px; margin-left:4px;">답변완료</span></c:if>
            </td>
            <td class="td-muted">
              <c:choose>
                <c:when test="${row.pstLvl > 0}">관리자</c:when>
                <c:when test="${fn:length(row.rgtUsrNm) == 2}">${fn:substring(row.rgtUsrNm, 0, 1)}*</c:when>
                <c:when test="${fn:length(row.rgtUsrNm) >= 3}">${fn:substring(row.rgtUsrNm, 0, 1)}*${fn:substring(row.rgtUsrNm, fn:length(row.rgtUsrNm)-1, fn:length(row.rgtUsrNm))}</c:when>
                <c:otherwise>${row.rgtUsrNm}</c:otherwise>
              </c:choose>
            </td>
            <td class="td-muted">${row.rgtDtm}</td>
            <td class="td-muted">${row.pstLvl == 0 ? row.viewCnt : '-'}</td>
          </tr>
        </c:forEach>
      </tbody>
    </table>

    <div class="board-paging">
      <a href="javascript:fnGoPage(${pageNo - 1})" class="${pageNo <= 1 ? 'disabled' : ''}">이전</a>
      <c:forEach var="p" begin="${startPage}" end="${endPage}">
        <a href="javascript:fnGoPage(${p})" class="${p == pageNo ? 'active' : ''}">${p}</a>
      </c:forEach>
      <a href="javascript:fnGoPage(${pageNo + 1})" class="${pageNo >= totalPage ? 'disabled' : ''}">다음</a>
    </div>

    <form class="board-search" method="post" action="${ctx}/bbs/viewBbsQna">
      <input type="hidden" name="brdCd" value="${brdCd}" />
      <select name="searchType">
        <option value="title" ${param.searchType eq 'title' ? 'selected' : ''}>제목</option>
        <option value="content" ${param.searchType eq 'content' ? 'selected' : ''}>내용</option>
      </select>
      <input type="text" name="keyword" value="${param.keyword}" placeholder="검색어를 입력해 주세요."/>
      <button type="submit">검색</button>
    </form>

    <!-- hidden forms -->
    <form id="goDetailForm" action="${ctx}/bbs/viewBbsDetailQna" method="post">
      <input type="hidden" name="brdCd" value="${brdCd}" />
      <input type="hidden" name="pstCd" id="detailPstCd" />
      <input type="hidden" name="pageNo" value="${pageNo}" />
    </form>
    <form id="pagingForm" action="${ctx}/bbs/viewBbsQna" method="post">
      <input type="hidden" name="brdCd" value="${brdCd}" />
      <input type="hidden" name="pageNo" id="pageNo" value="${pageNo}" />
      <input type="hidden" name="searchType" value="${param.searchType}" />
      <input type="hidden" name="keyword" value="${param.keyword}" />
    </form>
    <form id="goWriteForm" action="${ctx}/bbs/viewBbsWriteQna" method="post">
      <input type="hidden" name="brdCd" value="${brdCd}" />
    </form>
    <form id="goMngForm" action="${ctx}/bbsComQnaMng/viewBbsComQnaMng" method="post" target="_blank">
      <input type="hidden" name="brdCd" value="${brdCd}" />
    </form>

  </div>
</div>

<script>
  function fnGoPage(no) { $('#pageNo').val(no); $('#pagingForm').submit(); }
  function fnGoWrite() { $('#goWriteForm').submit(); }
  function fnGoMng() { $('#goMngForm').submit(); }

  <c:choose>
    <c:when test="${not empty sessionScope.loginUser}">
    function fnGoDetail(pstCd) {
      $('#detailPstCd').val(pstCd);
      $('#goDetailForm').submit();
    }
    </c:when>
    <c:otherwise>
    var _currentPstCd = '';
    function fnGoDetail(pstCd) {
      _currentPstCd = pstCd;
      $('#modalSecretPwd').val('');
      $('#secretPwdModal').fadeIn(150);
      setTimeout(function(){ $('#modalSecretPwd').focus(); }, 200);
    }
    function fnCloseModal() { $('#secretPwdModal').fadeOut(150); _currentPstCd = ''; }
    function fnCheckPwd() {
      var pwd = $('#modalSecretPwd').val().trim();
      if (!pwd) { alert('비밀번호를 입력해주세요.'); $('#modalSecretPwd').focus(); return; }
      var res = ajaxCall('${ctx}/bbs/checkSecretPwd', {
        brdCd: '${brdCd}', pstCd: _currentPstCd, secretPwd: pwd
      }, false);
      if (res && res.result === 'OK') {
        $('#detailPstCd').val(_currentPstCd);
        fnCloseModal();
        $('#goDetailForm').submit();
      } else {
        alert(res && res.message ? res.message : '비밀번호가 일치하지 않습니다.');
        $('#modalSecretPwd').val('').focus();
      }
    }
    $(document).on('keydown', '#modalSecretPwd', function(e) { if (e.keyCode === 13) { e.preventDefault(); fnCheckPwd(); } });
    $(document).on('click', '#secretPwdModal', function(e) { if ($(e.target).is('#secretPwdModal')) fnCloseModal(); });
    </c:otherwise>
  </c:choose>
</script>

<c:if test="${empty sessionScope.loginUser}">
<div id="secretPwdModal" class="privacy-modal" style="display:none;">
  <div class="privacy-modal-overlay" onclick="fnCloseModal()"></div>
  <div class="privacy-modal-content" style="max-width:400px;">
    <div class="privacy-modal-header">
      <h3 class="privacy-modal-title">비밀번호 확인</h3>
      <button type="button" class="privacy-modal-close" onclick="fnCloseModal()">&times;</button>
    </div>
    <div class="privacy-modal-body" style="white-space:normal;">
      <p style="margin-bottom:16px; font-size:13px; color:var(--gray-400);">글 작성 시 입력한 비밀번호를 입력해주세요.</p>
      <input type="password" id="modalSecretPwd" maxlength="20" placeholder="비밀번호 입력"
             style="width:100%; padding:14px 16px; border:1px solid var(--gray-200); border-radius:10px;
                    font-size:15px; outline:none; font-family:inherit; margin-bottom:16px;" />
      <div style="display:flex; gap:10px;">
        <button type="button" onclick="fnCloseModal()" class="board-btn board-btn-edit" style="flex:1;">취소</button>
        <button type="button" onclick="fnCheckPwd()" class="board-btn board-btn-list" style="flex:1;">확인</button>
      </div>
    </div>
  </div>
</div>
</c:if>

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>

</body>
</html>
