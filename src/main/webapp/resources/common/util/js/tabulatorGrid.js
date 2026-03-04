// tabulatorGrid.js (SIMPLE + NO jQuery)
// - dirty(신규/수정) 한 가지 상태만 관리: row._tgDirty = true/false
// - TG.getDirtyData(table): dirty 행만 뽑아서 MERGE로 보내기
// - TG.commit(table): 저장 성공 후 dirty 초기화 + 원본 스냅샷 갱신

(function (w) {
  w.TG = w.TG || {};
  var TG = w.TG;

  function isObj(x) {
    return x && typeof x === "object" && !Array.isArray(x);
  }

  function mergeDeep(target, src) {
    target = target || {};
    src = src || {};
    Object.keys(src).forEach(function (k) {
      if (isObj(src[k])) target[k] = mergeDeep(target[k], src[k]);
      else target[k] = src[k];
    });
    return target;
  }

  function clone(obj) {
    return JSON.parse(JSON.stringify(obj || {}));
  }

  function norm(v) {
    if (v === null || v === undefined) return "";
    return String(v).trim();
  }

  function strip(rowData, stripFields) {
    var d = Object.assign({}, rowData || {});
    (stripFields || []).forEach(function (k) { delete d[k]; });
    return d;
  }

  function isSameData(org, cur, ignoreFields) {
    org = org || {};
    cur = cur || {};
    var ignore = (ignoreFields || []).reduce(function (m, k) { m[k] = 1; return m; }, {});

    var keys = {};
    Object.keys(org).forEach(function (k) { if (!ignore[k]) keys[k] = 1; });
    Object.keys(cur).forEach(function (k) { if (!ignore[k]) keys[k] = 1; });

    for (var k in keys) {
      if (norm(org[k]) !== norm(cur[k])) return false;
    }
    return true;
  }

  TG.create = function (gridId, columns, options) {
    var selector = (gridId || "").startsWith("#") ? gridId : ("#" + gridId);
    options = options || {};

    // paging 의도 판단
    var usePaging =
      (options.pagination === true) ||
      (options.pagination !== false && (options.paginationMode || options.paginationSize));

    // dirty 추적 기본 ON
    if (options.trackDirty === undefined) options.trackDirty = true;

    // 비교에서 제외할 필드(내부/가상컬럼)
    // - 삭제버튼용 "_del" 많이 쓰니 기본 제외
    if (!options.ignoreFields) options.ignoreFields = ["_del"];
    // 서버 전송에서 제거할 필드
    if (!options.stripFields) options.stripFields = ["_del"];

    var baseOpt = {
      height: "600px",
      layout: "fitColumns",
      selectable: 1,
      data: [],
      columns: columns || []
    };

    if (usePaging) {
      baseOpt.pagination = true;
      baseOpt.paginationMode = "local";
      baseOpt.paginationSize = 10;
      baseOpt.paginationSizeSelector = [10, 20, 50, 100];
    } else {
      baseOpt.pagination = false;
    }

    // ✅ rowFormatter는 이벤트가 아니라 옵션이므로 여기에서 넣는다
    baseOpt.rowFormatter = function (row) {
      var el = row.getElement();
      if (!el) return;
      el.classList.toggle("tg-row-dirty", !!row._tgDirty);
    };

    var finalOpt = mergeDeep(baseOpt, options);
    finalOpt.columns = columns || [];

    if (finalOpt.pagination === false) {
      delete finalOpt.paginationMode;
      delete finalOpt.paginationSize;
      delete finalOpt.paginationSizeSelector;
      delete finalOpt.paginationButtonCount;
    }

    if (typeof Tabulator === "undefined") {
      console.error("[TG.create] Tabulator not loaded");
      return null;
    }

    var table = new Tabulator(selector, finalOpt);

    if (finalOpt.trackDirty) {
      TG.bindDirty(table, finalOpt);
    }

    return table;
  };

  TG.bind = function (table, rows, page) {
    if (!table) return;
    var data = Array.isArray(rows) ? rows : [];
    var p = table.setData(data);

    function after() {
      if (table.getPage && table.setPage) {
        try { table.setPage(page || 1); } catch (e) {}
      }
      if (typeof table._tgMarkClean === "function") table._tgMarkClean();
    }

    if (p && typeof p.then === "function") p.then(after);
    else after();
  };

  TG.load = function (table, url, params, async, dataKey) {
    if (typeof ajaxCall !== "function") {
      console.error("[TG.load] ajaxCall not found");
      return null;
    }
    async = (async === undefined ? false : async);

    var key = dataKey || "DATA";
    var res = ajaxCall(url, (params || {}), async);
    var rows = (res && res[key]) ? res[key] : [];

    TG.bind(table, rows, 1);
    return res;
  };

  // =========================
  // Dirty Tracking (단일 체계)
  // =========================
  TG.bindDirty = function (table, opt) {
    opt = opt || {};
    var ignoreFields = opt.ignoreFields || ["_del"];

    // 현재 데이터 기준 clean 스냅샷
    table._tgMarkClean = function () {
      table.getRows().forEach(function (r) {
        r._tgOriginal = clone(r.getData());
        r._tgDirty = false;
      });
      try { table.redraw(true); } catch (e) {}
    };

    // 신규 row => dirty
    table.on("rowAdded", function (row) {
      row._tgDirty = true;
      // 신규는 원본이 의미 없지만, 원복 비교 위해 현재값 스냅샷 저장
      row._tgOriginal = clone(row.getData());
      try { table.redraw(true); } catch (e) {}
    });

    // 수정 => 원본과 비교해 dirty/clean
    table.on("cellEdited", function (cell) {
      var row = cell.getRow();
      if (!row._tgOriginal) {
        row._tgDirty = true;
      } else {
        var cur = row.getData();
        var org = row._tgOriginal;
        row._tgDirty = !isSameData(org, cur, ignoreFields);
      }
      try { table.redraw(true); } catch (e) {}
    });

    // 처음 build 후 clean 스냅샷
    table.on("tableBuilt", function () {
      table._tgMarkClean();
    });
  };

  // dirty 행만 추출(MERGE 전송용)
  TG.getDirtyData = function (table) {
    if (!table) return [];
    var stripFields = (table.options && table.options.stripFields) ? table.options.stripFields : ["_del"];

    var out = [];
    table.getRows().forEach(function (r) {
      if (r._tgDirty) out.push(strip(r.getData(), stripFields));
    });
    return out;
  };

  // 저장 성공 후: dirty 초기화 + 원본 갱신
  TG.commit = function (table) {
    if (!table) return;
    if (typeof table._tgMarkClean === "function") table._tgMarkClean();
  };
  
  // ===============================
  // Validation (공통)
  // - alert/focus를 옵션으로 제어
  // ===============================
  TG.validate = function(table, opt){
    opt = opt || {};
    if(!table) return false;

    var res = table.validate();   // true or [CellComponent...]
    if(res === true) return true;

    // ✅ 포커스(첫 오류 셀로 이동) : 기본 true
    if(opt.focus !== false){
      try{
        var cell = res[0];
        var row  = cell.getRow();
        var p = row.scrollTo ? row.scrollTo() : null;

        Promise.resolve(p).then(function(){
          if(cell && cell.edit) cell.edit();
        });
      }catch(e){}
    }

    // alert : 기본 false (중복 alert 방지)
//    if(opt.alert === true){
//      alert(opt.message || "필수값/형식을 확인해주세요.");
//    }

    return false;
  };


  //
  // ===============================
  // TG.save
  // - 이미 preValidate 했으면 skip 가능
  // ===============================
  TG.save = function(table, url, opt){
    opt = opt || {};

    var mergeKey   = opt.mergeKey || "mergeRows";
    var async      = (opt.async === undefined ? false : opt.async);
    var extra      = opt.extraParams || {};

    // 메시지(기본값)
    var msgEmpty   = opt.msgEmpty   || "변경된 데이터가 없습니다.";
    var msgFail    = opt.msgFail    || "저장에 실패하였습니다.";

    // alert 사용 여부(기본 true)
    var alertEmpty = (opt.alertEmpty !== false);
    var alertFail  = (opt.alertFail  !== false);

    // 1) validate 제거 (JSP에서 먼저 TG.validate() 수행)

    // 2) dirty
    var dirty = TG.getDirtyData(table);
    if(!dirty || dirty.length === 0){
      if(alertEmpty) alert(msgEmpty);
      return { ok:false, code:"EMPTY", message: msgEmpty, dirty: [] };
    }

    // 3) ajax
    var params = Object.assign({}, extra);
    params[mergeKey] = JSON.stringify(dirty);

    var res = ajaxCall(url, params, async);

    // 4) success 판정 (프로젝트 규칙: resultCnt > 0)
    var success = !!(res && res.resultCnt > 0);

    if(!success){
      var serverMsg = (res && (res.Message || res.message)) ? (res.Message || res.message) : msgFail;
      if(alertFail) alert(serverMsg);
      return { ok:false, code:"FAIL", message: serverMsg, res: res, dirty: dirty };
    }else{
      TG.commit(table);
    }

    return { ok:true, code:"SUCCESS", res: res, dirty: dirty };
  };
  
  // 공통 삭제 (1건)
  // - row: Tabulator RowComponent
  // - url: 삭제 URL
  // - params: 서버로 보낼 파라미터 (예: {hstCd: "..."} )
  // - async: ajaxCall async (기본 false)
  // - opt: { confirmMsg }  // (선택) 서버삭제 confirm만
  TG.delete = function(row, url, params, async, opt){
    opt = opt || {};
    async = (async === undefined ? false : async);

    if(!row) return { ok:false, code:"EMPTY", res:null };

    // ✅ params 자체를 PK로 본다 (기본)
    //    단, params에 PK 외 다른 값도 섞일 수 있으면 opt.pkFields로 지정 가능
    var pkFields = Array.isArray(opt.pkFields) && opt.pkFields.length
      ? opt.pkFields
      : Object.keys(params || {});

    if(pkFields.length === 0){
      throw new Error("delete params(pk object) is required. ex) { liceCd: '...' }");
    }

    // ✅ PK 중 하나라도 비면 신규로 보고 로컬삭제
    var isNew = false;
    for(var i=0; i<pkFields.length; i++){
      var k = pkFields[i];
      var v = params ? params[k] : null;
      if(v == null || String(v).trim() === ""){
        isNew = true;
        break;
      }
    }

    if(isNew){
      row.delete();
      return { ok:true, code:"LOCAL", res:{ resultCnt:1 } };
    }

    if(!confirm(opt.confirmMsg || "삭제하시겠습니까?")){
      return { ok:false, code:"CANCEL", res:null };
    }

    if(typeof ajaxCall !== "function"){
      console.error("[TG.delete] ajaxCall not found");
      return { ok:false, code:"NO_AJAX", res:null };
    }

    var res = ajaxCall(url, (params || {}), async);

    if(res && Number(res.resultCnt) > 0){
      row.delete();
      return { ok:true, code:"OK", res:res };
    }

    alert((res && (res.Message || res.message)) ? (res.Message || res.message) : "삭제에 실패하였습니다.");
    return { ok:false, code:"FAIL", res:res };
  };

})(window);
