const settingUpdateUrl = "/management/setting/update";
const settingObj = {
    saveSettingInfo: function (formId) {
        comm.request({
            url: settingUpdateUrl,
            method: "PUT",
            form: $(formId),
            headers: {"Content-type": "application/x-www-form-urlencoded"},
        }, function (resp) {
            // 성공
            if (resp.code == '0000') {
                comm.message.alert("스토리 설정정보가 저장되었습니다.");
            }
        })
    },
};