<%--
  Created by IntelliJ IDEA.
  User: HAN
  Date: 2024-02-25
  Time: 오후 2:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<link rel="stylesheet" type="text/css" href="/resources/css/management-common.css"/>
<link rel="stylesheet" type="text/css" href="/resources/css/management-category.css"/>

<form id="managementCategoryForm">
    <div class="layout">
        <!-- 사이드바 -->
        <%@include file="include/menus.jsp" %>

        <!-- 메인 -->
        <main class="main">
            <!-- 등록/수정 -->
            <div class="category-form">
                <h3 id="form-title">카테고리 추가</h3>
                <input type="hidden" id="editing-row">


                <div class="form-group">
                    <label>카테고리 명</label>
                    <input type="text" id="cat-name" name="categoryNm" placeholder="카테고리 이름 입력">
                </div>
                <div class="form-group">
                    <label>주제</label>
                    <select id="cat-topic" name="defalutCategId"
                            class="categorySelect"
                            title="카테고리 주제">
                        <option value="" selected>선택</option>
                    </select>

                </div>
                <div class="form-group">
                    <label>공개 여부</label>
                    <select id="cat-visibility" name="showYn">
                        <option value="Y">공개</option>
                        <option value="N">비공개</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>카테고리 소개</label>
                    <textarea id="cat-desc" name="categoryComents" rows="3"
                              placeholder="카테고리 소개 입력"></textarea>
                </div>
                <div class="form-actions">
                    <button type="button" id="add-btn" onclick="addCategory()">등록</button>
                    <button type="button" id="update-btn" style="display:none;"
                            onclick="updateCategory()">수정
                    </button>
                    <button type="button" id="cancel-btn" style="display:none;"
                            onclick="cancelEdit()">취소
                    </button>
                </div>
            </div>

            <!-- 목록 -->
            <div class="categories">
                <h3>전체 카테고리 목록</h3>
                <table>
                    <thead>
                    <tr>
                        <th>카테고리 명</th>
                        <th>주제</th>
                        <th>공개 여부</th>
                        <th>소개</th>
                        <th>관리</th>
                    </tr>
                    </thead>
                    <tbody id="category-table">
                    <%--
                    <tr id="row-1">
                        <td>개발</td>
                        <td>웹/앱 개발</td>
                        <td>공개</td>
                        <td class="desc">개발 관련 글 모음</td>
                        <td class="actions">
                            <button onclick="editCategory(this)">수정</button>
                            <button onclick="deleteCategory(this)">삭제</button>
                        </td>
                    </tr>
                    <tr id="row-2">
                        <td>여행</td>
                        <td>국내/해외 여행기</td>
                        <td>비공개</td>
                        <td class="desc">여행 기록과 사진 및 다양한 여행 팁과 정보를 공유하는 공간입니다.</td>
                        <td class="actions">
                            <button type="button" onclick="editCategory(this)">수정</button>
                            <button type="button" onclick="deleteCategory(this)">삭제</button>
                        </td>
                    </tr>
                    --%>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</form>

