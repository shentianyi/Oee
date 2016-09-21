/**
 * Created by if on 16-9-19.
 */

var DTR = {};

DTR.oee = function (cls, title, xAxis, series) {
    var NeedScrollbar = false;
    var Max = 0;
    if (xAxis != null && xAxis != "") {
        Max = xAxis.length - 1;
        if (xAxis.length > 20) {
            NeedScrollbar = true;
            Max = 19;
        }
    }

    var charts = $(cls).highcharts({
        chart: {
            type: 'column',
            zoomType: 'xy',
            panning: true,
            panKey: 'ctrl',
            borderColor: '#bdc3c7',
            borderWidth: 1,
            backgroundColor: 'transparent',
            resetZoomButton: {
                position: {
                    x: 0,
                    y: -30
                },
                theme: {
                    fill: 'white',
                    stroke: 'silver',
                    r: 0,
                    states: {
                        hover: {
                            fill: '#ecf0f1',
                            style: {
                                color: '#34495e'
                            }
                        }
                    }
                }
            }
        },
        credits: {
            enabled: false
        },
        title: {
            text: title,
            x: -20
        },
        scrollbar: {
            enabled: NeedScrollbar
        },
        xAxis: {
            categories: xAxis,
            min: 0,
            max: Max
        },
        yAxis: {
            labels: {
                format: '{value}%'
            },
            title: {
                text: ''
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
                cursor: 'pointer',
                stacking: 'normal',
                dataLabels: {
                    enabled: true,
                    format: '{y}%',
                    rotation: -90,
                    style: {
                        color: 'white',
                        textShadow: 'none'
                    }
                }
            }
        },
        series: series
    });

    $('.show_spinner').remove();
};

DTR.downtime_code = function (cls, title, xAxis, series) {
    //清空
    $(cls).empty();

    var NeedScrollbar = false;
    var Max = 0;
    if (xAxis != null && xAxis != "") {
        Max = xAxis.length - 1;
        if (xAxis.length > 20) {
            NeedScrollbar = true;
            Max = 19;
        }
    }

    var charts = $(cls).highcharts({
        chart: {
            type: 'column',
            zoomType: 'xy',
            panning: true,
            panKey: 'ctrl',
            borderColor: '#bdc3c7',
            borderWidth: 1,
            backgroundColor: 'transparent',
            resetZoomButton: {
                position: {
                    x: 0,
                    y: -30
                },
                theme: {
                    fill: 'white',
                    stroke: 'silver',
                    r: 0,
                    states: {
                        hover: {
                            fill: '#ecf0f1',
                            style: {
                                color: '#34495e'
                            }
                        }
                    }
                }
            }
        },
        credits: {
            enabled: false
        },
        title: {
            text: title,
            x: -20
        },
        scrollbar: {
            enabled: NeedScrollbar
        },
        xAxis: {
            categories: xAxis,
            min: 0,
            max: Max
        },
        yAxis: {
            min: 0,
            title: {
                text: ''
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

    $('.show_spinner').remove();
};