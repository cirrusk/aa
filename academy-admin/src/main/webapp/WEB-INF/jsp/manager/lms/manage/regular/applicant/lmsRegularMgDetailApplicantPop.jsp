<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	
//Grid Init
var eduApplicantGrid = new AXGrid(); // instance 상단그리드

var g_params = {showTab:1};

//Grid Default Param
var defaultParam = {
	  page: 1
 	, rowPerPage: 20
 	, sortColKey: "lms.offline.list"
 	, sortIndex: 0
 	, sortOrder:"DESC"
};

var obj;
var apListHtml = "";
var apseq = [];
var apname = [];

<c:forEach items="${aplist}" var="aplist" varStatus="status">
	apseq["${status.index}"] = "${aplist.apseq}";
	apname["${status.index}"] = "${aplist.apname}";
</c:forEach> 

 <c:forEach items="${aplist}" var="aplist" >
	apListHtml += "<option value='${aplist.apseq }'>${aplist.apname }</option>";
</c:forEach> 
	
$(document.body).ready(function(){
	
	//grid Data reload Bind
	$(document).on("change",".AXSelectBox",function(){
		
		var idx = $(this).attr("id");
		var startNum = idx.indexOf("_")+1;
		var gridIdx = idx.substring(startNum,idx.length);
		
		for(var i = 0; i<obj.dataList.length;i++)
			{
				if(obj.dataList[i].no == gridIdx)
					{
						obj.dataList[i].togetherrequestflag = $("#togetherrequestflag_"+gridIdx).val();
					}
			}
	});
	
	//grid Data reload Bind
	$(document).on("change",".AXApseqSelectBox",function(){
		var idx = $(this).attr("id");
		var startNum = idx.indexOf("_")+1;
		var gridIdx = idx.substring(startNum,idx.length);
		
		for(var i = 0; i<obj.dataList.length;i++)
			{
				if(obj.dataList[i].no == gridIdx)
					{
						obj.dataList[i].apseq = $("#apseq_"+gridIdx).val();
					}
			}
	});
	
	$("#divTabPage2").hide();
	
	layer.init();
	//eduApplicantList.doSearch({page:1});
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		eduApplicantList.doSearch({page:1});
	});
	
	$("#rowPerPage").on("change", function(){
		eduApplicantList.doSearch({page:1, rowPerPage : $("#rowPerPage").val() });
	});
	
	//추가버튼 클릭시
	$("#registerBtn").on("click",function(){
			gridEvent.chkInsert();
	});
	
	//샘플파일다운 클릭시
	$("#sampleBtn").on("click", function(){
		var result = confirm("엑셀 내려받기를 시작 하겠습니까?\n 네트워크 상황에 따라서 1~3분 정도 시간이 걸릴 수 있습니다."); 
		if(result) {
			showLoading();
			var initParam = {
				exceltype : "addapplicant"		
			};
			$.extend(defaultParam, initParam);
			postGoto("<c:url value="/manager/lms/manage/regular/applicant/lmsAddApplicantSampleExcelDownload.do"/>", defaultParam);
			hideLoading();
		}
	});	
	
	//등록버튼 클릭시
	$("#btnRegister").on("click", function(){
		var fileYn = false;
		var fileExt = "";
		$( "input:file" ).each(function( index ){
			if($( this ).val().length>0 ){
				fileYn = true;
				var _lastDot = $( this ).val().lastIndexOf('.');
				fileExt = $( this ).val().substring(_lastDot+1, $( this ).val().length).toLowerCase();
			}
		});
		
		if(!fileYn){
			alert("등록할 엑셀파일을 선택하세요.");
			return;
		}
		if( fileExt != "xlsx" && fileExt != "xls" ) {
			alert("엑셀파일만 입력하세요.");
			return;
		}
		
		if( !confirm("교육생을 엑셀파일로 추가하시겠습니까?") ) {
			return;
		}
		
		$("#frm").ajaxForm({
			dataType:"json",
			data:{mode:"excel"},
			url:'/manager/lms/common/lmsFileUploadAjax.do',
			beforeSubmit:function(data, form, option){
				return true;
			},
	        success: function(result, textStatus){
	        	
	        	for(i=0; i<result.length;i++){
	        		$("#"+result[i].fieldName+"file").val(result[i].FileSavedName);
	        	}
	        	saveSubmit();
	        },
	        error: function(){
	           	alert("파일업로드 중 오류가 발생하였습니다.");
	           	return;
	        }
		}).submit();
	});
	
	//로그보기 버튼 클릭시
	$("#logBtn").on("click", function(){
		$("#logcontent_area").show();
	});
	
	$("#confirmBtn").on("click", function(){
		if( $("#successCount").html() != "0" && $("#successCount").html() != "" ) {
			var iniObject = {
				optionValue : "U2"
				,optionText : "교육신청자"
				,tabId : "U2"
			}
			$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.layer.setViewTab("U2",iniObject);
		}
		closeManageLayerPopup("addApplicantPop");
	});
});


