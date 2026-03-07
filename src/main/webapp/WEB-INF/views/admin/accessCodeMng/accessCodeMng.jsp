<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<div class="content-wrapper">

  <div class="content-header">
    <div class="container">
      <div class="row mb-2">
        <div class="col-sm-6"><h4>접속코드 관리</h4></div>
        <div class="col-sm-6">
          <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item active">시스템관리</li>
            <li class="breadcrumb-item">접속코드</li>
          </ol>
        </div>
      </div>
    </div>
  </div>

  <section class="content">
    <div class="container">
      <div class="card">
        <div class="card-header">
          <h5 class="card-title mb-0">사이트 접속코드 설정</h5>
        </div>
        <div class="card-body">
          <div class="form-group">
            <label><strong>접속코드</strong></label>
            <div class="input-group" style="max-width:400px;">
              <input type="text" id="accessCode" class="form-control" value="${accessCode}" maxlength="20" placeholder="접속코드 입력" />
              <div class="input-group-append">
                <button type="button" class="btn btn-bo-save" onclick="fnSave()">저장</button>
              </div>
            </div>
            <small class="text-muted mt-2 d-block">
              * 접속코드를 입력하면 사이트 방문 시 코드를 입력해야 접속할 수 있습니다.<br>
              * 접속코드를 비우고 저장하면 누구나 접속할 수 있습니다.<br>
              * 관리자 페이지(BO)는 접속코드와 무관하게 접근 가능합니다.
            </small>
          </div>
        </div>
      </div>
    </div>
  </section>

</div>

<script>
  function fnSave() {
    var code = $('#accessCode').val().trim();
    if (code && code.length < 4) {
      alert('접속코드는 4자 이상으로 설정해주세요.');
      $('#accessCode').focus();
      return;
    }
    var msg = code ? '접속코드를 "' + code + '"(으)로 설정하시겠습니까?' : '접속코드를 해제하시겠습니까?\n누구나 사이트에 접속할 수 있게 됩니다.';
    if (!confirm(msg)) return;

    var res = ajaxCall('${ctx}/accessCodeMng/saveAccessCode', { accessCode: code }, false);
    if (res && res.result === 'OK') {
      alert(code ? '접속코드가 설정되었습니다.' : '접속코드가 해제되었습니다.');
    } else {
      alert('저장 실패: ' + (res && res.message ? res.message : ''));
    }
  }
</script>
