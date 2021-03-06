define(['text!home/main.html', 'home/vendor/competence',
    // 'com.csair.base/urlConfig', 
    // 'home/vendor/zepto/zepto',
    // 'home/vendor/zepto/touch',
    // 'home/vendor/underscore-min',
    'home/vendor/swipe'
    // ,
    // 'home/vendor/fastclick/fastclick'
    /*'js/util.js'*/
    /* ,'../cordova'*/


], function(demoIndexTemplate, Competence
    // , UrlConfig

) {

    var View = Piece.View.extend({

        id: 'detailview',
        isOver: 0,
        //isFirst: true,
        events: {

            // "click header": 'refresh'

        },

        bindings: {

            // "Segment:change io": "onIOChange",
            // "List:select flightstatus-list": "onItemSelect"
        },


        refresh: function() {
            window.location.href=window.location.href;
            // refreshMainPage();

        },
        cordovaExec: function(plugin, action, parameters, callback) {
            cordova.exec(function(data) {
                if (callback !== undefined) {
                    callback();
                }
            }, function(err) {
                //alert(err);
            }, plugin, action, parameters === null || parameters === undefined ? [] : parameters);
        },
        refreshMainPage: function() {

            loadModuleList("CubeModuleList", "mainList", "main", function() {
                window.mySwipe = Swipe(document.getElementById('slider'), {
                    continuous: true,
                    callback: function(index, elem) {
                        console.log("index=" + index);
                        var whichPage = index + 1;
                        if(isShowBullet){
                            $("#position").children("li").removeClass("on");
                            $("#position").children("li:nth-child(" + whichPage + ")").addClass("on");
                        }

                    }
                });
            });
        },


        //首页接受到信息，刷新页面
        receiveMessage: function(identifier, count) {
            console.log("AAA进入index revceiveMessage count = " + count + identifier);
            var $moduleTips = $(".module_Tips[identifier='" + identifier + "']");
            console.log("size=" + $moduleTips.size());
            if (count > 0) {
                $moduleTips.html(count);
                $moduleTips.show();

            } else {
                $moduleTips.hide();
            }
        },


        loadModuleList: function(plugin, action, type, callback) {
            var that = this;

            var me = this;
            if (isOver === 0) {

                isOver = isOver + 1;
                var i = 0;
                $("#swipe").html("");
                $("#position").html("");
                console.log('AAAAAA------------------ZHE');
                // cordova.exec(success,failed,plugin,action,[]);
                cordova.exec(function(data) {
                    data = $.parseJSON(data);

                    var valueArray = new Array;
                    var keyArray = new Array;
                    var s = 3;

                    _.each(data, function(value, key) {
                        if (key === "首页") {
                            keyArray[0] = key;
                            valueArray[0] = value;
                        } else if (key === "次页") {
                            keyArray[1] = key;
                            valueArray[1] = value;
                        } else if (key === "基础包") {
                            keyArray[2] = key;
                            valueArray[2] = value;
                        } else {

                            keyArray[s] = key;
                            valueArray[s] = value;
                            s++;
                        }
                        console.log(s);

                    });
                    console.log("keyArray0 " + keyArray[0]);
                    console.log("keyArray1 " + keyArray[1]);
                    console.log("valueArray0 " + valueArray[0]);
                    console.log("valueArray1 " + valueArray[1]);
                    console.log("AAAAAA-----1DATA");
                    _.each(valueArray, function(value) {
                        //alert(JSON.stringify(value));
                        var len = value.length;
                        var j = 0;

                        //排列

                        value = _.sortBy(value, function(v) {
                            console.log("v.sortingWeight " + v.sortingWeight + "");
                            console.log("v. " + v.stringify);
                            return v.sortingWeight;

                        });
                        // downloadFile(value.icon + "", packageName + "/moduleIcon", function(entry) {
                        //     // document.body.innerHTML = "<img src  = " + entry.fullPath + ">";
                        //     value.icon = entry.fullPath;
                        // });

                        console.log("value2 = " + value.sortingWeight);

                        _.each((value), function(value, key) {
                            if (j % 12 === 0) {
                                i++;
                                $("#swipe").append("<div class='page_div'><ul id='myul" + i + "' clsss='scrollContent'></ul></div>");
                                if(isShowBullet){
                                    $("#position").append("<li></li>");
                                }
                            }

                            console.log("aaaa --" + value.sortingWeight + "");



                            $("#myul" + i).append(
                                _.template($("#module_div_ul").html(), {
                                    'icon': value.icon,
                                    'name': value.name,
                                    'identifier': value.identifier,
                                    'moduleType': value.moduleType,
                                    'msgCount': value.msgCount
                                }));



                            j++;

                        });

                    });


                    // console.log("渲染动画了没有11111111111====");

                    var list = Competence;


                    if (list.application.competence === "Y") {

                        console.log("有权限进入乘务申请模块");

                    } else {
                        console.log("没有权限进入乘务申请模块");
                        $("#application").attr({
                            'style': 'opacity:0.4;filter:alpha(opacity=40);'
                        });
                    }

                    if (list.crewmen.competence === "Y") {

                        console.log("有权限进入空勤任务模块");

                    } else {


                        console.log("没有权限进入空勤任务模块");

                        $("#crewmen").attr({
                            'style': 'opacity:0.4;filter:alpha(opacity=40);'
                        });

                    }



                    if (list.aircrew.competence === "Y") {

                        console.log("有权限进入机组任务模块");

                    } else {

                        console.log("没有权限进入机组任务模块");
                        $("#aircrew").attr({
                            'style': 'opacity:0.4;filter:alpha(opacity=40);'
                        });
                    }



                    if(isShowBullet){
                        $("#position").children("li:nth-child(1)").addClass("on");
                    }

                    console.log("i=" + i);
                    if (callback !== undefined) {
                        callback();
                    }
                    isOver = isOver - 1;
                    //bind click
                    /*$("li[identifier]").bind("click", function() {

                        console.log("length " + $("li[identifier]").size());
                        if (isLoadModuleByPiece) {
                            that.accessModuleByPiece(this, that);
                        } else {
                            that.accessModuleByApp(this, that);
                        }


                    });*/
                }, function(err) {
                    alert("获取页面出错");
                }, plugin, action, []);

            }



        },

        getWeather: function() {
                if (window.localStorage["socUserInfo"]) {
                var that = this;
                var me = this;
                //admin登陆后台接口传过来的基地为null，
                var loginMessage = JSON.parse(window.localStorage["socUserInfo"]);

                var base = loginMessage.chnBase;
                console.log(base);
                //$("#base").html(base);

                $.ajax({
                    timeout: 10 * 1000,
                    url: "http://58.248.56.101/opws-mobile-web/mobile/flightinfo-FlightWeather-findWeather.action",
                    type: "get",
                    data: {
                        "optArea": base
                    },
                    dataType: "json",
                    success: function(data, textStatus, jqXHR) {
                        console.log('列表数据加载成功：' + textStatus + " response:[" + data + "]");


                        that.hasWeather = true;


                        console.log("data=====================");
                        console.log(data);

                        console.log(data.weather.tempreture);
                        console.log(data.weather.rmk);
                        window.localStorage["homeWeather"] = JSON.stringify(data);

                        me.weatherRender(data);

                    },
                    error: function(e, xhr, type) {


                        console.error('列表数据加载失败：' + e + "/" + type + "/" + xhr);

                        //that.Toast("加载天气信息失败!", null);
                        //如果失败再次获取天气信息
                        me.getWeatherFail();

                    },

                    complete: function(xhr, status) {

                        // closeLoader();



                    }
                });
            }
        },

        getWeatherFail: function() {

            //获取天气信息



            this.timeWeather = setInterval(function() {

                console.log("获取天气信息开始");



                if (that.hasWeather) {

                    console.log("获取天气信息成功");

                    clearInterval(that.timeWeather);



                } else {

                    // console.log("获取天气信息失败");

                    // var loginMessage = JSON.parse(window.localStorage["socUserInfo"]);

                    // if (loginMessage) {

                    //  console.log("基地信息存在====================");


                    that.getWeather();

                    // } else {
                    //  console.log("基地信息不存在====================");

                    //  socLogin();
                    // }
                }
            }, 10 * 1000);

        },

        weatherRender: function(data) {

            if (data.weather.rmk) {

                $("#weather").html(data.weather.rmk);

            }

            if (data.weather.tempreture) {

                $("#degree").html(data.weather.tempreture + "°");
            }
        },

        Toast: function(msg, duration) {
            duration = isNaN(duration) ? 3000 : duration;
            var m = document.createElement('div');
            m.innerHTML = msg;
            m.style.cssText = "width:60%; min-width:150px; background:#000; opacity:0.5; height:40px; color:#fff; line-height:40px; text-align:center; border-radius:5px; position:fixed; top:80%; left:20%; z-index:999999; font-weight:bold;";
            document.body.appendChild(m);
            setTimeout(function() {
                var d = 0.5;
                m.style.webkitTransition = '-webkit-transform ' + d + 's ease-in, opacity ' + d + 's ease-in';
                m.style.opacity = '0';
                setTimeout(function() {
                    document.body.removeChild(m);
                }, d * 1000);
            }, duration);
        },


        getDates: function() {
            if (window.localStorage["socUserInfo"]) {


                //admin登陆后台接口传过来的基地为null，默认为广州
                var loginMessage = JSON.parse(window.localStorage["socUserInfo"]);

                var base = loginMessage.chnBase;
                console.log(base);
                $("#base").html(base);
            }
            var weekday = new Array(7);
            weekday[1] = "星期一";
            weekday[2] = "星期二";
            weekday[3] = "星期三";
            weekday[4] = "星期四";
            weekday[5] = "星期五";
            weekday[6] = "星期六";
            weekday[0] = "星期日";
            var myDate = new Date();

            var month = myDate.getMonth();

            var currentMonth = parseInt(month) + 1;
            var currentDay = myDate.getDate();
            var day = weekday[myDate.getDay()];


            var date = currentMonth + "月" + currentDay + "日" + " " + day;
            $("#date").html(date);

        },

        timeWeather: null,

        hasWeather: false,

        app: null,

        applicationCompetence: null,
        aircrewCompetence: null,
        crewmenCompetence: null,

        accessModuleByApp: function(tirgger, that) {

            var me = this;
            console.log("模块点击111");
            var type = "main";
            var identifier = $(tirgger).attr("identifier");
            console.log("module_click----" + identifier); /*var type = $(this).attr("moduleType");*/



            //判断当前账号是否有权限进入此模块
            if (identifier === "com.csair.application") {

                if (me.applicationCompetence) {
                    that.cordovaExec("CubeModuleOperator", "showModule", [identifier, type]);

                } else {

                    that.Toast("对不起,您暂无权限进入此模块", 4000);

                }



            } else if (identifier === "com.csair.aircrew") {


                if (me.aircrewCompetence) {
                    that.cordovaExec("CubeModuleOperator", "showModule", [identifier, type]);

                } else {

                    that.Toast("对不起,您暂无权限进入此模块", 4000);

                }

            } else if (identifier === "com.csair.crewmen") {


                if (me.crewmenCompetence) {

                    that.cordovaExec("CubeModuleOperator", "showModule", [identifier, type]);
                } else {

                    that.Toast("对不起,您暂无权限进入此模块", 4000);

                }
            } else if (identifier === "com.csair.setting") {

                that.cordovaExec("CubeModuleOperator", "setting");


            } else {

                that.cordovaExec("CubeModuleOperator", "showModule", [identifier, type]);
            }
        },

        accessModuleByPiece: function(tirgger, that) {

            var me = this;
            Piece.Session.deleteObject('moduleIndex');
            console.log("模块点击2222");
            var type = "main";
            var identifier = $(tirgger).attr("identifier");



            console.log("module_click----" + identifier); /*var type = $(this).attr("moduleType");*/


            //判断当前账号是否有权限进入此模块
            if (identifier === "com.csair.application") {

                if (me.applicationCompetence) {

                    that.container.navigateForResult('/' + identifier + '/index', {
                        trigger: true
                    }, '/com.csair.home/main', this.onGotResult);

                } else {

                    that.Toast("对不起,您暂无权限进入此模块", null);

                }



            } else if (identifier === "com.csair.aircrew") {


                if (me.aircrewCompetence) {
                    that.container.navigateForResult('/' + identifier + '/index', {
                        trigger: true
                    }, '/com.csair.home/main', this.onGotResult);

                } else {

                    that.Toast("对不起,您暂无权限进入此模块", null);

                }

            } else if (identifier === "com.csair.crewmen") {


                if (me.crewmenCompetence) {

                    that.container.navigateForResult('/' + identifier + '/index', {
                        trigger: true
                    }, '/com.csair.home/main', this.onGotResult);
                } else {

                    that.Toast("对不起,您暂无权限进入此模块", null);

                }
            } else if (identifier === "com.csair.setting") {

                that.cordovaExec("CubeModuleOperator", "setting");
            } else if (identifier === "com.foss.chat") {
                that.cordovaExec("CubeModuleOperator", "showModule", [identifier, type]);
            } else if (identifier === "com.foss.announcement") {
                that.cordovaExec("CubeModuleOperator", "showModule", [identifier, type]);
            } else if (identifier === "com.foss.message.record") {
                that.cordovaExec("CubeModuleOperator", "showModule", [identifier, type]);
            } else {

                that.container.navigateForResult('/' + identifier + '/index', {
                    trigger: true
                }, '/com.csair.home/main', this.onGotResult);
            }
        },
        //清楚之前缓存数据


        deleteDatas: function() {



            console.log("值班领导缓存");
            //值班领导缓存

            window.sessionStorage["com.csair.leading-leadingList.html"] = null;

            console.log("值班领导缓存结束");
            //我的空勤任务
            var mytask = [{
                querySite: 'flightTask',

            }, {
                querySite: 'sbyTask',

            }, {
                querySite: 'grdTask',

            }, {
                querySite: 'otherTask',

            }, {
                querySite: 'simTask',

            }, {
                querySite: 'findHistoryFly',

            }];

            for (var i = 0; i < mytask.length; i++) {

                window.sessionStorage['com.csair.crewmen-myselfTask.html-' + mytask[i].querySite] = null;

            }



            //信息公告

            window.sessionStorage["com.csair.notification-notification.html-findNoticeList"] = null;
            window.sessionStorage["com.csair.notification-notification.html-warningNoticeList"] = null;
            window.sessionStorage["com.csair.notification-notification.html-findEBNoticeList"] = null;
            window.sessionStorage["com.csair.notification-notification.html-noticeCabinlist"] = null;


            //运行橄榄


            window.sessionStorage["com.csair.overview-overview.html-today"] = null;
            window.sessionStorage["com.csair.overview-overview.html-yestoday"] = null;

        },
        onShow: function() {

            var that = this;
            var me = this;
            me.getDates();
            var isLoadModuleByPiece = true;

            me.deleteDatas();

            var list = Competence;



            var homeWeather = window.localStorage["homeWeather"];

            if (homeWeather === "null" || homeWeather === null || homeWeather === undefined || homeWeather === "undefined") {

                console.log("天气无数据");
                me.getWeather();


            } else {
                console.log("有数据");


                console.log(homeWeather);

                var datas= JSON.parse(homeWeather);

                console.log(datas);
                me.weatherRender(datas);
            }


            console.log("打印权限列表");
            console.log(list);


            if (list.application.competence === "Y") {
                me.applicationCompetence = "Y";
            }
            if (list.crewmen.competence === "Y") {
                me.crewmenCompetence = "Y";
            }
            if (list.aircrew.competence === "Y") {
                me.aircrewCompetence = "Y";
            }



            window.refreshMainPage = this.refreshMainPage;
            window.receiveMessage = this.receiveMessage;
            window.loadModuleList = this.loadModuleList;



            console.log("初始化借宿了啊");

            new FastClick(document.body);

            //封装cordova的执行方法，加上回调函数



            //设置按键
            // $("#setting_btn").click(function() {
            //  cordovaExec("CubeModuleOperator", "setting");
            // });
            //搜索按键
            $("#search_btn").click(function() {
                    

                //搜索事件
                var keyword = $("#search_input").val();
                console.log("点击了搜索按键：keyword=" + keyword);


                if (keyword) {
                    that.Toast("航班号或机未号!" + keyword, null);


                    var myDate = new Date();


                    var month = myDate.getMonth();

                    var currentMonth = parseInt(month) + 1;
                    var currentDay = myDate.getDate();

                    var confirmTime = myDate.getFullYear() + "-" + (currentMonth < 10 ? "0" + currentMonth : currentMonth) + "-" + (currentDay < 10 ? "0" + currentDay : currentDay);

                    console.log("confirmTime::++==" + confirmTime);


                    var queryAction = {
                        QueryType: '航班机尾号',
                        querySite: 'flight',
                        queryUrl: "",
                        requestParams: {
                            'fltDt': confirmTime,
                            'fltNr': keyword
                        },
                        fromPage: "home"
                    };
                    console.log("点击了搜索按键：queryActiond=");


                    window.localStorage['com.csair.dynamic-flightDynamic.html'] = JSON.stringify(queryAction);
                    var identifier = 'com.csair.dynamic';
                    console.log(window.location.href);
                    if (isLoadModuleByPiece) {
                        
                        that.container.navigateForResult('/' + identifier + '/index', {
                            trigger: true
                        }, '/com.csair.home/main', this.onGotResult);
                    } else {
                        that.cordovaExec("CubeModuleOperator", "showModule", ["com.csair.dynamic", "main"]);
                    }
                    //window.location = "../com.csair.dynamic/index.html#com.csair.dynamic/flightDynamic";

                } else {


                    that.Toast("请输入航班号或机未号!", null);

                }

            });


            //机场天气模块点击

            $("#weatherContent").click(function() {

                console.log("模块点击");
                var type = "main";
                var identifier = "com.csair.airport";
                console.log("module_click----" + identifier); /*var type = $(this).attr("moduleType");*/
                if (isLoadModuleByPiece) {
                    that.container.navigateForResult('/' + identifier + '/index', {
                        trigger: true
                    }, '/com.csair.home/main', this.onGotResult);
                } else {
                    that.cordovaExec("CubeModuleOperator", "showModule", [identifier, type]);
                }

            });

            //模块点击
            $("li[identifier]").die("click");
            $("li[identifier]").live("click", function() {
                console.log("length " + $("li[identifier]").size());
                if (isLoadModuleByPiece) {
                    that.accessModuleByPiece(this, that);
                } else {
                    that.accessModuleByApp(this, that);
                }


            });


            //没有权限的模块灰色显示

            //获取天气信息



            // this.timeWeather = setInterval(function() {

            //     console.log("获取天气信息开始");



            //     if (that.hasWeather) {

            //         console.log("获取天气信息成功");

            //         clearInterval(that.timeWeather);



            //     } else {

            //         // console.log("获取天气信息失败");

            //         // var loginMessage = JSON.parse(window.localStorage["socUserInfo"]);

            //         // if (loginMessage) {

            //         //  console.log("基地信息存在====================");


            //         that.getWeather();

            //         // } else {
            //         //  console.log("基地信息不存在====================");

            //         //  socLogin();
            //         // }
            //     }
            // }, 10 * 1000);

            //冒泡提示信息: msg:提示内容, duration:停留时间
            that.cordovaExec("CubeModuleList", "ShowMainView");

            var isLogin = true;
            console.log("4");
            if (window.sessionStorage.isIn) {
                isLogin = window.sessionStorage.isIn;
            } else {
                window.sessionStorage.isIn = isLogin;
            }

            if (isLogin == true) {
                that.cordovaExec("CubeModuleOperator", "sync", [], function() {
                    // alert("第一次登陆");
                    isFirst = false;
                    isLogin = false;
                    window.sessionStorage["isIn"] = isLogin;

                    loadModuleList("CubeModuleList", "mainList", "main", function() {
                        window.mySwipe = Swipe(document.getElementById('slider'), {
                            continuous: true,
                            callback: function(index, elem) {
                                console.log("index=" + index);
                                var whichPage = index + 1;
                                if(isShowBullet){
                                    $("#position").children("li").removeClass("on");
                                    $("#position").children("li:nth-child(" + whichPage + ")").addClass("on");
                                //li_click();
                                }

                            }
                        });


                    });


                });
            } else {
                //alert("第二次登陆"+window.sessionStorage["isIn"]);


                loadModuleList("CubeModuleList", "mainList", "main", function() {
                    window.mySwipe = Swipe(document.getElementById('slider'), {
                        continuous: true,
                        callback: function(index, elem) {
                            console.log("index=" + index);
                            var whichPage = index + 1;
                            if(isShowBullet){
                                $("#position").children("li").removeClass("on");
                                $("#position").children("li:nth-child(" + whichPage + ")").addClass("on");
                                //li_click();
                            }
                        }
                    });


                });

            }

           

        },



        render: function() {
            $(this.el).html(demoIndexTemplate);
            Piece.Session.deleteObject('moduleIndex');
            window.isShowBullet = true;

            Piece.View.prototype.render.call(this);
            return this;
        },



    });

    return View;
});