//엑셀파일 등록 로직
function saveSubmit(){
	var param = $("#frm").serialize();
	
	if(apListHtml != "")
		{
			param += "&checkkey=T";
			checkKey = "T";
		}
	else
		{
			param += "&checkkey=F";
			checkKey = "F";
		}
	
	$.ajaxCall({
   		url : "<c:url value="/manager/lms/manage/regular/applicant/lmsRegularMgAddApplicantExcelAjax.do"/>"
   		, timeout : 1000 * 120
   		, data : param
   		, type: 'POST'
        , contentType: 'application/x-www-form-urlencoded; charset=UTF-8'
   		, success: function( data, textStatus, jqXHR){
   			if(data.cnt == "0"){
   				alert("오류 발생으로 리스트가 업로드 되지 않았습니다.\n정규과정 리스트 업로드 시 오류가 발생하면 전체 리스트가 등록되지 않습니다.");
   			}else{
   				alert(data.comment+data.cnt + "건이 추가 되었습니다.");
   			}
   			$("#resultArea").show();
			$("#successCount").html(data.successcount);
			$("#failCount").html(data.failcount);
			$("#logcontent").val( data.logcontent );
   		},
   		error: function( jqXHR, textStatus, errorThrown) {
           	alert("<spring:message code="errors.load"/>");
           	return;
   		}
   	});
}

var layer = {
		init : function(){
			// 상단 탭
			$("#divLmsOfflineMgDetailTab").bindTab({
				  theme : "AXTabs"
				, overflow:"visible"
				, value: 1
				, options:[
					  {optionValue:"1", optionText:"개별등록", tabId:"1"} 
					, {optionValue:"2", optionText:"엑셀업로드", tabId:"2"}
				]
				, onchange : function(selectedObject, value){
					layer.setViewTab(value, selectedObject);
				}
			});
			// 초기 화면 셋팅
			eduApplicantList.init();
		}, setViewTab : function(value, selectedObject){
			$("#tabLayer .tabView").hide();
			$("#divTabPage" + value).show();
			g_params.showTab = value;
			
			// Grid Bind Real
			if(g_params.showTab=="1") {
			} else if(g_params.showTab=="2") {
			} 
		} // end func setViewTab
	}



