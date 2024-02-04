const insertApiUrl = '/visitor/insert';

const VISITOR = {
    save: function (memId, refererUrl) {
        const callUrl = location.href;
        const callSvc = location.pathname;
        const param = {
            accessPath: refererUrl,
            accPageUrl: callUrl,
            callService: callSvc,
            visitStoryMemId: memId,
        };

        REQUEST.send(insertApiUrl,"POST", param,null,null,{'Content-type': "application/json"});
    }
}
