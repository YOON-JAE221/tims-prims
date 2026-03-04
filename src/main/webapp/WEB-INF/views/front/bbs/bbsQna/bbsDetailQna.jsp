<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>

<main id="main">

  <!-- ======= Breadcrumbs ======= -->
  <div class="breadcrumbs d-flex align-items-center">
    <div class="container position-relative d-flex flex-column align-items-center">
      <h2>${brd.brdNm}</h2>
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

      <!-- ======= Detail ======= -->
      <section class="qnaDetail">
        <div class="container">

          <!-- 제목 영역 -->
          <div class="qnaDetail-header">
            <h3 class="qnaDetail-title">${pst.pstNm}</h3>
            <div class="qnaDetail-meta">
              <span>작성자 : ${pst.rgtUsrNm}</span>
              <span>등록일 : ${pst.rgtDtm}</span>
              <span>조회수 : ${pst.viewCnt}</span>
              <c:if test="${not empty sessionScope.loginUser}">
                <c:if test="${not empty pst.rgtPhone}"><span>연락처 : ${pst.rgtPhone}</span></c:if>
                <c:if test="${not empty pst.rgtEmail}"><span>이메일 : ${pst.rgtEmail}</span></c:if>
              </c:if>
            </div>
          </div>

          <!-- Q 질문 영역 -->
          <div class="qnaDetail-block qnaDetail-block--q">
            <div class="qnaDetail-badge qnaDetail-badge--q">Q</div>
            <div class="qnaDetail-body">
              <h4 class="qnaDetail-blockTitle">${pst.pstNm}</h4>
              <div class="qnaDetail-content"><c:out value="${pst.pstCnts}" escapeXml="false"/></div>
              <c:if test="${not empty fileList}">
                <div class="qnaDetail-atch">
                  <span class="qnaDetail-atchLabel">첨부파일</span>
                  <div class="qnaDetail-atchFiles">
                    <c:forEach var="file" items="${fileList}">
                      <a href="${ctx}/file/download?upldFileCd=${file.upldFileCd}&fileSeq=${file.fileSeq}" class="qnaDetail-atchItem">
                        <i class="bi bi-paperclip"></i> ${file.fileNm}
                      </a>
                    </c:forEach>
                  </div>
                </div>
              </c:if>
            </div>
          </div>

          <!-- A 답변 영역 -->
          <c:forEach var="reply" items="${replyList}">
            <div class="qnaDetail-block qnaDetail-block--a">
              <div class="qnaDetail-badge qnaDetail-badge--a">A</div>
              <div class="qnaDetail-body">
                <div class="qnaDetail-replyInfo">
                  <span class="qnaDetail-replyAuthor">${reply.rgtUsrNm}</span>
                  <span class="qnaDetail-replyDate">| ${reply.rgtDtm}</span>
                  <c:if test="${not empty sessionScope.loginUser}">
                    <span class="qnaDetail-replyActions">
                      <a href="javascript:fnEditReply()" class="qnaDetail-replyLink">답변수정</a>
                      <span class="qnaDetail-replyDot">|</span>
                      <a href="javascript:fnDeleteReply('${reply.pstCd}')" class="qnaDetail-replyLink">답변삭제</a>
                    </span>
                  </c:if>
                </div>
                <h4 class="qnaDetail-blockTitle">${reply.pstNm}</h4>
                <div class="qnaDetail-content"><c:out value="${reply.pstCnts}" escapeXml="false"/></div>
                <c:if test="${not empty reply.fileList}">
                  <div class="qnaDetail-atch">
                    <span class="qnaDetail-atchLabel">첨부파일</span>
                    <div class="qnaDetail-atchFiles">
                      <c:forEach var="file" items="${reply.fileList}">
                        <a href="${ctx}/file/download?upldFileCd=${file.upldFileCd}&fileSeq=${file.fileSeq}" class="qnaDetail-atchItem">
                          <i class="bi bi-paperclip"></i> ${file.fileNm}
                        </a>
                      </c:forEach>
                    </div>
                  </div>
                </c:if>
              </div>
            </div>
          </c:forEach>

          <!-- 답변 없을 때 -->
          <c:if test="${empty replyList}">
            <div class="qnaDetail-block qnaDetail-block--a qnaDetail-block--empty">
              <div class="qnaDetail-badge qnaDetail-badge--a">A</div>
              <div class="qnaDetail-body">
                <p class="qnaDetail-emptyMsg">아직 답변이 등록되지 않았습니다.</p>
              </div>
            </div>
          </c:if>

          <!-- 버튼 -->
          <div class="qnaDetail-btnRow">
            <button type="button" class="qnaDetail-btn qnaDetail-btn--list" onclick="fnGoList()">목록</button>
            <c:choose>
              <c:when test="${not empty sessionScope.loginUser}">
                <c:if test="${empty replyList}">
                  <button type="button" class="qnaDetail-btn qnaDetail-btn--dark" onclick="fnReply()">답변하기</button>
                </c:if>
                <button type="button" class="qnaDetail-btn qnaDetail-btn--dark" onclick="fnDeleteAll()">삭제</button>
              </c:when>
              <c:otherwise>
                <c:if test="${empty replyList}">
                  <button type="button" class="qnaDetail-btn qnaDetail-btn--dark" onclick="fnEdit()">수정</button>
                  <button type="button" class="qnaDetail-btn qnaDetail-btn--dark" onclick="fnDeleteByUser()">삭제</button>
                </c:if>
              </c:otherwise>
            </c:choose>
          </div>

          <!-- hidden forms -->
          <form id="goListForm" action="${ctx}/bbs/viewBbsQna" method="post">
            <input type="hidden" name="brdCd" value="${brdCd}" /><input type="hidden" name="pageNo" value="${pageNo}" />
          </form>
          <form id="goReplyForm" action="${ctx}/bbs/viewBbsWriteQnaAns" method="post">
            <input type="hidden" name="brdCd" value="${brdCd}" /><input type="hidden" name="pstCd" value="${pst.pstCd}" /><input type="hidden" name="pageNo" value="${pageNo}" />
          </form>
          <form id="goEditReplyForm" action="${ctx}/bbs/viewBbsWriteQnaAns" method="post">
            <input type="hidden" name="brdCd" value="${brdCd}" /><input type="hidden" name="pstCd" value="${pst.pstCd}" />
            <c:if test="${not empty replyList}"><input type="hidden" name="ansPstCd" value="${replyList[0].pstCd}" /></c:if>
            <input type="hidden" name="pageNo" value="${pageNo}" />
          </form>
          <form id="goDetailForm" action="${ctx}/bbs/viewBbsDetailQna" method="post">
            <input type="hidden" name="brdCd" value="${brdCd}" /><input type="hidden" name="pstCd" value="${pst.pstCd}" /><input type="hidden" name="pageNo" value="${pageNo}" />
          </form>
          <form id="goEditForm" action="${ctx}/bbs/viewBbsWriteQna" method="post">
            <input type="hidden" name="brdCd" value="${brdCd}" /><input type="hidden" name="pstCd" value="${pst.pstCd}" /><input type="hidden" name="pageNo" value="${pageNo}" />
          </form>

        </div>
      </section>

    </div><!-- /lnb-content -->
  </div><!-- /lnb-layout -->

