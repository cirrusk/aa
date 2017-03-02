<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

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
