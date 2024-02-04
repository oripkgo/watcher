
const serverhost = window.apiHost;
const serverSuccessCheckValue = {key :"code", val : "0000"}
const REQUEST = {
    send : function(url, method, data, succCallback, errCallback, headers, async){
        const xhr = new XMLHttpRequest();

        if( typeof data == 'string' ){
            data = JSON.parse(data);
        }

        method = ( method || 'GET').toUpperCase();
        // async = !(async == true || async == false)? true : async;

        if( (method == 'GET' || method == 'DELETE') && data){
            url = url + "?" + this.getParam(data);
        }

        if( url.indexOf("http") !== 0){
            url = serverhost + url;
        }

        xhr.open(method || "GET", url, async);

        xhr.setRequestHeader("Authorization", 'Bearer '+ localStorage.getItem("apiToken"));

        if( headers ){
            for (let key in headers) {
                xhr.setRequestHeader(key, headers[key]);
            }
        }

        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4) {
                const response = JSON.parse(xhr.responseText); // 성공적인 응답 처리
                if (xhr.status === 200 && response[serverSuccessCheckValue.key] === serverSuccessCheckValue.val) {
                    if( succCallback ){
                        succCallback(response);
                    }
                } else {
                    if( errCallback ){
                        errCallback(response);
                    }else{
                        //에러발생
                        console.error(response.status, response.message); //응답상태와 응답 메시지 출력
                        MESSAGE.alert(response.message);
                    }
                }
            }
        };

        xhr.onerror = function () {
            console.error("Network error occurred.");
            // 네트워크 오류 처리를 수행할 수 있습니다.
        };

        if( method == 'GET' || method == 'DELETE'){
            xhr.send();
        }else{
            if( (headers['Content-type'] && headers['Content-type'].indexOf('application/json') > -1) && (typeof data !== 'string') ){
                data = JSON.stringify(data);
            }

            xhr.send(data);
        }
    },

    getParam : function(json){
        let params = new URLSearchParams();
        for (let key in json) {
            params.append(key, json[key]);
        }

        return params.toString();
    }
}
