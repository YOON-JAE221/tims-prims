<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<style>
  .menu-layout { display:flex; gap:16px; }
  .menu-tree-wrap { flex:0 0 420px; min-width:420px; }
  .menu-form-wrap { flex:1; min-width:0; }
  @media (max-width:992px) {
    .menu-layout { flex-direction:column; }
    .menu-tree-wrap { flex:none; min-width:0; }
  }
  .menu-form-wrap .table th { font-size:13px; white-space:nowrap; }
  .menu-form-wrap .table td { font-size:13px; }
  /* 트리 행 클릭 커서 */
  #menuTree .tabulator-row { cursor:pointer; }
  #menuTree .tabulator-row.row-selected { background:#e8f4fd !important; }
  #menuTree .tabulator-row.row-new { background:#fff8e1 !important; font-style:italic; }
</style>

<!-- Content Wrapper -->
<div class="content-wrapper">

  <!-- Content Header -->
  <div class="content-header">
    <div class="container">
      <div class="row mb-2">
        <div class="col-sm-6"><h4>메뉴관리</h4></div>
        <div class="col-sm-6">
          <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item active">시스템관리</li>
            <li class="breadcrumb-item"><a href="${ctx}/sysMenuMng/viewSysMenuMng">메뉴관리</a></li>
          </ol>
        </div>
      </div>
    </div>
  </div>

  <!-- Main content -->
  <section class="content">
    <div class="container">
      <div class="menu-layout">

        <!-- ===== 좌: 트리 ===== -->
        <div class="menu-tree-wrap">
          <div class="card">
            <div class="card-header">
              <div class="row align-items-center">
                <div class="col"></div>
                <div class="col-auto">
                  <div class="d-flex bo-actionbar">
                    <button type="button" id="btnNew" class="btn btn-sm btn-bo-add" onclick="fnNewMenu()">신규</button>
                    <button type="button" class="btn btn-sm btn-bo-reset" onclick="fnLoadTree()">새로고침</button>
                  </div>
                </div>
              </div>
            </div>
            <div class="card-body" style="padding:0;">
              <div id="menuTree"></div>
            </div>
          </div>
        </div>

        <!-- ===== 우: 상세 폼 ===== -->
        <div class="menu-form-wrap">
          <div class="card">
            <div class="card-header">
              <div class="row align-items-center">
                <div class="col"><h5 class="mb-0" id="formTitle">메뉴 등록</h5></div>
                <div class="col-auto">
                  <div class="d-flex bo-actionbar">
                    <button type="button" class="btn btn-sm btn-bo-save" onclick="fnSave()">저장</button>
                    <button type="button" class="btn btn-sm btn-bo-delete" onclick="fnDelete()">삭제</button>
                    <button type="button" class="btn btn-sm btn-bo-reset" onclick="fnNewMenu()">초기화</button>
                  </div>
                </div>
              </div>
            </div>
            <div class="card-body">
              <form id="menuForm">
                <input type="hidden" name="uprMenuCd" id="uprMenuCd" />
                <input type="hidden" name="menuLvl" id="menuLvl" value="0" />
                <table class="table table-bordered">
                  <colgroup><col style="width:130px;"><col></colgroup>
                  <tbody>
                    <tr>
                      <th class="bg-light">메뉴코드 <span class="text-danger">*</span></th>
                      <td>
                        <input type="text" name="sysMenuCd" id="sysMenuCd" class="form-control form-control-sm" maxlength="20" />
                        <input type="hidden" id="isEditMode" value="N" />
                      </td>
                    </tr>
                    <tr>
                      <th class="bg-light">상위메뉴</th>
                      <td>
                        <span id="uprMenuNmDisplay" style="font-size:14px; color:#333;">(최상위)</span>
                      </td>
                    </tr>
                    <tr>
                      <th class="bg-light">메뉴명 <span class="text-danger">*</span></th>
                      <td><input type="text" name="menuNm" id="menuNm" class="form-control form-control-sm" maxlength="80" /></td>
                    </tr>
                    <tr>
                      <th class="bg-light">시스템구분</th>
                      <td>
                        <label><input type="radio" name="menuSysDiv" value="A" checked /> 관리자(A)</label>
                        <label class="ml-3"><input type="radio" name="menuSysDiv" value="F" /> 사용자(F)</label>
                      </td>
                    </tr>
                    <tr>
                      <th class="bg-light">메뉴구분</th>
                      <td>
                        <label><input type="radio" name="menuDiv" value="1" checked onclick="fnToggleBrdCd()" /> 일반</label>
                        <label class="ml-3"><input type="radio" name="menuDiv" value="2" onclick="fnToggleBrdCd()" /> 게시판</label>
                      </td>
                    </tr>
                    <tr id="trBrdCd" style="display:none;">
                      <th class="bg-light">게시판코드</th>
                      <td>
                        <input type="text" name="brdCd" id="brdCd" class="form-control form-control-sm" maxlength="50" readonly />
                      </td>
                    </tr>
                    <tr>
                      <th class="bg-light">메뉴 URL</th>
                      <td><input type="text" name="menuUrl" id="menuUrl" class="form-control form-control-sm" maxlength="300" /></td>
                    </tr>
                    <tr>
                      <th class="bg-light">정렬순서</th>
                      <td><input type="number" name="menuSort" id="menuSort" class="form-control form-control-sm" style="width:100px;" value="0" min="0" /></td>
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
                      <td><textarea name="bigo" id="bigo" class="form-control form-control-sm" rows="2" maxlength="4000"></textarea></td>
                    </tr>
                  </tbody>
                </table>
              </form>
            </div>
          </div>
        </div>

      </div>
    </div>
  </section>
