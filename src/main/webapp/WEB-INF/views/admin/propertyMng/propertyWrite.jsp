<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<div class="content-wrapper">

  <div class="content-header">
    <div class="container">
      <div class="row mb-2">
        <div class="col-sm-6"><h4>${empty prop ? '매물 등록' : '매물 상세'}</h4></div>
        <div class="col-sm-6">
          <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item active">매물관리</li>
            <li class="breadcrumb-item"><a href="${ctx}/propertyMng/viewPropertyMng">매물목록</a></li>
          </ol>
        </div>
      </div>
    </div>
  </div>

  <section class="content">
    <div class="container">

      <form id="propForm" enctype="multipart/form-data">
        <input type="hidden" name="propCd" value="${prop.propCd}" />

        <!-- 상단 버튼 -->
        <div style="text-align:right; margin-bottom:16px;">
          <button type="button" class="btn btn-bo-reset" onclick="fnGoList()">목록</button>
          <c:if test="${not empty prop}">
          <button type="button" class="btn btn-bo-reset ml-2" onclick="fnDelete()">삭제</button>
          </c:if>
          <button type="button" class="btn btn-bo-save ml-2" onclick="fnSave()">저장</button>
          <c:if test="${not empty prop}">
          <button type="button" class="btn btn-bo-reset ml-2" onclick="fnCopy()">복사</button>
          </c:if>
        </div>

        <!-- 기본정보 -->
        <div class="card">
          <div class="card-header"><h5 class="card-title mb-0">기본정보</h5></div>
          <div class="card-body">
            <div class="row">
              <div class="col-md-6">
                <div class="form-group">
                  <label>매물명 <span class="text-danger">*</span></label>
                  <input type="text" name="propNm" id="propNm" class="form-control" value="${prop.propNm}" placeholder="예: 프리머스타워 32평" />
                </div>
              </div>
              <div class="col-md-3">
                <div class="form-group">
                  <label>매물유형 <span class="text-danger">*</span></label>
                  <select name="propType" id="propType" class="form-control">
                    <option value="APT" ${prop.propType eq 'APT' ? 'selected' : ''}>아파트</option>
                    <option value="OFFICETEL" ${prop.propType eq 'OFFICETEL' ? 'selected' : ''}>오피스텔</option>
                    <option value="VILLA" ${prop.propType eq 'VILLA' ? 'selected' : ''}>빌라/주택</option>
                    <option value="ONEROOM" ${prop.propType eq 'ONEROOM' ? 'selected' : ''}>원룸/투룸</option>
                    <option value="SHOP" ${prop.propType eq 'SHOP' ? 'selected' : ''}>상가</option>
                    <option value="OFFICE" ${prop.propType eq 'OFFICE' ? 'selected' : ''}>사무실</option>
                  </select>
                </div>
              </div>
              <div class="col-md-3">
                <div class="form-group">
                  <label>거래유형 <span class="text-danger">*</span></label>
                  <select name="dealType" id="dealType" class="form-control">
                    <option value="SELL" ${prop.dealType eq 'SELL' ? 'selected' : ''}>매매</option>
                    <option value="JEONSE" ${prop.dealType eq 'JEONSE' ? 'selected' : ''}>전세</option>
                    <option value="WOLSE" ${prop.dealType eq 'WOLSE' ? 'selected' : ''}>월세</option>
                    <option value="RENT" ${prop.dealType eq 'RENT' ? 'selected' : ''}>임대</option>
                  </select>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 가격정보 -->
        <div class="card">
          <div class="card-header"><h5 class="card-title mb-0">가격정보</h5></div>
          <div class="card-body">
            <div class="row">
              <div class="col-md-3">
                <div class="form-group">
                  <label>매매가 (만원) <span class="text-danger">*</span></label>
                  <input type="number" name="sellPrice" class="form-control" value="${prop.sellPrice}" placeholder="0" />
                </div>
              </div>
              <div class="col-md-3">
                <div class="form-group">
                  <label>보증금 (만원) <span class="text-danger">*</span></label>
                  <input type="number" name="deposit" class="form-control" value="${prop.deposit}" placeholder="0" />
                </div>
              </div>
              <div class="col-md-3">
                <div class="form-group">
                  <label>월세 (만원) <span class="text-danger">*</span></label>
                  <input type="number" name="monthlyRent" class="form-control" value="${prop.monthlyRent}" placeholder="0" />
                </div>
              </div>
              <div class="col-md-3">
                <div class="form-group">
                  <label>관리비 (만원)</label>
                  <input type="number" name="mgmtCost" class="form-control" value="${prop.mgmtCost}" placeholder="0" />
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 면적/구조 -->
        <div class="card">
          <div class="card-header"><h5 class="card-title mb-0">면적 / 구조</h5></div>
          <div class="card-body">
            <div class="row">
              <div class="col-md-3">
                <div class="form-group">
                  <label>전용면적 (㎡) <span class="text-danger">*</span></label>
                  <input type="number" step="0.01" name="areaExclusive" class="form-control" value="${prop.areaExclusive}" />
                </div>
              </div>
              <div class="col-md-3">
                <div class="form-group">
                  <label>공급면적 (㎡)</label>
                  <input type="number" step="0.01" name="areaSupply" class="form-control" value="${prop.areaSupply}" />
                </div>
              </div>
              <div class="col-md-2">
                <div class="form-group">
                  <label>방수 <span class="text-danger">*</span></label>
                  <input type="number" name="roomCnt" class="form-control" value="${prop.roomCnt}" />
                </div>
              </div>
              <div class="col-md-2">
                <div class="form-group">
                  <label>욕실수</label>
                  <input type="number" name="bathCnt" class="form-control" value="${prop.bathCnt}" />
                </div>
              </div>
              <div class="col-md-2">
                <div class="form-group">
                  <label>방향</label>
                  <select name="direction" class="form-control">
                    <option value="">선택</option>
                    <option value="남향" ${prop.direction eq '남향' ? 'selected' : ''}>남향</option>
                    <option value="동향" ${prop.direction eq '동향' ? 'selected' : ''}>동향</option>
                    <option value="서향" ${prop.direction eq '서향' ? 'selected' : ''}>서향</option>
                    <option value="북향" ${prop.direction eq '북향' ? 'selected' : ''}>북향</option>
                    <option value="남동향" ${prop.direction eq '남동향' ? 'selected' : ''}>남동향</option>
                    <option value="남서향" ${prop.direction eq '남서향' ? 'selected' : ''}>남서향</option>
                  </select>
                </div>
              </div>
            </div>
            <div class="row">
              <div class="col-md-2">
                <div class="form-group">
                  <label>해당층 <span class="text-danger">*</span></label>
                  <input type="text" name="floorNo" class="form-control" value="${prop.floorNo}" />
                </div>
              </div>
              <div class="col-md-2">
                <div class="form-group">
                  <label>총층</label>
                  <input type="text" name="floorTotal" class="form-control" value="${prop.floorTotal}" />
                </div>
              </div>
              <div class="col-md-2">
                <div class="form-group">
                  <label>현관구조</label>
                  <select name="entranceType" class="form-control">
                    <option value="">선택</option>
                    <option value="복도식" ${prop.entranceType eq '복도식' ? 'selected' : ''}>복도식</option>
                    <option value="계단식" ${prop.entranceType eq '계단식' ? 'selected' : ''}>계단식</option>
                  </select>
                </div>
              </div>
              <div class="col-md-3">
                <div class="form-group">
                  <label>주차</label>
                  <input type="text" name="parking" class="form-control" value="${prop.parking}" placeholder="세대당 1대" />
                </div>
              </div>
              <div class="col-md-3">
                <div class="form-group">
                  <label>난방방식</label>
                  <input type="text" name="heating" class="form-control" value="${prop.heating}" placeholder="개별난방 (도시가스)" />
                </div>
              </div>
            </div>
            <div class="row">
              <div class="col-md-3">
                <div class="form-group">
                  <label>건축년도</label>
                  <input type="text" name="buildYear" class="form-control" value="${prop.buildYear}" placeholder="2020" />
                </div>
              </div>
              <div class="col-md-3">
                <div class="form-group">
                  <label>입주가능일</label>
                  <input type="text" name="moveInDate" class="form-control" value="${prop.moveInDate}" placeholder="즉시입주 / 2026-04 등" />
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 위치 -->
        <div class="card">
          <div class="card-header"><h5 class="card-title mb-0">위치정보</h5></div>
          <div class="card-body">
            <div class="row">
              <!-- 좌측: 주소 입력 -->
              <div class="col-md-6">
                <div class="form-group">
                  <label>주소 <span class="text-danger">*</span></label>
                  <div class="input-group">
                    <input type="text" name="address" id="address" class="form-control" value="${prop.address}" placeholder="주소 검색 버튼을 클릭하세요" readonly />
                    <div class="input-group-append">
                      <button type="button" class="btn btn-bo-save" onclick="fnSearchAddress()">주소 검색</button>
                    </div>
                  </div>
                </div>
                <div class="form-group">
                  <label>상세주소</label>
                  <input type="text" name="addressDtl" id="addressDtl" class="form-control" value="${prop.addressDtl}" placeholder="상세주소 입력 (동/호수 등)" />
                </div>
                <div class="row">
                  <div class="col-6">
                    <div class="form-group">
                      <label>위도</label>
                      <input type="text" name="lat" id="lat" class="form-control" value="${prop.lat}" readonly style="background:#f4f4f4;" />
                    </div>
                  </div>
                  <div class="col-6">
                    <div class="form-group">
                      <label>경도</label>
                      <input type="text" name="lng" id="lng" class="form-control" value="${prop.lng}" readonly style="background:#f4f4f4;" />
                    </div>
                  </div>
                </div>
              </div>
              <!-- 우측: 지도 미리보기 -->
              <div class="col-md-6">
                <label>지도 미리보기</label>
                <div id="propMapPreview" style="width:100%; height:220px; border:1px solid #ddd; border-radius:8px; overflow:hidden; background:#f4f4f4; display:flex; align-items:center; justify-content:center; color:#999; font-size:13px;">
                  주소를 검색하면 지도가 표시됩니다
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 노출설정 -->
        <div class="card">
          <div class="card-header"><h5 class="card-title mb-0">노출 / 상태</h5></div>
          <div class="card-body">
            <div class="row">
              <div class="col-md-4">
                <div class="form-group">
                  <label>뱃지</label>
                  <select name="badgeType" class="form-control">
                    <option value="NONE" ${prop.badgeType eq 'NONE' or empty prop.badgeType ? 'selected' : ''}>선택없음</option>
                    <option value="RECOMMEND" ${prop.badgeType eq 'RECOMMEND' ? 'selected' : ''}>추천</option>
                    <option value="URGENT" ${prop.badgeType eq 'URGENT' ? 'selected' : ''}>급매</option>
                  </select>
                  <small class="text-muted">추천/급매 설정 시 메인 슬라이더에 자동 노출됩니다.</small>
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-group">
                  <label>거래상태</label>
                  <select name="soldYn" class="form-control">
                    <option value="N" ${prop.soldYn ne 'Y' ? 'selected' : ''}>거래중</option>
                    <option value="Y" ${prop.soldYn eq 'Y' ? 'selected' : ''}>거래완료</option>
                  </select>
                </div>
              </div>
              <c:if test="${not empty prop}">
              <div class="col-md-4">
                <div class="form-group">
                  <label>조회수</label>
                  <input type="text" class="form-control" value="${prop.viewCnt != null ? prop.viewCnt : 0}" readonly style="background:#f4f4f4;" />
                </div>
              </div>
              </c:if>
            </div>
          </div>
        </div>

        <!-- 매물 설명 -->
        <div class="card">
          <div class="card-header"><h5 class="card-title mb-0">매물 설명</h5></div>
          <div class="card-body">
            <textarea id="initPropDesc" style="display:none;"><c:out value="${prop.propDesc}" escapeXml="true"/></textarea>
            <textarea id="summernote"></textarea>
            <input type="hidden" name="propDesc" id="propDescHidden" />
          </div>
        </div>

        <!-- 첨부파일 -->
        <div class="card">
          <div class="card-header"><h5 class="card-title mb-0">이미지 첨부</h5></div>
          <div class="card-body">
            <c:if test="${not empty fileList}">
              <div id="existFileWrap" class="mb-3">
                <c:forEach var="file" items="${fileList}">
                  <div class="d-flex align-items-center mb-1" data-upld-file-cd="${file.upldFileCd}" data-file-seq="${file.fileSeq}">
                    <a href="${ctx}/file/download?upldFileCd=${file.upldFileCd}&fileSeq=${file.fileSeq}">📎 ${file.fileNm}</a>
                    <button type="button" class="btn btn-xs btn-outline-danger ml-2" onclick="fnRemoveExistFile(this)">삭제</button>
                    <button type="button" class="btn btn-xs btn-outline-warning ml-1" onclick="fnRestoreExistFile(this)" style="display:none;">취소</button>
                  </div>
                </c:forEach>
              </div>
            </c:if>

            <!-- 드래그앤드롭 영역 -->
            <div id="dropZone" class="drop-zone">
              <div class="drop-zone-inner">
                <div class="drop-zone-icon">📷</div>
                <p class="drop-zone-text">이미지를 여기에 드래그하거나 <span class="drop-zone-browse">클릭하여 선택</span></p>
                <p class="drop-zone-hint">최대 10개, 파일당 20MB 이하 (JPG, PNG, GIF, WEBP)</p>
              </div>
              <input type="file" id="dropFileInput" multiple accept="image/*" style="display:none;" />
            </div>

            <!-- 추가된 파일 미리보기 -->
            <div id="newFilePreview" class="file-preview-wrap"></div>
          </div>
        </div>

      </form>

      <!-- 버튼 -->
      <!-- 버튼 -->
      <div style="text-align:center; padding:40px 0 80px;">
        <button type="button" class="btn btn-bo-reset" onclick="fnGoList()">목록</button>
        <c:if test="${not empty prop}">
        <button type="button" class="btn btn-bo-reset ml-2" onclick="fnDelete()">삭제</button>
        </c:if>
        <button type="button" class="btn btn-bo-save ml-2" onclick="fnSave()">저장</button>
        <c:if test="${not empty prop}">
        <button type="button" class="btn btn-bo-reset ml-2" onclick="fnCopy()">복사</button>
        </c:if>
      </div>

    </div>
  </section>
