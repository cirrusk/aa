<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>

<script type="text/javascript">
    var selectMode = {};
    var weekHtml = "";

    $(document).ready(function(){
        //저장
        $("#saveBtn").on("click", function (mode, item, idx){
            // 저장전 Validation
            // 예약자격
            if( $("[name='target']:checked").val()=="B02" ) {
                // 자격조건석택
                if( isNull($("#pintreatrange").val()) && isNull($("#citytreatcode").val()) && isNull($("#agetreatcode").val() ) ) {
                    alert("예약자격 조건은 하나 이상 선택 하셔야 합니다.");
                    return;
                }
            } else {
                if( isNull($("#special").val()) ) {
                    alert("특정대상자을(를) 선택 해 주세요.");
                    return;
                }
            }

            if( $("[name='period']:checked").val()=="P01" ) {
                if( isNull($("#startday").val()) ) {
                    alert("예약가능 시작일을(를) 선택 해 주세요.");
                    $("#startday").focus();
                    return;
                }
                if( isNull($("#endday").val()) ) {
                    alert("예약가능 종료일을(를) 선택 해 주세요.");
                    $("#endday").focus();
                    return;
                }
            } else {
                if( isNull($("#mstartday").val()) ) {
                    alert("예약가능 시작일을(를) 선택 해 주세요.");
                    $("#mstartday").focus();
                    return;
                }
                if( isNull($("#mendmonth").val()) ) {
                    alert("예약가능 종료일을(를) 선택 해 주세요.");
                    $("#mendmonth").focus();
                    return;
                }
                if( isNull($("#mendday").val()) ) {
                    alert("예약가능 종료일 해당월을(를)  선택 해 주세요.");
                    $("#mendday").focus();
                    return;
                }
            }

            if( $("[name='apply']:checked").val() == "P02" ) {
                var num = $("#selsession table tr").length;
                var weekRow = "";

                for(var i=0; i<num; i++){
                    var setweek       = $("#selsession table tr select[name='setweek']")[i];
                    var rsvsessionseq = $("#selsession table tr select[name='rsvsessionseq']")[i];

                    if( isNull(setweek.value) ) {
                        alert("["+(i+1)+"] 특정 적용 요일을 선택 해 주세요.");
                        return;
                    }
                    if( isNull(rsvsessionseq.value) ) {
                        alert("["+(i+1)+"] 특정 적용 세션을 선택 해 주세요.");
                        return;
                    }
                }
            }


            if(!confirm("저장하시겠습니까?")){
                return;
            }
            selectMode.mode = "I";
            pop.doSave(selectMode.mode);
        });

        $("#selsession").hide(); //특정세션 숨김.
        //------------셀렉트박스 월
        var html=[];
        var value = "";

        //월
        for(var i=1;i<=6;i++){
            value =i;
            html[i] = "<option value="+value+">"+value+"</option>";
        }
        $(".boxmonth").append(html.join(''));

        //------------셀렉트박스 일(월기준)
        for(var i=1;i<=31;i++){
            value = i;
            html[i] = "<option value="+value+">"+value+"</option>";
        }
        $(".mboxday").append(html.join(""));

        //--------------셀렉트박스 일(일기준) mendday
        for(var i=0;i<=100;i++){
            value = i;
            html[i] = "<option value="+value+">"+value+"</option>";
        }
        $(".boxday").append(html.join(""));


        $("#month").on("click",function(){
            $("#area2").show();
            $("#area1").hide();
        });

        $("#day").on("click",function(){
            $("#area2").hide();
            $("#area1").show();
        });

        $("#allsession").on("click",function(){
            $("#selsession").hide();
        });

        $("#session").on("click",function(){
            $("#selsession").show();
        });

        //예약자격선택 - 자격조건
        $("#cheNormal").on("click",function(){
            $("#rsvnormal").show();
            $("#rsvspecial").hide();
        });

        //예약자격선택 - 특정대상자선택
        $("#cheSpecial").on("click",function(){
            $("#rsvspecial").show();
            $("#rsvnormal").hide();
        });

        weekHtml = $("#setweek0").html();

        //행추가
        $("#hang").on("click",function(){
            var num = $("#selsession table tr").length;
            var html = "";

            html = html + "<tr id='row"+num+"'>";
            html = html + "<th scope='row'>요일</th>";
            html = html + "    <td><select style='min-width:80px;' id='setweek"+num+"' name='setweek' onchange='fnsetweek("+num+");'>";
            html = html + weekHtml;
            html = html + "    </select></td>";
            html = html + "    <th scope='row'>세션선택</th>";
            html = html + "    <td>";
            html = html + "        <select id='rsvsessionseq"+num+"' name='rsvsessionseq'>";
            html = html + "            <option value=''>선택</option>";
            html = html + "        </select>";
            html = html + "    </td>";
            html = html + "    <td>";
            html = html + "       <a href='javascript:;' class='btn_gray' onclick='fnrowdel("+num+")'>행삭제</a>";
            html = html + "    </td>";
            html = html + "</tr>";

            $("#selsession table").append(html);


        });


        // 요일선택
        $("#setweek").on("change",function(){
            if( this.value != "" ) {
                $.ajaxCall({
                    url: "<c:url value='/manager/reservation/programInfo/programInfoDetailSessionAjax.do'/>"
                    , data: {
                        expseq : $("#expseq").val()
                        , setweek : this.value
                    }
                    , success: function( data, textStatus, jqXHR){
                        if(data.result < 1){
                            alert("처리도중 오류가 발생하였습니다.");
                            return;
                        } else {
                            //요일 변경하기
                            if( data.dataList != null ) {
                                for(var i=0;i<data.dataList.length; i++) {
                                    $("#rsvsessionseq").append("<option value='"+ data.dataList[i].expsessionseq +"'>"+ data.dataList[i].sessionname +"</option>");
                                }
                            }
                        }
                    },
                    error: function( jqXHR, textStatus, errorThrown) {
        				var mag = '<spring:message code="errors.load"/>';
        				alert(mag);
                    }
                });
            }
        });
    });

    function fnrowdel(num) {
        $("#row"+num).remove();
    }

    function fnsetweek(num) {
        $.ajaxCall({
            url: "<c:url value='/manager/reservation/programInfo/programInfoDetailSessionAjax.do'/>"
            , data: {
                expseq : $("#expseq").val()
                , setweek : $("#setweek"+num).val()
            }
            , success: function( data, textStatus, jqXHR){
                if(data.result < 1){
                    alert("처리도중 오류가 발생하였습니다.");
                    return;
                } else {
                    //요일별 세션 불러오기
                    if( data.dataList != null ) {
                        var lHtml = "";
                        lHtml = lHtml + "            <option value=''>선택</option>";
                        for(var i=0;i<data.dataList.length; i++) {
                            lHtml = lHtml + "<option value='"+ data.dataList[i].expsessionseq +"'>"+ data.dataList[i].sessionname +"</option>";
                        }
                        $("#rsvsessionseq"+num).html(lHtml);
                    }
                }
            },
            error: function( jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
            }
        });
    }

    var pop = {
        doSave : function(mode, item, idx){
            if($(":input:radio[name='apply']:checked").val()=="P01"){
                // 모든세션
                var sUrl = "<c:url value="/manager/reservation/programInfo/programInfoAllSessionInsert.do"/>";
            } else {
                // 특정세션
                var sUrl = "<c:url value="/manager/reservation/programInfo/programInfoDetailTermInsert.do"/>";
            }

            var sMsg = "등록하였습니다.";

            var num = $("#selsession table tr").length;
            var weekRow = "";

            for(var i=0; i<num; i++){
                var rsvsessionseq = $("#selsession table tr select[name='rsvsessionseq']")[i];

                if(i == 0) {
                    weekRow = rsvsessionseq.value;
                } else {
                    weekRow = weekRow + "," + rsvsessionseq.value;
                }
            }

            var orderParam = {};
            var param = {
                weekRow : weekRow
            };

            var startday="";
            var endmonth="";
            var endday="";

            if( $(":input:radio[name='period']:checked").val()=="P01" ) {
                startday = $("#startday").val();
                endmonth = $("#endmonth").val();
                endday = $("#endday").val();
            } else {
                startday = $("#mstartday").val();
                endmonth = $("#mendmonth").val();
                endday = $("#mendday").val();
            }

            var masterParam = {
                targettypecode : $(":input:radio[name='target']:checked").val()
                , groupseq       : $("#special").val()
                , pintreatrange  : $("#pintreatrange").val()
                , citytreatcode  : $("#citytreatcode").val()
                , agetreatcode   : $("#agetreatcode").val()
                , periodtypecode : $(":input:radio[name='period']:checked").val()
                , startmonth     : "0"
                , startday       : startday
                , endmonth       : isNvl(endmonth,"")
                , endday         : endday
                , applysessiontypecode : $(":input:radio[name='apply']:checked").val()
                , expseq :$("#expseq").val()
            };

            $.extend(orderParam, param);
            $.extend(orderParam, masterParam);

            $.ajaxCall({
                url: sUrl
                , data: orderParam
                , success: function( data, textStatus, jqXHR){
                    if(data.result < 1){
        				var mag = '<spring:message code="errors.load"/>';
        				alert(mag);
                        //return;
                    } else {
                        alert("등록하였습니다");
                        eval($('#ifrm_main_'+$("input[name='frmId']").val()).get(0).contentWindow.termList.doSearch(param));
                        closeManageLayerPopup("searchPopup");
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
    				var mag = '<spring:message code="errors.load"/>';
    				alert(mag);
                }
            });
        }
    }

</script>
</head>
<div id="popwrap">
    <!--pop_title //-->
    <div class="title clear">
        <h2 class="fl">
            예약자격/기간 등록
        </h2>
        <span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
    </div>
    <!--// pop_title -->

    <!-- Contents -->
    <div id="popcontainer" style="height:270px">
        <form id="frmFile" name="fileform" method="post" enctype="multipart/form-data">
        <input type="hidden" id="expseq" value="${listtype.expseq}"/>
        <input type="hidden" name="frmId" value="${listtype.frmId}"/>
        <div id="popcontent">
            <!-- Sub Title -->
            <div class="poptitle clear">
                <h3>
                    예약자격/기간 등록
                </h3>
            </div>
            <!--// Sub Title -->
            <div class="tbl_write">
                <div>
                    <h2>1.예약 자격</h2>
                    적용할 우대 예약 조건을 선택해 주세요.
                </div>
                <div>
                    <label>
                        <input type="radio" class="AXInput" name="target" id="cheNormal" value="B02" checked/> 자격조건선택
                    </label>
                    <label>
                        <input type="radio" class="AXInput" name="target" id="cheSpecial" value="B01"/> 특정대상자선택
                    </label>
                </div>
                <div id="rsvnormal">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <th scope="row">Pin 구간</th>
                            <td>
                                <select id="pintreatrange">
                                    <option value="">선택</option>
                                    <c:forEach var="items" items="${pininfo }">
                                        <option value="${items.code }">${items.name }</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">우대지역</th>
                            <td>
                                <select id="citytreatcode">
                                    <option value="">선택</option>
                                    <c:forEach var="items" items="${areainfo }">
                                        <option value="${items.code }">${items.name }</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">나이우대</th>
                            <td>
                                <select id="agetreatcode">
                                    <option value="">선택</option>
                                    <c:forEach var="items" items="${ageinfo }">
                                        <option value="${items.seq }">${items.name }</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="rsvspecial" style="display:none;">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <th scope="row">특정대상자 구간</th>
                            <td>
                                <select id="special">
                                    <option value="">선택</option>
                                    <c:forEach var="items" items="${specialinfo }">
                                        <option value="${items.seq }">${items.name }</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                    </table>
                </div>
                <div>
                    <h2>1.예약 가능 기간</h2>
                    상기 선택 예약조건으로 지정할 기간유형을 선택하세요.
                </div>
                <div>
                    <label>
                        <input type="radio" class="AXInput" id="day" name="period" value="P01" checked/> 일기준
                    </label>
                    <label>
                        <input type="radio" class="AXInput" id="month" name="period" value="P03"/> 월기준
                    </label>
                </div>
                <div id="area1">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <th scope="row">예약 가능 시작일</th>
                            <td>
                                당일부터
                                <select class="boxday" id="startday" style="min-width:50px;">
                                    <option value="">선택</option>
                                </select>
                                일 후
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">예약 가능 종료일</th>
                            <td>
                                당일부터
                                <select class="boxday" id="endday" style="min-width:50px;">
                                    <option value="">선택</option>
                                </select>
                                일 후
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="area2" style="display:none;">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <th scope="row">예약 가능 시작일</th>
                            <td>
                                매월
                                <select class="mboxday" id="mstartday" style="min-width:50px;">
                                    <option value="">선택</option>
                                </select>
                                일
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">예약 가능 종료일</th>
                            <td>
                                <select class="boxmonth" id="mendmonth" style="min-width:50px;">
                                    <option value="">선택</option>
                                </select>
                                개월 후
                                &nbsp;&nbsp;
                                해당월
                                <select class="mboxday" id="mendday" style="min-width:50px;">
                                    <option value="">선택</option>
                                </select>
                                일
                            </td>
                        </tr>
                    </table>
                </div>
                <div style="line-height:1.3em;">
                    <p>예시1)</p>
                    <p>- 일기준 : 예약 가능 기간이 일 단위일 경우 (사용 당일부터 최대 7일 후까지)</p>
                    <p>- 월기준 : 예약 가능 기간이 월 단위일 경우 (매월 5일부터 3개월 후 말일까지)</p>
                    <br>
                    <p>예시2)</p>
                    <p>- 예약 가능 시작일을 “5일”, 예약 가능 종료일을 “25일＂로 설정할 경우</p>
                    <p>- 예약 신청하는 날이 7월 1일일 경우</p>
                    <p>- 예약 가능 기간은 7월 5일 ~ 7월 25일</p>
                </div>
                <div>
                    <h2>3.적용세션</h2>
                </div>
                <div>
                    <label>
                        <input type="radio" class="AXInput" name="apply" id="allsession" value="P01" checked/> 모든세션
                    </label>
                    <label>
                        <input type="radio" class="AXInput" name="apply" id="session"  value="P02"/> 특정세션선택
                    </label>
                </div>
                <div id="selsession">
                    <div class="fr">
                        <a href="javascript:;" class="btn_gray" id="hang">행추가</a>
                    </div>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr id="addtr">
                            <th scope="row">요일</th>
                            <td>
                                <select style="min-width:80px;" id="setweek0" name="setweek" onchange="fnsetweek(0);">
                                    <option value="">선택</option>
                                    <c:forEach var="items" items="${weekinfo }">
                                        <option value="${items.commoncodeseq}">${items.codename}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <th scope="row">선택</th>
                            <td>
                                <select id="rsvsessionseq0" name="rsvsessionseq">
                                    <option value="">선택</option>
                                </select>
                            </td>
                            <td>

                            </td>
                        </tr>
                    </table>
                </div>
            </div>

            <div class="btnwrap mb10">
                <a href="javascript:;" id="saveBtn" class="btn_green">등록</a>
                &nbsp;
                <a href="javascript:;" class="btn_gray btn_close close-layer">취소</a>
            </div>
        </div>
      </form>
    </div>
</div>
</body>