</div>

<script>
var menuTree = null;
var _flatList = [];
var _formSnapshot = '';
var _currentMenuCd = '';
var _isNewMode = false;  // 신규 모드 플래그

$(function() {
  initTree();
});

/* ===================== 트리 ===================== */
function initTree() {
  menuTree = new Tabulator("#menuTree", {
    height: "620px",
    layout: "fitColumns",
    dataTree: true,
    dataTreeStartExpanded: true,
    dataTreeChildField: "_children",
    selectable: false,
    columns: [
      { title:"메뉴명", field:"menuNm", minWidth:200, headerSort:false },
      {
        title:"구분", field:"menuSysDiv", width:60, hozAlign:"center", headerSort:false,
        formatter:function(c){ return c.getValue()==='A' ? "<span class='badge bg-primary'>A</span>" : "<span class='badge bg-info'>F</span>"; }
      },
      {
        title:"사용", field:"useYn", width:55, hozAlign:"center", headerSort:false,
        formatter:function(c){ return c.getValue()==='Y' ? "<span class='badge bg-success'>Y</span>" : "<span class='badge bg-secondary'>N</span>"; }
      },
      { title:"순서", field:"menuSort", width:55, hozAlign:"center", headerSort:false }
    ],
    rowFormatter: function(row) {
      var d = row.getData();
      if (d.sysMenuCd === '_NEW_') {
        row.getElement().classList.add('row-new');
      }
    }
  });

  menuTree.on("tableBuilt", function() {
    fnLoadTree(true);
  });

  menuTree.on("rowClick", function(e, row) {
    if (e.target.closest('.tabulator-data-tree-control')) return;
    fnSelectRow(row);
  });
}

/* 트리 로드 */
function fnLoadTree(isFirstLoad) {
  var res = ajaxCall("${ctx}/sysMenuMng/getSelectSysMenuList", {}, false);
  _flatList = (res && res.DATA) ? res.DATA : [];

  var treeData = buildTree(_flatList);
  menuTree.setData(treeData);

  _formSnapshot = '';
  _currentMenuCd = '';
  _isNewMode = false;
  $('#btnNew').prop('disabled', false);
  fnClearForm();

  // 첫 로드시 첫번째 행 자동 선택
  if (isFirstLoad) {
    setTimeout(function() {
      var firstRow = menuTree.getRows()[0];
      if (firstRow) fnSelectRow(firstRow);
    }, 200);
  }
}

function buildTree(list) {
  var map = {}, roots = [];
  list.forEach(function(item) {
    var copy = $.extend({}, item);
    copy._children = [];
    map[copy.sysMenuCd] = copy;
  });
  list.forEach(function(item) {
    var p = item.uprMenuCd || '';
    if (p && map[p]) {
      map[p]._children.push(map[item.sysMenuCd]);
    } else {
      roots.push(map[item.sysMenuCd]);
    }
  });
  return roots;
}

