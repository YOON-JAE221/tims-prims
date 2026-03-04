<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">

  <!-- Content Header (Page header) -->
  <div class="content-header">
    <div class="container">
      <div class="row mb-2">
        <div class="col-sm-6">
          <h4>연혁관리</h4>
        </div>
        <div class="col-sm-6">
          <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item active">회사소개</li>
            <li class="breadcrumb-item"><a href="${ctx}/comHistory/viewComHistory">연혁관리</a></li>
          </ol>
        </div>
      </div>
    </div>
  </div>

  <!-- Main content -->
  <section class="content">
    <div class="container">
      <div class="card">

        <!-- 카드 헤더 (검색/버튼) -->
        <div class="card-header">
          <div class="row align-items-center">

            <!-- 좌측/중앙: 조회조건 -->
            <div class="col-12 col-lg mb-2 mb-lg-0">
<!--        			<h3 class="card-title mb-0 mr-3">연혁 목록</h3> -->
            </div>

            <!-- 우측: CRUD -->
            <div class="col-12 col-lg-auto">
              <div class="d-flex justify-content-lg-end bo-actionbar">
                <button type="button" class="btn btn-sm btn-bo-add" onclick="fnAddRow()">신규</button>
				<button type="button" class="btn btn-sm btn-bo-save" onclick="fnSave()">저장</button>
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

<script>
  $(function () {
	  initSheet();
  });

  function initSheet(){
	  var columns = [
	      {title:"HST_CD", field:"hstCd", visible:false},
	      {title:"년도", field:"hstYr", width:100, hozAlign:"center", editor:"number", editorEmptyValue: null, validator:["required", "integer", "min:1900", "max:2100"]},
	      {title:"내용", field:"hstCnts", minWidth:520, editor:"input", validator:[ "required", { type:function(cell, value){ return String(value ?? "").trim().length > 0; } } ]}, // 공백만 입력하면 fail
	      {title:"정렬", field:"sort", width:90, hozAlign:"center", editor:"number", editorEmptyValue: null, validator:["required", "integer", "min:0"]},
	      {
	          title: "삭제",
	          field: "_del",
	          width: 80,
	          hozAlign: "center",
	          headerSort: false,
	          formatter: function () {
	            return "<button type='button' class='btn btn-xs btn-bo-reset'>삭제</button>";
	          },
	          cellClick: function (e, cell) {
	        	 fnDelete(cell.getRow());
	          }
	       },


	    ];

	    window.sheet1 = TG.create("sheet1", columns, {
	      height: "600px",
	      pagination: false,
	      validationMode: "highlight",
	      layout: "fitColumns"
	    });
	    // 테이블 준비된 후 로드
	    window.sheet1.on("tableBuilt", function(){ fnSearch(); });
  }

  function fnAddRow() {
    if (!window.sheet1) return;
    window.sheet1.addRow({ hstCd: "", hstYr: null, hstCnts: "", sort: null }, true);
  }

  //그리드 조회
  function fnSearch(){
    TG.load(window.sheet1, "${ctx}/comHistoryMng/getSelectComHstList", {}, false, "DATA");
  }

  //그리드 저장
  function fnSave(){
	// 그리드 validation 먼저 (제목 required 포함)
    if (!TG.validate(sheet1)) return;

    var saveRes = TG.save(sheet1, "${ctx}/comHistoryMng/saveComHistoryMng");
	if(saveRes.ok){
	  alert("저장되었습니다.");
	  fnSearch();
	}
  }

  function fnDelete(row){
	var d = row.getData();
	var delRes = TG.delete(row, "${ctx}/comHistoryMng/deleteComHistoryMng", { hstCd: d.hstCd }, false);

	if(delRes.ok){
	   alert("삭제되었습니다.");
	   fnSearch();
	}
  }

</script>
