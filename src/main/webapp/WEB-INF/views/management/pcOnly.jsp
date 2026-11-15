<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>PC 전용 페이지 안내</title>
  <!-- 폰트 및 아이콘 사용을 위한 CDN (선택사항) -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">

  <style>
    body {
      font-family: 'Noto Sans KR', sans-serif;
      background-color: #f9fafb;
      margin: 0;
      padding: 0;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      color: #333;
    }

    .pc-only-container {
      text-align: center;
      background: #fff;
      padding: 40px 30px;
      border-radius: 16px;
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
      max-width: 400px;
      width: 90%;
      box-sizing: border-box;
    }

    .icon-box {
      font-size: 50px;
      color: #286BB7;
      margin-bottom: 20px;
    }

    h2 {
      font-size: 20px;
      margin-bottom: 12px;
      color: #111;
    }

    p {
      font-size: 14px;
      color: #666;
      line-height: 1.6;
      margin-bottom: 25px;
    }

    .home-btn {
      display: inline-block;
      background-color: #286BB7;
      color: #fff;
      text-decoration: none;
      padding: 12px 24px;
      border-radius: 8px;
      font-size: 14px;
      font-weight: 500;
      transition: background-color 0.2s;
    }

    .home-btn:hover {
      background-color: #1f5393;
    }
  </style>
</head>
<body>

<div class="pc-only-container">
  <div class="icon-box">
    <i class="fa-solid.fa-desktop"></i> <!-- PC 아이콘 -->
  </div>
  <h2>PC 환경 전용 페이지입니다</h2>
  <p>
    원활한 관리자 기능 제공을 위해<br>
    본 페이지는 <strong>PC(데스크탑/태블릿)</strong> 환경에서만 지원됩니다.<br>
    PC 브라우저를 통해 접속해 주세요.
  </p>
  <a href="javascript:history.back();" class="home-btn">이전 페이지로 돌아가기</a>
</div>

</body>
</html>