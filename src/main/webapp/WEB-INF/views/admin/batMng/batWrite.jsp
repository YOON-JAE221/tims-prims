<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<!-- Content Wrapper -->
<div class="content-wrapper">

  <!-- Content Header -->
  <div class="content-header">
    <div class="container">
      <div class="row mb-2">
        <div class="col-sm-6">
          <h4>배치관리 - <c:choose><c:when test="${not empty detail}">수정</c:when><c:otherwise>등록</c:otherwise></c:choose></h4>
        </div>
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

      <!-- 배치 정보 카드 -->
      <div class="card">
        <div class="card-header">
          <div class="row align-items-center">
            <div class="col"></div>
            <div class="col-12 col-lg-auto">
              <div class="d-flex justify-content-lg-end bo-actionbar">
                <button type="button" class="btn btn-sm btn-bo-save" onclick="fnSave()">저장</button>
                <c:if test="${not empty detail}">
                  <c:if test="${detail.manualExecYn eq 'Y'}">
                    <button type="button" class="btn btn-sm btn-dark" onclick="fnManualExec()">수동실행</button>
                  </c:if>
                  <button type="button" class="btn btn-sm btn-bo-reset" onclick="fnDelete()">삭제</button>
                </c:if>
                <button type="button" class="btn btn-sm btn-bo-reset" onclick="fnGoList()">목록</button>
              </div>
            </div>
          </div>
        </div>

        <div class="card-body">
          <form id="batForm">
            <input type="hidden" name="mode" id="mode" value="${not empty detail ? 'edit' : 'new'}" />

            <table class="table table-bordered">
              <colgroup><col style="width:160px;"><col></colgroup>
              <tbody>
                <tr>
                  <th class="bg-light">잡코드(Bean명) <span class="text-danger">*</span></th>
                  <td>
                    <c:choose>
                      <c:when test="${not empty detail}">
                        <input type="hidden" name="jobCd" id="jobCd" value="${detail.jobCd}" />
                        <span style="font-size:14px; font-family:monospace; color:#333;">${detail.jobCd}</span>
                      </c:when>
                      <c:otherwise>
                        <input type="text" name="jobCd" id="jobCd" class="form-control" maxlength="50"
                               placeholder="예: usrInfoMaskingJob" />
                      </c:otherwise>
                    </c:choose>
                  </td>
                </tr>
                <tr>
                  <th class="bg-light">잡명 <span class="text-danger">*</span></th>
                  <td>
                    <input type="text" name="jobNm" id="jobNm" class="form-control" value="${detail.jobNm}" maxlength="100" />
                  </td>
                </tr>
                <tr>
                  <th class="bg-light">잡 설명</th>
                  <td>
                    <input type="text" name="jobDesc" id="jobDesc" class="form-control" value="${detail.jobDesc}" maxlength="500" />
                  </td>
                </tr>
                <tr>
                  <th class="bg-light">크론식</th>
                  <td>
                    <div class="d-flex align-items-center" style="gap:10px;">
                      <input type="text" name="jobCron" id="jobCron" class="form-control" style="max-width:300px;"
                             value="${detail.jobCron}" maxlength="100" placeholder="예: 0 0 2 * * ?" />
                      <small class="text-muted">초 분 시 일 월 요일 (Spring 6자리)</small>
                    </div>
                    <div class="mt-1">
                      <small class="text-muted">
                        매일 02시 = <code>0 0 2 * * ?</code>
                        &nbsp;|&nbsp; 매시 정각 = <code>0 0 * * * ?</code>
                        &nbsp;|&nbsp; 매주 월 09시 = <code>0 0 9 ? * MON</code>
                      </small>
                    </div>
                  </td>
                </tr>
                <tr>
                  <th class="bg-light">수동실행 허용</th>
                  <td>
                    <label><input type="radio" name="manualExecYn" value="Y"
                      <c:if test="${empty detail or detail.manualExecYn eq 'Y'}">checked</c:if> /> 허용</label>
                    <label class="ml-3"><input type="radio" name="manualExecYn" value="N"
                      <c:if test="${detail.manualExecYn eq 'N'}">checked</c:if> /> 불가</label>
                  </td>
                </tr>
                <tr>
                  <th class="bg-light">사용여부</th>
                  <td>
                    <label><input type="radio" name="useYn" value="Y"
                      <c:if test="${empty detail or detail.useYn eq 'Y'}">checked</c:if> /> 사용</label>
                    <label class="ml-3"><input type="radio" name="useYn" value="N"
                      <c:if test="${detail.useYn eq 'N'}">checked</c:if> /> 미사용</label>
                  </td>
                </tr>
                <c:if test="${not empty detail}">
                <tr>
                  <th class="bg-light">최근실행</th>
                  <td>
                    <c:choose>
                      <c:when test="${not empty detail.lastExecDtm}">
                        <c:choose>
                          <c:when test="${detail.lastExecRslt eq 'SUCCESS'}">
                            <span class="badge bg-success">성공</span>
                          </c:when>
                          <c:when test="${detail.lastExecRslt eq 'FAIL'}">
                            <span class="badge bg-danger">실패</span>
                          </c:when>
                          <c:otherwise>
                            <span class="badge bg-warning">${detail.lastExecRslt}</span>
                          </c:otherwise>
                        </c:choose>
                        <span class="ml-2 text-muted">${detail.lastExecDtm}</span>
                      </c:when>
                      <c:otherwise>
                        <span class="text-muted">실행 이력 없음</span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                </tr>
                </c:if>
              </tbody>
            </table>
          </form>
        </div>
      </div>

      <!-- 실행 이력 카드 (수정 모드에서만) -->
      <c:if test="${not empty detail}">
      <div class="card mt-3">
        <div class="card-header">
          <div class="row align-items-center">
            <div class="col"><h6 class="mb-0">실행 이력</h6></div>
            <div class="col-auto">
              <button type="button" class="btn btn-xs btn-bo-reset" onclick="fnSearchHist()">새로고침</button>
            </div>
          </div>
        </div>
        <div class="card-body">
          <div id="sheet2"></div>
        </div>
      </div>
      </c:if>

    </div>
  </section>
