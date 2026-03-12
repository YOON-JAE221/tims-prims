<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<div class="content-wrapper">
  <div class="content-header">
    <div class="container">
      <div class="row mb-2">
        <div class="col-sm-6"><h4>회원관리</h4></div>
        <div class="col-sm-6">
          <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item active">시스템관리</li>
            <li class="breadcrumb-item"><a href="${ctx}/usrMng/viewUsrMng">회원관리</a></li>
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
                <select id="srchUseYn" class="form-control form-control-sm" style="width:100px;" onchange="fnSearch()">
                  <option value="ALL">전체상태</option>
                  <option value="Y" selected>사용</option>
                  <option value="N">미사용</option>
                </select>
                <input type="text" id="srchKeyword" class="form-control form-control-sm" style="width:200px;" placeholder="회원명/로그인ID 검색" onkeypress="if(event.keyCode===13) fnSearch();" />
                <button type="button" class="btn btn-sm btn-bo-search" onclick="fnSearch()">검색</button>
              </div>
            </div>
            <div class="col-12 col-lg-auto">
              <div class="d-flex justify-content-lg-end bo-actionbar">
                <button type="button" class="btn btn-sm btn-bo-reset" onclick="fnSearch()">새로고침</button>
              </div>
            </div>
          </div>
        </div>

        <!-- 그리드 -->
        <div class="card-body p-0">
          <div class="p-2">
            <span id="totalCntTxt" style="font-size:13px; color:#666;">총 0건</span>
          </div>
          <div id="usrGrid"></div>
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
var usrTable = null;
var _allData = [];
var currentPage = 1;
var pageSize = 20;

$(function() {
  initGrid();
});

function initGrid() {
  var columns = [
    { title:"로그인ID", field:"loginId", minWidth:120,
      formatter: function(cell) {
        return '<span style="color:#1B2A4A;font-weight:600;text-decoration:underline;cursor:pointer;">' + (cell.getValue() || '') + '</span>';
      },
      cellClick: function(e, cell) {
        var d = cell.getRow().getData();
        location.href = '${ctx}/usrMng/viewUsrWrite?usrCd=' + d.usrCd;
      }
    },
    { title:"회원명", field:"usrNm", width:120 },
    { title:"이메일", field:"eml", minWidth:180 },
    { title:"핸드폰", field:"phoneNo", width:130, hozAlign:"center",
      formatter: function(cell) {
        var v = cell.getValue();
        if (!v) return '';
        // 마스킹: 010-****-5678
        if (v.length >= 8) {
          return v.substring(0,3) + '-****-' + v.substring(v.length-4);
        }
        return v;
      }
    },
    { title:"성별", field:"gndrNm", width:80, hozAlign:"center" },
    { title:"사용여부", field:"useYn", width:90, hozAlign:"center",
      formatter: function(cell) {
        if (cell.getValue() === 'Y') return '<span class="badge badge-success">사용</span>';
        return '<span class="badge badge-secondary">미사용</span>';
      }
    },
    { title:"마지막로그인", field:"lastLoginDtm", width:140, hozAlign:"center" }
  ];

  usrTable = TG.create("usrGrid", columns, {
    height: "600px",
    pagination: false,
    layout: "fitColumns",
    selectable: 1
  });

  usrTable.on("tableBuilt", function() { fnSearch(); });
}

function fnSearch() {
  currentPage = 1;
  var res = ajaxCall('${ctx}/usrMng/getUsrList', {
    useYn: $('#srchUseYn').val(),
    keyword: $('#srchKeyword').val()
  }, false);
  _allData = (res && res.DATA) ? res.DATA : [];
  fnLoadPage();
}

function fnLoadPage() {
  var totalCnt = _allData.length;
  var start = (currentPage - 1) * pageSize;
  var pageData = _allData.slice(start, start + pageSize);
  TG.bind(usrTable, pageData);
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
</script>
