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
		
		if(uidArr.length <= 1)
			{
				alert("더 이상 설문을 제출한 신청자가 없습니다");
			}
		else
			{	
				if(type == 'N')
					{
						for(var i = 0; i<uidArr.length;i++)
							{
								if(curUid == uidArr[i].trim())
									{
										if(i == uidArr.length-1)
											{
												nextUid = 0;
											}
										else
											{
												nextUid = i+1;
											}
									}
							}
					}
				else if(type == 'P')
				{
					for(var i = 0; i<uidArr.length;i++)
					{
						if(curUid == uidArr[i].trim())
							{
								if(i == 0)
									{
										nextUid = uidArr.length-1;
									}
								else
									{
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
					url: "<c:url value="/manager/lms/manage/regular/course/lmsRegularMgDetailSurveyResponsePopChange.do"/>"
						, data:  data
						, dataType : "html"
						, type : "post"
							, success: function(data){
								$("#surveyAnswer").html($(data).filter("#surveyAnswer").html());
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
		<h2 class="fl">개인별 설문 결과</h2>
		<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
	</div>
	


	<!-- Contents -->
	<div id="popcontainer"  style="height:430px">
		<div id="popcontent">
			<div class="tbl_write">
			<span id="info">
				<input type="hidden" id="uidList" value="${uidlist }"/> 
				<input type="hidden" id="uid" value="${param.uid }"/> 
				<input type="hidden" id="stepcourseid"  name="stepcourseid" value="${param.stepcourseid }">
				<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
					<colgroup>
						<col width="22%"  />
						<col width="28%" />
						<col width="22%" />
						<col width="28%" />
					</colgroup>
					<tr>
						<th>ABO번호</th>
						<td>${param.uid }</td>
						<th>이름</th>
						<td>${param.name }</td>
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
				<span id="surveyAnswer">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="15%" />
							<col width="45%"  />
							<col width="30%" />
							<col width="10%" />
						</colgroup>
						<tr>
							<th>NO</th>
							<th>질문</th>
							<th>답변</th>
							<th>척도점수</th>
						</tr>
						<c:forEach items="${responseList1 }" var="responseList1">
							<tr>
								<td>${responseList1.surveyseq }</td>
								<td>${responseList1.surveyname }</td>
								<c:if test="${responseList1.surveytype == 1}">
									<td>
										${responseList1.objectresponse } ) ${responseList1.samplename }
										<c:if test="${not empty responseList1.opinioncontent }">
											<br/>${responseList1.opinioncontent }
										</c:if>
									</td>
									<td>${responseList1.samplevalue }</td>
								</c:if>
								<c:if test="${responseList1.surveytype == 2}">
									<td colspan="2">
										<table id="tblSearch"  width="100%" border="0" cellspacing="0" cellpadding="0">
											<colgroup>
												<col width="76%" />
												<col width="24%" />
											</colgroup>
											<c:forEach items="${responseList2 }" var="responseList2">
													<c:if test="${responseList2.surveyseq eq responseList1.surveyseq }">
														<tr>
															<td>${responseList2.objectresponse} ) ${responseList2.samplename }</td>
															<td>${responseList2.samplevalue }</td>
														</tr>
													</c:if>
											</c:forEach>
										</table>
									</td>
								</c:if>
								<c:if test="${responseList1.surveytype == 3 or responseList1.surveytype ==4}">
									<td>
										${responseList1.subjectresponse }
									</td>
									<td> </td>
								</c:if>
							</tr>
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