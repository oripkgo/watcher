
const TOKEN = function(){

    const tokenApiUrl = "/comm/refresh-token";

    const init = function (callback) {

        REQUEST.send(tokenApiUrl, "POST", {
            token: (localStorage.getItem("apiToken") || "")
        }, function (resp) {
            if (resp.code == '0000') {
                console.log('token : ' + resp['apiToken'])
                localStorage.setItem("apiToken", resp['apiToken']);

                if( callback ){
                    callback();
                }
            }
        }, null, {'Content-type': "application/json"}, false)
    }

    return {

        init : init

    }

}()
