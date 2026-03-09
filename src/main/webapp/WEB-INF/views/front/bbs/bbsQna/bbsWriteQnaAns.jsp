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
      <div class="qnaDetail">

        <!-- 원글 헤더 -->
        <div class="qnaDetail-header">
          <h3 class="qnaDetail-title">${parentPst.pstNm}</h3>
          <div class="qnaDetail-meta">
            <span>작성자 : ${parentPst.rgtUsrNm}</span>
            <span>등록일 : ${parentPst.rgtDtm}</span>
            <span>조회수 : ${parentPst.viewCnt}</span>
            <c:if test="${not empty sessionScope.loginUser}">
              <c:if test="${not empty parentPst.rgtPhone}"><span>연락처 : ${parentPst.rgtPhone}</span></c:if>

            </c:if>
          </div>
        </div>

        <!-- Q 질문 영역 (읽기전용) -->
        <div class="qnaDetail-block qnaDetail-block--q">
          <div class="qnaDetail-badge qnaDetail-badge--q">Q</div>
          <div class="qnaDetail-body">
            <h4 class="qnaDetail-blockTitle">${parentPst.pstNm}</h4>
            <div class="qnaDetail-content"><c:out value="${parentPst.pstCnts}" escapeXml="false"/></div>
          </div>
        </div>

        <!-- 원글 첨부파일 -->
        <c:if test="${not empty parentFileList}">
          <div class="qnaDetail-atch">
            <span class="qnaDetail-atchLabel">첨부파일</span>
            <div class="qnaDetail-atchFiles">
              <c:forEach var="file" items="${parentFileList}">
                <a href="${ctx}/file/download?upldFileCd=${file.upldFileCd}&fileSeq=${file.fileSeq}" class="qnaDetail-atchItem">
                  <i class="bi bi-paperclip"></i> ${file.fileNm}
                </a>
              </c:forEach>
            </div>
          </div>
        </c:if>

        <!-- 답변 작성 폼 -->
        <form id="bbsAnsForm" enctype="multipart/form-data">
          <input type="hidden" name="brdCd" value="${brdCd}" />
          <input type="hidden" name="rotPstCd" value="${parentPst.pstCd}" />
          <input type="hidden" name="uprPstCd" value="${parentPst.pstCd}" />
          <input type="hidden" name="pstLvl" value="1" />
          <input type="hidden" name="pstCnts" id="pstCntsHidden" />
          <c:if test="${not empty ansPst}">
            <input type="hidden" name="pstCd" value="${ansPst.pstCd}" />
          </c:if>

          <table class="bbsWrite-formTable qnaAns-formTable">
            <colgroup><col style="width:120px;"><col></colgroup>
            <tbody>
              <tr>
                <th>제목</th>
                <td>
                  <input type="hidden" name="pstNm" id="pstNm" value="Re: ${parentPst.pstNm}" />
                  <span style="font-size:15px; color:#333;">Re: ${parentPst.pstNm}</span>
                </td>
              </tr>
              <tr>
                <th>내용</th>
                <td>
                  <c:if test="${not empty ansPst}">
                    <textarea id="initCnts" style="display:none;"><c:out value="${ansPst.pstCnts}" escapeXml="true"/></textarea>
                  </c:if>
                  <textarea id="summernote"></textarea>
                </td>
              </tr>
              <c:if test="${fn:contains(brd.brdPropBinary, 'F')}">
                <tr>
                  <th>첨부파일</th>
                  <td>
                    <c:if test="${not empty ansFileList}">
                      <div class="bbsWrite-existFiles" id="existFileWrap">
                        <c:forEach var="file" items="${ansFileList}">
                          <div class="bbsWrite-fileRow">
                            <a href="${ctx}/file/download?upldFileCd=${file.upldFileCd}&fileSeq=${file.fileSeq}">
                              <i class="bi bi-paperclip"></i> ${file.fileNm}
                            </a>
                            <button type="button" class="bbsWrite-fileRemove" onclick="fnRemoveExistFile(this)">삭제</button>
                            <button type="button" class="bbsWrite-fileRestore" onclick="fnRestoreExistFile(this)" style="display:none;">취소</button>
                            <input type="hidden" class="deleteFileInput" disabled name="deleteFiles" value="${file.upldFileCd}:${file.fileSeq}" />
                          </div>
                        </c:forEach>
                      </div>
                    </c:if>
                    <div class="bbsWrite-fileWrap" id="fileWrap">
                      <div class="bbsWrite-fileRow"><input type="file" name="atchFile" /><button type="button" class="bbsWrite-fileRemove" onclick="fnRemoveFile(this)">삭제</button></div>
                    </div>
                    <button type="button" class="bbsWrite-fileAdd" onclick="fnAddFile()">+ 파일추가</button>
                  </td>
                </tr>
              </c:if>
            </tbody>
          </table>
        </form>

        <!-- 버튼 -->
        <div class="qnaDetail-btnRow">
          <button type="button" class="qnaDetail-btn qnaDetail-btn--list" onclick="fnCancel()">취소</button>
          <button type="button" class="qnaDetail-btn qnaDetail-btn--dark" onclick="fnSaveAns()">${not empty ansPst ? '답변 수정' : '답변 등록'}</button>
        </div>

        <form id="goDetailForm" action="${ctx}/bbs/viewBbsDetailQna" method="post">
          <input type="hidden" name="brdCd" value="${brdCd}" />
          <input type="hidden" name="pstCd" value="${parentPst.pstCd}" />
          <input type="hidden" name="pageNo" value="${pageNo}" />
        </form>

      </div><!-- /qnaDetail -->
    </div><!-- /lnb-content -->
  </div><!-- /lnb-layout -->

