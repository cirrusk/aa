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
        , sortColKey: "Rsv.programInfo.list"
        , sortIndex: 1
        , sortOrder:"DESC"
    };

    $(document.body).ready(function() {
        param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"};
        if(param.menuAuth == "W"){
            $(".authWrite").show();
        }else{
            $(".authWrite").hide();
        }

        adminList.init();

        // 엑셀다운 버튼 클릭시
        $("#btnExcel").on("click", function(){
            var result = confirm("엑셀 내려받기를 시작 하시겠습니까?\n 네트워크 상황에 따라서 1~3분 정도 시간이 걸릴 수 있습니다.");
            if(result) {
                showLoading();
                var initParam = {
                };
                $.extend(defaultParam, initParam);
                postGoto("<c:url value="/manager/reservation/programInfo/programInfoExcelDownload.do"/>", defaultParam);
                hideLoading();
            }
        });

        // 페이지당 보기수 변경 이벤트
        $("#cboPagePerRow").on("change", function(){
            adminList.doSearch({page:1, rowPerPage : $("#cboPagePerRow").val() });
        });

        // 검색버튼 클릭
        $("#btnSearch").on("click", function(){
            adminList.doSearch({page:1});
        });

        //측정프로그램 등록
        $("#btnCheck").click(function(){
            var f = document.listForm;
            f.listMode.value = "CHECK";
            f.action = "/manager/reservation/programInfo/programInfoDetailOne.do";
            f.submit();
        });

        //체험프로그램 등록
        $("#btnExp").click(function(){
            var f = document.listForm;
            f.listMode.value = "EXP";
            f.action = "/manager/reservation/programInfo/programInfoDetailOne.do";
            f.submit();
        });
    });

    //시설정보상세
    var gridEvent = {
        nameClick: function (val) {
            var f = document.listForm;
            f.expseq.value = val;
            f.action = "/manager/reservation/programInfo/programInfoDetailPage.do";
            f.submit();
        }
    }

    var adminList = {
        /** init : 초기 화면 구성 (Grid)
         */
        init : function() {
            var idx = 0; // 정렬 Index
            var _colGroup = [
                  {key:"row_num", label:"No.", width:"40", align:"center", formatter:"money", sort:false}
                , {key:"ppname", label:"PP", width:"60", align:"center", sort:false}
                , {key:"categorytype1", label:"타입", width:"60", align:"center", sort:false}
                , {key:"productname", label:"프로그램 명", width:"150", align:"center", sort:false, formatter: function(){
                    return "<a href=\"javascript:;\" onclick=\"gridEvent.nameClick('" + this.item.expseq + "','"+this.item.categorytype1+"')\">" + this.item.productname + "</a>";
                }}
                , {key:"seatcount", label:"수용 인원", width:"40", align:"center", sort:false, formatter: function(){
                    if(this.item.seatcount1 != null){
                        return "<span>"+this.item.seatcount1+"</span>"
                    }else{
                        return "<span>"+this.item.seatcount2+"</span>"
                    }
                }}
                , {key:"startdate", label:"운영시작", width:"60", align:"center", sort:false}
                , {key:"enddate", label:"운영종료", width:"60", align:"center", sort:false}
                , {key:"updatedate", label:"최종 수정일시", width:"60", align:"center", sort:false}
                , {key:"updateuser", label:"최종 수정자", width:"60", align:"center", sort:false}
                , {key:"statuscode", label:"상태", width:"40", align:"center", sort:false}
                , {key:"update", label:"수정", width:"40", align:"center", sort:false, formatter:function(){
                    var menuAuthManage = param.menuAuth;
                    if(menuAuthManage=="W"){
                        return "<a href=\"javascript:;\" class=\"btn_green\" onclick=\"adminList.doSearchUpdate('" + this.item.expseq  + "')\">수정</a>";
                    }else{
                        return;
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
            adminList.doSearch();
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

            // Param 셋팅(검색조건)
            var initParam = {
                ppseq : $("#ppseq option:selected").val()
               ,categorytype1 : $("#categorytype1 option:selected").val()
               ,statuscode : $("#statuscode option:selected").val()
               ,productname: $("#productname").val()
            };

            $.extend(defaultParam, param);
            $.extend(defaultParam, initParam);

            $.ajaxCall({
                url: "<c:url value="/manager/reservation/programInfo/programInfoListAjax.do"/>"
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
        },doSearchUpdate: function(val){
            var f = document.listForm;
            f.expseq.value = val;
            f.listMode.value = "U";
            f.action = "/manager/reservation/programInfo/programInfoUpdatePage.do";
            f.submit();
        }
    }

</script>
</head>

<body class="bgw">
<form:form id="listForm" name="listForm" method="post">
    <input type="hidden" id="expseq" name="expseq" value="${listtype.expseq}"/>
    <input type="hidden" name="listMode" id="listMode"/>
    <input type="hidden" name="frmId" value="${param.frmId}"/>
    <input type="hidden" name="menuAuth" id="menuAuth" value="${param.menuAuth}"/>
</form:form>
<!--title //-->
<div class="contents_title clear">
    <h2 class="fl">프로그램 정보</h2>
</div>

<!--search table // -->
<div class="tbl_write">
	<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
		<colgroup>
			<col width="9%" />
			<col width="*"  />
			<col width="10%" />
			<col width="30%" />
			<col width="10%" />
		</colgroup>
			<tr>
				<th>PP</th>
	            <td>
	                <select id="ppseq">
						<c:if test="${1 < fn:length(ppCodeList)}">
							<option value="">전체</option>
						</c:if>
	                    <c:forEach var="item" items="${ppCodeList}">
	                        <option value="${item.commonCodeSeq}">${item.codeName}</option>
	                    </c:forEach>
	                </select>
	            </td>
	            <th>프로그램타입</th>
	            <td>
	                <select id="categorytype1">
	                    <option value="">전체</option>
	                    <option value="E01">체성분측정</option>
	                    <option value="E02">피부측정</option>
	                    <option value="E03">브랜드체험</option>
	                    <option value="E04">문화체험</option>
	                </select>
	            </td>
	            <th rowspan="2">
	           		<div class="btnwrap mb10">
	           			<a href="javascript:;" id="btnSearch" class="btn_gray btn_big">조회</a>
	           		</div>
	           </th>
			</tr>
			<tr>
				<th>상태</th>
	            <td>
	                <select id="statuscode">
	                    <option value="">전체</option>
	                    <option value="B01">사용</option>
	                    <option value="B02">사용안함</option>
	                </select>
	            </td>
	            <th>프로그램 명</th>
	            <td>
	                <input type="text" class="AXInput" style="min-width:303px;" id="productname" value=""/>
	            </td>
			</tr>
	</table>
</div>

    <div class="contents_title clear">
        <div class="fl">
            <select id="cboPagePerRow" name="cboPagePerRow" style="width:auto; min-width:100px">
                <ct:code type="option" majorCd="pageCnt" selectAll="false" selected="${rowPerCount }"/>
            </select>
        </div>
        <div class="fr">
            <a href="javascript:;" id="btnExcel" class="btn_excel" style="vertical-align:middle; margin-left:0px;">엑셀다운</a>
            <a href="javascript:;" id="btnCheck" class="btn_green authWrite" style="vertical-align:middle; margin-left:0px;">측정프로그램등록</a>
            <a href="javascript:;" id="btnExp" class="btn_green authWrite" style="vertical-align:middle; margin-left:0px;">체험프로그램등록</a>
        </div>
    </div>

	<!-- grid -->
	<div id="AXGrid">
	    <div id="AXGridTarget_${param.frmId}"></div>
	</div>

<!-- Board List -->

</body>