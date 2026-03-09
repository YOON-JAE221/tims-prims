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
            <li class="breadcrumb-item"><a href="${ctx}/propCatMng/viewPropCatMng">매물코드관리</a></li>
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
              <button class="btn btn-sm btn-bo-add" onclick="fnOpenCatModal()">신규</button>
            </div>
            <div class="cat-panel-body" id="catListArea">
              <c:forEach var="cat" items="${catList}">
                <div class="cat-item" data-cd="${cat.catCd}" onclick="fnSelectCat('${cat.catCd}', this)">
                  <div class="cat-item-info">
                    <span class="cat-item-nm">${cat.catNm}</span>
                    <span class="cat-item-cd">${cat.catCd}</span>
                  </div>
                  <span class="badge ${cat.useYn eq 'Y' ? 'badge-success' : 'badge-danger'}">${cat.useYn eq 'Y' ? '사용' : '미사용'}</span>
                  <div class="cat-item-actions">
                    <button onclick="event.stopPropagation(); fnOpenCatModal('${cat.catCd}','${cat.catNm}',${cat.sortOrder},'${cat.useYn}')" title="수정">✏</button>
                    <button onclick="event.stopPropagation(); fnDeleteCat('${cat.catCd}','${cat.catNm}')" title="삭제">🗑</button>
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
          <div class="card">
            <div class="card-header">
              <div class="row align-items-center">
                <div class="col">
                  <h5 class="card-title mb-0" id="subTitle">소분류 (대분류를 선택해주세요)</h5>
                </div>
                <div class="col-auto" id="subBtns" style="display:none;">
                  <div class="d-flex bo-actionbar">
                    <button type="button" class="btn btn-sm btn-bo-add" onclick="fnAddSubRow()">신규</button>
                    <button type="button" class="btn btn-sm btn-bo-save" onclick="fnSaveSub()">저장</button>
                    <button type="button" class="btn btn-sm btn-bo-reset" onclick="fnReloadSub()">새로고침</button>
                  </div>
                </div>
              </div>
            </div>
            <div class="card-body">
              <div id="subGrid"></div>
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

<!-- 소분류 모달 제거됨 - TG 그리드 인라인 편집 사용 -->

<script>
var selectedCatCd = '';
var selectedCatNm = '';
var subTable = null;

/* ========== 소분류 그리드 초기화 ========== */
$(function() {
  initSubGrid();
});

function initSubGrid() {
  var columns = [
    { title:"코드", field:"subCatCd", width:100, editor:false },
    { title:"소분류명", field:"catNm", minWidth:200, editor:"input", validator:["required"] },
    { title:"정렬순서", field:"sortOrder", width:120, hozAlign:"center", editor:"number", editorEmptyValue:null, validator:["required","integer","min:0"] },
    { title:"사용여부", field:"useYn", width:120, hozAlign:"center",
      editor:"list", editorParams:{ values:{ "Y":"사용", "N":"미사용" } },
      formatter: function(cell) {
        return cell.getValue() === 'Y'
          ? '<span class="badge badge-success">사용</span>'
          : '<span class="badge badge-danger">미사용</span>';
      }
    },
    { title:"삭제", field:"_del", width:100, hozAlign:"center", headerSort:false,
      formatter: function() { return "<button type='button' class='btn btn-xs btn-bo-reset'>삭제</button>"; },
      cellClick: function(e, cell) { fnDeleteSubCat(cell.getRow()); }
    }
  ];

  subTable = TG.create("subGrid", columns, {
    height: "auto",
    pagination: false,
    validationMode: "highlight",
    layout: "fitColumns"
  });
}

/* ========== 대분류 선택 → 소분류 로드 ========== */
function fnSelectCat(catCd, el) {
  selectedCatCd = catCd;
  $('.cat-item').removeClass('active');
  $(el).addClass('active');
  selectedCatNm = $(el).find('.cat-item-nm').text();

  $('#subTitle').text('소분류 ─ ' + selectedCatNm);
  $('#subBtns').show();

  fnReloadSub();
}

function fnReloadSub() {
  if (!selectedCatCd || !subTable) return;
  TG.load(subTable, '${ctx}/propCatMng/getSubCatList', { catCd: selectedCatCd }, false, "DATA");
}

/* ========== 신규 행 추가 ========== */
function fnAddSubRow() {
  if (!subTable || !selectedCatCd) { alert('대분류를 먼저 선택해주세요.'); return; }
  subTable.addRow({ subCatCd: "", catNm: "", sortOrder: 0, useYn: "Y" }, false);
}

/* ========== 멀티저장 (TG.save) ========== */
function fnSaveSub() {
  if (!subTable) return;
  if (!TG.validate(subTable)) return;

  var saveRes = TG.save(subTable, '${ctx}/propCatMng/saveSubCatList', {
    extraParams: { catCd: selectedCatCd }
  });

  if (saveRes.ok) {
    alert('저장되었습니다.');
    fnReloadSub();
    // 대분류 개수 갱신
    location.reload();
  }
}

/* ========== 삭제 (TG.delete) ========== */
function fnDeleteSubCat(row) {
  var d = row.getData();
  var delRes = TG.delete(row, '${ctx}/propCatMng/deleteSubCat', {
    catCd: selectedCatCd,
    subCatCd: d.subCatCd
  }, false);

  if (delRes.ok) {
    if (delRes.code !== 'LOCAL') {
      alert('삭제되었습니다.');
      fnReloadSub();
    }
  }
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

/* ========== 소분류 모달 (미사용 - TG 그리드 인라인 편집으로 대체) ========== */

/* ESC 닫기 */
$(document).keydown(function(e) {
  if (e.keyCode === 27) {
    fnCloseCatModal();
  }
});
</script>
