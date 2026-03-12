<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<!-- Content Wrapper -->
<div class="content-wrapper">

  <!-- Content Header -->
  <div class="content-header">
    <div class="container">
      <div class="row mb-2">
        <div class="col-sm-6"><h4>발송내역</h4></div>
        <div class="col-sm-6">
          <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item active">시스템관리</li>
            <li class="breadcrumb-item"><a href="${ctx}/sendLogMng/viewSendLogMng">발송내역</a></li>
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

            <!-- 검색 영역 -->
            <div class="col-12 col-lg mb-2 mb-lg-0">
              <div class="d-flex flex-wrap align-items-center" style="gap:6px;">
                <select id="searchSendType" class="form-control form-control-sm" style="width:100px;">
                  <option value="">발송유형</option>
                  <option value="E">이메일</option>
                  <option value="S">SMS</option>
                  <option value="A">알림톡</option>
                </select>
                <select id="searchRslt" class="form-control form-control-sm" style="width:90px;">
                  <option value="">결과</option>
                  <option value="SUCCESS">성공</option>
                  <option value="FAIL">실패</option>
                </select>
                <input type="text" id="searchKeyword" class="form-control form-control-sm" style="width:200px;" placeholder="수신자/주소/제목 검색" />
                <button type="button" class="btn btn-sm btn-bo-search" onclick="fnSearch()">검색</button>
              </div>
            </div>

            <!-- 버튼 영역 -->
            <div class="col-12 col-lg-auto">
              <div class="d-flex justify-content-lg-end bo-actionbar">
                <button type="button" class="btn btn-sm btn-bo-reset" onclick="fnReset()">초기화</button>
              </div>
            </div>

          </div>
        </div>

        <div class="card-body">
          <div id="sheet1"></div>
        </div>

        <!-- 페이징 -->
        <div class="card-footer d-flex justify-content-center" style="padding:12px 0;">
          <div id="gridPaging"></div>
        </div>

      </div>
    </div>
  </section>
</div>

<!-- 에러 상세 모달 -->
<div class="modal fade" id="errModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">에러 메시지</h5>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>
      <div class="modal-body">
        <pre id="errMsgText" style="white-space:pre-wrap; word-break:break-all; max-height:400px; overflow-y:auto;"></pre>
      </div>
    </div>
  </div>
</div>

<script>
var _allData = [];
var currentPage = 1;
var pageSize = 20;

$(function() {
  initSheet();
});

function initSheet() {
  var columns = [
    {
      title:"발송유형",
      field:"sendTypeNm",
      width:85,
      hozAlign:"center",
      headerHozAlign:"center",
      headerSort:false,
      formatter: function(cell) {
        var v = cell.getRow().getData().sendType;
        var nm = cell.getValue();
        if (v === 'E') return "<span class='badge bg-primary'>" + nm + "</span>";
        if (v === 'S') return "<span class='badge bg-info'>" + nm + "</span>";
        if (v === 'A') return "<span class='badge bg-warning text-dark'>" + nm + "</span>";
        return nm;
      }
    },
    {
      title:"결과",
      field:"sendRslt",
      width:75,
      hozAlign:"center",
      headerHozAlign:"center",
      headerSort:false,
      formatter: function(cell) {
        var v = cell.getValue();
        if (v === 'SUCCESS') return "<span class='badge bg-success'>성공</span>";
        if (v === 'FAIL') return "<span class='badge bg-danger' style='cursor:pointer;'>실패</span>";
        return v;
      },
      cellClick: function(e, cell) {
        var d = cell.getRow().getData();
        if (d.sendRslt === 'FAIL' && d.errMsg) {
          $('#errMsgText').text(d.errMsg);
          $('#errModal').modal('show');
        }
      }
    },
    {
      title:"수신자",
      field:"recvNm",
      width:120,
      hozAlign:"left",
      headerSort:false,
      formatter: function(cell) {
        return cell.getValue() || '-';
      }
    },
    {
      title:"수신주소",
      field:"recvAddr",
      minWidth:180,
      hozAlign:"left",
      headerSort:false,
      formatter: function(cell) {
        return cell.getValue() || '-';
      }
    },
    {
      title:"제목",
      field:"sendTitle",
      minWidth:250,
      hozAlign:"left",
      headerSort:false,
      formatter: function(cell) {
        var v = cell.getValue();
        if (!v) return "<span class='text-muted'>-</span>";
        return "<span title='" + v.replace(/'/g, "&#39;") + "'>" + v + "</span>";
      }
    },
    {
      title:"발송일시",
      field:"creDtm",
      width:170,
      hozAlign:"center",
      headerSort:false
    }
  ];

  window.sheet1 = TG.create("sheet1", columns, {
    height: "600px",
    pagination: false,
    layout: "fitColumns"
  });

  window.sheet1.on("tableBuilt", function() {
    fnSearch();
  });
}

function fnSearch() {
  currentPage = 1;
  var param = {
    searchSendType: $('#searchSendType').val(),
    searchRslt:     $('#searchRslt').val(),
    searchKeyword:  $('#searchKeyword').val().trim()
  };
  var res = ajaxCall("${ctx}/sendLogMng/getSelectSendLogList", param, false);
  _allData = (res && res.DATA) ? res.DATA : [];
  fnLoadPage();
}

function fnLoadPage() {
  var totalCnt = _allData.length;
  var start = (currentPage - 1) * pageSize;
  var pageData = _allData.slice(start, start + pageSize);
  TG.bind(window.sheet1, pageData);
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

function fnReset() {
  $('#searchSendType').val('');
  $('#searchRslt').val('');
  $('#searchKeyword').val('');
  fnSearch();
}

/* 엔터키 검색 */
$('#searchKeyword').on('keypress', function(e) {
  if (e.which === 13) fnSearch();
});
</script>
