<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<!-- Content Wrapper -->
<div class="content-wrapper">

  <!-- Content Header -->
  <div class="content-header">
    <div class="container">
      <div class="row mb-2">
        <div class="col-sm-6">
          <h4>${brd.brdNm} - <c:choose><c:when test="${not empty pst}">수정</c:when><c:otherwise>등록</c:otherwise></c:choose></h4>
        </div>
        <div class="col-sm-6">
          <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item active">${menuNm}</li>
            <li class="breadcrumb-item">${brd.brdNm}</li>
          </ol>
        </div>
      </div>
    </div>
  </div>

  <!-- Main content -->
  <section class="content">
    <div class="container">
      <div class="card">

        <!-- 카드 헤더 -->
        <div class="card-header">
          <div class="row align-items-center">
            <div class="col-12 col-lg mb-2 mb-lg-0"></div>
            <div class="col-12 col-lg-auto">
              <div class="d-flex justify-content-lg-end bo-actionbar">
                <button type="button" class="btn btn-sm btn-bo-save" onclick="fnSave()">저장</button>
                <button type="button" class="btn btn-sm btn-bo-reset" onclick="fnGoList()">목록</button>
              </div>
            </div>
          </div>
        </div>

        <!-- 카드 바디 -->
        <div class="card-body">
          <form id="bbsWriteForm" enctype="multipart/form-data">
            <input type="hidden" name="brdCd" value="${brdCd}" />
            <input type="hidden" name="pstCd" value="${pst.pstCd}" />
            <input type="hidden" name="pstCnts" id="pstCntsHidden" />

            <table class="table table-bordered">
              <colgroup>
                <col style="width:120px;">
                <col>
              </colgroup>
              <tbody>
                <!-- 제목 -->
                <tr>
                  <th class="bg-light">제목</th>
                  <td>
                    <input type="text" name="pstNm" class="form-control" placeholder="제목을 입력해 주세요." value="${pst.pstNm}" />
                  </td>
                </tr>
                <!-- 등록구분 -->
                <c:if test="${fn:contains(brd.brdPropBinary, 'A')}">
                  <tr>
                    <th class="bg-light">등록구분</th>
                    <td>
                      <label><input type="radio" name="noticeYn" value="N" checked /> 일반</label>
                      <label style="margin-left:16px;"><input type="radio" name="noticeYn" value="Y"
                        <c:if test="${pst.noticeYn eq 'Y'}">checked</c:if>
                      /> 공지</label>
                    </td>
                  </tr>
                </c:if>
                <!-- 내용 -->
                <tr>
                  <th class="bg-light">내용</th>
                  <td>
                    <textarea id="initCnts" style="display:none;"><c:out value="${pst.pstCnts}" escapeXml="true"/></textarea>
                    <textarea id="summernote"></textarea>
                  </td>
                </tr>
                <!-- 첨부파일 -->
                <c:if test="${fn:contains(brd.brdPropBinary, 'F')}">
                  <tr>
                    <th class="bg-light">첨부파일</th>
                    <td>
                      <!-- 기존 파일 -->
                      <c:if test="${not empty fileList}">
                        <div id="existFileWrap" style="margin-bottom:8px;">
                          <c:forEach var="file" items="${fileList}">
                            <div class="d-flex align-items-center mb-1" data-upld-file-cd="${file.upldFileCd}" data-file-seq="${file.fileSeq}">
                              <a href="${ctx}/file/download?upldFileCd=${file.upldFileCd}&fileSeq=${file.fileSeq}">
                                <i class="fas fa-paperclip"></i> ${file.fileNm}
                              </a>
                              <button type="button" class="btn btn-xs btn-bo-reset ml-2" onclick="fnRemoveExistFile(this)">삭제</button>
                              <button type="button" class="btn btn-xs btn-bo-reset ml-2" onclick="fnRestoreExistFile(this)" style="display:none;">취소</button>
                            </div>
                          </c:forEach>
                        </div>
                      </c:if>
                      <!-- 신규 파일 -->
                      <div id="fileWrap">
                        <div class="d-flex align-items-center mb-1">
                          <input type="file" name="atchFile" class="form-control-file" style="width:auto;" />
                          <button type="button" class="btn btn-xs btn-bo-reset ml-2" onclick="fnRemoveFile(this)">삭제</button>
                        </div>
                      </div>
                      <button type="button" class="btn btn-xs btn-bo-add" onclick="fnAddFile()">+ 파일추가</button>
                    </td>
                  </tr>
                </c:if>
              </tbody>
            </table>
          </form>
        </div>

      </div>
    </div>
  </section>