/* ===================== 행 선택 ===================== */
function fnSelectRow(row) {
  var d = row.getData();
  if (d.sysMenuCd === '_NEW_') return; // 신규 임시행 클릭 무시
  if (d.sysMenuCd === _currentMenuCd && !_isNewMode) return;

  if (_formSnapshot && fnIsFormDirty()) {
    if (!confirm('저장하지 않은 변경사항이 있습니다.\n이동하시겠습니까?')) return;
  }

  // 신규 모드였으면 임시행 제거 + 복원
  if (_isNewMode) {
    fnRemoveNewRow();
  }

  // 선택 스타일
  $('#menuTree .tabulator-row').removeClass('row-selected');
  row.getElement().classList.add('row-selected');

  _currentMenuCd = d.sysMenuCd;
  fnBindForm(d);
}

/* ===================== 폼 바인딩 ===================== */
function fnBindForm(d) {
  $('#sysMenuCd').val(d.sysMenuCd || '').prop('readonly', true);
  $('#isEditMode').val('Y');

  var uprCd = d.uprMenuCd || '';
  $('#uprMenuCd').val(uprCd);
  if (uprCd) {
    var parentMenu = _flatList.find(function(m){ return m.sysMenuCd === uprCd; });
    $('#uprMenuNmDisplay').text(parentMenu ? parentMenu.menuNm + ' [' + uprCd + ']' : uprCd);
  } else {
    $('#uprMenuNmDisplay').text('(최상위)');
  }

  $('#menuNm').val(d.menuNm || '');
  $('input[name="menuSysDiv"][value="' + (d.menuSysDiv || 'A') + '"]').prop('checked', true);
  $('input[name="menuDiv"][value="' + (d.menuDiv || '1') + '"]').prop('checked', true);
  fnToggleBrdCd();
  $('#brdCd').val(d.brdCd || '');
  $('#menuUrl').val(d.menuUrl || '');
  $('#menuSort').val(d.menuSort != null ? d.menuSort : 0);
  $('input[name="useYn"][value="' + (d.useYn || 'Y') + '"]').prop('checked', true);
  $('#bigo').val(d.bigo || '');
  $('#menuLvl').val(d.menuLvl != null ? d.menuLvl : 0);

  $('#formTitle').text('메뉴 수정 [' + d.sysMenuCd + ']');
  _formSnapshot = fnGetFormData();
}

/* ===================== 폼 초기화 ===================== */
function fnClearForm() {
  $('#menuForm')[0].reset();
  $('#sysMenuCd').val('').prop('readonly', false);
  $('#isEditMode').val('N');
  $('#uprMenuCd').val('');
  $('#uprMenuNmDisplay').text('(최상위)');
  $('#menuLvl').val(0);
  $('#menuSort').val(0);
  $('input[name="menuSysDiv"][value="A"]').prop('checked', true);
  $('input[name="menuDiv"][value="1"]').prop('checked', true);
  $('input[name="useYn"][value="Y"]').prop('checked', true);
  fnToggleBrdCd();
  $('#formTitle').text('메뉴 등록');
  _formSnapshot = fnGetFormData();
}

/* ===================== 신규 ===================== */
function fnNewMenu() {
  if (_formSnapshot && fnIsFormDirty()) {
    if (!confirm('저장하지 않은 변경사항이 있습니다.\n초기화하시겠습니까?')) return;
  }

  // 이미 신규 모드면 무시
  if (_isNewMode) return;

  // 현재 선택된 행 = 상위메뉴
  var parentCd = '';
  var parentNm = '(최상위)';
  var parentLvl = -1;
  var parentSysDiv = 'A';
  if (_currentMenuCd) {
    var cur = _flatList.find(function(m){ return m.sysMenuCd === _currentMenuCd; });
    if (cur) {
      parentCd = cur.sysMenuCd;
      parentNm = cur.menuNm + ' [' + cur.sysMenuCd + ']';
      parentLvl = parseInt(cur.menuLvl) || 0;
      parentSysDiv = cur.menuSysDiv || 'A';
    }
  }

  // 트리에 임시 행 추가
  fnAddNewRow(parentCd, parentSysDiv);

  // 폼 초기화
  fnClearForm();
  $('#uprMenuCd').val(parentCd);
  $('#uprMenuNmDisplay').text(parentNm);
  $('#menuLvl').val(parentLvl + 1);
  $('input[name="menuSysDiv"][value="' + parentSysDiv + '"]').prop('checked', true);
  $('#formTitle').text('메뉴 신규 등록');

  // 신규 모드 ON
  _isNewMode = true;
  $('#btnNew').prop('disabled', true);
  _formSnapshot = fnGetFormData();

  // 포커스
  $('#sysMenuCd').focus();
}

