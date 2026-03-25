<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<!-- Summernote (이 페이지에서만 로드) -->
<link rel="stylesheet" href="${ctx}/resources/common/summernote/css/admin/summernote-bs4.min.css" />
<script src="${ctx}/resources/common/summernote/js/admin/summernote-bs4.min.js" charset="UTF-8"></script>
<script src="${ctx}/resources/common/summernote/js/summernote-ko-KR.min.js" charset="UTF-8"></script>
<script src="${ctx}/resources/common/summernote/js/summernote-editor-common.js" charset="UTF-8"></script>
<!-- SortableJS (드래그 순서 변경) -->
<script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>

<div class="content-wrapper">
  <div class="content-header">
    <div class="container">
      <div class="row mb-2">
        <div class="col-sm-6"><h4>${empty prop ? '매물 등록' : '매물 수정'}</h4></div>
        <div class="col-sm-6">
          <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item active">매물관리</li>
            <li class="breadcrumb-item"><a href="${ctx}/propertyMng/viewPropertyMng">매물관리</a></li>
            <li class="breadcrumb-item">${empty prop ? '등록' : '수정'}</li>
          </ol>
        </div>
      </div>
    </div>
  </div>

  <section class="content">
    <div class="container">
      <form id="propForm" enctype="multipart/form-data">
        <input type="hidden" name="propCd" value="${prop.propCd}" />

        <!-- ===== 상단 버튼 ===== -->
        <div style="display:flex; justify-content:flex-end; gap:8px; margin-bottom:16px;">
          <button type="button" class="btn btn-bo-reset" onclick="fnGoList()">목록</button>
          <button type="button" class="btn btn-bo-reset" onclick="fnRefresh()">새로고침</button>
          <c:if test="${not empty prop}">
            <button type="button" class="btn btn-bo-del" onclick="fnDelete()">삭제</button>
          </c:if>
          <c:if test="${not empty prop and prop.soldYn ne 'Y'}">
            <button type="button" class="btn btn-bo-copy" onclick="fnCopy()">복사</button>
            <button type="button" class="btn btn-bo-save" onclick="fnSave()">저장</button>
            <button type="button" class="btn btn-danger" onclick="fnComplete()">거래완료</button>
          </c:if>
          <c:if test="${empty prop}">
            <button type="button" class="btn btn-bo-save" onclick="fnSave()">저장</button>
          </c:if>
        </div>

        <!-- ===== 0. 관리정보 (맨 위) ===== -->
        <div class="card">
          <div class="card-header"><h5 class="card-title mb-0">관리정보</h5></div>
          <div class="card-body">
            <table class="table table-bordered bo-form-table">
              <tr>
                <th>등록자</th>
                <td><c:out value="${not empty prop.creUsrNm ? prop.creUsrNm : ssnUsrNm}" /></td>
                <th>등록일시</th>
                <td><c:out value="${not empty prop.creDtmFmt ? prop.creDtmFmt : '-'}" /></td>
              </tr>
              <tr>
                <th>관리자 메모</th>
                <td colspan="3"><textarea name="adminMemo" class="form-control form-control-sm" rows="2" placeholder="비공개 메모">${prop.adminMemo}</textarea></td>
              </tr>
            </table>
          </div>
        </div>

        <!-- ===== 1. 기본정보 ===== -->
        <div class="card">
          <div class="card-header"><h5 class="card-title mb-0">기본정보</h5></div>
          <div class="card-body">
            <table class="table table-bordered bo-form-table">
              <tr>
                <th style="width:100px;">분류 <span class="text-danger">*</span></th>
                <td colspan="3">
                  <div class="d-flex align-items-center" style="gap:12px;">
                    <div class="d-flex align-items-center" style="gap:4px;">
                      <span style="font-size:12px; color:#666;">대분류</span>
                      <select name="catCd" id="catCd" class="form-control form-control-sm" style="width:130px;" onchange="fnCatChange(this.value)" required>
                        <option value="">선택</option>
                        <c:forEach var="cat" items="${catList}">
                          <option value="${cat.catCd}" ${prop.catCd eq cat.catCd ? 'selected' : ''}>${cat.catNm}</option>
                        </c:forEach>
                      </select>
                    </div>
                    <div class="d-flex align-items-center" style="gap:4px;">
                      <span style="font-size:12px; color:#666;">중분류</span>
                      <select name="midCatCd" id="midCatCd" class="form-control form-control-sm" style="width:130px;" onchange="fnMidCatChange(this.value)">
                        <option value="">선택</option>
                      </select>
                    </div>
                    <div class="d-flex align-items-center" style="gap:4px;">
                      <span style="font-size:12px; color:#666;">소분류</span>
                      <select name="subCatCd" id="subCatCd" class="form-control form-control-sm" style="width:130px;">
                        <option value="">선택</option>
                      </select>
                    </div>
                  </div>
                </td>
              </tr>
              <tr>
                <th>거래종류 <span class="text-danger">*</span></th>
                <td colspan="3">
                  <label class="mr-3"><input type="radio" name="dealType" value="SELL" ${empty prop.dealType || prop.dealType eq 'SELL' ? 'checked' : ''} /> 매매</label>
                  <label class="mr-3"><input type="radio" name="dealType" value="JEONSE" ${prop.dealType eq 'JEONSE' ? 'checked' : ''} /> 전세</label>
                  <label class="mr-3"><input type="radio" name="dealType" value="WOLSE" ${prop.dealType eq 'WOLSE' ? 'checked' : ''} /> 월세</label>
                  <label><input type="radio" name="dealType" value="SHORT" ${prop.dealType eq 'SHORT' ? 'checked' : ''} /> 단기임대</label>
                </td>
              </tr>
              <tr>
                <th>매물명 <span class="text-danger">*</span></th>
                <td colspan="3"><input type="text" name="propNm" class="form-control form-control-sm" value="${prop.propNm}" maxlength="100" required /></td>
              </tr>
              <tr>
                <th>매물특징</th>
                <td colspan="3"><input type="text" name="propFeature" class="form-control form-control-sm" value="${prop.propFeature}" maxlength="100" placeholder="리스트에 노출되는 한줄 요약 (40자 권장)" /></td>
              </tr>
            </table>
          </div>
        </div>

        <!-- ===== 2. 매물소재지 ===== -->
        <div class="card">
          <div class="card-header"><h5 class="card-title mb-0">매물소재지</h5></div>
          <div class="card-body">
            <div class="row">
              <!-- 좌측: 입력 -->
              <div class="col-lg-6">
                <div class="form-group">
                  <label><strong>주소</strong> <span class="text-danger">*</span></label>
                  <div class="d-flex" style="gap:8px;">
                    <input type="text" name="address" id="address" class="form-control form-control-sm" value="${prop.address}" placeholder="주소 검색" readonly style="flex:1;" />
                    <button type="button" class="btn btn-sm btn-bo-save" onclick="fnSearchAddr()">주소 검색</button>
                  </div>
                </div>
                <div class="form-group">
                  <label>상세주소</label>
                  <input type="text" name="addressDtl" class="form-control form-control-sm" value="${prop.addressDtl}" placeholder="상세주소 입력 (동/호수 등)" />
                </div>
                <input type="hidden" name="lat" id="lat" value="${prop.lat}" />
                <input type="hidden" name="lng" id="lng" value="${prop.lng}" />
                <div class="form-group">
                  <label>건물명</label>
                  <input type="text" name="buildingNm" class="form-control form-control-sm" value="${prop.buildingNm}" />
                </div>
              </div>
              <!-- 우측: 지도 미리보기 -->
              <div class="col-lg-6">
                <label><strong>지도 미리보기</strong></label>
                <div id="mapPreview" style="width:100%; height:280px; border:1px solid #dee2e6; border-radius:4px; background:#f5f5f5; display:flex; align-items:center; justify-content:center; color:#aaa;">
                  <c:if test="${empty prop.lat}">주소를 검색하면 지도가 표시됩니다</c:if>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- ===== 3. 가격정보 ===== -->
        <div class="card">
          <div class="card-header"><h5 class="card-title mb-0">가격정보 <small class="text-muted">(만원 단위 입력)</small></h5></div>
          <div class="card-body">
            <table class="table table-bordered bo-form-table">
              <tr>
                <th>매매가 <small class="text-muted">(만원)</small></th>
                <td><input type="number" name="sellPrice" class="form-control form-control-sm" value="${prop.sellPrice}" /></td>
                <th>보증금/전세가 <small class="text-muted">(만원)</small></th>
                <td><input type="number" name="deposit" class="form-control form-control-sm" value="${prop.deposit}" /></td>
              </tr>
              <tr>
                <th>월세 <small class="text-muted">(만원)</small></th>
                <td><input type="number" name="monthlyRent" class="form-control form-control-sm" value="${prop.monthlyRent}" /></td>
                <th>월관리비 <small class="text-muted">(만원)</small></th>
                <td><input type="number" name="monthlyMgmt" class="form-control form-control-sm" value="${prop.monthlyMgmt}" /></td>
              </tr>
              <tr>
                <th>권리금 <small class="text-muted">(만원)</small></th>
                <td><input type="number" name="premium" class="form-control form-control-sm" value="${prop.premium}" /></td>
                <th>융자금 <small class="text-muted">(만원)</small></th>
                <td>
                  <div class="d-flex" style="gap:8px;">
                    <select name="loanYn" class="form-control form-control-sm" style="width:100px;">
                      <option value="N" ${empty prop.loanYn || prop.loanYn eq 'N' ? 'selected' : ''}>없음</option>
                      <option value="Y" ${prop.loanYn eq 'Y' ? 'selected' : ''}>있음</option>
                    </select>
                    <input type="number" name="loanAmount" class="form-control form-control-sm" value="${prop.loanAmount}" placeholder="융자금액" style="width:150px;" />
                  </div>
                </td>
              </tr>
            </table>
          </div>
        </div>

        <!-- ===== 4. 매물정보 ===== -->
        <div class="card">
          <div class="card-header"><h5 class="card-title mb-0">매물정보</h5></div>
          <div class="card-body">
            <table class="table table-bordered bo-form-table">
              <tr>
                <th>공급면적 <small class="text-muted">(㎡)</small></th>
                <td><input type="number" step="0.01" name="areaSupply" class="form-control form-control-sm" value="${prop.areaSupply}" /></td>
                <th>전용면적 <small class="text-muted">(㎡)</small></th>
                <td><input type="number" step="0.01" name="areaExclusive" class="form-control form-control-sm" value="${prop.areaExclusive}" /></td>
              </tr>
              <tr>
                <th>대지면적 <small class="text-muted">(㎡)</small></th>
                <td><input type="number" step="0.01" name="areaLand" class="form-control form-control-sm" value="${prop.areaLand}" /></td>
                <th>연면적 <small class="text-muted">(㎡)</small></th>
                <td><input type="number" step="0.01" name="areaTotal" class="form-control form-control-sm" value="${prop.areaTotal}" /></td>
              </tr>
              <tr>
                <th>용도지역</th>
                <td><input type="text" name="zoneType" class="form-control form-control-sm" value="${prop.zoneType}" placeholder="예: 제2종일반주거지역" /></td>
                <th>도로폭</th>
                <td><input type="text" name="roadWidth" class="form-control form-control-sm" value="${prop.roadWidth}" placeholder="예: 8m" /></td>
              </tr>
              <tr>
                <th>해당층</th>
                <td><input type="text" name="floorNo" class="form-control form-control-sm" value="${prop.floorNo}" placeholder="예: 5, B1" /></td>
                <th>총층</th>
                <td><input type="number" name="floorTotal" class="form-control form-control-sm" value="${prop.floorTotal}" /></td>
              </tr>
              <tr>
                <th>방수</th>
                <td><input type="number" name="roomCnt" class="form-control form-control-sm" value="${prop.roomCnt}" /></td>
                <th>욕실수</th>
                <td><input type="number" name="bathCnt" class="form-control form-control-sm" value="${prop.bathCnt}" /></td>
              </tr>
              <tr>
                <th>방향</th>
                <td>
                  <select name="direction" class="form-control form-control-sm" style="width:120px;">
                    <option value="">선택</option>
                    <option value="동" ${prop.direction eq '동' ? 'selected' : ''}>동</option>
                    <option value="서" ${prop.direction eq '서' ? 'selected' : ''}>서</option>
                    <option value="남" ${prop.direction eq '남' ? 'selected' : ''}>남</option>
                    <option value="북" ${prop.direction eq '북' ? 'selected' : ''}>북</option>
                    <option value="남동" ${prop.direction eq '남동' ? 'selected' : ''}>남동</option>
                    <option value="남서" ${prop.direction eq '남서' ? 'selected' : ''}>남서</option>
                    <option value="북동" ${prop.direction eq '북동' ? 'selected' : ''}>북동</option>
                    <option value="북서" ${prop.direction eq '북서' ? 'selected' : ''}>북서</option>
                  </select>
                </td>
                <th>주차</th>
                <td>
                  <label class="mr-2"><input type="radio" name="parkingYn" value="Y" ${prop.parkingYn eq 'Y' ? 'checked' : ''} /> 가능</label>
                  <label><input type="radio" name="parkingYn" value="N" ${prop.parkingYn eq 'N' ? 'checked' : ''} /> 불가</label>
                </td>
              </tr>
              <tr>
                <th>사용승인일</th>
                <td><input type="date" name="buildDate" class="form-control form-control-sm" value="${prop.buildDate}" style="width:180px;" /></td>
                <th>현관유형</th>
                <td>
                  <select name="entranceType" class="form-control form-control-sm" style="width:120px;">
                    <option value="">선택</option>
                    <option value="복도식" ${prop.entranceType eq '복도식' ? 'selected' : ''}>복도식</option>
                    <option value="계단식" ${prop.entranceType eq '계단식' ? 'selected' : ''}>계단식</option>
                    <option value="복합식" ${prop.entranceType eq '복합식' ? 'selected' : ''}>복합식</option>
                  </select>
                </td>
              </tr>
              <tr>
                <th>난방방식</th>
                <td>
                  <select name="heating" class="form-control form-control-sm" style="width:120px;">
                    <option value="">선택</option>
                    <option value="개별" ${prop.heating eq '개별' ? 'selected' : ''}>개별난방</option>
                    <option value="중앙" ${prop.heating eq '중앙' ? 'selected' : ''}>중앙난방</option>
                    <option value="지역" ${prop.heating eq '지역' ? 'selected' : ''}>지역난방</option>
                  </select>
                </td>
                <th></th><td></td>
              </tr>
            </table>
          </div>
        </div>

        <!-- ===== 5. 상세정보 ===== -->
        <div class="card">
          <div class="card-header"><h5 class="card-title mb-0">상세정보</h5></div>
          <div class="card-body">
            <textarea id="initCnts" style="display:none;">${prop.detailCnts}</textarea>
            <textarea id="detailCnts" name="detailCnts"></textarea>
          </div>
        </div>

        <!-- ===== 6. 사진 ===== -->
        <div class="card">
          <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="card-title mb-0">사진</h5>
            <small class="text-muted">💡 드래그로 순서 변경 | "대표" 클릭하여 썸네일 지정</small>
          </div>
          <div class="card-body">
            <!-- 대표 이미지 경로 (hidden) -->
            <input type="hidden" name="thumbImgPath" id="thumbImgPath" value="${prop.thumbImgPath}" />
            <!-- 새 파일 중 대표 인덱스 (hidden) - 새 파일이 대표일 때 사용 -->
            <input type="hidden" name="thumbNewFileIndex" id="thumbNewFileIndex" value="" />
            <!-- 이미지 순서 (hidden) -->
            <input type="hidden" name="imageOrder" id="imageOrder" value="" />

            <!-- 2열 그리드 파일 미리보기 -->
            <div id="filePreviewArea" class="prop-file-grid">
              <c:if test="${not empty fileList}">
                <c:forEach var="file" items="${fileList}" varStatus="st">
                  <c:set var="imgPath" value="${file.savePath}${file.saveFileNm}" />
                  <c:set var="isThumb" value="${imgPath eq prop.thumbImgPath}" />
                  <div class="prop-file-card" data-type="exist" data-upld-file-cd="${file.upldFileCd}" data-file-seq="${file.fileSeq}" data-img-path="${imgPath}">
                    <div class="prop-file-card-header">
                      <span class="prop-file-thumb ${isThumb || (empty prop.thumbImgPath && st.first) ? 'active' : ''}" onclick="fnSetThumb(this)"><i class="fas fa-check"></i> 대표</span>
                      <button type="button" class="prop-file-remove" onclick="fnDeleteFile(this)">×</button>
                    </div>
                    <div class="prop-file-card-img">
                      <img src="/upload${imgPath}" alt="" loading="lazy" decoding="async" onerror="this.style.display='none'" />
                    </div>
                    <div class="prop-file-card-footer">
                      <div class="prop-file-drag"><i class="fas fa-grip-horizontal"></i> 드래그하여 순서변경</div>
                    </div>
                  </div>
                </c:forEach>
              </c:if>
            </div>

            <!-- 드래그앤드롭 업로드 영역 -->
            <input type="file" name="atchFile" id="atchFileInput" multiple accept=".jpg,.jpeg,.png,.gif,.webp" style="display:none;" />
            <div id="dropZone" class="prop-drop-zone">
              <span class="prop-drop-icon"><i class="fas fa-cloud-upload-alt"></i></span>
              <p class="prop-drop-text">이미지를 여기에 드래그하거나 <a href="javascript:void(0)" class="prop-drop-link">클릭하여 선택</a></p>
              <small class="text-muted">파일당 20MB 이하 (JPG, PNG, GIF, WEBP)</small>
            </div>
            <div id="deleteFilesArea"></div>
          </div>
        </div>

        <!-- 전시정보 hidden -->
        <input type="hidden" name="displayYn" value="${empty prop.displayYn ? 'Y' : prop.displayYn}" />
        <input type="hidden" name="displayStart" value="${prop.displayStart}" />
        <input type="hidden" name="displayEnd" value="${prop.displayEnd}" />

        <!-- ===== 하단 버튼 ===== -->
        <div style="display:flex; justify-content:center; gap:8px; padding:40px 0 80px;">
          <button type="button" class="btn btn-bo-reset" onclick="fnGoList()">목록</button>
          <button type="button" class="btn btn-bo-reset" onclick="fnRefresh()">새로고침</button>
          <c:if test="${not empty prop}">
            <button type="button" class="btn btn-bo-del" onclick="fnDelete()">삭제</button>
          </c:if>
          <c:if test="${not empty prop and prop.soldYn ne 'Y'}">
            <button type="button" class="btn btn-bo-copy" onclick="fnCopy()">복사</button>
            <button type="button" class="btn btn-bo-save" onclick="fnSave()">저장</button>
            <button type="button" class="btn btn-danger" onclick="fnComplete()">거래완료</button>
          </c:if>
          <c:if test="${empty prop}">
            <button type="button" class="btn btn-bo-save" onclick="fnSave()">저장</button>
          </c:if>
        </div>
      </form>
    </div>
  </section>
