<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	

var seatListGrid = new AXGrid(); // instance 상단그리드
var frmid = "${param.frmId}";
var rowcount = 0;
var first = true;
//Grid Default Param
var defaultParam = {
sortColKey: "lms.offline.list"
};

$(document.body).ready(function(){
	
	seatList.init();
	seatList.doSearch();
	myIframeResizeHeight(frmid);
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		seatList.doSearch();
	});
	
	//샘플파일다운로드 클릭시
	$("#sampleBtn").on("click",function(){
		var result = confirm("엑셀 내려받기를 시작 하겠습니까?\n 네트워크 상황에 따라서 1~3분 정도 시간이 걸릴 수 있습니다."); 
		if(result) {
			showLoading();
			var initParam = {
				exceltype : "registerseat"		
			};
			
			$.extend(defaultParam, initParam);
			
			postGoto("<c:url value="/manager/lms/manage/offline/lmsRegisterSeatSampleExcelDownload.do"/>", defaultParam);
			hideLoading();
		}
	});
	
	//저장버튼 클릭시
	$("#insertBtn").on("click", function(){
		
		//권한체크함수
		if(checkManagerAuth($("#managerMenuAuth").val())){return;}
		
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
		
		if(rowcount != 0){
			if( !confirm("기존 좌석이 모두 리셋 됩니다. 그래도 진행하시겠습니까?") ) {
				return;
			}
		}else{
			if( !confirm("좌석을 엑셀파일로 추가하시겠습니까?") ) {
				return;
			}
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
	
});


//엑셀 좌석 등록
function saveSubmit(){
	var param = $("#frm").serialize();
	$.ajaxCall({
   		url : "<c:url value="/manager/lms/manage/offline/lmsOfflineMgSeatRegisterExcelAjax.do"/>"
   		, data : param
   		, type: 'POST'
        , contentType: 'application/x-www-form-urlencoded; charset=UTF-8'
   		, success: function( data, textStatus, jqXHR){
				if(data.logcontent != "" && data.logcontent != null)
				{
					alert(data.logcontent);
				}
			$("#resultArea").show();	
			$("#successCount").html(data.successcount);
			$("#failCount").html(data.failcount);
			$("#logcontent").val( data.logcontent );
			seatList.doSearch();
   		},
   		error: function( jqXHR, textStatus, errorThrown) {
           	alert("<spring:message code="errors.load"/>");
           	return;
   		}
   	});
}


		//블럭 상태 해제 또는 블럭
		 function goUpdate(seatseq,seatuseflag)
		{
			//권한체크함수
			if(checkManagerAuth($("#managerMenuAuth").val())){return;}
				
			$.ajaxCall({
				url: "<c:url value="/manager/lms/manage/offline/lmsOfflineMgSeatUpdateAjax.do"/>"
				, data: "courseid="+$("#courseid").val()+"&seatseq="+seatseq+"&seatuseflag="+seatuseflag
				, success: function(data, textStatus, jqXHR){
					seatList.doSearch();
				},
				error: function( jqXHR, textStatus, errorThrown) {
		           	alert("<spring:message code="errors.load"/>");
				}
			});
		} 


			/* 교육신청자 관리 탭 구성 */
			var seatList = {
					/** init : 초기 화면 구성 (Grid)
					*/		
					init : function() {
						var idx = 0; // 정렬 Index 
						var _colGroup = [
											 {key:"no1", label:"No.", width:"50", align:"center", sort:false}
											, {key:"seatseq1", display:false}
											, {key:"seatnumber1", label:"좌석번호", width:"150", align:"center", sort:false }
											, {key:"seattype1", label:"등급", width:"100", align:"center", sort:false}
											, {
												key:"seatflag1", label:"상태", width:"150", align:"center", sort:false, formatter: function(){
												
													if(this.item.seatflag1 == "N")
														{
															return "<a href=\"javascript:;\" class=\"btn_gray\" onclick=\"javascript:goUpdate('"+this.item.seatseq1+"','Y');\">해제</a>";
														}
													else if(this.item.seatflag1 == "Y")
														{
															return "<a href=\"javascript:;\" class=\"btn_green\" onclick=\"javascript:goUpdate('"+this.item.seatseq1+"','N');\">블럭</a>";
														}
													else if(this.item.seatflag1 == "A")
														{
															return "<span>배정</span>";
														}
													
												}
											}
											, {key:"no2", label:"No.", width:"50", align:"center", sort:false}
											, {key:"seatseq2", display:false}
											, {key:"seatnumber2", label:"좌석번호", width:"150", align:"center", sort:false }
											, {key:"seattype2", label:"등급", width:"100", align:"center", sort:false}
											, {
												key:"seatflag2", label:"상태", width:"150", align:"center", sort:false, formatter: function(){
												
													if(this.item.seatflag2 == "N")
														{
														return "<a href=\"javascript:;\" class=\"btn_gray\" onclick=\"javascript:goUpdate('"+this.item.seatseq2+"','Y');\">해제</a>";
														}
													else if(this.item.seatflag2 == "Y")
														{
														return "<a href=\"javascript:;\" class=\"btn_green\" onclick=\"javascript:goUpdate('"+this.item.seatseq2+"','N');\">블럭</a>";
														}
													else if(this.item.seatflag2 == "A")
														{
															return "<span>배정</span>";
														}
													
												}
											}
											, {key:"no3", label:"No.", width:"50", align:"center",  sort:false}
											, {key:"seatseq3", display:false}
											, {key:"seatnumber3", label:"좌석번호", width:"150", align:"center", sort:false }
											, {key:"seattype3", label:"등급", width:"100", align:"center", sort:false}
											, {
												key:"seatflag3", label:"상태", width:"150", align:"center", sort:false, formatter: function(){
														
														if(this.item.seatflag3 == "N")
															{
															return "<a href=\"javascript:;\" class=\"btn_gray\" onclick=\"javascript:goUpdate('"+this.item.seatseq3+"','Y');\">해제</a>";
															}
														else if(this.item.seatflag3 == "Y")
															{
															return "<a href=\"javascript:;\" class=\"btn_green\" onclick=\"javascript:goUpdate('"+this.item.seatseq3+"','N');\">블럭</a>";
															}
														else if(this.item.seatflag3 == "A")
															{
																return "<span>배정</span>";
															}
														
													}
												}
										]
						var gridParam = {
								colGroup : _colGroup
								, fitToWidth: false
			 					//, fixedColSeq: 3
								, colHead : { heights: [25,25]}
								, targetID : "AXGridTarget_Seat"
								, height : "400px"
							}
			
						fnGrid.nonPageGrid(seatListGrid, gridParam);
					}, doSearch : function() {
						
						// Param 셋팅(검색조건)
						 var initParam = {
								 searchseattype : $("#searchseattype").val()	
							  , searchseatuseflag : $("#searchseatuseflag").val()
							  , courseid : "${courseid}"
							  , searchseatnum : $("#searchseatnum").val()
						}; 
						
						$.extend(defaultParam, initParam);
						
						$.ajaxCall({
					   		url: "<c:url value="/manager/lms/manage/offline/lmsOfflineMgDetailSeatRegisterAjax.do"/>"
					   		, data: defaultParam
					   		, success: function( data, textStatus, jqXHR){
					   			if(data.result < 1){
					        		alert("<spring:message code="errors.load"/>");
					        		alert("success"+data);
					        		return;
								} else {
									callbackList(data);
									$("#totalcount").text(data.totalcount);
									if(first){
										first = false;
										rowcount = data.totalcount;
									}
								}
					   		},
					   		error: function( jqXHR, textStatus, errorThrown) {
					           	alert("<spring:message code="errors.load"/>");
					           	alert("error"+textStatus);
					   		}
					   	});
			
					   	function callbackList(data) {
					   		 
					   		var obj = data; //JSON.parse(data);
					   		// Grid Bind
					   		var gridData = {
								list: obj.dataList
								}
					   		// Grid Bind Real
					   		seatListGrid.setData(gridData);
					   		
					   		$("#AXGridTarget_Seat_AX_gridPageBody").hide();
					   	}
			}
}
</script>
</head>

<body class="bgw">
	<form id="frm" name="fileform" method="post" enctype="multipart/form-data">
		<input type="hidden" id="courseid"  name="courseid" value="${courseid }">
		<input type="hidden" id="seatregisterexcelfile" name="seatregisterexcelfile" value="" title="" />
			<div class="tbl_write">

			<div> >> 좌석 엑셀 등록</div>
				<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
					<colgroup>
						<col width="25%"  />
						<col width="75%" />
					</colgroup>
					<tr>
						<th>등록</th>
						<td>
							<input type="file" id="seatregisterexcel" name="seatregisterexcel"  class="required"  accept=".xlsx,.xls" title="첨부파일" style="width:auto; min-width:200px" required="required">
							<a href="javascript:;" id="insertBtn" class="btn_excel">엑셀 업로드</a>
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
				</table>
	</form>
				
				</br>
				<div> >> 좌석 목록</div>
				<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
					<colgroup>
						<col width="11%" />
						<col width="16%"  />
						<col width="11%" />
						<col width="16%" />
						<col width="11%" />
						<col width="25%" />
						<col width="10%" />
					</colgroup>
					<tr>
						<th>좌석등급</th>
						<td>
							<select id="searchseattype" name="searchseattype">
								<option value="">선택</option>
								<option value="V">VIP</option>
								<option value="N">일반</option>
							</select>
						</td>
						<th>상태</th>
						<td>
							<select id="searchseatuseflag" name="searchseatuseflag" style="width:auto; min-width:100px" >
								<option value="">선택</option>
								<option value="A">배정</option>
								<option value="N">블럭</option>
								<option value="Y">해제</option>
							</select>
						</td>
						<th>좌석 번호 </th>
						<td><input type="text" id="searchseatnum" name="searchseatnum" style="width:auto; min-width:200px" ></td>
						<td>
							<div class="btnwrap mb10">
								<a href="javascript:;" id="btnSearch" class="btn_gray btn_big" style="width:auto; min-width:30px">검색</a>
							</div>
						</td>
					</tr>
				</table>
				</br>
				<div class="contents_title clear">
					<span> Total : <span id="totalcount"></span>건</span>
				</div>
			
			<!-- axisGrid -->
				<div id="AXGrid">
					<div id="AXGridTarget_Seat"></div>
				</div>
</div>
</body>
