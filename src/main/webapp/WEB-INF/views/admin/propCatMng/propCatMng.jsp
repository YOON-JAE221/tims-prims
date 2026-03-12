<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<style>
  .cat-layout { display:flex; gap:16px; }
  .cat-tree-wrap { flex:0 0 480px; min-width:480px; }
  .cat-form-wrap { flex:1; min-width:0; }
  @media (max-width:992px) {
    .cat-layout { flex-direction:column; }
    .cat-tree-wrap { flex:none; min-width:0; }
  }
  .cat-form-wrap .table th { font-size:13px; white-space:nowrap; width:120px; }
  .cat-form-wrap .table td { font-size:13px; }
  /* 트리 행 클릭 커서 */
  #catTree .tabulator-row { cursor:pointer; }
  #catTree .tabulator-row.row-selected { background:#e8f4fd !important; }
  #catTree .tabulator-row.row-new { background:#fff8e1 !important; font-style:italic; }
  /* 사용법 박스 */
  .help-box { background:#f8f9fa; border:1px solid #e9ecef; border-radius:6px; padding:16px; margin-top:16px; }
  .help-box h6 { font-size:14px; font-weight:700; color:#1B2A4A; margin-bottom:12px; }
  .help-box ul { margin:0; padding-left:20px; font-size:13px; color:#555; }
  .help-box li { margin-bottom:6px; }
</style>

<!-- Content Wrapper -->
<div class="content-wrapper">

  <!-- Content Header -->
  <div class="content-header">
    <div class="container">
      <div class="row mb-2">
        <div class="col-sm-6"><h4>카테고리관리</h4></div>
        <div class="col-sm-6">
          <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item active">매물관리</li>
            <li class="breadcrumb-item"><a href="${ctx}/propCatMng/viewPropCatMng">카테고리관리</a></li>
          </ol>
        </div>
      </div>
    </div>
  </div>

  <!-- Main content -->
  <section class="content">
    <div class="container">
      <div class="cat-layout">

        <!-- ===== 좌: 트리 ===== -->
        <div class="cat-tree-wrap">
          <div class="card">
            <div class="card-header">
              <div class="row align-items-center">
                <div class="col"></div>
                <div class="col-auto">
                  <div class="d-flex bo-actionbar">
                    <button type="button" id="btnNew" class="btn btn-sm btn-bo-add" onclick="fnNewCat()">신규</button>
                    <button type="button" class="btn btn-sm" style="background:#217346; border-color:#217346; color:#fff;" onclick="fnExcelDown()"><i class="fas fa-file-excel"></i> 엑셀</button>
                  </div>
                </div>
              </div>
            </div>
            <div class="card-body" style="padding:0;">
              <div id="catTree"></div>
            </div>
          </div>
        </div>

        <!-- ===== 우: 상세 폼 ===== -->
        <div class="cat-form-wrap">
          <div class="card">
            <div class="card-header">
              <div class="row align-items-center">
                <div class="col"><h5 class="mb-0" id="formTitle">카테고리 등록</h5></div>
                <div class="col-auto">
                  <div class="d-flex bo-actionbar">
                    <button type="button" class="btn btn-sm btn-bo-save" onclick="fnSave()">저장</button>
                    <button type="button" class="btn btn-sm btn-bo-reset" onclick="fnDelete()">삭제</button>
                    <button type="button" class="btn btn-sm btn-bo-reset" onclick="location.reload()">새로고침</button>
                  </div>
                </div>
              </div>
            </div>
            <div class="card-body">
              <form id="catForm">
                <input type="hidden" name="uprCatCd" id="uprCatCd" />
                <input type="hidden" name="catLvl" id="catLvl" value="0" />
                <table class="table table-bordered">
                  <colgroup><col style="width:120px;"><col></colgroup>
                  <tbody>
                    <tr>
                      <th class="bg-light">카테고리코드 <span class="text-danger">*</span></th>
                      <td>
                        <input type="text" name="catCd" id="catCd" class="form-control form-control-sm" maxlength="50" style="text-transform:uppercase;" />
                        <small class="text-muted" id="catCdHelp">대분류만 직접 입력, 하위분류는 자동생성</small>
                        <input type="hidden" id="isEditMode" value="N" />
                      </td>
                    </tr>
                    <tr>
                      <th class="bg-light">상위카테고리</th>
                      <td>
                        <span id="uprCatNmDisplay" style="font-size:14px; color:#333;">(최상위)</span>
                      </td>
                    </tr>
                    <tr>
                      <th class="bg-light">카테고리명 <span class="text-danger">*</span></th>
                      <td><input type="text" name="catNm" id="catNm" class="form-control form-control-sm" maxlength="50" /></td>
                    </tr>
                    <tr>
                      <th class="bg-light">정렬순서</th>
                      <td><input type="number" name="sortOrder" id="sortOrder" class="form-control form-control-sm" style="width:100px;" value="0" min="0" /></td>
                    </tr>
                    <tr>
                      <th class="bg-light">사용여부</th>
                      <td>
                        <label><input type="radio" name="useYn" value="Y" checked /> 사용</label>
                        <label class="ml-3"><input type="radio" name="useYn" value="N" /> 미사용</label>
                      </td>
                    </tr>
                    <tr>
                      <th class="bg-light">비고</th>
                      <td><textarea name="bigo" id="bigo" class="form-control form-control-sm" rows="2" maxlength="500"></textarea></td>
                    </tr>
                  </tbody>
                </table>
              </form>

              <!-- 사용법 안내 -->
              <div class="help-box">
                <h6>💡 사용법</h6>
                <ul>
                  <li>트리에서 항목 클릭 → 우측 폼에 상세정보 표시</li>
                  <li><strong>[신규]</strong> 클릭 → 선택된 항목의 하위로 추가</li>
                  <li>대분류(최상위)만 코드 직접 입력 (예: APT, SHOP)</li>
                  <li>중분류/소분류는 코드가 자동으로 생성됩니다</li>
                  <li>삭제 시 하위 카테고리도 함께 삭제됩니다</li>
                </ul>
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>
  </section>
</div>

<script>
var catTree = null;
var _flatList = [];
var _formSnapshot = '';
var _currentCatCd = '';
var _isNewMode = false;

$(function() {
  initTree();
});

/* ===================== 트리 초기화 ===================== */
function initTree() {
  catTree = new Tabulator("#catTree", {
    height: "580px",
    layout: "fitColumns",
    dataTree: true,
    dataTreeStartExpanded: false,
    dataTreeChildField: "_children",
    selectable: false,
    columns: [
      { title:"카테고리명", field:"catNm", minWidth:220, headerSort:false },
      {
        title:"사용", field:"useYn", width:70, hozAlign:"center", headerSort:false,
        formatter:function(c){
          return c.getValue()==='Y'
            ? "<span class='badge badge-success'>사용</span>"
            : "<span class='badge badge-danger'>미사용</span>";
        }
      },
      { title:"순서", field:"sortOrder", width:55, hozAlign:"center", headerSort:false }
    ],
    rowFormatter: function(row) {
      var d = row.getData();
      if (d.catCd === '_NEW_') {
        row.getElement().classList.add('row-new');
      }
    }
  });

  catTree.on("tableBuilt", function() {
    fnLoadTree(true);
  });

  catTree.on("rowClick", function(e, row) {
    if (e.target.closest('.tabulator-data-tree-control')) return;
    fnSelectRow(row);
  });
}

/* 트리 로드 */
function fnLoadTree(isFirstLoad) {
  var res = ajaxCall("${ctx}/propCatMng/getCatList", {}, false);
  _flatList = (res && res.DATA) ? res.DATA : [];

  var treeData = buildTree(_flatList);
  catTree.setData(treeData);

  _formSnapshot = '';
  _currentCatCd = '';
  _isNewMode = false;
  $('#btnNew').prop('disabled', false);
  fnClearForm();

  // 첫 로드시 첫번째 행 자동 선택
  if (isFirstLoad) {
    setTimeout(function() {
      var firstRow = catTree.getRows()[0];
      if (firstRow) fnSelectRow(firstRow);
    }, 200);
  }
}

function buildTree(list) {
  var map = {}, roots = [];
  list.forEach(function(item) {
    var copy = $.extend({}, item);
    copy._children = [];
    map[copy.catCd] = copy;
  });
  list.forEach(function(item) {
    var p = item.uprCatCd || '';
    if (p && map[p]) {
      map[p]._children.push(map[item.catCd]);
    } else {
      roots.push(map[item.catCd]);
    }
  });
  return roots;
}

/* ===================== 행 선택 ===================== */
function fnSelectRow(row) {
  var d = row.getData();
  if (d.catCd === '_NEW_') return;
  if (d.catCd === _currentCatCd && !_isNewMode) return;

  if (_formSnapshot && fnIsFormDirty()) {
    if (!confirm('저장하지 않은 변경사항이 있습니다.\n이동하시겠습니까?')) return;
  }

  if (_isNewMode) {
    fnRemoveNewRow();
  }

  $('#catTree .tabulator-row').removeClass('row-selected');
  row.getElement().classList.add('row-selected');

  _currentCatCd = d.catCd;
  fnBindForm(d);
}

/* ===================== 폼 바인딩 ===================== */
function fnBindForm(d) {
  $('#catCd').val(d.catCd || '').prop('readonly', true);
  $('#isEditMode').val('Y');

  var uprCd = d.uprCatCd || '';
  $('#uprCatCd').val(uprCd);
  if (uprCd) {
    var parentCat = _flatList.find(function(m){ return m.catCd === uprCd; });
    $('#uprCatNmDisplay').text(parentCat ? parentCat.catNm + ' [' + uprCd + ']' : uprCd);
  } else {
    $('#uprCatNmDisplay').text('(최상위)');
  }

  $('#catNm').val(d.catNm || '');
  $('#sortOrder').val(d.sortOrder != null ? d.sortOrder : 0);
  $('input[name="useYn"][value="' + (d.useYn || 'Y') + '"]').prop('checked', true);
  $('#bigo').val(d.bigo || '');
  $('#catLvl').val(d.catLvl != null ? d.catLvl : 0);

  $('#formTitle').text('카테고리 수정 [' + d.catCd + ']');
  $('#catCdHelp').hide();
  _formSnapshot = fnGetFormData();
}

/* ===================== 폼 초기화 ===================== */
function fnClearForm() {
  $('#catForm')[0].reset();
  $('#catCd').val('').prop('readonly', false);
  $('#isEditMode').val('N');
  $('#uprCatCd').val('');
  $('#uprCatNmDisplay').text('(최상위)');
  $('#catLvl').val(0);
  $('#sortOrder').val(0);
  $('input[name="useYn"][value="Y"]').prop('checked', true);
  $('#formTitle').text('카테고리 등록');
  $('#catCdHelp').show();
  _formSnapshot = fnGetFormData();
}

/* ===================== 신규 ===================== */
function fnNewCat() {
  if (_formSnapshot && fnIsFormDirty()) {
    if (!confirm('저장하지 않은 변경사항이 있습니다.\n초기화하시겠습니까?')) return;
  }

  if (_isNewMode) return;

  var parentCd = '';
  var parentNm = '(최상위)';
  var parentLvl = -1;
  if (_currentCatCd) {
    var cur = _flatList.find(function(m){ return m.catCd === _currentCatCd; });
    if (cur) {
      parentCd = cur.catCd;
      parentNm = cur.catNm + ' [' + cur.catCd + ']';
      parentLvl = parseInt(cur.catLvl) || 0;
    }
  }

  fnAddNewRow(parentCd);
  fnClearForm();
  $('#uprCatCd').val(parentCd);
  $('#uprCatNmDisplay').text(parentNm);
  $('#catLvl').val(parentLvl + 1);
  $('#formTitle').text('카테고리 신규 등록');

  // 하위분류면 코드 자동생성
  if (parentCd) {
    var res = ajaxCall('${ctx}/propCatMng/getNextCatCd', { uprCatCd: parentCd }, false);
    if (res && res.catCd) {
      $('#catCd').val(res.catCd).prop('readonly', true);
      $('#catCdHelp').text('코드 자동생성됨').show();
    }
  } else {
    $('#catCd').val('').prop('readonly', false);
    $('#catCdHelp').text('대분류만 직접 입력 (예: APT, SHOP)').show();
  }

  _isNewMode = true;
  $('#btnNew').prop('disabled', true);
  _formSnapshot = fnGetFormData();

  $('#catNm').focus();
}

/* 트리에 임시 행 추가 */
function fnAddNewRow(parentCd) {
  var newData = {
    catCd: '_NEW_',
    catNm: '(신규 카테고리)',
    useYn: 'Y',
    sortOrder: 0,
    _children: []
  };

  if (parentCd) {
    var parentRow = fnFindRow(parentCd);
    if (parentRow) {
      if (!parentRow.isTreeExpanded()) parentRow.treeExpand();
      var pData = parentRow.getData();
      if (!pData._children) pData._children = [];
      pData._children.push(newData);
      parentRow.update(pData);

      setTimeout(function() {
        var newRow = fnFindRow('_NEW_');
        if (newRow) {
          newRow.getElement().classList.add('row-new');
          newRow.scrollTo();
        }
      }, 100);
      return;
    }
  }

  catTree.addRow(newData, false);
  setTimeout(function() {
    var newRow = fnFindRow('_NEW_');
    if (newRow) {
      newRow.getElement().classList.add('row-new');
      newRow.scrollTo();
    }
  }, 100);
}

/* 임시 행 제거 */
function fnRemoveNewRow() {
  var newRow = fnFindRow('_NEW_');
  if (newRow) newRow.delete();
  _isNewMode = false;
  $('#btnNew').prop('disabled', false);
}

/* 카테고리코드로 트리 행 찾기 */
function fnFindRow(catCd) {
  var found = null;
  function search(rows) {
    for (var i = 0; i < rows.length; i++) {
      if (rows[i].getData().catCd === catCd) { found = rows[i]; return; }
      var children = rows[i].getTreeChildren();
      if (children && children.length) search(children);
      if (found) return;
    }
  }
  search(catTree.getRows());
  return found;
}

/* ===================== 저장 ===================== */
function fnSave() {
  var catCd = $('#catCd').val().trim().toUpperCase();
  $('#catCd').val(catCd);

  if (!catCd) { alert('카테고리코드를 입력해 주세요.'); $('#catCd').focus(); return; }
  if (!$('#catNm').val().trim()) { alert('카테고리명을 입력해 주세요.'); $('#catNm').focus(); return; }

  // 대분류(최상위)인 경우 영문 대문자만 허용
  var uprCatCd = $('#uprCatCd').val();
  if (!uprCatCd && !/^[A-Z_]+$/.test(catCd)) {
    alert('대분류 코드는 영문 대문자와 _ 만 가능합니다.');
    $('#catCd').focus();
    return;
  }

  // catLvl 자동 계산
  var catLvl = 0;
  if (uprCatCd) {
    var parent = _flatList.find(function(m){ return m.catCd === uprCatCd; });
    if (parent) catLvl = (parseInt(parent.catLvl) || 0) + 1;
  }
  $('#catLvl').val(catLvl);

  var res = ajaxFormCall("${ctx}/propCatMng/saveCat", "#catForm", false);
  if (res && res.result === 'OK') {
    alert('저장되었습니다.');
    var savedCd = catCd;

    _isNewMode = false;
    $('#btnNew').prop('disabled', false);

    fnLoadTree(false);
    setTimeout(function() {
      fnFindAndSelect(savedCd);
    }, 300);
  } else {
    alert('저장 실패: ' + (res && (res.message || res.msg) ? (res.message || res.msg) : 'unknown'));
  }
}

/* 트리에서 행 찾아 선택 */
function fnFindAndSelect(catCd) {
  var row = fnFindRow(catCd);
  if (row) {
    $('#catTree .tabulator-row').removeClass('row-selected');
    row.getElement().classList.add('row-selected');
    _currentCatCd = catCd;
    fnBindForm(row.getData());
    row.scrollTo();
  }
}

/* ===================== 삭제 ===================== */
function fnDelete() {
  var catCd = $('#catCd').val().trim();
  if (!catCd || $('#isEditMode').val() !== 'Y') {
    alert('삭제할 카테고리를 선택해 주세요.'); return;
  }
  if (!confirm('[' + catCd + '] 카테고리를 삭제하시겠습니까?\n하위 카테고리도 함께 삭제됩니다.')) return;

  var res = ajaxCall("${ctx}/propCatMng/deleteCat", { catCd: catCd }, false);
  if (res && res.result === 'OK') {
    alert('삭제되었습니다.');
    fnLoadTree(false);
  } else {
    alert('삭제 실패: ' + (res && (res.message || res.msg) ? (res.message || res.msg) : 'unknown'));
  }
}

/* ===================== 유틸 ===================== */
function fnGetFormData() {
  return $('#catForm').serialize();
}

function fnIsFormDirty() {
  return _formSnapshot !== fnGetFormData();
}

/* ===================== 엑셀 다운로드 ===================== */
function fnExcelDown() {
  location.href = '${ctx}/propCatMng/excelDown';
}
</script>
