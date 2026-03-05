<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>

<div class="page-header">
  <h2>문의하기</h2>
</div>

<c:set var="activeLnb" value="qna" scope="request" />
<div class="content-layout">
  <%@ include file="/WEB-INF/views/front/bbs/inc/sidebarSupport.jsp" %>

  <div class="content-main">

    <!-- 제목 헤더 -->
    <div class="board-detail-header">
      <div class="board-detail-title">${pst.pstNm}</div>
      <div class="board-detail-meta">
        <span>작성자 : ${pst.rgtUsrNm}</span>
        <span>등록일 : ${pst.rgtDtm}</span>
        <span>조회 : ${pst.viewCnt}</span>
        <c:if test="${not empty sessionScope.loginUser}">
          <c:if test="${not empty pst.rgtPhone}"><span>연락처 : ${pst.rgtPhone}</span></c:if>
          <c:if test="${not empty pst.rgtEmail}"><span>이메일 : ${pst.rgtEmail}</span></c:if>
        </c:if>
      </div>
    </div>

    <!-- Q 질문 -->
    <div style="padding:28px 0; border-bottom:1px solid var(--gray-200);">
      <div style="display:flex; gap:14px; align-items:flex-start;">
        <div style="width:36px; height:36px; border-radius:10px; background:var(--orange); color:white; display:flex; align-items:center; justify-content:center; font-weight:800; font-size:16px; flex-shrink:0;">Q</div>
        <div style="flex:1;">
          <div style="font-size:15px; color:var(--gray-700); line-height:1.85; word-break:keep-all;">
            <c:out value="${pst.pstCnts}" escapeXml="false"/>
          </div>
          <c:if test="${not empty fileList}">
            <div class="board-detail-attach" style="margin-top:16px; border-radius:10px;">
              <div class="board-detail-attach-label">첨부파일</div>
              <ul class="board-detail-attach-list">
                <c:forEach var="file" items="${fileList}">
                  <li><a href="${ctx}/file/download?upldFileCd=${file.upldFileCd}&fileSeq=${file.fileSeq}">${file.fileNm}</a></li>
                </c:forEach>
              </ul>
            </div>
          </c:if>
        </div>
      </div>
    </div>

    <!-- A 답변 -->
    <c:forEach var="reply" items="${replyList}">
      <div style="padding:28px 0; border-bottom:1px solid var(--gray-200); background:var(--gray-50); margin:0 -24px; padding-left:24px; padding-right:24px;">
        <div style="display:flex; gap:14px; align-items:flex-start;">
          <div style="width:36px; height:36px; border-radius:10px; background:var(--navy); color:white; display:flex; align-items:center; justify-content:center; font-weight:800; font-size:16px; flex-shrink:0;">A</div>
          <div style="flex:1;">
            <div style="display:flex; align-items:center; gap:8px; margin-bottom:12px; font-size:13px; color:var(--gray-400);">
              <span style="font-weight:600; color:var(--navy);">${reply.rgtUsrNm}</span>
              <span>| ${reply.rgtDtm}</span>
              <c:if test="${not empty sessionScope.loginUser}">
                <span style="margin-left:auto;">
                  <a href="javascript:fnEditReply()" style="color:var(--orange); font-size:12px;">수정</a>
                  <span style="margin:0 4px;">|</span>
                  <a href="javascript:fnDeleteReply('${reply.pstCd}')" style="color:#dc3545; font-size:12px;">삭제</a>
                </span>
              </c:if>
            </div>
            <div style="font-size:15px; color:var(--gray-700); line-height:1.85; word-break:keep-all;">
              <c:out value="${reply.pstCnts}" escapeXml="false"/>
            </div>
            <c:if test="${not empty reply.fileList}">
              <div class="board-detail-attach" style="margin-top:16px; border-radius:10px;">
                <div class="board-detail-attach-label">첨부파일</div>
                <ul class="board-detail-attach-list">
                  <c:forEach var="file" items="${reply.fileList}">
                    <li><a href="${ctx}/file/download?upldFileCd=${file.upldFileCd}&fileSeq=${file.fileSeq}">${file.fileNm}</a></li>
                  </c:forEach>
                </ul>
              </div>
            </c:if>
          </div>
        </div>
      </div>
    </c:forEach>

    <!-- 답변 없을 때 -->
    <c:if test="${empty replyList}">
      <div style="padding:40px 0; text-align:center; color:var(--gray-400); font-size:14px; border-bottom:1px solid var(--gray-200);">
        <div style="width:36px; height:36px; border-radius:10px; background:var(--gray-200); color:var(--gray-400); display:inline-flex; align-items:center; justify-content:center; font-weight:800; font-size:16px; margin-bottom:10px;">A</div>
        <p>아직 답변이 등록되지 않았습니다.</p>
      </div>
    </c:if>

    <!-- 버튼 -->
    <div class="board-detail-btns">
      <button type="button" class="board-btn board-btn-list" onclick="fnGoList()">목록</button>
      <c:choose>
        <c:when test="${not empty sessionScope.loginUser}">
          <c:if test="${empty replyList}">
            <button type="button" class="board-btn board-btn-edit" onclick="fnReply()">답변하기</button>
          </c:if>
          <button type="button" class="board-btn board-btn-delete" onclick="fnDeleteAll()">삭제</button>
        </c:when>
        <c:otherwise>
          <c:if test="${empty replyList}">
            <button type="button" class="board-btn board-btn-edit" onclick="fnEdit()">수정</button>
            <button type="button" class="board-btn board-btn-delete" onclick="fnDeleteByUser()">삭제</button>
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
    <form id="goEditForm" action="${ctx}/bbs/viewBbsWriteQna" method="post">
      <input type="hidden" name="brdCd" value="${brdCd}" /><input type="hidden" name="pstCd" value="${pst.pstCd}" /><input type="hidden" name="pageNo" value="${pageNo}" />
    </form>
    <form id="goDetailForm" action="${ctx}/bbs/viewBbsDetailQna" method="post">
      <input type="hidden" name="brdCd" value="${brdCd}" /><input type="hidden" name="pstCd" value="${pst.pstCd}" /><input type="hidden" name="pageNo" value="${pageNo}" />
    </form>

  </div>
