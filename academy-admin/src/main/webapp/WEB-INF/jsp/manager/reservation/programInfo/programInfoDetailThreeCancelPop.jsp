<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>

<script type="text/javascript">
    //Grid Init
    var adminGrid = new AXGrid(); // instance 상단그리드

    //Grid Default Param
    var defaultParam = {
        page: 1
        , rowPerPage: "${rowPerCount }"
        , sortColKey: "Rsv.facilityInfo.detailthreecancelpop"
        , sortIndex: 1
        , sortOrder:"DESC"
    };

    $(document).ready(function(){
        var idx = 0; // 정렬 Index
        var _colGroup = [
            {key:"penaltyseq", label:"No.", width:"50", align:"center", formatter:"checkbox", sort:false,checked:function(){
                return this.item.___checked && this.item.___checked["1"];}}
            , {key:"typecode", label:"구분", width:"200", align:"center", sort:false}
            , {key:"typedetailcode", label:"취소 기준", width:"150", align:"center", sort:false}
            , {key:"applytypecode", addClass:idx++, label:"패널티", width:"200", align:"center"}
        ]

        var gridParam = {
            colGroup : _colGroup
            , fitToWidth: true
            , targetID : "AXGridTarget_${param.frmId}"
            , height : "300px"
        }

        fnGrid.nonPageGrid(adminGrid, gridParam);
        doSearch();

        // 체크박스 저장
        $("#saveBtn").on("click", function (){

            var penaltyseq = "";
            var checkedList = adminGrid.getCheckedListWithIndex(0);// colSeq

            for(var i = 0; i < checkedList.length; i++){
                if(i == 0){
                    penaltyseq = checkedList[i].item.penaltyseq;
                } else {
                    penaltyseq = penaltyseq + ","+ checkedList[i].item.penaltyseq;
                }
            }

            if($.trim(penaltyseq).length ==0){
                alert("선택된 대상자가 없습니다.");
                return;
            }

            // 저장전 Validation
            if(!confirm("저장하시겠습니까?")){
                return;
            }

            var param ={
                penaltyseq : penaltyseq
                ,expseq :$("#expseq").val()
            }

            $.ajaxCall({
                url: "<c:url value="/manager/reservation/programInfo/programInfoDetailCancelInsert.do"/>"
                , data: param
                , success: function(data, textStatus, jqXHR){
                    alert("등록하였습니다");
                    eval($('#ifrm_main_'+$("input[name='frmId']").val()).get(0).contentWindow.cancelList.doSearch(param));
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
            url: "<c:url value="/manager/reservation/programInfo/programInfoDetailThreeCancelPopListAjax.do"/>"
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
            adminGrid.setData(gridData);
        }
    }

</script>

<div id="popwrap">
    <form:form id="listForm" name="listForm" method="post">
        <input type="hidden" id="expseq" name="expseq" value="${listtype.expseq}"/>
        <input type="hidden" id="type" name="type" value="${listtype.type}"/>
        <input type="hidden" name="frmId" value="${listtype.frmId}"/>
    </form:form>
    <!--pop_title //-->
    <div class="title clear">
        <h2 class="fl">
            취소/패널티 등록
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
                    취소/패널티
                </h3>
            </div>

            <!-- grid -->
            <div id="AXGrid">
                <div id="AXGridTarget_${param.frmId}"></div>
            </div>

            <div class="btnwrap mb10">
                <a href="javascript:;" id="saveBtn" class="btn_green">등록</a>
                &nbsp;
                <a href="javascript:;" class="btn_gray btn_close close-layer">취소</a>
            </div>
        </div>
    </div>
</div>
