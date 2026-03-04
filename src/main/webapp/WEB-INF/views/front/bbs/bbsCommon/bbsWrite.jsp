<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="isSupport" value="${brdMenuNm eq '고객지원'}" />
<c:set var="isEngineering" value="${brdMenuNm eq 'ENGINEERING'}" />
<c:set var="hasSidebar" value="${isSupport or isEngineering}" />

<main id="main">

  <!-- ======= Breadcrumbs ======= -->
  <div class="breadcrumbs d-flex align-items-center">
    <div class="container position-relative d-flex flex-column align-items-center">
      <h2>${brd.brdNm}</h2>
      <ol>
        <li>${brdMenuNm}</li>
      </ol>
    </div>
  </div><!-- End Breadcrumbs -->

  <%-- 2컬럼 사이드바 --%>
  <c:if test="${hasSidebar}">
    <c:choose>
      <c:when test="${isSupport}">
        <c:choose>
          <c:when test="${fn:contains(listUrl, 'Notice')}"><c:set var="activeLnb" value="notice" scope="request" /></c:when>
          <c:when test="${fn:contains(listUrl, 'DataRoom')}"><c:set var="activeLnb" value="dataroom" scope="request" /></c:when>
          <c:otherwise><c:set var="activeLnb" value="notice" scope="request" /></c:otherwise>
        </c:choose>
        <div class="lnb-layout">
          <%@ include file="/WEB-INF/views/front/bbs/inc/sidebarSupport.jsp" %>
          <div class="lnb-content">
      </c:when>
      <c:when test="${isEngineering}">
        <c:choose>
          <c:when test="${fn:contains(listUrl, 'Stra')}"><c:set var="activeLnb" value="stra" scope="request" /></c:when>
          <c:when test="${fn:contains(listUrl, 'Stre')}"><c:set var="activeLnb" value="stre" scope="request" /></c:when>
          <c:when test="${fn:contains(listUrl, 'Dise')}"><c:set var="activeLnb" value="dise" scope="request" /></c:when>
          <c:when test="${fn:contains(listUrl, 'Safe')}"><c:set var="activeLnb" value="safe" scope="request" /></c:when>
          <c:when test="${fn:contains(listUrl, 'Spfe')}"><c:set var="activeLnb" value="spfe" scope="request" /></c:when>
          <c:when test="${fn:contains(listUrl, 'Tere')}"><c:set var="activeLnb" value="tere" scope="request" /></c:when>
          <c:when test="${fn:contains(listUrl, 'Vera')}"><c:set var="activeLnb" value="vera" scope="request" /></c:when>
          <c:when test="${fn:contains(listUrl, 'Sdse')}"><c:set var="activeLnb" value="sdse" scope="request" /></c:when>
          <c:otherwise><c:set var="activeLnb" value="stra" scope="request" /></c:otherwise>
        </c:choose>
        <div class="lnb-layout">
          <%@ include file="/WEB-INF/views/front/bbs/inc/sidebarEngineering.jsp" %>
          <div class="lnb-content">
      </c:when>
    </c:choose>
  </c:if>

  <!-- ======= Write ======= -->
  <section id="bbsWrite" class="bbsWrite">
    <div class="container">

      <form id="bbsWriteForm" enctype="multipart/form-data">
        <input type="hidden" name="brdCd" value="${brdCd}" />
        <input type="hidden" name="pstCd" value="${pst.pstCd}" />
        <input type="hidden" name="pstCnts" id="pstCntsHidden" />

        <table class="bbsWrite-formTable">
          <colgroup><col style="width:120px;"><col></colgroup>
          <tbody>
            <tr>
              <th>제목</th>
              <td><input type="text" name="pstNm" class="bbsWrite-input" placeholder="제목을 입력해 주세요." value="${pst.pstNm}" /></td>
            </tr>
            <c:if test="${fn:contains(brd.brdPropBinary, 'A')}">
              <tr>
                <th>등록구분</th>
                <td>
                  <label><input type="radio" name="noticeYn" value="N" checked /> 일반</label>
                  <label style="margin-left:16px;"><input type="radio" name="noticeYn" value="Y" <c:if test="${pst.noticeYn eq 'Y'}">checked</c:if> /> 공지</label>
                </td>
              </tr>
            </c:if>
            <tr>
              <th>내용</th>
              <td>
                <textarea id="initCnts" style="display:none;"><c:out value="${pst.pstCnts}" escapeXml="true"/></textarea>
                <textarea id="summernote"></textarea>
              </td>
            </tr>
            <c:if test="${fn:contains(brd.brdPropBinary, 'F')}">
              <tr>
                <th>첨부파일</th>
                <td>
                  <c:if test="${not empty fileList}">
                    <div class="bbsWrite-existFiles" id="existFileWrap">
                      <c:forEach var="file" items="${fileList}">
                        <div class="bbsWrite-fileRow" data-upld-file-cd="${file.upldFileCd}" data-file-seq="${file.fileSeq}">
                          <a href="${ctx}/file/download?upldFileCd=${file.upldFileCd}&fileSeq=${file.fileSeq}"><i class="bi bi-paperclip"></i> ${file.fileNm}</a>
                          <button type="button" class="bbsWrite-fileRemove" onclick="fnRemoveExistFile(this)">삭제</button>
                          <button type="button" class="bbsWrite-fileRestore" onclick="fnRestoreExistFile(this)" style="display:none;">취소</button>
                        </div>
                      </c:forEach>
                    </div>
                  </c:if>
                  <div class="bbsWrite-fileWrap" id="fileWrap">
                    <div class="bbsWrite-fileRow">
                      <input type="file" name="atchFile" />
                      <button type="button" class="bbsWrite-fileRemove" onclick="fnRemoveFile(this)">삭제</button>
                    </div>
                  </div>
                  <button type="button" class="bbsWrite-fileAdd" onclick="fnAddFile()">+ 파일추가</button>
                </td>
              </tr>
            </c:if>
          </tbody>
        </table>
      </form>

      <div class="bbsWrite-btnRow">
        <button type="button" class="bbsWrite-btn bbsWrite-btn--list" onclick="fnGoList()">목록</button>
        <button type="button" class="bbsWrite-btn bbsWrite-btn--save" onclick="fnSave()">저장</button>
      </div>

      <form id="goDetailForm" action="${ctx}/bbs/viewBbsDetail" method="post">
        <input type="hidden" name="brdCd" value="${brdCd}" />
        <input type="hidden" name="pstCd" id="detailPstCd" />
      </form>
      <form id="goListForm" action="${ctx}${listUrl}" method="post">
        <input type="hidden" name="brdCd" value="${brdCd}" />
        <input type="hidden" name="pageNo" value="${pageNo}" />
      </form>

    </div>
  </section>

  <%-- 레이아웃 닫기 --%>
  <c:if test="${hasSidebar}">
      </div><!-- /lnb-content -->
    </div><!-- /lnb-layout -->
  </c:if>

