<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>설문 결과</title>
</head>
<script type="text/javascript">

$(document).ready(function(){
	
	
	// 엑셀다운 버튼 클릭시
	$("#aExcdlDown").on("click", function(){
		var result = confirm("엑셀 내려받기를 시작 하시겠습니까?\n 네트워크 상황에 따라서 1~3분 정도 시간이 걸릴 수 있습니다."); 
		if(result) {
			showLoading();
			var initParam = {
					stepcourseid : "${param.stepcourseid}"
			};
			postGoto("/manager/lms/manage/regular/lmsRegularMgSurveyExcelDownload.do", initParam);
			hideLoading();
		}
	});	
});

</script>
<body>
	<br/>
	<div class="contents_title clear">
		<div class="fl">
			<a href="javascript:;" id="aExcdlDown" class="btn_excel" style="vertical-align:middle">엑셀 다운</a>
		</div>
	</div>
	
	
	<div class="tbl_write">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
						<col width="10%"  />
						<col width="40%" />
						<col width="10%"  />
						<col width="20%" />
						<col width="10%"  />
						<col width="10%" />
					</colgroup>
					<tr>
						<th>NO</th>
						<th>질문</th>
						<th>척도평균</th>
						<th>답변</th>
						<th>답변수</th>
						<th>선택비율</th>
					</tr>
						<c:forEach  items="${surveyList }" var="surveyList"  step="1" >
							<tr>
								<td>${surveyList.surveyseq }</td>
								<td>${surveyList.surveyname }</td>
								<td>${surveyList.avgsamplevalue }</td>
								<td colspan="3" >
									<table id="tblSearch" width="100%" cellspacing="0" cellpadding="0">
										<colgroup>
											<col width="50%"  />
											<col width="25%" />
											<col width="25%" />
										</colgroup>
										<c:if test="${surveyList.surveytype == 1 or surveyList.surveytype ==2 }">
												<c:forEach items="${sampleObjectList }" var="sampleObjectList">
													<c:if test="${sampleObjectList.surveyseq == surveyList.surveyseq }">
														<tr>
															<td>${sampleObjectList.sampleseq } ) ${sampleObjectList.samplename }</td>
															<td>${sampleObjectList.cnt }</td>
															<td>${sampleObjectList.pct } %</td>
														</tr>
													</c:if>
												</c:forEach>
										</c:if>
										<c:if test="${surveyList.surveytype == 3 or surveyList.surveytype == 4 }">
											<c:forEach items="${sampleSubjectList }" var="sampleSubjectList">
												<c:if test="${sampleSubjectList.surveyseq == surveyList.surveyseq }">
													<tr>
														<td colspan="3">
															${sampleSubjectList.subjectresponse }
														</td>
													</tr>
												</c:if>
											</c:forEach>
										</c:if>
									</table>
								</td>
							</tr>
						</c:forEach>
					</table>
				</div>
</body>
</html>