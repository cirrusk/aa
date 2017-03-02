<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

   <script id="jscode">
   		var managerMenuAuth ="${managerMenuAuth}";
        /**
         * Require Files for AXISJ UI Component...
         * Based        : jQuery
         * Javascript   : AXJ.js, AXGrid.js, AXInput.js, AXSelect.js
         * CSS          : AXJ.css, AXGrid.css, AXButton.css, AXInput.css, AXSelecto.css
         */
        AXConfig.AXGrid.fitToWidthRightMargin = -1;

        var pageID = "AXGrid";
        var AXGrid_instances = [];
        var fnObj = {
            pageStart: function () {
                fnObj.grid.bind();
            },
            grid: {
                target: new AXGrid(),
                bind: function () {
                    window.myGrid = fnObj.grid.target;

                    var getColGroup = function () {
                        return [
                            {key: "categoryid", label: "", width: "50", align: "center", formatter:"checkbox", sort: false},
                            {key: "subcount", label: "하위갯수", width: "0", align: "center", sort: false, display:false},
                            {key: "no", label: "No" , width: "50" , align: "center", sort: false },
                            {key: "categoryname1", label: "카테고리1", width: "100", align : "center", sort: false},
                            {key: "categoryname2", label: "카테고리2", width: "100", sort: false},
                            {key: "categoryname3", label: "카테고리3", width: "100", sort: false},
                            {key: "copyrightflag", label: "저작권동의", width: "90", align: "center", sort: false},
                            {key: "complianceflag", label: "Compliance", width: "90", align: "center", sort: false},
                            {key: "openflag", label: "상태", width: "90", align: "center", sort: false},
                            {
            					key: "subinsert", label : "", width: "150", align: "center", sort: false, formatter: function () {
            						if( this.item.categorylevel != '3' ) {
            							var returnUrl = "<a href=\"javascript:;\" class=\"btn_green\" onclick=\"fn_subCategory('" + this.item.categoryid + "','in')\">하위카테고리 등록</a>"
            							;
            							return returnUrl;
            						}
            					}
            				},
            				{
            					key: "update", label : "", width: "80", align: "center", sort: false, formatter: function () {
           							return "<a href=\"javascript:;\" class=\"btn_green\" onclick=\"fn_subCategory('" + this.item.categoryid + "','up')\">수정</a>";
            					}
            				}
                        ];
                    };
                    
                    var getColHead = function () {
                    	return { 
							heights: [25,25],
							rows : [
			                    [
								  	{colSeq:  0, rowspan: 1, valign:"middle"}
									, {colSeq:  1, rowspan: 1, valign:"middle"}
									, {colSeq:  2, rowspan: 1, valign:"middle"}
									, {colSeq:  3, rowspan: 1, valign:"middle"}
									, {colSeq:  4, rowspan: 1, valign:"middle"}
									, {colSeq:  5, rowspan: 1, valign:"middle"}
									, {colSeq:  6, rowspan: 1, valign:"middle"}
									, {colSeq:  7, rowspan: 1, valign:"middle"}
									, {colSeq:  8, rowspan: 1, valign:"middle"}
									, {colseq: null, colspan: 2, label: "비고", align: "center", valign:"middle"}
								]
							]
                    	};
                    };

                    myGrid.setConfig({
                        targetID: "AXGridTarget",
                        sort: true, //정렬을 원하지 않을 경우 (tip
                        colHeadTool: true, // column tool use
                        fitToWidth: true, // 너비에 자동 맞춤
                        colGroup: getColGroup(),
                        colHead : getColHead(),
                        colHeadAlign: "center", // 헤드의 기본 정렬 값. colHeadAlign 을 지정하면 colGroup 에서 정의한 정렬이 무시되고 colHeadAlign : false 이거나 없으면 colGroup 에서 정의한 속성이 적용됩니다.
                        body: {
                            addClass: function () {
                                return (this.index % 2 == 0 ? "gray" : "white"); // red, green, blue, yellow, white, gray
                            }
                        },
                        page: {
                            display: false,
                            paging: false
                        }
                    });

                    var list = [
						<c:forEach var="category" items="${categoryGrid}" varStatus="idx">
                			{
                				categoryid: "${category.categoryid}",
                				subcount: "${category.subcount}",
                				no: "${category.no}",
                				categoryname1: "${category.categoryname1}", 
                				categoryname2: "${category.categoryname2}",
                				categoryname3: "${category.categoryname3}",
                				copyrightflag: "${category.copyrightflag}",
                				complianceflag: "${category.complianceflag}",
                				openflag: "${category.openflag}",
                				categorylevel: "${category.categorylevel}"
                			} ,
                		</c:forEach>
                    ];
                    
                    if( list == null || list == "" || list == undefined ) {
                    	$("#totalcount").text("0");
                    } else {
                    	$("#totalcount").text( list.length );
                    }
                    
                    myGrid.setList(list);
                    
                }
            }
        };
        
		jQuery(document.body).ready(function () {
			
        	fnObj.pageStart();
        	
        	$("#searchcoursetype").on("change", function(){
        		fn_selectList();
            });
            
        	$("#1stInsert").on("click", function(){
        		if(checkManagerAuth(managerMenuAuth)){return;}
        		var param = {
        			categorytype :  $("#searchcoursetype option:selected").val()
        			, inputtype : "in"
        		};
        		
        		var popParam = {
        			url : "/manager/lms/course/lmsCategoryPop.do"
        			, width : "550"
        			, height : "480"
        			, params : param
        			, targetId : "searchPopup"
        		}
        		window.parent.openManageLayerPopup(popParam);
        	});
        	
        	$("#aDelete").on("click", function(){
        		if(checkManagerAuth(managerMenuAuth)){return;}
        		var checkcategoryid = "";
        		var checkSubCount = "";
        		var checkSubCountCnt = 0;
        		var checkedList = myGrid.getCheckedListWithIndex(0);// colSeq
        		
        		for(var i = 0; i < checkedList.length; i++){
        			if(i == 0){
        				checkSubCount = checkedList[i].item.subcount;
        				if( checkSubCount == "0") {
        					checkcategoryid = checkedList[i].item.categoryid + ",";	
        				} else {
        					checkSubCountCnt ++;
        				}
        			} else {
        				checkSubCount = checkedList[i].item.subcount;
        				if( checkSubCount == "0") {
        					checkcategoryid += checkedList[i].item.categoryid + ",";
        				} else {
        					checkSubCountCnt ++;
        				}
        			}
        		}
    			
        		if( checkcategoryid != "" ) {
    				checkcategoryid = checkcategoryid.substring(0, checkcategoryid.length-1);
    			}
        		if( checkSubCountCnt > 0 ) {
            		if($.trim(checkcategoryid).length == 0){
            			alert("하위 카테고리가 있는 것은 삭제할 수 없습니다.");
            			return;
            		}
        		} else {
            		if($.trim(checkcategoryid).length == 0){
            			alert("선택된 분류가 없습니다.");
            			return;
            		}
        		}
        		
        		var result = confirm("선택한 교육분류를 삭제 하겠습니까?"); 
        		if( result ) {

                	var param = {
                   		searchcoursetype :  $("#searchcoursetype option:selected").val()
                   		, checkcategoryid : checkcategoryid
                   		, inputtype : "del"
                  	};
                   	
                   	$.ajaxCall({
               	   		url: "<c:url value="/manager/lms/course/lmsCategorySaveAjax.do"/>"
               	   		, data: param
               	   		, success: function( data, textStatus, jqXHR){
               	   			if(data.result < 1){
               	           		alert("<spring:message code="errors.load"/>");
               	           		return;
               	   			} else {
               	   				alert("삭제가 완료되었습니다.");
               	   				
               	   				fn_selectList();
               	   			}
               	   		},
               	   		error: function( jqXHR, textStatus, errorThrown) {
               	           	alert("<spring:message code="errors.load"/>");
               	   		}
               	   	});
        		}
            });
        	
			$("#aExcdlDown").on("click", function(){
				var result = confirm("엑셀 내려받기를 시작 하겠습니까?\n 네트워크 상황에 따라서 1~3분 정도 시간이 걸릴 수 있습니다."); 
				if(result) {
					showLoading();
					
					var initParam = {
						searchcoursetype :  $("#searchcoursetype option:selected").val()
					};
					postGoto("/manager/lms/course/lmsCategoryExcelDownload.do", initParam);
					
					hideLoading();
				}
            	
            });
		});
		
    	function fn_subCategory( categoryId, inputtype ) {
    		if(inputtype=='in'){
    			if(checkManagerAuth(managerMenuAuth)){return;}
    		}
    		var param = {
    			categorytype :  $("#searchcoursetype option:selected").val()
       			, categoryid : categoryId
       			, inputtype : inputtype
       		};
        		
       		var popParam = {
       			url : "/manager/lms/course/lmsCategoryPop.do"
       			, width : "550"
       			, height : "480"
       			, params : param
       			, targetId : "searchPopup"
       		}
       		window.parent.openManageLayerPopup(popParam);
    	}
    	
    	function fn_selectList() {
    		var param = {
           		searchcoursetype :  $("#searchcoursetype option:selected").val()
          	};
           	
           	$.ajaxCall({
       	   		url: "<c:url value="/manager/lms/course/lmsCategoryAjax.do"/>"
       	   		, data: param
       	   		, success: function( data, textStatus, jqXHR){
       	   			if(data.result < 1){
       	           		alert("<spring:message code="errors.load"/>");
       	           		return;
       	   			} else {
	       	   			if( data.categoryGrid == null || data.categoryGrid == "" || data.categoryGrid == undefined ) {
	       	   				$("#totalcount").text("0");
	                    } else {
	                    	$("#totalcount").text(data.categoryGrid.length);
	                    }
       	   				
       	   				myGrid.setList(data.categoryGrid);
       	   			}
       	   		},
       	   		error: function( jqXHR, textStatus, errorThrown) {
       	           	alert("<spring:message code="errors.load"/>");
       	   		}
       	   	});
    	}
    	
    </script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">교육분류</h2>
	</div>
	
	<!--search table // -->
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="9%" />
				<col width="*"  />
			</colgroup>
			<tr>
				<th>과정구분</th>
				<td>
					<select id="searchcoursetype" name="searchcoursetype" style="width:auto; min-width:160px" >
						<c:forEach items="${courseTypeList}" var="items">
							<option value="${items.value}" <c:if test="${searchcoursetype == items.value}">selected</c:if>>${items.name}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
		</table>
	</div>
			
	<div class="contents_title clear" style="padding-top:60px;">
		<div class="fl">
			<a href="javascript:;" id="aDelete" class="btn_green" style="vertical-align:middle; margin-left:0px;">삭제</a>
			<a href="javascript:;" id="aExcdlDown" class="btn_excel" style="vertical-align:middle">엑셀 다운</a>
			<span> Total : <span id="totalcount"></span>건</span>			
		</div>
		
		<div class="fr">
			<a href="javascript:;" id="1stInsert" class="btn_green">카테고리 등록</a>
		</div>
	</div>
	
		<!-- grid -->
	<div id="AXGrid">
		<div id="AXGridTarget"></div>
	</div>
			
	<!-- Board List -->
</body>
</html>