/**
 * Created by marco on 16-9-19.
 */

var DTR = {};

DTR.show_charts = function (downTimeRecords) {
    $('.bu-charts > div').empty();
    $('.right-detail > div').empty();
    $('.performance_tbody').empty();
    $('.limit_tbody').empty();

    charts_loading('.display-body');

    $.ajax({
        url: '/downtime_records/display',
        type: 'post',
        data: {
            downtime_records: downTimeRecords
        },
        success: function (data) {
            //如果 返回值正确，继续执行
            if (data.result) {
                //只有在机器维度的时候 执行 Bu OEE图表展示
                //有可能为空
                if (downTimeRecords.dimensionality != 200) {
                    var Bu_Oee = data.bu_oee;
                    bu_oee_parsed_data(Bu_Oee);
                }

                // OEE 图表展示
                var Oee = data.oee;
                oee_parsed_data(downTimeRecords.dimensionality, Oee);

                //Bu 停机代码 图表展示
                var BuDownTimeCode = data.bu_downtime;
                bu_downtime_code_parsed_data(BuDownTimeCode);

                // 停机代码 图表展示
                var DownTimeCode = data.downtime_code;
                downtime_code_parsed_data(downTimeRecords.dimensionality, downTimeRecords.is_daily, DownTimeCode);

                //停机前5大
                var Limit = data.limit;
                limit(Limit);
            } else {
                layout.popMsg('popMsg-danger', '请求数据出现错误!');
            }
        },
        error: function () {
            console.log("Error");
            layout.popMsg('popMsg-danger', '请求不到服务器!');
        }
    });
};

