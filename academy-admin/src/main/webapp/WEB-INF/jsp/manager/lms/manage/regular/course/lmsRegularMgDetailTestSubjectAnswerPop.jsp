<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>



<script type="text/javascript">

var saveClickCheck = 0;


function prevAndNext(type)
	{	
		var nextUid = 0;
		var uidList = $("#uidList").val().substring(1,$("#uidList").val().length-1);
		var uidArr = uidList.split(",");
		
		var curUid = $("#curUid").val();
		var curIndex = 0;
		var nextIndex = 0;	
			for(i=0; i<uidArr.length;i++){
				if(uidArr[i].trim() == curUid){
					curIndex =  i;
				}
			}
			if(type=="P"){
				nextIndex = curIndex - 1;
			}else{
				nextIndex = curIndex + 1;
			}
			if( nextIndex < 0 ){
				alert("첫번째 수험생 입니다.");
				return;
			}
			if( nextIndex >= uidArr.length){
				alert("마지막 수험생 입니다.");
				return;
			}
			
			var data = {
				courseid : "${param.courseid}"
				,stepcourseid : "${param.stepcourseid}"
				,uid : uidArr[nextIndex].trim()
				,uidlist : uidArr
				,coursename : "${param.coursename}"
			}
				
			 $.ajax({
					url: "<c:url value="/manager/lms/manage/regular/course/lmsRegularMgDetailTestSubjectAnswerPopChange.do"/>"
						, data:  data
						, dataType : "text"
						, type : "post"
							, success: function(data){
								
								$("#subjectAnswer").html($(data).filter("#subjectAnswer").html());
								$("#info").html($(data).filter("#info").html());
							},
							error: function() {
					           	alert("<spring:message code="errors.load"/>");
							}
			 
				}) ; 
	}
	
function checkSave(type)
{
	var size = $("#frm").serializeArray().length/9;
	var check = false;
	
	for(var i=0;i<size;i++)
		{	
			if($("#subjectpoint"+i).val() == $("#beforeSubjectpoint"+i).val())
				{
					check = true;
		
				}
		}
	
	if(check)
		{
			saveClickCheck = 1;
		}
	
	
	if(saveClickCheck == 0)
		{
			if(confirm("평가 점수를 저장하지 않았습니다.\r\n이동하시겠습니까?"))
				{
					prevAndNext(type);
				}
		}
	else if(saveClickCheck == 1)
		{
					prevAndNext(type);
		}
	
	saveClickCheck = 0;
}

$(document).ready(function(){

	$("#nextBtn").on("click",function(){
		checkSave("N");
	});
	
	//이전버튼
	$("#preBtn").on("click",function(){
		checkSave("P");
	});
	
	$("#saveBtn").on("click",function(){
		//점수가 배점보다 높은지 check할 것
		var size = $("#frm").serializeArray().length/9;
		
		var check = false;
		
		for(var i=0;i<size;i++)
		{	
			if( !isNumber($("#subjectpoint"+i).val()) ) {
				alert("점수를 숫자로 입력하세요.");
				return;
			}
			
			if( parseInt($("#subjectpoint"+i).val()) > parseInt($("#testpoolpoint"+i).val()) )
			{
				return alert("입력된 점수가 배점보다 높은게 있습니다.");
			}
		}
		
		if( !confirm("점수를 저장하시겠습니까?")) {
			return;
		}
		
		//입력된 점수 저장
		$.ajaxCall({
	   		url: "<c:url value="/manager/lms/manage/regular/course/lmsRegularMgDetailEachSubjectPointUpdate.do"/>"
	   		, data: $("#frm").serialize()
	   		, success: function( data, textStatus, jqXHR){
	        		alert("저장완료하였습니다.");
	        		saveClickCheck = 1;
	   		},
	   		error: function( jqXHR, textStatus, errorThrown) {
	           	alert("<spring:message code="errors.load"/>");
	           	alert("error"+textStatus);
	   		}
	   	}); 
	});
	
});