</div>

<!-- 카카오 주소 + 지도 -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=<%=com.prims.common.constant.Constant.KAKAO_MAP_API_KEY%>&autoload=false&libraries=services"></script>

<script>
var previewMap = null;
var previewMarker = null;

$(function() {
  // 거래완료 상태면 폼 전체 readonly 처리
  <c:if test="${prop.soldYn eq 'Y'}">
  $('#propForm').find('input, select, textarea').prop('disabled', true);
  $('#dropZone').hide();
  $('.card-header').first().after('<div class="alert alert-secondary m-3" style="margin-bottom:0 !important;"><strong>📋 거래완료된 매물입니다.</strong> 조회만 가능합니다.</div>');
  </c:if>

  // Summernote 초기화 (공지사항과 동일)
  try {
    EDIT.Summernote.init({
      el: '#detailCnts',
      ctx: '${ctx}',
      initSelector: '#initCnts',
      height: 400
    });
  } catch(e) { console.error('Summernote init error', e); }

  // 수정모드: 카테고리 로드
  var initCatCd = '${prop.catCd}';
  var initMidCatCd = '${prop.midCatCd}';
  var initSubCatCd = '${prop.subCatCd}';
  if (initCatCd) {
    fnCatChange(initCatCd, initMidCatCd, initSubCatCd);
  }

  // 수정모드: 지도 미리보기
  var initLat = parseFloat('${prop.lat}') || 0;
  var initLng = parseFloat('${prop.lng}') || 0;
  if (initLat && initLng) {
    try {
      if (typeof kakao !== 'undefined' && kakao.maps && kakao.maps.load) {
        kakao.maps.load(function() { fnShowMapPreview(initLat, initLng); });
      }
    } catch(e) { console.error('Kakao map init error', e); }
  }

  // 드래그앤드롭 초기화 (별도 블록으로 분리하여 에러 격리)
  try { fnInitDropZone(); } catch(e) { console.error('dropzone init error', e); }

  // Sortable 초기화 (이미지 순서 드래그)
  try { fnInitSortable(); } catch(e) { console.error('sortable init error', e); }
});

