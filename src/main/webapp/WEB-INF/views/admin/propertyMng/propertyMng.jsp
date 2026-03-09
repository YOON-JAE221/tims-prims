<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<div class="content-wrapper">
  <div class="content-header">
    <div class="container">
      <div class="row mb-2">
        <div class="col-sm-6"><h4>매물관리</h4></div>
        <div class="col-sm-6">
          <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item active">매물관리</li>
            <li class="breadcrumb-item"><a href="${ctx}/propertyMng/viewPropertyMng">매물관리</a></li>
          </ol>
        </div>
      </div>
    </div>
  </div>

  <section class="content">
    <div class="container">
      <div class="card">
        <!-- 검색영역 -->
        <div class="card-header">
          <div class="row align-items-center">
            <div class="col-12 col-lg mb-2 mb-lg-0">
              <div class="d-flex flex-wrap align-items-center" style="gap:8px;">
                <select id="srchCatCd" class="form-control form-control-sm" style="width:120px;">
                  <option value="ALL">전체분류</option>
                  <c:forEach var="cat" items="${catList}">
                    <option value="${cat.catCd}">${cat.catNm}</option>
                  </c:forEach>
                </select>
                <select id="srchDealType" class="form-control form-control-sm" style="width:100px;">
                  <option value="ALL">전체거래</option>
                  <option value="SELL">매매</option>
                  <option value="JEONSE">전세</option>
                  <option value="WOLSE">월세</option>
                  <option value="SHORT">단기임대</option>
                </select>
                <select id="srchSoldYn" class="form-control form-control-sm" style="width:100px;">
                  <option value="ALL">전체상태</option>
                  <option value="N">거래중</option>
                  <option value="Y">거래완료</option>
                </select>
                <select id="srchBadgeType" class="form-control form-control-sm" style="width:100px;">
                  <option value="ALL">전체뱃지</option>
                  <option value="NONE">없음</option>
                  <option value="RECOMMEND">추천</option>
                  <option value="URGENT">급매</option>
                </select>
                <input type="text" id="srchKeyword" class="form-control form-control-sm" style="width:180px;" placeholder="매물명/주소 검색" onkeypress="if(event.keyCode===13) fnSearch();" />
                <button type="button" class="btn btn-sm btn-bo-search" onclick="fnSearch()">검색</button>
              </div>
            </div>
            <div class="col-12 col-lg-auto">
              <div class="d-flex justify-content-lg-end bo-actionbar">
                <button type="button" class="btn btn-sm btn-bo-add" onclick="fnGoWrite()">신규</button>
              </div>
            </div>
          </div>
        </div>

        <!-- 그리드 -->
        <div class="card-body">
          <div id="propGrid"></div>
        </div>
      </div>
    </div>
  </section>
</div>

<script>
var propTable = null;

$(function() {
  initGrid();
});

function initGrid() {
  var columns = [
    { title:"유형", field:"catNm", width:110, hozAlign:"center" },
    { title:"거래", field:"dealTypeNm", width:90, hozAlign:"center" },
    { title:"매물명", field:"propNm", minWidth:200,
      formatter: function(cell) {
        var d = cell.getRow().getData();
        var feature = d.propFeature ? '<br><small class="text-muted">' + d.propFeature + '</small>' : '';
        return cell.getValue() + feature;
      }
    },
    { title:"주소", field:"address", minWidth:180 },
    { title:"뱃지", field:"badgeType", width:70, hozAlign:"center",
      formatter: function(cell) {
        var v = cell.getValue();
        if (v === 'RECOMMEND') return '<span class="badge badge-primary">추천</span>';
        if (v === 'URGENT') return '<span class="badge badge-danger">급매</span>';
        return '-';
      }
    },
    { title:"상태", field:"soldYn", width:80, hozAlign:"center",
      formatter: function(cell) {
        return cell.getValue() === 'Y'
          ? '<span class="badge badge-secondary">거래완료</span>'
          : '<span class="badge badge-success">거래중</span>';
      }
    },
    { title:"조회수", field:"viewCnt", width:70, hozAlign:"center" },
    { title:"삭제", field:"_del", width:70, hozAlign:"center", headerSort:false,
      formatter: function() { return "<button type='button' class='btn btn-xs btn-bo-del'>삭제</button>"; },
      cellClick: function(e, cell) { fnDeleteProp(cell.getRow()); }
    }
  ];

  propTable = TG.create("propGrid", columns, {
    height: "600px",
    pagination: false,
    layout: "fitColumns",
    trackDirty: false,
    selectable: 1
  });

  propTable.on("tableBuilt", function() { fnSearch(); });
  propTable.on("rowDblClick", function(e, row) {
    var d = row.getData();
    location.href = '${ctx}/propertyMng/viewPropertyWrite?propCd=' + d.propCd;
  });
}

function fnSearch() {
  TG.load(propTable, '${ctx}/propertyMng/getSelectPropertyList', {
    catCd: $('#srchCatCd').val(),
    dealType: $('#srchDealType').val(),
    soldYn: $('#srchSoldYn').val(),
    badgeType: $('#srchBadgeType').val(),
    keyword: $('#srchKeyword').val()
  }, false, "DATA");
}

function fnGoWrite() {
  location.href = '${ctx}/propertyMng/viewPropertyWrite';
}

function fnDeleteProp(row) {
  var d = row.getData();
  if (!confirm('[' + d.propNm + '] 매물을 삭제하시겠습니까?')) return;
  var res = ajaxCall('${ctx}/propertyMng/deleteProperty', { propCd: d.propCd }, false);
  if (res && res.result === 'OK') {
    alert('삭제되었습니다.');
    fnSearch();
  } else {
    alert('삭제 실패');
  }
}
</script>
