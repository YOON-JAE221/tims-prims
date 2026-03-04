<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/front/common/head.jsp" %>

<main id="main">

  <!-- ======= Breadcrumbs ======= -->
  <div class="breadcrumbs d-flex align-items-center">
    <div class="container position-relative d-flex flex-column align-items-center">
      <h2>${brd.brdNm}</h2>
      <ol>
        <li>고객지원</li>
      </ol>
    </div>
  </div><!-- End Breadcrumbs -->

  <!-- ======= 2컬럼 레이아웃 ======= -->
  <c:set var="activeLnb" value="qna" scope="request" />
  <div class="lnb-layout">
    <%@ include file="/WEB-INF/views/front/bbs/inc/sidebarSupport.jsp" %>

    <div class="lnb-content">
      <div class="bbsWrite">

        <h3 class="lnb-contentTitle">문의하기</h3>

        <form id="bbsWriteForm" enctype="multipart/form-data">
          <input type="hidden" name="brdCd" value="${brdCd}" />
          <input type="hidden" name="pstCd" value="${pst.pstCd}" />
          <input type="hidden" name="rgtEmail" id="rgtEmail" />
          <input type="hidden" name="rgtPhone" id="rgtPhone" />

          <table class="bbsWrite-formTable">
            <colgroup><col style="width:120px;"><col></colgroup>
            <tbody>
              <tr>
                <th>성명 <span class="required-mark">*</span></th>
                <td><input type="text" name="rgtUsrNm" id="rgtUsrNm" class="bbsWrite-input" placeholder="성명을 입력해주세요" value="${pst.rgtUsrNm}" maxlength="50" style="width:200px;" /></td>
              </tr>
              <tr>
                <th>연락처 <span class="required-mark">*</span></th>
                <td>
                  <c:if test="${not empty pst.rgtPhone}"><c:set var="phoneParts" value="${fn:split(pst.rgtPhone, '-')}" /></c:if>
                  <div class="bbsWrite-phoneRow">
                    <select name="phone1" id="phone1" class="bbsWrite-select" style="width:100px;">
                      <option value="010" ${not empty phoneParts and phoneParts[0] eq '010' ? 'selected' : ''}>010</option>
                    </select>
                    <span style="margin:0 8px;">-</span>
                    <input type="text" name="phone2" id="phone2" class="bbsWrite-input-short" value="${not empty phoneParts ? phoneParts[1] : ''}" maxlength="4" style="width:100px;" oninput="this.value=this.value.replace(/[^0-9]/g,'')" />
                    <span style="margin:0 8px;">-</span>
                    <input type="text" name="phone3" id="phone3" class="bbsWrite-input-short" value="${not empty phoneParts ? phoneParts[2] : ''}" maxlength="4" style="width:100px;" oninput="this.value=this.value.replace(/[^0-9]/g,'')" />
                  </div>
                </td>
              </tr>
              <tr>
                <th>이메일</th>
                <td>
                  <c:if test="${not empty pst.rgtEmail}"><c:set var="emailParts" value="${fn:split(pst.rgtEmail, '@')}" /></c:if>
                  <div class="bbsWrite-emailRow">
                    <input type="text" name="emailId" id="emailId" class="bbsWrite-input-short" value="${not empty emailParts ? emailParts[0] : ''}" maxlength="50" style="width:200px;" />
                    <span style="margin:0 8px;">@</span>
                    <input type="text" name="emailDomain" id="emailDomain" class="bbsWrite-input-short" value="${not empty emailParts ? emailParts[1] : ''}" maxlength="50" style="width:200px;" />
                    <select name="emailSelect" id="emailSelect" class="bbsWrite-select" onchange="fnSelectEmailDomain(this)" style="width:150px;margin-left:8px;">
                      <option value="">직접입력</option>
                      <option value="naver.com">naver.com</option>
                      <option value="gmail.com">gmail.com</option>
                      <option value="daum.net">daum.net</option>
                      <option value="hanmail.net">hanmail.net</option>
                      <option value="nate.com">nate.com</option>
                    </select>
                  </div>
                </td>
              </tr>
              <tr>
                <th>제목 <span class="required-mark">*</span></th>
                <td><input type="text" name="pstNm" id="pstNm" class="bbsWrite-input" placeholder="제목을 입력해주세요" value="${pst.pstNm}" maxlength="200" /></td>
              </tr>
              <c:choose>
                <c:when test="${empty pst.pstCd}">
                  <tr>
                    <th>비밀번호 <span class="required-mark">*</span></th>
                    <td>
                      <input type="password" name="secretPwd" id="secretPwd" class="bbsWrite-input" placeholder="비밀번호를 입력해주세요 (수정/삭제 시 필요)" value="" maxlength="20" style="width:400px;" />
                      <input type="hidden" name="secretYn" value="Y" />
                    </td>
                  </tr>
                </c:when>
                <c:otherwise><input type="hidden" name="secretYn" value="Y" /></c:otherwise>
              </c:choose>
              <tr>
                <th>문의사항 <span class="required-mark">*</span></th>
                <td><textarea name="pstCnts" id="pstCnts" class="bbsWrite-textarea" placeholder="문의하실 내용을 입력해주세요" rows="10">${pst.pstCnts}</textarea></td>
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
                    <div class="bbsWrite-fileRow"><input type="file" name="atchFile" /><button type="button" class="bbsWrite-fileRemove" onclick="fnRemoveFile(this)">삭제</button></div>
                  </div>
                  <button type="button" class="bbsWrite-fileAdd" onclick="fnAddFile()">+ 파일추가</button>
                  <p class="bbsWrite-fileGuide">* 최대 5개 파일, 파일당 10MB 이하</p>
                </td>
              </tr>
              </c:if>
            </tbody>
          </table>
        </form>

        <!-- 개인정보처리방침 (신규등록 시만) -->
        <c:if test="${empty pst.pstCd}">
        <div class="privacy-section" style="margin-top:30px;">
          <h4 class="privacy-title">개인정보 수집 및 이용 동의</h4>
          <div class="privacy-box">강한건축구조기술사사무소(이하 '회사')는 개인정보보호법에 따라 이용자의 개인정보 보호 및 권익을 보호하고, 개인정보와 관련한 이용자의 고충을 원활하게 처리할 수 있도록 다음과 같이 개인정보를 수집·이용합니다.

