<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>
<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>



<script type="text/javascript">	
var d_params = {showTab:"1"};
var frmid = "${param.frmId}";

var kindTabTag1 = "";                                     
kindTabTag1 += '	<select id="searchstamptype">         ';
kindTabTag1 += '		<option value="">선택</option>    ';
kindTabTag1 += '		<option value="N">일반</option>   ';
kindTabTag1 += '		<option value="C">정규과정</option>';
kindTabTag1 += '	</select>                             ';

var kindTabTag2 = "";
kindTabTag2 += '<select id="searchtype" name="searchtype" style="width:auto; min-width:100px" > ';
kindTabTag2 += '<option value="">전체</option>                                                  ';
kindTabTag2 += '<option value="1">스탬프명</option>                                              ';
kindTabTag2 += '<option value="2">스탬프설명</option>                                                 ';
kindTabTag2 += '</select>                                                                       ';

var memberTabTag1 = "";
memberTabTag1 += '	<select id="searchstampid">                                                      ';
memberTabTag1 += '		<option value="">선택</option>                                               ';
<c:forEach items='${stampList}' var='stampList'>
	memberTabTag1 += '			<option value="${stampList.stampid }">${stampList.stampname }</option>   ';
</c:forEach>
memberTabTag1 += '	</select>                                                                        ';

var memberTabTag2 = "";
memberTabTag2 += '<select id="searchtype" name="searchtype" style="width:auto; min-width:100px" > ';
memberTabTag2 += '<option value="">전체</option>                                                  ';
memberTabTag2 += '<option value="1">ABO번호</option>                                              ';
memberTabTag2 += '<option value="2">이름</option>                                                 ';
memberTabTag2 += '</select >                                                                       ';


$(document.body).ready(function(){
	
	//tab초기 설정
	var iniObject = {
			optionValue : "1"
			,optionText : "회원"
			,tabId : "1"
	}
	
	layer.init();
	layer.setViewTab("1",iniObject);
});

var layer = {
		init : function(){
			// 상단 탭
			$("#stampTab").bindTab({
				  theme : "AXTabs"
				, overflow:"visible"
				, value:"1"
				, options:[
					  {optionValue:"1", optionText:"회원", tabId:"1"} 
					, {optionValue:"2", optionText:"스탬프종류", tabId:"2"}
				]
				, onchange : function(selectedObject, value){
					layer.setViewTab(value, selectedObject);
				}
			});
		}, setViewTab : function(value, selectedObject){
			d_params.showTab = value;
			
			// Grid Bind Real
			if(d_params.showTab=="1") {
				//회원 탭페이지 불러오기
			  	$.ajax({
						url: "<c:url value="/manager/lms/advantage/lmsStampMemberList.do"/>"
						, dataType : "text"
						, type : "post"
						, success: function(data)
							{	
								$("#thName").text("스탬프");
								$("#searchSpan1").html(memberTabTag1);
								$("#searchSpan2").html(memberTabTag2);
								$("#stampTabLayer").html(data);
							}
						, error: function()
							{
					           	alert("<spring:message code="errors.load"/>");
							}
				}) ;  
				
			} else if(d_params.showTab=="2") {
				
				
				$.ajax({
						url: "<c:url value="/manager/lms/advantage/lmsStampKind.do"/>"
						, dataType : "text"
						, type : "post"
						, success: function(data)
							{	
								$("#thName").text("구분");
								$("#searchSpan1").html(kindTabTag1);
								$("#searchSpan2").html(kindTabTag2);
								$("#stampTabLayer").html(data);
							}
						, error: function()
							{
					           	alert("<spring:message code="errors.load"/>");
							}
					}) ; 		
			} 
		} // end func setViewTab
	}

</script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">스탬프 랭킹</h2>
	</div>
	
	<!--search table // -->
		<div class="tbl_write">
			<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
				<colgroup>
					<col width="15%" />
					<col width="25%"  />
					<col width="20%" />
					<col width="30%" />
					<col width="10%" />
				</colgroup>
				<tr>
					<th id="thName">스탬프</th>
					<td>
					<span id="searchSpan1">
						<select id="searchstampid">
							<option value="">선택</option>
							<c:forEach items="${stampList}" var="stampList">
								<option value="${stampList.stampid }">${stampList.stampname }</option>
							</c:forEach>
						</select>
					</span>
					</td>
					<th>스탬프 획득일</th>
					<td>
						<input type="text" id="searchstartdate" name="searchstartdate" class="AXInput datepDay" value="${date.searchstartdate }"> ~ 
						<input type="text" id="searchenddate" name="searchenddate" class="AXInput datepDay" value="${date.searchenddate }">
					</td>
					<th rowspan="2">
						<div class="btnwrap mb10">
							<a href="javascript:;" id="btnSearch" class="btn_gray btn_big" style="width:auto; min-width:30px">검색</a>
						</div>
					</th>
				</tr>
				<tr>
					<th>조회</th>
					<td colspan="3">
					<span id="searchSpan2">
						<select id="searchtype" name="searchtype" style="width:auto; min-width:100px" >
							<option value="">전체</option>
							<option value="1">ABO번호</option>
							<option value="2">이름</option>
						</select>
					</span>
						<input type="text" id="searchtext" name="searchtext" style="width:auto; min-width:200px" >
					</td>
				</tr>
			</table>
		</div>
	
	<br/>
	
	<div> >> 스탬프 통계</div>	
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
				<colgroup>
					<col width="20%" />
					<col width="30%"  />
					<col width="20%" />
					<col width="30%" />
				</colgroup>
				<tr>
					<th>스탬프 총수</th>
					<td id="stampCnt">${info.stampcnt }</td>
					<th>회원수</th>
					<td id="memberCnt">${info.membercnt }</td>
				</tr>
		</table>
	</div>
	
	<br/>
	
	<div>>>스탬프 보유현황</div>
	
	<div id="stampTab"></div>
	
	<div id="stampTabLayer"></div>
</body>
</html>





					