</div>

<script>
  function fnGoList() { $('#goListForm').submit(); }
  function fnReply() { $('#goReplyForm').submit(); }
  function fnEditReply() { $('#goEditReplyForm').submit(); }
  function fnEdit() { $('#goEditForm').submit(); }
  function fnDeleteAll() {
    var hasReply = ${not empty replyList ? 'true' : 'false'};
    if (!confirm(hasReply ? '질문과 답변이 모두 삭제됩니다. 삭제하시겠습니까?' : '삭제하시겠습니까?')) return;
    var res = ajaxCall("${ctx}/bbsComMng/deleteBbsPst", { brdCd:'${brdCd}', pstCd:'${pst.pstCd}', cascade:'Y' }, false);
    if (res && res.result === 'OK') { alert('삭제되었습니다.'); fnGoList(); } else { alert('삭제 실패'); }
  }
  function fnDeleteReply(replyPstCd) {
    if (!confirm('답변을 삭제하시겠습니까?')) return;
    var res = ajaxCall("${ctx}/bbsComMng/deleteBbsPst", { brdCd:'${brdCd}', pstCd:replyPstCd }, false);
    if (res && res.result === 'OK') { alert('답변이 삭제되었습니다.'); $('#goDetailForm').submit(); } else { alert('삭제 실패'); }
  }
  function fnDeleteByUser() {
    if (!confirm('삭제하시겠습니까?')) return;
    var res = ajaxCall("${ctx}/bbsComMng/deleteBbsPst", { brdCd:'${brdCd}', pstCd:'${pst.pstCd}' }, false);
    if (res && res.result === 'OK') { alert('삭제되었습니다.'); fnGoList(); } else { alert('삭제 실패'); }
  }
</script>

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>
</body>
</html>