/* 대분류 변경 → 중분류 로드 */
function fnCatChange(catCd, selectedMidCatCd, selectedSubCatCd) {
  var $mid = $('#midCatCd');
  var $sub = $('#subCatCd');
  $mid.html('<option value="">선택</option>');
  $sub.html('<option value="">선택</option>');
  if (!catCd) return;

  var res = ajaxCall('${ctx}/propertyMng/getMidCatList', { catCd: catCd }, false);
  if (res && res.DATA) {
    for (var i = 0; i < res.DATA.length; i++) {
      var d = res.DATA[i];
      var sel = (d.midCatCd === selectedMidCatCd) ? ' selected' : '';
      $mid.append('<option value="' + d.midCatCd + '"' + sel + '>' + d.catNm + '</option>');
    }
    // 중분류 선택값 있으면 소분류도 로드
    if (selectedMidCatCd) {
      fnMidCatChange(selectedMidCatCd, selectedSubCatCd);
    }
  }
}

/* 중분류 변경 → 소분류 로드 */
function fnMidCatChange(midCatCd, selectedSubCatCd) {
  var $sub = $('#subCatCd');
  $sub.html('<option value="">선택</option>');
  if (!midCatCd) return;

  var res = ajaxCall('${ctx}/propertyMng/getSubCatList', { catCd: midCatCd }, false);
  if (res && res.DATA) {
    for (var i = 0; i < res.DATA.length; i++) {
      var d = res.DATA[i];
      var sel = (d.subCatCd === selectedSubCatCd) ? ' selected' : '';
      $sub.append('<option value="' + d.subCatCd + '"' + sel + '>' + d.catNm + '</option>');
    }
  }
}

