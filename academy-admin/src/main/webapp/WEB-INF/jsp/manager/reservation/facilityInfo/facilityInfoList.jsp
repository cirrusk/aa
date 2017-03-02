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
        , sortColKey: "Rsv.facilityInfo.list"
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
                var k = 0;
                var fctype = "";
                var fccheck = $("[name='fctype']");

                for(var i = 0; i < fccheck.length; i++){
                    if($("#fctype"+i).is(":checked")) {
                        if (k > 0) {
                            fctype = fctype + "," + $("#fctype" + i + ":checked").val();
                        } else {
                            fctype = $("#fctype" + i).val();
                            k = k + 1;
                        }
                    }
                }
                showLoading();
                var initParam = {
                    roomname : $("#roomname").val()
                    , statuscode : $("#selectyn option:selected").val()
                    , ppseq : $("#ppseq option:selected").val()
                    , partition : $("#partition").val()
                    , fctype : fctype
                };
                $.extend(defaultParam, initParam);
                postGoto("<c:url value="/manager/reservation/facilityInfo/facilityinfoExcelDownload.do"/>", defaultParam);
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

        //신규등록
        $("#btnInsert").click(function(){
            var f = document.listForm;
            f.roomMode.value = "I";
            f.action = "/manager/reservation/facilityInfo/facilityInfoDetailOne.do";
            f.submit();
        });

        //파티션룸으로 설정
        $("#btnSet").on("click", function(){
            var seq = "";
            var roomseq = "";
            var ppseq1 = "";
            var ppseq2 = "";
            var setCheckList = adminGrid.getCheckedListWithIndex(0);

            if(setCheckList.length < 3  && setCheckList.length > 1){
            	for(var i=0;i<setCheckList.length;i++){
            		if(i==0){
            			roomseq = setCheckList[i].item.roomseq;
                        ppseq1 = setCheckList[i].item.ppseq;
            		} else {
            			roomseq = roomseq + "," + setCheckList[i].item.roomseq;
                        ppseq2 = setCheckList[i].item.ppseq;
            		}
            	}

                if(ppseq1!=ppseq2) {
                    alert("동일한 시설만 진행 할 수 있습니다.");
                    return;
                }

                var param = {
                    roomseq : roomseq
                    , ppseq : ppseq1
                };

                $.ajaxCall({
                    url: "<c:url value="/manager/reservation/facilityInfo/facilityInfoPartitionCheck.do"/>"
                    , data: param
                    , success: function( data, textStatus, jqXHR){
                        if(data.err < 1){
                            alert(data.msg);
                        } else {
                            if( data.err =="1" ) {
                                var f = document.listForm;
                                 f.roomseq.value = roomseq;
                                 f.action = "/manager/reservation/facilityInfo/facilityInfoPartitionDetail.do";
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

            }else{
                alert("두 개의 시설만 파티션 룸으로 셋팅이 가능합니다.");
            }
        });

    });

    //시설정보상세
    var gridEvent = {
        nameClick: function (val) {
            var f = document.listForm;
            f.roomseq.value = val;
            f.action = "/manager/reservation/facilityInfo/facilityInfoDetailPage.do";
            f.submit();
           
        }
    }

    var adminList = {
        /** init : 초기 화면 구성 (Grid)
         */
        init : function() {
            var idx = 0; // 정렬 Index
            var _colGroup = [
                {key:"checkbox", label:" ", width:"20", align:"center", formatter:"checkbox", sort:false,checked:function(){
                    return this.item.___checked && this.item.___checked["1"];}}
                , {key:"row_num", label:"No.", width:"20", align:"center", formatter:"money", sort:false}
                , {key:"ppname", label:"PP", width:"40", align:"center", sort:false}
                , {key:"roomname", label:"시설 명", width:"80", align:"center", sort:false, formatter: function(){
					return "<a href=\"javascript:;\" onclick=\"gridEvent.nameClick('" + this.item.roomseq + "')\">" + this.item.roomname + "</a>";
				  }}
                , {key:"typename", label:"시설 타입", width:"40", align:"center", sort:false}
                , {key:"sameroomseq", label:"파티션 룸", width:"40", align:"center", sort:false}
                , {key:"seatcount", label:"수용 인원", width:"40", align:"center", sort:false}
                , {key:"startdate", label:"운영시작", width:"40", align:"center", sort:false}
                , {key:"enddate", label:"운영종료", width:"40", align:"center", sort:false}
                , {key:"statuscode", label:"상태", width:"40", align:"center", sort:false,formatter: function(){
                    if(this.item.statuscode == "B01"){
                        return "<span>사용</span>";
                    }else if(this.item.statuscode == "B02"){
                        return "<span>사용안함</span>";
                    }else if(this.item.statuscode == null) {
                        return "<span></span>";
                    }
                }}
                , {key:"updatedate", label:"최종 수정일시", width:"60", align:"center", sort:false}
                , {key:"updateuser", label:"최종 수정자", width:"40", align:"center", sort:false}
                , {key:"roomseq", label:"수정", width:"70", align:"center", sort:false, formatter:function(){
                    var menuAuthManage = param.menuAuth;
                    if(menuAuthManage == "W"){
                        return "<a href=\"javascript:;\" class=\"btn_green\" onclick=\"adminList.doSearchDetail('" + this.item.roomseq  + "')\">수정</a>";
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
            var k = 0;
            var fctype = "";
            var fccheck = $("[name='fctype']");

            for(var i = 0; i < fccheck.length; i++){
                if($("#fctype"+i).is(":checked")) {
                    if (k > 0) {
                        fctype = fctype + "," + $("#fctype" + i + ":checked").val();
                    } else {
                        fctype = $("#fctype" + i).val();
                        k = k + 1;
                    }
                }
            }

            // Param 셋팅(검색조건)
            var initParam = {
                roomname : $("#roomname").val()
                , statuscode : $("#selectyn option:selected").val()
                , ppseq : $("#ppseq option:selected").val()
                , fctype : fctype
                , partition : $("#partition").val()
            };

            $.extend(defaultParam, param);
            $.extend(defaultParam, initParam);

            $.ajaxCall({
                url: "<c:url value="/manager/reservation/facilityInfo/facilityInfListAjax.do"/>"
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
        },doSearchDetail: function(val){
            var f = document.listForm;
            f.roomseq.value = val;
            f.roomMode.value = "U";
            f.action = "/manager/reservation/facilityInfo/facilityInfoDetailOne.do";
            f.submit();
        }
    }

</script>
</head>

<body class="bgw">
<form:form id="listForm" name="listForm" method="post">
    <input type="hidden" id="roomseq" name="roomseq" value="${listseq.roomseq}"/>
    <input type="hidden" id="sTypeseq" name="sTypeseq" value="${listseq.typeseq}"/>
    <input type="hidden" name="roomMode" id="roomMode"/>
    <input type="hidden" name="frmId" value="${param.frmId}"/>
    <input type="hidden" name="menuAuth" id="menuAuth" value="${param.menuAuth}"/>
</form:form>
<!--title //-->
<div class="contents_title clear">
    <h2 class="fl">시설 정보</h2>
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
            <th scope="row" style="text-align: center;">PP</th>
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
            <th scope="row" style="text-align: center;">시설타입</th>
            <td>&nbsp;
                <c:forEach var="rsvType" items="${rsvType}" varStatus="i">
                    <label>
                        <input type="checkbox" id="fctype${i.index}" name="fctype" value="${rsvType.typeseq}"/> ${rsvType.typename}
                    </label>
                </c:forEach>
            </td>
            <th rowspan="3">
           		<div class="btnwrap mb10">
           			<a href="javascript:;" id="btnSearch" class="btn_gray btn_big">조회</a>
           		</div>
           </th>
        </tr>
        <tr>
            <th scope="row" style="text-align: center;">파티션 룸</th>
            <td>
                <select id="partition">
                    <option value="">전체</option>
                    <option value="Y">Y</option>
                    <option value="N">N</option>
                </select>
            </td>
            <th scope="row" style="text-align: center;">상태</th>
            <td>&nbsp;
                <select id="selectyn">
                    <option value="">전체</option>
                    <option value="B01">사용</option>
                    <option value="B02">사용안함</option>
                </select>
            </td>
        </tr>
        <tr>
            <th scope="row" style="text-align: center;">시설명</th>
            <td colspan="3">
                <input type="text" class="AXInput" style="min-width:303px;" id="roomname" value=""/>
            </td>
        </tr>
    </table>

    <div class="contents_title clear" style="padding-top: 15px;height: 15px;">
        <div class="fl">
            <select id="cboPagePerRow" name="cboPagePerRow" style="width:auto; min-width:100px">
                <ct:code type="option" majorCd="pageCnt" selectAll="false" selected="${rowPerCount }"/>
            </select>
        </div>
        <div class="fr">
            <a href="javascript:;" id="btnExcel" class="btn_excel" style="vertical-align:middle; margin-left:0px;">엑셀다운</a>
            <a href="javascript:;" id="btnSet" class="btn_green authWrite" style="vertical-align:middle; margin-left:0px;">선택 룸 파티션룸으로 설정</a>
            <a href="javascript:;" id="btnInsert" class="btn_green authWrite" style="vertical-align:middle; margin-left:0px;">신규등록</a>
        </div>
    </div>

</div>

<!-- grid -->
<div id="AXGrid">
    <div id="AXGridTarget_${param.frmId}"></div>
</div>

<!-- Board List -->

</body>