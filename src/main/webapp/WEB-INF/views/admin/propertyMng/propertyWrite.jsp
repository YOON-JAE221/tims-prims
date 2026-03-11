<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

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
          <c:if test="${not empty prop}">
            <button type="button" class="btn btn-bo-del" onclick="fnDelete()">삭제</button>
            <button type="button" class="btn btn-bo-copy" onclick="fnCopy()">복사</button>
          </c:if>
          <button type="button" class="btn btn-bo-save" onclick="fnSave()">저장</button>
        </div>

        <!-- ===== 1. 기본정보 ===== -->
        <div class="card">
          <div class="card-header"><h5 class="card-title mb-0">기본정보</h5></div>
          <div class="card-body">
            <table class="table table-bordered bo-form-table">
              <tr>
                <th>대분류 <span class="text-danger">*</span></th>
                <td>
                  <select name="catCd" id="catCd" class="form-control form-control-sm" style="width:200px;" onchange="fnCatChange(this.value)" required>
                    <option value="">선택</option>
                    <c:forEach var="cat" items="${catList}">
                      <option value="${cat.catCd}" ${prop.catCd eq cat.catCd ? 'selected' : ''}>${cat.catNm}</option>
                    </c:forEach>
                  </select>
                </td>
                <th>소분류 <span class="text-danger">*</span></th>
                <td>
                  <select name="subCatCd" id="subCatCd" class="form-control form-control-sm" style="width:200px;" required>
                    <option value="">선택</option>
                  </select>
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
                <div class="row">
                  <div class="col-6">
                    <div class="form-group">
                      <label><strong>위도</strong></label>
                      <input type="text" name="lat" id="lat" class="form-control form-control-sm" value="${prop.lat}" />
                    </div>
                  </div>
                  <div class="col-6">
                    <div class="form-group">
                      <label><strong>경도</strong></label>
                      <input type="text" name="lng" id="lng" class="form-control form-control-sm" value="${prop.lng}" />
                    </div>
                  </div>
                </div>
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
          <div class="card-header"><h5 class="card-title mb-0">가격정보</h5></div>
          <div class="card-body">
            <table class="table table-bordered bo-form-table">
              <tr>
                <th>매매가 <small class="text-muted">(원)</small></th>
                <td><input type="number" name="sellPrice" class="form-control form-control-sm" value="${prop.sellPrice}" /></td>
                <th>보증금/전세가 <small class="text-muted">(원)</small></th>
                <td><input type="number" name="deposit" class="form-control form-control-sm" value="${prop.deposit}" /></td>
              </tr>
              <tr>
                <th>월세 <small class="text-muted">(원)</small></th>
                <td><input type="number" name="monthlyRent" class="form-control form-control-sm" value="${prop.monthlyRent}" /></td>
                <th>월관리비 <small class="text-muted">(원)</small></th>
                <td><input type="number" name="monthlyMgmt" class="form-control form-control-sm" value="${prop.monthlyMgmt}" /></td>
              </tr>
              <tr>
                <th>권리금 <small class="text-muted">(원, 상가)</small></th>
                <td><input type="number" name="premium" class="form-control form-control-sm" value="${prop.premium}" /></td>
                <th>융자여부</th>
                <td>
                  <div class="d-flex" style="gap:8px;">
                    <select name="loanYn" class="form-control form-control-sm" style="width:100px;">
                      <option value="N" ${empty prop.loanYn || prop.loanYn eq 'N' ? 'selected' : ''}>없음</option>
                      <option value="Y" ${prop.loanYn eq 'Y' ? 'selected' : ''}>있음</option>
                    </select>
                    <input type="number" name="loanAmount" class="form-control form-control-sm" value="${prop.loanAmount}" placeholder="융자금(만원)" style="width:150px;" />
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
                <th></th><td></td>
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
          <div class="card-header"><h5 class="card-title mb-0">사진</h5></div>
          <div class="card-body">
            <!-- 기존 사진 -->
            <div id="existFileArea" class="d-flex flex-wrap" style="gap:10px; margin-bottom:10px;">
              <c:if test="${not empty fileList}">
                <c:forEach var="file" items="${fileList}">
                  <div class="exist-file-item" id="file_${file.upldFileCd}_${file.fileSeq}">
                    <img src="${ctx}/common/fileView?upldFileCd=${file.upldFileCd}&fileSeq=${file.fileSeq}" />
                    <button type="button" class="btn btn-xs btn-bo-del" onclick="fnDeleteFile('${file.upldFileCd}','${file.fileSeq}')">×</button>
                  </div>
                </c:forEach>
              </c:if>
            </div>
            <!-- 드래그앤드롭 업로드 -->
            <input type="file" name="atchFile" id="atchFileInput" multiple accept=".jpg,.jpeg,.png,.gif,.webp" style="display:none;" />
            <div id="dropZone" class="drop-zone">
              <span class="drop-zone-icon">&#128247;</span>
              <p class="drop-zone-text">이미지를 여기에 드래그하거나 <a href="javascript:void(0)" class="drop-zone-link" id="dropZoneLink">클릭하여 선택</a></p>
              <small class="text-muted">최대 10개, 파일당 20MB 이하 (JPG, PNG, GIF, WEBP)</small>
            </div>
            <!-- 새 파일 미리보기 -->
            <div id="newFilePreview" class="d-flex flex-wrap" style="gap:10px; margin-top:10px;"></div>
            <div id="deleteFilesArea"></div>
          </div>
        </div>

        <!-- ===== 7. 전시/상태 ===== -->
        <div class="card">
          <div class="card-header"><h5 class="card-title mb-0">전시/상태</h5></div>
          <div class="card-body">
            <table class="table table-bordered bo-form-table">
              <tr>
                <th>전시여부</th>
                <td>
                  <label class="mr-2"><input type="radio" name="displayYn" value="Y" ${empty prop.displayYn || prop.displayYn eq 'Y' ? 'checked' : ''} /> 전시</label>
                  <label><input type="radio" name="displayYn" value="N" ${prop.displayYn eq 'N' ? 'checked' : ''} /> 비전시</label>
                </td>
                <th>뱃지</th>
                <td>
                  <select name="badgeType" class="form-control form-control-sm" style="width:120px;">
                    <option value="NONE" ${empty prop.badgeType || prop.badgeType eq 'NONE' ? 'selected' : ''}>없음</option>
                    <option value="RECOMMEND" ${prop.badgeType eq 'RECOMMEND' ? 'selected' : ''}>추천</option>
                    <option value="URGENT" ${prop.badgeType eq 'URGENT' ? 'selected' : ''}>급매</option>
                  </select>
                </td>
              </tr>
              <tr>
                <th>전시 시작일</th>
                <td><input type="date" name="displayStart" class="form-control form-control-sm" value="${prop.displayStart}" style="width:180px;" /></td>
                <th>전시 종료일</th>
                <td><input type="date" name="displayEnd" class="form-control form-control-sm" value="${prop.displayEnd}" style="width:180px;" /></td>
              </tr>
              <tr>
                <th>거래완료</th>
                <td>
                  <label class="mr-2"><input type="radio" name="soldYn" value="N" ${empty prop.soldYn || prop.soldYn eq 'N' ? 'checked' : ''} /> 거래중</label>
                  <label><input type="radio" name="soldYn" value="Y" ${prop.soldYn eq 'Y' ? 'checked' : ''} /> 거래완료</label>
                </td>
                <th></th><td></td>
              </tr>
              <tr>
                <th>관리자 메모</th>
                <td colspan="3"><textarea name="adminMemo" class="form-control form-control-sm" rows="2" placeholder="비공개 메모">${prop.adminMemo}</textarea></td>
              </tr>
            </table>
          </div>
        </div>

        <!-- ===== 하단 버튼 ===== -->
        <div style="display:flex; justify-content:center; gap:8px; padding:40px 0 80px;">
          <button type="button" class="btn btn-bo-reset" onclick="fnGoList()">목록</button>
          <c:if test="${not empty prop}">
            <button type="button" class="btn btn-bo-del" onclick="fnDelete()">삭제</button>
            <button type="button" class="btn btn-bo-copy" onclick="fnCopy()">복사</button>
          </c:if>
          <button type="button" class="btn btn-bo-save" onclick="fnSave()">저장</button>
        </div>
      </form>
    </div>
  </section>
