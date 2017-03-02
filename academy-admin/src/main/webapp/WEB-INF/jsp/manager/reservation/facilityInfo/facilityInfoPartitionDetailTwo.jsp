<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    var g_params = {showTab:1};
    var htmlTime ="";
    var htmlTimeMM ="";
    var cookType = "${cookType.cookmastercode}";
    var checkType = "${listseq.checkType}";
    var checkCount = "${listseq.checkCount}";
    var typeName = "${facilityType.typename}";

    //Grid Init
    var adminGrid = new AXGrid(); // instance 상단그리드

    //Grid Default Param
    var defaultParam = {
        sortColKey: "Rsv.facilityInfo.detailTwoList"
        , sortIndex: 1
        , sortOrder:"DESC"
    };

    $(document).ready(function(){
        param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"};
        hode.init();
        list.init();  //요일저장
        layer.init(); //탭시작
        layer.setViewTab('W02');
        adminList.init(); //운영일 휴무일 지정 리스트
        adminList.doSearch();

        //숫자만 입력
        $(".isNum").keyup(function(){$(this).val( $(this).val().replace(/[^0-9]/g,"") );} );

        //월요일규칙 전체요일에 적용
        $("#allSave").click(function(){
            var result = confirm("현재 설정한 시간, 정상가 할인가가 나머지 요일에 모두 일괄 적용됩니다.진행하시겠습니까?");
            if( !checkTime() ) {
                return;
            }
            if(result) {
                list.doSave("week");
                return;
            }else{
                return;
            }
        });

        //목록이동
        $("#btnList").on("click",function(){
            var f = document.listForm;
            f.action = "/manager/reservation/facilityInfo/facilityInfoList.do";
            f.submit();
        });

        //이전단계로
        $("#btnBefore").on("click",function(){
            var param = {
                roomseq : $("#roomseq").val(),
                setweek : g_params.showTab
            };

            $.ajaxCall({
                url: "<c:url value="/manager/reservation/facilityInfo/facilityPartyCheck.do"/>"
                , data: param
                , success: function( data, textStatus, jqXHR){
                    if(data.err < 1){
                        alert(data.msg);
                    } else {
                        if( data.err =="1" ) {
                            var f = document.listForm;
                            f.action = "/manager/reservation/facilityInfo/facilityInfoDetailOne.do";
                            f.submit();
                        } else {
                            alert(data.msg);
                        }
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
                    var mag = '<spring:message code="errors.load"/>';
                    alert(mag);
                }
            });
        });

        //다음단계로
        $("#btnNext").on("click",function(){
            var param = {
                roomseq : $("#roomseq").val(),
                setweek : g_params.showTab
            };

            $.ajaxCall({
                url: "<c:url value="/manager/reservation/facilityInfo/facilityPartyCheck.do"/>"
                , data: param
                , success: function( data, textStatus, jqXHR){
                    if(data.err < 1){
                        alert(data.msg);
                    } else {
                        if( data.err =="1" ) {
                            var f = document.listForm;
                            f.action = "/manager/reservation/facilityInfo/facilityInfoDetailThree.do";
                            f.submit();
                        } else {
                            alert(data.msg);
                        }
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
                    var mag = '<spring:message code="errors.load"/>';
                    alert(mag);
                }
            });
        });

        //우선운영요일/휴무지정 일정추가
        $("#btnAddSchedule").on("click",function(){
            var param = {
                  roomseq : $("#roomseq").val()
                , sTypeseq : $("#sTypeseq").val()
                , frmId  : $("[name='frmId']").val()
                , roomMode : $("#roomMode").val()
                , checkType : $("#checkType").val()
                , checkCount : $("#checkCount").val()
                , typeName : $("#typeName").val()
                , partCheck : $("#partCheck").val()
            };

            var popParam = {
                url : "<c:url value="/manager/reservation/facilityInfo/facilityInfoDetailTwoPop.do" />"
                ,modalID:"modalDiv01"
                , width : "1150"
                , height : "650"
                , params : param
                , targetId : "searchPopup"
            }
            window.parent.openManageLayerPopup(popParam);
        });

        // 하단저장
        $("#roomSave").on("click", function (){
            // 저장전 Validation
            if(!confirm("저장하시겠습니까?")){
                return;
            }

            var param = {
                roomseq : $("#roomseq").val(),
                setweek : g_params.showTab
            };

            $.ajaxCall({
                url: "<c:url value="/manager/reservation/facilityInfo/facilityPartyCheck.do"/>"
                , data: param
                , success: function( data, textStatus, jqXHR){
                    if(data.err < 1){
                        alert(data.msg);
                    } else {
                        if( data.err =="1" ) {
                            var f = document.listForm;
                            f.action = "/manager/reservation/facilityInfo/facilityInfoDetailThree.do";
                            f.submit();
                        } else {
                            alert(data.msg);
                        }
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
                    var mag = '<spring:message code="errors.load"/>';
                    alert(mag);
                }
            });
        });

        //세션추가
        $("#btnAdd").on("click",function(){
            var inner = "";
            var tlength = $("[name='addtr']").length;
            var num = "";

            inner =  '<tr name="addtr">';
            inner += '<input type="hidden" name="hiddenseq[]" value="">';
            inner += '  <td style="text-align: center;">세션</td>';
            inner += '  <td style="text-align: center;">';
            inner += '      <select style="min-width:50px;" name="stHour[]">';
            inner += '          <option value="">선택</option>';
            for (var i = 0; i <= 24; i++) {
                var value = "";
                if (i < 10) {
                    value = "0" + i;
                } else {
                    value = i;
                }
                inner += '     <option value="' + value + '">' + value + '</option>';
            }
            inner += '      </select> 시';
            inner += '      <select style="min-width:50px;" name="stMin[]">';
            inner += '          <option value="">선택</option>';
            for (var i = 0; i < 60; i++) {
                var value = "";
                if (i < 10) {
                    value = "0" + i;
                } else {
                    value = i;
                }
                inner += '     <option value="' + value + '">' + value + '</option>';
            }
            inner += '      </select> 분 ~';
            inner += '      <select style="min-width:50px;" name="endHour[]">';
            inner += '          <option value="">선택</option>';
            for (var i = 0; i <= 24; i++) {
                var value = "";
                if (i < 10) {
                    value = "0" + i;
                } else {
                    value = i;
                }
                inner += '     <option value="' + value + '">' + value + '</option>';
            }
            inner += '      </select> 시';
            inner += '      <select style="min-width:50px;" name="endMin[]">';
            inner += '          <option value="">선택</option>';
            for (var i = 0; i < 60; i++) {
                var value = "";
                if (i < 10) {
                    value = "0" + i;
                } else {
                    value = i;
                }
                inner += '     <option value="' + value + '">' + value + '</option>';
            }
            inner += '      </select> 분';
            inner += '  </td>';
            inner += '  <td>';
            inner += '      정상가 <input type="text" class="AXInput isNum" name="noNo[]" value="0" style="width:50px;IME-MODE:disabled;" maxlength="4" onkeydown="return showKeyCode(event)"  /> 만원<br/>';
            inner += '      할인가 <input type="text" class="AXInput isNum" name="noSale[]" value="0" style="width:50px;IME-MODE:disabled;" maxlength="4" onkeydown="return showKeyCode(event)" /> 만원 *할인가가 없을경우0으로 입력해 주십시오. ';
            inner += '  </td>';
            inner += '    <td style="text-align: center;"><a href="javascript:;" name="delStaff" class="btn_green" >세션삭제</a></td>';
            inner += '</tr>';

            $('#tblSearch').append(inner);
        });

        //세션삭제
        $("#btnRemoven").on("click",function(){
            var len = $("#tblSearch tr").length;
            if(len < 1){
                alert("삭제할수 없습니다.")
                return;
            }else {
                $("#tblSearch tr:last").remove();
            }
        });

        $(document).on("click","a[name=delStaff]",function(){

            var trHtml = $(this).parent().parent();

            trHtml.remove(); //tr 테그 삭제

        });

        for (var i = 0; i <= 24; i++) {
            var value = "";
            if (i < 10) {
                value = "0" + i;
            } else {
                value = i;
            }
            htmlTime += '     <option value="' + value + '">' + value + '</option>';
        }

        for (var i = 0; i < 60; i++) {
            var value = "";
            if (i < 10) {
                value = "0" + i;
            } else {
                value = i;
            }
            htmlTimeMM += '     <option value="' + value + '">' + value + '</option>';
        }
    });

    /* 숫자만 입력받기 */
    function showKeyCode(event) {
        event = event || window.event;
        var keyID = (event.which) ? event.which : event.keyCode;
        if( ( keyID >=48 && keyID <= 57 ) || ( keyID >=96 && keyID <= 105 ) || keyID == 8 || keyID == 9 || keyID == 37 || keyID == 39 || keyID == 46 ) {
            return;
        } else if(keyID == 190) {
            alert("소수점은 입력 불가합니다.");
            return false;
        } else {
            return false;
        }
    }

    var hode = {
        init : function() {
            var head = "";

            head += '<tr>';
            head += '    <th scope="row" style="text-align: center;height: 30px;">세션</th>';
            head += '    <th scope="row" style="text-align: center;">시간선택</th>';
            head += '    <th scope="row" style="text-align: center;">가격(교육장)</th>';
            head += '    <th scope="row" style="text-align: center;">세션삭제</th>';
            head += '</tr>';

            $('#tblHead').append(head);
        }
    }

    var layer = {
        init : function(){
            // 상단 탭
            $("#divConditionTab").bindTab({
                theme : "AXTabs"
                , overflow :"visible"
                , value: "W02"
                , options:[
                    {optionValue:"W02", optionText:"월", tabId:"W02"}
                    , {optionValue:"W03", optionText:"화", tabId:"W03"}
                    , {optionValue:"W04", optionText:"수", tabId:"W04"}
                    , {optionValue:"W05", optionText:"목", tabId:"W05"}
                    , {optionValue:"W06", optionText:"금", tabId:"W06"}
                    , {optionValue:"W07", optionText:"토", tabId:"W07"}
                    , {optionValue:"W01", optionText:"일", tabId:"W01"}
                    , {optionValue:"W08", optionText:"마지막주일요일", tabId:"W08"}
                ]
                , onchange : function(selectedObject, value){
                    layer.setViewTab(value, selectedObject);
                }
            });
        }, setViewTab : function(value, selectedObject){
            g_params.showTab = value;

            if (g_params.showTab == "W02") {
                $("#allSave").show();
            } else if (g_params.showTab != "W02") {
                $("#allSave").hide();
            }
            $('#tblSearch').empty();

            layer.weekSearch(g_params.showTab);

        }, weekSearch : function (value){
            var param ={
                roomseq : $("#roomseq").val()
                , setweek : value
            }

            $.ajaxCall({
                url: "<c:url value="/manager/reservation/facilityInfo/facilityInfoSelectWeek.do"/>"
                , data: param
                , success: function( data, textStatus, jqXHR){
                    if(data.result < 1){
                        alert("처리도중 오류가 발생하였습니다.");
                        return;
                    } else {
                        var inner = "";
                        var data = data.listWeek;

                        if(data.length > 0) {
                            $('#tblSearch').empty();
                            for (var i = 0; i < data.length; i++) {
                                var index = i+1;
                                var num = i;
                                var lineNum = i+1;

                                inner = '<tr name="addtr">';
                                inner += '<input type="hidden" name="hiddenseq[]" value="'+data[i].rsvsessionseq+'">';
                                inner += '  <td style="text-align: center;">세션'+lineNum+'</td>';
                                inner += '  <td style="text-align: center;">';
                                inner += '      <select style="min-width:50px;" name="stHour[]">';
                                inner += '          <option value="">선택</option>';
                                for (var j = 0; j <= 24; j++) {
                                    var value = "";
                                    var selected = "";
                                    if (j < 10) {
                                        value = "0" + j;
                                    } else {
                                        value = j;
                                    }
                                    if(data[i].starthour == value){
                                        selected = 'selected="selected"';
                                    }else{
                                        selected = "";
                                    }
                                    inner += '<option value="' + value + '" '+ selected +'>' + value + '</option>';
                                }
                                inner += '      </select> 시';
                                inner += '      <select style="min-width:50px;" name="stMin[]">';
                                inner += '          <option value="">선택</option>';
                                for (var m = 0; m < 60; m++) {
                                    var value = "";
                                    var selected = "";
                                    if (m < 10) {
                                        value = "0" + m;
                                    } else {
                                        value = m;
                                    }
                                    if(data[i].startmin == value){
                                        selected = 'selected="selected"';
                                    }else{
                                        selected = "";
                                    }
                                    inner += '     <option value="' + value + '" '+ selected +'>' + value + '</option>';
                                }
                                inner += '      </select> 분 ~';
                                inner += '      <select style="min-width:50px;" name="endHour[]">';
                                inner += '          <option value="">선택</option>';
                                for (var k = 0; k <= 24; k++) {
                                    var value = "";
                                    var selected = "";
                                    if (k < 10) {
                                        value = "0" + k;
                                    } else {
                                        value = k;
                                    }
                                    if(data[i].endhour == value){
                                        selected = 'selected="selected"';
                                    }else{
                                        selected = "";
                                    }
                                    inner += '     <option value="' + value + '" '+ selected +'>' + value + '</option>';
                                }
                                inner += '      </select> 시';
                                inner += '      <select style="min-width:50px;" name="endMin[]">';
                                inner += '          <option value="">선택</option>';
                                for (var n = 0; n < 60; n++) {
                                    var value = "";
                                    var selected = "";
                                    if (n < 10) {
                                        value = "0" + n;
                                    } else {
                                        value = n;
                                    }
                                    if(data[i].endmin == value){
                                        selected = 'selected="selected"';
                                    }else{
                                        selected = "";
                                    }
                                    inner += '     <option value="' + value + '" '+ selected +'>' + value + '</option>';
                                }
                                inner += '      </select> 분';
                                inner += '  </td>';
                                inner += '  <td>';
                                inner += '      정상가 <input type="text" class="AXInput" name="noNo[]" style="width:50px;IME-MODE:disabled;" maxlength="4" onkeydown="return showKeyCode(event)"   value="' + data[i].price / 10000 + '"/> 만원<br/>';
                                inner += '      할인가 <input type="text" class="AXInput" name="noSale[]" style="width:50px;IME-MODE:disabled;" maxlength="4" onkeydown="return showKeyCode(event)"   value="' + data[i].discountprice / 10000 + '"/> 만원 *할인가가 없을경우0으로 입력해 주십시오.';
                                inner += '  </td>';
                                inner += '    <td style="text-align: center;"><a href="javascript:;" name="delStaff" class="btn_green" >세션삭제</a></td>';
                                inner += '</tr>';

                                $('#tblSearch').append(inner);
                            }
                        }
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
					var mag = '<spring:message code="errors.load"/>';
					alert(mag);
                }
            });
        },
    }

    //요일저장
    var list = {
        init : function(){
            $("#weekSave").on("click", function (){
                // 저장전 Validation
                if(!confirm("저장하시겠습니까?")){
                    return;
                }
                if( !checkTime() ) {
                    return;
                }
                list.doCheck();
            });
        },
        //파티션룸으로 설정
        doCheck : function(){
            var param = {
                roomseq : $("#roomseq").val(),
                setweek : g_params.showTab
            };

            $.ajaxCall({
                url: "<c:url value="/manager/reservation/facilityInfo/facilitySessionPartitionCheck.do"/>"
                , data: param
                , success: function( data, textStatus, jqXHR){
                    if(data.err < 1){
                        alert(data.msg);
                    } else {
                        if( data.err =="1" ) {
                            list.doSave("day");
                        } else {
                            alert(data.msg);
                        }
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
                    var mag = '<spring:message code="errors.load"/>';
                    alert(mag);
                }
            });
        }
        // end Init
        , doSave : function(mode){
            var seqsession = $(".seqsession").val();

            var sUrl = "";
            if(mode == "day") {
                sUrl = "<c:url value="/manager/reservation/facilityInfo/facilityInfoInsert.do"/>";
            } else {
                sUrl = "<c:url value="/manager/reservation/facilityInfo/facilityInfoInsertAll.do"/>";
            }

            var hiddenseq = document.getElementsByName("hiddenseq[]");
            var stHour  = document.getElementsByName("stHour[]");
            var stMin   = document.getElementsByName("stMin[]");
            var endHour = document.getElementsByName("endHour[]");
            var endMin  = document.getElementsByName("endMin[]");
            var noNo = document.getElementsByName("noNo[]");
            var noSale = document.getElementsByName("noSale[]");
            var weekRow = "";
            var stTime = "";
            var endTime = "";
            var bChk = false;

            for(var i=0; i<stHour.length; i++){
            	if(isNull(stHour[i].value) || isNull(stMin[i].value) ) {
            		alert("세션["+(i+1)+"] 시작 시간(분)을 입력 해 주세요.");
            		bChk = true;
            		break;
            	}
            	
            	if(isNull(endHour[i].value) || isNull(endMin[i].value) ) {
            		alert("세션["+(i+1)+"] 종료 시간(분)을 입력 해 주세요.");
            		bChk = true;
            		break;
            	}
                
            	stTime = stHour[i].value + stMin[i].value;
                endTime = endHour[i].value +endMin[i].value;
                if (i == 0) {
                    weekRow = hiddenseq[i].value + "/" + stTime + "/" + endTime + "/" + isNvl(noNo[i].value, "0") + "/" + isNvl(noSale[i].value, "0") + "/" + 0 + "/" + 0;
                } else {
                    weekRow = weekRow + "," + hiddenseq[i].value + "/" + stTime + "/" + endTime + "/" + isNvl(noNo[i].value, "0") + "/" + isNvl(noSale[i].value, "0") + "/" + 0 + "/" + 0;
                }
            }
            if(bChk) return;
            
            // Param 셋팅(검색조건)
            var orderParam = {
                roomseq : $("#roomseq").val(),
                setweek : g_params.showTab,
                weekRow : weekRow,
                roomMode : $("#roomMode").val()
            };
            $.ajaxCall({
                url: sUrl
                , data: orderParam
                , success: function( data, textStatus, jqXHR){
                    if(data.result < 0){
    					var mag = '<spring:message code="errors.load"/>';
    					alert(mag);
                        //return;
                    } else {
                        list.doPatyCheck();

                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
					var mag = '<spring:message code="errors.load"/>';
					alert(mag);
                }
            });
        },
        //파티션룸으로 설정
        doPatyCheck : function(){
            var param = {
                roomseq : $("#roomseq").val(),
                setweek : g_params.showTab
            };

            $.ajaxCall({
                url: "<c:url value="/manager/reservation/facilityInfo/facilityPartyCheck.do"/>"
                , data: param
                , success: function( data, textStatus, jqXHR){
                    if(data.err < 1){
                        alert(data.msg);
                    } else {
                        if( data.err =="1" ) {
                            alert("등록하였습니다.");
                        } else {
                            alert(data.msg);
                        }
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
                    var mag = '<spring:message code="errors.load"/>';
                    alert(mag);
                }
            });
        }
    }

    //운영일 휴무일 지정
    var adminList = {
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
                , {key:"detail", addclass:idx++, label:"상세보기", width:"60", align:"center", sort:false, formatter: function(){
                    if(this.item.worktypecode=="S01"){
                        return "<a href=\"javascript:;\" class='btn_green' onclick=\"gridEvent.nameClick('" + this.item.setdate + "')\">보기</a>";
                    }else if(this.item.worktypecode=="S02"){
                        return "-";
                    }
                }}
                , {key:"del", addclass:idx++, label:"삭제", width:"60", align:"center", sort:false, formatter: function(){
                    return "<a href=\"javascript:;\" class='btn_green' onclick=\"delList.early('" + this.item.setdate + "')\">삭제</a>";
                }}
            ]

            var gridParam = {
                colGroup : _colGroup
                , fitToWidth: true
                , targetID : "AXGridTarget_${param.frmId}"
                , height : "320px"
            }

            fnGrid.nonPageGrid(adminGrid, gridParam);
        }, doSearch : function(param) {
            // Param 셋팅(검색조건)
            var initParam = {
                roomseq : $("#roomseq").val()
            };

            $.extend(defaultParam, param);
            $.extend(defaultParam, initParam);

            $.ajaxCall({
                url: "<c:url value="/manager/reservation/facilityInfo/facilityInfoDetailTwoListAjax.do"/>"
                , data: defaultParam
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
                adminGrid.setData(gridData);
            }
        }
    }

    //삭제
    var delList = {
        early:function(setdate){

            if(!confirm("삭제하시겠습니까?")){
                return;
            }

            var sUrl = "";
            sUrl = "<c:url value="/manager/reservation/facilityInfo/facilityInfoEarlyDel.do"/>";

            var param = {
                roomseq : $("#roomseq").val(),
                setdate :setdate
            }

            $.ajaxCall({
                url: sUrl
                , data: param
                , success: function( data, textStatus, jqXHR){
                    if(data.result < 1){
    					var mag = '<spring:message code="errors.load"/>';
    					alert(mag);
                    } else {
                        alert("삭제 하였습니다.");
                        adminList.doSearch(); //우선운영요일/휴무지정 리스트
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
					var mag = '<spring:message code="errors.load"/>';
					alert(mag);
                }
            });
        }//end init
    }

    //미리보기
    var gridEvent = {
        nameClick: function (setdate) {

            var param = {
                  setdate : setdate
                , roomseq : $("#roomseq").val()
                , checkCount : $("#checkCount").val()
                , typeName : $("#typeName").val()
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

    function checkTime() {
        var stHour  = document.getElementsByName("stHour[]");
        var stMin   = document.getElementsByName("stMin[]");
        var endHour = document.getElementsByName("endHour[]");
        var endMin  = document.getElementsByName("endMin[]");

        var stTime = "";
        var endTime = "";
        var stTimeClon = "";
        var endTimeClon = "";

        for(var i=0; i<stHour.length; i++) {
            stTime = stHour[i].value + stMin[i].value;
            endTime = endHour[i].value + endMin[i].value;

            if(stTime >= endTime){
                alert("잘못된 시간 설정입니다.");
                return false;
            }

            for(var j=0; j<stHour.length; j++) {
                stTimeClon = stHour[j].value + stMin[j].value;
                endTimeClon = endHour[j].value + endMin[j].value;

                if(i != j) {
                    if (stTime < stTimeClon && endTime > stTimeClon) {
                        alert("잘못된 시간 설정입니다.");
                        return false;
                    }
                    if (stTime > stTimeClon && endTime < endTimeClon) {
                        alert("잘못된 시간 설정입니다.");
                        return false;
                    }
                    if (stTime < endTimeClon && endTime > endTimeClon) {
                        alert("잘못된 시간 설정입니다.");
                        return false;
                    }
                }
            }
        }

        return true;
    }

</script>
</head>

<body class="bgw">
<form:form id="listForm" name="listForm" method="post">
    <input type="hidden" id="roomseq" name="roomseq" value="${listseq.roomseq}"/>
    <input type="hidden" id="sTypeseq" name="sTypeseq" value="${listseq.sTypeseq}"/>
    <input type="hidden" id="roomMode" name="roomMode" value="${listseq.roomMode}"/>
    <input type="hidden" id ="checkType" name="checkType" value="${listseq.checkType}"/>
    <input type="hidden" name="cookType" value="${listseq.typesearch}"/>
    <input type="hidden" id="checkCount" name="checkCount" value="${listseq.checkCount}"/>
    <input type="hidden" id="typeName" name="typeName" value="${facilityType.typename}"/>
    <input type="hidden" name="frmId" value="${param.frmId}"/>
    <input type="hidden" name="menuAuth" id="menuAuth" value="${param.menuAuth}"/>
    <input type="hidden" id="partCheck" name="partCheck" value="${listseq.partCheck}"/>
</form:form>
<div id="popwrap">
    <!--pop_title //-->
    <div class="contents_title clear">
        <h2 class="fl">파티션시설 정보 상세</h2>
    </div>
    <div id="crumbs">
        <ul>
            <li><a href="#1">1. 기본정보</a></li>
            <li><a href="#2" class="on">2.날짜/세션정보</a></li>
            <li><a href="#3">3.예약조건</a></li>
        </ul>
    </div>
    <!--// pop_title -->

    <!-- Contents -->
    <div id="popcontainer"  style="height:800px">
        <div id="popcontent">
            <!-- Sub Title -->

            <div id="divConditionTab"></div>

            <!--// Sub Title -->
            <div id="tabLayer">
                <div id="divTabPage1" class="tabView">
                    <div class="contents_title clear" style="font-size: 15px;height: 15px;line-height: 3;">
                        <div class="fl">
                            부가세 제외 10,000원 단위 이하는 절사하여 등록하세요.
                        </div>
                        <div class="fr">
                            <a href="javascript:;" id="btnAdd" class="btn_green">세션추가</a>
                            <%--<a href="javascript:;" id="btnRemoven" class="btn_green">세션삭제</a>--%>
                        </div>
                    </div>
                    <div class="tbl_write">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="stable">
                            <thead id="tblHead">
                            </thead>
                            <tbody id="tblSearch">
                            </tbody>
                        </table>
                        <div style="text-align: right;">
                            요일별 세션, 가격 정보 수정시 특정 요일 변경 내용을 저장한 후 다른 요일 수정해주셔야 적용 됩니다. (미저장 후 다른요일 수정시 미적용 됨)
                            <br>
                            <%--<a href="javascript:;" id="allSave" class="btn_green">월요일 규칙을 전체요일에 적용</a>--%>
                            <a href="javascript:;" id="weekSave" class="btn_green">저장</a>
                        </div>
                    </div>

                </div>
            </div>
            <div class="contents_title clear" style="font-size: 15px;height: 15px;line-height: 2;">
                <div class="fl">
                    우선운영요일/휴무지정
                </div>
                <div class="fr">
                    <a href="javascript:;" class="btn_green" id="btnAddSchedule">일정추가</a>
                </div>
            </div>
            <br>
            <div id="AXGrid">
                <div id="AXGridTarget_${param.frmId}"></div>
            </div>
            <br>
            <div class="contents_title clear" style="padding-top: 15px;height: 15px;">
                <div class="fr">
                    <a href="javascript:;" id="roomSave" class="btn_green">저장</a>
                </div>
                <div align="center">
                    <a href="javascript:;" id="btnList" class="btn_gray">목록</a>
                    <c:if test="${listseq.roomMode eq 'U'}">
                        <a href="javascript:;" id="btnBefore" class="btn_gray">이전 단계로</a>
                        <a href="javascript:;" id="btnNext" class="btn_gray">다음 단계로</a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>
<!--// Edu Part Cd Info -->
</body>