/* 교육신청자 관리 탭 구성 */
var eduApplicantList = {
		/** init : 초기 화면 구성 (Grid)
		*/	
		
		
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
								{key:"uid", width:"40", align:"center", formatter:"checkbox", formatterlabel:"", sort:false, checked:function(){
								    return this.item.___checked && this.item.___checked["1"];
								}}
								, {key:"no", label:"No.", width:"50", align:"center", formatter:"money", sort:false}
								, {key:"uid", label:"ABO 번호", width:"120", align:"center"}
								, {key:"name", label:"이름", width:"150", align:"center"}
								, {key:"pincode", label:"핀레벨", width:"120", align:"center"}
								, {key:"groups", label:"핀레벨코드값", display:false}
								, {key:"togetherflag", display:false}
								, {key:"partnerinfossn", display:false}
								, {		
										key: "apseq", label : "교육장소", width: "180", align: "center", sort: false, formatter: function () {
											if(apListHtml==""){
												return "<span>해당없음</span><select id='apseq_"+this.item.no.number()+"' style='display:none;min-width:100px'><option value=''>AP 선택</option></select>";
											}else{
													var selectTag2 = "";
													selectTag2 += "<select id='apseq_"+this.item.no.number()+"' class='AXApseqSelectBox' style='min-width:100px'> <option value=''>AP 선택</option>";
													
													for(var i = 0 ;i<apseq.length;i++)
														{
															if(this.item.apseq == apseq[i])
																{
																	selectTag2 +=  "<option value='"+apseq[i]+"' selected>"+apname[i]+"</option>";
																}
															else
																{
																	selectTag2 +=  "<option value='"+apseq[i]+"'>"+apname[i]+"</option>";
																}
														}
													
													selectTag2 += "</select>";
													return selectTag2;
											}
													
										}
									}
								, {		
										key: "togetherrequestflag", label : "부사업자 신청", width: "180", align: "center", sort: false, formatter: function () {
												if(this.item.togetherflag == "Y")
													{
														if(this.item.partnerinfossn == null || this.item.partnerinfossn == "")
															{
																return "<span>부사업자없음</span>";
															}
														else
															{	
																if(this.item.togetherflag == "" || this.item.togetherflag == "N")
																	{
																		return "해당없음";
																	}
																else
																	{
																		if(this.item.togetherrequestflag == "Y")
																			{
																				var selectTag = "";
																				selectTag += "<select id='togetherrequestflag_"+this.item.no.number()+"' class='AXSelectBox' name='togetherrequestflag' style='min-width:100px'>";
																				selectTag += "<option value='N'>미신청</option>                           ";
																				selectTag += "<option value='Y' selected>신청</option>                             ";
																				selectTag += "</select>  ";
																				
																				return selectTag;
																			}
																		else
																			{
																				var selectTag = "";
																				selectTag += "<select id='togetherrequestflag_"+this.item.no.number()+"' class='AXSelectBox' name='togetherrequestflag' style='min-width:100px'>";
																				selectTag += "<option value='N' selected>미신청</option>                           ";
																				selectTag += "<option value='Y'>신청</option>                             ";
																				selectTag += "</select>  ";
																				
																				return selectTag;
																			}
																	}
															}
													}
												else
													{
														return "<span>해당없음</span>";
													}
										}
									}
								, {key:"requestflagyn", label:"신청여부", width:"100", align:"center"}
							]
			var gridParam = {
					colGroup : _colGroup
					, fitToWidth: false
 					//, fixedColSeq: 3
					, colHead : { heights: [25,25]}
					, targetID : "AXGridTarget_Applicant"
					, sortFunc : eduApplicantList.doSortSearch
					, doPageSearch : eduApplicantList.doPageSearch
				}

			fnGrid.initGrid(eduApplicantGrid, gridParam);
		}, doPageSearch : function(pageNo) {
			// Grid Page List
			eduApplicantList.doSearch({page:pageNo});
		}, doSortSearch : function(){
			var sortParam = getParamObject(eduApplicantGrid.getSortParam()+"&page=1");
			defaultParam.sortOrder = sortParam.sortWay; 
			// 리스트 갱신(검색)
			eduApplicantList.doSearch(sortParam);
		}, doSearch : function(param) {
			
			// Param 셋팅(검색조건)
			 var initParam = {
					searchpinlevel : $("#searchpinlevel").val()	
				  , searchmemberinfo : $("#searchmemberinfo").val()
				  , courseid : "${detail.courseid}"
				  , searchtext : $("#searchtext").val()
			}; 
			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);
			$.ajaxCall({
		   		url: "<c:url value="/manager/lms/manage/regular/applicant/lmsRegularMgDetailApplicantPopAjax.do"/>"
		   		, data: defaultParam
		   		, success: function( data, textStatus, jqXHR){
		   			if(data.result < 1){
		        		alert("<spring:message code="errors.load"/>");
		        		alert("success"+data);
		        		return;
					} else {
						callbackList(data);
					}
		   		},
		   		error: function( jqXHR, textStatus, errorThrown) {
		           	alert("<spring:message code="errors.load"/>");
		           	alert("error"+textStatus);
		   		}
		   	});

		   	function callbackList(data) {
		   		 
		   		obj = data; //JSON.parse(data);
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
		   		$("#totalcount").text(obj.totalCount);
		   		// Grid Bind Real
		   		eduApplicantGrid.setData(gridData);
		   		
		   		
		   	}
			
		}

	}

