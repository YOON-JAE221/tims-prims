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
        <div class="card-header">
          <div class="row align-items-center">
            <div class="col-12 col-lg mb-2 mb-lg-0"></div>
            <div class="col-12 col-lg-auto">
              <div class="d-flex justify-content-lg-end bo-actionbar">
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

<script>
$(function() {
  initSheet();
});

function initSheet() {
  var columns = [
    { title:"로그인ID", field:"loginId", minWidth:140, headerSort:false,
      formatter: function(cell) {
        return '<span style="color:#1B2A4A;font-weight:600;text-decoration:underline;cursor:pointer;">' + (cell.getValue() || '') + '</span>';
      },
      cellClick: function(e, cell) {
        var d = cell.getRow().getData();
        location.href = '${ctx}/usrMng/viewUsrWrite?usrCd=' + d.usrCd;
      }
    },
    { title:"회원명", field:"usrNm", width:140, headerSort:false },
    { title:"이메일", field:"eml", minWidth:200, headerSort:false },
    { title:"핸드폰", field:"phoneNo", width:160, hozAlign:"center", headerSort:false,
      formatter: function(cell) {
        var v = cell.getValue();
        if (!v) return '';
        v = v.replace(/-/g, '');
        if (v.length === 11) {
          return v.substring(0,3) + '-' + v.substring(3,7) + '-' + v.substring(7);
        } else if (v.length === 10) {
          return v.substring(0,3) + '-' + v.substring(3,6) + '-' + v.substring(6);
        }
        return v;
      }
    },
    { title:"성별", field:"gndrNm", width:80, hozAlign:"left", headerSort:false },
    { title:"사용여부", field:"useYn", width:120, hozAlign:"center", headerSort:false,
      formatter: function(cell) {
        if (cell.getValue() === 'Y') return '<span class="badge bg-success">사용</span>';
        return '<span class="badge bg-secondary">미사용</span>';
      }
    },
    { title:"마지막 로그인 일시", field:"lastLoginDtm", width:180, hozAlign:"left", headerSort:false }
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
  TG.load(window.sheet1, '${ctx}/usrMng/getUsrList', {}, false, "DATA");
}
</script>
