<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<!-- Content Wrapper -->
<div class="content-wrapper">

  <!-- Content Header -->
  <div class="content-header">
    <div class="container">
      <div class="row mb-2">
        <div class="col-sm-6"><h4>배치관리</h4></div>
        <div class="col-sm-6">
          <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item active">시스템관리</li>
            <li class="breadcrumb-item"><a href="${ctx}/batMng/viewBatMng">배치관리</a></li>
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
            <div class="col-12 col-lg mb-2 mb-lg-0"></div>
            <div class="col-12 col-lg-auto">
              <div class="d-flex justify-content-lg-end bo-actionbar">
                <button type="button" class="btn btn-sm btn-bo-add" onclick="fnWrite()">신규</button>
                <button type="button" class="btn btn-sm btn-bo-reset" onclick="fnSearch()">새로고침</button>
              </div>
            </div>
          </div>
        </div>

        <div class="card-body">
          <div id="sheet1"></div>
        </div>

      </div>
    </div>
  </section>
</div>

<!-- 상세 이동용 -->
<form id="goWriteForm" action="${ctx}/batMng/viewBatWrite" method="post">
  <input type="hidden" name="jobCd" id="writeJobCd" />
</form>

<script>
$(function() {
  initSheet();
});

function initSheet() {
  var columns = [
    {
      title:"잡코드",
      field:"jobCd",
      width:180,
      headerSort:false,
      formatter: function(cell) {
        return "<span style='cursor:pointer; text-decoration:underline; font-family:monospace;'>" + (cell.getValue() || '') + "</span>";
      },
      cellClick: function(e, cell) {
        fnDetail(cell.getRow());
      }
    },
    {
      title:"잡명",
      field:"jobNm",
      minWidth:120,
      headerSort:false
    },
    {
      title:"크론식",
      field:"jobCron",
      width:140,
      hozAlign:"center",
      headerSort:false,
      formatter: function(cell) {
        return "<code>" + (cell.getValue() || '-') + "</code>";
      }
    },
    {
      title:"사용",
      field:"useYn",
      width:70,
      hozAlign:"center",
      headerSort:false,
      formatter: function(cell) {
        return cell.getValue() === 'Y'
          ? "<span class='badge bg-success'>사용</span>"
          : "<span class='badge bg-secondary'>미사용</span>";
      }
    },
    {
      title:"수동실행",
      width:90,
      hozAlign:"center",
      headerSort:false,
      formatter: function(cell) {
        var d = cell.getRow().getData();
        if (d.manualExecYn !== 'Y') return "<span class='text-muted'>-</span>";
        return "<button class='btn btn-xs btn-dark'>실행</button>";
      },
      cellClick: function(e, cell) {
        var d = cell.getRow().getData();
        if (d.manualExecYn === 'Y') fnManualExec(d.jobCd, d.jobNm);
      }
    },
    {
      title:"최근결과",
      field:"lastExecRslt",
      width:90,
      hozAlign:"center",
      headerSort:false,
      formatter: function(cell) {
        var v = cell.getValue();
        if (!v) return "<span class='text-muted'>-</span>";
        if (v === 'SUCCESS') return "<span class='badge bg-success'>성공</span>";
        if (v === 'FAIL') return "<span class='badge bg-danger'>실패</span>";
        return "<span class='badge bg-warning'>" + v + "</span>";
      }
    },
    {
      title:"최근실행일",
      field:"lastExecDtm",
      width:170,
      hozAlign:"center",
      headerSort:false,
      formatter: function(cell) {
        return cell.getValue() || '-';
      }
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
  TG.load(window.sheet1, "${ctx}/batMng/getSelectBatList", {}, false, "DATA");
}

function fnWrite() {
  $('#writeJobCd').val('');
  $('#goWriteForm').submit();
}

function fnDetail(row) {
  var d = row.getData();
  $('#writeJobCd').val(d.jobCd);
  $('#goWriteForm').submit();
}

function fnManualExec(jobCd, jobNm) {
  if (!confirm('[' + jobNm + '] 배치를 수동 실행하시겠습니까?')) return;

  var res = ajaxCall("${ctx}/batMng/manualExec", { jobCd: jobCd }, false);
  if (res && res.result === 'OK') {
    alert('실행이 완료되었습니다.');
    fnSearch();
  } else {
    alert('실행 실패: ' + (res && res.message ? res.message : 'unknown'));
  }
}
</script>