</div>

<!-- 목록 이동용 -->
<form id="goListForm" action="${ctx}/batMng/viewBatMng" method="post"></form>

<script>
$(function() {
  <c:if test="${not empty detail}">
    initHistSheet();
  </c:if>
});

/* ========== 저장 ========== */
function fnSave() {
  if (!$('#jobCd').val().trim()) { alert('잡코드를 입력해 주세요.'); $('#jobCd').focus(); return; }
  if (!$('#jobNm').val().trim()) { alert('잡명을 입력해 주세요.'); $('#jobNm').focus(); return; }

  // 잡코드 형식 검증 (영문+숫자+언더스코어만)
  var jobCd = $('#jobCd').val().trim();
  if (!/^[a-zA-Z][a-zA-Z0-9_]*$/.test(jobCd)) {
    alert('잡코드는 영문으로 시작하고, 영문/숫자/언더스코어만 가능합니다.');
    $('#jobCd').focus();
    return;
  }

  var res = ajaxFormCall("${ctx}/batMng/saveBat", "#batForm", false);
  if (res && res.result === 'OK') {
    alert('저장되었습니다.');
    // 신규 등록 후 수정 모드로 전환
    if ($('#mode').val() === 'new') {
      location.href = '${ctx}/batMng/viewBatWrite?jobCd=' + jobCd;
    }
  } else {
    alert('저장 실패: ' + (res && res.message ? res.message : 'unknown'));
  }
}

/* ========== 삭제 ========== */
function fnDelete() {
  if (!confirm('이 배치를 삭제하시겠습니까?')) return;
  var res = ajaxCall("${ctx}/batMng/deleteBat", { jobCd: '${detail.jobCd}' }, false);
  if (res && res.result === 'OK') {
    alert('삭제되었습니다.');
    fnGoList();
  } else {
    alert('삭제 실패');
  }
}

