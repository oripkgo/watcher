
const TOKEN = function(){

    const tokenApiUrl = "/comm/token";

    const init = function (callback) {

        REQUEST.send(tokenApiUrl, "GET", {
            token: (localStorage.getItem("apiToken") || "")
        }, function (resp) {
            if (resp.code == '0000') {
                console.log('token : ' + resp['apiToken'])
                localStorage.setItem("apiToken", resp['apiToken']);

                if( callback ){
                    callback();
                }
            }
        }, null, null, false)
    }

    return {

        init : init

    }

}()
