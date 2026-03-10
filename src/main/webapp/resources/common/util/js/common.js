function ajaxCall(url, params, async) {
    var obj = new Object();
    $.ajax({
        url: url,
        type: "POST",
        dataType: "json",
        async: async,
        beforeSend: function (xhr) {
            xhr.setRequestHeader("m", $("ilcs").attr("m"));
        },
        data: params,
        success: function (data) {
            obj = data;
        },
        error: function (jqXHR, ajaxSettings, thrownError) {
			console.log("error")
        }
    });

    return obj;
}

/**
 * FormData Ajax (공통)
 * - form: jQuery selector 또는 FormData 객체
 * - async: 동기/비동기 (기본 false)
 */
function ajaxFormCall(url, form, async) {
    var obj = new Object();
    var formData = (form instanceof FormData) ? form : new FormData($(form)[0]);

    $.ajax({
        url: url,
        type: "POST",
        data: formData,
        processData: false,
        contentType: false,
        async: (async !== undefined) ? async : false,
        beforeSend: function (xhr) {
            xhr.setRequestHeader("m", $("ilcs").attr("m"));
        },
        success: function (data) {
            obj = data;
        },
        error: function (jqXHR, ajaxSettings, thrownError) {
            console.log("error");
        }
    });

    return obj;
}

$(document).on("input", "[numeric]", function() {
    this.value = this.value.replace(/[^0-9]/g, '');
});

$(document).on("blur", "[numeric]", function() {
    let val = $(this).val().replace(/[^0-9]/g, ''); // 숫자만 남기기
    $(this).val(val);
});

function validateField(formSelector) {
    let isValid = true;

    $(formSelector).find("[required], .required").each(function() {
        if ($(this).val().trim() === "") {
            let label = $(this).data("label") || $(this).attr("name") || "해당 항목";
            alert(label + "을(를) 입력해주세요.");
            $(this).focus();
            isValid = false;
            return false;  // ← break each
        }
    });

    return isValid;
}

function decodeHtml(str){
    const t = document.createElement('textarea');
    t.innerHTML = str;
    return t.value;
}

/** XSS 방지 */
function escapeHtml(str){
  return String(str ?? "")
    .replaceAll("&","&amp;")
    .replaceAll("<","&lt;")
    .replaceAll(">","&gt;")
    .replaceAll('"',"&quot;")
    .replaceAll("'","&#39;");
}  


/* global $ */
(function (global) {
  "use strict";

  // ✅ jQuery 없으면 바로 터지게(원인 빨리 잡기)
  if (typeof global.$ === "undefined") {
    console.error("[FileUtil] jQuery($) is not loaded.");
    return;
  }

  /**
   * FormData Ajax (POST)
   */
  function _ajaxFormData(url, formData) {
    return $.ajax({
      url: url,
      type: "POST",
      data: formData,
      processData: false,
      contentType: false
    });
  }

  /**
   * 공통 업로드 1건
   * @param {File} file
   * @param {String} subDir   예: "license"
   * @param {String} ctx      예: "/kmwown" 또는 "" (contextPath)
   * @returns jqXHR(Promise-like)  { success, upldFileCd, url, ... }
   */
  function uploadCommonFile(file, subDir, ctx) {
    if (!file) return $.Deferred().reject(new Error("file is required")).promise();

    ctx = ctx || "";
    subDir = subDir || "common";

    var url = ctx + "/file/commonUpload";

    var fd = new FormData();
    fd.append("file", file, file.name);
    fd.append("subDir", subDir);

    return _ajaxFormData(url, fd);
  }

  /**
   * sheet rows 중 _file 있는 row만 업로드 후,
   * 업로드 성공하면 row에 fileKeyField 세팅하고 _file/_previewUrl 정리
   *
   * ✅ 기존행(이미 fileKeyField 값 있는 행)은 업로드 스킵 + 첨부수정 시도면 에러
   *
   * @param sheet  getRows(), row.getData(), row.update() 지원 가정
   * @param subDir 예: "license"
   * @param ctx    예: "${ctx}"
   * @param options
   *   - fileField: 기본 "_file"
   *   - fileKeyField: (필수) 예: "liceFileKey"
   *   - extraPatch: function(rowData, uploadRes, file) => ({...})
   */
  async function uploadPendingGridFiles(sheet, subDir, ctx, options) {
    options = options || {};
    var fileField = options.fileField || "_file";
    var fileKeyField = options.fileKeyField; // 필수
    var extraPatchFn = options.extraPatch;

    if (!fileKeyField) {
      throw new Error("fileKeyField is required (ex: 'liceFileKey')");
    }
    if (!sheet || !sheet.getRows) return;

    var rows = sheet.getRows();
    for (var i = 0; i < rows.length; i++) {
      var row = rows[i];
      var d = row.getData ? row.getData() : null;
      if (!d) continue;

      // ✅ 기존행(이미 fileKey 있으면) 업로드 대상 아님
      var existedKey = d[fileKeyField];
      if (existedKey != null && String(existedKey).trim() !== "") {
        // 기존행인데 _file이 있으면 = 첨부 수정 시도 → 막기
        if (d[fileField]) {
          throw new Error("첨부파일은 수정할 수 없습니다.");
        }
        continue;
      }

      var f = d[fileField];
      if (!f) continue; // 업로드할 파일 없으면 스킵

      // ✅ await 가능 (jQuery jqXHR는 thenable)
      var res = await uploadCommonFile(f, subDir, ctx);

      if (!res || res.fail) {
        throw new Error("파일 업로드 실패: " + ((res && res.message) ? res.message : "unknown"));
      }
      if (!res.upldFileCd) {
        throw new Error("파일 업로드 실패: upldFileCd 응답이 없음");
      }

      // 기본 patch
      var patch = {};
      patch[fileKeyField] = res.upldFileCd;

      // 로컬 정리
      patch[fileField] = null;
      if (d._previewUrl) patch._previewUrl = null;

      // 화면별 추가 patch
      if (typeof extraPatchFn === "function") {
        var extra = extraPatchFn(d, res, f);
        if (extra && typeof extra === "object") {
          for (var k in extra) patch[k] = extra[k];
        }
      }

      if (row.update) row.update(patch);
      else Object.assign(d, patch);
    }
  }

  //여기 핵심: 전역(FileUtil)로 무조건 박기
  global.FileUtil = global.FileUtil || {};
  global.FileUtil.uploadCommonFile = uploadCommonFile;
  global.FileUtil.uploadPendingGridFiles = uploadPendingGridFiles;

  // 로드 확인용(원하면 지워)
  // console.log("[FileUtil] loaded", global.FileUtil);

})(window);