/* ========== 수동실행 ========== */
function fnManualExec() {
  if (!confirm('[${detail.jobNm}] 배치를 수동 실행하시겠습니까?\n실행 후 이력에서 결과를 확인할 수 있습니다.')) return;

  var res = ajaxCall("${ctx}/batMng/manualExec", { jobCd: '${detail.jobCd}' }, false);
  if (res && res.result === 'OK') {
    alert('실행이 완료되었습니다.');
    fnSearchHist();
  } else {
    alert('실행 실패: ' + (res && res.message ? res.message : 'unknown'));
  }
}

/* ========== 목록 ========== */
function fnGoList() {
  $('#goListForm').submit();
}

/* ========== 이력 그리드 ========== */
function initHistSheet() {
  var columns = [
    {
      title:"결과",
      field:"execRslt",
      width:80,
      hozAlign:"center",
      headerHozAlign:"center",
      headerSort:false,
      formatter: function(cell) {
        var v = cell.getValue();
        if (v === 'SUCCESS') return "<span class='badge bg-success'>성공</span>";
        if (v === 'FAIL')    return "<span class='badge bg-danger'>실패</span>";
        if (v === 'RUNNING') return "<span class='badge bg-warning'>실행중</span>";
        return v || '-';
      }
    },
    {
      title:"실행방식",
      field:"execType",
      width:90,
      hozAlign:"center",
      headerHozAlign:"center",
      headerSort:false,
      formatter: function(cell) {
        return cell.getValue() === 'MANUAL'
          ? "<span class='text-primary'>수동</span>"
          : "<span class='text-muted'>자동</span>";
      }
    },
    {
      title:"실행자",
      field:"execType",
      width:80,
      hozAlign:"center",
      headerHozAlign:"center",
      headerSort:false,
      formatter: function(cell) {
        return cell.getValue() === 'MANUAL' ? '관리자' : '시스템';
      }
    },
    {
      title:"대상",
      field:"tgtCnt",
      width:70,
      hozAlign:"center",
      headerHozAlign:"center",
      headerSort:false,
      formatter: function(cell) { return (cell.getValue() != null ? cell.getValue() : 0) + '건'; }
    },
    {
      title:"처리",
      field:"procCnt",
      width:70,
      hozAlign:"center",
      headerHozAlign:"center",
      headerSort:false,
      formatter: function(cell) { return (cell.getValue() != null ? cell.getValue() : 0) + '건'; }
    },
    {
      title:"에러",
      field:"errMsg",
      width:70,
      hozAlign:"center",
      headerHozAlign:"center",
      headerSort:false,
      formatter: function(cell) {
        var v = cell.getValue();
        if (!v) return "<span class='text-muted'>-</span>";
        return "<button class='btn btn-xs btn-outline-danger'>보기</button>";
      },
      cellClick: function(e, cell) {
        var v = cell.getValue();
        if (v) alert(v);
      }
    },
    {
      title:"시작일시",
      field:"execStartDtm",
      hozAlign:"center",
      headerHozAlign:"center",
      headerSort:false
    },
    {
      title:"종료일시",
      field:"execEndDtm",
      hozAlign:"center",
      headerHozAlign:"center",
      headerSort:false,
      formatter: function(cell) { return cell.getValue() || '-'; }
    }
  ];

  window.sheet2 = TG.create("sheet2", columns, {
    height: "300px",
    pagination: false,
    layout: "fitColumns"
  });

  window.sheet2.on("tableBuilt", function() {
    fnSearchHist();
  });
}

function fnSearchHist() {
  if (window.sheet2) {
    TG.load(window.sheet2, "${ctx}/batMng/getSelectBatHistList", { jobCd: '${detail.jobCd}' }, false, "DATA");
  }
}
</script>
