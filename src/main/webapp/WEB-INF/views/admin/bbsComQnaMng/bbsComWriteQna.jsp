<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<!-- Content Wrapper -->
<div class="content-wrapper">

  <!-- Content Header -->
  <div class="content-header">
    <div class="container">
      <div class="row mb-2">
        <div class="col-sm-6">
          <h4>문의게시판</h4>
        </div>
        <div class="col-sm-6">
          <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item active">고객지원</li>
            <li class="breadcrumb-item"><a href="${ctx}/bbs/viewBbsQna">문의게시판</a></li>
          </ol>
        </div>
      </div>
    </div>
  </div>

  <!-- Main content -->
  <section class="content">
    <div class="container">

      <!-- ===== 질문 영역 (읽기전용) ===== -->
      <div class="card">
        <div class="card-header"><h5 class="mb-0"><span class="badge bg-info text-white mr-2">Q</span> 문의내용</h5></div>
        <div class="card-body">
          <table class="table table-bordered">
            <colgroup><col style="width:120px;"><col></colgroup>
            <tbody>
              <tr>
                <th class="bg-light">성명</th>
                <td>${qst.rgtUsrNm}</td>
              </tr>
              <tr>
                <th class="bg-light">연락처</th>
                <td>${qst.rgtPhone}</td>
              </tr>
              <tr>
                <th class="bg-light">이메일</th>
                <td><c:out value="${qst.rgtEmail}" default="-" /></td>
              </tr>
              <tr>
                <th class="bg-light">제목</th>
                <td>${qst.pstNm}</td>
              </tr>
              <tr>
                <th class="bg-light">등록일시</th>
                <td>${qst.rgtDtm}</td>
              </tr>
              <tr>
                <th class="bg-light">조회수</th>
                <td>${qst.viewCnt}</td>
              </tr>
              <tr>
                <th class="bg-light">문의사항</th>
                <td><div style="min-height:60px; white-space:pre-wrap;"><c:out value="${qst.pstCnts}" escapeXml="false" /></div></td>
              </tr>
              <c:if test="${not empty qstFileList}">
              <tr>
                <th class="bg-light">첨부파일</th>
                <td>
                  <c:forEach var="file" items="${qstFileList}">
                    <div class="mb-1">
                      <a href="${ctx}/file/download?upldFileCd=${file.upldFileCd}&fileSeq=${file.fileSeq}">
                        <i class="fas fa-paperclip"></i> ${file.fileNm}
                      </a>
                    </div>
                  </c:forEach>
                </td>
              </tr>
              </c:if>
            </tbody>
          </table>
        </div>
      </div>

      <!-- ===== 답변 영역 (입력/수정) ===== -->
      <div class="card mt-3">
        <div class="card-header">
          <div class="row align-items-center">
            <div class="col"><h5 class="mb-0"><span class="badge bg-success text-white mr-2">A</span> 답변</h5></div>
            <div class="col-auto">
              <div class="d-flex bo-actionbar">
                <button type="button" class="btn btn-sm btn-bo-save" onclick="fnSaveAns()">${not empty ans ? '답변 수정' : '답변 등록'}</button>
                <button type="button" class="btn btn-sm btn-bo-reset" onclick="fnGoList()">목록</button>
              </div>
            </div>
          </div>
        </div>
        <div class="card-body">
          <form id="bbsAnsForm" enctype="multipart/form-data">
            <input type="hidden" name="brdCd" value="${brdCd}" />
            <input type="hidden" name="rotPstCd" value="${qst.pstCd}" />
            <input type="hidden" name="uprPstCd" value="${qst.pstCd}" />
            <input type="hidden" name="pstLvl" value="1" />
            <input type="hidden" name="pstCnts" id="pstCntsHidden" />
            <c:if test="${not empty ans}">
              <input type="hidden" name="pstCd" value="${ans.pstCd}" />
            </c:if>

            <table class="table table-bordered">
              <colgroup><col style="width:120px;"><col></colgroup>
              <tbody>
                <tr>
                  <th class="bg-light">제목</th>
                  <td>
                    <input type="hidden" name="pstNm" id="pstNm" value="Re: ${qst.pstNm}" />
                    <span style="font-size:14px; color:#333;">Re: ${qst.pstNm}</span>
                  </td>
                </tr>
                <tr>
                  <th class="bg-light">내용</th>
                  <td>
                    <c:if test="${not empty ans}">
                      <textarea id="initCnts" style="display:none;"><c:out value="${ans.pstCnts}" escapeXml="true"/></textarea>
                    </c:if>
                    <textarea id="summernote"></textarea>
                  </td>
                </tr>
                <c:if test="${fn:contains(brd.brdPropBinary, 'F')}">
                <tr>
                  <th class="bg-light">첨부파일</th>
                  <td>
                    <!-- 기존 답변 첨부파일 -->
                    <c:if test="${not empty ans.fileList}">
                      <div id="existFileWrap" style="margin-bottom:8px;">
                        <c:forEach var="file" items="${ans.fileList}">
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
<form id="goListForm" action="${ctx}/bbsComQnaMng/viewBbsComQnaMng" method="post"></form>

