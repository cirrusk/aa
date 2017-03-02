<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">
    //Grid Init
    var adminGrid = new AXGrid(); // instance 상단그리드

    //Grid Default Param
    var defaultParam = {
        page: 1
        , rowPerPage: "${rowPerCount }"
        , sortColKey: "common.noteSend.list"
        , sortIndex: 1
        , sortOrder:"DESC"
    };

    $(document.body).ready(function() {
        adminList.init();
        adminList.doSortSearch();

        // 검색버튼 클릭
        $("#btnSearch").on("click", function(){
            adminList.doSearch({page:1});
        });

        //Axisj 월달력
        $("#startday").bindDate({separator:"/", selectType:"d"});
        $("#endday").bindDate({separator:"/", selectType:"d"});

    });

    var adminList = {
        /** init : 초기 화면 구성 (Grid)
         */
        init : function() {
            var idx = 0; // 정렬 Index
            var _colGroup = [
                {key:"row_num", label:"No.", width:"40", align:"center", formatter:"money", sort:false}
                , {key:"senddate", label:"발송일", width:"150", align:"center", sort:false}
                , {key:"noteservice", label:"서비스구분", width:"150", align:"center", sort:false,formatter: function(){
                    if(this.item.noteservice == "1"){
                        return "<span>아카데미</span>";
                    }else if(this.item.noteservice == "2"){
                        return "<span>비즈니스</span>";
                    }else if(this.item.noteservice == "3"){
                        return "<span>쇼핑</span>";
                    }
                }}
                , {key: "notecontent", label : "쪽지안내문구", width: "200", align: "center"}
                , {key: "name", label : "ABO 이름", width: "150", align: "center"}
                , {key: "uid", label : "ABO NO.", width: "150", align: "center"}
                , {key:"newyn", label:"신규여부", width:"150", align:"center", sort:false,formatter:function(){
                    if(this.item.newyn < 24){
                        return "<span>신규</span>"
                    }else{
                        return "<span></span>"
                    }
                }}
                , {key:"deleteyn", label:"삭제여부", width:"150", align:"center", sort:false,formatter:function(){
                    if(this.item.deleteyn == "Y"){
                        return "<span>Y</span>"
                    }else{
                        return "<span>N</span>"
                    }
                }}
            ]

            var gridParam = {
                colGroup : _colGroup
                , fitToWidth: true
                , targetID : "AXGridTarget_${param.frmId}"
                , sortFunc : adminList.doSortSearch
                , doPageSearch : adminList.doPageSearch
            }

            fnGrid.initGrid(adminGrid, gridParam);
        }, doPageSearch : function(pageNo) {
            // Grid Page List
            adminList.doSearch({page:pageNo});
        }, doSortSearch : function(sortKey){
            // Grid Sort
            defaultParam.sortOrder = fnGrid.sortGridOrder(defaultParam, sortKey);
            var param = {
                sortIndex : sortKey
                , page : 1
            };

            // 리스트 갱신(검색)
            adminList.doSearch(param);
        }, doSearch : function(param) {
            var check ="";

            if($("#checkyn").is(":checked",true)){
                check = $("#checkyn").val();
            }

            // Param 셋팅(검색조건)
            var initParam = {
                 noteservice : $("#noteservice").val()
                ,startday: $("#startday").val()
                ,endday:$("#endday").val()
                ,searchtype :$("#txtCalSearchType").val()
                ,searchword :$("#CalculationNm").val()
                ,deleteyn :$("#deleteyn").val()
                ,newcheck: check
            };

            $.extend(defaultParam, param);
            $.extend(defaultParam, initParam);

            $.ajaxCall({
                url: "<c:url value="/manager/common/noteSend/noteSendListAjax.do"/>"
                , data: defaultParam
                , success: function( data, textStatus, jqXHR){
                    if(data.result < 1){
                        var msg = '<spring:message code="errors.load"/>';
                        alert(msg);
                        return;
                    } else {
                        callbackList(data);
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
                    var msg = '<spring:message code="errors.load"/>';
                    alert(msg);
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
    }

</script>
</head>

<body class="bgw">
<!--title //-->
<div class="contents_title clear">
    <h2 class="fl">발신이력</h2>
</div>

<!--search table // -->
<div class="tbl_write">
    <table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <th scope="row" style="text-align: center;">서비스 구분</th>
            <td colspan="3">
                <select id="noteservice">
                    <option value="">전체</option>
                    <option value="3">쇼핑</option>
                    <option value="2">비즈니스</option>
                    <option value="1">아카데미</option>
                </select>
            </td>
        </tr>
        <tr>
            <th scope="row" style="text-align: center;">날짜</th>
            <td colspan="3">
                <input type="text" id="startday" name="searchday" class="AXInput datepDay" readonly="readonly">
                ~
                <input type="text" id="endday" name="searchday" class="AXInput datepDay" readonly="readonly">
            </td>
        </tr>
        <tr>
            <th scope="row" style="text-align: center;" colspan="1">신규여부</th>
            <td colspan="1" style="width: 486px;">
                <label>
                    <input type="checkbox" id="checkyn" name="checkyn" value="24"/>
                    신규
                </label>
            </td>
            <th scope="row" style="text-align: center;" colspan="1">삭제여부</th>
            <td colspan="1">
                <select id="deleteyn">
                    <option value="">선택</option>
                    <option value="Y">Y</option>
                    <option value="N">N</option>
                </select>
            </td>
        </tr>
        <tr>
            <th scope="row" style="text-align: center;">ABO</th>
            <td colspan="3">
                <select id="txtCalSearchType" name="txtSearchType" style="width:auto; min-width:100px" >
                    <option value="">선택</option>
                    <option value="1">ABO번호</option>
                    <option value="2">이름</option>
                </select>
                <input type="text" id="CalculationNm" name="CalculationNm" style="width:auto; min-width:100px" >
                <a href="javascript:;" id="btnSearch" class="btn_gray btn_small">조회</a>
            </td>
        </tr>
    </table>
</div>

<!-- grid -->
<div id="AXGrid">
    <div id="AXGridTarget_${param.frmId}"></div>
</div>

<!-- Board List -->

</body>
