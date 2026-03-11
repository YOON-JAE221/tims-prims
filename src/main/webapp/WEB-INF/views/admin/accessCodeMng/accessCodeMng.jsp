<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<style>
.config-card { margin-bottom: 20px; }
.config-card .card-header { display: flex; align-items: center; gap: 8px; background: #1B2A4A; color: #fff; }
.config-card .card-header i { font-size: 16px; color: #E8830C; }
.config-card .card-body { padding: 24px; }
.config-row { display: flex; align-items: center; margin-bottom: 16px; }
.config-row:last-child { margin-bottom: 0; }
.config-label { width: 100px; font-weight: 600; color: #333; }
.config-input { flex: 1; max-width: 300px; }
.config-radio { display: flex; gap: 20px; }
.config-radio label { display: flex; align-items: center; gap: 6px; cursor: pointer; font-weight: 500; }
.config-radio input[type="radio"] { width: 16px; height: 16px; }
.config-hint { background: #f8f9fa; border-radius: 6px; padding: 12px 16px; margin-top: 16px; font-size: 13px; color: #666; line-height: 1.6; }
.config-hint i { color: #17a2b8; margin-right: 6px; }
.config-actions { display: flex; justify-content: flex-end; margin-top: 20px; padding-top: 16px; border-top: 1px solid #eee; }
</style>

<div class="content-wrapper">

  <div class="content-header">
    <div class="container">
      <div class="row mb-2">
        <div class="col-sm-6"><h4>환경설정</h4></div>
        <div class="col-sm-6">
          <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item active">시스템관리</li>
            <li class="breadcrumb-item"><a href="${ctx}/accessCodeMng/viewAccessCodeMng">환경설정</a></li>
          </ol>
        </div>
      </div>
    </div>
  </div>

  <section class="content">
    <div class="container">

      <!-- 사이트 접속 설정 -->
      <div class="card config-card">
        <div class="card-header">
          <i class="fas fa-globe"></i>
          <h5 class="card-title mb-0">사이트 접속 설정</h5>
        </div>
        <div class="card-body">
          <div class="config-row">
            <span class="config-label">사용여부</span>
            <div class="config-radio">
              <label><input type="radio" name="siteUseYn" value="Y" ${siteConfig.useYn == 'Y' ? 'checked' : ''} onchange="fnToggleInput('site')"> 사용</label>
              <label><input type="radio" name="siteUseYn" value="N" ${siteConfig.useYn != 'Y' ? 'checked' : ''} onchange="fnToggleInput('site')"> 미사용</label>
            </div>
          </div>
          <div class="config-row">
            <span class="config-label">접속코드</span>
            <div class="config-input">
              <input type="text" id="siteCode" class="form-control" value="${siteConfig.configValue}" maxlength="20" placeholder="접속코드 입력 (4자 이상)" ${siteConfig.useYn != 'Y' ? 'disabled' : ''} />
            </div>
          </div>
          <div class="config-hint">
            <i class="fas fa-info-circle"></i>
            사이트 전체에 접속코드를 설정합니다. 활성화 시 모든 방문자가 코드 입력 후 접속 가능합니다.<br>
            관리자 페이지(BO)는 접속코드와 무관하게 접근 가능합니다.
          </div>
          <div class="config-actions">
            <button type="button" class="btn btn-bo-save" onclick="fnSave('SITE_ACCESS_CODE', 'site')">저장</button>
          </div>
        </div>
      </div>

      <!-- 매물검색 접근 설정 -->
      <div class="card config-card">
        <div class="card-header">
          <i class="fas fa-search-location"></i>
          <h5 class="card-title mb-0">매물검색 접근 설정</h5>
        </div>
        <div class="card-body">
          <div class="config-row">
            <span class="config-label">사용여부</span>
            <div class="config-radio">
              <label><input type="radio" name="propSearchUseYn" value="Y" ${propSearchConfig.useYn == 'Y' ? 'checked' : ''} onchange="fnToggleInput('propSearch')"> 사용</label>
              <label><input type="radio" name="propSearchUseYn" value="N" ${propSearchConfig.useYn != 'Y' ? 'checked' : ''} onchange="fnToggleInput('propSearch')"> 미사용</label>
            </div>
          </div>
          <div class="config-row">
            <span class="config-label">접근코드</span>
            <div class="config-input">
              <input type="text" id="propSearchCode" class="form-control" value="${propSearchConfig.configValue}" maxlength="20" placeholder="접근코드 입력 (4자 이상)" ${propSearchConfig.useYn != 'Y' ? 'disabled' : ''} />
            </div>
          </div>
          <div class="config-hint">
            <i class="fas fa-info-circle"></i>
            매물검색(지도) 페이지에 접근코드를 설정합니다. 활성화 시 해당 페이지 접근 전 코드 입력이 필요합니다.
          </div>
          <div class="config-actions">
            <button type="button" class="btn btn-bo-save" onclick="fnSave('PROP_SEARCH_ACCESS_CODE', 'propSearch')">저장</button>
          </div>
        </div>
      </div>

      <!-- 매물안내 접근 설정 -->
      <div class="card config-card">
        <div class="card-header">
          <i class="fas fa-list-alt"></i>
          <h5 class="card-title mb-0">매물안내 접근 설정</h5>
        </div>
        <div class="card-body">
          <div class="config-row">
            <span class="config-label">사용여부</span>
            <div class="config-radio">
              <label><input type="radio" name="propListUseYn" value="Y" ${propListConfig.useYn == 'Y' ? 'checked' : ''} onchange="fnToggleInput('propList')"> 사용</label>
              <label><input type="radio" name="propListUseYn" value="N" ${propListConfig.useYn != 'Y' ? 'checked' : ''} onchange="fnToggleInput('propList')"> 미사용</label>
            </div>
          </div>
          <div class="config-row">
            <span class="config-label">접근코드</span>
            <div class="config-input">
              <input type="text" id="propListCode" class="form-control" value="${propListConfig.configValue}" maxlength="20" placeholder="접근코드 입력 (4자 이상)" ${propListConfig.useYn != 'Y' ? 'disabled' : ''} />
            </div>
          </div>
          <div class="config-hint">
            <i class="fas fa-info-circle"></i>
            매물안내(리스트) 페이지에 접근코드를 설정합니다. 활성화 시 해당 페이지 접근 전 코드 입력이 필요합니다.
          </div>
          <div class="config-actions">
            <button type="button" class="btn btn-bo-save" onclick="fnSave('PROP_LIST_ACCESS_CODE', 'propList')">저장</button>
          </div>
        </div>
      </div>

    </div>
  </section>

</div>

<script>
// 사용여부에 따라 입력필드 활성화/비활성화
function fnToggleInput(type) {
  var useYn = $('input[name="' + type + 'UseYn"]:checked').val();
  var $input = $('#' + type + 'Code');
  if (useYn === 'Y') {
    $input.prop('disabled', false).focus();
  } else {
    $input.prop('disabled', true);
  }
}

// 저장
function fnSave(configKey, type) {
  var useYn = $('input[name="' + type + 'UseYn"]:checked').val();
  var code = $('#' + type + 'Code').val().trim();

  // 사용인데 코드 없으면
  if (useYn === 'Y' && !code) {
    alert('접근코드를 입력해주세요.');
    $('#' + type + 'Code').focus();
    return;
  }

  // 사용인데 4자 미만이면
  if (useYn === 'Y' && code.length < 4) {
    alert('접근코드는 4자 이상으로 설정해주세요.');
    $('#' + type + 'Code').focus();
    return;
  }

  var msg = useYn === 'Y' 
    ? '접근코드를 설정하시겠습니까?\n코드: ' + code
    : '접근 제한을 해제하시겠습니까?\n누구나 접근할 수 있게 됩니다.';

  if (!confirm(msg)) return;

  var res = ajaxCall('${ctx}/accessCodeMng/saveConfig', {
    configKey: configKey,
    useYn: useYn,
    configValue: code
  }, false);

  if (res && res.result === 'OK') {
    alert(useYn === 'Y' ? '접근코드가 설정되었습니다.' : '접근 제한이 해제되었습니다.');
    location.reload();
  } else {
    alert('저장 실패: ' + (res && res.message ? res.message : ''));
  }
}
</script>