<script>
  const editor = EDIT.Summernote.init({
    el: '#summernote',
    ctx: '${ctx}',
    <c:if test="${not empty ans}">initSelector: '#initCnts',</c:if>
    height: 350
  });

  /* 파일 추가 */
  function fnAddFile() {
    var row = '<div class="d-flex align-items-center mb-1">'
            + '  <input type="file" name="atchFile" class="form-control-file" style="width:auto;" />'
            + '  <button type="button" class="btn btn-xs btn-bo-reset ml-2" onclick="fnRemoveFile(this)">삭제</button>'
            + '</div>';
    $('#fileWrap').append(row);
  }
  function fnRemoveFile(btn) {
    if ($('#fileWrap > div').length > 1) { $(btn).closest('div').remove(); }
    else { $(btn).siblings('input[type="file"]').val(''); }
  }
  function fnRemoveExistFile(btn) {
    var $row = $(btn).closest('div[data-upld-file-cd]');
    $row.find('a').css({'text-decoration':'line-through','color':'#999'});
    $(btn).hide(); $row.find('[onclick*="fnRestoreExistFile"]').show();
    var key = $row.data('upld-file-cd') + ':' + $row.data('file-seq');
    $('#bbsAnsForm').append('<input type="hidden" name="deleteFiles" class="deleteFileInput" value="' + key + '" />');
  }
  function fnRestoreExistFile(btn) {
    var $row = $(btn).closest('div[data-upld-file-cd]');
    $row.find('a').css({'text-decoration':'','color':''});
    $(btn).hide(); $row.find('[onclick*="fnRemoveExistFile"]').show();
    var key = $row.data('upld-file-cd') + ':' + $row.data('file-seq');
    $('#bbsAnsForm .deleteFileInput').filter(function(){ return $(this).val() === key; }).remove();
  }

  /* 답변 저장 */
  function fnSaveAns() {
    if (!EDIT.Summernote.validateRequired(editor, '#bbsAnsForm')) {
      alert('답변 내용을 입력해 주세요.'); editor.focus(); return;
    }
    $('#pstCntsHidden').val(editor.getHTML());

    var res = ajaxFormCall("${ctx}/bbs/saveBbsPst", "#bbsAnsForm", false);
    if (res && res.result === 'OK') {
      alert('${not empty ans ? "답변이 수정되었습니다." : "답변이 등록되었습니다."}');
      // 새로고침 (답변 등록 후 수정 모드로)
      var form = $('<form method="post" action="${ctx}/bbsComQnaMng/viewBbsComWriteQna"></form>');
      form.append('<input name="brdCd" value="${brdCd}" />');
      form.append('<input name="pstCd" value="${qst.pstCd}" />');
      form.appendTo('body').submit();
    } else {
      alert('저장 실패: ' + (res && (res.message || res.msg) ? (res.message || res.msg) : 'unknown'));
    }
  }

  function fnGoList() { $('#goListForm').submit(); }
</script>