/* ========== 주소 검색 + 지도 미리보기 ========== */
function fnSearchAddr() {
  new daum.Postcode({
    oncomplete: function(data) {
      var addr = data.roadAddress || data.jibunAddress;
      $('#address').val(addr);

      // 카카오 지오코딩 → 좌표 자동 설정
      if (typeof kakao !== 'undefined' && kakao.maps && kakao.maps.load) {
        kakao.maps.load(function() {
          var geocoder = new kakao.maps.services.Geocoder();
          geocoder.addressSearch(addr, function(result, status) {
            if (status === kakao.maps.services.Status.OK) {
              var lat = result[0].y;
              var lng = result[0].x;
              $('#lat').val(lat);
              $('#lng').val(lng);
              fnShowMapPreview(lat, lng);
            }
          });
        });
      }
    }
  }).open();
}

function fnShowMapPreview(lat, lng) {
  var container = document.getElementById('mapPreview');
  container.innerHTML = '';
  container.style.color = '';
  var latLng = new kakao.maps.LatLng(lat, lng);

  if (!previewMap) {
    previewMap = new kakao.maps.Map(container, { center: latLng, level: 3 });
    previewMarker = new kakao.maps.Marker({ position: latLng });
    previewMarker.setMap(previewMap);
    previewMap.addControl(new kakao.maps.ZoomControl(), kakao.maps.ControlPosition.RIGHT);
  } else {
    previewMap.setCenter(latLng);
    previewMarker.setPosition(latLng);
  }
  setTimeout(function() { previewMap.relayout(); }, 100);
}

