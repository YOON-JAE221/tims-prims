<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/common/head.jsp" %>

<style>
  .content-wrapper { padding-top: 20px !important; }
</style>

<div class="content-wrapper">
  <section class="content" style="padding-top:32px;">
    <div class="container-fluid">

      <!-- 상단 요약 카드 -->
      <div class="dash-cards" style="grid-template-columns: repeat(4, 1fr);">
        <div class="dash-card primary clickable" onclick="fnGoPropMng('')">
          <div class="dash-card-icon">🏠</div>
          <div class="dash-card-label">전체 매물</div>
          <div class="dash-card-value">${not empty propSummary.totalCnt ? propSummary.totalCnt : 0}<small> 건</small></div>
        </div>
        <div class="dash-card success clickable" onclick="fnGoPropMng('N')">
          <div class="dash-card-icon">🤝</div>
          <div class="dash-card-label">거래중</div>
          <div class="dash-card-value">${not empty propSummary.activeCnt ? propSummary.activeCnt : 0}<small> 건</small></div>
        </div>
        <div class="dash-card info clickable" onclick="fnGoPropMng('Y')">
          <div class="dash-card-icon">✅</div>
          <div class="dash-card-label">거래완료</div>
          <div class="dash-card-value">${not empty propSummary.soldCnt ? propSummary.soldCnt : 0}<small> 건</small></div>
        </div>
        <div class="dash-card danger clickable" onclick="location.href='${ctx}/bbsComQnaMng/viewBbsComQnaMng'">
          <div class="dash-card-icon">⚠️</div>
          <div class="dash-card-label">미답변 문의</div>
          <div class="dash-card-value">${not empty qna.unansweredCnt ? qna.unansweredCnt : 0}<small> 건</small></div>
        </div>
      </div>

      <!-- 메인 컨텐츠 -->
      <div class="dash-row">
        <!-- 좌측: 최근 등록 매물 -->
        <div class="dash-section">
          <div class="dash-section-header">
            <span class="dash-section-title">📋 최근 등록 매물</span>
            <div style="display:flex; align-items:center; gap:10px;">
              <input type="text" id="srchPropNo" class="form-control form-control-sm" placeholder="매물번호 입력 후 Enter" style="width:160px; font-size:12px;" onkeypress="if(event.keyCode===13) loadRecentPropList();" />
              <a href="${ctx}/propertyMng/viewPropertyMng" class="dash-section-link">전체보기 →</a>
            </div>
          </div>
          <div class="recent-prop-wrap" style="overflow-x:auto; padding:16px;">
            <table class="recent-prop-table" style="border:1px solid #e0e0e0; border-radius:8px; overflow:hidden;">
              <thead>
                <tr>
                  <th style="text-align:left; width:18%;">매물명</th>
                  <th style="text-align:left; width:14%;">주소</th>
                  <th style="width:8%;">대분류</th>
                  <th style="width:8%;">중분류</th>
                  <th style="width:8%;">소분류</th>
                  <th style="width:6%;">거래</th>
                  <th style="width:7%;">등록자</th>
                  <th style="text-align:left; width:14%;">관리자메모</th>
                  <th style="width:9%;">매물번호</th>
                  <th style="width:5%;">조회</th>
                </tr>
              </thead>
              <tbody id="recentPropBody">
                <tr><td colspan="10" style="text-align:center; padding:40px; color:#aaa;">로딩중...</td></tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- 우측 -->
        <div class="dash-col-right">
          <!-- 빠른 바로가기 (세로 3개) -->
          <div class="dash-section">
            <div class="dash-section-header">
              <span class="dash-section-title">⚡ 빠른 바로가기</span>
            </div>
            <div class="quick-links">
              <a href="${ctx}/propertyMng/viewPropertyWrite" class="quick-link">➕ 매물 등록</a>
              <a href="${ctx}/bbsComQnaMng/viewBbsComQnaMng" class="quick-link">📩 문의 게시판</a>
              <a href="javascript:fnGoNotice()" class="quick-link">📢 공지사항</a>
            </div>
          </div>

          <!-- 인기 매물 TOP 5 -->
          <div class="dash-section">
            <div class="dash-section-header">
              <span class="dash-section-title">🔥 인기 매물 TOP 5</span>
            </div>
            <div class="top-prop-list" id="topPropList">
              <div style="padding:20px; text-align:center; color:#aaa;">로딩중...</div>
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
</form>

<form id="goNoticeForm" action="${ctx}/bbsComMng/viewBbsComMng" method="post">
  <input type="hidden" name="brdCd" value="38f5e73ffcbf11f08771908d6ec6e544" />
</form>

<script>
$(function() {
  loadRecentPropList();
  loadTopPropList();
});

function loadRecentPropList() {
  var propNo = $('#srchPropNo').val() || '';
  $.post("${ctx}/admin/getRecentPropList", { propNo: propNo }, function(res) {
    var list = res.data || [];
    var html = '';
    if (list.length === 0) {
      html = '<tr><td colspan="10" style="text-align:center; padding:40px; color:#aaa;">데이터가 없습니다.</td></tr>';
    } else {
      for (var i = 0; i < list.length; i++) {
        var p = list[i];
        var memo = p.adminMemo || '-';
        if (memo.length > 15) memo = memo.substring(0, 15) + '...';
        html += '<tr onclick="fnGoPropEdit(\'' + p.propCd + '\')">';
        html += '<td style="text-align:left;"><span class="prop-name">' + (p.propNm || '-') + '</span></td>';
        html += '<td style="text-align:left;">' + (p.address || '-') + '</td>';
        html += '<td style="text-align:center;">' + p.catNm + '</td>';
        html += '<td style="text-align:center;">' + (p.midCatNm || '-') + '</td>';
        html += '<td style="text-align:center;">' + (p.subCatNm || '-') + '</td>';
        html += '<td style="text-align:center;">' + (p.dealTypeNm || '-') + '</td>';
        html += '<td style="text-align:center;">' + (p.creUsrNm || '-') + '</td>';
        html += '<td style="text-align:left; color:#666;">' + memo + '</td>';
        html += '<td style="text-align:center;"><span style="font-family:monospace;font-weight:600;color:#1a2332;">' + (p.propNo || '-') + '</span></td>';
        html += '<td style="text-align:center;">' + (p.viewCnt || 0) + '</td>';
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
        html += '<div class="top-prop-item" onclick="fnGoPropEdit(\'' + p.propCd + '\')">';
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

function fnGoPropMng(soldYn) {
  $('#soldYnVal').val(soldYn);
  $('#goPropMngForm').submit();
}

function fnGoNotice() {
  $('#goNoticeForm').submit();
}
</script>
