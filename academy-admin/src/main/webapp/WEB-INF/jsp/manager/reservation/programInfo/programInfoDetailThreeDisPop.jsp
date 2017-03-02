<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>

<script type="text/javascript">
    //Grid Init
    var adminDisPopGrid = new AXGrid(); // instance 상단그리드

    //Grid Default Param
    var defaultParam = {
        page: 1
        , rowPerPage: "${rowPerCount }"
        , sortColKey: "Rsv.facilityInfo.detailThreeDis"
        , sortIndex: 1
        , sortOrder:"DESC"
    };


    $(document).ready(function(){
        var idx = 0; // 정렬 Index
        var _colGroup = [
            {key:"settingseq", label:"No.", width:"50", align:"center", formatter:"checkbox", sort:false,checked:function(){
                return this.item.___checked && this.item.___checked["1"];}}
            , {key:"role", label:"자격", width:"200", align:"center", sort:false}
            , {key:"globaldailycount", addClass:idx++, label:"일", width:"100", align:"center"}
            , {key:"globalweeklycount", addClass:idx++, label:"주", width:"100", align:"center"}
            , {key:"globalmonthlycount", addClass:idx++, label:"월", width:"100", align:"center"}
            , {key:"ppdailycount", addClass:idx++, label:"일", width:"100", align:"center"}
            , {key:"ppweeklycount", addClass:idx++, label:"주", width:"100", align:"center"}
            , {key:"ppmonthlycount", addClass:idx++, label:"월", width:"100", align:"center"}
        ]

        var gridParam = {
            colGroup : _colGroup
            , colHead : { heights: [20,20],
                rows : [
                    [
                        {colSeq: 0, rowspan: 2, valign:"middle"}
                        , {colSeq: 1, rowspan: 2, valign:"middle"}
                        , {colseq:null, colspan: 3, label: "총 예약 가능 횟수 (전국PP기준)", align: "center", valign:"middle"}
                        , {colseq:null, colspan: 3, label: "시설별 예약 가능 횟수", align: "center", valign:"middle"}
                    ], [
                        {colSeq: 2}
                        ,{colSeq: 3}
                        ,{colSeq: 4}
                        ,{colSeq: 5}
                        ,{colSeq: 6}
                        ,{colSeq: 7}
                    ]
                ]
            }
            , fitToWidth: true
            , targetID : "AXGridTarget_${param.frmId}"
            , height : "300px"
        }

        fnGrid.nonPageGrid(adminDisPopGrid, gridParam);
        doSearch();

        // 체크박스 저장
        $("#saveBtn").on("click", function (){

            var settingseq = "";
            var checkedList = adminDisPopGrid.getCheckedListWithIndex(0);// colSeq

            for(var i = 0; i < checkedList.length; i++){
                if(i == 0){
                    settingseq = checkedList[i].item.settingseq;
                } else {
                    settingseq = settingseq + ","+ checkedList[i].item.settingseq;
                }
            }

            if($.trim(settingseq).length ==0){
                alert("선택된 대상자가 없습니다.");
                return;
            }

            // 저장전 Validation
            if(!confirm("저장하시겠습니까?")){
                return;
            }

            var param ={
                settingseq : settingseq
                ,expseq : $("#expseq").val()
                ,type : $("#category").val()
            }

            $.ajaxCall({
                url: "<c:url value="/manager/reservation/programInfo/programInfoDetailDisInsert.do"/>"
                , data: param
                , success: function(data, textStatus, jqXHR){
                    alert("등록하였습니다");
                    eval($('#ifrm_main_'+$("input[name='frmId']").val()).get(0).contentWindow.disList.doSearch(param));
                    closeManageLayerPopup("searchPopup");
                },
                error: function( jqXHR, textStatus, errorThrown) {
    				var mag = '<spring:message code="errors.load"/>';
    				alert(mag);
                }
            });

        });
    });

    function doSearch(){
        // Param 셋팅(검색조건)
        var initParam = {
        };


        $.extend(defaultParam, initParam);

        $.ajaxCall({
            url: "<c:url value="/manager/reservation/programInfo/programInfoDetailDisPopListAjax.do"/>"
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
                , page:{
                    pageNo: obj.page,
                    pageSize: defaultParam.rowPerPage,
                    pageCount: obj.totalPage,
                    listCount: obj.totalCount
                }
            };
            // Grid Bind Real
            adminDisPopGrid.setData(gridData);
        }
    }

</script>

<div id="popwrap">
    <form:form id="listForm" name="listForm" method="post">
        <input type="hidden" id="expseq" name="expseq" value="${listtype.expseq}"/>
        <input type="hidden" id="category" name="category" value="${listtype.type}"/>
        <input type="hidden" name="frmId" value="${listtype.frmId}"/>
    </form:form>
    <!--pop_title //-->
    <div class="title clear">
        <h2 class="fl">
            누적예약제한 등록
        </h2>
        <span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
    </div>
    <!--// pop_title -->

    <!-- Contents -->
    <div id="popcontainer"  style="height:270px">
        <div id="popcontent">
            <!-- Sub Title -->
            <div class="poptitle clear">
                <h3>
                    누적 예약 제한
                </h3>
            </div>
            <!--// Sub Title -->
            <div class="tbl_write">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <!-- grid -->
                    <div id="AXGrid">
                        <div id="AXGridTarget_${param.frmId}"></div>
                    </div>

                </table>
            </div>


            <div class="btnwrap mb10">
                <a href="javascript:;" id="saveBtn" class="btn_green">등록</a>
                &nbsp;
                <a href="javascript:;" class="btn_gray btn_close close-layer">취소</a>
            </div>
        </div>
    </div>
</div>