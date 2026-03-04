<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<!-- Content Wrapper -->
<div class="content-wrapper">

  <!-- Content Header -->
  <div class="content-header">
    <div class="container">
      <div class="row mb-2">
        <div class="col-sm-6"><h4>팝업관리</h4></div>
        <div class="col-sm-6">
          <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item active">시스템관리</li>
            <li class="breadcrumb-item"><a href="${ctx}/popMng/viewPopMng">팝업관리</a></li>
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

<!-- 상세/신규 이동용 -->
<form id="goWriteForm" action="${ctx}/popMng/viewPopWrite" method="post">
  <input type="hidden" name="popCd" id="writePopCd" />
</form>

<script>
$(function() {
  initSheet();
});

function initSheet() {
  var columns = [
    {
      title:"팝업명",
      field:"popNm",
      minWidth:120,
      headerSort:false,
      formatter: function(cell) {
        return "<span style='cursor:pointer; text-decoration:underline;'>" + (cell.getValue() || '') + "</span>";
      },
      cellClick: function(e, cell) {
        fnDetail(cell.getRow());
      }
    },
    {
      title:"사용여부",
      field:"useYn",
      width:90,
      hozAlign:"center",
      headerSort:false,
      formatter: function(cell) {
        return cell.getValue() === 'Y'
          ? "<span class='badge bg-success'>사용</span>"
          : "<span class='badge bg-secondary'>미사용</span>";
      }
    },
    {
      title:"미리보기",
      width:90,
      hozAlign:"center",
      headerSort:false,
      formatter: function() {
        return "<button class='btn btn-xs btn-dark'>미리보기</button>";
      },
      cellClick: function(e, cell) {
        fnPreviewFromList(cell.getRow().getData());
      }
    },
    {
      title:"게시시작일",
      field:"openStartDt",
      width:120,
      hozAlign:"center",
      headerSort:false,
      formatter: function(cell) {
        var v = cell.getValue() || '';
        if (v.length === 8) return v.substring(0,4) + '-' + v.substring(4,6) + '-' + v.substring(6,8);
        return v;
      }
    },
    {
      title:"게시종료일",
      field:"openEndDt",
      width:120,
      hozAlign:"center",
      headerSort:false,
      formatter: function(cell) {
        var v = cell.getValue() || '';
        if (v.length === 8) return v.substring(0,4) + '-' + v.substring(4,6) + '-' + v.substring(6,8);
        return v;
      }
    },
    {
      title:"삭제",
      field:"_del",
      width:80,
      hozAlign:"center",
      headerSort:false,
      formatter: function() {
        return "<button type='button' class='btn btn-xs btn-bo-reset'>삭제</button>";
      },
      cellClick: function(e, cell) {
        fnDeleteFromList(cell.getRow().getData());
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
  TG.load(window.sheet1, "${ctx}/popMng/getSelectPopList", {}, false, "DATA");
}

function fnWrite() {
  $('#writePopCd').val('');
  $('#goWriteForm').submit();
}

function fnDetail(row) {
  var d = row.getData();
  $('#writePopCd').val(d.popCd);
  $('#goWriteForm').submit();
}

function fnPreviewFromList(d) {
  var popCd = d.popCd;
  if (!popCd) { alert('팝업코드가 없습니다.'); return; }

  var res = ajaxCall("${ctx}/popMng/getSelectPopOne", { popCd: popCd }, false);
  var detail = res && res.DATA ? res.DATA : (res || {});
  if (!detail || !detail.popCd) { alert('팝업 데이터를 불러올 수 없습니다.'); return; }

  var w = parseInt(detail.popWidth) || 500;
  var h = parseInt(detail.popHgt) || 400;
  var x = parseInt(detail.popXLoc) || 100;
  var y = parseInt(detail.popYLoc) || 100;
  var html = detail.popCnts || '';
  var title = detail.popNm || '팝업 미리보기';

  var popup = window.open('', '_blank', 'width=' + w + ',height=' + h + ',left=' + x + ',top=' + y + ',scrollbars=yes');
  popup.document.write(fnBuildPopupHtml(title, html));
  popup.document.close();
}

function fnDeleteFromList(d) {
  if (!d.popCd) return;
  if (!confirm('[' + (d.popNm || '') + '] 팝업을 삭제하시겠습니까?')) return;
  var res = ajaxCall("${ctx}/popMng/deletePop", { popCd: d.popCd }, false);
  if (res && res.result === 'OK') {
    alert('삭제되었습니다.');
    fnSearch();
  } else {
    alert('삭제 실패');
  }
}

/* 팝업 미리보기 공통 HTML */
function fnBuildPopupHtml(title, content) {
  return '<!DOCTYPE html><html><head><meta charset="UTF-8"><title>' + title + '</title>'
    + '<style>'
    + '* { margin:0; padding:0; box-sizing:border-box; }'
    + 'html, body { height:100%; font-family:"Pretendard","Noto Sans KR","맑은 고딕",sans-serif; }'
    + 'body { display:flex; flex-direction:column; background:#f4f5f7; }'
    + '.pop-body { flex:1; overflow-y:auto; padding:28px 24px 20px; }'
    + '.pop-body img { max-width:100%; height:auto; }'
    + '.pop-footer { display:flex; align-items:center; justify-content:space-between; padding:10px 16px; background:#fff; border-top:1px solid #e0e0e0; font-size:13px; color:#666; }'
    + '.pop-footer label { cursor:pointer; display:flex; align-items:center; gap:6px; }'
    + '.pop-footer input[type=checkbox] { width:15px; height:15px; accent-color:#555; }'
    + '.pop-close { padding:6px 20px; font-size:13px; font-weight:500; color:#fff; background:#333; border:none; border-radius:4px; cursor:pointer; }'
    + '.pop-close:hover { background:#555; }'
    + '</style></head>'
    + '<body>'
    + '<div class="pop-body">' + content + '</div>'
    + '<div class="pop-footer">'
    + '  <label><input type="checkbox" /> 오늘 하루 보지 않기</label>'
    + '  <button class="pop-close" onclick="window.close()">닫기</button>'
    + '</div>'
    + '</body></html>';
}
</script>
