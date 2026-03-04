<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">

  <!-- Content Header (Page header) -->
  <div class="content-header">
    <div class="container">
      <div class="row mb-2">
        <div class="col-sm-6">
          <h4>등록 및 면허</h4>
        </div>
        <div class="col-sm-6">
          <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item active">회사소개</li>
            <li class="breadcrumb-item"><a href="${ctx}/license/viewLicense">등록 및 면허</a></li>
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
            </div>

            <!-- 우측: CRUD -->
            <div class="col-12 col-lg-auto">
              <div class="d-flex justify-content-lg-end bo-actionbar">
                <button type="button" class="btn btn-sm btn-bo-add" onclick="fnPickFile()">업로드</button>
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

	/** 업로드 input (공용) */
	var _fileInput = null;

	function initSheet() {

	  // hidden file input 세팅
	  if (!_fileInput) {
	    _fileInput = document.createElement("input");
	    _fileInput.type = "file";
	    _fileInput.accept = "image/*";   // 이미지면 유지, 제한 없애려면 제거
	    _fileInput.multiple = true;      // ✅ 여러개 선택
	    _fileInput.style.display = "none";
	    document.body.appendChild(_fileInput);

	    _fileInput.addEventListener("change", onFilesPicked);
	  }

	  var columns = [
	    { title:"liceCd", field:"liceCd", visible:false },
	    { title:"liceFileKey", field:"liceFileKey", visible:false }, // 저장 후 UPLD_FILE_CD 들어갈 자리(옵션)
	    { title:"fileFullPath", field:"fileFullPath", visible:false },

	    // 타이틀(수정 가능)
	    {
	      title:"제목",
	      field:"liceTitle",
	      minWidth:420,
	      editor:"input",
	      validator: ["required", function(cell, value){
	    	  return String(value ?? "").trim().length > 0;
	    	}]
	    },

	    // 원본파일명(FILE_NM) 표시 (수정 불가)
	    {
	      title:"파일명",
	      field:"fileNm", // == FILE_NM
	      minWidth:360,
	      headerSort:false,
	      formatter:function(cell){
    	    var v = cell.getValue();
    	    if(v){
    	      return "<span>" + escapeHtml(v) + "</span>";
    	    }
    	    return "<span style='color:#999;'>(미첨부)</span>";
    	  },
    	  cellClick:function(e, cell){
   		    var rowData = cell.getRow().getData();
   		    var fullPath = rowData.fileFullPath;   // hidden 필드
   		    // 새창으로 미리보기
   		    window.open(fullPath, "_blank", "noopener,noreferrer");
   		  }
	    },

	    // 저장용 데이터(그리드 표시 X)
	    { title:"FILE_SIZ", field:"fileSiz", visible:false },   // == FILE_SIZ (bytes)
	    { title:"FILE_EXTN", field:"fileExtn", visible:false }, // == FILE_EXTN (png/jpg...)

	    // 정렬순서(수정 가능)
	    {
	      title:"정렬순서",
	      field:"sort",
	      width:110,
	      hozAlign:"center",
	      editor:"number",
	      editorEmptyValue:null,
	      validator:["required","integer","min:0"]
	    },


	    // 삭제(흰색 버튼)
	    {
	      title: "삭제",
	      field: "_del",
	      width: 90,
	      hozAlign: "center",
	      headerSort: false,
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
	    layout: "fitColumns"  // 전체 너비 채우기
	  });

	  window.sheet1.on("tableBuilt", function(){
	    fnSearch();
	  });
	}

	/** 상단 업로드 버튼 → 파일 선택창 */
	function fnPickFile(){
	  if(!_fileInput) return;
	  _fileInput.value = "";  // 같은 파일 다시 선택 가능
	  _fileInput.click();
	}

	/** 파일 선택하면 파일 개수만큼 row 생성 */
	function onFilesPicked(){
	  if(!window.sheet1) return;
	  if(!this.files || !this.files.length) return;

	  const files = Array.from(this.files);
	  let nextSort = getNextSort(); // 정렬 자동부여(원하면 null로)

	  files.forEach(file => {
	    const extn = (file.name.split(".").pop() || "").toLowerCase();
	    const previewUrl = URL.createObjectURL(file); // 저장 전 미리보기용(로컬)

	    window.sheet1.addRow({
	      liceCd: "",
	      liceTitle: "",

	      // 저장용(요구한 3개)
	      fileNm: file.name,     // FILE_NM (원본파일명)
	      fileSiz: file.size,    // FILE_SIZ
	      fileExtn: extn,        // FILE_EXTN

	      sort: nextSort++,

	      // 저장 전 미리보기/업로드용
	      _file: file,               // 실제 저장 시 multipart로 올릴 파일
	      _previewUrl: previewUrl,   // 로컬 미리보기 URL
	      rowStatus: "I"
	    }, true);
	  });
	}

	/** 미리보기: 저장 전(_file 또는 _previewUrl) / 저장 후(liceFileKey 기반) */
	function fnPreview(row){
	  const d = row.getData();

	  // 1) 저장 전 로컬 파일 미리보기
	  if(d._previewUrl){
	    window.open(d._previewUrl, "_blank");
	    return;
	  }
	  if(d._file){
	    const url = URL.createObjectURL(d._file);
	    window.open(url, "_blank");
	    setTimeout(()=>{ try{ URL.revokeObjectURL(url); }catch(e){} }, 3000);
	    return;
	  }

	  // 2) 저장 후 서버 미리보기 (엔드포인트는 네 프로젝트에 맞게)
	  if(d.liceFileKey){
	    window.open("${ctx}/file/preview?upldFileCd=" + encodeURIComponent(d.liceFileKey) + "&fileSeq=1", "_blank");
	    return;
	  }

	  alert("미리보기할 파일이 없습니다.");
	}



	/** 다음 sort 계산 */
	function getNextSort(){
	  try{
	    const data = window.sheet1.getData ? window.sheet1.getData() : [];
	    let max = 0;
	    data.forEach(r => {
	      const v = parseInt(r.sort, 10);
	      if(!isNaN(v) && v > max) max = v;
	    });
	    return max + 1;
	  }catch(e){
	    return 1;
	  }
	}

	/** 조회/저장(연결은 네 API로) */
	function fnSearch(){
	  TG.load(window.sheet1, "${ctx}/licenseMng/getSelectLicenseList", {}, false, "DATA");
	}

	async function fnSave(){

	  // 그리드 validation 먼저 (제목 required 포함)
      if (!TG.validate(sheet1)) return;

	  try{
	    await FileUtil.uploadPendingGridFiles(sheet1, "license", "${ctx}", {
	      fileKeyField: "liceFileKey"
	    });

	    var saveRes = TG.save(sheet1, "${ctx}/licenseMng/saveLicenseMng");
	    if(saveRes && saveRes.ok){
	      alert("저장되었습니다.");
	      fnSearch();
	    }
	  }catch(e){
	    alert(e && e.message ? e.message : String(e));
	    return null;
	  }
	}


	/** 삭제 */
	function fnDelete(row){
	  const d = row.getData();

	  // 신규행이면 그냥 삭제
	  if(!d.liceCd){
	    row.delete();
	    return;
	  }
	  // TODO: 기존행은 서버 delete 호출로 변경
	  var delRes = TG.delete(row, "${ctx}/licenseMng/deleteLicenseMng", { liceCd: d.liceCd }, false);
	  if(delRes.ok){
		 alert("삭제되었습니다.");
		 fnSearch();
	  }
	}




</script>