</div>

<!-- 카카오 주소 + 지도 -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=<%=com.prims.common.constant.Constant.KAKAO_MAP_API_KEY%>&autoload=false"></script>

<script>
var previewMap = null;
var previewMarker = null;

$(function() {
  // Summernote 초기화 (공지사항과 동일)
  try {
    EDIT.Summernote.init({
      el: '#detailCnts',
      ctx: '${ctx}',
      initSelector: '#initCnts',
      height: 400
    });
  } catch(e) { console.error('Summernote init error', e); }

  // 수정모드: 소분류 로드
  var initCatCd = '${prop.catCd}';
  var initSubCatCd = '${prop.subCatCd}';
  if (initCatCd) {
    fnCatChange(initCatCd, initSubCatCd);
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
});

/* 대분류 변경 → 소분류 로드 */
function fnCatChange(catCd, selectedSubCatCd) {
  var $sub = $('#subCatCd');
  $sub.html('<option value="">선택</option>');
  if (!catCd) return;

  var res = ajaxCall('${ctx}/propertyMng/getSubCatList', { catCd: catCd }, false);
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

  // 영역 전체 클릭 → 파일 선택
  $zone.on('click', function(e) {
    // 이미 input click이 진행중이면 무시 (이중 호출 방지)
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
      $input[0].files = e.originalEvent.dataTransfer.files;
      fnPreviewNewFiles($input[0].files);
    }
  });

  $input.on('change', function() {
    fnPreviewNewFiles(this.files);
  });
}