</div>

<form id="goWriteForm" action="${ctx}/propertyMng/viewPropertyWrite" method="post" style="display:none;">
  <input type="hidden" name="propCd" id="writePropCd" />
</form>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d53f71f3d9ea4c5c59f5f63df52a5c0d&libraries=services&autoload=false"></script>

<style>
.drop-zone {
  border: 2px dashed #ccc; border-radius: 12px; padding: 40px 20px;
  text-align: center; cursor: pointer; transition: all 0.2s;
  background: #fafafa;
}
.drop-zone:hover, .drop-zone.dragover {
  border-color: #007bff; background: #f0f7ff;
}
.drop-zone.dragover .drop-zone-icon { transform: scale(1.15); }
.drop-zone-icon { font-size: 36px; margin-bottom: 8px; transition: transform 0.2s; }
.drop-zone-text { font-size: 14px; color: #555; margin: 0 0 4px; }
.drop-zone-browse { color: #007bff; font-weight: 600; text-decoration: underline; }
.drop-zone-hint { font-size: 12px; color: #999; margin: 0; }

.file-preview-wrap { display: flex; flex-wrap: wrap; gap: 12px; margin-top: 16px; }
.file-preview-item {
  position: relative; width: 120px; border: 1px solid #e0e0e0; border-radius: 8px;
  overflow: hidden; background: #fff;
}
.file-preview-item img {
  width: 120px; height: 90px; object-fit: cover; display: block;
}
.file-preview-item .fp-name {
  padding: 4px 6px; font-size: 11px; color: #555;
  white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
}
.file-preview-item .fp-size {
  padding: 0 6px 4px; font-size: 10px; color: #999;
}
.file-preview-item .fp-remove {
  position: absolute; top: 4px; right: 4px;
  width: 22px; height: 22px; border-radius: 50%;
  background: rgba(0,0,0,0.55); color: #fff; border: none;
  font-size: 14px; line-height: 22px; text-align: center;
  cursor: pointer; transition: background 0.15s;
}
.file-preview-item .fp-remove:hover { background: rgba(220,53,69,0.85); }
</style>

<script>
  // 다음 우편번호 + 카카오 Geocoder
  function fnSearchAddress() {
    new daum.Postcode({
      oncomplete: function(data) {
        var addr = data.roadAddress || data.jibunAddress;
        console.log('[주소선택]', addr);
        $('#address').val(addr);
        $('#addressDtl').val('').focus();

        // 카카오 Geocoder로 좌표 변환
        kakao.maps.load(function() {
          var geocoder = new kakao.maps.services.Geocoder();
          geocoder.addressSearch(addr, function(results, status) {
            console.log('[Geocoder] status:', status, 'results:', results);
            if (status === kakao.maps.services.Status.OK) {
              var lat = results[0].y;
              var lng = results[0].x;
              $('#lat').val(lat);
              $('#lng').val(lng);
              fnShowMapPreview(lat, lng);
            } else {
              $('#lat').prop('readonly', false).css('background', '');
              $('#lng').prop('readonly', false).css('background', '');
              alert('좌표를 자동으로 가져올 수 없습니다.\n위도/경도를 직접 입력해주세요.');
            }
          });
        });
      }
    }).open();
  }

  // 지도 미리보기
  function fnShowMapPreview(lat, lng) {
    kakao.maps.load(function() {
      var container = document.getElementById('propMapPreview');
      container.innerHTML = '';
      container.style.color = '';
      container.style.fontSize = '';
      container.style.display = '';
      var map = new kakao.maps.Map(container, {
        center: new kakao.maps.LatLng(lat, lng),
        level: 3
      });
      var marker = new kakao.maps.Marker({ position: new kakao.maps.LatLng(lat, lng) });
      marker.setMap(map);
      map.addControl(new kakao.maps.ZoomControl(), kakao.maps.ControlPosition.RIGHT);
    });
  }

  // 수정 모드: 기존 좌표 있으면 지도 표시
  $(function() {
    var lat = '${prop.lat}';
    var lng = '${prop.lng}';
    if (lat && lng && lat !== '' && lng !== '' && lat !== 'null' && lng !== 'null') {
      fnShowMapPreview(parseFloat(lat), parseFloat(lng));
    }
  });

  const editor = EDIT.Summernote.init({
    el: '#summernote',
    ctx: '${ctx}',
    initSelector: '#initPropDesc',
    height: 350
  });

  /* ===== 드래그앤드롭 파일 업로드 ===== */
  var newFiles = []; // { file, id }
  var fileIdSeq = 0;
  var MAX_FILES = 10;
  var MAX_SIZE = 20 * 1024 * 1024;
  var ALLOWED_TYPES = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];

  var $dropZone = $('#dropZone');
  var $dropInput = $('#dropFileInput');

  // 클릭 → 파일선택
  $dropZone.on('click', function(e) {
    if (e.target === $dropInput[0]) return; // input 자체 클릭은 무시
    $dropInput.trigger('click');
  });
  $dropInput.on('click', function(e) { e.stopPropagation(); });
  $dropInput.on('change', function() {
    fnHandleFiles(this.files);
    this.value = '';
  });

  // 드래그 이벤트
  $dropZone.on('dragenter dragover', function(e) {
    e.preventDefault(); e.stopPropagation();
    $dropZone.addClass('dragover');
  });
  $dropZone.on('dragleave drop', function(e) {
    e.preventDefault(); e.stopPropagation();
    $dropZone.removeClass('dragover');
  });
  $dropZone.on('drop', function(e) {
    var dt = e.originalEvent.dataTransfer;
    if (dt && dt.files) fnHandleFiles(dt.files);
  });

  function fnHandleFiles(fileList) {
    var existCnt = $('#existFileWrap div[data-upld-file-cd]').length - $('#propForm .deleteFileInput').length;
    if (existCnt < 0) existCnt = 0;

    for (var i = 0; i < fileList.length; i++) {
      var f = fileList[i];

      if (existCnt + newFiles.length >= MAX_FILES) {
        alert('최대 ' + MAX_FILES + '개까지 첨부할 수 있습니다.'); break;
      }
      if (f.size > MAX_SIZE) {
        alert('"' + f.name + '" 파일이 20MB를 초과합니다.'); continue;
      }
      if (ALLOWED_TYPES.indexOf(f.type) === -1) {
        alert('"' + f.name + '"은 지원하지 않는 파일 형식입니다.\n(JPG, PNG, GIF, WEBP만 가능)'); continue;
      }

      var id = 'nf_' + (++fileIdSeq);
      newFiles.push({ file: f, id: id });
      fnRenderPreview(f, id);
    }
  }

  function fnRenderPreview(file, id) {
    var reader = new FileReader();
    reader.onload = function(e) {
      var sizeStr = file.size < 1024 * 1024
        ? (file.size / 1024).toFixed(0) + 'KB'
        : (file.size / (1024 * 1024)).toFixed(1) + 'MB';

      var html = '<div class="file-preview-item" data-file-id="' + id + '">'
        + '<button type="button" class="fp-remove" onclick="fnRemoveNewFile(\'' + id + '\')">&times;</button>'
        + '<img src="' + e.target.result + '" />'
        + '<div class="fp-name" title="' + file.name + '">' + file.name + '</div>'
        + '<div class="fp-size">' + sizeStr + '</div>'
        + '</div>';
      $('#newFilePreview').append(html);
    };
    reader.readAsDataURL(file);
  }

  function fnRemoveNewFile(id) {
    newFiles = newFiles.filter(function(f) { return f.id !== id; });
    $('.file-preview-item[data-file-id="' + id + '"]').remove();
  }

  function fnRemoveExistFile(btn) {
    var $row = $(btn).closest('div[data-upld-file-cd]');
    $row.find('a').css({'text-decoration':'line-through','color':'#999'});
    $(btn).hide(); $row.find('[onclick*="fnRestoreExistFile"]').show();
    var key = $row.data('upld-file-cd') + ':' + $row.data('file-seq');
    $('#propForm').append('<input type="hidden" name="deleteFiles" class="deleteFileInput" value="' + key + '" />');
  }

  function fnRestoreExistFile(btn) {
    var $row = $(btn).closest('div[data-upld-file-cd]');
    $row.find('a').css({'text-decoration':'','color':''});
    $(btn).hide(); $row.find('[onclick*="fnRemoveExistFile"]').show();
    var key = $row.data('upld-file-cd') + ':' + $row.data('file-seq');
    $('#propForm .deleteFileInput').filter(function(){ return $(this).val() === key; }).remove();
  }

  function fnSave() {
    if (!$('#propNm').val().trim()) { alert('매물명을 입력해주세요.'); $('#propNm').focus(); return; }
    if (!$('#address').val().trim()) { alert('주소를 입력해주세요.'); $('#address').focus(); return; }

    // 거래유형에 따른 가격 필수 체크
    var dealType = $('#dealType').val();
    if (dealType === 'SELL') {
      if (!$('input[name="sellPrice"]').val() || $('input[name="sellPrice"]').val() == '0') { alert('매매가를 입력해주세요.'); $('input[name="sellPrice"]').focus(); return; }
    } else if (dealType === 'JEONSE') {
      if (!$('input[name="deposit"]').val() || $('input[name="deposit"]').val() == '0') { alert('보증금을 입력해주세요.'); $('input[name="deposit"]').focus(); return; }
    } else {
      if (!$('input[name="deposit"]').val() && !$('input[name="monthlyRent"]').val()) { alert('보증금 또는 월세를 입력해주세요.'); $('input[name="deposit"]').focus(); return; }
    }

    // 전용면적
    if (!$('input[name="areaExclusive"]').val()) { alert('전용면적을 입력해주세요.'); $('input[name="areaExclusive"]').focus(); return; }

    // 방수 (상가/사무실은 0 허용)
    var propType = $('#propType').val();
    if ((propType === 'APT' || propType === 'OFFICETEL' || propType === 'VILLA' || propType === 'ONEROOM') && (!$('input[name="roomCnt"]').val() || $('input[name="roomCnt"]').val() == '0')) {
      alert('방수를 입력해주세요.'); $('input[name="roomCnt"]').focus(); return;
    }

    // 해당층
    if (!$('input[name="floorNo"]').val().trim()) { alert('해당층을 입력해주세요.'); $('input[name="floorNo"]').focus(); return; }

    // 에디터 내용 hidden에 세팅
    $('#propDescHidden').val(editor.getHTML());

    // FormData 빌드 (폼 데이터 + 드래그앤드롭 파일)
    var formData = new FormData($('#propForm')[0]);
    for (var i = 0; i < newFiles.length; i++) {
      formData.append('atchFile', newFiles[i].file);
    }

    var res = ajaxFormCall('${ctx}/propertyMng/saveProperty', formData, false);
    if (res && res.result === 'OK') {
      alert('저장되었습니다.');
      fnGoList();
    } else {
      alert('저장 실패: ' + (res && res.message ? res.message : ''));
    }
  }

  function fnGoList() {
    location.href = '${ctx}/propertyMng/viewPropertyMng';
  }

  function fnDelete() {
    if (!confirm('삭제하시겠습니까?\n삭제된 매물은 복구할 수 없습니다.')) return;
    var res = ajaxCall('${ctx}/propertyMng/deleteProperty', { propCd: '${prop.propCd}' }, false);
    if (res && res.resultCnt > 0) {
      alert('삭제되었습니다.');
      fnGoList();
    } else {
      alert('삭제 실패');
    }
  }

  function fnCopy() {
    if (!confirm('이 매물을 복사하시겠습니까?\n매물명 뒤에 "_복사본"이 붙습니다.')) return;
    var res = ajaxCall('${ctx}/propertyMng/copyProperty', { propCd: '${prop.propCd}' }, false);
    if (res && res.result === 'OK') {
      alert('복사되었습니다. 복사된 매물의 수정화면으로 이동합니다.');
      $('#writePropCd').val(res.newPropCd);
      $('#goWriteForm').submit();
    } else {
      alert('복사 실패: ' + (res && res.message ? res.message : ''));
    }
  }
</script>