<script>
  const categoryInsertUrl = "/management/category";
  const categListSpaceNm = "category_left";
  const categoryMemberListIdNm = "categoryMemberList";
  const categListNm = "category_1st";
  const categSelectNm = "categorySelect";
  const formId = '#managementCategoryForm';

  const CATEGORY_LIST = comm.category.get();
  const MEMBER_CATEGORY_LIST = comm.category.getMember();
  const CATEGORY_MAP = {};
  let thisObj;

  function toggleMenu() {
    document.getElementById('menu').classList.toggle('active');
  }

  function saveCategory(categoryParams, callback) {

    let param = {};
    param.paramJson = JSON.stringify([categoryParams]);

    comm.request({
      url: categoryInsertUrl,
      method: "POST",
      data: JSON.stringify(param)
    }, function (resp) {
      // 수정 성공
      if (resp.code == '0000') {
        if (callback) {
          callback(JSON.parse(resp['insertIds']))
        }
      }
    })
  }

  function addCategory() {
    const name = document.getElementById('cat-name').value.trim();
    const topic = document.getElementById('cat-topic').value.trim();
    const visibility = document.getElementById('cat-visibility').value;
    const desc = document.getElementById('cat-desc').value.trim();

    if (!name) {
      comm.message.alert("카테고리명을 입력하세요.")
      return;
    }

    const tagId = comm.generateUUID();
    const insertParams = {
      "TAG_ID": tagId,
      "DEFALUT_CATEG_ID": topic,
      "SHOW_YN": visibility,
      "CATEGORY_COMENTS": desc,
      "CATEGORY_NM": name,
      "DELETE_YN": "N",
    }

    saveCategory(insertParams, function (insertIds) {
      insertParams['ID'] = insertIds[insertParams.TAG_ID];
      MEMBER_CATEGORY_LIST.push(insertParams);
      setCategoryMemberList();
      clearForm();

    })

  }

  function editCategory(btn) {

    const categoryId = $(btn).parents("tr").data().ID
    const target = getCategory(categoryId);

    const row = btn.closest('tr');
    document.getElementById('form-title').innerText = "카테고리 수정";
    document.getElementById('cat-name').value = target.CATEGORY_NM;
    document.getElementById('cat-topic').value = target.DEFALUT_CATEG_ID;
    document.getElementById('cat-visibility').value = target.SHOW_YN;
    document.getElementById('cat-desc').value = target.CATEGORY_COMENTS;
    document.getElementById('editing-row').value = target.ID;

    // 버튼 상태 변경
    document.getElementById('add-btn').style.display = "none";
    document.getElementById('update-btn').style.display = "inline-block";
    document.getElementById('cancel-btn').style.display = "inline-block";
  }

  function updateCategory() {
    const rowId = document.getElementById('editing-row').value;
    const row = getCategory(rowId);

    row.CATEGORY_NM = document.getElementById('cat-name').value;
    row.DEFALUT_CATEG_ID = document.getElementById('cat-topic').value;
    row.SHOW_YN = document.getElementById('cat-visibility').value;
    row.CATEGORY_COMENTS = document.getElementById('cat-desc').value;

    saveCategory(row, function () {
      setCategoryMemberList();
      cancelEdit();
    })

  }

  function getCategory(categoryId) {
    const target = MEMBER_CATEGORY_LIST.find(item => String(item.ID) === String(categoryId));
    return target;
  }

  function deleteCategory(btn) {

    comm.message.confirm("정말 삭제하시겠습니까?", function (isOk) {

      if (isOk) {
        const categoryId = $(btn).parents("tr").data().ID
        const target = getCategory(categoryId);

        if (target) {
          target.DELETE_YN = "Y";
        }

        saveCategory(target, function (insertIds) {
          const index = MEMBER_CATEGORY_LIST.findIndex(item => item.ID === categoryId);
          if (index !== -1) {
            MEMBER_CATEGORY_LIST.splice(index, 1); // index 위치에서 1개의 요소 제거
          }

          setCategoryMemberList();
        });
      }

    })

  }

  function cancelEdit() {
    clearForm();
    document.getElementById('form-title').innerText = "카테고리 추가";
    document.getElementById('add-btn').style.display = "inline-block";
    document.getElementById('update-btn').style.display = "none";
    document.getElementById('cancel-btn').style.display = "none";
  }

  function clearForm() {
    document.getElementById('cat-name').value = "";
    document.getElementById('cat-topic').value = "";
    document.getElementById('cat-visibility').value = "Y";
    document.getElementById('cat-desc').value = "";
    document.getElementById('editing-row').value = "";
  }

  function setCategorySelectElement() {
    CATEGORY_LIST.forEach(function (obj) {
      const option = $("<option></option>");

      $(option).text(obj.CATEGORY_NM);
      $(option).attr("value", obj.ID);

      $(option).data(obj);
      $("." + categSelectNm).append(option);

      CATEGORY_MAP[obj.ID] = obj.CATEGORY_NM;
    })
  }

  function setCategoryMemberList() {
    $("#category-table").empty();
    MEMBER_CATEGORY_LIST.forEach(function (obj) {
      const tr = $("<tr id='row-" + obj.ID + "'></tr>");
      const categoryId = obj.ID;
      const categoryName = obj.CATEGORY_NM;
      const categoryShowYn = obj.SHOW_YN === 'Y' ? '공개' : '비공개';
      const categoryType = CATEGORY_MAP[obj.DEFALUT_CATEG_ID];
      const categoryDesc = obj.CATEGORY_COMENTS;

      $(tr).append(`
            <td>\${categoryName}</td>
            <td>\${categoryType}</td>
            <td>\${categoryShowYn}</td>
            <td class="desc">\${categoryDesc}</td>
            <td class="actions">
                <button type="button" onclick="editCategory(this)">수정</button>
                <button type="button" onclick="deleteCategory(this)">삭제</button>
            </td>
        `)

      $(tr).data(obj);
      $("#category-table").append(tr)

    })
  }

  function initCategory() {
    setCategorySelectElement();
    setCategoryMemberList();
  }

  initCategory();


</script>


