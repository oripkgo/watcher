<%--
  Created by IntelliJ IDEA.
  User: oripk
  Date: 2024-02-11
  Time: 오후 1:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="popular-posts">
    <h3>인기 게시글 TOP 10</h3>
    <ul class="articleList">
    </ul>
</div>

<script>
  const apiUrlManagementBoardPoularStorys = "/management/board/popularity/storys";

  comm.request({url: apiUrlManagementBoardPoularStorys, method: "GET"}, function (resp) {
    if (resp.code == '0000') {
      const $listContainer = $(".articleList");
      $listContainer.empty();

      // 리스트가 비어있을 경우 처리 (선택사항)
      if (!resp.list || resp.list.length === 0) {
        $listContainer.append('<li>데이터가 없습니다.</li>');
        return;
      }

      resp.list.forEach(function (obj) {
        const image = window.getImgTagStr(obj['THUMBNAIL_IMG_PATH'], "story-thumbnail");

        // 1. 링크 주소 생성
        const viewUrl = window.getStoryViewUrl(obj['MEMBER_ID'], obj['ID']);

        // 2. 조회수 금액 포맷팅 (방금 배우신 toLocaleString 활용!)
        const viewCnt = obj['VIEW_CNT'] ? Number(obj['VIEW_CNT']).toLocaleString() : '0';

        // 3. HTML 구조 생성
        let liHtml = '<li>';
        liHtml += '    <div class="info">';
        liHtml += '        <a href="' + viewUrl + '">' + obj['TITLE'] + '</a>';
        // 조회수와 등록일 표시 (컬럼명은 실제 데이터에 맞춰 확인 필요)
        liHtml += '        <span>조회수 ' + viewCnt + ' · ' + (obj['REG_DATE'] || '') + '</span>';
        liHtml += '    </div>';
        liHtml += '    <div class="thumb">';

        // 썸네일이 있을 때만 이미지를 출력하고, 없으면 빈 div 유지
        liHtml += image

        liHtml += '    </div>';
        liHtml += '</li>';

        $listContainer.append(liHtml);
      });
    }
  });
</script>