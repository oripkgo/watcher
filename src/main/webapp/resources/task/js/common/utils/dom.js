const DOM = function () {

    return {

        /**
         * form 요소에 serializeArray를 json 파라미터 형태로 리턴해준다
         * */
        serializeJson: function (arr) {
            var obj = {};
            arr.forEach(function (data) {
                if (data.value) {
                    obj[data.name] = data.value;
                }

            })

            return obj;
        },

        appendForm: function (id, name) {
            let formObj = $('<form></form>');
            $(formObj).attr("id", id);
            $(formObj).attr("name", (name || (id || "")));
            return formObj;
        },

        appendInput: function (form, name, value, isHideId) {
            if ($("#" + name).length > 0) {
                $("#" + name).remove();
            }

            if (isHideId) {
                $(form).append('<input type="hidden" name="' + name + '">');
            } else {
                $(form).append('<input type="hidden" name="' + name + '" id="' + name + '">');
            }

            $(form).find("input[name='" + name + "']").val(value);
            return $(form).find("input[name='" + name + "']");
        },

    }

}()