//수강생 신청
var gridEvent = {
		chkInsert : function() {
			
			var test = true;
			
			// 선택 정보 추가전 메세지 출력
			var listIdx = eduApplicantGrid.getCheckedListWithIndex(0);
			var len = listIdx.length;

			if(len == 0){
				alert("선택된 회원이 없습니다.");
				return;
			}
			
			//데이터 조립
			var arrUid = [];
			var arrPincode = [];
			var arrTogetherRequestFlag = [];
			var arrApSeq = [];
			
			
			for(var i = 0; i<len;i++)
			{	
				arrApSeq[i] = listIdx[i].item.apseq;
				arrUid[i] = listIdx[i].item.uid;
				arrPincode[i] = listIdx[i].item.groups;
			}
			
			
			var data =
				{
					uids : arrUid
					,pincodes : arrPincode
					,courseid : $("#courseid").val()
					,apseqs : arrApSeq
				};
			
			 var result = confirm("선택한 회원을 추가하시겠습니까?"); 
			 
 		  if(result) {
		 	if(apListHtml != "")
		 		{
	 			  for(var i = 0; i<data.apseqs.length;i++)
	 				  {
	 				  		if(data.apseqs[i] == "")
	 				  			{
	 				  				return alert("교육장소를 선택해주세요");
	 				  			}
	 				  }
		 		}
 			  if(listIdx[0].item.togetherflag == "Y")
 				 {	
 				 	
 				 	for(var i = 0;i<len;i++)
 				 		{	
 				 			if(listIdx[i].item.partnerinfossn == null || listIdx[i].item.partnerinfossn == "")
 				 				{
 				 					arrTogetherRequestFlag[i] = "";
 				 				}
 				 			else
 				 				{
									arrTogetherRequestFlag[i] = listIdx[i].item.togetherrequestflag;
 				 					
 				 				}
 				 		}
 				 }
 			 else
 				 {
	 				 	for(var i = 0;i<len;i++)
	 				 		{
								arrTogetherRequestFlag[i] = "";
	 				 		}
 				 }
 			 
			 	var extendData = {
			 			togetherrequestflags : arrTogetherRequestFlag 
			 			,togetherflag : listIdx[0].item.togetherflag
			 				};
 			 
 				$.extend(data,extendData);
				$.ajaxCall({
					url: "<c:url value="/manager/lms/manage/regular/applicant/lmsRegularMgApplicantAddAjax.do"/>"
					, data: data
					, success: function(data, textStatus, jqXHR){
						
						var iniObject = {
								optionValue : "U2"
								,optionText : "교육신청자"
								,tabId : "U2"
						}
						
						$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.layer.setViewTab("U2",iniObject);
						alert(data.comment+data.cnt + "건이 추가 되었습니다.");
						closeManageLayerPopup("addApplicantPop");
					},
					error: function( jqXHR, textStatus, errorThrown) {
			           	alert("<spring:message code="errors.load"/>");
					}
				});
			}     
		}
}
	
</script>
</head>