/* ========== 드래그앤드롭 파일 업로드 ========== */
function fnInitDropZone() {
  var $zone = $('#dropZone');
  var $input = $('#atchFileInput');

  // 페이지 전체 드래그 방지
  $(document).on('dragover drop', function(e) {
    if (!$(e.target).closest('#dropZone').length) {
      e.preventDefault();
      e.stopPropagation();
    }
  });

  // 영역 전체 클릭 → 파일 선택
  $zone.on('click', function(e) {
    if (e.target === $input[0]) return;
    $input.trigger('click');
  });

  // 드래그 오버
  $zone.on('dragover', function(e) { e.preventDefault(); e.stopPropagation(); $zone.addClass('drag-over'); });
  $zone.on('dragleave', function(e) { e.preventDefault(); e.stopPropagation(); $zone.removeClass('drag-over'); });
  $zone.on('drop', function(e) {
    e.preventDefault(); e.stopPropagation();
    $zone.removeClass('drag-over');
    if (e.originalEvent.dataTransfer.files.length) {
      fnAddNewFiles(e.originalEvent.dataTransfer.files);
    }
  });

  $input.on('change', function() {
    fnAddNewFiles(this.files);
    this.value = '';
  });
}

var _newFiles = [];
var _newFileIdCounter = 0;
var _deletedExistFiles = [];
var _sortable = null;

