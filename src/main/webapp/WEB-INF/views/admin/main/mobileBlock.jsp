<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>접근 불가 - 프리머스 부동산</title>
  <link rel="icon" sizes="any" href="${pageContext.request.contextPath}/resources/front/img/favicon/favicon.ico">
  <style>
    * { margin:0; padding:0; box-sizing:border-box; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
      background: linear-gradient(135deg, #f5f7fa 0%, #e4e8ed 100%);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 20px;
    }
    .block-container {
      background: #fff;
      border-radius: 20px;
      padding: 50px 40px;
      text-align: center;
      max-width: 380px;
      width: 100%;
      box-shadow: 0 10px 40px rgba(0,0,0,0.08);
    }
    .block-icon {
      font-size: 70px;
      margin-bottom: 24px;
      display: block;
    }
    .block-title {
      font-size: 22px;
      font-weight: 700;
      color: #1a2332;
      margin-bottom: 16px;
    }
    .block-message {
      font-size: 15px;
      color: #666;
      line-height: 1.7;
      margin-bottom: 32px;
    }
    .block-btn {
      display: inline-block;
      padding: 14px 32px;
      background: #E8830C;
      color: #fff;
      border-radius: 10px;
      text-decoration: none;
      font-weight: 600;
      font-size: 15px;
      transition: background 0.2s;
    }
    .block-btn:hover {
      background: #d17308;
      color: #fff;
      text-decoration: none;
    }
    .block-footer {
      margin-top: 24px;
      font-size: 12px;
      color: #999;
    }
  </style>
</head>
<body>
  <div class="block-container">
    <span class="block-icon">🖥️</span>
    <h1 class="block-title">PC에서 접속해주세요</h1>
    <p class="block-message">
      관리자 페이지는 PC 환경에서만<br>
      이용하실 수 있습니다.<br><br>
      원활한 관리를 위해<br>
      데스크탑 또는 노트북에서 접속해주세요.
    </p>
    <a href="/" class="block-btn">메인으로 이동</a>
    <p class="block-footer">프리머스 부동산</p>
  </div>
</body>
</html>
