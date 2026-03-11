<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<div class="content-wrapper">

  <div class="content-header">
    <div class="container">
      <div class="row mb-2">
        <div class="col-sm-6"><h4>부동산뉴스관리</h4></div>
        <div class="col-sm-6">
          <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item active">전시관리</li>
            <li class="breadcrumb-item"><a href="${ctx}/newsMng/viewNewsMng">부동산뉴스관리</a></li>
          </ol>
        </div>
      </div>
    </div>
  </div>

  <section class="content">
    <div class="container">
      <div class="card">
        <div class="card-header">
          <div class="row align-items-center">
            <div class="col-12 col-lg mb-2 mb-lg-0"></div>
            <div class="col-12 col-lg-auto">
              <div class="d-flex justify-content-lg-end bo-actionbar">
                <button type="button" class="btn btn-sm btn-bo-add" onclick="fnAddRow()">신규</button>
                <button type="button" class="btn btn-sm btn-bo-save" onclick="fnSave()">저장</button>
                <button type="button" class="btn btn-sm btn-bo-reset" onclick="fnReload()">새로고침</button>
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

<script>
// 커스텀 날짜 에디터 (YYYYMMDD <-> YYYY-MM-DD)
var dateEditor = function(cell, onRendered, success, cancel) {
  var input = document.createElement("input");
  input.type = "date";
  input.style.width = "100%";
  input.style.padding = "4px";
  input.style.border = "1px solid #ddd";
  input.style.borderRadius = "3px";

  // YYYYMMDD -> YYYY-MM-DD 변환
  var val = cell.getValue();
  if (val && val.length === 8) {
    input.value = val.substring(0,4) + '-' + val.substring(4,6) + '-' + val.substring(6,8);
  }

  onRendered(function() {
    input.focus();
    try { input.showPicker(); } catch(e) {}
  });

  input.addEventListener("change", function() {
    success(input.value.replace(/-/g, ''));
  });

  input.addEventListener("blur", function() {
    success(input.value.replace(/-/g, ''));
  });

  input.addEventListener("keydown", function(e) {
    if (e.keyCode === 13) success(input.value.replace(/-/g, ''));
    if (e.keyCode === 27) cancel();
  });

  return input;
};

$(function() {
  initGrid();
});

function initGrid() {
  var columns = [
    { title:"제목", field:"newsTitle", minWidth:280, headerSort:false, editor:"input", validator:["required"] },
    { title:"링크 URL", field:"newsUrl", minWidth:350, headerSort:false, editor:"input", validator:["required"],
      formatter: function(cell) {
        var v = cell.getValue();
        if (v) return '<a href="' + v + '" target="_blank" style="color:#007bff;">' + v + '</a>';
        return '';
      }
    },
    { title:"등록일", field:"rgtDt", width:120, hozAlign:"center", headerSort:false, editor:dateEditor, validator:["required"],
      formatter: function(cell) {
        var v = cell.getValue();
        if (v && v.length === 8) {
          return v.substring(0,4) + '-' + v.substring(4,6) + '-' + v.substring(6,8);
        }
        return v || '';
      }
    },
    { title:"사용여부", field:"useYn", width:100, hozAlign:"center", headerSort:false,
      editor:"list", editorParams:{ values:{ "Y":"사용", "N":"미사용" } },
      formatter: function(cell) {
        var v = cell.getValue();
        var badge = v === 'Y' ? '<span class="badge bg-success">사용</span>' : '<span class="badge bg-secondary">미사용</span>';
        return badge + ' <span style="color:#999;font-size:10px;">▼</span>';
      }
    },
    { title:"삭제", field:"_del", width:80, hozAlign:"center", headerSort:false,
      formatter: function() {
        return "<button type='button' class='btn btn-xs btn-bo-reset'>삭제</button>";
      },
      cellClick: function(e, cell) { fnDeleteRow(cell.getRow()); }
    }
  ];

  window.newsTable = TG.create("sheet1", columns, {
    height: "600px",
    pagination: false,
    layout: "fitColumns"
  });

  window.newsTable.on("tableBuilt", function() {
    fnReload();
  });
}

// 목록 조회
function fnReload() {
  if (!window.newsTable) return;
  TG.load(window.newsTable, '${ctx}/newsMng/getNewsList', {}, false, "DATA");
}

// 신규 행 추가 (오늘 날짜 디폴트)
function fnAddRow() {
  if (!window.newsTable) return;
  var today = new Date();
  var yyyy = today.getFullYear();
  var mm = String(today.getMonth() + 1).padStart(2, '0');
  var dd = String(today.getDate()).padStart(2, '0');
  var todayStr = yyyy + mm + dd;

  window.newsTable.addRow({
    newsCd: "",
    newsTitle: "",
    newsUrl: "",
    rgtDt: todayStr,
    useYn: "Y"
  }, true);
}

// 멀티저장 (TG.save)
function fnSave() {
  if (!window.newsTable) return;
  if (!TG.validate(window.newsTable)) return;

  var saveRes = TG.save(window.newsTable, '${ctx}/newsMng/saveNewsList', {});

  if (saveRes.ok) {
    alert('저장되었습니다.');
    fnReload();
  }
}

// 삭제
function fnDeleteRow(row) {
  var d = row.getData();

  // 신규 행이면 바로 삭제
  if (!d.newsCd) {
    row.delete();
    return;
  }

  // 기존 데이터면 서버 삭제
  if (!confirm('해당 뉴스를 삭제하시겠습니까?')) return;

  var res = ajaxCall('${ctx}/newsMng/deleteNews', { newsCd: d.newsCd }, false);
  if (res && res.result === 'OK') {
    alert('삭제되었습니다.');
    fnReload();
  } else {
    alert('삭제 실패');
  }
}
</script>