</script>

<body class="bgw">
<input type="hidden" id="uidList" value="${uidlist }"/> 

<div id="popwrap">
<!--pop_title //-->
<div class="title clear">
		<h2 class="fl">주관식 개별 채점</h2>
		<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
	</div>
	
	<!-- Contents -->
	<div id="popcontainer"  style="height:430px">
		<div id="popcontent">
			
			
			<div class="tbl_write">
			<span id="info">
				<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
					<colgroup>
						<col width="15%"  />
						<col width="15%" />
						<col width="10%" />
						<col width="15%" />
						<col width="10%" />
						<col width="13%" />
						<col width="10%" />
						<col width="12%" />
					</colgroup>
					<tr>
						<th>시험명</th>
						<td colspan="7">
							${param.coursename }
						</td>
					</tr>
					<tr>
						<th>총인원</th>
						<td colspan="3">${info.totalcount }</td>
						<th>채점완료</th>
						<td colspan="3">${info.markedcount }</td>
					</tr>
					<tr>
						<th>이름</th>
						<td>${info.name }</td>
						<th>총점</th>
						<td>${info.totalpoint }</td>
						<th>주관식</th>
						<td>${info.subjectpoint }</td>
						<th>객관식</th>
						<td>${info.objectpoint }</td>
						
					</tr>
				</table>
				</span>
			</div>
				<br/>
				<div class="contents_title clear">
					<div class="fl">
						<a href="javascript:;" id="preBtn" class="btn_green"> 이전</a>
					</div>
					<div class="fr">
						<a href="javascript:;" id="nextBtn" class="btn_green"> 다음</a>
					</div>
				</div>
				
				<form id="frm" name="frm" method="post" enctype="multipart/form-data">
				<span id="subjectAnswer">
					<input type="hidden" id="curUid" name="uid" value="${param.uid }"/> 
					<input type="hidden" name="stepcourseid" value="${stepcourseid }">
					<input type="hidden" name="stepseq" value="${param.stepseq }">
					<input type="hidden" name="courseid" value="${param.courseid }">
				<div class="tbl_write">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
						<col width="10%"  />
						<col width="15%" />
						<col width="50%" />
						<col width="10%" />
						<col width="15%" />
					</colgroup>
					<tr>
						<th>NO</th>
						<th colspan="2">문제 / 답변</th>
						<th>배점</th>
						<th>점수</th>
					</tr>
						<c:forEach items="${subjectlist }" var="subjectlist"  step="1"  varStatus="status">
								<tr>
									<th rowspan="3">
										${subjectlist.no }
									</th>
									<th>문제</th>
									<td>
										${subjectlist.testpoolname }<br/>
									</td>
									<td rowspan="3">${subjectlist.testpoolpoint }</td>
										<td rowspan="3"><input type="text" name="subjectpoints" id="subjectpoint${status.index }"  value="${subjectlist.point }"/></td>
										<input type="hidden" name="beforeSubjectpoint" id="beforeSubjectpoint${status.index }"  value="${subjectlist.point}"/>
										<input type="hidden" name="testpoolpoints" id="testpoolpoint${status.index }"  value="${subjectlist.testpoolpoint }"/>
										<input type="hidden" name="answerseqs"  value="${subjectlist.answerseq }"/>
										<input type="hidden" name="testpoolids"  value="${subjectlist.testpoolid }"/>
								</tr>
									<tr><th>모범답안</th><td> ${subjectlist.subjectanswer }</td></tr>
									<tr><th>응시자 답안</th><td> ${subjectlist.studentsubjectanswer }</td></tr>
						</c:forEach>
					</table>
				</div>
				</span>
				</form>
				<div align="center">
					<a href="javascript:;" id="saveBtn" class="btn_green"> 저장</a>
					<a href="javascript:;" id="closeBtn" class="btn_green close-layer"> 닫기</a>
				</div>
	</div>
</div>
</div>
</div>
</body>
</html>