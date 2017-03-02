<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
<style type="text/css">
	#crumbs {text-align: center;}
	#crumbs ul {list-style: none;display: inline-table;}
	#crumbs ul li {display: inline;}
	#crumbs ul li a {display: block;float: left;height: 20px;background: #3498db;text-align: center;padding: 10px 20px 10px 50px;position: relative;margin: 0 1px 0 0; font-size: 20px;text-decoration: none;color: #fff;}
	#crumbs ul li a:after {content: "";  border-top: 20px solid transparent;border-bottom: 20px solid transparent;border-left: 20px solid #3498db;position: absolute; right: -20px; top: 0;z-index: 1;}
	#crumbs ul li a:before {content: "";  border-top: 20px solid transparent;border-bottom: 20px solid transparent;border-left: 20px solid #d4f2ff;position: absolute; left: 0; top: 0;}
	#crumbs ul li:first-child a {border-top-left-radius: 0px; border-bottom-left-radius: 0px;}
	#crumbs ul li:first-child a:before {display: none; }
	#crumbs ul li:last-child a {padding-right: 80px;border-top-right-radius: 0px; border-bottom-right-radius: 0px;}
	#crumbs ul li:last-child a:after {display: none; }
	#crumbs ul li a:hover, #crumbs ul li a.on {background: #fa5ba5;}
	#crumbs ul li a:hover:after, #crumbs ul li a.on:after {border-left-color: #fa5ba5;}
