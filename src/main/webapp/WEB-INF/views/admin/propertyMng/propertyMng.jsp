<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<div class="content-wrapper">
  <div class="content-header">
    <div class="container">
      <div class="row mb-2">
        <div class="col-sm-6"><h4>매물관리</h4></div>
        <div class="col-sm-6">
          <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item active">매물관리</li>
            <li class="breadcrumb-item"><a href="${ctx}/propertyMng/viewPropertyMng">매물관리</a></li>
          </ol>
        </div>
      </div>
    </div>
  </div>

  <section class="content">
    <div class="container">
      <div class="card">
        <!-- 검색영역 -->
        <div class="card-header">
          <div class="row align-items-center">
            <div class="col-12 col-lg mb-2 mb-lg-0">
              <div class="d-flex flex-wrap align-items-center" style="gap:8px;">
                <select id="srchCatCd" class="form-control form-control-sm" style="width:120px;" onchange="fnChangeCat()">
                  <option value="ALL">전체분류</option>
                  <c:forEach var="cat" items="${catList}">
                    <option value="${cat.catCd}">${cat.catNm}</option>
                  </c:forEach>
                </select>
                <select id="srchSubCatCd" class="form-control form-control-sm" style="width:120px;" onchange="fnSearch()">
                  <option value="ALL">전체소분류</option>
                </select>
                <select id="srchDealType" class="form-control form-control-sm" style="width:120px;" onchange="fnSearch()">
                  <option value="ALL">전체거래</option>
                  <option value="SELL">매매</option>
                  <option value="JEONSE">전세</option>
                  <option value="WOLSE">월세</option>
                  <option value="SHORT">단기임대</option>
                </select>
                <select id="srchSoldYn" class="form-control form-control-sm" style="width:100px;" onchange="fnSearch()">
                  <option value="ALL">전체상태</option>
                  <option value="N">거래중</option>
                  <option value="Y">거래완료</option>
                </select>
                <select id="srchBadgeType" class="form-control form-control-sm" style="width:100px;" onchange="fnSearch()">
                  <option value="ALL">전체뱃지</option>
                  <option value="NONE">없음</option>
                  <option value="RECOMMEND">추천</option>
                  <option value="URGENT">급매</option>
                </select>
                <input type="text" id="srchKeyword" class="form-control form-control-sm" style="width:180px;" placeholder="매물명/주소 검색" onkeypress="if(event.keyCode===13) fnSearch();" />
                <button type="button" class="btn btn-sm btn-bo-search" onclick="fnSearch()">검색</button>
              </div>
            </div>
            <div class="col-12 col-lg-auto">
              <div class="d-flex justify-content-lg-end bo-actionbar">
                <button type="button" class="btn btn-sm btn-bo-add" onclick="fnGoWrite()">신규</button>
                <button type="button" class="btn btn-sm btn-bo-save" onclick="fnSaveStatus()">저장</button>
              </div>
            </div>
          </div>
        </div>

        <!-- 그리드 -->
        <div class="card-body p-0">
          <div class="p-2">
            <span id="totalCntTxt" style="font-size:13px; color:#666;">총 0건</span>
          </div>
          <div id="propGrid"></div>
        </div>

        <!-- 페이징 -->
        <div class="card-footer d-flex justify-content-center" style="padding:12px 0;">
          <div id="gridPaging"></div>
        </div>
      </div>
    </div>
  </section>
</div>

<script>
var propTable = null;
var _allData = [];
var currentPage = 1;
var pageSize = 20;

$(function() {
  initGrid();
  <c:if test="${not empty initCatCd}">
  $('#srchCatCd').val('${initCatCd}');
  fnChangeCat();
  </c:if>
});

function initGrid() {
  var columns = [
    { title:"대분류", field:"catNm", width:100 },
    { title:"소분류", field:"subCatNm", width:100 },
    { title:"거래", field:"dealTypeNm", width:100 },
    { title:"매물명", field:"propNm", minWidth:200,
      formatter: function(cell) {
        return '<span style="color:#1B2A4A;font-weight:600;text-decoration:underline;cursor:pointer;">' + (cell.getValue() || '') + '</span>';
      },
      cellClick: function(e, cell) {
        var d = cell.getRow().getData();
        location.href = '${ctx}/propertyMng/viewPropertyWrite?propCd=' + d.propCd;
      }
    },
    { title:"주소", field:"address", minWidth:180 },
    { title:"뱃지", field:"badgeType", width:90,
      formatter: function(cell) {
        var v = cell.getValue();
        if (v === 'RECOMMEND') return '<span class="badge" style="background:#E8830C;color:#fff;">추천</span>';
        if (v === 'URGENT') return '<span class="badge" style="background:#dc3545;color:#fff;">급매</span>';
        return '-';
      }
    },
    { title:"상태", field:"soldYn", width:100,
      editor:"list", editorParams:{ values:{ "N":"거래중", "Y":"거래완료" } },
      formatter: function(cell) {
        if (cell.getValue() === 'Y') return '<span class="badge badge-secondary">거래완료</span> <span style="color:#aaa;font-size:10px;">▼</span>';
        return '<span class="badge badge-success">거래중</span> <span style="color:#aaa;font-size:10px;">▼</span>';
      }
    },
    { title:"조회수", field:"viewCnt", width:100, hozAlign:"center" },
    { title:"삭제", field:"_del", width:80, headerSort:false,
      formatter: function() { return "<button type='button' class='btn btn-xs btn-bo-reset'>삭제</button>"; },
      cellClick: function(e, cell) { fnDeleteProp(cell.getRow()); }
    }
  ];

  propTable = TG.create("propGrid", columns, {
    height: "600px",
    pagination: false,
    layout: "fitColumns",
    trackDirty: true,
    selectable: 1
  });

  propTable.on("tableBuilt", function() { fnSearch(); });

  // 상태 변경 시 _allData 동기화
  propTable.on("cellEdited", function(cell) {
    var d = cell.getRow().getData();
    for (var i = 0; i < _allData.length; i++) {
      if (_allData[i].propCd === d.propCd) {
        _allData[i].soldYn = d.soldYn;
        _allData[i]._tgDirty = true;
        break;
      }
    }
  });
}

