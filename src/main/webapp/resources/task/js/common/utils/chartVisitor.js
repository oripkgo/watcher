
const dailyVisitorUrl = "/visitor/chart/count/daily?searchDate=";
const monthVisitorUrl = "/visitor/chart/count/month?searchDate=";

const drawChart = function (chartTarget, datas, customDate, customTitle) {
    let toDay = new Date();

    if (customDate) {
        toDay = customDate;
    }

    const m = toDay.getMonth() == 12 ? 1 : toDay.getMonth() + 1;

    let title = m + "월 방문자수";
    let labels = [];
    let maxData = 0;
    let visitorDatas = [];

    if (customTitle) {
        title = customTitle;
    }

    labels = Object.keys(datas);

    for (let key in datas) {

        if (datas[key] && datas[key] > maxData) {
            maxData = datas[key];
        }

        visitorDatas.push(datas[key]);
    }

    const chartData = {
        labels: labels,
        datasets: [{
            label: title,
            backgroundColor: '#333',
            borderColor: '#333',
            data: visitorDatas,
        }]
    };

    const config = {
        type: 'line',
        data: chartData,
        options: {
            scales: {
                y: {
                    beginAtZero: true,
                    // min: 0,
                    // max: 25
                },
            }
        }
    };

    // if( maxData <= 0 ){
    config.options.scales.y.min = 0;
    config.options.scales.y.max = maxData + 5;
    // }

    if (window.myChart) {
        window.myChart.data = config.data;
        window.myChart.options = config.options;
        window.myChart.update();
    } else {
        window.myChart = new window['Chart'](
            document.getElementsByClassName(chartTarget)[0],
            config
        );
    }
}

const getChartData = function (visitList, customDate) {
    let result = {};
    let toDay = new Date();
    if (customDate) {
        toDay = customDate;
    }

    const y = toDay.getFullYear();
    const m = toDay.getMonth() == 12 ? 1 : toDay.getMonth() + 1;
    const d = toDay.getDate();

    const last_day = new Date(y, m, 0).getDate();

    for (let i = 1; i <= last_day; i++) {
        if (i > d) {
            result[i] = null;
        } else {
            result[i] = 0;
        }
    }

    visitList.forEach(function (obj) {
        if (obj['VISIT_DATE']) {
            result[(obj['VISIT_DATE'].substring(6) * 1)] = obj['CNT'];
        }
    })

    return result;
}

const getMonthChartData = function (visitList, customDate) {
    let result = {};

    let toDay = new Date();

    if (customDate) {
        toDay = customDate;
    }

    // const y = toDay.getFullYear();
    const m = toDay.getMonth() == 12 ? 1 : toDay.getMonth() + 1;
    // const d = toDay.getDate();


    for (let i = 1; i <= 12; i++) {
        if (i > m) {
            result[i + '월'] = null;
        } else {
            result[i + '월'] = 0;
        }

    }

    visitList.forEach(function (obj) {
        if (obj['VISIT_MONTH']) {
            result[(obj['VISIT_MONTH'].substring(4) * 1) + '월'] = obj['CNT'];
        }
    })

    return result;
}

const chartVisitor = {
    init: function (target, dateObj, title) {
        this.drawTarget = target;
        this.dateObj = dateObj;
        this.title = title;

        const year = this.dateObj.getFullYear(); // 년도를 가져옵니다.
        const month = (this.dateObj.getMonth() + 1).toString().padStart(2, '0'); // 월을 가져오고 0부터 시작하는 인덱스를 1을 더하며 2자리로 포맷팅합니다.
        const day = this.dateObj.getDate().toString().padStart(2, '0'); // 일을 가져오고 2자리로 포맷팅합니다.

        this.dataStr = year + month + day; // 원하는 형식으로 날짜를 조합합니다.
    },

    drawDailyVisitor: function () {
        let chartThis = this;
        REQUEST.send(dailyVisitorUrl + chartThis.dataStr,"GET",null, function(resp){
            if (resp.code == '0000') {
                drawChart(chartThis.drawTarget, getChartData(resp['visitInfoList'], chartThis.dateObj), chartThis.dateObj)
            }
        })
    },

    drawMonthVisitor: function () {
        let chartThis = this;
        REQUEST.send(monthVisitorUrl + chartThis.dataStr,"GET",null, function(resp){
            if (resp.code == '0000') {
                drawChart(chartThis.drawTarget, getMonthChartData(resp['visitInfoList'], chartThis.dateObj), chartThis.dateObj)
            }
        })
    },
}
