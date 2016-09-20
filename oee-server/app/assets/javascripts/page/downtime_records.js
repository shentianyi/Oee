/**
 * Created by if on 16-9-19.
 */

var DTR = {};

DTR.oee = function (cls, title, xAxis, series) {
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
            },
            stackLabels: {
                enabled: true,
                formatter: function () {
                    return this.total + "%";
                },
                style: {
                    fontWeight: 'bold'
                }
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

DTR.downtime_code = function (cls, title, xAxis, series) {
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
                format: '{value}'
            },
            stackLabels: {
                enabled: true,
                formatter: function () {
                    return this.total;
                },
                style: {
                    fontWeight: 'bold'
                }
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
                    this.series.name + ': ' + this.y + '<br/>';
            }
        },
        plotOptions: {
            column: {
                stacking: 'normal',
                dataLabels: {
                    enabled: false,
                    format: '{y}',
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