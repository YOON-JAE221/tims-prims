<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">

  <!-- Content Header -->
  <div class="content-header">
    <div class="container">
      <div class="row mb-2">
        <div class="col-sm-6">
          <h4>문의게시판</h4>
        </div>
        <div class="col-sm-6">
          <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item active">고객지원</li>
            <li class="breadcrumb-item"><a href="${ctx}/bbs/viewBbsQna">문의게시판</a></li>
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
            <div class="col-12 col-lg mb-2 mb-lg-0">
            </div>
            <div class="col-12 col-lg-auto">
              <div class="d-flex justify-content-lg-end bo-actionbar">
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

<input type="hidden" id="brdCd" value="${brdCd}" />

<!-- BO 상세 이동용 -->
<form id="goDetailForm" action="${ctx}/bbsComQnaMng/viewBbsComWriteQna" method="post">
  <input type="hidden" name="brdCd" value="${brdCd}" />
  <input type="hidden" name="pstCd" id="detailPstCd" />
</form>

<script>
  $(function () {
    initSheet();
  });

  function initSheet() {
    var columns = [
      { title:"PST_CD", field:"pstCd", visible:false },
      { title:"BRD_CD", field:"brdCd", visible:false },
      {
        title:"제목",
        field:"pstNm",
        minWidth:350,
        headerSort:false,
        formatter: function(cell) {
          return "<span style='cursor:pointer; text-decoration:underline;'>" + cell.getValue() + "</span>";
        },
        cellClick: function(e, cell) {
          fnDetail(cell.getRow());
        }
      },
      {
        title:"작성자",
        field:"rgtUsrNm",
        width:120,
        hozAlign:"center",
        headerSort:false
      },
      {
        title:"등록일시",
        field:"rgtDtm",
        width:160,
        hozAlign:"center",
        headerSort:false
      },
      {
        title:"답변상태",
        field:"replyStatus",
        width:110,
        hozAlign:"center",
        headerSort:false,
        formatter: function(cell) {
          var val = cell.getValue();
          if (val === '답변완료') {
            return "<span class='badge bg-success'>답변완료</span>";
          } else {
            return "<span class='badge bg-warning text-dark'>대기</span>";
          }
        }
      },
      {
        title:"삭제",
        field:"_del",
        width:80,
        hozAlign:"center",
        headerSort:false,
        formatter: function () {
          return "<button type='button' class='btn btn-xs btn-bo-reset'>삭제</button>";
        },
        cellClick: function (e, cell) {
          fnDelete(cell.getRow());
        }
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

  // 조회
  function fnSearch() {
    var params = { brdCd: $('#brdCd').val() };
    TG.load(window.sheet1, "${ctx}/bbsComQnaMng/getSelectQnaPstList", params, false, "DATA");
  }

  // 삭제 (원글 + 답변 모두)
  function fnDelete(row) {
    var d = row.getData();
    var replyCnt = d.replyCnt || 0;
    var msg = replyCnt > 0
      ? "답변 " + replyCnt + "건도 함께 삭제됩니다. 삭제하시겠습니까?"
      : "삭제하시겠습니까?";

    var delRes = TG.delete(row, "${ctx}/bbsComQnaMng/deleteQnaPst", {
      brdCd: d.brdCd,
      pstCd: d.pstCd
    }, false, msg);

    if (delRes.ok) {
      alert("삭제되었습니다.");
      fnSearch();
    }
  }

  // 상세 (FO QnA 상세로 이동)
  function fnDetail(row) {
    var d = row.getData();
    $('#detailPstCd').val(d.pstCd);
    $('#goDetailForm').submit();
  }
</script>