<body class="bgw">
<input type="hidden" id="courseid" value="${detail.courseid }">
<div id="popwrap">
<!--pop_title //-->
<div class="title clear">
		<h2 class="fl">교육신청자 추가</h2>
		<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
	</div>
	
	<!-- Contents -->
	<div id="popcontainer"  style="height:430px">
		<div id="popcontent">
	
	
	<div id="divLmsOfflineMgDetailTab"></div>
	
	<div id="tabLayer">
		<div id="divTabPage1" class="tabView">
			<div class="tbl_write">
				<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
					<colgroup>
						<col width="15%" />
						<col width="20%"  />
						<col width="10%" />
						<col width="40%" />
						<col width="15%" />
					</colgroup>
					<tr>
						<th>핀레벨</th>
						<td>
							<select id="searchpinlevel" name="searchpinlevel">
								<option value="">선택</option>
								<c:forEach items="${pincodelist}" var="pincodelist">
									<option value="${pincodelist.targetcodeseq }"> ${pincodelist.casetwo } </option>
								</c:forEach>
							</select>
						</td>
						<th>조회</th>
						<td>
							<select id="searchmemberinfo" name="searchmemberinfo" style="width:auto; min-width:100px" >
								<option value="">전체</option>
								<option value="1">ABO번호</option>
								<option value="2">이름</option>
							</select>
							<input type="text" id="searchtext" name="searchtext" style="width:auto; min-width:160px" >
						</td>
						<td>
							<div class="btnwrap mb10">
								<a href="javascript:;" id="btnSearch" class="btn_gray btn_big" style="width:auto; min-width:30px">검색</a>
							</div>
						</td>
					</tr>
				</table>
				
				<div class="contents_title clear">
					<div class="fl">
						<select id="rowPerPage" name="rowPerPage" style="width:auto; min-width:100px"> 
							<option value="20">20</option>
							<option value="50">50</option>
							<option value="500">500</option>
							<option value="1000">1000</option>
						</select>
						
						<span> Total : <span id="totalcount"></span>건</span>
					</div>
				</div>
				
				
				<!-- axisGrid -->
				<div id="AXGrid">
					<div id="AXGridTarget_Applicant"></div>
				</div>
				
				<br/>
				
					<div align="center">
						<a href="javascript:;" id="registerBtn" class="btn_green">저장</a>
						<a href="javascript:;" id="closeBtn" class="btn_green close-layer">취소</a>
					</div>
		</div>
	</div>
	
	
	<div id="divTabPage2" class="tabView">
	<form id="frm" name="fileform" method="post" enctype="multipart/form-data">
		<input type="hidden" id="togetherflag"  name="togetherflag" value="${detail.togetherflag }">
		<input type="hidden" id="courseid"  name="courseid" value="${detail.courseid }">
		<input type="hidden" id="addapplicantexcelfile" name="addapplicantexcelfile" value="" title="" />
			<div class="tbl_write">
				<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
					<colgroup>
						<col width="25%"  />
						<col width="75%" />
					</colgroup>
					<tr>
						<th>과정명</th>
						<td>
							${detail.coursename }
						</td>
					</tr>
					<tr>
						<th>엑셀파일</th>
						<td>
							<input type="file" id="addapplicantexcel" name="addapplicantexcel"  class="required"  accept=".xlsx,.xls" title="첨부파일" style="width:auto; min-width:200px" required="required">
							<a href="javascript:;" id="btnRegister" class="btn_excel">엑셀 업로드</a>
							<a href="javascript:;" id="sampleBtn" class="btn_excel">샘플 다운</a>
						</td>
					</tr>
					<tr>
						<th>업로드 결과</th>
						<td style="height:25px;">
							<span id="resultArea" style="display:none;">
							성공 : <span id="successCount"></span>건, 오류: <span id="failCount"></span>건  <a href="javascript:;" id="logBtn" class="btn_green"> 로그보기</a>
							</span>
						</td>
					</tr>
					<tr id="logcontent_area" style="display:none;">								
						<th>로그내역</th>
						<td style="height:150px;">
							<textarea id="logcontent" name="logcontent" class="AXInput" style="width:90%;height:150px;" readonly="readonly"></textarea>
						</td>
					</tr>
					<tr>
						<th>부사업자신청</th>
						<td>
							Y 또는 N 입력 ( Y.신청함 N.신청안함 ) 
						</td>
					</tr>
					<tr>
						<th>교육장소</th>
						<td>
						<c:choose>
							<c:when test="${not empty aplist }">
								<c:forEach items="${aplist}"  var="aplist" ><span>${aplist.apname } : ${aplist.apseq } &nbsp;&nbsp;</span></c:forEach>
							</c:when>
							<c:otherwise>
								<span>해당없음</span>
							</c:otherwise>
						</c:choose>
						</td>
					</tr>
				</table>
				<br/>
				<div align="center">
					<a href="javascript:;" id="confirmBtn" class="btn_green close-layer">닫기</a>
				</div>
			</div>	
	</form>
	</div>
	</div>
</div>
</div>
</div>
</div>


<!-- apList -->
</body>