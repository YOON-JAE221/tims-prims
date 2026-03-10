<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<style>
  .content-wrapper { padding-top: 20px !important; }

  /* ===== 상단 요약 카드 ===== */
  .dash-cards { display: grid; grid-template-columns: repeat(6, 1fr); gap: 16px; margin-bottom: 24px; }
  .dash-card {
    background: #fff; border-radius: 12px; padding: 20px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.06);
    position: relative; overflow: hidden;
    transition: transform 0.2s, box-shadow 0.2s;
    border: 1px solid #f0f0f0;
  }
  .dash-card:hover { transform: translateY(-3px); box-shadow: 0 6px 16px rgba(0,0,0,0.1); }
  .dash-card-icon {
    width: 44px; height: 44px; border-radius: 10px;
    display: flex; align-items: center; justify-content: center;
    font-size: 20px; margin-bottom: 14px;
  }
  .dash-card-label { font-size: 13px; color: #888; margin-bottom: 6px; }
  .dash-card-value { font-size: 28px; font-weight: 700; color: #1a2332; }
  .dash-card-value small { font-size: 14px; color: #aaa; font-weight: 500; }

  /* 카드 색상 */
  .dash-card.primary .dash-card-icon { background: #e8f4fd; color: #1976d2; }
  .dash-card.success .dash-card-icon { background: #e8f5e9; color: #43a047; }
  .dash-card.info .dash-card-icon { background: #f3e5f5; color: #8e24aa; }
  .dash-card.warning .dash-card-icon { background: #fff3e0; color: #fb8c00; }
  .dash-card.danger .dash-card-icon { background: #ffebee; color: #e53935; }
  .dash-card.dark .dash-card-icon { background: #eceff1; color: #546e7a; }

  .dash-card.danger { border-left: 4px solid #e53935; }
  .dash-card.danger .dash-card-value { color: #e53935; }
  .dash-card.clickable { cursor: pointer; }

  /* ===== 메인 콘텐츠 2컬럼 ===== */
  .dash-row { display: grid; grid-template-columns: 7fr 3fr; gap: 20px; }
  .dash-col-main { display: flex; flex-direction: column; gap: 20px; }
  .dash-col-side { display: flex; flex-direction: column; gap: 20px; }

  /* ===== 카드 공통 ===== */
  .dash-section {
    background: #fff; border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.06);
    border: 1px solid #f0f0f0;
  }
  .dash-section-header {
    display: flex; align-items: center; justify-content: space-between;
    padding: 16px 20px; border-bottom: 1px solid #f0f0f0;
  }
  .dash-section-title { font-size: 15px; font-weight: 700; color: #1a2332; display: flex; align-items: center; gap: 8px; }
  .dash-section-title i { color: #E8830C; }
  .dash-section-link { font-size: 13px; color: #888; transition: color 0.15s; }
  .dash-section-link:hover { color: #E8830C; }
  .dash-section-body { padding: 0; }

  /* ===== 인기매물 리스트 ===== */
  .top-prop-list { padding: 16px 20px; }
  .top-prop-item {
    display: flex; align-items: center; gap: 12px;
    padding: 12px 0; border-bottom: 1px solid #f5f5f5;
  }
  .top-prop-item:last-child { border-bottom: none; }
  .top-prop-rank {
    width: 26px; height: 26px; border-radius: 6px;
    background: #f5f5f5; color: #888;
    display: flex; align-items: center; justify-content: center;
    font-size: 12px; font-weight: 700; flex-shrink: 0;
  }
  .top-prop-rank.r1 { background: #E8830C; color: #fff; }
  .top-prop-rank.r2 { background: #1a2332; color: #fff; }
  .top-prop-rank.r3 { background: #546e7a; color: #fff; }
  .top-prop-info { flex: 1; min-width: 0; }
  .top-prop-name { font-size: 14px; font-weight: 600; color: #1a2332; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
  .top-prop-cat { font-size: 12px; color: #888; margin-top: 2px; }
  .top-prop-views { font-size: 13px; color: #E8830C; font-weight: 600; flex-shrink: 0; }

  /* ===== 빠른 바로가기 ===== */
  .quick-links { padding: 20px; display: flex; flex-direction: column; gap: 10px; }
  .quick-link {
    display: flex; align-items: center; gap: 12px;
    padding: 14px 16px; border-radius: 10px;
    background: #f8f9fa; border: 1px solid #eee;
    color: #1a2332; font-size: 14px; font-weight: 600;
    transition: all 0.2s; text-decoration: none;
  }
  .quick-link:hover { background: #E8830C; color: #fff; border-color: #E8830C; }
  .quick-link i { font-size: 16px; width: 20px; text-align: center; }

  /* ===== 반응형 ===== */
  @media (max-width: 1400px) {
    .dash-cards { grid-template-columns: repeat(3, 1fr); }
  }
  @media (max-width: 1200px) {
    .dash-row { grid-template-columns: 1fr; }
  }
  @media (max-width: 768px) {
    .dash-cards { grid-template-columns: repeat(2, 1fr); }
  }
</style>

<!-- Content Wrapper -->
<div class="content-wrapper">
  <section class="content" style="padding-top:32px;">
    <div class="container">

      <!-- ========== 상단 요약 카드 ========== -->
      <div class="dash-cards">
        <div class="dash-card primary clickable" onclick="location.href='${ctx}/propertyMng/viewPropertyMng'">
          <div class="dash-card-icon"><i class="fas fa-home"></i></div>
          <div class="dash-card-label">전체 매물</div>
          <div class="dash-card-value">${not empty propSummary.totalCnt ? propSummary.totalCnt : 0}<small> 건</small></div>
        </div>
        <div class="dash-card success clickable" onclick="location.href='${ctx}/propertyMng/viewPropertyMng'">
          <div class="dash-card-icon"><i class="fas fa-handshake"></i></div>
          <div class="dash-card-label">거래중</div>
          <div class="dash-card-value">${not empty propSummary.activeCnt ? propSummary.activeCnt : 0}<small> 건</small></div>
        </div>
        <div class="dash-card info clickable" onclick="location.href='${ctx}/propertyMng/viewPropertyMng'">
          <div class="dash-card-icon"><i class="fas fa-check-circle"></i></div>
          <div class="dash-card-label">거래완료</div>
          <div class="dash-card-value">${not empty propSummary.soldCnt ? propSummary.soldCnt : 0}<small> 건</small></div>
        </div>
        <div class="dash-card warning clickable" onclick="location.href='${ctx}/propertyMng/viewPropertyMng'">
          <div class="dash-card-icon"><i class="fas fa-star"></i></div>
          <div class="dash-card-label">추천 매물</div>
          <div class="dash-card-value">${not empty propSummary.recommendCnt ? propSummary.recommendCnt : 0}<small> 건</small></div>
        </div>
        <div class="dash-card dark clickable" onclick="location.href='${ctx}/propertyMng/viewPropertyMng'">
          <div class="dash-card-icon"><i class="fas fa-bolt"></i></div>
          <div class="dash-card-label">급매 매물</div>
          <div class="dash-card-value">${not empty propSummary.urgentCnt ? propSummary.urgentCnt : 0}<small> 건</small></div>
        </div>
        <div class="dash-card danger clickable" onclick="location.href='${ctx}/bbsComQnaMng/viewBbsComQnaMng'">
          <div class="dash-card-icon"><i class="fas fa-exclamation-circle"></i></div>
          <div class="dash-card-label">미답변 문의</div>
          <div class="dash-card-value">${not empty qna.unansweredCnt ? qna.unansweredCnt : 0}<small> 건</small></div>
        </div>
      </div>

      <!-- ========== 메인 콘텐츠 ========== -->
      <div class="dash-row">

        <!-- 좌측: 그리드 영역 -->
        <div class="dash-col-main">

          <!-- 최근 등록 매물 -->
          <div class="dash-section">
            <div class="dash-section-header">
              <span class="dash-section-title"><i class="fas fa-clipboard-list"></i> 최근 등록 매물</span>
              <a href="${ctx}/propertyMng/viewPropertyMng" class="dash-section-link">전체보기 →</a>
            </div>
            <div class="dash-section-body">
              <div id="sheetProp"></div>
            </div>
          </div>

          <!-- 최근 문의 -->
          <div class="dash-section">
            <div class="dash-section-header">
              <span class="dash-section-title"><i class="fas fa-comments"></i> 최근 문의</span>
              <a href="${ctx}/bbsComQnaMng/viewBbsComQnaMng" class="dash-section-link">전체보기 →</a>
            </div>
            <div class="dash-section-body">
              <div id="sheetQna"></div>
            </div>
          </div>

        </div>

        <!-- 우측: 사이드 영역 -->
        <div class="dash-col-side">

          <!-- 인기 매물 TOP 5 -->
          <div class="dash-section">
            <div class="dash-section-header">
              <span class="dash-section-title"><i class="fas fa-fire"></i> 인기 매물 TOP 5</span>
            </div>
            <div class="dash-section-body">
              <div class="top-prop-list" id="topPropList">
                <div style="padding:20px; text-align:center; color:#aaa;">로딩중...</div>
              </div>
            </div>
          </div>

          <!-- 빠른 바로가기 -->
          <div class="dash-section">
            <div class="dash-section-header">
              <span class="dash-section-title"><i class="fas fa-bolt"></i> 빠른 바로가기</span>
            </div>
            <div class="dash-section-body">
              <div class="quick-links">
                <a href="${ctx}/propertyMng/viewPropertyWrite" class="quick-link">
                  <i class="fas fa-plus-circle"></i> 매물 등록
                </a>
                <a href="${ctx}/bbsComNoticeMng/viewBbsComWriteNotice" class="quick-link">
                  <i class="fas fa-bullhorn"></i> 공지사항 작성
                </a>
                <a href="${ctx}/bbsComQnaMng/viewBbsComQnaMng" class="quick-link">
                  <i class="fas fa-envelope"></i> 문의 확인
                </a>
                <a href="${ctx}/popMng/viewPopMng" class="quick-link">
                  <i class="fas fa-window-restore"></i> 팝업 관리
                </a>
              </div>
            </div>
          </div>

        </div>
      </div>

    </div>
  </section>
</div>

<!-- 매물 상세 이동용 -->
<form id="goPropForm" action="${ctx}/propertyMng/viewPropertyEdit" method="post">
  <input type="hidden" name="propCd" id="propCdVal" />
</form>

<!-- 문의 상세 이동용 -->
<form id="goQnaForm" action="${ctx}/bbsComQnaMng/viewBbsComWriteQna" method="post">
  <input type="hidden" name="pstCd" id="qnaPstCd" />
  <input type="hidden" name="brdCd" value="3ccd942dfcbf11f08771908d6ec6e544" />
</form>

<script>
$(function() {
  initPropSheet();
  initQnaSheet();
  loadTopPropList();
});

/* ========== 최근 등록 매물 그리드 ========== */
function initPropSheet() {
  var columns = [
    {
      title:"상태",
      field:"sellYn",
      width:80,
      hozAlign:"center",
      headerHozAlign:"center",
      headerSort:false,
      formatter: function(cell) {
        return cell.getValue() === 'Y'
          ? "<span class='badge bg-secondary'>거래완료</span>"
          : "<span class='badge bg-success'>거래중</span>";
      }
    },
    {
      title:"매물명",
      field:"propNm",
      minWidth:180,
      headerSort:false,
      formatter: function(cell) {
        var d = cell.getRow().getData();
        var badge = '';
        if (d.badgeType === 'RECOMMEND') badge = "<span class='badge bg-warning text-dark me-1'>추천</span>";
        else if (d.badgeType === 'URGENT') badge = "<span class='badge bg-danger me-1'>급매</span>";
        return badge + "<span style='cursor:pointer; text-decoration:underline;'>" + (cell.getValue() || '') + "</span>";
      },
      cellClick: function(e, cell) {
        var d = cell.getRow().getData();
        $('#propCdVal').val(d.propCd);
        $('#goPropForm').submit();
      }
    },
    {
      title:"유형",
      field:"catNm",
      width:100,
      hozAlign:"center",
      headerHozAlign:"center",
      headerSort:false
    },
    {
      title:"거래",
      field:"dealTypeNm",
      width:80,
      hozAlign:"center",
      headerHozAlign:"center",
      headerSort:false
    },
    {
      title:"조회",
      field:"viewCnt",
      width:70,
      hozAlign:"center",
      headerHozAlign:"center",
      headerSort:false,
      formatter: function(cell) { return (cell.getValue() || 0) + '회'; }
    },
    {
      title:"등록일",
      field:"creDtm",
      width:140,
      hozAlign:"center",
      headerHozAlign:"center",
      headerSort:false
    }
  ];

  window.sheetProp = TG.create("sheetProp", columns, {
    height: "320px",
    pagination: false,
    layout: "fitColumns"
  });

  window.sheetProp.on("tableBuilt", function() {
    TG.load(window.sheetProp, "${ctx}/admin/getRecentPropList", {}, false, "DATA");
  });
}

/* ========== 최근 문의 그리드 ========== */
function initQnaSheet() {
  var columns = [
    {
      title:"상태",
      field:"replyYn",
      width:80,
      hozAlign:"center",
      headerHozAlign:"center",
      headerSort:false,
      formatter: function(cell) {
        return cell.getValue() === 'Y'
          ? "<span class='badge bg-success'>답변완료</span>"
          : "<span class='badge bg-warning text-dark'>대기</span>";
      }
    },
    {
      title:"제목",
      field:"pstNm",
      minWidth:180,
      headerSort:false,
      formatter: function(cell) {
        return "<span style='cursor:pointer; text-decoration:underline;'>" + (cell.getValue() || '') + "</span>";
      },
      cellClick: function(e, cell) {
        var d = cell.getRow().getData();
        $('#qnaPstCd').val(d.pstCd);
        $('#goQnaForm').submit();
      }
    },
    {
      title:"작성자",
      field:"rgtUsrNm",
      width:100,
      hozAlign:"center",
      headerHozAlign:"center",
      headerSort:false
    },
    {
      title:"연락처",
      field:"rgtPhone",
      width:130,
      hozAlign:"center",
      headerHozAlign:"center",
      headerSort:false,
      formatter: function(cell) { return cell.getValue() || '-'; }
    },
    {
      title:"등록일",
      field:"rgtDtm",
      width:140,
      hozAlign:"center",
      headerHozAlign:"center",
      headerSort:false
    }
  ];

  window.sheetQna = TG.create("sheetQna", columns, {
    height: "280px",
    pagination: false,
    layout: "fitColumns"
  });

  window.sheetQna.on("tableBuilt", function() {
    TG.load(window.sheetQna, "${ctx}/admin/getRecentQnaList", {}, false, "DATA");
  });
}

/* ========== 인기 매물 TOP 5 ========== */
function loadTopPropList() {
  $.post("${ctx}/admin/getTopPropList", function(res) {
    var list = res.data || [];
    var html = '';

    if (list.length === 0) {
      html = '<div style="padding:20px; text-align:center; color:#aaa;">데이터가 없습니다.</div>';
    } else {
      for (var i = 0; i < list.length; i++) {
        var p = list[i];
        var rankClass = i < 3 ? 'r' + (i + 1) : '';
        html += '<div class="top-prop-item" style="cursor:pointer;" onclick="fnGoPropEdit(\'' + p.propCd + '\')">';
        html += '  <div class="top-prop-rank ' + rankClass + '">' + (i + 1) + '</div>';
        html += '  <div class="top-prop-info">';
        html += '    <div class="top-prop-name">' + (p.propNm || '') + '</div>';
        html += '    <div class="top-prop-cat">' + (p.catNm || '') + '</div>';
        html += '  </div>';
        html += '  <div class="top-prop-views">' + (p.viewCnt || 0) + '회</div>';
        html += '</div>';
      }
    }

    $('#topPropList').html(html);
  });
}

function fnGoPropEdit(propCd) {
  $('#propCdVal').val(propCd);
  $('#goPropForm').submit();
}
</script>
