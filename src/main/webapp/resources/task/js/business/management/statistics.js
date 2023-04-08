const visitorCntSearchUrl = "/visitor/search/cnt"
const statisticsObj = {
    getTodayDateAndWeekday : function(){
        const d = new Date();
        return comm.date.getDate(d, '.') + ' ' + comm.date.getDayOfTheWeek(d);
    },

    getLocaleString : function(numStr){
        return (numStr*1).toLocaleString();
    },

    setVisitorFromSearch : function(callback){
        comm.request({url: visitorCntSearchUrl, method: "GET"}, function (resp) {
            if (resp.code == '0000' && callback) {
                callback(resp['visitInfo']);
            }
        })
    },
}