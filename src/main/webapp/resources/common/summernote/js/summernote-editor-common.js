/* global $, window */
window.EDIT = window.EDIT || {};

EDIT.Summernote = (function () {

  /* ── 유틸 ─────────────────────────────────────── */

  function decodeHtml(str) {
    if (!str) return "";
    var txt = document.createElement("textarea");
    txt.innerHTML = str;
    return txt.value;
  }

  function debounce(fn, wait) {
    var t = null;
    return function () {
      var args = arguments;
      clearTimeout(t);
      t = setTimeout(function () { fn.apply(null, args); }, wait);
    };
  }

  /* ── 이미지 파일명 추출 (/upload/editor/xxxxx) ── */

  function extractFileNameFromImgSrc(src) {
    if (!src) return null;
    try {
      var u = new URL(src, window.location.origin);
      var path = u.pathname || "";
      var key = "/upload/editor/";
      var idx = path.indexOf(key);
      if (idx === -1) return null;
      var tail = path.substring(idx + key.length);
      if (!tail || tail.includes("/")) return null;
      return tail;
    } catch (e) {
      return null;
    }
  }

  function getEditorImageFileSet(html) {
    var set = new Set();
    if (!html) return set;
    var wrap = document.createElement("div");
    wrap.innerHTML = html;
    wrap.querySelectorAll("img[src]").forEach(function (img) {
      var fn = extractFileNameFromImgSrc(img.getAttribute("src"));
      if (fn) set.add(fn);
    });
    return set;
  }

  function diffRemoved(prevSet, nextSet) {
    var removed = [];
    prevSet.forEach(function (v) { if (!nextSet.has(v)) removed.push(v); });
    return removed;
  }

  /* ── 서버 이미지 삭제 요청 ───────────────────── */

  function deleteServerImage(deleteUrl, fileName) {
    var fd = new FormData();
    fd.append("fileName", fileName);
    $.ajax({
      url: deleteUrl,
      type: "POST",
      data: fd,
      processData: false,
      contentType: false,
      success: function () {},
      error: function (xhr) {
        console.warn("Summernote delete fail:", fileName, xhr.status);
      }
    });
  }

  /* ── 필수입력 체크 ───────────────────────────── */

  function validateRequired(editor, form) {
    var html = (editor && editor.getData) ? (editor.getData() || "") : "";
    var wrap = document.createElement("div");
    wrap.innerHTML = html;

    var textOnly = (wrap.textContent || "").replace(/\u00a0/g, "").trim();
    var hasMedia = !!wrap.querySelector("img, video, iframe, object, embed");
    var hasFile = false;
    var formEl = null;

    if (typeof form === "string") formEl = document.querySelector(form);
    else if (form && form.nodeType === 1) formEl = form;

    if (formEl) {
      var fileInputs = formEl.querySelectorAll('input[type="file"]');
      for (var i = 0; i < fileInputs.length; i++) {
        if (fileInputs[i].files && fileInputs[i].files.length > 0) { hasFile = true; break; }
      }
    }
    return !!(textOnly || hasMedia || hasFile);
  }

  /* ── 초기화 ──────────────────────────────────── */
  /**
   * @param opts
   *   - el           : selector (예: '#summernote')
   *   - ctx          : contextPath
   *   - initSelector : 초기값 textarea selector
   *   - initHtml     : 초기 HTML 직접 전달
   *   - height       : 에디터 높이 (기본 400, 숫자)
   *   - uploadUrl    : 이미지 업로드 URL (기본 /file/editorUpload)
   *   - deleteUrl    : 이미지 삭제 URL  (기본 /file/editorDelete)
   *   - deleteDebounceMs : 삭제 디바운스 ms (기본 800)
   *   - toolbar      : 커스텀 툴바 (선택)
   * @returns wrapper { getData, setData, getHTML, setHTML, focus, getInstance }
   */
  function init(opts) {
    var elSelector = opts.el || "#summernote";
    var ctx = opts.ctx || "";
    var uploadUrl = ctx + (opts.uploadUrl || "/file/editorUpload");
    var deleteUrl = ctx + (opts.deleteUrl || "/file/editorDelete");
    var height = parseInt(opts.height) || 400;

    // 초기 HTML
    var initHtml = "";
    if (opts.initHtml != null) {
      initHtml = opts.initHtml;
    } else if (opts.initSelector) {
      initHtml = decodeHtml($(opts.initSelector).val() || "");
    }

    // 기본 툴바
    var toolbar = opts.toolbar || [
      ['style', ['style']],
      ['font', ['bold', 'italic', 'underline', 'strikethrough']],
      ['fontsize', ['fontsize']],
      ['color', ['color']],
      ['para', ['ul', 'ol', 'paragraph']],
      ['table', ['table']],
      ['insert', ['link', 'picture']],
      ['view', ['codeview', 'undo', 'redo']]
    ];

    // 이미지 삭제 감지용
    var prevImages = getEditorImageFileSet(initHtml);
    var $el = $(elSelector);

    var onChangeDebounced = debounce(function () {
      var nowHtml = $el.summernote('code');
      var nowImages = getEditorImageFileSet(nowHtml);
      var removed = diffRemoved(prevImages, nowImages);

      removed.forEach(function (fileName) {
        deleteServerImage(deleteUrl, fileName);
      });

      prevImages = nowImages;
    }, opts.deleteDebounceMs || 800);

    // Summernote 초기화
    $el.summernote({
      lang: 'ko-KR',
      height: height,
      toolbar: toolbar,
      fontSizes: ['8','9','10','11','12','14','16','18','20','22','24','28','32','36'],
      callbacks: {
        onInit: function () {
          // 초기값 세팅
          if (initHtml) {
            $el.summernote('code', initHtml);
            prevImages = getEditorImageFileSet(initHtml);
          }
        },
        onImageUpload: function (files) {
          for (var i = 0; i < files.length; i++) {
            uploadImage(files[i], $el, uploadUrl, prevImages);
          }
        },
        onChange: function () {
          onChangeDebounced();
        },
        onMediaDelete: function (target) {
          // 이미지 직접 삭제 시 (Delete키, 백스페이스 등)
          var src = $(target).attr('src') || '';
          var fileName = extractFileNameFromImgSrc(src);
          if (fileName) {
            deleteServerImage(deleteUrl, fileName);
            prevImages.delete(fileName);
          }
        }
      }
    });

    // 래퍼 반환 (CKEditor common과 동일 인터페이스)
    return {
      getData: function () { return $el.summernote('code'); },
      getHTML: function () { return $el.summernote('code'); },
      setData: function (html) { $el.summernote('code', html); prevImages = getEditorImageFileSet(html); },
      setHTML: function (html) { $el.summernote('code', html); prevImages = getEditorImageFileSet(html); },
      focus: function () { $el.summernote('focus'); },
      isEmpty: function () { return $el.summernote('isEmpty'); },
      getInstance: function () { return $el; }
    };
  }

  /* ── 이미지 업로드 ───────────────────────────── */

  function uploadImage(file, $el, uploadUrl, prevImages) {
    var fd = new FormData();
    fd.append("image", file, file.name);

    $.ajax({
      url: uploadUrl,
      type: "POST",
      data: fd,
      processData: false,
      contentType: false,
      success: function (res) {
        if (res && res.fail) {
          alert(res.message || "업로드 실패");
          return;
        }
        var url = res && (res.returnUrl || res.url);
        if (!url) {
          alert("응답에 URL이 없습니다.");
          return;
        }
        $el.summernote('insertImage', url);
        // 업로드 성공 시 이미지 목록 갱신
        var fileName = extractFileNameFromImgSrc(url);
        if (fileName) prevImages.add(fileName);
      },
      error: function (xhr) {
        alert("이미지 업로드 실패: " + (xhr.status || ""));
      }
    });
  }

  return { init: init, decodeHtml: decodeHtml, validateRequired: validateRequired };
})();
