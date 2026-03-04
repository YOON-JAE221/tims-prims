<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">

  <!-- Content Header (Page header) -->
  <div class="content-header">
    <div class="container">
      <div class="row mb-2">
        <div class="col-sm-6">
          <h4>인사말</h4>
        </div>
        <div class="col-sm-6">
          <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item active">회사소개</li>
            <li class="breadcrumb-item"><a href="/greeting/viewGreeting">인사말</a></li>
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
				<button type="button" class="btn btn-sm btn-bo-save" onclick="fnSave()">저장</button>
				<button type="button" class="btn btn-sm btn-bo-reset" onclick="fnSearch()">새로고침</button>
              </div>
            </div>

          </div>
        </div>

        <div class="card-body">
          <!-- 서버에서 내려온 HTML을 안전하게 담아두기 -->
          <input type="hidden" id="pstCd" value="${pstCd}"/>
 		  <textarea id="initCnts" style="display:none;"><c:out value="${pstCnts}" escapeXml="true"/></textarea>
		  <textarea id="summernote"></textarea>
		</div>

      </div>
    </div>
  </section>
</div>

<script>
var editor = EDIT.Summernote.init({
    el: '#summernote',
    ctx: '${ctx}',
    initSelector: '#initCnts',
    height: 520
});

  function fnSave() {
    const params = { pstCd: $('#pstCd').val(), pstCnts: editor.getHTML() };
    const res = ajaxCall("${ctx}/greetingMng/saveGreetingMng", params, false);

    if (res) {
      alert('저장되었습니다.');
    } else {
      alert('저장 실패: ' + (res && (res.message || res.msg) ? (res.message || res.msg) : 'unknown'));
    }
  }

  function fnSearch() { location.reload(); }
</script>
