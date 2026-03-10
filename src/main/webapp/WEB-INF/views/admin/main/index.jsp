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
  .dash-row { display: grid; grid-template-columns: 1fr 280px; gap: 20px; align-items: stretch; }
  .dash-col-main { display: flex; flex-direction: column; min-height: 0; }
  .dash-col-side { display: flex; flex-direction: column; gap: 12px; }

  /* ===== 카드 공통 ===== */
  .dash-section {
    background: #fff; border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.06);
    border: 1px solid #f0f0f0;
  }
  .dash-section.flex-grow { flex: 1; display: flex; flex-direction: column; min-height: 0; }
  .dash-section-header {
    display: flex; align-items: center; justify-content: space-between;
    padding: 12px 16px; border-bottom: 1px solid #f0f0f0; flex-shrink: 0;
  }
  .dash-section-title { font-size: 14px; font-weight: 700; color: #1a2332; display: flex; align-items: center; gap: 8px; }
  .dash-section-title i { color: #E8830C; }
  .dash-section-link { font-size: 12px; color: #888; transition: color 0.15s; }
  .dash-section-link:hover { color: #E8830C; }
  .dash-section-body { padding: 0; }
  .dash-section-body.flex-grow { flex: 1; overflow: hidden; display: flex; flex-direction: column; }

  /* ===== 최근 매물 테이블 ===== */
  .recent-prop-wrap { flex: 1; overflow-y: auto; min-height: 300px; max-height: calc(100vh - 320px); }
  .recent-prop-table { width: 100%; border-collapse: collapse; }
  .recent-prop-table th {
    padding: 10px 6px; text-align: center; font-size: 12px; font-weight: 600;
    color: #888; background: #fafafa; border-bottom: 1px solid #f0f0f0;
    position: sticky; top: 0; z-index: 1;
  }
  .recent-prop-table td {
    padding: 10px 6px; font-size: 13px; color: #333;
    border-bottom: 1px solid #f5f5f5; vertical-align: middle;
  }
  .recent-prop-table tbody tr { cursor: pointer; transition: background 0.15s; }
  .recent-prop-table tbody tr:hover { background: #fafafa; }
  .recent-prop-table tbody tr:last-child td { border-bottom: none; }

  .prop-name { font-weight: 500; color: #1a2332; font-size: 13px; }
  .prop-name:hover { color: #E8830C; }
  .badge-status { display: inline-block; padding: 4px 8px; border-radius: 4px; font-size: 11px; font-weight: 600; white-space: nowrap; }
  .badge-status.active { background: #e8f5e9; color: #43a047; }
  .badge-status.sold { background: #f5f5f5; color: #888; }
  .badge-prop { padding: 2px 5px; border-radius: 3px; font-size: 10px; font-weight: 600; margin-right: 4px; }
  .badge-prop.recommend { background: #fff3e0; color: #fb8c00; }
  .badge-prop.urgent { background: #ffebee; color: #e53935; }

  /* ===== 빠른 바로가기 ===== */
  .quick-links { padding: 8px 12px; display: flex; flex-direction: column; gap: 6px; }
  .quick-link {
    display: flex; align-items: center; gap: 8px;
    padding: 10px 12px; border-radius: 8px;
    background: #f8f9fa; border: 1px solid #eee;
    color: #1a2332; font-size: 12px; font-weight: 600;
    transition: all 0.2s; text-decoration: none;
  }
  .quick-link:hover { background: #E8830C; color: #fff; border-color: #E8830C; }
  .quick-link i { font-size: 13px; width: 16px; text-align: center; }

  /* ===== 인기매물 리스트 ===== */
  .top-prop-list { padding: 8px 12px; flex: 1; overflow-y: auto; }
  .top-prop-item {
    display: flex; align-items: center; gap: 8px;
    padding: 8px 0; border-bottom: 1px solid #f5f5f5;
  }
  .top-prop-item:last-child { border-bottom: none; }
  .top-prop-rank {
    width: 22px; height: 22px; border-radius: 5px;
    background: #f5f5f5; color: #888;
    display: flex; align-items: center; justify-content: center;
    font-size: 11px; font-weight: 700; flex-shrink: 0;
  }
  .top-prop-rank.r1 { background: #E8830C; color: #fff; }
  .top-prop-rank.r2 { background: #1a2332; color: #fff; }
  .top-prop-rank.r3 { background: #546e7a; color: #fff; }
  .top-prop-info { flex: 1; min-width: 0; }
  .top-prop-name { font-size: 12px; font-weight: 600; color: #1a2332; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
  .top-prop-cat { font-size: 10px; color: #888; margin-top: 1px; }
  .top-prop-views { font-size: 11px; color: #E8830C; font-weight: 600; flex-shrink: 0; }

  @media (max-width: 1400px) { .dash-cards { grid-template-columns: repeat(3, 1fr); } }
  @media (max-width: 1200px) { .dash-row { grid-template-columns: 1fr; } }
  @media (max-width: 768px) {
    .dash-cards { grid-template-columns: repeat(2, 1fr); }
    /* 모바일: 최근 등록 매물 가로 스크롤 */
    .recent-prop-wrap { overflow-x: auto; }
    .recent-prop-table { min-width: 600px; }
  }
</style>

<div class="content-wrapper">
  <section class="content" style="padding-top:32px;">
    <div class="container">

      <div class="dash-cards">
        <div class="dash-card primary clickable" onclick="fnGoPropMng('', '')">
          <div class="dash-card-icon"><i class="fas fa-home"></i></div>
          <div class="dash-card-label">전체 매물</div>
          <div class="dash-card-value">${not empty propSummary.totalCnt ? propSummary.totalCnt : 0}<small> 건</small></div>
        </div>
        <div class="dash-card success clickable" onclick="fnGoPropMng('N', '')">
          <div class="dash-card-icon"><i class="fas fa-handshake"></i></div>
          <div class="dash-card-label">거래중</div>
          <div class="dash-card-value">${not empty propSummary.activeCnt ? propSummary.activeCnt : 0}<small> 건</small></div>
        </div>
        <div class="dash-card info clickable" onclick="fnGoPropMng('Y', '')">
          <div class="dash-card-icon"><i class="fas fa-check-circle"></i></div>
          <div class="dash-card-label">거래완료</div>
          <div class="dash-card-value">${not empty propSummary.soldCnt ? propSummary.soldCnt : 0}<small> 건</small></div>
        </div>
        <div class="dash-card warning clickable" onclick="fnGoPropMng('', 'RECOMMEND')">
          <div class="dash-card-icon"><i class="fas fa-star"></i></div>
          <div class="dash-card-label">추천 매물</div>
          <div class="dash-card-value">${not empty propSummary.recommendCnt ? propSummary.recommendCnt : 0}<small> 건</small></div>
        </div>
        <div class="dash-card dark clickable" onclick="fnGoPropMng('', 'URGENT')">
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

      <div class="dash-row">
        <div class="dash-col-main">
          <div class="dash-section flex-grow">
            <div class="dash-section-header">
              <span class="dash-section-title"><i class="fas fa-clipboard-list"></i> 최근 등록 매물</span>
              <a href="${ctx}/propertyMng/viewPropertyMng" class="dash-section-link">전체보기 →</a>
            </div>
            <div class="dash-section-body flex-grow">
              <div class="recent-prop-wrap">
                <table class="recent-prop-table">
                  <thead>
                    <tr>
                      <th style="width:70px;">상태</th>
                      <th style="text-align:left;">매물명</th>
                      <th style="width:65px;">대분류</th>
                      <th style="width:65px;">소분류</th>
                      <th style="width:50px;">거래</th>
                      <th style="width:40px;">조회</th>
                      <th style="width:85px;">등록일</th>
                    </tr>
                  </thead>
                  <tbody id="recentPropBody">
                    <tr><td colspan="7" style="text-align:center; padding:40px; color:#aaa;">로딩중...</td></tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>

        <div class="dash-col-side">
          <!-- 빠른 바로가기 (위로 이동) -->
          <div class="dash-section">
            <div class="dash-section-header">
              <span class="dash-section-title"><i class="fas fa-bolt"></i> 빠른 바로가기</span>
            </div>
            <div class="dash-section-body">
              <div class="quick-links">
                <a href="${ctx}/propertyMng/viewPropertyWrite" class="quick-link"><i class="fas fa-plus-circle"></i> 매물 등록</a>
                <a href="${ctx}/bbsComNoticeMng/viewBbsComWriteNotice" class="quick-link"><i class="fas fa-bullhorn"></i> 공지사항 작성</a>
                <a href="${ctx}/bbsComQnaMng/viewBbsComQnaMng" class="quick-link"><i class="fas fa-envelope"></i> 문의 확인</a>
              </div>
            </div>
          </div>

          <!-- 인기 매물 TOP 5 (아래로 이동, flex-grow로 남은 공간 채움) -->
          <div class="dash-section flex-grow">
            <div class="dash-section-header">
              <span class="dash-section-title"><i class="fas fa-fire"></i> 인기 매물 TOP 5</span>
            </div>
            <div class="dash-section-body flex-grow">
              <div class="top-prop-list" id="topPropList">
                <div style="padding:20px; text-align:center; color:#aaa;">로딩중...</div>
              </div>
            </div>
          </div>
        </div>
      </div>

    </div>
  </section>
</div>

<form id="goPropForm" action="${ctx}/propertyMng/viewPropertyWrite" method="post">
  <input type="hidden" name="propCd" id="propCdVal" />
</form>

<form id="goPropMngForm" action="${ctx}/propertyMng/viewPropertyMng" method="post">
  <input type="hidden" name="soldYn" id="soldYnVal" />
  <input type="hidden" name="badgeType" id="badgeTypeVal" />
</form>

<script>
$(function() {
  loadRecentPropList();
  loadTopPropList();
});

function loadRecentPropList() {
  $.post("${ctx}/admin/getRecentPropList", function(res) {
    var list = res.data || [];
    var html = '';
    if (list.length === 0) {
      html = '<tr><td colspan="7" style="text-align:center; padding:40px; color:#aaa;">데이터가 없습니다.</td></tr>';
    } else {
      for (var i = 0; i < list.length; i++) {
        var p = list[i];
        var statusClass = p.soldYn === 'Y' ? 'sold' : 'active';
        var statusText = p.soldYn === 'Y' ? '거래완료' : '거래중';
        var badge = '';
        if (p.badgeType === 'RECOMMEND') badge = '<span class="badge-prop recommend">추천</span>';
        else if (p.badgeType === 'URGENT') badge = '<span class="badge-prop urgent">급매</span>';
        html += '<tr onclick="fnGoPropEdit(\'' + p.propCd + '\')">';
        html += '<td style="text-align:center;"><span class="badge-status ' + statusClass + '">' + statusText + '</span></td>';
        html += '<td style="text-align:left;">' + badge + '<span class="prop-name">' + (p.propNm || '') + '</span></td>';
        html += '<td style="text-align:center;">' + (p.catNm || '-') + '</td>';
        html += '<td style="text-align:center;">' + (p.subCatNm || '-') + '</td>';
        html += '<td style="text-align:center;">' + (p.dealTypeNm || '-') + '</td>';
        html += '<td style="text-align:center;">' + (p.viewCnt || 0) + '</td>';
        html += '<td style="text-align:center;">' + (p.rgtDtm || '-') + '</td>';
        html += '</tr>';
      }
    }
    $('#recentPropBody').html(html);
  });
}

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
        html += '<div class="top-prop-rank ' + rankClass + '">' + (i + 1) + '</div>';
        html += '<div class="top-prop-info"><div class="top-prop-name">' + (p.propNm || '') + '</div>';
        html += '<div class="top-prop-cat">' + (p.catNm || '') + '</div></div>';
        html += '<div class="top-prop-views">' + (p.viewCnt || 0) + '회</div></div>';
      }
    }
    $('#topPropList').html(html);
  });
}

function fnGoPropEdit(propCd) {
  $('#propCdVal').val(propCd);
  $('#goPropForm').submit();
}

function fnGoPropMng(soldYn, badgeType) {
  $('#soldYnVal').val(soldYn);
  $('#badgeTypeVal').val(badgeType);
  $('#goPropMngForm').submit();
}
</script>
