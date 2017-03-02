<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

		<div id="info">
		<input type="hidden" id="uidList" value="${uidlist }"/>
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
			</div>
			
			<div id="subjectAnswer">
					<input type="hidden" id="curUid"  name="uid" value="${param.uid }"/> 
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
</div>