function fnSearch() {
  currentPage = 1;
  var res = ajaxCall('${ctx}/propertyMng/getSelectPropertyList', {
    catCd: $('#srchCatCd').val(),
    subCatCd: $('#srchSubCatCd').val(),
    dealType: $('#srchDealType').val(),
    soldYn: $('#srchSoldYn').val(),
    badgeType: $('#srchBadgeType').val(),
    keyword: $('#srchKeyword').val()
  }, false);
  _allData = (res && res.DATA) ? res.DATA : [];
  fnLoadPage();
}

function fnLoadPage() {
  var totalCnt = _allData.length;
  var start = (currentPage - 1) * pageSize;
  var pageData = _allData.slice(start, start + pageSize);
  TG.bind(propTable, pageData);
  $('#totalCntTxt').text('총 ' + totalCnt + '건');
  fnDrawPaging(totalCnt);
}

function fnDrawPaging(totalCnt) {
  var totalPage = Math.ceil(totalCnt / pageSize);
  if (totalPage < 1) totalPage = 1;
  var startPage = Math.floor((currentPage - 1) / 10) * 10 + 1;
  var endPage = Math.min(startPage + 9, totalPage);

  var html = '<nav><ul class="pagination pagination-sm">';
  html += '<li class="page-item ' + (currentPage <= 1 ? 'disabled' : '') + '"><a class="page-link" href="javascript:fnGoPage(' + (currentPage - 1) + ')">이전</a></li>';
  for (var p = startPage; p <= endPage; p++) {
    html += '<li class="page-item ' + (p === currentPage ? 'active' : '') + '"><a class="page-link" href="javascript:fnGoPage(' + p + ')">' + p + '</a></li>';
  }
  html += '<li class="page-item ' + (currentPage >= totalPage ? 'disabled' : '') + '"><a class="page-link" href="javascript:fnGoPage(' + (currentPage + 1) + ')">다음</a></li>';
  html += '</ul></nav>';
  $('#gridPaging').html(html);
}

function fnGoPage(page) {
  if (page < 1) return;
  var totalPage = Math.ceil(_allData.length / pageSize);
  if (page > totalPage) return;
  currentPage = page;
  fnLoadPage();
}

function fnGoWrite() {
  location.href = '${ctx}/propertyMng/viewPropertyWrite';
}

// 대분류 변경 시 소분류 연동 + 즉시조회
function fnChangeCat() {
  var catCd = $('#srchCatCd').val();
  var $sub = $('#srchSubCatCd');
  $sub.html('<option value="ALL">전체소분류</option>');
  if (catCd && catCd !== 'ALL') {
    var res = ajaxCall('${ctx}/propertyMng/getSubCatList', { catCd: catCd }, false);
    if (res && res.DATA) {
      $.each(res.DATA, function(i, item) {
        $sub.append('<option value="' + item.subCatCd + '">' + item.catNm + '</option>');
      });
    }
  }
  fnSearch();
}

// 상태 멀티저장
function fnSaveStatus() {
  var dirtyRows = [];
  for (var i = 0; i < _allData.length; i++) {
    if (_allData[i]._tgDirty) {
      dirtyRows.push({ propCd: _allData[i].propCd, soldYn: _allData[i].soldYn });
    }
  }
  if (dirtyRows.length === 0) { alert('변경된 데이터가 없습니다.'); return; }
  if (!confirm(dirtyRows.length + '건의 상태를 저장하시겠습니까?')) return;

  var res = ajaxCall('${ctx}/propertyMng/savePropertySoldYnList', {
    mergeRows: JSON.stringify(dirtyRows)
  }, false);

  if (res && res.resultCnt > 0) {
    alert('저장되었습니다.');
    fnSearch();
  } else {
    alert('저장 실패: ' + (res && res.Message ? res.Message : ''));
  }
}

function fnDeleteProp(row) {
  var d = row.getData();
  if (!confirm('[' + d.propNm + '] 매물을 삭제하시겠습니까?')) return;
  var res = ajaxCall('${ctx}/propertyMng/deleteProperty', { propCd: d.propCd }, false);
  if (res && res.result === 'OK') {
    alert('삭제되었습니다.');
    fnSearch();
  } else {
    alert('삭제 실패');
  }
}
</script>
