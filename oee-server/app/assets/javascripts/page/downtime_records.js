/**
 * Created by if on 16-9-19.
 */

var DTR = {};

DTR.oee = function (cls, title, xAxis, plotColor, series) {
    $(cls).highcharts({
        chart: {
            type: 'column'
        },
        credits: {
            enabled: false
        },
        title: {
            text: title,
            x: -20
        },
        xAxis: {
            categories: xAxis
        },
        yAxis: {
            min: 0,
            labels: {
                format: '{value}%'
            }
        },
        legend: {
            align: 'center',
            verticalAlign: 'bottom',
            shadow: false
        },
        tooltip: {
            formatter: function () {
                return '<b>' + this.x + '</b><br/>' +
                    this.series.name + ': ' + this.y + '%<br/>';
            }
        },
        plotOptions: {
            column: {
                color: plotColor,
                stacking: 'normal',
                dataLabels: {
                    enabled: true,
                    format: '{y}%',
                    rotation: -90,
                    style: {
                        textShadow: 'none'
                    }
                }
            }
        },
        series: series
    });
};