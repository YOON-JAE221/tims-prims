<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">

  <!-- Content Header -->
  <div class="content-header">
    <div class="container">
      <div class="row mb-2">
        <div class="col-sm-6">
          <h4>게시판관리</h4>
        </div>
        <div class="col-sm-6">
          <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item active">시스템관리</li>
            <li class="breadcrumb-item"><a href="${ctx}/bbsBrdMng/viewBbsBrdMng">게시판관리</a></li>
          </ol>
        </div>
      </div>
    </div>
  </div>

  <!-- Main content -->
  <section class="content">
    <div class="container">
      <div class="card">

        <!-- 카드 헤더 -->
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

        <!-- 카드 바디 (그리드) -->
        <div class="card-body">
          <div id="sheet1"></div>
        </div>

      </div>
    </div>
  </section>
</div>

<!-- 상세/신규 이동용 -->
<form id="goWriteForm" action="${ctx}/bbsBrdMng/viewBbsBrdWrite" method="post">
  <input type="hidden" name="brdCd" id="writeBrdCd" />
</form>

<script>
  $(function () {
    initSheet();
  });

  function initSheet() {
    var columns = [
      {
        title:"게시판코드",
        field:"brdCd",
        width:320,
        hozAlign:"center",
        headerSort:false
      },
      {
        title:"게시판명",
        field:"brdNm",
        minWidth:250,
        headerSort:false,
        formatter: function(cell) {
          return "<span style='cursor:pointer; text-decoration:underline;'>" + cell.getValue() + "</span>";
        },
        cellClick: function(e, cell) {
          fnDetail(cell.getRow());
        }
      },
      {
        title:"사용여부",
        field:"useYn",
        width:100,
        hozAlign:"center",
        headerSort:false,
        formatter: function(cell) {
          var val = cell.getValue();
          if (val === 'Y') {
            return "<span class='badge bg-success'>사용</span>";
          } else {
            return "<span class='badge bg-secondary'>미사용</span>";
          }
        }
      },
      {
        title:"목록URL",
        field:"brdListUrl",
        width:280,
        headerSort:false
      }
    ];

    window.sheet1 = TG.create("sheet1", columns, {
      height: "600px",
      pagination: false,
      validationMode: "highlight",
      layout: "fitColumns"
    });

    window.sheet1.on("tableBuilt", function () {
      fnSearch();
    });
  }

  function fnSearch() {
    TG.load(window.sheet1, "${ctx}/bbsBrdMng/getSelectBbsBrdList", {}, false, "DATA");
  }

  function fnWrite() {
    $('#writeBrdCd').val('');
    $('#goWriteForm').submit();
  }

  function fnDetail(row) {
    var d = row.getData();
    $('#writeBrdCd').val(d.brdCd);
    $('#goWriteForm').submit();
  }
</script>
