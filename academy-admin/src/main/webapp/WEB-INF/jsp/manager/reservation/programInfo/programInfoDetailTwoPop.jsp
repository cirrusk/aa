<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>

<script type="text/javascript">
    var selectMode = {};

    $(document).ready(function(){
        $("#setdate").bindDate({separator:"-", selectType:"d"});

        //휴무일로지정 저장
        $("#saveBtn").on("click",function(){
            if(!confirm("저장하시겠습니까?")){
                return;
            }
            var mode = $("input:radio[name='day']:checked").val();
            list.doSave(mode);
        });

        //세션추가
        $("#btnAdd").on("click",function(){
            var newitem = $("#tblSearch tbody tr:eq(0)").clone();
            newitem.removeClass();
            $("#tblSearch").append(newitem);
        });

        //세션삭제
        $("#btnRemoven").on("click",function(){
            var len = $("#tblSearch tbody tr").length;
            if(len < 2){
                alert("삭제할 수 없습니다.");
            }else {
                $("#tblSearch tr:last").remove();
            }
        });

        //휴무일로 지정
        $("#holiday").on("click",function(){
            $("#session").hide();
        });

        //운영일로 지정
        $("#runday").on("click",function(){
            $("#session").show();
        });

        var html=[];
        var value = "";

        //시간 삽입하기
        for(var i=0;i<=24;i++){
            if(i<10){
                value = "0"+i;
            }else{
                value = i;
            }
            html[i] = "<option value="+value+">"+value+"</option>";
        }
        $(".hour").append(html.join(''));


        //분 삽입하기
        for(var i=0;i<60;i++){
            if(i<10){
                value = "0" + i;
            }else{
                value = i;
            }

            html[i] = "<option value="+value+">"+value+"</option>";
        }
        $(".min").append(html.join(""));

    });

    var list = {
         doSave : function(mode, item, idx){
             var checkList  = document.getElementsByName("checkList[]");
             var checkPong = "Y";
             for(var i=0; i<checkList.length; i++) {
                 if (checkList[i].value == $("#setdate").val().replace(/-/g, "")) {
                     checkPong = "N";
                 }
             }
             if(checkPong == "N") {
                 if(confirm("해당일자에 지정된 우선운영요일/휴무일이 존재 합니다. 변경 하시겠습니까?")){
                 } else {
                     return;
                 }
             }

             var rsvCheckList = document.getElementsByName("rsvCheckList[]");
             var rsvCheckPong = "Y";
             for(var i=0; i<rsvCheckList.length; i++) {
                 if(rsvCheckList[i].value == $("#setdate").val().replace(/-/g,"")) {
                     rsvCheckPong = "N";
                 }
             }
             if(rsvCheckPong == "N") {
                 alert("해당일자에 시설 예약이 있어 휴무일로 지정할 수 없습니다.\n예약 ABO와 사전 커뮤니케이션 하시고 관리자 예약으로 조치 바랍니다.");
                 return;
             }

            var sUrl = "<c:url value="/manager/reservation/programInfo/programInfoInsertEarly.do"/>";
            var sMsg = "등록하였습니다.";

            var orderParam = {};
            var param = {};

            if(isNull($("#setdate").val())) {
                alert("지정일자 값이 없습니다.\n 지정일자은(는) 필수 입력값입니다. ");
                $("#setdate").focus();
                return;
            }

            if(mode == "S01") {
                var stHour = document.getElementsByName("stHour[]");
                var stMin = document.getElementsByName("stMin[]");
                var endHour = document.getElementsByName("endHour[]");
                var endMin = document.getElementsByName("endMin[]");

                var weekRow = "";
                var stTime = "";
                var endTime = "";
                var bChk = false;

                for (var i = 0; i < stHour.length; i++) {
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
                    endTime = endHour[i].value + endMin[i].value;

                    if (i == 0) {
                        weekRow = stTime + "/" + endTime
                    } else {
                        weekRow = weekRow + "," + stTime + "/" + endTime
                    }
                }

                if(bChk) return;

                param = {
                    weekRow : weekRow
                };
            }

            // Param 셋팅(검색조건)
            var masterParam = {
                expseq : $("#expseq").val(),
                setdate : $("#setdate").val(),
                worktypecode : $("input:radio[name='day']:checked").val(),
                listMode : $("#listMode").val()
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
                        alert(sMsg);
                        eval($('#ifrm_main_'+$("input[name='frmId']").val()).get(0).contentWindow.adminList.doSearch(param));
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
<form:form id="listForm" name="listForm" method="post">
    <input type="hidden" id="expseq" name="expseq" value="${listtype.expseq}"/>
    <input type="hidden" id="type" name="type" value="${listtype.categorytype1}"/>
    <input type="hidden" name="frmId" value="${listtype.frmId}"/>
    <input type="hidden" id="listMode" name="listMode" value="${listtype.listMode}"/>
</form:form>
<c:forEach items="${checkList}" var="huList" varStatus="status">
    <input type="hidden" name="checkList[]" value="${huList.setdate}"/>
</c:forEach>
<c:forEach items="${rsvCheckList}" var="rsvList" varStatus="status">
    <input type="hidden" name="rsvCheckList[]" value="${rsvList.reservationdate}"/>
</c:forEach>
<div id="popwrap">
    <!--pop_title //-->
    <div class="title clear">
        <h2 class="fl">
            일정추가
        </h2>
        <span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
    </div>
    <!--// pop_title -->

    <!-- Contents -->
    <div id="popcontainer"  style="height:270px">
        <div id="popcontent">
            <!-- Sub Title -->
            <div class="poptitle clear">
                <h3>우선운영요일/휴무지정</h3>
            </div>
            <!--// Sub Title -->
            <div class="tbl_write">
                <div>
                    <h2>1.날짜선택</h2>
                    <input type="text" id="setdate" class="AXInput datepDay" readonly="readonly">
                </div>
                <br>
                <div>
                    <h2>2.구분선택</h2>
                    <h3>적용할 구분 조건을 선택해 주세요.</h3>
                    <label>
                        <input type="radio" class="AXInput" name="day" id="runday" value="S01" checked/> 운영일로 지정
                    </label>
                    <label>
                        <input type="radio" class="AXbindCheckedHandle_radio" name="day" id="holiday" value="S02"/> 휴무일로 지정
                    </label>
                </div>
                <br>
                <span id="session">
                    <h2>3.세션설정</h2>
                    <div class="contents_title clear" style="font-size: 15px;height: 15px;line-height: 3;">
                        <div class="fl">
                            세션조건을 선택하세요.
                        </div>
                        <div class="fr">
                            <a href="javascript:;" id="btnAdd" class="btn_gray">세션추가</a>
                            <a href="javascript:;" id="btnRemoven" class="btn_gray">세션삭제</a>
                        </div>
                    </div>
                    <table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
                        <thead>
                        <tr>
                            <th scope="row" style="text-align: center;">세션</th>
                            <th scope="row" style="text-align: center;">시간선택</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr style="text-align: center;">
                            <td style="text-align: center;">세션</td>
                            <td style="text-align: center;">
                                <select style="min-width: 50px;" name="stHour[]" class="hour">
                                    <option value="">선택</option>
                                </select> 시
                                <select style="min-width: 50px;" name="stMin[]" class="min">
                                    <option value="">선택</option>
                                </select> 분 ~
                                <select style="min-width: 50px;" name="endHour[]" class="hour">
                                    <option value="">선택</option>
                                </select> 시
                                <select style="min-width: 50px;" name="endMin[]" class="min">
                                    <option value="">선택</option>
                                </select> 분
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </span>
            </div>

            <div class="btnwrap mb10">
                <a href="javascript:;" id="saveBtn" class="btn_green">등록</a>
                &nbsp;
                <a href="javascript:;" class="btn_gray btn_close close-layer">취소</a>
            </div>
        </div>
    </div>
</div>
</body>