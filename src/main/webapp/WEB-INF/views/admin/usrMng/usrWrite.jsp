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
      <!-- 버튼 상단 -->
      <div class="d-flex justify-content-end mb-2 bo-actionbar">
        <button type="button" class="btn btn-sm btn-bo-list" onclick="fnGoList()">목록</button>
        <button type="button" class="btn btn-sm btn-bo-reset" onclick="fnResetPassword()">비밀번호 초기화</button>
        <button type="button" class="btn btn-sm btn-bo-delete" onclick="fnDelete()">삭제</button>
        <button type="button" class="btn btn-sm btn-bo-save" onclick="fnSave()">저장</button>
      </div>

      <form id="usrForm">
        <input type="hidden" name="usrCd" value="${usr.usrCd}" />

        <!-- 기본정보 -->
        <div class="card">
          <div class="card-header"><strong>기본정보</strong></div>
          <div class="card-body">
            <table class="table-form">
              <colgroup><col style="width:150px;"><col></colgroup>
              <tbody>
                <tr>
                  <th>로그인ID</th>
                  <td>
                    <input type="text" class="form-control form-control-sm" style="width:200px;" value="${usr.loginId}" readonly disabled />
                  </td>
                </tr>
                <tr>
                  <th><span class="text-danger">*</span> 회원명</th>
                  <td>
                    <input type="text" name="usrNm" class="form-control form-control-sm" style="width:200px;" value="${usr.usrNm}" required />
                  </td>
                </tr>
                <tr>
                  <th>이메일</th>
                  <td>
                    <input type="email" name="eml" class="form-control form-control-sm" style="width:300px;" value="${usr.eml}" />
                  </td>
                </tr>
                <tr>
                  <th>핸드폰번호</th>
                  <td>
                    <input type="text" name="phoneNo" class="form-control form-control-sm" style="width:200px;" value="${usr.phoneNo}" placeholder="01012345678" maxlength="11" />
                  </td>
                </tr>
                <tr>
                  <th>성별</th>
                  <td>
                    <div class="form-check form-check-inline">
                      <input class="form-check-input" type="radio" name="gndr" id="gndrM" value="M" ${usr.gndr == 'M' ? 'checked' : ''}>
                      <label class="form-check-label" for="gndrM">남자</label>
                    </div>
                    <div class="form-check form-check-inline">
                      <input class="form-check-input" type="radio" name="gndr" id="gndrF" value="F" ${usr.gndr == 'F' ? 'checked' : ''}>
                      <label class="form-check-label" for="gndrF">여자</label>
                    </div>
                  </td>
                </tr>
                <tr>
                  <th>생년월일</th>
                  <td>
                    <input type="date" name="brthDt" class="form-control form-control-sm" style="width:180px;"
                      value="${not empty usr.brthDt ? usr.brthDt.substring(0,4).concat('-').concat(usr.brthDt.substring(4,6)).concat('-').concat(usr.brthDt.substring(6,8)) : ''}" />
                  </td>
                </tr>
                <tr>
                  <th>사용여부</th>
                  <td>
                    <div class="form-check form-check-inline">
                      <input class="form-check-input" type="radio" name="useYn" id="useYnY" value="Y" ${usr.useYn == 'Y' ? 'checked' : ''}>
                      <label class="form-check-label" for="useYnY">사용</label>
                    </div>
                    <div class="form-check form-check-inline">
                      <input class="form-check-input" type="radio" name="useYn" id="useYnN" value="N" ${usr.useYn == 'N' ? 'checked' : ''}>
                      <label class="form-check-label" for="useYnN">미사용</label>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- 계정정보 -->
        <div class="card mt-3">
          <div class="card-header"><strong>계정정보</strong></div>
          <div class="card-body">
            <table class="table-form">
              <colgroup><col style="width:150px;"><col><col style="width:150px;"><col></colgroup>
              <tbody>
                <tr>
                  <th>마지막 로그인</th>
                  <td>${usr.lastLoginDtm}</td>
                  <th>로그인 실패횟수</th>
                  <td>${usr.loginErrCnt}회</td>
                </tr>
                <tr>
                  <th>로그인 제한시작</th>
                  <td>${usr.loginLimitStartDtm}</td>
                  <th>탈퇴 처리일시</th>
                  <td>${usr.wthdExeDtm}</td>
                </tr>
                <tr>
                  <th>등록일</th>
                  <td>${usr.creDtm}</td>
                  <th>수정일</th>
                  <td>${usr.updDtm}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </form>

      <!-- 버튼 하단 -->
      <div class="d-flex justify-content-end mt-3 bo-actionbar">
        <button type="button" class="btn btn-sm btn-bo-list" onclick="fnGoList()">목록</button>
        <button type="button" class="btn btn-sm btn-bo-reset" onclick="fnResetPassword()">비밀번호 초기화</button>
        <button type="button" class="btn btn-sm btn-bo-delete" onclick="fnDelete()">삭제</button>
        <button type="button" class="btn btn-sm btn-bo-save" onclick="fnSave()">저장</button>
      </div>
    </div>
  </section>
</div>

<script>
var usrCd = '${usr.usrCd}';

function fnGoList() {
  location.href = '${ctx}/usrMng/viewUsrMng';
}

function fnSave() {
  var usrNm = $('input[name="usrNm"]').val().trim();
  if (!usrNm) {
    alert('회원명을 입력해주세요.');
    $('input[name="usrNm"]').focus();
    return;
  }

  if (!confirm('저장하시겠습니까?')) return;

  // 생년월일 YYYYMMDD 변환
  var brthDt = $('input[name="brthDt"]').val();
  if (brthDt) {
    brthDt = brthDt.replace(/-/g, '');
  }

  var param = {
    usrCd: usrCd,
    usrNm: usrNm,
    eml: $('input[name="eml"]').val(),
    phoneNo: $('input[name="phoneNo"]').val().replace(/-/g, ''),
    gndr: $('input[name="gndr"]:checked').val() || '',
    brthDt: brthDt,
    useYn: $('input[name="useYn"]:checked').val() || 'Y'
  };

  var res = ajaxCall('${ctx}/usrMng/updateUsr', param, false);
  if (res && res.result === 'OK') {
    alert('저장되었습니다.');
    location.reload();
  } else {
    alert('저장 실패: ' + (res.message || ''));
  }
}

function fnDelete() {
  if (!confirm('정말 삭제하시겠습니까?\n삭제된 데이터는 복구할 수 없습니다.')) return;

  var res = ajaxCall('${ctx}/usrMng/deleteUsr', { usrCd: usrCd }, false);
  if (res && res.result === 'OK') {
    alert('삭제되었습니다.');
    fnGoList();
  } else {
    alert('삭제 실패: ' + (res.message || ''));
  }
}

function fnResetPassword() {
  if (!confirm('비밀번호를 초기화하시겠습니까?\n초기 비밀번호: primus1234')) return;

  var res = ajaxCall('${ctx}/usrMng/resetPassword', { usrCd: usrCd }, false);
  if (res && res.result === 'OK') {
    alert(res.message || '비밀번호가 초기화되었습니다.');
  } else {
    alert('초기화 실패: ' + (res.message || ''));
  }
}
</script>
