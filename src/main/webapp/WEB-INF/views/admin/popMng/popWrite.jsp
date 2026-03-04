<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<style>
  .pop-size-group { display:flex; align-items:center; gap:8px; }
  .pop-size-group input { width:100px; }
</style>

<!-- Content Wrapper -->
<div class="content-wrapper">

  <!-- Content Header -->
  <div class="content-header">
    <div class="container">
      <div class="row mb-2">
        <div class="col-sm-6">
          <h4>팝업관리 - <c:choose><c:when test="${not empty detail}">수정</c:when><c:otherwise>등록</c:otherwise></c:choose></h4>
        </div>
        <div class="col-sm-6">
          <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item active">시스템관리</li>
            <li class="breadcrumb-item"><a href="${ctx}/popMng/viewPopMng">팝업관리</a></li>
          </ol>
        </div>
      </div>
    </div>
  </div>

  <!-- Main content -->
  <section class="content">
    <div class="container">
      <div class="card">

        <div class="card-header">
          <div class="row align-items-center">
            <div class="col"></div>
            <div class="col-12 col-lg-auto">
              <div class="d-flex justify-content-lg-end bo-actionbar">
                <button type="button" class="btn btn-sm btn-bo-save" onclick="fnSave()">저장</button>
                <c:if test="${not empty detail}">
                  <button type="button" class="btn btn-sm btn-bo-delete" onclick="fnDelete()">삭제</button>
                  <button type="button" class="btn btn-sm btn-dark" onclick="fnPreview()">미리보기</button>
                </c:if>
                <button type="button" class="btn btn-sm btn-bo-reset" onclick="fnGoList()">목록</button>
              </div>
            </div>
          </div>
        </div>

        <div class="card-body">
          <form id="popForm">
            <input type="hidden" name="popCd" id="popCd" value="${detail.popCd}" />
            <input type="hidden" name="popCnts" id="popCnts" />

            <table class="table table-bordered">
              <colgroup><col style="width:140px;"><col></colgroup>
              <tbody>
                <!-- 팝업코드 -->
                <tr>
                  <th class="bg-light">팝업코드</th>
                  <td>
                    <c:choose>
                      <c:when test="${not empty detail}">
                        <span style="font-size:14px; color:#333; font-family:monospace;">${detail.popCd}</span>
                      </c:when>
                      <c:otherwise>
                        <span style="font-size:14px; color:#999;">(저장 시 자동생성)</span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                </tr>
                <!-- 팝업명 -->
                <tr>
                  <th class="bg-light">팝업명 <span class="text-danger">*</span></th>
                  <td>
                    <input type="text" name="popNm" id="popNm" class="form-control" value="${detail.popNm}" maxlength="200" />
                  </td>
                </tr>
                <!-- 게시기간 -->
                <tr>
                  <th class="bg-light">게시기간 <span class="text-danger">*</span></th>
                  <td>
                    <div class="pop-size-group">
                      <input type="date" name="openStartDtView" id="openStartDtView" class="form-control form-control-sm" style="width:170px;" />
                      <span>~</span>
                      <input type="date" name="openEndDtView" id="openEndDtView" class="form-control form-control-sm" style="width:170px;" />
                    </div>
                    <input type="hidden" name="openStartDt" id="openStartDt" value="${detail.openStartDt}" />
                    <input type="hidden" name="openEndDt" id="openEndDt" value="${detail.openEndDt}" />
                  </td>
                </tr>
                <!-- 팝업 크기 -->
                <tr>
                  <th class="bg-light">팝업 크기(px)</th>
                  <td>
                    <div class="pop-size-group">
                      <span>가로</span>
                      <input type="text" name="popWidth" id="popWidth" class="form-control form-control-sm" value="${detail.popWidth}" maxlength="10" />
                      <span>×</span>
                      <span>세로</span>
                      <input type="text" name="popHgt" id="popHgt" class="form-control form-control-sm" value="${detail.popHgt}" maxlength="10" />
                    </div>
                  </td>
                </tr>
                <!-- 팝업 위치 -->
                <tr>
                  <th class="bg-light">팝업 위치(px)</th>
                  <td>
                    <div class="pop-size-group">
                      <span>X</span>
                      <input type="text" name="popXLoc" id="popXLoc" class="form-control form-control-sm" value="${detail.popXLoc}" maxlength="10" />
                      <span>Y</span>
                      <input type="text" name="popYLoc" id="popYLoc" class="form-control form-control-sm" value="${detail.popYLoc}" maxlength="10" />
                    </div>
                  </td>
                </tr>
                <!-- 시스템구분 (사용자 고정) -->
                <input type="hidden" name="menuSysDiv" value="F" />
                <!-- 사용여부 -->
                <tr>
                  <th class="bg-light">사용여부</th>
                  <td>
                    <label><input type="radio" name="useYn" value="Y" <c:if test="${empty detail or detail.useYn eq 'Y'}">checked</c:if> /> 사용</label>
                    <label class="ml-3"><input type="radio" name="useYn" value="N" <c:if test="${detail.useYn eq 'N'}">checked</c:if> /> 미사용</label>
                  </td>
                </tr>
                <!-- 팝업 내용 (에디터) -->
                <tr>
                  <th class="bg-light">팝업 내용</th>
                  <td>
                    <textarea id="summernote"></textarea>
                    <textarea id="initCnts" style="display:none;">${detail.popCnts}</textarea>
                  </td>
                </tr>
              </tbody>
            </table>
          </form>
        </div>

      </div>
    </div>
  </section>