1. 개인정보의 수집 및 이용 목적
회사는 수집한 개인정보를 다음의 목적을 위해 활용합니다. 수집한 개인정보는 다음의 목적 이외의 용도로는 사용되지 않으며, 이용 목적이 변경될 경우에는 사전에 동의를 구할 예정입니다.
- 온라인 문의 접수 및 답변 처리
- 문의 내용에 대한 확인 및 사실조사를 위한 연락·통지
- 처리 결과 통보 및 서비스 관련 상담 처리

2. 수집하는 개인정보 항목
회사는 문의 접수를 위해 아래와 같은 개인정보를 수집합니다.
- 필수항목 : 성명, 연락처(휴대전화번호)
- 선택항목 : 이메일

3. 개인정보의 보유 및 이용 기간
회사는 개인정보 수집 및 이용 목적이 달성된 후에는 해당 정보를 지체 없이 파기합니다. 다만, 관련 법령에 따라 보존이 필요한 경우 해당 법령에서 정한 기간까지 보관합니다.
- 보유 기간 : 수집일로부터 3년
- 소비자의 불만 또는 분쟁처리에 관한 기록 : 3년 (전자상거래 등에서의 소비자보호에 관한 법률)
- 보유 기간 경과 시 해당 개인정보를 지체 없이 파기합니다.

4. 개인정보의 파기 절차 및 방법
회사는 원칙적으로 개인정보 처리 목적이 달성된 경우에는 지체 없이 해당 개인정보를 파기합니다.
- 파기 절차 : 이용자가 입력한 정보는 목적 달성 후 별도의 DB에 옮겨져 내부 방침 및 관련 법령에 따라 일정 기간 저장된 후 파기됩니다.
- 파기 방법 : 전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 파기합니다.

5. 동의 거부권 및 불이익 안내
이용자는 개인정보 수집·이용에 대한 동의를 거부할 권리가 있습니다. 다만, 필수항목에 대한 동의를 거부하실 경우 온라인 문의 접수 서비스 이용이 제한될 수 있습니다.

6. 개인정보 보호책임자
회사는 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 이용자의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.
- 성명 : 송대룡
- 직책 : 대표
- 연락처 : 010-5093-1443
- 이메일 : kanghanstr@naver.com
          </div>
          <label class="privacy-agree">
            <input type="checkbox" id="privacyAgree" />
            <span class="privacy-agree-text">개인정보 수집 및 이용에 동의합니다.</span>
          </label>
        </div>
        </c:if>

        <div class="bbsWrite-btnRow">
          <button type="button" class="bbsWrite-btn bbsWrite-btn--list" onclick="fnGoList()">취소</button>
          <button type="button" class="bbsWrite-btn bbsWrite-btn--save" onclick="fnSave()">${empty pst.pstCd ? '등록' : '수정'}</button>
        </div>

        <form id="goListForm" action="${ctx}/bbs/viewBbsQna" method="post">
          <input type="hidden" name="brdCd" value="${brdCd}" />
          <input type="hidden" name="pageNo" value="${pageNo}" />
        </form>

      </div><!-- /bbsWrite -->
    </div><!-- /lnb-content -->
  </div><!-- /lnb-layout -->