//区别： OEE 显示数据在柱状图上， 停机代码没有
//OEE 类型图表绘制
DTR.oee = function (cls, width, title, xAxis, series) {
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
            width: width,
            zoomType: 'xy',
            panning: true,
            panKey: 'ctrl',
            // borderColor: '#bdc3c7',
            // borderWidth: 1,
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
                pointWidth: 25,
                pointPadding: 0.2,
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

//停机代码图表绘制
DTR.downtime_code = function (cls, width, title, xAxis, series) {
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
            width: width,
            zoomType: 'xy',
            panning: true,
            panKey: 'ctrl',
            // borderColor: '#bdc3c7',
            // borderWidth: 1,
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
                pointWidth: 25,
                pointPadding: 0.2,
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

//Bu OEE 图表展示
function bu_oee_parsed_data(Bu_Oee) {
    if (Bu_Oee == "" || Bu_Oee == null) {
        return;
    }

    var Bu_OeeXAxis = new Array(),
        BuOeeAvailability = new Array(),
        BuOeeAvailabilityJ1 = new Array(),
        BuOeeOee = new Array(),
        BuOeeOeeJ1 = new Array(),
        BuOeePerformance = new Array();

    for (var buOee in Bu_Oee) {
        Bu_OeeXAxis.push(Bu_Oee[buOee].machine.nr);
        BuOeeOee.push({color: '#2980b9', y: Bu_Oee[buOee].oee});
        BuOeeOeeJ1.push({color: '#3498db', y: Bu_Oee[buOee].oee_j1});
        BuOeeAvailability.push({color: '#a94442', y: Bu_Oee[buOee].availability});
        BuOeeAvailabilityJ1.push({color: '#e74c3c', y: Bu_Oee[buOee].availability_j1});
        BuOeePerformance.push({color: '#e67e22', y: Bu_Oee[buOee].performance});
    }

    var BuOeeSeries = new Array(),
        BuAvailSeries = new Array(),
        BuPerSeries = new Array();

    BuOeeSeries.push({name: 'OEE', data: BuOeeOee}, {name: 'OEE_J1', data: BuOeeOeeJ1});
    BuAvailSeries.push({name: 'Availability', data: BuOeeAvailability}, {
        name: 'Availablity_J1',
        data: BuOeeAvailabilityJ1
    });

    BuPerSeries.push({name: 'Performance', data: BuOeePerformance});

    //设置图表宽度 为350
    DTR.oee('#bu_oee', '350', "Bu OEE", Bu_OeeXAxis, BuOeeSeries);
    DTR.oee('#bu_availability', '350', "Bu Availability", Bu_OeeXAxis, BuAvailSeries);
    DTR.oee('#bu_performance', '350', "Bu Performance", Bu_OeeXAxis, BuPerSeries);
}

//OEE 图表展示
function oee_parsed_data(dimensionality, Oee) {
    if (Oee == "" || Oee == null) {
        showNothing('#oee');
        showNothing('#availability');
        showNothing('#performance');
        return;
    }

    var OeeXAxis = new Array(),
        OeeXId = new Array(),
        OeeAvailability = new Array(),
        OeeAvailabilityJ1 = new Array(),
        OeeOee = new Array(),
        OeeOeeJ1 = new Array(),
        OeePerformance = new Array(),
        Performance_table = new Array();

    for (var oee in Oee) {
        //维度不同， 横坐标不一样
        if (dimensionality == 200) {
            $('.display-body').css({display: 'block'});
            $('.bu-charts').css({display: 'none'});
            $('.right-detail').css({display: 'block'});
            $('.sum-table').css({display: 'none'});
            OeeXAxis.push(Oee[oee].time);
        }
        else {
            $('.sum-table').css({display: 'block'});
            $('.display-body').css({display: 'table'});
            $('.bu-charts').css({display: 'table-cell'});
            $('.right-detail').css({display: 'table-cell'});
            OeeXId.push(Oee[oee].machine.id);
            OeeXAxis.push(Oee[oee].machine.nr);
            Performance_table.push({
                machine: Oee[oee].machine.nr,
                bu: Oee[oee].bu.name,
                performance: Oee[oee].performance
            });
        }

        OeeOee.push({color: '#2980b9', y: Oee[oee].oee});
        OeeOeeJ1.push({color: '#3498db', y: Oee[oee].oee_j1});
        OeeAvailability.push({color: '#a94442', y: Oee[oee].availability});
        OeeAvailabilityJ1.push({color: '#e74c3c', y: Oee[oee].availability_j1});
        OeePerformance.push({color: '#e67e22', y: Oee[oee].performance});
    }

    var OeeSeries = new Array(), AvailSeries = new Array(), PerSeries = new Array();

    OeeSeries.push({name: 'OEE', data: OeeOee}, {name: 'OEE_J1', data: OeeOeeJ1});
    AvailSeries.push({name: 'Availablity', data: OeeAvailability}, {name: 'Availablity_J1', data: OeeAvailabilityJ1});
    PerSeries.push({name: 'Performance', data: OeePerformance});

    DTR.oee('#oee', null, "OEE", OeeXAxis, OeeSeries);
    DTR.oee('#availability', null, "Availability", OeeXAxis, AvailSeries);
    DTR.oee('#performance', null, "Performance", OeeXAxis, PerSeries);

    //表现率展示
    performance(Performance_table);
}

//展示表现率
function performance(Performance_table) {
    if (Performance_table.length > 0) {
        //如果没有5个，只显示返回的
        if (Performance_table.length > 5) {
            for (var i = 0; i < 5; i++) {
                $('<tr><td> ' + Performance_table[i].machine + '<td>' +
                    Performance_table[i].bu + '</td> <td>' +
                    Performance_table[i].performance + '</td> </td></tr>').appendTo('.performance_tbody');
            }
        } else {
            for (var i = 0; i < Performance_table.length; i++) {
                $('<tr><td> ' + Performance_table[i].machine + '<td>' +
                    Performance_table[i].bu + '</td> <td>' +
                    Performance_table[i].performance + '</td> </td></tr>').appendTo('.performance_tbody');
            }
        }
    } else {
        showNothing('.performance_tbody');
    }
}

//Bu 停机代码
function bu_downtime_code_parsed_data(BuDownTimeCode) {
    if (BuDownTimeCode == "" || BuDownTimeCode == null) {
        showNothing('#bu_downtime_code');
        return;
    }

    var BuDTCXAxis = BuDownTimeCode.bus;
    var BuDTCSeries = BuDownTimeCode.downtime_code;
    DTR.downtime_code('#bu_downtime_code', '350', 'Bu DownTime Code', BuDTCXAxis, BuDTCSeries);
}

//停机代码
function downtime_code_parsed_data(dimensionality, isDaily, downTimeCode) {
    //计算停机代码
    var DTCXAxis = new Array(),
        DTCData = new Array(),
        DTCSeries = new Array();

    if (dimensionality == "200" && isDaily == "false") {
        DTCXAxis.push(downTimeCode.months);
        DTCSeries = downTimeCode.downtime_code;
    } else {
        for (var i in downTimeCode) {
            DTCXAxis.push(i);
            //计算步长
            var count = 0;
            for (var key in downTimeCode[i]) {
                count++;
                DTCData.push({key: key, value: downTimeCode[i][key]});
            }
        }

        for (var j = 0; j < count; j++) {
            var SeriesData = new Array();
            for (var m = j; m < DTCData.length; m += count) {
                SeriesData.push(DTCData[m].value);
            }
            DTCSeries.push({name: DTCData[j].key, data: SeriesData});
        }
    }

    var downtime_code = {
        XAxis: DTCXAxis,
        downtime_codes: DTCSeries
    };

    if (DTCXAxis.length == 0) {
        showNothing('#downtime_code');
        return;
    }

    DTR.downtime_code('#downtime_code', null, 'DownTime Code', DTCXAxis, DTCSeries);
}

//停机前5大
function limit(limit) {
    if (limit.length > 0) {
        for (var i = 0; i < limit.length; i++) {
            $('<tr><td>' + limit[i].machine + '</td>' +
                '<td>' + limit[i].bu + '</td>' +
                '<td>' + limit[i].downtime_code + '</td>' +
                '<td>' + limit[i].downtime_start + '</td>' +
                '<td>' + limit[i].time + '</td></tr>').appendTo('.limit_tbody');
        }
    } else {
        showNothing('.limit_tbody');
    }
}

//没有数据时显示
function showNothing(cls) {
    var LoadingHtml = '<div class="show_bullhorn">' +
        '<span class = "fa fa-bullhorn fa-3x"></span>' +
        '<span> 没有数据，请修改查询条件 </span></div>';

    $(cls).append(LoadingHtml);
}

// loading 动画
function charts_loading(cls) {
    var LoadingHtml = '<div class="show_spinner">' +
        '<span class = "fa fa-spinner fa-spin fa-4x"></span>' +
        '<span> 数据正在加载，请稍候... </span></div>';

    $(cls).append(LoadingHtml);
}