</main><!-- End #main -->


<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>

<script>
  function fnGoList() { $('#goListForm').submit(); }
  function fnDeleteAll() {
    var hasReply = ${not empty replyList ? 'true' : 'false'};
    var msg = hasReply ? '질문과 답변이 모두 삭제됩니다. 삭제하시겠습니까?' : '삭제하시겠습니까?';
    if (!confirm(msg)) return;
    var res = ajaxCall("${ctx}/bbs/deleteBbsPst", { brdCd:'${brdCd}', pstCd:'${pst.pstCd}', cascade:'Y' }, false);
    if (res && res.result === 'OK') { alert('삭제되었습니다.'); fnGoList(); } else { alert('삭제 실패'); }
  }
  function fnDeleteReply(replyPstCd) {
    if (!confirm('답변을 삭제하시겠습니까?')) return;
    var res = ajaxCall("${ctx}/bbs/deleteBbsPst", { brdCd:'${brdCd}', pstCd:replyPstCd }, false);
    if (res && res.result === 'OK') { alert('답변이 삭제되었습니다.'); $('#goDetailForm').submit(); } else { alert('삭제 실패'); }
  }
  function fnReply() { $('#goReplyForm').submit(); }
  function fnEditReply() { $('#goEditReplyForm').submit(); }
  function fnEdit() { $('#goEditForm').submit(); }
  function fnDeleteByUser() {
    if (!confirm('삭제하시겠습니까?')) return;
    var res = ajaxCall("${ctx}/bbs/deleteBbsPst", { brdCd:'${brdCd}', pstCd:'${pst.pstCd}' }, false);
    if (res && res.result === 'OK') { alert('삭제되었습니다.'); fnGoList(); } else { alert('삭제 실패'); }
  }
</script>