function fnAddNewFiles(files) {
  for (var i = 0; i < files.length; i++) {
    var file = files[i];
    if (!file.type.startsWith('image/')) {
      alert('이미지 파일만 업로드 가능합니다.');
      continue;
    }
    if (file.size > 20 * 1024 * 1024) {
      alert('파일 크기는 20MB 이하만 가능합니다: ' + file.name);
      continue;
    }

    var fileId = 'new_' + (++_newFileIdCounter);
    _newFiles.push({ id: fileId, file: file });
    fnRenderNewFile(fileId, file);
  }
  fnUpdateThumbBadge();
}

function fnRenderNewFile(fileId, file) {
  var reader = new FileReader();
  reader.onload = function(e) {
    var html = '<div class="prop-file-card" data-type="new" data-file-id="' + fileId + '">' +
                 '<div class="prop-file-card-header">' +
                   '<span class="prop-file-thumb" onclick="fnSetThumb(this)"><i class="fas fa-check"></i> 대표</span>' +
                   '<span class="prop-file-new">NEW</span>' +
                   '<button type="button" class="prop-file-remove" onclick="fnDeleteFile(this)">×</button>' +
                 '</div>' +
                 '<div class="prop-file-card-img">' +
                   '<img src="' + e.target.result + '" alt="' + file.name + '" />' +
                 '</div>' +
                 '<div class="prop-file-card-footer">' +
                   '<div class="prop-file-drag"><i class="fas fa-grip-horizontal"></i> 드래그하여 순서변경</div>' +
                 '</div>' +
               '</div>';
    $('#filePreviewArea').append(html);
    fnUpdateThumbBadge();
  };
  reader.readAsDataURL(file);
}

/* ========== Sortable 초기화 ========== */
function fnInitSortable() {
  var el = document.getElementById('filePreviewArea');
  if (!el || typeof Sortable === 'undefined') return;

  _sortable = new Sortable(el, {
    animation: 150,
    handle: '.prop-file-drag',
    draggable: '.prop-file-card',
    ghostClass: 'prop-file-ghost',
    chosenClass: 'prop-file-chosen',
    dragClass: 'prop-file-dragging',
    forceFallback: true,
    fallbackTolerance: 3,
    onStart: function() {
      document.body.style.cursor = 'grabbing';
    },
    onEnd: function() {
      document.body.style.cursor = '';
      fnUpdateThumbBadge();
    }
  });
}

/* ========== 썸네일 배지 업데이트 ========== */
function fnUpdateThumbBadge() {
  var $cards = $('#filePreviewArea .prop-file-card:not(.prop-file-card--deleted)');
  var $activeCard = $cards.filter(function() {
    return $(this).find('.prop-file-thumb').hasClass('active');
  });

  // 대표 없으면 첫번째를 대표로
  if ($activeCard.length === 0 && $cards.length > 0) {
    var $firstCard = $cards.first();
    $firstCard.find('.prop-file-thumb').addClass('active');

    // 첫 번째 카드의 타입에 따라 thumbImgPath 또는 thumbNewFileIndex 설정
    var type = $firstCard.data('type');
    if (type === 'exist') {
      var firstPath = $firstCard.data('img-path');
      $('#thumbImgPath').val(firstPath || '');
      $('#thumbNewFileIndex').val('');
    } else {
      var fileId = $firstCard.data('file-id');
      $('#thumbImgPath').val('');
      $('#thumbNewFileIndex').val(fileId || '');
    }
  }
}

/* ========== 대표 이미지 설정 ========== */
function fnSetThumb(el) {
  var $card = $(el).closest('.prop-file-card');
  if ($card.hasClass('prop-file-card--deleted')) return;

  // 기존 대표 해제
  $('#filePreviewArea .prop-file-card .prop-file-thumb').removeClass('active');
  // 새 대표 설정
  $card.find('.prop-file-thumb').addClass('active');

  // thumbImgPath / thumbNewFileIndex 업데이트
  var type = $card.data('type');
  if (type === 'exist') {
    // 기존 파일: 경로 설정
    var imgPath = $card.data('img-path');
    $('#thumbImgPath').val(imgPath || '');
    $('#thumbNewFileIndex').val('');
  } else {
    // 새 파일: 파일 ID 저장 (저장 시 서버에서 해당 파일로 대표 설정)
    var fileId = $card.data('file-id');
    $('#thumbImgPath').val('');
    $('#thumbNewFileIndex').val(fileId || '');
  }
}

