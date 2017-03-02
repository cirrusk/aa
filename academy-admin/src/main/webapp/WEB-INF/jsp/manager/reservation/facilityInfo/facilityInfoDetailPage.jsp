<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">
    //Grid Init , 날짜/세션정보
    var dateGrid = new AXGrid(); // instance 상단그리드

    //Grid Default Param
    var dateParam = {
          sortColKey: "Rsv.facilityInfo.dateList"
        , sortIndex: 1
        , sortOrder:"DESC"
    };

    //Grid Init , 우선운영요일
    var firstGrid = new AXGrid(); // instance 상단그리드

    //Grid Default Param
    var firstParam = {
          sortColKey: "Rsv.facilityInfo.detailtwolist"
        , sortIndex: 1
        , sortOrder:"DESC"
    };

    //Grid Init , 예약자격/기간
    var termGrid = new AXGrid(); // instance 상단그리드
    var cookTermGrid = new AXGrid(); // instance 상단그리드
    //Grid Default Param
    var termParam = {
        sortColKey: "Rsv.facilityInfo.detailThreeTerm"
    };

    //Grid Init , 누적예약제한
    var disGrid = new AXGrid(); // instance 상단그리드
    var cookDisGrid = new AXGrid(); // instance 상단그리드
    //Grid Default Param
    var disParam = {
        sortColKey: "Rsv.facilityInfo.detailThreeDis"
    };

    //Grid Init , 취소패널티
    var cancelGrid = new AXGrid(); // instance 상단그리드
    var cookCancelGrid = new AXGrid(); // instance 상단그리드
    //Grid Default Param
    var cancelParam = {
        sortColKey: "Rsv.facilityInfo.detailThreeCancel"
    };

	$(document).ready(function(){
        param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"};

        dateList.init(); // 날짜/세션정보
        firstList.init(); //우선운영요일/휴무지정

        var type = $("#typename").val();

        if(type == "교육장,퀸룸/파티룸" || type == "퀸룸/파티룸") {
           $("#cookList").show();
        }
        /*리스트셋팅*/
        termList.init();//예약자격/기간 리스트
        disList.init(); //누적예약제한
        cancelList.init();//취소/패널티
        if(type == "교육장,퀸룸/파티룸" || type == "퀸룸/파티룸") {
            cookTermList.init();//요리명장 우대 예약조건 예약자격/기간 리스트
            cookDisList.init();//요리명장 우대 예약조건 누적예약제한
            cookCancelList.init();//요리명장 우대 예약조건 취소/패널티
        }

        //목록이동
        $("#btnReturn").on("click", function(){
            var f = document.listForm;
            f.action = "/manager/reservation/facilityInfo/facilityInfoList.do";
            f.submit();
        });

	});

    // 날짜/세션정보
    var dateList = {
        /** init : 초기 화면 구성 (Grid)
         */
        init : function() {
            var idx = 0; // 정렬 Index
            var checkCount = "${checkCount.typecount}";
            var typeName = "${detailpage.typename}";
            if(checkCount>1){
                var _colGroup = [
                    {key:"weekdate", label:"요일", width:"50", align:"center", sort:false}
                    , {key:"sessionname", label:"세션", width:"80", align:"center", sort:false}
                    , {key:"weektime", label:"시간", width:"80", align:"center", sort:false}
                    , {key:"price", label:"정상가", width:"100", align: "center", sort:false}
                    , {key:"discountprice", addclass:idx++, label:"할인가", width:"100", align:"center", sort:false}
                    , {key:"queenprice", label:"정상가(퀸룸)", width:"100", align: "center", sort:false}
                    , {key:"queendiscountprice", addclass:idx++, label:"할인가(퀸룸)", width:"100", align:"center", sort:false}
                ]
            }else{
               if(typeName == "비즈룸"){
                   var _colGroup = [
                         {key:"weekdate", label:"요일", width:"50", align:"center", sort:false}
                       , {key:"sessionname", label:"세션", width:"80", align:"center", sort:false}
                       , {key:"weektime", label:"시간", width:"80", align:"center", sort:false}
                   ]
               }else if(typeName == "교육장"){
                   var _colGroup = [
                       {key:"weekdate", label:"요일", width:"50", align:"center", sort:false}
                       , {key:"sessionname", label:"세션", width:"80", align:"center", sort:false}
                       , {key:"weektime", label:"시간", width:"80", align:"center", sort:false}
                       , {key:"price", label:"정상가", width:"100", align: "center", sort:false}
                       , {key:"discountprice", addclass:idx++, label:"할인가", width:"100", align:"center", sort:false}
                   ]
               }else if(typeName == "퀸룸/파티룸" || typeName == "퀸룸"){
                   var _colGroup = [
                       {key:"weekdate", label:"요일", width:"50", align:"center", sort:false}
                       , {key:"sessionname", label:"세션", width:"80", align:"center", sort:false}
                       , {key:"weektime", label:"시간", width:"80", align:"center", sort:false}
                       , {key:"queenprice", label:"정상가(퀸룸)", width:"100", align: "center", sort:false}
                       , {key:"queendiscountprice", addclass:idx++, label:"할인가(퀸룸)", width:"100", align:"center", sort:false}
                   ]
               }else{
                   var _colGroup = [
                       {key:"weekdate", label:"요일", width:"50", align:"center", sort:false}
                       , {key:"sessionname", label:"세션", width:"80", align:"center", sort:false}
                       , {key:"weektime", label:"시간", width:"80", align:"center", sort:false}
                       , {key:"price", label:"정상가", width:"100", align: "center", sort:false}
                       , {key:"discountprice", addclass:idx++, label:"할인가", width:"100", align:"center", sort:false}
                       , {key:"queenprice", label:"정상가(퀸룸)", width:"100", align: "center", sort:false}
                       , {key:"queendiscountprice", addclass:idx++, label:"할인가(퀸룸)", width:"100", align:"center", sort:false}
                   ]
               }
            }



            var gridParam = {
                colGroup : _colGroup
                , fitToWidth: true
                , targetID : "AXGridDate_${param.frmId}"
                , height : "300px"
            }
            fnGrid.nonPageGrid(dateGrid, gridParam);
            dateList.doSearch(); // 날짜/세션정보
        }, doSearch : function(param) {
            // Param 셋팅(검색조건)
            var initParam = {
                roomseq : $("#roomseq").val()
            };
            $.extend(dateParam, param);
            $.extend(dateParam, initParam);

            $.ajaxCall({
                url: "<c:url value="/manager/reservation/facilityInfo/facilityInfoDetailDateAjax.do"/>"
                , data: dateParam
                , success: function( data, textStatus, jqXHR){
                    if(data.result < 1){
    					var mag = '<spring:message code="errors.load"/>';
    					alert(mag);
                        return;
                    } else {
                        callbackList(data);
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
					var mag = '<spring:message code="errors.load"/>';
					alert(mag);
                }
            });

            function callbackList(data) {
                var obj = data; //JSON.parse(data);
                // Grid Bind
                var gridData = {
                    list: obj.dataList
                };
                // Grid Bind Real
                dateGrid.setData(gridData);
            }
        }
    }

    //운영일 휴무일 지정
    var firstList = {
        /** init : 초기 화면 구성 (Grid)
         */
        init : function() {
            var idx = 0; // 정렬 Index
            var _colGroup = [
                {key:"row_num", label:"No.", width:"40", align:"center", formatter:"money", sort:false}
                , {key:"worktypecode", label:"구분", width:"50", align:"center", sort:false, formatter: function(){
                    if(this.item.worktypecode=="S01"){
                        return "<span>운영<span>";
                    }else if(this.item.worktypecode=="S02"){
                        return "<span>휴무<span>";
                    }
                }}
                , {key:"setdate", label:"일자", width:"80", align:"center", sort:false}
                , {key: "sessioncount", label : "세션수", width: "360", align: "center", sort:false , formatter: function(){
                    if(this.item.worktypecode=="S01"){
                        return this.item.sessioncount;
                    }else if(this.item.worktypecode=="S02"){
                        return "-";
                    }
                }}
                , {key:"ki", label:"상세보기", width:"60", align:"center", sort:false, formatter: function(){
                    if(this.item.worktypecode=="S01"){
                        return "<a href=\"javascript:;\" class='btn_green' onclick=\"gridEvent.nameClick('" + this.item.setdate + "')\">보기</a>";
                    }else if(this.item.worktypecode=="S02"){
                        return "-";
                    }
                }}
            ]

            var gridParam = {
                colGroup : _colGroup
                , fitToWidth: true
                , targetID : "AXGridFirst_${param.frmId}"
                , height : "300px"
            }
            fnGrid.nonPageGrid(firstGrid, gridParam);
            firstList.doSearch(); //우선운영요일/휴무지정
        }, doSearch : function(param) {
            // Param 셋팅(검색조건)
            var initParam = {
                roomseq : $("#roomseq").val()
            };
            $.extend(firstParam, param);
            $.extend(firstParam, initParam);

            $.ajaxCall({
                url: "<c:url value="/manager/reservation/facilityInfo/facilityInfoDetailTwoListAjax.do"/>"
                , data: firstParam
                , success: function( data, textStatus, jqXHR){
                    if(data.result < 1){
    					var mag = '<spring:message code="errors.load"/>';
    					alert(mag);
                        return;
                    } else {
                        callbackList(data);
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
					var mag = '<spring:message code="errors.load"/>';
					alert(mag);
                }
            });

            function callbackList(data) {
                var obj = data; //JSON.parse(data);
                // Grid Bind
                var gridData = {
                    list: obj.dataList
                };
                // Grid Bind Real
                firstGrid.setData(gridData);
            }
        }
    }

	//예약자격 리스트
    var termList = {
        /** init : 초기 화면 구성 (Grid)
         */
        init : function() {
            var idx = 0; // 정렬 Index
            var _colGroup = [
                {key:"rsvrole", label:"예약자격", width:"100", align:"center", sort:false}
                , {key:"startdate", label:"시작일", width:"100", align:"center", sort:false}
                , {key:"enddate", label:"종료일", width:"100", align:"center", sort:false}
                , {key: "setweek", label : "적용세션유형", width: "150", align: "center"}
            ]
            var gridParam = {
                colGroup : _colGroup
                , fitToWidth: true
                , colHead : {
                    heights : [ 20, 20 ],rows :
                            [
                                [
                                    {colSeq : 0, rowspan : 2, valign : "middle"},
                                    {colSeq : null, colspan : 2, valign : "middle", label : "예약가능시간", align : "center"},
                                    {colSeq : 3, rowspan : 2, valign : "middle"},
                                    {colSeq : 4, rowspan : 2, valign : "middle"}
                                ],[
                                {colSeq : 1},
                                {colSeq : 2}
                            ]
                            ]
                }
                , targetID : "AXGridTerm_${param.frmId}"
                , height : "300px"
            }
            fnGrid.nonPageGrid(termGrid, gridParam);
            termList.doSearch();//예약자격/기간 리스트
        }, doSearch : function(param) {
            // Param 셋팅(검색조건)
            var initParam = {
                roomseq : $("#roomseq").val()
                , cookType : "N"
            };
            $.extend(termParam, param);
            $.extend(termParam, initParam);

            $.ajaxCall({
                url: "<c:url value="/manager/reservation/facilityInfo/facilityInfoDetailThreeTermListAjax.do"/>"
                , data: termParam
                , success: function( data, textStatus, jqXHR){
                    if(data.result < 1){
    					var mag = '<spring:message code="errors.load"/>';
    					alert(mag);
                        return;
                    } else {
                        callbackList(data);
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
					var mag = '<spring:message code="errors.load"/>';
					alert(mag);
                }
            });

            function callbackList(data) {
                var obj = data; //JSON.parse(data);
                // Grid Bind
                var gridData = {
                    list: obj.dataList
                };
                // Grid Bind Real
                termGrid.setData(gridData);
            }
        }
    }

    //누적예약제한 리스트
    var disList = {
        /** init : 초기 화면 구성 (Grid)
         */
        init : function() {
            var idx = 0; // 정렬 Index
            var _colGroup = [
                {key:"role", label:"자격", width:"150", align:"center", sort:false}
                , {key:"globaldailycount", addClass:idx++, label:"일", width:"100", align:"center"}
                , {key:"globalweeklycount", addClass:idx++, label:"주", width:"100", align:"center"}
                , {key:"globalmonthlycount", addClass:idx++, label:"월", width:"100", align:"center"}
                , {key:"ppdailycount", addClass:idx++, label:"일", width:"100", align:"center"}
                , {key:"ppweeklycount", addClass:idx++, label:"주", width:"100", align:"center"}
                , {key:"ppmonthlycount", addClass:idx++, label:"월", width:"100", align:"center"}
            ]

            var gridParam = {
                colGroup : _colGroup
                , fitToWidth: true
                , colHead : {
                    heights : [ 20, 20 ],rows :
                            [
                                [
                                    {colSeq : 0, rowspan : 2, valign : "middle"},
                                    {colSeq : null, colspan : 3, valign :"middle", label:"전국PP예약제한횟수"},
                                    {colSeq : null, colspan : 3, valign :"middle", label:"PP별예약제한횟수"},
                                    {colSeq : 7, rowspan : 2, valign : "middle"}
                                ],[
                                {colSeq : 1},
                                {colSeq : 2},
                                {colSeq : 3},
                                {colSeq : 4},
                                {colSeq : 5},
                                {colSeq : 6}
                             ]
                            ]
                }
                , targetID : "AXGridDis_${param.frmId}"
                , height : "300px"
            }
            fnGrid.nonPageGrid(disGrid, gridParam);
            disList.doSearch(); //누적예약제한
        }, doSearch : function(param) {
            // Param 셋팅(검색조건)
            var initParam = {
                roomseq : $("#roomseq").val()
                , cookType : "N"
            };
            $.extend(disParam, param);
            $.extend(disParam, initParam);

            $.ajaxCall({
                url: "<c:url value="/manager/reservation/facilityInfo/facilityInfoDetailThreeDisListAjax.do"/>"
                , data: disParam
                , success: function( data, textStatus, jqXHR){
                    if(data.result < 1){
    					var mag = '<spring:message code="errors.load"/>';
    					alert(mag);
                        return;
                    } else {
                        callbackList(data);
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
					var mag = '<spring:message code="errors.load"/>';
					alert(mag);
                }
            });

            function callbackList(data) {
                var obj = data; //JSON.parse(data);
                // Grid Bind
                var gridData = {
                    list: obj.dataList
                };
                // Grid Bind Real
                disGrid.setData(gridData);
            }
        }
    }

    //취소/패널티 리스트
    var cancelList = {
        /** init : 초기 화면 구성 (Grid)
         */
        init : function() {
            var idx = 0; // 정렬 Index
            var _colGroup = [
                {key:"typecode", label:"구분", width:"150", align:"center", sort:false}
                , {key:"typedetailcode", label:"취소 기준", width:"150", align:"center", sort:false}
                , {key:"applytypecode", label:"패널티", width:"200", align:"center"}
            ]

            var gridParam = {
                colGroup : _colGroup
                , fitToWidth: true
                , targetID : "AXGridCancel_${param.frmId}"
                , height : "300px"
            }
            fnGrid.nonPageGrid(cancelGrid, gridParam);
            cancelList.doSearch();//취소/패널티
        }, doSearch : function(param) {
            // Param 셋팅(검색조건)
            var initParam = {
                roomseq : $("#roomseq").val()
                , cookType : "N"
            };
            $.extend(cancelParam, param);
            $.extend(cancelParam, initParam);

            $.ajaxCall({
                url: "<c:url value="/manager/reservation/facilityInfo/facilityInfoDetailThreeCancelListAjax.do"/>"
                , data: cancelParam
                , success: function( data, textStatus, jqXHR){
                    if(data.result < 1){
    					var mag = '<spring:message code="errors.load"/>';
    					alert(mag);
                        return;
                    } else {
                        callbackList(data);
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
					var mag = '<spring:message code="errors.load"/>';
					alert(mag);
                }
            });

            function callbackList(data) {
                var obj = data; //JSON.parse(data);
                // Grid Bind
                var gridData = {
                    list: obj.dataList
                };
                // Grid Bind Real
                cancelGrid.setData(gridData);
            }
        }
    }

    //요리명장 우대 예약 조건 예약자격 리스트
    var cookTermList = {
        /** init : 초기 화면 구성 (Grid)
         */
        init : function() {
            var idx = 0; // 정렬 Index
            var _colGroup = [
                {key:"rsvrole", label:"예약자격", width:"100", align:"center", sort:false}
                , {key:"startdate", label:"시작일", width:"100", align:"center", sort:false}
                , {key:"enddate", label:"종료일", width:"100", align:"center", sort:false}
                , {key: "setweek", label : "적용세션유형", width: "150", align: "center"}
            ]

            var gridParam = {
                colGroup : _colGroup
                , fitToWidth: true
                , colHead : {
                    heights : [ 20, 20 ],rows :
                            [
                                [
                                    {colSeq : 0, rowspan : 2, valign : "middle"},
                                    {colSeq : null, colspan : 2, valign : "middle", label : "예약가능시간", align : "center"},
                                    {colSeq : 3, rowspan : 2, valign : "middle"},
                                    {colSeq : 4, rowspan : 2, valign : "middle"}
                                ],[
                                {colSeq : 1},
                                {colSeq : 2}
                            ]
                            ]
                }
                , targetID : "AXGridCookTerm_${param.frmId}"
                , height : "300px"
            }
            fnGrid.nonPageGrid(cookTermGrid, gridParam);
            cookTermList.doSearch();//요리명장 우대 예약조건 예약자격/기간 리스트
        }, doSearch : function(param) {
            // Param 셋팅(검색조건)
            var initParam = {
                roomseq : $("#roomseq").val()
                , cookType : "Y"
            };
            $.extend(termParam, param);
            $.extend(termParam, initParam);

            $.ajaxCall({
                url: "<c:url value="/manager/reservation/facilityInfo/facilityInfoDetailThreeTermListAjax.do"/>"
                , data: disParam
                , success: function( data, textStatus, jqXHR){
                    if(data.result < 1){
    					var mag = '<spring:message code="errors.load"/>';
    					alert(mag);
                        return;
                    } else {
                        callbackList(data);
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
					var mag = '<spring:message code="errors.load"/>';
					alert(mag);
                }
            });

            function callbackList(data) {
                var obj = data; //JSON.parse(data);
                // Grid Bind
                var gridData = {
                    list: obj.dataList
                };
                // Grid Bind Real
                cookTermGrid.setData(gridData);
            }
        }
    }

    //요리명장 우대 예약 조건 누적예약제한 리스트
    var cookDisList = {
        /** init : 초기 화면 구성 (Grid)
         */
        init : function() {
            var idx = 0; // 정렬 Index
            var _colGroup = [
                {key:"role", label:"자격", width:"150", align:"center", sort:false}
                , {key:"globaldailycount", addClass:idx++, label:"일", width:"100", align:"center"}
                , {key:"globalweeklycount", addClass:idx++, label:"주", width:"100", align:"center"}
                , {key:"globalmonthlycount", addClass:idx++, label:"월", width:"100", align:"center"}
                , {key:"ppdailycount", addClass:idx++, label:"일", width:"100", align:"center"}
                , {key:"ppweeklycount", addClass:idx++, label:"주", width:"100", align:"center"}
                , {key:"ppmonthlycount", addClass:idx++, label:"월", width:"100", align:"center"}
            ]

            var gridParam = {
                colGroup : _colGroup
                , fitToWidth: true
                , colHead : {
                    heights : [ 20, 20 ],rows :
                            [
                                [
                                    {colSeq : 0, rowspan : 2, valign : "middle"},
                                    {colSeq : null, colspan : 3, valign :"middle", label:"전국PP예약제한횟수"},
                                    {colSeq : null, colspan : 3, valign :"middle", label:"PP별예약제한횟수"},
                                    {colSeq : 7, rowspan : 2, valign : "middle"}
                                ],[
                                {colSeq : 1},
                                {colSeq : 2},
                                {colSeq : 3},
                                {colSeq : 4},
                                {colSeq : 5},
                                {colSeq : 6}
                            ]
                            ]
                }
                , targetID : "AXGridCookDis_${param.frmId}"
                , height : "300px"
            }
            fnGrid.nonPageGrid(cookDisGrid, gridParam);
            cookDisList.doSearch();//요리명장 우대 예약조건 누적예약제한
        }, doSearch : function(param) {
            // Param 셋팅(검색조건)
            var initParam = {
                roomseq : $("#roomseq").val()
                , cookType : "Y"
            };
            $.extend(termParam, param);
            $.extend(termParam, initParam);

            $.ajaxCall({
                url: "<c:url value="/manager/reservation/facilityInfo/facilityInfoDetailThreeDisListAjax.do"/>"
                , data: termParam
                , success: function( data, textStatus, jqXHR){
                    if(data.result < 1){
    					var mag = '<spring:message code="errors.load"/>';
    					alert(mag);
                        return;
                    } else {
                        callbackList(data);
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
					var mag = '<spring:message code="errors.load"/>';
					alert(mag);
                }
            });

            function callbackList(data) {
                var obj = data; //JSON.parse(data);
                // Grid Bind
                var gridData = {
                    list: obj.dataList
                };
                // Grid Bind Real
                cookDisGrid.setData(gridData);
            }
        }
    }

    //요리명장 우대 예약 조건 취소/패널티 리스트
    var cookCancelList = {
        /** init : 초기 화면 구성 (Grid)
         */
        init : function() {
            var idx = 0; // 정렬 Index
            var _colGroup = [
                  {key:"typecode", label:"구분", width:"150", align:"center", sort:false}
                , {key:"typedetailcode", label:"취소 기준", width:"150", align:"center", sort:false}
                , {key:"applytypecode", label:"패널티", width:"200", align:"center"}
            ]

            var gridParam = {
                colGroup : _colGroup
                , fitToWidth: true
                , targetID : "AXGridCookCancel_${param.frmId}"
                , height : "300px"
            }
            fnGrid.nonPageGrid(cookCancelGrid, gridParam);
            cookCancelList.doSearch();//요리명장 우대 예약조건 취소/패널티
        }, doSearch : function(param) {
            // Param 셋팅(검색조건)
            var initParam = {
                roomseq : $("#roomseq").val()
                , cookType : "Y"
            };
            $.extend(cancelParam, param);
            $.extend(cancelParam, initParam);

            $.ajaxCall({
                url: "<c:url value="/manager/reservation/facilityInfo/facilityInfoDetailThreeCancelListAjax.do"/>"
                , data: cancelParam
                , success: function( data, textStatus, jqXHR){
                    if(data.result < 1){
    					var mag = '<spring:message code="errors.load"/>';
    					alert(mag);
                        return;
                    } else {
                        callbackList(data);
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
					var mag = '<spring:message code="errors.load"/>';
					alert(mag);
                }
            });

            function callbackList(data) {
                var obj = data; //JSON.parse(data);
                // Grid Bind
                var gridData = {
                    list: obj.dataList
                };
                // Grid Bind Real
                cookCancelGrid.setData(gridData);
            }
        }
    }

    //미리보기
    var gridEvent = {
        nameClick: function (setdate) {

            var param = {
                  setdate : setdate
                , roomseq : $("#roomseq").val()
                , checkCount : $("#checkCount").val()
                , typeName : $("#typename").val()
            };

            var popParam = {
                url: "<c:url value="/manager/reservation/facilityInfo/facilityInfoDetailSessionPop.do" />"
                , width: "612"
                , height: "400"
                , params: param
                , targetId: "searchPopup"
            }

            window.parent.openManageLayerPopup(popParam);

        }
    }


</script>
</head>

<body class="bgw">
<!--title //-->
    <div class="contents_title clear">
        <h2 class="fl">시설 정보 상세</h2>
    </div>
    <form:form id="listForm" name="listForm" method="post">
        <input type="hidden" id="roomseq" name="roomseq" value="${detailpage.roomseq}"/>
        <input type="hidden" id="typename" name="typename" value="${detailpage.typename}"/>
        <input type="hidden" id="checkCount" name="checkCount" value="${checkCount.typecount}"/>
        <input type="hidden" name="frmId" value="${param.frmId}"/>
        <input type="hidden" name="menuAuth" id="menuAuth" value="${param.menuAuth}"/>
    </form:form>
<!--search table // -->
    <div class="tbl_write" style="height: 800px;overflow-y:scroll;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
        	<colgroup>
				<col width="13%" />
				<col width="37%"  />
				<col width="13%" />
				<col width="37%"  />
			</colgroup>
            <tr>
                <th scope="row">시설 코드</th>
                <td colspan="3">${detailpage.roomseq}</td>
            </tr>
            <tr>
                <th scope="row">PP</th>
                <td>${detailpage.ppname}</td>
                <th scope="row">시설명</th>
                <td>${detailpage.roomname}</td>
            </tr>
            <tr>
                <th scope="row">시설 타입</th>
                <td>${detailpage.typename}</td>
                <th scope="row">운영기간</th>
                <td>${detailpage.startdate}~${detailpage.enddate}</td>
            </tr>
            <tr>
                <th scope="row">상태</th>
                <td colspan="3">${detailpage.useyn}</td>
            </tr>
            <tr>
                <th scope="row">시설소개</th>
                <td colspan="3" style="max-width: 100%; word-break:break-all;">${detailpage.intro}</td>
            </tr>
            <tr>
                <th scope="row">이용시간</th>
                <td>${detailpage.usetime} 시간</td>
				<th scope="row">정원</th>
                <td>${detailpage.seatcount}</td>                
            </tr>
            <tr>
                <th>예약자격</th>
                <td>${detailpage.role}</td>
                <th>예약자격 부가설명</th>
                <td>${detailpage.rolenote}</td>
            </tr>
            <tr>
            	<th scope="row">부대시설</th>
                <td colspan="3" style="max-width:100%; word-break:break-all;">${detailpage.facility}</td>
            </tr>
            <tr>
                <th scope="row">섬네일</th>
                <td colspan="3">
                	<c:forEach var="item" items="${detailfile}" varStatus="status">
                        <div>
                            <img src="/manager/trainingFee/proof/imageView.do?filefullurl=${item.filefullurl }&storefilename=${item.storefilename }" width="400px;" style="max-height:148px;max-width: 228px;">
                        </div>
                        <div>
                            ${item.realfilename}
                            <br>
                             ${item.altdesc}
                        </div>
                    </c:forEach>
                </td>
            </tr>
            <tr>
                <th scope="row">검색용 키워드</th>
                <td colspan="3">${detailpage.keyword}</td>
            </tr>
        </table>
        <br>
        <!-- grid -->
        <div class="contents_title clear">
            <h2 class="fl">．날짜/세션 정보</h2>
        </div>
        <div id="AXGridDate">
            <div id="AXGridDate_${param.frmId}"></div>
        </div>
        <!-- grid -->
        <div class="contents_title clear">
            <h2 class="fl">．우선운영요일/휴무지정</h2>
        </div>
        <div id="AXGridFirst">
            <div id="AXGridFirst_${param.frmId}"></div>
        </div>

        <div class="contents_title clear" style="font-size: 20px;">
            <h2 class="fl"> 예약 조건</h2>
        </div>
        <!-- grid -->
        <div class="contents_title clear">
            <h2 class="fl">．&nbsp;예약 자격/기간</h2>
        </div>
        <div id="AXGridTerm">
            <div id="AXGridTerm_${param.frmId}"></div>
        </div>
        <!-- grid -->
        <div class="contents_title clear">
            <h2 class="fl">．&nbsp;누적 예약 제한</h2>
        </div>
        <div id="AXGridDis">
            <div id="AXGridDis_${param.frmId}"></div>
        </div>
        <!-- grid -->
        <div class="contents_title clear">
            <h2 class="fl">．&nbsp;취소/패널티</h2>
        </div>
        <div id="AXGridCancel">
            <div id="AXGridCancel_${param.frmId}"></div>
        </div>

        <div id="cookList" style="display:none;">
            <div class="contents_title clear" style="font-size: 20px;">
                 <h2 class="fl"> 요리명장 우대 예약 조건(무료)</h2>
            </div>
            <!-- grid -->
            <div class="contents_title clear">
                <h2 class="fl">．&nbsp;예약 자격/기간</h2>
            </div>
            <div id="AXGridCookTerm">
                <div id="AXGridCookTerm_${param.frmId}"></div>
            </div>
            <!-- grid -->
            <div class="contents_title clear">
                <h2 class="fl">．&nbsp;누적 예약 제한</h2>
            </div>
            <div id="AXGridCookDis">
                <div id="AXGridCookDis_${param.frmId}"></div>
            </div>
            <!-- grid -->
            <div class="contents_title clear">
                <h2 class="fl">．&nbsp;취소/패널티</h2>
            </div>
            <div id="AXGridCookCancel">
                <div id="AXGridCookCancel_${param.frmId}"></div>
            </div>
        </div>

        <div class="contents_title clear" style="padding-top: 15px;height: 15px;">
            <div align="center">
                <a href="javascript:;" id="btnReturn" class="btn_gray">목록</a>
            </div>
        </div>
    </div>

<!-- Board List -->
</body>