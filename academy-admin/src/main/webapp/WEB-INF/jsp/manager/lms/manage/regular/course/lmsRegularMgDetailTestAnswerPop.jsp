<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>



<script type="text/javascript">

function prevAndNext(type)
	{	
		var nextUid = 0;
		var uidList = $("#uidList").val().substring(1,$("#uidList").val().length-1);
		var uidArr = uidList.split(",");
		var curUid = $("#uid").val();
		
		if(uidArr.length <= 1) {
			alert("더 이상 시험을 친 신청자가 없습니다");
		} else {
			if(type == 'N') {
				for(var i = 0; i<uidArr.length;i++) {
					if( curUid == uidArr[i].trim() ) {
						if(i == uidArr.length-1) {
							nextUid = 0;
						} else {
							nextUid = i+1;
						}
					}
					
				}
			} else if(type == 'P') {
				for(var i = 0; i<uidArr.length;i++) {
					if(curUid == uidArr[i].trim()) {
						if(i == 0) {
							nextUid = uidArr.length -1;
						} else {
							nextUid = i-1;
						}
					}
				}
			}
			
			var data = {
				stepcourseid : $("#stepcourseid").val()
				,uid : uidArr[nextUid].trim()
				,uidlist : uidArr
			}
			
			 $.ajax({
				url: "<c:url value="/manager/lms/manage/regular/course/lmsRegularMgDetailTestAnswerPopChange.do"/>"
					, data:  data
					, dataType : "html"
					, type : "post"
						, success: function(data){
							$("#testAnswer").html($(data).filter("#testAnswer").html());
							$("#info").html($(data).filter("#info").html());
						},
						error: function() {
				           	alert("<spring:message code="errors.load"/>");
						}
		 
			}) ; 
		}
	}

$(document).ready(function(){

	$("#nextBtn").on("click",function(){
		prevAndNext("N");
	});
	
	$("#preBtn").on("click",function(){
		prevAndNext("P");
	});
	
	
});

</script>

<body class="bgw">

<div id="popwrap">
<!--pop_title //-->
<div class="title clear">
		<h2 class="fl">개인별 시험 답안지</h2>
		<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
	</div>
	
	<!-- Contents -->
	<div id="popcontainer"  style="height:430px">
		<div id="popcontent">
			<div class="tbl_write">
			<span id="info">
			<input type="hidden" id="uidList" value="${uidlist }"/> 
			<input type="hidden" id="uid" value="${param.uid }"/> 
			<input type="hidden" id="stepcourseid"  name="stepcourseid" value="${stepcourseid }">
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
							${info.coursename }
						</td>
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
				
				<div class="tbl_write">
				<span id="testAnswer">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
						<col width="25%"  />
						<col width="75%" />
					</colgroup>
					<tr>
						<th>NO</th>
						<th>질문</th>
					</tr>
					
						<c:forEach items="${testlist }" var="testList"  step="1">
							<c:if test="${testList.answertype eq '1'}">
								<tr>
									<th rowspan="3">
										${testList.no }
									</th>
									<td>
										${testList.testpoolname }<br/>
										<c:forEach items="${answerlist}" var="answerList">
											<c:if test="${testList.testpoolid eq answerList.testpoolid }">
												${answerList.testpoolanswerseq } ) ${answerList.testpoolanswername } <br/>
											</c:if>
										</c:forEach>
									</td>
								</tr>
								<tr><td>정답 : ${testList.objectanswer }</td></tr>
								<tr><td>입력 답 : ${testList.studentobjectanswer }</td></tr>
							</c:if>
							<c:if test="${testList.answertype eq '2'}">
								<tr>
									<th rowspan="3">
										${testList.no }
									</th>
									<td>
										${testList.testpoolname }<br/>
										<c:forEach items="${answerlist}" var="answerList">
											<c:if test="${testList.testpoolid eq answerList.testpoolid }">
												${answerList.testpoolanswerseq } ) ${answerList.testpoolanswername } <br/>
											</c:if>
										</c:forEach>
									</td>
								</tr>
								<tr><td>정답 : ${testList.objectanswer }</td></tr>
								<tr><td>입력 답 : ${testList.studentobjectanswer }</td></tr>
							</c:if>
							<c:if test="${testList.answertype eq '3' }">
								<th rowspan="3">
									${testList.no }
								</th>
								<td>
									${testList.testpoolname }<br/>
								</td>
								</tr>
								<tr><td>정답 : ${testList.subjectanswer }</td></tr>
								<tr><td>입력 답 : ${testList.studentsubjectanswer }</td></tr>
							</c:if>
						</c:forEach>
					</table>
					</span>
				</div>
			
				<div class="contents_title clear">
					<div align="center">
						<a href="javascript:;" id="closeBtn" class="btn_green close-layer"> 닫기</a>
					</div>
				</div>
	</div>
</div>
</div>
</div>
</body>
</html>