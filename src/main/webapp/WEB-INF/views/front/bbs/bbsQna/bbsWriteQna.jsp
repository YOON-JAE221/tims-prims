<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>

<div class="page-header">
  <h2>문의하기</h2>
</div>

<c:set var="activeLnb" value="qna" scope="request" />
<div class="content-layout">
  <%@ include file="/WEB-INF/views/front/bbs/inc/sidebarSupport.jsp" %>

  <div class="content-main">

    <div class="board-header">
      <p style="font-size:18px; font-weight:700; color:var(--navy);">${empty pst.pstCd ? '문의 등록' : '문의 수정'}</p>
    </div>

    <form id="bbsWriteForm" enctype="multipart/form-data">
      <input type="hidden" name="brdCd" value="${brdCd}" />
      <input type="hidden" name="pstCd" value="${pst.pstCd}" />
      <input type="hidden" name="rgtPhone" id="rgtPhone" />

      <table class="qna-form-table">
        <colgroup><col style="width:130px;"><col></colgroup>
        <tbody>
          <tr>
            <th>성명 <span class="qna-required">*</span></th>
            <td><input type="text" name="rgtUsrNm" id="rgtUsrNm" class="qna-input qna-input-sm" placeholder="성명을 입력해주세요" value="${pst.rgtUsrNm}" maxlength="50" /></td>
          </tr>
          <tr>
            <th>연락처 <span class="qna-required">*</span></th>
            <td>
              <c:if test="${not empty pst.rgtPhone}"><c:set var="phoneParts" value="${fn:split(pst.rgtPhone, '-')}" /></c:if>
              <div class="qna-inline">
                <select name="phone1" id="phone1" class="qna-select">
                  <option value="010" ${not empty phoneParts and phoneParts[0] eq '010' ? 'selected' : ''}>010</option>
                </select>
                <span class="sep">-</span>
                <input type="text" name="phone2" id="phone2" class="qna-input" style="width:100px;" value="${not empty phoneParts ? phoneParts[1] : ''}" maxlength="4" oninput="this.value=this.value.replace(/[^0-9]/g,'')" />
                <span class="sep">-</span>
                <input type="text" name="phone3" id="phone3" class="qna-input" style="width:100px;" value="${not empty phoneParts ? phoneParts[2] : ''}" maxlength="4" oninput="this.value=this.value.replace(/[^0-9]/g,'')" />
              </div>
            </td>
          </tr>
          <tr>
            <th>제목 <span class="qna-required">*</span></th>
            <td><input type="text" name="pstNm" id="pstNm" class="qna-input" placeholder="제목을 입력해주세요" value="${not empty pst.pstNm ? pst.pstNm : initPstNm}" maxlength="200" /></td>
          </tr>
          <c:if test="${empty pst.pstCd}">
          <tr>
            <th>비밀번호 <span class="qna-required">*</span></th>
            <td>
              <input type="password" name="secretPwd" id="secretPwd" class="qna-input qna-input-md" placeholder="비밀번호를 입력해주세요 (수정/삭제 시 필요)" maxlength="20" />
              <input type="hidden" name="secretYn" value="Y" />
            </td>
          </tr>
          </c:if>
          <c:if test="${not empty pst.pstCd}"><input type="hidden" name="secretYn" value="Y" /></c:if>
          <tr>
            <th>문의사항 <span class="qna-required">*</span></th>
            <td><textarea name="pstCnts" id="pstCnts" class="qna-textarea" placeholder="문의하실 내용을 입력해주세요">${pst.pstCnts}</textarea></td>
          </tr>
          <c:if test="${fn:contains(brd.brdPropBinary, 'F')}">
          <tr>
            <th>첨부파일</th>
            <td>
              <c:if test="${not empty fileList}">
                <div id="existFileWrap" style="margin-bottom:10px;">
                  <c:forEach var="file" items="${fileList}">
                    <div class="qna-file-row" data-upld-file-cd="${file.upldFileCd}" data-file-seq="${file.fileSeq}">
                      <a href="${ctx}/file/download?upldFileCd=${file.upldFileCd}&fileSeq=${file.fileSeq}" style="color:var(--navy);">📎 ${file.fileNm}</a>
                      <button type="button" onclick="fnRemoveExistFile(this)" style="margin-left:8px; font-size:12px; color:#dc3545; background:none; border:none; cursor:pointer;">삭제</button>
                      <button type="button" onclick="fnRestoreExistFile(this)" style="display:none; margin-left:8px; font-size:12px; color:var(--orange); background:none; border:none; cursor:pointer;">취소</button>
                    </div>
                  </c:forEach>
                </div>
              </c:if>
              <div id="fileWrap">
                <div class="qna-file-row"><input type="file" name="atchFile" style="font-size:13px;" /></div>
              </div>
              <button type="button" class="qna-file-add" onclick="fnAddFile()">+ 파일추가</button>
              <p class="qna-file-guide">* 최대 5개 파일, 파일당 10MB 이하</p>
            </td>
          </tr>
          </c:if>
        </tbody>
      </table>
    </form>

    <!-- 개인정보 동의 -->
    <c:if test="${empty pst.pstCd}">
    <div style="margin-top:28px; padding:24px; background:var(--gray-50); border-radius:12px; border:1px solid var(--gray-100);">
      <h4 style="font-size:15px; font-weight:700; color:var(--navy); margin-bottom:12px;">개인정보 수집 및 이용 동의</h4>
      <div style="max-height:160px; overflow-y:auto; padding:16px; background:white; border:1px solid var(--gray-200); border-radius:8px; font-size:13px; color:var(--gray-500); line-height:1.8; white-space:pre-line; margin-bottom:14px;">프리머스 부동산(이하 '회사')은 개인정보보호법에 따라 이용자의 개인정보 보호 및 권익을 보호하기 위해 다음과 같이 개인정보를 수집·이용합니다.