</div>

<!-- 목록 이동용 -->
<form id="goListForm" action="${ctx}/bbsComMng/viewBbsComMng" method="post">
  <input type="hidden" name="brdCd" value="${brdCd}" />
</form>

<script>
  const editor = EDIT.Summernote.init({
    el: '#summernote',
    ctx: '${ctx}',
    initSelector: '#initCnts',
    height: 400
  });

  /* 파일 추가 */
  function fnAddFile() {
    var row = '<div class="d-flex align-items-center mb-1">'
            + '  <input type="file" name="atchFile" class="form-control-file" style="width:auto;" />'
            + '  <button type="button" class="btn btn-xs btn-bo-reset ml-2" onclick="fnRemoveFile(this)">삭제</button>'
            + '</div>';
    $('#fileWrap').append(row);
  }

  /* 신규 파일 삭제 */
  function fnRemoveFile(btn) {
    if ($('#fileWrap > div').length > 1) {
      $(btn).closest('div').remove();
    } else {
      $(btn).siblings('input[type="file"]').val('');
    }
  }

  /* 기존 첨부파일 삭제 (지연 삭제 - 저장 시 실제 삭제) */
  function fnRemoveExistFile(btn) {
    var $row = $(btn).closest('div[data-upld-file-cd]');
    $row.addClass('file-deleted');
    $row.find('a').css({'text-decoration':'line-through', 'color':'#999'});
    $(btn).hide();
    $row.find('[onclick*="fnRestoreExistFile"]').show();

    var key = $row.data('upld-file-cd') + ':' + $row.data('file-seq');
    $('#bbsWriteForm').append('<input type="hidden" name="deleteFiles" class="deleteFileInput" value="' + key + '" />');
  }

  /* 기존 첨부파일 복원 */
  function fnRestoreExistFile(btn) {
    var $row = $(btn).closest('div[data-upld-file-cd]');
    $row.removeClass('file-deleted');
    $row.find('a').css({'text-decoration':'', 'color':''});
    $(btn).hide();
    $row.find('[onclick*="fnRemoveExistFile"]').show();

    var key = $row.data('upld-file-cd') + ':' + $row.data('file-seq');
    $('#bbsWriteForm .deleteFileInput').filter(function(){ return $(this).val() === key; }).remove();
  }

  /* 저장 */
  function fnSave() {
    var pstNm = $('input[name="pstNm"]').val().trim();
    if (!pstNm) { alert('제목을 입력해 주세요.'); $('input[name="pstNm"]').focus(); return; }

    if (!EDIT.Summernote.validateRequired(editor, '#bbsWriteForm')) {
      alert('내용을 입력해 주세요.');
      editor.focus();
      return;
    }

    var pstCnts = editor.getHTML();
    $('#pstCntsHidden').val(pstCnts);

    var res = ajaxFormCall("${ctx}/bbsComMng/saveBbsPst", "#bbsWriteForm", false);
    if (res && res.result === 'OK') {
      alert('저장되었습니다.');
      fnGoList();
    } else {
      alert('저장 실패: ' + (res && (res.message || res.msg) ? (res.message || res.msg) : 'unknown'));
    }
  }

  /* 목록으로 */
  function fnGoList() {
    $('#goListForm').submit();
  }
</script>