</style>
<script type="text/javascript">

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
    var cookType = "${cookType.cookmastercode}";

    $(document.body).ready(function() {
        param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"};
        if("C01" == cookType) {
            $("#cookList").show();
        }

        /*리스트셋팅*/
        termList.init();//예약자격/기간 리스트
        disList.init(); //누적예약제한
        cancelList.init();//취소/패널티

        if("C01" == cookType) {
            cookTermList.init();//요리명장 우대 예약조건 예약자격/기간 리스트
            cookDisList.init();//요리명장 우대 예약조건 누적예약제한
            cookCancelList.init();//요리명장 우대 예약조건 취소/패널티
        }


        //목록이동
        $("#btnReturn").on("click",function(){
            var f = document.listForm;
            f.action = "/manager/reservation/facilityInfo/facilityInfoList.do";
            f.submit();
        });

        //하단저장이동
        $("#btnSave").on("click",function(){
            // 저장전 Validation
            if(!confirm("저장하시겠습니까?")){
                return;
            }
            var f = document.listForm;
            f.action = "/manager/reservation/facilityInfo/facilityInfoList.do";
            f.submit();
        });

        //이전단계로
        $("#btnBefore").on("click",function(){
            var f = document.listForm;
            if($("#partCheck").val() == "1") {
                f.action = "/manager/reservation/facilityInfo/facilityInfoPartitionDetailTwo.do";
            } else {
                f.action = "/manager/reservation/facilityInfo/facilityInfoDetailTwo.do";
            }
            f.submit();
        });

        //예약조건추가 팝업호출시
        $(".termpop").on("click",function(){
            var param = {
                roomseq :$("#roomseq").val()
                , cookType : "N"
                , frmId  : $("[name='frmId']").val()
            };

            var popParam = {
                url : "<c:url value="/manager/reservation/facilityInfo/facilityInfoDetailThreeTermPop.do" />"
                ,modalID:"modalDiv01"
                , width : "800"
                , height : "900"
                , params : param
                , targetId : "searchPopup"
            }
            window.parent.openManageLayerPopup(popParam);
        });

        //예약조건추가 팝업호출시 - 요리명장용
        $(".cooktermpop").on("click",function(){
            var param = {
                roomseq :$("#roomseq").val()
                , cookType : "Y"
                , frmId  : $("[name='frmId']").val()
            };

            var popParam = {
                url : "<c:url value="/manager/reservation/facilityInfo/facilityInfoDetailThreeTermPop.do" />"
                ,modalID:"modalDiv01"
                , width : "800"
                , height : "900"
                , params : param
                , targetId : "searchPopup"
            }
            window.parent.openManageLayerPopup(popParam);
        });



        //누적예약제한추가 팝업호출시
        $(".dispop").on("click",function(){

            var checklist = disGrid.getList();

            var param = {
               roomseq : $("#roomseq").val()
                , sTypeseq : $("#sTypeseq").val()
                , cookType : "N"
                , frmId  : $("[name='frmId']").val()
                , disLength : checklist.length
            };

            var popParam = {
                url : "<c:url value="/manager/reservation/facilityInfo/facilityInfoDetailThreeDisPop.do" />"
                ,modalID:"modalDiv01"
                , width : "1000"
                , height : "600"
                , params : param
                , targetId : "searchPopup"
            }
            window.parent.openManageLayerPopup(popParam);
        });

        //누적예약제한 - 요리명장
        $(".discookpop").on("click",function(){

            var checklist = cookDisGrid.getList();

            var param = {
                roomseq : $("#roomseq").val()
                , sTypeseq : $("#sTypeseq").val()
                , cookType : "Y"
                , frmId  : $("[name='frmId']").val()
                , disLength : checklist.length
            };

            var popParam = {
                url : "<c:url value="/manager/reservation/facilityInfo/facilityInfoDetailThreeDisPop.do" />"
                ,modalID:"modalDiv01"
                , width : "1000"
                , height : "600"
                , params : param
                , targetId : "searchPopup"
            }
            window.parent.openManageLayerPopup(popParam);
        });

        //취소/패널티 팝업호출시
        $(".cancelpop").on("click",function(){
            var param = {
                roomseq : $("#roomseq").val()
                , cookType: "N"
                , frmId  : $("[name='frmId']").val()
            };

            var popParam = {
                url : "<c:url value="/manager/reservation/facilityInfo/facilityInfoDetailThreeCancelPop.do" />"
                ,modalID:"modalDiv01"
                , width : "1000"
                , height : "600"
                , params : param
                , targetId : "searchPopup"
            }
            window.parent.openManageLayerPopup(popParam);
        });

        //취소/패널티 - 요리명장
        $(".cancelcookpop").on("click",function(){
            var param = {
                roomseq : $("#roomseq").val()
                , frmId  : $("[name='frmId']").val()
                , cookType : "Y"
            };

            var popParam = {
                url : "<c:url value="/manager/reservation/facilityInfo/facilityInfoDetailThreeCancelPop.do" />"
                ,modalID:"modalDiv01"
                , width : "1000"
                , height : "600"
                , params : param
                , targetId : "searchPopup"
            }
            window.parent.openManageLayerPopup(popParam);
        });
    });

    var gridEvent = {
    		delClick : function(rsvroleseq,applysessiontypecode) {
    			var params = {
    					rsvroleseq : rsvroleseq
                       ,applysessiontypecode: applysessiontypecode
    			};
    				// 모든 세션 applysessiontypecode P1 pintreatrange, citytreatcode, agetreatcode 필요
    				// 특정 세션 applysessiontypecode P2 rsvroleseq 필요
    			if(!confirm("삭제 하시 겠습니까?")) return;
    				
    			$.ajaxCall({
                    url: "<c:url value="/manager/reservation/facilityInfo/facilityInfoPartitionDetailDelete.do"/>"
                    , data: params
                    , success: function( data, textStatus, jqXHR){
                        if(data.result < 1){
        					var mag = '<spring:message code="errors.load"/>';
        					alert(mag);
                            //return;
                        } else {
                            termList.doSearch();
                            alert("삭제 완료 되었습니다.");
                        }
                    },
                    error: function( jqXHR, textStatus, errorThrown) {
    					var mag = '<spring:message code="errors.load"/>';
    					alert(mag);
                    }
                });
    			
    		},
        cookDelClick : function(rsvroleseq,applysessiontypecode) {
            var params = {
                rsvroleseq : rsvroleseq
               ,applysessiontypecode : applysessiontypecode
            };
            // 모든 세션 applysessiontypecode P1 pintreatrange, citytreatcode, agetreatcode 필요
            // 특정 세션 applysessiontypecode P2 rsvroleseq 필요
            if(!confirm("삭제 하시 겠습니까?")) return;

            $.ajaxCall({
                url: "<c:url value="/manager/reservation/facilityInfo/facilityInfoPartitionDetailDelete.do"/>"
                , data: params
                , success: function( data, textStatus, jqXHR){
                    if(data.result < 1){
    					var mag = '<spring:message code="errors.load"/>';
    					alert(mag);
                        //return;
                    } else {
                        cookTermList.doSearch();
                        alert("삭제 완료 되었습니다.");
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
					var mag = '<spring:message code="errors.load"/>';
					alert(mag);
                }
            });

        },
    		disDelClick : function(settingseq, roomseq, typeseq, cookType) {
    			var params = {
    					settingseq : settingseq,
    					roomseq : roomseq,
    					typeseq : typeseq,
    					cookType:cookType
    			};
    				// 모든 세션 applysessiontypecode P1 pintreatrange, citytreatcode, agetreatcode 필요
    				// 특정 세션 applysessiontypecode P2 rsvroleseq 필요
    			if(!confirm("삭제 하시 겠습니까?")) return;
    				
    			$.ajaxCall({
                    url: "<c:url value="/manager/reservation/facilityInfo/disListDelete.do"/>"
                    , data: params
                    , success: function( data, textStatus, jqXHR){
                        if(data.result < 1){
        					var mag = '<spring:message code="errors.load"/>';
        					alert(mag);
                            //return;
                        } else {
                            doReturn("disList");
                            alert("삭제 완료 되었습니다.");
                        }
                    },
                    error: function( jqXHR, textStatus, errorThrown) {
    					var mag = '<spring:message code="errors.load"/>';
    					alert(mag);
                    }
                });
    		},
        cookDisDelClick : function(settingseq, roomseq, typeseq, cookType) {
            var params = {
                settingseq : settingseq,
                roomseq : roomseq,
                typeseq : typeseq,
                cookType:cookType
            };
            // 모든 세션 applysessiontypecode P1 pintreatrange, citytreatcode, agetreatcode 필요
            // 특정 세션 applysessiontypecode P2 rsvroleseq 필요
            if(!confirm("삭제 하시 겠습니까?")) return;

            $.ajaxCall({
                url: "<c:url value="/manager/reservation/facilityInfo/disListDelete.do"/>"
                , data: params
                , success: function( data, textStatus, jqXHR){
                    if(data.result < 1){
    					var mag = '<spring:message code="errors.load"/>';
    					alert(mag);
                        //return;
                    } else {
                        cookDisList.doSearch();
                        alert("삭제 완료 되었습니다.");
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
					var mag = '<spring:message code="errors.load"/>';
					alert(mag);
                }
            });
        },
        cancelDelClick : function(penaltyseq,roomseq, cookType) {
    			var params = {
    					penaltyseq : penaltyseq,
    					roomseq : roomseq,
    					cookType:cookType
    			};
    				// 모든 세션 applysessiontypecode P1 pintreatrange, citytreatcode, agetreatcode 필요
    				// 특정 세션 applysessiontypecode P2 rsvroleseq 필요
    			if(!confirm("삭제 하시 겠습니까?")) return;
    				
    			$.ajaxCall({
                    url: "<c:url value="/manager/reservation/facilityInfo/cancelListDelete.do"/>"
                    , data: params
                    , success: function( data, textStatus, jqXHR){
                        if(data.result < 1){
        					var mag = '<spring:message code="errors.load"/>';
        					alert(mag);
                            //return;
                        } else {
                            doReturn("cancelList");
                            alert("삭제 완료 되었습니다.");
                        }
                    },
                    error: function( jqXHR, textStatus, errorThrown) {
    					var mag = '<spring:message code="errors.load"/>';
    					alert(mag);
                    }
                });
    		},
        cookCancelDelClick : function(penaltyseq,roomseq, cookType) {
            var params = {
                penaltyseq : penaltyseq,
                roomseq : roomseq,
                cookType:cookType
            };
            // 모든 세션 applysessiontypecode P1 pintreatrange, citytreatcode, agetreatcode 필요
            // 특정 세션 applysessiontypecode P2 rsvroleseq 필요
            if(!confirm("삭제 하시 겠습니까?")) return;

            $.ajaxCall({
                url: "<c:url value="/manager/reservation/facilityInfo/cancelListDelete.do"/>"
                , data: params
                , success: function( data, textStatus, jqXHR){
                    if(data.result < 1){
    					var mag = '<spring:message code="errors.load"/>';
    					alert(mag);
                        //return;
                    } else {
                        cookCancelList.doSearch();
                       alert("삭제 완료 되었습니다.");
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
					var mag = '<spring:message code="errors.load"/>';
					alert(mag);
                }
            });
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
                , {key:"del", label:"삭제", width:"60", align:"center", sort:false, formatter: function(){
                     return "<a href=\"javascript:;\" class='btn_green' onclick=\"gridEvent.delClick('" + this.item.rsvroleseq + "','"+this.item.applysessiontypecode+"','N')\">삭제</a>";
                }}
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
                roomseq : $("#roomseq").val(),
                cookType: "N"
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
                , {key:"del", label:"삭제", width:"100", align:"center", sort:false, formatter: function () {
                    return "<a href=\"javascript:;\" class=\"btn_green\" onclick=\"gridEvent.disDelClick('" + this.item.settingseq  + "','" + this.item.roomseq  + "','" + this.item.typeseq  + "','N')\">삭제</a>";
                }}
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
                ,cookType: "N"
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
                , {key:"modifydate", label:"삭제", width:"100", align:"center", sort:false, formatter: function () {
                    return "<a href=\"javascript:;\" class=\"btn_green\" onclick=\"gridEvent.cancelDelClick('" + this.item.penaltyseq  + "','" + this.item.roomseq  + "','N')\">삭제</a>";
                }}
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

    if("C01" == cookType) {
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
                    , {key:"del", label:"삭제", width:"60", align:"center", sort:false, formatter: function(){
                    	return "<a href=\"javascript:;\" class='btn_green' onclick=\"gridEvent.cookDelClick('" + this.item.rsvroleseq + "','"+this.item.applysessiontypecode+"')\">삭제</a>";
                    }}
                ]
                var gridParam = {
                    colGroup : _colGroup
                    , fitToWidth: true
                    , colHead : {
                        heights : [ 20, 20 ],rows :
                                [
                                    [
                                        {colSeq : 0, rowspan : 2, valign : "middle"},
                                        {colSeq : null,  colspan : 2,valign : "middle",label : "예약가능시간",align : "center"},
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
                    url: "<c:url value="/manager/reservation/facilityInfo/facilityInfoDetailThreeCookTermListAjax.do"/>"
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
                    , {key:"del", label:"삭제", width:"100", align:"center", sort:false, formatter: function () {
                    	return "<a href=\"javascript:;\" class=\"btn_green\" onclick=\"gridEvent.cookDisDelClick('" + this.item.settingseq  + "','" + this.item.roomseq  + "','" + this.item.typeseq  + "','Y')\">삭제</a>";
                    }}
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
                    , {key:"modifydate", label:"삭제", width:"100", align:"center", sort:false, formatter: function () {
                    	return "<a href=\"javascript:;\" class=\"btn_green\" onclick=\"gridEvent.cookCancelDelClick('" + this.item.penaltyseq  + "','" + this.item.roomseq  + "','Y')\">삭제</a>";
                    }}
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
    }

    function doReturn(funId) {
    	if(funId == "cookTermList") cookTermList.doSearch();    	
    	if(funId == "termList")     termList.doSearch();    	
    	if(funId == "cookDisList")  cookDisList.doSearch();    	
    	if(funId == "disList")      disList.doSearch();    	
    	if(funId == "cookCancelList") cookCancelList.doSearch();    	
    	if(funId == "cancelList")   cancelList.doSearch();    	
    }
</script>
</head>

<body class="bgw">
    <form:form id="listForm" name="listForm" method="post">
        <input type="hidden" id="roomseq" name="roomseq" value="${listseq.roomseq}"/>
        <input type="hidden" id="sTypeseq" name="sTypeseq" value="${listseq.sTypeseq}"/>
        <input type="hidden" id="roomMode" name="roomMode" value="${listseq.roomMode}"/>
        <input type="hidden" id="cookType"name="cookType" value="${cookType.cookmastercode}"/>
        <input type="hidden" name="frmId" value="${param.frmId}"/>
        <input type="hidden" name="menuAuth" id="menuAuth" value="${param.menuAuth}"/>
        <input type="hidden" name="partCheck" id="partCheck" value="${ptype.roomseq}"/>
    </form:form>
    <!--title //-->
    <div class="contents_title clear">
        <h2 class="fl">
            예약 조건
        </h2>
    </div>
    <div id="crumbs">
		<ul>
			<li><a href="#1">1. 기본정보</a></li>
			<li><a href="#2">2.날짜/세션정보</a></li>
			<li><a href="#3" class="on">3.예약조건</a></li>
		</ul>
	</div>
    <!--search table // -->
    <div style="overflow-y: scroll;height: 800px;">
        <div class="contents_title clear">
            <h2 class="fl">．&nbsp;예약 자격/기간</h2>
            <div class="fr">
                <a href="javascript:;" class="btn_green termpop">조건추가</a>
            </div>
        </div>
        <!-- grid -->
        <div id="AXGrid">
            <div id="AXGridTerm_${param.frmId}"></div>
        </div>
        <br>

        <div class="contents_title clear">
            <h2 class="fl">．&nbsp;누적 예약 제한</h2>
            <div class="fr">
                <a href="javascript:;" class="btn_green dispop">조건추가</a>
            </div>
        </div>
        <div id="AXGrid1">
            <div id="AXGridDis_${param.frmId}"></div>
        </div>
        <br>

        <div class="contents_title clear">
            <h2 class="fl">．&nbsp;취소/패널티</h2>
            <div class="fr">
                <a href="javascript:;" class="btn_green cancelpop">조건추가</a>
            </div>
        </div>
        <div id="AXGrid2">
            <div id="AXGridCancel_${param.frmId}"></div>
        </div>
        <br>

        <div id="cookList" style="display:none;">
            <div class="contents_title clear" style="font-size: 20px;">
                <h2 class="fl">．&nbsp;요리명장 우대 예약 조건(무료)</h2>
            </div>
            <div class="contents_title clear">
                <h2 class="fl">．&nbsp;요리명장 예약 자격/기간</h2>
                <div class="fr">
                    <a href="javascript:;" class="btn_green cooktermpop">조건추가</a>
                </div>
            </div>
            <div id="AXGrid3">
                <div id="AXGridCookTerm_${param.frmId}"></div>
            </div>
            <br>

            <div class="contents_title clear">
                <h2 class="fl">．&nbsp;요리명장 누적 예약 제한</h2>
                <div class="fr">
                    <a href="javascript:;" class="btn_green discookpop">조건추가</a>
                </div>
            </div>
            <div id="AXGrid4">
                <div id="AXGridCookDis_${param.frmId}"></div>
            </div>
            <br>

            <div class="contents_title clear">
                <h2 class="fl">．&nbsp;요리명장 취소/패널티</h2>
                <div class="fr">
                    <a href="javascript:;" class="btn_green cancelcookpop">조건추가</a>
                </div>
            </div>
            <div id="AXGrid5">
                <div id="AXGridCookCancel_${param.frmId}"></div>
            </div>
            <br>
        </div>

        <div class="contents_title clear" style="padding-top: 15px;height: 15px;">
            <div class="fr">
                <a href="javascript:;" id="btnSave" class="btn_green" style="vertical-align:middle; margin-left:0px;">저장</a>
            </div>
            <div style="text-align: center;">
                <a href="javascript:;" id="btnReturn" class="btn_gray">목록</a>
                <c:if test="${listseq.roomMode eq 'U'}">
                    <a href="javascript:;" id="btnBefore" class="btn_gray">이전 단계로</a>
                </c:if>
            </div>
        </div>
    </div>

<!-- Board List -->

</body>