</main><!-- End #main -->


<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>

<script>
  const editor = EDIT.Summernote.init({ el: '#summernote', ctx: '${ctx}', <c:if test="${not empty ansPst}">initSelector: '#initCnts',</c:if> height: 400 });
  var _isEditMode = ${not empty ansPst ? 'true' : 'false'};

  function fnAddFile() {
    var row = '<div class="bbsWrite-fileRow"><input type="file" name="atchFile" /><button type="button" class="bbsWrite-fileRemove" onclick="fnRemoveFile(this)">삭제</button></div>';
    $('#fileWrap').append(row);
  }
  function fnRemoveFile(btn) {
    if ($('#fileWrap .bbsWrite-fileRow').length > 1) { $(btn).closest('.bbsWrite-fileRow').remove(); } else { $(btn).siblings('input[type="file"]').val(''); }
  }
  function fnRemoveExistFile(btn) {
    var $row = $(btn).closest('.bbsWrite-fileRow');
    $row.addClass('bbsWrite-fileRow--deleted');
    $row.find('.deleteFileInput').prop('disabled', false);
    $(btn).hide(); $row.find('.bbsWrite-fileRestore').show();
  }
  function fnRestoreExistFile(btn) {
    var $row = $(btn).closest('.bbsWrite-fileRow');
    $row.removeClass('bbsWrite-fileRow--deleted');
    $row.find('.deleteFileInput').prop('disabled', true);
    $(btn).hide(); $row.find('.bbsWrite-fileRemove').show();
  }
  function fnSaveAns() {
    if (!EDIT.Summernote.validateRequired(editor, '#bbsAnsForm')) { alert('내용을 입력해 주세요.'); editor.focus(); return; }
    var pstCnts = editor.getHTML();
    $('#pstCntsHidden').val(pstCnts);
    var res = ajaxFormCall("${ctx}/bbs/saveBbsPst", "#bbsAnsForm", false);
    if (res && res.result === 'OK') { alert(_isEditMode ? '답변이 수정되었습니다.' : '답변이 등록되었습니다.'); $('#goDetailForm').submit(); }
    else { alert('저장 실패: ' + (res && (res.message || res.msg) ? (res.message || res.msg) : 'unknown')); }
  }
  function fnCancel() { $('#goDetailForm').submit(); }
</script>
