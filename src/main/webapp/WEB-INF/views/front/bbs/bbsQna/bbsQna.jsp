<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>
<%@ include file="/WEB-INF/views/front/bbs/bbsCommon/inc/bbsPagingVars.jspf" %>
<main id="main">

  <!-- ======= Breadcrumbs ======= -->
  <div class="breadcrumbs d-flex align-items-center">
    <div class="container position-relative d-flex flex-column align-items-center">
      <h2>문의게시판</h2>
      <ol>
        <li>고객지원</li>
      </ol>
    </div>
  </div><!-- End Breadcrumbs -->

  <!-- ======= 2컬럼 레이아웃 ======= -->
  <c:set var="activeLnb" value="qna" scope="request" />
  <div class="lnb-layout">
    <%@ include file="/WEB-INF/views/front/bbs/inc/sidebarSupport.jsp" %>

    <div class="lnb-content">
      <div class="lnb-contentHeader">
        <span class="bbsCommon-total">TOTAL : <span class="bbsCommon-totalNum">${totalCnt}</span> 건</span>
        <div class="lnb-contentBtns">
          <c:if test="${not empty sessionScope.loginUser}">
            <form action="${ctx}/bbsComQnaMng/viewBbsComQnaMng" method="POST" style="display:inline;">
              <input type="hidden" name="brdCd" value="${brdCd}" />
              <button type="submit" class="btn btn-admin-mng"><i class="bi bi-gear-fill"></i> 관리</button>
            </form>
          </c:if>
          <form action="${ctx}/bbs/viewBbsWriteQna" method="POST" style="display:inline;">
            <input type="hidden" name="brdCd" value="${brdCd}" />
            <input type="hidden" name="pageNo" value="${pageNo}" />
            <button type="submit" class="btn btn-admin-mng"><i class="bi bi-pencil-fill"></i> 문의하기</button>
          </form>
        </div>
      </div>

      <div class="bbsCommon">

        <div class="bbsCommon-tableWrap">
          <table class="bbsCommon-table">
            <colgroup>
              <col style="width:80px;"><col><col style="width:120px;"><col style="width:140px;"><col style="width:100px;">
            </colgroup>
            <thead>
              <tr><th>번호</th><th class="txt-left">제목</th><th>글쓴이</th><th>날짜</th><th>조회</th></tr>
            </thead>
            <tbody>
              <c:if test="${empty list}">
                <tr><td colspan="5" class="bbsCommon-emptyTd">등록된 게시물이 없습니다.</td></tr>
              </c:if>
              <c:forEach var="row" items="${list}" varStatus="st">
                <tr class="bbsCommon-row"
                    <c:choose>
                      <c:when test="${row.pstLvl == 0}">onclick="fnGoDetail('${row.pstCd}')"</c:when>
                      <c:otherwise>onclick="fnGoDetail('${row.rotPstCd}')"</c:otherwise>
                    </c:choose>
                >
                  <td>
                    <c:choose>
                      <c:when test="${row.pstLvl == 0}">${row.rowNum}</c:when>
                      <c:otherwise><i class="bi bi-arrow-return-right text-muted"></i></c:otherwise>
                    </c:choose>
                  </td>
                  <td class="txt-left">
                    <c:choose>
                      <c:when test="${row.pstLvl == 0}">
                        <span class="bbsCommon-ttl">${row.pstNm}</span>
                        <i class="bi bi-lock-fill" style="color:#999; font-size:12px; margin-left:4px;"></i>
                      </c:when>
                      <c:otherwise>
                        <span class="bbsCommon-ttl" style="padding-left: 20px;">
                          <i class="bi bi-arrow-return-right text-warning me-1"></i>
                          ${row.pstNm}
                          <i class="bi bi-lock-fill" style="color:#999; font-size:12px; margin-left:4px;"></i>
                        </span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td class="muted">${row.rgtUsrNm}</td>
                  <td class="muted">${row.rgtDtm}</td>
                  <td class="muted">${row.pstLvl == 0 ? row.viewCnt : '-'}</td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>

        <div class="bbsCommon-paging">
          <ul class="bbsCommon-pages">
            <li class="${pageNo <= 1 ? 'disabled' : ''}"><a href="javascript:fnGoPage(${pageNo - 1})">이전</a></li>
            <c:forEach var="p" begin="${startPage}" end="${endPage}">
              <li class="${p == pageNo ? 'active' : ''}"><a href="javascript:fnGoPage(${p})">${p}</a></li>
            </c:forEach>
            <li class="${pageNo >= totalPage ? 'disabled' : ''}"><a href="javascript:fnGoPage(${pageNo + 1})">다음</a></li>
          </ul>
        </div>

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

        <div class="bbsCommon-searchRow">
          <form class="bbsCommon-searchForm" method="post" action="${ctx}/bbs/viewBbsQna">
            <input type="hidden" name="brdCd" value="${brdCd}" />
            <select name="searchType" class="bbsCommon-select">
              <option value="title" ${param.searchType eq 'title' ? 'selected' : ''}>제목</option>
              <option value="content" ${param.searchType eq 'content' ? 'selected' : ''}>내용</option>
            </select>
            <input type="text" name="keyword" value="${param.keyword}" placeholder="검색어를 입력해 주세요." class="bbsCommon-input"/>
            <button type="submit" class="bbsCommon-searchBtn2">검색</button>
          </form>
        </div>
      </div><!-- /bbsCommon -->

    </div><!-- /lnb-content -->
  </div><!-- /lnb-layout -->

</main><!-- End #main -->

<script>
  function fnGoPage(no) {
    $('#pageNo').val(no);
    $('#pagingForm').submit();
  }

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
    function fnCloseModal() {
      $('#secretPwdModal').fadeOut(150);
      _currentPstCd = '';
    }
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
<div id="secretPwdModal" style="display:none; position:fixed; inset:0; z-index:10000; background:rgba(0,0,0,0.45);">
  <div style="position:absolute; top:50%; left:50%; transform:translate(-50%,-50%);
              background:#fff; border-radius:14px; padding:36px 32px 28px; width:380px; max-width:90vw;
              box-shadow:0 20px 60px rgba(0,0,0,0.18);">
    <h4 style="margin:0 0 6px; font-size:18px; font-weight:800; color:#111;">비밀번호 확인</h4>
    <p style="margin:0 0 20px; font-size:13px; color:#888; line-height:1.5;">글 작성 시 입력한 비밀번호를 입력해주세요.</p>
    <input type="password" id="modalSecretPwd" maxlength="20" placeholder="비밀번호 입력"
           style="width:100%; height:46px; border:1px solid #ddd; border-radius:10px;
                  padding:0 14px; font-size:15px; outline:none; box-sizing:border-box;" />
    <div style="display:flex; gap:10px; margin-top:18px;">
      <button type="button" onclick="fnCloseModal()"
              style="flex:1; height:44px; border:1px solid #ddd; background:#fff; border-radius:10px;
                     font-size:14px; font-weight:700; color:#666; cursor:pointer;">취소</button>
      <button type="button" onclick="fnCheckPwd()"
              style="flex:1; height:44px; border:none; background:#111; color:#fff; border-radius:10px;
                     font-size:14px; font-weight:700; cursor:pointer;">확인</button>
    </div>
  </div>
</div>
</c:if>


<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>