/* 트리에 임시 행(노란색) 추가 */
function fnAddNewRow(parentCd, sysDiv) {
  var newData = {
    sysMenuCd: '_NEW_',
    menuNm: '(신규 메뉴)',
    menuSysDiv: sysDiv || 'A',
    useYn: 'Y',
    menuSort: 0,
    _children: []
  };

  if (parentCd) {
    // 부모 행 찾아서 자식으로 추가
    var parentRow = fnFindRow(parentCd);
    if (parentRow) {
      // 부모 펼치기
      if (!parentRow.isTreeExpanded()) parentRow.treeExpand();
      // 자식 데이터에 추가
      var pData = parentRow.getData();
      if (!pData._children) pData._children = [];
      pData._children.push(newData);
      parentRow.update(pData);

      // 임시행으로 스크롤
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

  // 상위메뉴 없으면 root에 추가
  menuTree.addRow(newData, false);
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

/* 메뉴코드로 트리 행 찾기 (자식 포함) */
function fnFindRow(menuCd) {
  var found = null;
  function search(rows) {
    for (var i = 0; i < rows.length; i++) {
      if (rows[i].getData().sysMenuCd === menuCd) { found = rows[i]; return; }
      var children = rows[i].getTreeChildren();
      if (children && children.length) search(children);
      if (found) return;
    }
  }
  search(menuTree.getRows());
  return found;
}

/* ===================== 저장 ===================== */
function fnSave() {
  var sysMenuCd = $('#sysMenuCd').val().trim();
  if (!sysMenuCd) { alert('메뉴코드를 입력해 주세요.'); $('#sysMenuCd').focus(); return; }
  if (!$('#menuNm').val().trim()) { alert('메뉴명을 입력해 주세요.'); $('#menuNm').focus(); return; }

  // menuLvl 자동 계산
  var uprMenuCd = $('#uprMenuCd').val();
  var menuLvl = 0;
  if (uprMenuCd) {
    var parent = _flatList.find(function(m){ return m.sysMenuCd === uprMenuCd; });
    if (parent) menuLvl = (parseInt(parent.menuLvl) || 0) + 1;
  }
  $('#menuLvl').val(menuLvl);

  var res = ajaxFormCall("${ctx}/sysMenuMng/saveSysMenu", "#menuForm", false);
  if (res && res.result === 'OK') {
    alert('저장되었습니다.');
    var savedCd = sysMenuCd;

    // 신규 모드 해제
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
function fnFindAndSelect(menuCd) {
  var row = fnFindRow(menuCd);
  if (row) {
    $('#menuTree .tabulator-row').removeClass('row-selected');
    row.getElement().classList.add('row-selected');
    _currentMenuCd = menuCd;
    fnBindForm(row.getData());
    row.scrollTo();
  }
}

/* ===================== 삭제 ===================== */
function fnDelete() {
  var sysMenuCd = $('#sysMenuCd').val().trim();
  if (!sysMenuCd || $('#isEditMode').val() !== 'Y') {
    alert('삭제할 메뉴를 선택해 주세요.'); return;
  }
  if (!confirm('[' + sysMenuCd + '] 메뉴를 삭제하시겠습니까?\n하위 메뉴도 함께 삭제됩니다.')) return;

  var res = ajaxCall("${ctx}/sysMenuMng/deleteSysMenu", { sysMenuCd: sysMenuCd }, false);
  if (res && res.result === 'OK') {
    alert('삭제되었습니다.');
    fnLoadTree(false);
  } else {
    alert('삭제 실패: ' + (res && (res.message || res.msg) ? (res.message || res.msg) : 'unknown'));
  }
}

/* ===================== 유틸 ===================== */
function fnToggleBrdCd() {
  var isBoard = $('input[name="menuDiv"]:checked').val() === '2';
  $('#trBrdCd').toggle(isBoard);
  if (!isBoard) $('#brdCd').val('');
}

function fnGetFormData() {
  return $('#menuForm').serialize();
}

function fnIsFormDirty() {
  return _formSnapshot !== fnGetFormData();
}
</script>
