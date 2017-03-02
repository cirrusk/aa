<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>

<html>
<head>
<title></title>
<script type="text/javascript">
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
};
/**
 * 설정
 */
doInitializeLocal = function() {
	
	forDetail = $.action();
	forDetail.config.formId = "FormList";
	forDetail.config.url    = "<c:url value="/univ/course/active/quiz/answer/list.do"/>";
};

/**
 * 상세보기 화면을 호출하는 함수
 */
doDetail = function(mapPKs) {
	UT.getById(forDetail.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
	forDetail.run();
};


</script>
</head>

<body>
	<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	
	    <input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>" />
	    <input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
	    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
	    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
		<input type="hidden" name="srchClassificationCode"  value="" />
		<input type="hidden" name="courseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
	</form>

 	<table id="listTable" class="tbl-detail mt10">
	    <colgroup>
	        <col style="width: 120px" />
	        <col />
	        <col />
	        <col />
	        <col />
	        <col />
	        <col />
	        <col />
	        <col />
	        <col />
	    </colgroup>
	    <tbody>
	    	<tr>
	    		<th>08:30 ~ 08:40</th>
	    		<td colspan="90">
	    			<a href="#" onclick="doDetail({'srchClassificationCode' : 'A'});">Opening</a>
    			</td>
	    	</tr>
	    	<tr>
	    		<th rowspan="2">08:40 ~ 10:00</th>
	    		<td colspan="90">
	    			<a href="#" onclick="doDetail({'srchClassificationCode' : 'G1'});">LG CEO 특강 『시장선도 실행력 확보를 위한 LG HR의 방향』 <br>하현회 사장님</a>
				</td>
	    	</tr>
	    	<tr>
	    		<td colspan="90">
	    			<a href="#" onclick="doDetail({'srchClassificationCode' : 'G2'});">LG CEO 특강 『시장선도 실행력 확보를 위한 LG HR의 방향』 <br>이웅범 사장님</a>
	    		</td>
	    	</tr>
	    	<tr>
	    		<th>10:15 ~ 11:40</th>
	    		<td colspan="90">
	    			<a href="#" onclick="doDetail({'srchClassificationCode' : 'M'});">
	    				Mega Trend 세션<br/>『패러다임 전환기 HR의 미래 준비』
	    			</a>
				</td>
	    	</tr>
	    	<tr>
	    		<th>11:50 ~ 11:55</th>
	    		<td colspan="90">
	    			<a href="#" onclick="doDetail({'srchClassificationCode' : 'D'});">
	    				회장 격려사
    				</a>
				</td>
	    	</tr>
	    	<tr>
	    		<th>12:00 ~ 13:10</th>
	    		<td colspan="90">
	    			<a href="#" onclick="doDetail({'srchClassificationCode' : 'E'});">
	    				중식
    				</a>
				</td>
	    	</tr>
	    	<tr>
	    		<th rowspan="5">13:20 ~ 14:05</th>
	    		<td colspan="90" class="align-c">
	    			LG HR 프랙티스 발표 세션
				</td>
	    	</tr>
	    	<tr>
	    		<td colspan="10" class="align-c">H1</td>
	    		<td colspan="10" class="align-c">H2</td>
	    		<td colspan="10" class="align-c">H3</td>
	    		<td colspan="10" class="align-c">H4</td>
	    		<td colspan="10" class="align-c">H5</td>
	    		<td colspan="10" class="align-c">H6</td>
	    		<td colspan="10" class="align-c">H7</td>
	    		<td colspan="10"  class="align-c">H8</td>
	    		<td colspan="10" class="align-c">H9</td>
	    	</tr>
	    	<tr>
	    		<td colspan="10" class="align-c">
	    			<a href="#" onclick="doDetail({'srchClassificationCode' : 'H1'});">
	    				해외 생산법인 인력유연화<br/> 프로세스 구축
    				</a>
				</td>
				<td colspan="10" class="align-c"> 
	    			<a href="#" onclick="doDetail({'srchClassificationCode' : 'H2'});">
	    				Learning 3.0 Ⅱ<br/>
						(Corporate 차원의 Flipped Learning 전개)
					</a>

				</td>
				<td colspan="10" class="align-c">
	    			<a href="#" onclick="doDetail({'srchClassificationCode' : 'H3'});">
	    				전략적 HR 실행을 지원하는 <br/>HR Analytics 2.0
					</a>
				</td>
				<td colspan="10" class="align-c">
	    			<a href="#" onclick="doDetail({'srchClassificationCode' : 'H4'});">
	    				신사업 성공을 위한 HR집중 지원<br/>(OLED 사업 지원 사례)
					</a>
				</td>
				<td colspan="10" class="align-c">
	    			<a href="#" onclick="doDetail({'srchClassificationCode' : 'H5'});">
	    				Global HR의 Lessons and Learned <br/> (중국 생산법인을 중심으로)
					</a>
				</td>
				<td colspan="10" class="align-c">
	    			<a href="#" onclick="doDetail({'srchClassificationCode' : 'H6'});">
	    				20년을 넘어 100년 영속을 향한<br/> LG디스플레이 노동조합 USR
    				</a>
				</td>
				<td colspan="10" class="align-c">
	    			<a href="#" onclick="doDetail({'srchClassificationCode' : 'H7'});">
	    				조직진단형 퇴직면담을 통한 <br/>Issue 발굴 및 해결 사례
    				</a>
				</td>
				<td colspan="10" class="align-c">
	    			<a href="#" onclick="doDetail({'srchClassificationCode' : 'H8'});">
	    				현장변혁을 위한 신임리더 역량 <br/> 및 조직 내 소통 강화
    				</a>
				</td>
				<td colspan="10" class="align-c">
	    			<a href="#" onclick="doDetail({'srchClassificationCode' : 'H9'});">
	    			사업 실행력 강화를 위한 <br/>해외주재원 사전 선발·육성 프로그램</a>
				</td>
	    	</tr>
	    	<tr>
	    		<td colspan="10" class="align-c">H10</td>
	    		<td colspan="10" class="align-c">H11</td>
	    		<td colspan="10" class="align-c">H12</td>
	    		<td colspan="10" class="align-c">H13</td>
	    		<td colspan="10" class="align-c">H14</td>
	    		<td colspan="10" class="align-c">H15</td>
	    		<td colspan="10" class="align-c">H16</td>
	    		<td colspan="10" class="align-c">H17</td>
	    		<td colspan="10" class="align-c">H18</td>
	    	</tr>
	    	<tr>
	    		<td colspan="10" class="align-c">
	    			<a href="#" onclick="doDetail({'srchClassificationCode' : 'H10'});">
	    				Integrating Perspectives in Global <br/> Organizations for Culture Transformation
    				</a>
				</td>
				<td colspan="10" class="align-c"> 
	    			<a href="#" onclick="doDetail({'srchClassificationCode' : 'H11'});">
	    				Pre에서 Pro-MR로(국내 영업인력 확보에서 조기전력화 System까지)
    				</a>
				</td>
				<td colspan="10" class="align-c"> 
	    			<a href="#" onclick="doDetail({'srchClassificationCode' : 'H12'});">
	    				새로운 학습모델 구축을 위한 Reading Odyssey 사례
    				</a>
				</td>
				<td colspan="10" class="align-c">
	    			<a href="#" onclick="doDetail({'srchClassificationCode' : 'H13'});">
	    				환경을 살리는 청소년 습관교육 ‘빌려쓰는 지구 스쿨’ 
    				</a>
				</td>
				<td colspan="10" class="align-c">
	    			<a href="#" onclick="doDetail({'srchClassificationCode' : 'H14'});">
    					HR System 변화를 통한 성과주의 강화(중국인 몸에 맞는 현지형 HR옷 입히기)
   					</a>
				</td>
				<td colspan="10" class="align-c">
	    			<a href="#" onclick="doDetail({'srchClassificationCode' : 'H15'});">
	    				협력사 노경이슈 대응사례 및 시사점
    				</a>
				</td>
				<td colspan="10" class="align-c">
	    			<a href="#" onclick="doDetail({'srchClassificationCode' : 'H16'});">
	    				시장선도를 위한 B2C 영업 교육 (경쟁사가 배우려 하고 따라 하는 소매역량 강화)
    				</a>
				</td>
				<td colspan="10" class="align-c">
	    			<a href="#" onclick="doDetail({'srchClassificationCode' : 'H17'});">
    					채용정책과 사업전략 변화에  Fit되는 신입사원 기술역량 확보 메커니즘 실행
   					</a>
				</td>
				<td colspan="10" class="align-c">
	    			<a href="#" onclick="doDetail({'srchClassificationCode' : 'H18'});">
	    				건설 기술력 강화를 위한 다기능엔지니어(MFE) 육성사례
    				</a>
				</td>
	    	</tr>
	    	<tr>
	    		<th rowspan="3">14:20 ~ 15:35</th>
	    		<td colspan="90" class="align-c">
	    			외부 프랙티스 발표 세션
				</td>
	    	</tr>
	    	<tr>
	    		<td colspan="15" class="align-c">E1</td>
	    		<td colspan="15" class="align-c">E2</td>
	    		<td colspan="15" class="align-c">E3</td>
	    		<td colspan="15" class="align-c">E4</td>
	    		<td colspan="15" class="align-c">E5</td>
	    		<td colspan="15" class="align-c">E6</td>
	    	</tr>
	    	<tr>
	    		<td colspan="15" class="align-c">
	    			<a href="#" onclick="doDetail({'srchClassificationCode' : 'E1'});">
	    				사업성과 창출을 Drive한 듀폰의 HR 혁신 사례
    				</a>
				</td>
	    		<td colspan="15" class="align-c">
	    			<a href="#" onclick="doDetail({'srchClassificationCode' : 'E2'});">
	    			저성장 시대, 사업성과 창출을 위한 21세기 글로벌 전략
    				</a>
				</td>
	    		<td colspan="15" class="align-c"><a href="#" onclick="doDetail({'srchClassificationCode' : 'E3'});">
	    			실행이 강한 조직과 리더는 <br/>어떻게 만들어 지는가?</a>
</td>
	    		<td colspan="15" class="align-c"><a href="#" onclick="doDetail({'srchClassificationCode' : 'E4'});">
	    			Social Recruiting의 이해 및 <br/>실무 활용방안 모색
</a>
</td>
	    		<td colspan="15" class="align-c"><a href="#" onclick="doDetail({'srchClassificationCode' : 'E5'});">고령화 시대의 HR과제와 
전문가 역할</a>
</td>
	    		<td colspan="15" class="align-c"><a href="#" onclick="doDetail({'srchClassificationCode' : 'E6'});">Big Data 시대의 도래, 
HR Innovation</a>
</td>
	    	
	    	</tr>
	    	<tr>
	    		<th rowspan="3">15:40 ~ 17:00</th>
	    		<td colspan="90" class="align-c">
	    			패널 디스커션
				</td>
	    	</tr>
	    	<tr>
	    		<td colspan="18" class="align-c">P1</td>
	    		<td colspan="18" class="align-c">P2</td>
	    		<td colspan="18" class="align-c">P3</td>
	    		<td colspan="18" class="align-c">P4</td>
	    		<td colspan="18" class="align-c">P5</td>
	    	</tr>
	    	<tr>
	    		<td colspan="18" class="align-c"><a href="#" onclick="doDetail({'srchClassificationCode' : 'P1'});">
	    			LG의 차세대 성장 엔진 사업분야의 성공을 위한 <br/>Talent Management 이슈

				</td>
	    		<td colspan="18" class="align-c"><a href="#" onclick="doDetail({'srchClassificationCode' : 'P2'});">중국 사업 성공을 위한 HR 과제</a>
				</td>
	    		<td colspan="18" class="align-c"><a href="#" onclick="doDetail({'srchClassificationCode' : 'P3'});">저성장기 Turnaround를 위한 LG성과주의 점검</a> 
				</td>
	    		<td colspan="18" class="align-c"><a href="#" onclick="doDetail({'srchClassificationCode' : 'P4'});">“김대리 생각” <br/> HR Junior들의 고민거리 공유 및 <br/>HR 선배와의 대화
	    		</a>
</td>
	    		<td colspan="18" class="align-c"><a href="#" onclick="doDetail({'srchClassificationCode' : 'P5'});">“이대리 노하우” <br/> HR Junior들의 업무 노하우 공유</a>
</td>
	    	</tr>
	 	</tbody>
    </table>
	<Br/>
</body>
</html>