/* ========== 파일 삭제 ========== */
function fnDeleteFile(btn) {
  var $card = $(btn).closest('.prop-file-card');
  var type = $card.data('type');
  var wasActive = $card.find('.prop-file-thumb').hasClass('active');

  if (type === 'exist') {
    var upldFileCd = $card.data('upld-file-cd');
    var fileSeq = $card.data('file-seq');
    _deletedExistFiles.push(upldFileCd + ':' + fileSeq);
    $card.addClass('prop-file-card--deleted');
    $card.find('.prop-file-thumb').removeClass('active');

    // 삭제 취소 오버레이 추가
    if (!$card.find('.prop-file-undo-overlay').length) {
      $card.append('<div class="prop-file-undo-overlay"><span class="undo-text">삭제됨</span><button type="button" class="prop-file-undo-btn" onclick="fnUndoDelete(this)"><i class="fas fa-undo"></i> 삭제취소</button></div>');
    }

    // hidden input 추가
    $('#deleteFilesArea').append('<input type="hidden" name="deleteFiles" value="' + upldFileCd + ':' + fileSeq + '" />');
  } else {
    var fileId = $card.data('file-id');
    _newFiles = _newFiles.filter(function(f) { return f.id !== fileId; });
    $card.remove();
  }

  fnUpdateThumbBadge();
}

/* ========== 파일 삭제 취소 ========== */
function fnUndoDelete(btn) {
  var $card = $(btn).closest('.prop-file-card');
  var upldFileCd = $card.data('upld-file-cd');
  var fileSeq = $card.data('file-seq');
  var key = upldFileCd + ':' + fileSeq;

  _deletedExistFiles = _deletedExistFiles.filter(function(k) { return k !== key; });
  $card.removeClass('prop-file-card--deleted');
  $card.find('.prop-file-undo-overlay').remove();

  // hidden input 제거
  $('#deleteFilesArea').find('input[value="' + key + '"]').remove();

  fnUpdateThumbBadge();
}

/* ========== 저장 ========== */
function fnSave() {
  var $form = $('#propForm');
  if (!$form[0].checkValidity()) { $form[0].reportValidity(); return; }

  $('[name=detailCnts]').val($('#detailCnts').summernote('code'));

  // 이미지 순서 수집
  fnCollectImageOrder();

  var formData = new FormData($form[0]);

  // 새 파일들 추가 (순서대로)
  var fileOrder = $('#imageOrder').val();
  if (fileOrder) {
    try {
      var orderList = JSON.parse(fileOrder);
      orderList.forEach(function(item) {
        if (item.fileId && item.fileId.startsWith('new_')) {
          var found = _newFiles.find(function(f) { return f.id === item.fileId; });
          if (found) {
            formData.append('atchFile', found.file);
          }
        }
      });
    } catch(e) {}
  }

  $.ajax({
    url: '${ctx}/propertyMng/saveProperty',
    type: 'POST',
    data: formData,
    processData: false,
    contentType: false,
    success: function(res) {
      if (res.result === 'OK') {
        alert('저장되었습니다.');
        location.href = '${ctx}/propertyMng/viewPropertyWrite?propCd=' + res.propCd;
      } else {
        alert('저장 실패: ' + (res.message || ''));
      }
    }
  });
}

/* ========== 삭제 ========== */
function fnDelete() {
  if (!confirm('삭제하시겠습니까?')) return;
  var res = ajaxCall('${ctx}/propertyMng/deleteProperty', { propCd: '${prop.propCd}' }, false);
  if (res && res.result === 'OK') {
    alert('삭제되었습니다.');
    fnGoList();
  } else {
    alert('삭제 실패');
  }
}

/* ========== 복사 ========== */
function fnCopy() {
  if (!confirm('매물을 복사하시겠습니까?')) return;
  var res = ajaxCall('${ctx}/propertyMng/copyProperty', { propCd: '${prop.propCd}' }, false);
  if (res && res.result === 'OK') {
    alert('복사되었습니다.');
    location.href = '${ctx}/propertyMng/viewPropertyWrite?propCd=' + res.newPropCd;
  }
}

/* ========== 거래완료 처리 ========== */
function fnComplete() {
  var msg = "거래완료 처리하시겠습니까?\n\n";
  msg += "⚠️ 주의:\n";
  msg += "- 첨부된 사진이 모두 삭제됩니다\n";
  msg += "- 되돌릴 수 없습니다";

  if (!confirm(msg)) return;

  var res = ajaxCall('${ctx}/propertyMng/completeProperty', { propCd: '${prop.propCd}' }, false);
  if (res && res.result === 'OK') {
    alert('거래완료 처리되었습니다.');
    fnGoList();
  } else {
    alert('처리 실패: ' + (res && res.message ? res.message : ''));
  }
}

