<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<div class="content-wrapper">

  <div class="content-header">
    <div class="container-fluid">
      <div class="row mb-2">
        <div class="col-sm-6"><h4>매물관리</h4></div>
        <div class="col-sm-6">
          <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item active">매물관리</li>
          </ol>
        </div>
      </div>
    </div>
  </div>

  <section class="content">
    <div class="container-fluid">
      <div class="card">

        <!-- 조회조건 -->
        <div class="card-header">
          <div class="row align-items-center">
            <div class="col-12 col-lg mb-2 mb-lg-0">
              <div class="d-flex flex-wrap align-items-center" style="gap:6px;">
                <select id="srchPropType" class="form-control form-control-sm" style="width:110px;">
                  <option value="ALL">전체유형</option>
                  <option value="APT">아파트</option>
                  <option value="OFFICETEL">오피스텔</option>
                  <option value="VILLA">빌라/주택</option>
                  <option value="ONEROOM">원룸/투룸</option>
                  <option value="SHOP">상가</option>
                  <option value="OFFICE">사무실</option>
                </select>
                <select id="srchDealType" class="form-control form-control-sm" style="width:100px;">
                  <option value="ALL">전체거래</option>
                  <option value="SELL">매매</option>
                  <option value="JEONSE">전세</option>
                  <option value="WOLSE">월세</option>
                  <option value="RENT">임대</option>
                </select>
                <select id="srchBadgeType" class="form-control form-control-sm" style="width:90px;">
                  <option value="ALL">전체뱃지</option>
                  <option value="RECOMMEND">추천</option>
                  <option value="URGENT">급매</option>
                  <option value="NONE">없음</option>
                </select>
                <select id="srchSoldYn" class="form-control form-control-sm" style="width:100px;">
                  <option value="ALL">전체상태</option>
                  <option value="N">거래중</option>
                  <option value="Y">거래완료</option>
                </select>
                <input type="text" id="srchKeyword" class="form-control form-control-sm" style="width:180px;" placeholder="매물명/주소 검색" />
                <button type="button" class="btn btn-sm btn-bo-save" onclick="fnSearch()">검색</button>
              </div>
            </div>
            <div class="col-12 col-lg-auto">
              <div class="d-flex justify-content-lg-end bo-actionbar">
                <button type="button" class="btn btn-sm btn-bo-add" onclick="fnWrite()">신규</button>
                <button type="button" class="btn btn-sm btn-bo-reset" onclick="fnReset()">새로고침</button>
              </div>
            </div>
          </div>
        </div>

        <!-- 그리드 -->
        <div class="card-body p-0">
          <div class="p-2">
            <span id="totalCntTxt" style="font-size:13px; color:#666;">총 0건</span>
          </div>
          <div id="propertyGrid" style="width:100%;"></div>
        </div>

<style>
#propertyGrid .tabulator-table { width: 100% !important; }
#propertyGrid .tabulator-header { width: 100% !important; }
#propertyGrid .tabulator-row { width: 100% !important; }
</style>

        <!-- 페이징 -->
        <div class="card-footer d-flex justify-content-center">
          <div id="gridPaging"></div>
        </div>

      </div>
    </div>
  </section>

</div>

<!-- hidden forms -->
<form id="goWriteForm" action="${ctx}/propertyMng/viewPropertyWrite" method="post">
  <input type="hidden" name="propCd" id="writePropCd" />
</form>

<script>
var currentPage = 1;
var pageSize = 20;
var table;

$(function() {
  initGrid();
});

function initGrid() {
  table = new Tabulator("#propertyGrid", {
    height: "600px",
    layout: "fitColumns",
    responsiveLayout: false,
    data: [],
    columns: [
      { title: "유형", field: "propTypeNm", width: 100, hozAlign: "center", resizable: false },
      { title: "거래", field: "dealTypeNm", width: 80, hozAlign: "center", resizable: false },
      { title: "매물명", field: "propNm", widthGrow: 3,
        formatter: function(cell) {
          return '<span style="color:#1B2A4A;font-weight:600;text-decoration:underline;cursor:pointer;">' + (cell.getValue() || '') + '</span>';
        },
        cellClick: function(e, cell) {
          fnEdit(cell.getRow().getData().propCd);
        }
      },
      { title: "주소", field: "address", widthGrow: 3 },
      { title: "뱃지", field: "badgeTypeNm", width: 80, hozAlign: "center", resizable: false,
        formatter: function(cell) {
          var v = cell.getRow().getData().badgeType;
          if (v === 'RECOMMEND') return '<span style="color:#E8830C;font-weight:700;">추천</span>';
          if (v === 'URGENT') return '<span style="color:#dc3545;font-weight:700;">급매</span>';
          return '-';
        }
      },
      { title: "상태", field: "soldYnNm", width: 80, hozAlign: "center", resizable: false,
        formatter: function(cell) {
          return cell.getRow().getData().soldYn === 'Y'
            ? '<span style="color:#dc3545;font-weight:600;">완료</span>'
            : '<span style="color:#28a745;">거래중</span>';
        }
      },
      { title: "등록일", field: "rgtDtm", width: 100, hozAlign: "center", resizable: false },
      { title: "삭제", width: 60, hozAlign: "center", headerSort: false, resizable: false,
        formatter: function() { return '<button class="btn btn-xs btn-bo-reset">삭제</button>'; },
        cellClick: function(e, cell) { fnDelete(cell.getRow()); }
      }
    ]
  });

  table.on("tableBuilt", function() {
    fnSearch();
  });
}

function fnSearch() {
  currentPage = 1;
  fnLoadData();
}

function fnLoadData() {
  var param = {
    propType: $('#srchPropType').val(),
    dealType: $('#srchDealType').val(),
    badgeType: $('#srchBadgeType').val(),
    soldYn: $('#srchSoldYn').val(),
    keyword: $('#srchKeyword').val().trim(),
    pageSize: pageSize,
    offset: (currentPage - 1) * pageSize
  };

  var res = ajaxCall('${ctx}/propertyMng/getSelectPropertyList', param, false);
  if (res && res.DATA) {
    table.setData(res.DATA);
    var totalCnt = res.totalCnt || 0;
    $('#totalCntTxt').text('총 ' + totalCnt + '건');
    fnDrawPaging(totalCnt);
  }
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
  currentPage = page;
  fnLoadData();
}

function fnReset() {
  $('#srchPropType').val('ALL');
  $('#srchDealType').val('ALL');
  $('#srchBadgeType').val('ALL');
  $('#srchSoldYn').val('ALL');
  $('#srchKeyword').val('');
  fnSearch();
}

function fnWrite() {
  $('#writePropCd').val('');
  $('#goWriteForm').submit();
}

function fnEdit(propCd) {
  $('#writePropCd').val(propCd);
  $('#goWriteForm').submit();
}

function fnDelete(row) {
  if (!confirm('삭제하시겠습니까?')) return;
  var d = row.getData();
  var res = ajaxCall('${ctx}/propertyMng/deleteProperty', { propCd: d.propCd }, false);
  if (res && res.resultCnt > 0) {
    alert('삭제되었습니다.');
    fnSearch();
  } else {
    alert('삭제 실패');
  }
}

$('#srchKeyword').on('keydown', function(e) { if (e.keyCode === 13) fnSearch(); });
</script>
