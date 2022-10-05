<%--
  Created by IntelliJ IDEA.
  User: HAN
  Date: 2022-10-01
  Time: 오후 4:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>


<canvas class="graph_canvas" style="width: 100%; height: 100%;"></canvas>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>

    const drawChart = function(obj, datas, customTitle, customLabels){
        let toDay = new Date();
        const y = toDay.getFullYear();
        const m = toDay.getMonth() == 12 ? 1 : toDay.getMonth() + 1;
        let title = m + "월 방문자수";
        let labels = [];

        if (customTitle) {
            title = customTitle;
        }

        if (customLabels) {
            labels = customLabels;
        } else {

            const last_day = new Date(y, m, 0).getDate();

            for (let i = 1; i <= last_day; i++) {
                labels.push(i);
            }

        }


        const chartData = {
            labels: labels,
            datasets: [{
                label: title,
                backgroundColor: '#333',
                borderColor: '#333',
                data: datas,
            }]
        };

        const config = {
            type: 'line',
            data: chartData,
            options: {}
        };

        const myChart = new Chart(
            (obj),
            config
        );

    }

    drawChart(document.getElementsByClassName('graph_canvas')[0]);

</script>
