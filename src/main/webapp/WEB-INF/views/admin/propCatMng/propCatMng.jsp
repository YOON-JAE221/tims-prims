<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<style>
  .cat-wrap { display: flex; gap: 16px; }
  .cat-left { flex: 0 0 380px; }
  .cat-right { flex: 1; min-width: 0; }
  .cat-panel { background: #fff; border: 1px solid #dee2e6; border-radius: 4px; }
  .cat-panel-header {
    display: flex; justify-content: space-between; align-items: center;
    padding: 12px 16px; border-bottom: 1px solid #dee2e6; background: #f8f9fa;
    font-weight: 700; font-size: 14px;
  }
  .cat-panel-body { padding: 0; }

  /* 대분류 리스트 */
  .cat-item {
    display: flex; align-items: center; padding: 10px 16px;
    border-bottom: 1px solid #f0f0f0; cursor: pointer; transition: background 0.15s;
    font-size: 13px;
  }
  .cat-item:hover { background: #f8f9fa; }
  .cat-item.active { background: #e8f4fd; border-left: 3px solid #1B2A4A; }
  .cat-item-info { flex: 1; }
  .cat-item-nm { font-weight: 700; color: #1B2A4A; }
  .cat-item-cd { font-size: 11px; color: #999; font-family: monospace; margin-left: 6px; }
  .cat-item-cnt {
    background: #E8830C; color: #fff; border-radius: 10px;
    padding: 1px 8px; font-size: 11px; font-weight: 700; margin-right: 8px;
  }
  .cat-item-badge {
    padding: 2px 8px; border-radius: 3px; font-size: 11px; font-weight: 600;
  }
  .cat-item-badge.y { background: #d4edda; color: #155724; }
  .cat-item-badge.n { background: #f8d7da; color: #721c24; }
  .cat-item-actions { display: flex; gap: 4px; margin-left: 8px; }
  .cat-item-actions button {
    border: none; background: none; cursor: pointer; font-size: 13px; padding: 2px 4px;
    color: #999; transition: color 0.15s;
  }
  .cat-item-actions button:hover { color: #333; }

  /* 소분류 테이블 */
  .sub-table { width: 100%; font-size: 13px; }
  .sub-table th {
    background: #f8f9fa; padding: 8px 12px; border-bottom: 2px solid #dee2e6;
    font-weight: 600; text-align: center; font-size: 12px; color: #555;
  }
  .sub-table td { padding: 8px 12px; border-bottom: 1px solid #f0f0f0; vertical-align: middle; }
  .sub-table tr:hover { background: #fafbfc; }
  .sub-table .td-center { text-align: center; }
  .sub-table .td-mono { font-family: monospace; text-align: center; color: #666; }

  .sub-empty { padding: 40px; text-align: center; color: #999; font-size: 13px; }

  /* 입력 모달 */
  .cat-modal-bg {
    display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0;
    background: rgba(0,0,0,0.4); z-index: 1050; align-items: center; justify-content: center;
  }
  .cat-modal-bg.show { display: flex; }
  .cat-modal {
    background: #fff; border-radius: 8px; width: 420px; max-width: 90%;
    box-shadow: 0 12px 40px rgba(0,0,0,0.2);
  }
  .cat-modal-header {
    padding: 16px 20px; border-bottom: 1px solid #dee2e6;
    font-size: 15px; font-weight: 700; color: #1B2A4A;
  }
  .cat-modal-body { padding: 20px; }
  .cat-modal-footer {
    padding: 12px 20px; border-top: 1px solid #dee2e6;
    display: flex; justify-content: flex-end; gap: 8px;
  }
  .cat-modal-body .form-group { margin-bottom: 14px; }
  .cat-modal-body label { font-size: 13px; font-weight: 600; margin-bottom: 4px; display: block; }

  @media (max-width: 768px) {
    .cat-wrap { flex-direction: column; }
    .cat-left { flex: none; width: 100%; }
  }
</style>

<div class="content-wrapper">

  <div class="content-header">
    <div class="container">
      <div class="row mb-2">
        <div class="col-sm-6"><h4>매물코드관리</h4></div>
        <div class="col-sm-6">
          <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item active">매물관리</li>
            <li class="breadcrumb-item">매물코드관리</li>
          </ol>
        </div>
      </div>
    </div>
  </div>

  <section class="content">
    <div class="container">
      <div class="cat-wrap">

        <!-- ===== 좌측: 대분류 ===== -->
        <div class="cat-left">
          <div class="cat-panel">
            <div class="cat-panel-header">
              대분류
              <button class="btn btn-sm btn-bo-save" onclick="fnOpenCatModal()">+ 추가</button>
            </div>
            <div class="cat-panel-body" id="catListArea">
              <c:forEach var="cat" items="${catList}">
                <div class="cat-item" data-cd="${cat.CAT_CD}" onclick="fnSelectCat('${cat.CAT_CD}', this)">
                  <div class="cat-item-info">
                    <span class="cat-item-nm">${cat.CAT_NM}</span>
                    <span class="cat-item-cd">${cat.CAT_CD}</span>
                  </div>
                  <span class="cat-item-cnt">${cat.SUB_CNT}</span>
                  <span class="cat-item-badge ${cat.USE_YN eq 'Y' ? 'y' : 'n'}">${cat.USE_YN eq 'Y' ? '사용' : '미사용'}</span>
                  <div class="cat-item-actions">
                    <button onclick="event.stopPropagation(); fnOpenCatModal('${cat.CAT_CD}','${cat.CAT_NM}',${cat.SORT_ORDER},'${cat.USE_YN}')" title="수정">✏</button>
                    <button onclick="event.stopPropagation(); fnDeleteCat('${cat.CAT_CD}','${cat.CAT_NM}')" title="삭제">🗑</button>
                  </div>
                </div>
              </c:forEach>
              <c:if test="${empty catList}">
                <div class="sub-empty">등록된 대분류가 없습니다.</div>
              </c:if>
            </div>
          </div>
        </div>

        <!-- ===== 우측: 소분류 ===== -->
        <div class="cat-right">
          <div class="cat-panel">
            <div class="cat-panel-header">
              <span id="subTitle">소분류 (대분류를 선택해주세요)</span>
              <button class="btn btn-sm btn-bo-save" id="btnAddSub" onclick="fnOpenSubModal()" style="display:none;">+ 추가</button>
            </div>
            <div class="cat-panel-body" id="subListArea">
              <div class="sub-empty">좌측에서 대분류를 선택하면 소분류 목록이 표시됩니다.</div>
            </div>
          </div>
        </div>

      </div>
    </div>
  </section>

</div>

<!-- ===== 대분류 모달 ===== -->
<div class="cat-modal-bg" id="catModal">
  <div class="cat-modal">
    <div class="cat-modal-header" id="catModalTitle">대분류 등록</div>
    <div class="cat-modal-body">
      <input type="hidden" id="catModalMode" value="new" />
      <div class="form-group">
        <label>대분류코드 <span class="text-danger">*</span></label>
        <input type="text" id="catCd" class="form-control" maxlength="20" placeholder="영문 대문자 (예: APT)" style="text-transform:uppercase;" />
        <small class="text-muted">영문 대문자, 수정 시 변경 불가</small>
      </div>
      <div class="form-group">
        <label>분류명 <span class="text-danger">*</span></label>
        <input type="text" id="catNm" class="form-control" maxlength="50" placeholder="예: 아파트" />
      </div>
      <div class="form-group">
        <label>정렬순서</label>
        <input type="number" id="catSortOrder" class="form-control" value="0" min="0" style="width:100px;" />
      </div>
      <div class="form-group">
        <label>사용여부</label>
        <select id="catUseYn" class="form-control" style="width:100px;">
          <option value="Y">사용</option>
          <option value="N">미사용</option>
        </select>
      </div>
    </div>
    <div class="cat-modal-footer">
      <button class="btn btn-secondary btn-sm" onclick="fnCloseCatModal()">취소</button>
      <button class="btn btn-bo-save btn-sm" onclick="fnSaveCat()">저장</button>
    </div>
  </div>
</div>

<!-- ===== 소분류 모달 ===== -->
<div class="cat-modal-bg" id="subModal">
  <div class="cat-modal">
    <div class="cat-modal-header" id="subModalTitle">소분류 등록</div>
    <div class="cat-modal-body">
      <input type="hidden" id="subModalMode" value="new" />
      <input type="hidden" id="subCatCd" />
      <div class="form-group">
        <label>대분류</label>
        <input type="text" id="subParentNm" class="form-control" readonly style="background:#f5f5f5;" />
      </div>
      <div class="form-group">
        <label>소분류명 <span class="text-danger">*</span></label>
        <input type="text" id="subCatNm" class="form-control" maxlength="50" placeholder="예: 주상복합" />
      </div>
      <div class="form-group">
        <label>정렬순서</label>
        <input type="number" id="subSortOrder" class="form-control" value="0" min="0" style="width:100px;" />
      </div>
      <div class="form-group">
        <label>사용여부</label>
        <select id="subUseYn" class="form-control" style="width:100px;">
          <option value="Y">사용</option>
          <option value="N">미사용</option>
        </select>
      </div>
    </div>
    <div class="cat-modal-footer">
      <button class="btn btn-secondary btn-sm" onclick="fnCloseSubModal()">취소</button>
      <button class="btn btn-bo-save btn-sm" onclick="fnSaveSubCat()">저장</button>
    </div>
  </div>
</div>

<script>
var selectedCatCd = '';
var selectedCatNm = '';

/* ========== 대분류 선택 → 소분류 로드 ========== */
function fnSelectCat(catCd, el) {
  selectedCatCd = catCd;
  $('.cat-item').removeClass('active');
  $(el).addClass('active');
  selectedCatNm = $(el).find('.cat-item-nm').text();

  $('#subTitle').text('소분류 ─ ' + selectedCatNm);
  $('#btnAddSub').show();

  var res = ajaxCall('${ctx}/propCatMng/getSubCatList', { catCd: catCd }, false);
  if (res && res.result === 'OK') {
    fnRenderSubList(res.list);
  }
}

function fnRenderSubList(list) {
  if (!list || list.length === 0) {
    $('#subListArea').html('<div class="sub-empty">등록된 소분류가 없습니다.</div>');
    return;
  }
  var html = '<table class="sub-table"><thead><tr>'
    + '<th style="width:60px;">코드</th>'
    + '<th>소분류명</th>'
    + '<th style="width:70px;">정렬</th>'
    + '<th style="width:70px;">사용</th>'
    + '<th style="width:90px;">관리</th>'
    + '</tr></thead><tbody>';

  for (var i = 0; i < list.length; i++) {
    var s = list[i];
    var badge = s.USE_YN === 'Y'
      ? '<span class="cat-item-badge y">사용</span>'
      : '<span class="cat-item-badge n">미사용</span>';

    html += '<tr>'
      + '<td class="td-mono">' + s.SUB_CAT_CD + '</td>'
      + '<td>' + s.CAT_NM + '</td>'
      + '<td class="td-center">' + s.SORT_ORDER + '</td>'
      + '<td class="td-center">' + badge + '</td>'
      + '<td class="td-center">'
      + '<button class="btn btn-xs btn-outline-secondary" onclick="fnOpenSubModal(\'' + s.SUB_CAT_CD + '\',\'' + s.CAT_NM + '\',' + s.SORT_ORDER + ',\'' + s.USE_YN + '\')">수정</button> '
      + '<button class="btn btn-xs btn-outline-danger" onclick="fnDeleteSubCat(\'' + s.SUB_CAT_CD + '\',\'' + s.CAT_NM + '\')">삭제</button>'
      + '</td></tr>';
  }
  html += '</tbody></table>';
  $('#subListArea').html(html);
}

/* ========== 대분류 모달 ========== */
function fnOpenCatModal(catCd, catNm, sortOrder, useYn) {
  if (catCd) {
    $('#catModalMode').val('edit');
    $('#catModalTitle').text('대분류 수정');
    $('#catCd').val(catCd).prop('readonly', true).css('background', '#f5f5f5');
    $('#catNm').val(catNm);
    $('#catSortOrder').val(sortOrder);
    $('#catUseYn').val(useYn);
  } else {
    $('#catModalMode').val('new');
    $('#catModalTitle').text('대분류 등록');
    $('#catCd').val('').prop('readonly', false).css('background', '');
    $('#catNm').val('');
    $('#catSortOrder').val(0);
    $('#catUseYn').val('Y');
  }
  $('#catModal').addClass('show');
  setTimeout(function() { (catCd ? $('#catNm') : $('#catCd')).focus(); }, 100);
}

function fnCloseCatModal() { $('#catModal').removeClass('show'); }

function fnSaveCat() {
  var catCd = $('#catCd').val().trim().toUpperCase();
  var catNm = $('#catNm').val().trim();
  if (!catCd) { alert('대분류코드를 입력해주세요.'); $('#catCd').focus(); return; }
  if (!catNm) { alert('분류명을 입력해주세요.'); $('#catNm').focus(); return; }
  if (!/^[A-Z_]+$/.test(catCd)) { alert('대분류코드는 영문 대문자와 _ 만 가능합니다.'); return; }

  var res = ajaxCall('${ctx}/propCatMng/saveCat', {
    catCd: catCd,
    catNm: catNm,
    sortOrder: $('#catSortOrder').val(),
    useYn: $('#catUseYn').val()
  }, false);

  if (res && res.result === 'OK') {
    alert('저장되었습니다.');
    location.reload();
  } else {
    alert('저장 실패: ' + (res && res.message ? res.message : ''));
  }
}

function fnDeleteCat(catCd, catNm) {
  if (!confirm('[' + catNm + '] 대분류와 하위 소분류를 모두 삭제하시겠습니까?')) return;
  var res = ajaxCall('${ctx}/propCatMng/deleteCat', { catCd: catCd }, false);
  if (res && res.result === 'OK') {
    alert('삭제되었습니다.');
    location.reload();
  } else {
    alert('삭제 실패');
  }
}

/* ========== 소분류 모달 ========== */
function fnOpenSubModal(subCatCd, catNm, sortOrder, useYn) {
  if (!selectedCatCd) { alert('대분류를 먼저 선택해주세요.'); return; }
  $('#subParentNm').val(selectedCatNm + ' (' + selectedCatCd + ')');

  if (subCatCd) {
    $('#subModalMode').val('edit');
    $('#subModalTitle').text('소분류 수정');
    $('#subCatCd').val(subCatCd);
    $('#subCatNm').val(catNm);
    $('#subSortOrder').val(sortOrder);
    $('#subUseYn').val(useYn);
  } else {
    $('#subModalMode').val('new');
    $('#subModalTitle').text('소분류 등록');
    $('#subCatCd').val('');
    $('#subCatNm').val('');
    $('#subSortOrder').val(0);
    $('#subUseYn').val('Y');
  }
  $('#subModal').addClass('show');
  setTimeout(function() { $('#subCatNm').focus(); }, 100);
}

function fnCloseSubModal() { $('#subModal').removeClass('show'); }

function fnSaveSubCat() {
  var catNm = $('#subCatNm').val().trim();
  if (!catNm) { alert('소분류명을 입력해주세요.'); $('#subCatNm').focus(); return; }

  var res = ajaxCall('${ctx}/propCatMng/saveSubCat', {
    catCd: selectedCatCd,
    subCatCd: $('#subCatCd').val(),
    catNm: catNm,
    sortOrder: $('#subSortOrder').val(),
    useYn: $('#subUseYn').val()
  }, false);

  if (res && res.result === 'OK') {
    alert('저장되었습니다.');
    fnCloseSubModal();
    // 소분류 다시 로드
    fnSelectCat(selectedCatCd, $('.cat-item[data-cd="' + selectedCatCd + '"]')[0]);
    // 대분류 개수 갱신 위해 리로드
    location.reload();
  } else {
    alert('저장 실패: ' + (res && res.message ? res.message : ''));
  }
}

function fnDeleteSubCat(subCatCd, catNm) {
  if (!confirm('[' + catNm + '] 소분류를 삭제하시겠습니까?')) return;
  var res = ajaxCall('${ctx}/propCatMng/deleteSubCat', {
    catCd: selectedCatCd,
    subCatCd: subCatCd
  }, false);

  if (res && res.result === 'OK') {
    alert('삭제되었습니다.');
    fnSelectCat(selectedCatCd, $('.cat-item[data-cd="' + selectedCatCd + '"]')[0]);
    location.reload();
  } else {
    alert('삭제 실패');
  }
}

/* ESC 닫기 */
$(document).keydown(function(e) {
  if (e.keyCode === 27) {
    fnCloseCatModal();
    fnCloseSubModal();
  }
});
</script>
