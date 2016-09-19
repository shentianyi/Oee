/**
 * Created by if on 16-9-19.
 */

var DTR = {};

DTR.downtime_record = function (cls, title, xAxis, series) {
    console.log('Start....')

    console.log(series);

    console.log('End....')

    $(cls).highcharts({
        chart: {
            type: 'column'
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
            // stackLabels: {
            //     enabled: true
            // }
        },
        legend: {
            align: 'right',
            x: -30,
            verticalAlign: 'top',
            y: 25,
            floating: true,
            borderColor: '#CCC',
            shadow: false
        },
        tooltip: {
            formatter: function () {
                return '<b>' + this.x + '</b><br/>' +
                    this.series.name + ': ' + this.y + '<br/>' +
                    'Total: ' + this.point.stackTotal;
            }
        },
        plotOptions: {
            column: {
                stacking: 'normal',
                dataLabels: {
                    enabled: true,
                    style: {
                        textShadow: '0 0 3px black'
                    }
                }
            }
        },
        series: series
    });
};