var _newFiles = []; // 새 파일 목록 관리

function fnPreviewNewFiles(files) {
  // 기존 목록에 추가
  for (var i = 0; i < files.length; i++) {
    _newFiles.push(files[i]);
  }
  fnRenderNewFiles();
  fnSyncFileInput();
}

function fnRemoveNewFile(idx) {
  _newFiles.splice(idx, 1);
  fnRenderNewFiles();
  fnSyncFileInput();
}

function fnRenderNewFiles() {
  var $preview = $('#newFilePreview');
  $preview.empty();
  for (var i = 0; i < _newFiles.length; i++) {
    (function(file, idx) {
      var reader = new FileReader();
      reader.onload = function(e) {
        $preview.append(
          '<div class="exist-file-item" id="newFile_' + idx + '">' +
          '<img src="' + e.target.result + '" />' +
          '<button type="button" class="btn btn-xs btn-bo-del" onclick="fnRemoveNewFile(' + idx + ')">×</button>' +
          '<span class="new-file-label">NEW</span>' +
          '</div>'
        );
      };
      reader.readAsDataURL(file);
    })(_newFiles[i], i);
  }
}

function fnSyncFileInput() {
  // DataTransfer로 input.files를 동기화
  var dt = new DataTransfer();
  for (var i = 0; i < _newFiles.length; i++) {
    dt.items.add(_newFiles[i]);
  }
  document.getElementById('atchFileInput').files = dt.files;
}

/* ========== 저장 ========== */
function fnSave() {
  var $form = $('#propForm');
  if (!$form[0].checkValidity()) { $form[0].reportValidity(); return; }

  $('[name=detailCnts]').val($('#detailCnts').summernote('code'));

  var formData = new FormData($form[0]);

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

/* ========== 파일 삭제 ========== */
function fnDeleteFile(upldFileCd, fileSeq) {
  if (!confirm('이 사진을 삭제하시겠습니까?')) return;
  $('#file_' + upldFileCd + '_' + fileSeq).hide();
  $('#deleteFilesArea').append('<input type="hidden" name="deleteFiles" value="' + upldFileCd + ':' + fileSeq + '" />');
}

function fnGoList() {
  location.href = '${ctx}/propertyMng/viewPropertyMng';
}
</script>

<style>
/* 기존 파일 아이템 */
.exist-file-item { position:relative; display:inline-block; }
.exist-file-item img { width:150px; height:100px; object-fit:cover; border-radius:4px; border:1px solid #dee2e6; }
.exist-file-item .btn { position:absolute; top:4px; right:4px; font-size:14px; padding:0 6px; line-height:20px; background:rgba(0,0,0,0.5); color:#fff; border:none; border-radius:50%; }
.exist-file-item .btn:hover { background:rgba(220,53,69,0.9); }
.new-file-label { position:absolute; bottom:4px; left:4px; background:#28a745; color:#fff; font-size:10px; padding:1px 6px; border-radius:3px; font-weight:700; }

/* 드래그앤드롭 영역 */
.drop-zone {
  border:2px dashed #b8d4f0; border-radius:8px; padding:40px 30px; text-align:center; cursor:pointer;
  transition: border-color 0.2s, background 0.2s;
  background: #fbfdff;
}
.drop-zone:hover, .drop-zone.drag-over { border-color:#0078ff; background:#f0f7ff; }
.drop-zone-icon { font-size:36px; color:#888; margin-bottom:12px; display:block; }
.drop-zone-text { margin:0 0 6px; font-size:14px; color:#555; font-weight:500; }
.drop-zone-link { color:#0078ff; font-weight:700; text-decoration:underline; cursor:pointer; }
.drop-zone-link:hover { color:#005ec7; }
.drop-zone p { margin:0; }
</style>