1. 수집 목적 : 온라인 문의 접수 및 답변 처리
2. 수집 항목 : 성명, 연락처
3. 보유 기간 : 수집일로부터 3년
4. 보호책임자 : 박세환 (032-327-1277)

동의를 거부할 권리가 있으며, 동의 거부 시 문의 접수가 제한됩니다.</div>
      <label style="display:flex; align-items:center; gap:8px; cursor:pointer; font-size:14px; color:var(--gray-700); font-weight:600;">
        <input type="checkbox" id="privacyAgree" style="width:18px; height:18px; accent-color:var(--orange);" />
        개인정보 수집 및 이용에 동의합니다.
      </label>
    </div>
    </c:if>

    <div class="board-detail-btns">
      <button type="button" class="board-btn board-btn-edit" onclick="fnGoList()">취소</button>
      <button type="button" class="board-btn board-btn-list btn-save" onclick="fnSave()">${empty pst.pstCd ? '등록' : '수정'}</button>
    </div>

    <form id="goListForm" action="${ctx}/bbs/viewBbsQna" method="post">
      <input type="hidden" name="brdCd" value="${brdCd}" />
      <input type="hidden" name="pageNo" value="${pageNo}" />
    </form>

  </div>
</div>

<script>
  function fnAddFile() { $('#fileWrap').append('<div class="qna-file-row"><input type="file" name="atchFile" style="font-size:13px;" /></div>'); }
  function fnGoList() { $('#goListForm').submit(); }

  function fnRemoveExistFile(btn) {
    var $row = $(btn).closest('div[data-upld-file-cd]');
    $row.find('a').css({'text-decoration':'line-through','color':'#999'});
    $(btn).hide(); $row.find('[onclick*="fnRestoreExistFile"]').show();
    var key = $row.data('upld-file-cd') + ':' + $row.data('file-seq');
    $('#bbsWriteForm').append('<input type="hidden" name="deleteFiles" class="deleteFileInput" value="' + key + '" />');
  }
  function fnRestoreExistFile(btn) {
    var $row = $(btn).closest('div[data-upld-file-cd]');
    $row.find('a').css({'text-decoration':'','color':''});
    $(btn).hide(); $row.find('[onclick*="fnRemoveExistFile"]').show();
    var key = $row.data('upld-file-cd') + ':' + $row.data('file-seq');
    $('#bbsWriteForm .deleteFileInput').filter(function(){ return $(this).val() === key; }).remove();
  }

  function fnSave() {
    var $btn = $('.btn-save');
    if ($btn.prop('disabled')) return;
    if ($('#privacyAgree').length && !$('#privacyAgree').is(':checked')) { alert('개인정보 수집 및 이용에 동의해주세요.'); return; }
    if (!$('#rgtUsrNm').val().trim()) { alert('성명을 입력해주세요.'); $('#rgtUsrNm').focus(); return; }
    var p2 = $('#phone2').val().trim(), p3 = $('#phone3').val().trim();
    if (!p2 || !p3) { alert('연락처를 입력해주세요.'); $('#phone2').focus(); return; }
    $('#rgtPhone').val($('#phone1').val() + '-' + p2 + '-' + p3);
    if (!$('#pstNm').val().trim()) { alert('제목을 입력해주세요.'); $('#pstNm').focus(); return; }
    if ($('#secretPwd').length && !$('#secretPwd').val().trim()) { alert('비밀번호를 입력해주세요.'); $('#secretPwd').focus(); return; }
    if (!$('#pstCnts').val().trim()) { alert('문의사항을 입력해주세요.'); $('#pstCnts').focus(); return; }

    $btn.prop('disabled', true).text('처리중...');
    var res = ajaxFormCall("${ctx}/bbs/saveBbsPstQna", "#bbsWriteForm", false);
    if (res && res.result === 'OK') { alert('${empty pst.pstCd ? "문의가 등록되었습니다." : "수정되었습니다."}'); fnGoList(); }
    else { $btn.prop('disabled', false).text('${empty pst.pstCd ? "등록" : "수정"}'); alert('등록 실패'); }
  }
</script>

<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>
</body>
</html>
