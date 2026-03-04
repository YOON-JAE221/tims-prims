<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<!-- Content Wrapper -->
<div class="content-wrapper">

  <!-- Content Header -->
  <div class="content-header">
    <div class="container">
      <div class="row mb-2">
        <div class="col-sm-6">
          <h4>게시판관리 - <c:choose><c:when test="${not empty brd}">수정</c:when><c:otherwise>등록</c:otherwise></c:choose></h4>
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
                <button type="button" class="btn btn-sm btn-bo-save" onclick="fnSave()">저장</button>
                <button type="button" class="btn btn-sm btn-bo-reset" onclick="fnGoList()">목록</button>
              </div>
            </div>
          </div>
        </div>

        <!-- 카드 바디 -->
        <div class="card-body">
          <form id="bbsBrdForm">
            <input type="hidden" name="brdCd" id="brdCd" value="${brd.brdCd}" />
            <input type="hidden" name="brdPropBinary" id="brdPropBinary" value="${brd.brdPropBinary}" />

            <table class="table table-bordered">
              <colgroup>
                <col style="width:150px;">
                <col>
              </colgroup>
              <tbody>
                <!-- 게시판코드 -->
                <tr>
                  <th class="bg-light">게시판코드</th>
                  <td>
                    <c:choose>
                      <c:when test="${not empty brd}">
                        <span style="font-size:14px; color:#333; font-family:monospace;">${brd.brdCd}</span>
                      </c:when>
                      <c:otherwise>
                        <span style="font-size:14px; color:#999;">(저장 시 자동생성)</span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                </tr>
                <!-- 게시판명 -->
                <tr>
                  <th class="bg-light">게시판명 <span class="text-danger">*</span></th>
                  <td>
                    <input type="text" name="brdNm" id="brdNm" class="form-control" placeholder="게시판명을 입력해 주세요." value="${brd.brdNm}" maxlength="100" />
                  </td>
                </tr>
                <!-- 게시판설명 -->
                <tr>
                  <th class="bg-light">게시판설명</th>
                  <td>
                    <textarea name="brdDscr" id="brdDscr" class="form-control" rows="3" placeholder="게시판 설명을 입력해 주세요." maxlength="500">${brd.brdDscr}</textarea>
                  </td>
                </tr>
                <!-- 게시판권한 -->
                <tr>
                  <th class="bg-light">게시판권한</th>
                  <td>
                    <div class="d-flex flex-wrap" style="gap:20px;">
                      <label class="d-flex align-items-center mb-0" style="cursor:pointer;">
                        <input type="checkbox" class="brdPropChk mr-1" value="A" /> 등록구분
                      </label>
                      <label class="d-flex align-items-center mb-0" style="cursor:pointer;">
                        <input type="checkbox" class="brdPropChk mr-1" value="Q" /> 문의게시판
                      </label>
                      <label class="d-flex align-items-center mb-0" style="cursor:pointer;">
                        <input type="checkbox" class="brdPropChk mr-1" value="F" /> 첨부파일
                      </label>
                      <label class="d-flex align-items-center mb-0" style="cursor:pointer;">
                        <input type="checkbox" class="brdPropChk mr-1" value="S" /> 썸네일이미지
                      </label>
                    </div>
                  </td>
                </tr>
                <!-- 목록URL -->
                <tr>
                  <th class="bg-light">목록URL (FO)</th>
                  <td>
                    <input type="text" name="brdListUrl" id="brdListUrl" class="form-control" placeholder="/bbs/viewBbsXxx" value="${brd.brdListUrl}" maxlength="200" />
                  </td>
                </tr>
                <!-- 사용여부 -->
                <tr>
                  <th class="bg-light">사용여부</th>
                  <td>
                    <label><input type="radio" name="useYn" value="Y" <c:if test="${empty brd or brd.useYn eq 'Y'}">checked</c:if> /> 사용</label>
                    <label style="margin-left:16px;"><input type="radio" name="useYn" value="N" <c:if test="${brd.useYn eq 'N'}">checked</c:if> /> 미사용</label>
                  </td>
                </tr>
              </tbody>
            </table>
          </form>
        </div>

      </div>
    </div>
  </section>
</div>

<!-- 목록 이동용 -->
<form id="goListForm" action="${ctx}/bbsBrdMng/viewBbsBrdMng" method="post"></form>

<script>
  $(function() {
    // 기존 권한값으로 체크박스 초기화
    var prop = '${brd.brdPropBinary}' || '';
    if (prop) {
      $('.brdPropChk').each(function() {
        if (prop.indexOf($(this).val()) > -1) {
          $(this).prop('checked', true);
        }
      });
    }
  });

  /* 저장 */
  function fnSave() {
    var brdNm = $('#brdNm').val().trim();
    if (!brdNm) { alert('게시판명을 입력해 주세요.'); $('#brdNm').focus(); return; }

    // 체크박스 → brdPropBinary 조합
    var props = [];
    $('.brdPropChk:checked').each(function() {
      props.push($(this).val());
    });
    $('#brdPropBinary').val(props.join(''));

    var res = ajaxFormCall("${ctx}/bbsBrdMng/saveBbsBrd", "#bbsBrdForm", false);
    if (res && res.result === 'OK') {
      alert('저장되었습니다.');
      fnGoList();
    } else {
      alert('저장 실패: ' + (res && (res.message || res.msg) ? (res.message || res.msg) : 'unknown'));
    }
  }

  function fnGoList() {
    $('#goListForm').submit();
  }
</script>