</main><!-- End #main -->


<%@ include file="/WEB-INF/views/front/common/footer.jsp" %>

<script>
  function fnSelectEmailDomain(sel) { var domain = sel.value; if (domain) { $('#emailDomain').val(domain); } }

  function fnAddFile() {
    var row = '<div class="bbsWrite-fileRow"><input type="file" name="atchFile" /><button type="button" class="bbsWrite-fileRemove" onclick="fnRemoveFile(this)">삭제</button></div>';
    $('#fileWrap').append(row);
  }
  function fnRemoveFile(btn) {
    if ($('#fileWrap .bbsWrite-fileRow').length > 1) { $(btn).closest('.bbsWrite-fileRow').remove(); } else { $(btn).siblings('input[type="file"]').val(''); }
  }

  function fnSave() {
    // 중복 클릭 방지
    var $btn = $('.bbsWrite-btn--save');
    if ($btn.prop('disabled')) return;

    // 개인정보 동의 체크 (신규등록 시)
    if ($('#privacyAgree').length && !$('#privacyAgree').is(':checked')) { alert('개인정보 수집 및 이용에 동의해주세요.'); return; }

    if (!$('#rgtUsrNm').val().trim()) { alert('성명을 입력해주세요.'); $('#rgtUsrNm').focus(); return; }
    var phone1 = $('#phone1').val(), phone2 = $('#phone2').val().trim(), phone3 = $('#phone3').val().trim();
    if (!phone2 || !phone3) { alert('연락처를 입력해주세요.'); $('#phone2').focus(); return; }
    if (phone2.length < 3 || phone2.length > 4) { alert('연락처 중간자리를 정확히 입력해주세요.'); $('#phone2').focus(); return; }
    if (phone3.length !== 4) { alert('연락처 끝자리 4자리를 입력해주세요.'); $('#phone3').focus(); return; }
    $('#rgtPhone').val(phone1 + '-' + phone2 + '-' + phone3);

    var emailId = $('#emailId').val().trim(), emailDomain = $('#emailDomain').val().trim();
    if (emailId || emailDomain) {
      if (!emailId || !emailDomain) { alert('이메일을 정확히 입력해주세요.'); $('#emailId').focus(); return; }
      var email = emailId + '@' + emailDomain;
      if (!/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/.test(email)) { alert('올바른 이메일 형식이 아닙니다.'); $('#emailId').focus(); return; }
      $('#rgtEmail').val(email);
    } else { $('#rgtEmail').val(''); }

    if (!$('#pstNm').val().trim()) { alert('제목을 입력해주세요.'); $('#pstNm').focus(); return; }
    if ($('#secretPwd').length && !$('#secretPwd').val().trim()) { alert('비밀번호를 입력해주세요.'); $('#secretPwd').focus(); return; }
    if (!$('#pstCnts').val().trim()) { alert('문의사항을 입력해주세요.'); $('#pstCnts').focus(); return; }

    var files = document.querySelectorAll('input[name="atchFile"]'), maxSize = 10*1024*1024, fileCount = 0;
    for (var i = 0; i < files.length; i++) { if (files[i].files.length > 0) { fileCount++; if (files[i].files[0].size > maxSize) { alert('파일 크기는 10MB를 초과할 수 없습니다.'); return; } } }
    if (fileCount > 5) { alert('첨부파일은 최대 5개까지 등록 가능합니다.'); return; }

    $btn.prop('disabled', true).text('처리중...');
    var res = ajaxFormCall("${ctx}/bbs/saveBbsPstQna", "#bbsWriteForm", false);
    if (res && res.result === 'OK') { alert('${empty pst.pstCd ? "문의가 등록되었습니다." : "수정되었습니다."}'); fnGoList(); }
    else { $btn.prop('disabled', false).text('${empty pst.pstCd ? "등록" : "수정"}'); alert('등록 실패: ' + (res && (res.message || res.msg) ? (res.message || res.msg) : 'unknown')); }
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