</main><!-- End #main -->


<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>

<script>
  const editor = EDIT.Summernote.init({ el: '#summernote', ctx: '${ctx}', initSelector: '#initCnts', height: 400 });

  function fnAddFile() {
    var row = '<div class="bbsWrite-fileRow"><input type="file" name="atchFile" /><button type="button" class="bbsWrite-fileRemove" onclick="fnRemoveFile(this)">삭제</button></div>';
    $('#fileWrap').append(row);
  }
  function fnRemoveFile(btn) {
    if ($('#fileWrap .bbsWrite-fileRow').length > 1) $(btn).closest('.bbsWrite-fileRow').remove();
    else $(btn).siblings('input[type="file"]').val('');
  }
  function fnSave() {
    var pstNm = $('input[name="pstNm"]').val().trim();
    if (!pstNm) { alert('제목을 입력해 주세요.'); $('input[name="pstNm"]').focus(); return; }
    if (!EDIT.Summernote.validateRequired(editor, '#bbsWriteForm')) { alert('내용을 입력해 주세요.'); editor.focus(); return; }
    $('#pstCntsHidden').val(editor.getHTML());
    var res = ajaxFormCall("${ctx}/bbs/saveBbsPst", "#bbsWriteForm", false);
    if (res && res.result === 'OK') { alert('저장되었습니다.'); $('#detailPstCd').val(res.pstCd); $('#goDetailForm').submit(); }
    else { alert('저장 실패: ' + (res && (res.message || res.msg) ? (res.message || res.msg) : 'unknown')); }
  }
  function fnGoList() { $('#goListForm').submit(); }
  function fnRemoveExistFile(btn) {
    var $row = $(btn).closest('.bbsWrite-fileRow');
    $row.addClass('bbsWrite-fileRow--deleted'); $row.find('a').css({'text-decoration':'line-through','color':'#999'});
    $(btn).hide(); $row.find('.bbsWrite-fileRestore').show();
    var key = $row.data('upld-file-cd') + ':' + $row.data('file-seq');
    $('#bbsWriteForm').append('<input type="hidden" name="deleteFiles" class="deleteFileInput" value="' + key + '" />');
  }
  function fnRestoreExistFile(btn) {
    var $row = $(btn).closest('.bbsWrite-fileRow');
    $row.removeClass('bbsWrite-fileRow--deleted'); $row.find('a').css({'text-decoration':'','color':''});
    $(btn).hide(); $row.find('.bbsWrite-fileRemove').show();
    var key = $row.data('upld-file-cd') + ':' + $row.data('file-seq');
    $('#bbsWriteForm .deleteFileInput').filter(function(){ return $(this).val() === key; }).remove();
  }
</script>