</div>

<!-- 목록 이동용 -->
<form id="goListForm" action="${ctx}/popMng/viewPopMng" method="post"></form>

<script>
var snEditor = null;

$(function() {
  // Summernote 초기화 (공통 모듈)
  snEditor = EDIT.Summernote.init({
    el: '#summernote',
    ctx: '${ctx}',
    initSelector: '#initCnts',
    height: 400
  });

  // 게시기간 date ↔ hidden 연동
  fnInitDateFields();
});

/* 날짜 필드 초기화 */
function fnInitDateFields() {
  var startDt = '${detail.openStartDt}' || '';
  var endDt = '${detail.openEndDt}' || '';
  if (startDt.length === 8) {
    $('#openStartDtView').val(startDt.substring(0,4) + '-' + startDt.substring(4,6) + '-' + startDt.substring(6,8));
  }
  if (endDt.length === 8) {
    $('#openEndDtView').val(endDt.substring(0,4) + '-' + endDt.substring(4,6) + '-' + endDt.substring(6,8));
  }
}

/* date → hidden YYYYMMDD 변환 */
function fnSyncDate() {
  var s = $('#openStartDtView').val().replace(/-/g, '');
  var e = $('#openEndDtView').val().replace(/-/g, '');
  $('#openStartDt').val(s);
  $('#openEndDt').val(e);
}

/* 저장 */
function fnSave() {
  if (!$('#popNm').val().trim()) { alert('팝업명을 입력해 주세요.'); $('#popNm').focus(); return; }
  if (!$('#openStartDtView').val() || !$('#openEndDtView').val()) { alert('게시기간을 입력해 주세요.'); return; }

  fnSyncDate();

  $('#popCnts').val(snEditor.getData());

  var res = ajaxFormCall("${ctx}/popMng/savePop", "#popForm", false);
  if (res && res.result === 'OK') {
    alert('저장되었습니다.');
    if (!$('#popCd').val() && res.popCd) {
      $('#popCd').val(res.popCd);
      location.href = '${ctx}/popMng/viewPopWrite?popCd=' + res.popCd;
    }
  } else {
    alert('저장 실패: ' + (res && (res.message || res.msg) ? (res.message || res.msg) : 'unknown'));
  }
}

/* 삭제 */
function fnDelete() {
  if (!confirm('이 팝업을 삭제하시겠습니까?')) return;
  var res = ajaxCall("${ctx}/popMng/deletePop", { popCd: '${detail.popCd}' }, false);
  if (res && res.result === 'OK') {
    alert('삭제되었습니다.');
    fnGoList();
  } else {
    alert('삭제 실패');
  }
}

/* 미리보기 */
function fnPreview() {
  var w = parseInt($('#popWidth').val()) || 500;
  var h = parseInt($('#popHgt').val()) || 400;
  var x = parseInt($('#popXLoc').val()) || 100;
  var y = parseInt($('#popYLoc').val()) || 100;
  var html = snEditor.getData();
  var title = $('#popNm').val() || '팝업 미리보기';

  var popup = window.open('', '_blank', 'width=' + w + ',height=' + h + ',left=' + x + ',top=' + y + ',scrollbars=yes');
  popup.document.write(fnBuildPopupHtml(title, html));
  popup.document.close();
}

/* 목록 */
function fnGoList() {
  $('#goListForm').submit();
}

/* 팝업 미리보기 공통 HTML */
function fnBuildPopupHtml(title, content) {
  return '<!DOCTYPE html><html><head><meta charset="UTF-8"><title>' + title + '</title>'
    + '<style>'
    + '* { margin:0; padding:0; box-sizing:border-box; }'
    + 'html, body { height:100%; font-family:"Pretendard","Noto Sans KR","맑은 고딕",sans-serif; }'
    + 'body { display:flex; flex-direction:column; background:#f4f5f7; }'
    + '.pop-body { flex:1; overflow-y:auto; padding:28px 24px 20px; }'
    + '.pop-body img { max-width:100%; height:auto; }'
    + '.pop-footer { display:flex; align-items:center; justify-content:space-between; padding:10px 16px; background:#fff; border-top:1px solid #e0e0e0; font-size:13px; color:#666; }'
    + '.pop-footer label { cursor:pointer; display:flex; align-items:center; gap:6px; }'
    + '.pop-footer input[type=checkbox] { width:15px; height:15px; accent-color:#555; }'
    + '.pop-close { padding:6px 20px; font-size:13px; font-weight:500; color:#fff; background:#333; border:none; border-radius:4px; cursor:pointer; }'
    + '.pop-close:hover { background:#555; }'
    + '</style></head>'
    + '<body>'
    + '<div class="pop-body">' + content + '</div>'
    + '<div class="pop-footer">'
    + '  <label><input type="checkbox" /> 오늘 하루 보지 않기</label>'
    + '  <button class="pop-close" onclick="window.close()">닫기</button>'
    + '</div>'
    + '</body></html>';
}
</script>
