<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<style>
  .dash-card {
    border: none;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    transition: transform 0.15s;
  }
  .content-wrapper { padding-top: 20px !important; }
  .dash-card:hover { transform: translateY(-2px); }
  .dash-card .card-body { padding: 20px 24px; }
  .dash-card .dash-label { font-size: 13px; color: #888; margin-bottom: 4px; }
  .dash-card .dash-value { font-size: 28px; font-weight: 700; }
  .dash-card .dash-icon { font-size: 36px; opacity: 0.15; position: absolute; right: 20px; top: 18px; }
  .dash-card-danger { border-left: 4px solid #dc3545; }
  .dash-card-danger .dash-value { color: #dc3545; }
  .section-title {
    font-size: 15px;
    font-weight: 700;
    color: #333;
    margin-bottom: 0;
  }
</style>

<!-- Content Wrapper -->
<div class="content-wrapper">

  <!-- Main content -->
  <section class="content" style="padding-top:40px;">
    <div class="container">

      <!-- ========== 문의 요약 카드 ========== -->
      <div class="row mb-4" style="margin-top:8px;">
        <div class="col-6 col-lg-3 mb-3">
          <div class="card dash-card">
            <div class="card-body position-relative">
              <div class="dash-label">오늘 문의</div>
              <div class="dash-value">${not empty qna.todayCnt ? qna.todayCnt : 0}<small style="font-size:14px;color:#999;"> 건</small></div>
              <i class="fas fa-envelope dash-icon"></i>
            </div>
          </div>
        </div>
        <div class="col-6 col-lg-3 mb-3">
          <div class="card dash-card dash-card-danger" style="cursor:pointer;" onclick="location.href='${ctx}/bbsComQnaMng/viewBbsComQnaMng'">
            <div class="card-body position-relative">
              <div class="dash-label">미답변 문의</div>
              <div class="dash-value">${not empty qna.unansweredCnt ? qna.unansweredCnt : 0}<small style="font-size:14px;color:#999;"> 건</small></div>
              <i class="fas fa-exclamation-circle dash-icon" style="color:#dc3545;"></i>
            </div>
          </div>
        </div>
        <div class="col-6 col-lg-3 mb-3">
          <div class="card dash-card">
            <div class="card-body position-relative">
              <div class="dash-label">이번달 문의</div>
              <div class="dash-value">${not empty qna.monthCnt ? qna.monthCnt : 0}<small style="font-size:14px;color:#999;"> 건</small></div>
              <i class="fas fa-calendar-alt dash-icon"></i>
            </div>
          </div>
        </div>
        <div class="col-6 col-lg-3 mb-3">
          <div class="card dash-card">
            <div class="card-body position-relative">
              <div class="dash-label">전체 문의</div>
              <div class="dash-value">${not empty qna.totalCnt ? qna.totalCnt : 0}<small style="font-size:14px;color:#999;"> 건</small></div>
              <i class="fas fa-inbox dash-icon"></i>
            </div>
          </div>
        </div>
      </div>

      <!-- ========== 최근 문의 내역 ========== -->
      <div class="card mb-4">
        <div class="card-header d-flex align-items-center">
          <span class="section-title">최근 문의 내역</span>
          <a href="${ctx}/bbsComQnaMng/viewBbsComQnaMng" class="btn btn-xs btn-outline-secondary ml-auto">문의관리 →</a>
        </div>
        <div class="card-body p-0">
          <div id="sheetQna"></div>
        </div>
      </div>

      <!-- ========== 배치 현황 ========== -->
      <div class="card mb-4">
        <div class="card-header d-flex align-items-center">
          <span class="section-title">배치 현황</span>
          <a href="${ctx}/batMng/viewBatMng" class="btn btn-xs btn-outline-secondary ml-auto">배치관리 →</a>
        </div>
        <div class="card-body p-0">
          <div id="sheetBat"></div>
        </div>
      </div>

    </div>
  </section>

</div>

<!-- 문의 상세 이동용 -->
<form id="goQnaForm" action="${ctx}/bbsComQnaMng/viewBbsComWriteQna" method="post">
  <input type="hidden" name="pstCd" id="qnaPstCd" />
  <input type="hidden" name="brdCd" value="3ccd942dfcbf11f08771908d6ec6e544" />
</form>

<script>
$(function() {
  initQnaSheet();
  initBatSheet();
});

/* ========== 최근 문의 그리드 ========== */
function initQnaSheet() {
  var columns = [
    {
      title:"상태",
      field:"replyYn",
      width:80,
      hozAlign:"center",
      headerHozAlign:"center",
      headerSort:false,
      formatter: function(cell) {
        return cell.getValue() === 'Y'
          ? "<span class='badge bg-success'>답변완료</span>"
          : "<span class='badge bg-warning text-dark'>대기</span>";
      }
    },
    {
      title:"제목",
      field:"pstNm",
      minWidth:150,
      headerSort:false,
      formatter: function(cell) {
        return "<span style='cursor:pointer; text-decoration:underline;'>" + (cell.getValue() || '') + "</span>";
      },
      cellClick: function(e, cell) {
        var d = cell.getRow().getData();
        $('#qnaPstCd').val(d.pstCd);
        $('#goQnaForm').submit();
      }
    },
    {
      title:"작성자",
      field:"rgtUsrNm",
      width:100,
      hozAlign:"center",
      headerHozAlign:"center",
      headerSort:false
    },
    {
      title:"연락처",
      field:"rgtPhone",
      width:150,
      hozAlign:"center",
      headerHozAlign:"center",
      headerSort:false,
      formatter: function(cell) { return cell.getValue() || '-'; }
    },
    {
      title:"등록일",
      field:"rgtDtm",
      width:150,
      hozAlign:"center",
      headerHozAlign:"center",
      headerSort:false
    }
  ];

  window.sheetQna = TG.create("sheetQna", columns, {
    height: "360px",
    pagination: false,
    layout: "fitColumns"
  });

  window.sheetQna.on("tableBuilt", function() {
    TG.load(window.sheetQna, "${ctx}/admin/getRecentQnaList", {}, false, "DATA");
  });
}

/* ========== 배치 현황 그리드 ========== */
function initBatSheet() {
  var columns = [
    {
      title:"잡명",
      field:"jobNm",
      minWidth:150,
      headerSort:false
    },
    {
      title:"최근결과",
      field:"lastExecRslt",
      width:90,
      hozAlign:"center",
      headerHozAlign:"center",
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
      title:"대상",
      field:"lastTgtCnt",
      width:70,
      hozAlign:"center",
      headerHozAlign:"center",
      headerSort:false,
      formatter: function(cell) { return (cell.getValue() != null ? cell.getValue() : '-') + (cell.getValue() != null ? '건' : ''); }
    },
    {
      title:"처리",
      field:"lastProcCnt",
      width:70,
      hozAlign:"center",
      headerHozAlign:"center",
      headerSort:false,
      formatter: function(cell) { return (cell.getValue() != null ? cell.getValue() : '-') + (cell.getValue() != null ? '건' : ''); }
    },
    {
      title:"최근실행일",
      field:"lastExecDtm",
      width:170,
      hozAlign:"center",
      headerHozAlign:"center",
      headerSort:false,
      formatter: function(cell) { return cell.getValue() || '-'; }
    }
  ];

  window.sheetBat = TG.create("sheetBat", columns, {
    height: "200px",
    pagination: false,
    layout: "fitColumns"
  });

  window.sheetBat.on("tableBuilt", function() {
    TG.load(window.sheetBat, "${ctx}/admin/getBatStatusList", {}, false, "DATA");
  });
}
</script>