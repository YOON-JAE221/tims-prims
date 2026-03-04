<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sdr.common.constant.Constant" %>
<!-- ======= 공통 CTA Section ======= -->
<section class="cta-bottom">
  <div class="container">
    <div class="cta-bottom-inner">

      <div class="cta-bottom-text">
        <h3 class="cta-bottom-title">도움이 필요하신가요?</h3>
        <p class="cta-bottom-desc">구조설계 · 구조검토 · 내진성능평가 · 안전진단까지,<br class="d-none d-md-inline"> 프로젝트 규모에 관계없이 부담 없이 상담받으실 수 있습니다.</p>
      </div>

      <div class="cta-bottom-actions">
        <a href="https://open.kakao.com/o/sCMG1DXh" target="_blank" rel="noopener noreferrer" class="cta-btn cta-btn-kakao">
          <i class="bi bi-chat-dots-fill"></i> 카카오톡 상담
        </a>
        <a href="javascript:goToBbs('<%= Constant.BRD_CD_QNA %>')" class="cta-btn cta-btn-qna">
          <i class="bi bi-pencil-square"></i> 문의 상담
        </a>
        <a href="https://blog.naver.com/thdeofyd" target="_blank" rel="noopener noreferrer" class="cta-btn cta-btn-blog">
          <i class="bi bi-journal-richtext"></i> Blog
        </a>
      </div>

    </div>
  </div>
</section>
<!-- End CTA Section -->