/* ===============================
 * 부동산 금액 포맷 유틸 (원 → 억/만원)
 * =============================== */
(function(global) {
  /**
   * 원 단위 금액을 한국식 부동산 표기로 변환
   * formatPrice(385000000) → "3억 8,500만"
   * formatPrice(280000000) → "2억 8,000만"
   * formatPrice(15000000)  → "1,500만"
   * formatPrice(600000)    → "60만"
   * formatPrice(0)         → "-"
   */
  function formatPrice(val) {
    val = parseInt(val) || 0;
    if (val <= 0) return '-';

    var eok = Math.floor(val / 100000000);
    var man = Math.floor((val % 100000000) / 10000);
    var parts = [];

    if (eok > 0) parts.push(eok + '억');
    if (man > 0) parts.push(man.toLocaleString() + '만');

    // 억, 만 둘 다 0이면 (1만원 미만)
    if (parts.length === 0) return val.toLocaleString() + '원';

    return parts.join(' ');
  }

  /**
   * 페이지 로드 시 .price-format 요소를 자동 포맷
   * data-sell, data-deposit, data-rent, data-deal-type 속성 사용
   */
  function initPriceFormat() {
    var els = document.querySelectorAll('.price-format');
    els.forEach(function(el) {
      var dealType = el.getAttribute('data-deal-type') || '';
      var sell = el.getAttribute('data-sell') || '0';
      var deposit = el.getAttribute('data-deposit') || '0';
      var rent = el.getAttribute('data-rent') || '0';
      var html = '';

      if (dealType === 'SELL') {
        html = '<strong>' + formatPrice(parseInt(sell)) + '</strong>';
      } else if (dealType === 'JEONSE') {
        html = '<strong>' + formatPrice(parseInt(deposit)) + '</strong>';
      } else {
        html = '<strong>' + formatPrice(parseInt(deposit)) + '/' + formatPrice(parseInt(rent)) + '</strong>';
      }
      el.innerHTML = html;
    });
  }

  global.PriceUtil = { formatPrice: formatPrice, initPriceFormat: initPriceFormat };

  // DOM 로드 시 자동 실행 (중복 호출 방지)
  var _priceFormatDone = false;
  function runOnce() {
    if (_priceFormatDone) return;
    _priceFormatDone = true;
    initPriceFormat();
  }

  // 방법1: DOMContentLoaded
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', runOnce);
  } else {
    runOnce();
  }

  // 방법2: jQuery ready (백업)
  if (typeof jQuery !== 'undefined') {
    jQuery(function() { runOnce(); });
  }
})(window);