/* ========== 저장 시 이미지 순서 수집 ========== */
function fnCollectImageOrder() {
  var orderList = [];
  $('#filePreviewArea .prop-file-card:not(.prop-file-card--deleted)').each(function(idx) {
    var type = $(this).data('type');
    if (type === 'exist') {
      orderList.push({
        fileSeq: $(this).data('file-seq'),
        newSeq: idx + 1
      });
    } else {
      orderList.push({
        fileId: $(this).data('file-id'),
        newSeq: idx + 1
      });
    }
  });
  $('#imageOrder').val(JSON.stringify(orderList));
}

function fnGoList() {
  location.href = '${ctx}/propertyMng/viewPropertyMng';
}

function fnRefresh() {
  location.reload();
}
</script>

<style>
/* 3열 그리드 */
.prop-file-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
  margin-bottom: 20px;
  min-height: 50px;
}

/* 카드 스타일 */
.prop-file-card {
  position: relative;
  background: #fff;
  border: 1px solid #e0e0e0;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0,0,0,0.06);
  transition: box-shadow 0.2s, transform 0.2s;
}
.prop-file-card:hover {
  box-shadow: 0 4px 16px rgba(0,0,0,0.1);
}

/* 카드 헤더 */
.prop-file-card-header {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  padding: 10px;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  z-index: 10;
}

/* 대표 이미지 뱃지 */
.prop-file-thumb {
  background: rgba(0,0,0,0.5);
  color: #fff;
  font-size: 11px;
  padding: 4px 10px;
  border-radius: 4px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  display: inline-flex;
  align-items: center;
  gap: 4px;
}
.prop-file-thumb:hover {
  background: rgba(0,0,0,0.7);
}
.prop-file-thumb.active {
  background: #28a745;
}

/* NEW 뱃지 */
.prop-file-new {
  background: #007bff;
  color: #fff;
  font-size: 10px;
  padding: 3px 8px;
  border-radius: 3px;
  font-weight: 700;
  margin-left: 8px;
}

/* 삭제 버튼 */
.prop-file-remove {
  width: 28px;
  height: 28px;
  border: none;
  border-radius: 50%;
  background: rgba(0,0,0,0.5);
  color: #fff;
  font-size: 18px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background 0.2s;
}
.prop-file-remove:hover {
  background: #dc3545;
}

/* 이미지 영역 */
.prop-file-card-img {
  width: 100%;
  aspect-ratio: 16 / 10;
  overflow: hidden;
  background: #f5f5f5;
  display: flex;
  align-items: center;
  justify-content: center;
}
.prop-file-card-img img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  opacity: 0;
  transition: opacity 0.3s ease;
}
.prop-file-card-img img[src] {
  opacity: 1;
}

/* 카드 푸터 */
.prop-file-card-footer {
  padding: 12px 15px 15px;
  background: #fff;
}

/* 드래그 핸들 */
.prop-file-drag {
  padding: 8px;
  background: #f0f0f0;
  border-radius: 6px;
  text-align: center;
  font-size: 12px;
  color: #888;
  cursor: grab;
  transition: all 0.2s;
  user-select: none;
}
.prop-file-drag:hover {
  background: #e0e0e0;
  color: #555;
}
.prop-file-drag:active {
  cursor: grabbing;
}

/* 드래그 상태 */
.prop-file-ghost {
  opacity: 0.4;
  border: 2px dashed #007bff !important;
}
.prop-file-chosen {
  box-shadow: 0 8px 25px rgba(0,0,0,0.15) !important;
}

/* 삭제된 카드 */
.prop-file-card--deleted {
  opacity: 0.5;
  position: relative;
}
.prop-file-card--deleted .prop-file-card-header,
.prop-file-card--deleted .prop-file-card-footer {
  pointer-events: none;
}

/* 삭제 취소 오버레이 */
.prop-file-undo-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0,0,0,0.6);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
  z-index: 25;
  border-radius: 12px;
}
.prop-file-undo-overlay .undo-text {
  color: #fff;
  font-size: 16px;
  font-weight: 600;
}
.prop-file-undo-btn {
  background: #fff;
  color: #333;
  border: none;
  padding: 10px 20px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  gap: 6px;
  transition: all 0.2s;
}
.prop-file-undo-btn:hover {
  background: #007bff;
  color: #fff;
}

/* 드래그앤드롭 영역 */
.prop-drop-zone {
  border: 2px dashed #ccc;
  border-radius: 12px;
  padding: 40px 20px;
  text-align: center;
  cursor: pointer;
  transition: all 0.2s;
  background: #fafafa;
}
.prop-drop-zone:hover,
.prop-drop-zone.drag-over {
  border-color: #007bff;
  background: #f0f7ff;
}
.prop-drop-icon {
  font-size: 36px;
  color: #999;
  display: block;
  margin-bottom: 12px;
}
.prop-drop-text {
  margin: 0 0 8px;
  font-size: 14px;
  color: #555;
}
.prop-drop-link {
  color: #007bff;
  font-weight: 600;
  text-decoration: underline;
}

/* 반응형 */
@media (max-width: 1200px) {
  .prop-file-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}
@media (max-width: 768px) {
  .prop-file-grid {
    grid-template-columns: 1fr;
  }
}
</style>
