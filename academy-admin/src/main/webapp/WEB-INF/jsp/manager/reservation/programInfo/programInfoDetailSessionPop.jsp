<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>

<script type="text/javascript">
    //Grid Init
    var adminGrid = new AXGrid(); // instance 상단그리드

    //Grid Default Param
    var defaultParam = {
        page: 1
        , rowPerPage: "${rowPerCount }"
        , sortColKey: "Rsv.programInfo.detailpoppreview"
        , sortIndex: 1
        , sortOrder:"DESC"
    };

    $(document).ready(function(){
        var idx = 0; // 정렬 Index
        var _colGroup = [
            {key:"sessionname", label:"세션", width:"50", align:"center", sort:false}
            , {key:"weektime", label:"시간", width:"200", align:"center", sort:false}
        ]

        var gridParam = {
            colGroup : _colGroup
            , fitToWidth: true
            , targetID : "AXGridTarget_${param.frmId}"
            , height : "300px"
        }

        fnGrid.nonPageGrid(adminGrid, gridParam);
        doSearch();
    });

    function doSearch(){
        // Param 셋팅(검색조건)
        var initParam = {
            expseq : $("#expseq").val()
            ,setdate : $("#setdate").val()
        };

        $.extend(defaultParam, initParam);

        $.ajaxCall({
            url: "<c:url value="/manager/reservation/programInfo/programInfoDetailTwoPreview.do"/>"
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
        <input type="hidden" id="setdate" name="setdate" value="${weektype.setdate}"/>
    </form:form>
    <!--pop_title //-->
    <div class="title clear">
        <h2 class="fl">
            운영요일 미리보기
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
                    세션정보 미리보기  ${weektype.setdate} (${listtype.datename})
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
                <a href="javascript:;" class="btn_gray btn_close close-layer">취소</a>
            </div>
        </div>
    </div>
</div>