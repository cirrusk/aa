<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/mobile/header.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/mobile/layerPop.jsp" %>

<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<!-- //page unique -->
<title>교육비 관리 - ABN Korea</title>

<script type="text/javascript">
	$(document.body).ready(function(){
		var userAgent = navigator.userAgent.toLowerCase();
		
		if (userAgent.search("android") > -1 || userAgent.search("Android") > -1 || userAgent.search("ANDROID") > -1){
			if(userAgent.search("amway") > -1 || userAgent.search("AMWAY") > -1) {
				$("#trainingFeeForm > input[name='app']").val("amway_Android");
			} else {
				$("#trainingFeeForm > input[name='app']").val("Android");
			}			
		} else if ((userAgent.search("iphone") > -1) || (userAgent.search("ipod") > -1) || (userAgent.search("ipad") > -1)){
			$("#trainingFeeForm > input[name='app']").val("Android");
		}
		
		//스크롤 사이즈
		abnkorea_resize();
		
		$(".rowTr").on("click", function(){
			$('.selectTr').removeClass('selectTr');
			$(this).removeClass('rowTr').addClass('selectTr');
		});
		
		$("#helfLayerPop").on("click", function(){
			$('#uiLayerPop_mTFHelp').show();
		});
		
		$(".btnPopCloseEvent").on("click", function(){
			$('#uiLayerPop_mTFHelp').hide();
		});
		
		$(".btnMember").on("click", function(){
			setTimeout(function(){ abnkorea_resize(); }, 500);
		});
		
		
	});
	
	var pageEvent = {
			agreePage : function() {
				$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeeAgreeFull.do")
				$("#trainingFeeForm").submit();
			},
			pfList : function() {
				$("#trainingFeeForm > input[name='pfyear']").val($("#pfyear option:selected").val());
				$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeeIndex.do")
				$("#trainingFeeForm").submit();
			}
	}
	
	var tabEvent = {
			groupTab : function() {
				$("#trainingFeeForm > input[name='procType']").val("group");
				$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeeIndex.do")
				$("#trainingFeeForm").submit();
			},
			personTab : function() {
				$("#trainingFeeForm > input[name='procType']").val("person");
				$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeeIndex.do")
				$("#trainingFeeForm").submit();
			}
	};

	var listEvent = {
			planPage : function(giveyear, givemonth,procType, mode) {
				$("#trainingFeeForm > input[name='giveyear']").val(giveyear);
				$("#trainingFeeForm > input[name='givemonth']").val(givemonth);
				$("#trainingFeeForm > input[name='listDay']").val(givemonth);
				$("#trainingFeeForm > input[name='procType']").val(procType);
				$("#trainingFeeForm > input[name='mode']").val(mode);
				if(mode=="I") $("#trainingFeeForm > input[name='editYn']").val("Y");
				if(mode=="S") $("#trainingFeeForm > input[name='editYn']").val("N");
				$("#trainingFeeForm > input[name='okdata']").val($("#okdata").val().substring(1,$("#okdata").val().length));
				$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeePlan.do")
				$("#trainingFeeForm").submit();
			},
			spendPage : function(giveyear, givemonth,procType, mode) {
				$("#trainingFeeForm > input[name='giveyear']").val(giveyear);
				$("#trainingFeeForm > input[name='givemonth']").val(givemonth);
				$("#trainingFeeForm > input[name='listDay']").val(givemonth);
				$("#trainingFeeForm > input[name='procType']").val(procType);
				$("#trainingFeeForm > input[name='mode']").val(mode);
				if(mode=="I") $("#trainingFeeForm > input[name='editYn']").val("Y");
				if(mode=="S") $("#trainingFeeForm > input[name='editYn']").val("N");
				$("#trainingFeeForm > input[name='okdata']").val($("#okdata").val().substring(1,$("#okdata").val().length));
				$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeeSpend.do")
				$("#trainingFeeForm").submit();
			},
			groupList : function(idno, giveyear, givemonth, groupcode) {
				$("#groupView"+idno).hide();
				$("#groupClose"+idno).show();
				$("."+giveyear+givemonth).show();

			},
			groupListClose : function(idno, giveyear, givemonth) {
				$("#groupView"+idno).show();
				$("#groupClose"+idno).hide();
				$("."+giveyear+givemonth).hide();
				
			},
			uiLayerPop_help01 : function() {
				var popParam = {
						url : "/trainingFee/trainingFeeMainInfoLayerPop.do"
						, width : "600"
						, height : "800"
						, params : {}
				}
				
				openLayerPopup(popParam);
			},
			uiLayerPop_w02 : function(giveyear, givemonth, depaboNo) {
				var popParam = {
						url : "/mobile/trainingFee/trainingFeeMainLayerPop.do"
						, width : "450"
						, height : "400"
						, params : {giveyear  : giveyear
									, givemonth : givemonth
									, depaboNo  : depaboNo}
				}
				
				openLayerPopup(popParam);
			}			
	};
	
</script>
</head>

<body>
	<!-- content area | ### academy IFRAME Start ### -->
<section id="pbContent" class="bizroom">
	<form id="trainingFeeForm" name="trainingFeeForm" method="post">
		<input type="hidden" name="fiscalyear"     value="${scrData.fiscalyear }"    />
		<input type="hidden" name="giveyear"       value="${scrData.giveyear }"      />
		<input type="hidden" name="givemonth"      value="${scrData.givemonth }"     />
		<input type="hidden" name="depaboNo"       value="${scrData.depaboNo }"      />
		<input type="hidden" name="groupCode"      value="${scrData.groupcode }"     />
		<input type="hidden" name="giveopen"       value="${scrData.giveopen }"      />
		<input type="hidden" name="procType"       value="${scrData.procType }"      />
		<input type="hidden" name="delegtypecode"  value="${scrData.delegtypecode }" />
		<input type="hidden" name="editYn"         value=""                          />
		<input type="hidden" name="okdata"         value=""                          />
		<input type="hidden" name="mode"           value=""                          />
		<input type="hidden" name="authgroup"      value="${scrData.authgroup }"     />
		<input type="hidden" name="authperson"     value="${scrData.authperson }"    />
		<input type="hidden" name="authmanageflag" value="${scrData.authmanageflag }"/>
		<input type="hidden" name="pfyear"         value=""                          />
		<input type="hidden" name="app"            value=""                          />
	</form>
	<!-- 교육비 관리 -->
	<div class="mTrainingFee">
	
		<h2 class="titTop">교육비 관리 <a href="javascript:pageEvent.agreePage();" class="btnTbl">교육비동의 관리</a></h2>

		<div class="tabWrap">
			<span class="hide">교육비 관리</span>
			<ul class="tabDepth1 tNum2Line">
				<c:if test="${scrData.procType eq 'group' }">
				<li class="on"><strong>그룹</strong></li>
				<li><a href="javascript:tabEvent.personTab();">개인</a></li>
				</c:if>
				<c:if test="${scrData.procType eq 'person' }">
				<li><a href="javascript:tabEvent.groupTab();">그룹</a></li>
				<li class="on"><strong>개인</strong></li>
				</c:if>
			</ul>
		</div>
		
		<div class="inquiryWrap">
			<div class="inquiryBox">
				<div class="inputBox">
					<p class="selectBox">
						<select title="조회 기간" id="pfyear" onchange="javascript:pageEvent.pfList();">
							<option value="0">등록 가능 기간</option>
							<c:forEach var="pf" items="${pfList}" varStatus="status">
								<option value="${pf.pfyear }" <c:if test="${scrData.pfyear eq pf.pfyear}">selected="selected"</c:if>>${pf.pfyearname}</option>
							</c:forEach>
						</select>
					</p>
				</div>
			</div>
		</div>
		
		<c:if test="${scrData.procType eq 'group' }">
			<c:forEach var="itemp" items="${groupList}" varStatus="status">
				<c:if test="${itemp.giveflag ne 'N'}">
					<c:set var="okdata" value="${okdata }, ${itemp.giveyear}${itemp.givemonth}"></c:set>
				</c:if>
				<div class="articleBox">
					<div class="articleTit">
						<span><strong>${itemp.giveyear}-${itemp.givemonth}<em> / </em>${itemp.trfeetext} </strong>원 <c:if test="${itemp.trfeetype eq 'NOTFOUND'}"><c:if test="${item.btntype ne 'NOT'}"> 예상</c:if></c:if></span>
						<c:choose>
							<c:when test="${scrData.authgroup eq '0' }">
							</c:when>
							<c:otherwise>
								<c:if test="${!empty itemp.groupcode}">
									<a href="javascript:;" class="btnMember">그룹</a>
								</c:if>
							</c:otherwise>
						</c:choose>
					</div>
					<div class="articleCon">
	<%-- 					btntype:${itemp.btntype} planstatus:${itemp.planstatus} giveflag:${itemp.giveflag } giveopen:${scrData.giveopen } --%>
						<ul class="manageStep step${status.index + 1 }">
						<!-- 사전계획서 영역 -->
						<c:if test="${itemp.btntype eq 'PLAN'}">
						<c:choose>
							<c:when test="${scrData.giveopen eq 'Y' and itemp.giveflag ne 'N'}">
								<c:choose>
									<c:when test="${itemp.planstatus eq 'Y'}">
										<li onclick="javascript:listEvent.planPage('${itemp.giveyear}','${itemp.givemonth}','group','S')"><p>사전계획<span>조회</span></p>
											<div class="tailMsg">
												<ul>
													<li>그룹: ${itemp.plangrpamount }원</li>
													<li>차액: ${itemp.plansumamount }원</li>
												</ul>
											</div>
										</li>
										<li><p>지출증빙 <span>-</span></p></li>
									</c:when>
									<c:otherwise>
										<li class="on" onclick="javascript:listEvent.planPage('${itemp.giveyear}','${itemp.givemonth}','group','I')"><p>사전계획<span>등록</span></p>
											<div class="tailMsg">
												<ul>
													<li>그룹: ${itemp.plangrpamount }원</li>
													<li>차액: ${itemp.plansumamount }원</li>
												</ul>
											</div>
										</li>
			  							<li><p>지출증빙 <span>-</span></p></li>
									</c:otherwise>
								</c:choose>
							</c:when>
							<c:when test="${scrData.giveopen eq 'Y' and itemp.giveflag eq 'N'}">
								<c:choose>
									<c:when test="${item.planstatus eq 'Y'}">
										<li onclick="javascript:listEvent.planPage('${itemp.giveyear}','${itemp.givemonth}','group','S')"><p>사전계획<span>조회</span></p></li>
										<li><p>지출증빙 <span>-</span></p></li>
									</c:when>
									<c:otherwise>
										<td>
											<li><p>사전계획 <span>-</span></p></li>
											<li><p>지출증빙 <span>-</span></p></li>	
										</td>
									</c:otherwise>
								</c:choose>
							</c:when>
							<c:when test="${scrData.giveopen eq 'N'}">
								<c:choose>
									<c:when test="${item.planstatus eq 'Y'}">
										<li onclick="javascript:listEvent.planPage('${itemp.giveyear}','${itemp.givemonth}','group','S')"><p>사전계획<span>조회</span></p></li>
										<li><p>지출증빙 <span>-</span></p></li>
									</c:when>
									<c:otherwise>
										<li><p>사전계획 <span>-</span></p></li>
										<li><p>지출증빙 <span>-</span></p></li>
									</c:otherwise>
								</c:choose>	
							</c:when>
							<c:otherwise>
								<li><p>사전계획 <span>-</span></p></li>
								<li><p>지출증빙 <span>-</span></p></li>
							</c:otherwise>
						</c:choose>
						</c:if>
						<c:if test="${itemp.btntype eq 'ALL'}">
						<c:choose>
							<c:when test="${scrData.giveopen eq 'Y' and itemp.giveflag ne 'N'}">
								<c:choose>
									<c:when test="${itemp.planstatus eq 'Y'}">
										<li onclick="javascript:listEvent.planPage('${itemp.giveyear}','${itemp.givemonth}','group','S')"><p>사전계획<span>조회</span></p>
											<div class="tailMsg">
												<ul>
													<li>그룹: ${itemp.plangrpamount }원</li>
													<li>차액: ${itemp.plansumamount }원</li>
												</ul>
											</div>
										</li>
										<c:choose>
											<c:when test="${itemp.spendstatus eq 'Y'}">
												<li onclick="javascript:listEvent.spendPage('${itemp.giveyear}','${itemp.givemonth}','group','S')"><p>지출증빙<span>조회</span></p>
													<div class="tailMsg">
														<ul>
															<li>그룹: ${itemp.grpamount }원</li>
															<li>차액: ${itemp.spandsumamount }원</li>
														</ul>
													</div>
												</li>
											</c:when>
											<c:otherwise>
												<li class="on" onclick="javascript:listEvent.spendPage('${itemp.giveyear}','${itemp.givemonth}','group','I')"><p>지출증빙<span>${itemp.spendcnt}</span></p>
													<div class="tailMsg">
														<ul>
															<li>그룹: ${itemp.grpamount }원</li>
															<li>차액: ${itemp.spandsumamount }원</li>
														</ul>
													</div>
												</li>
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<li class="on" onclick="javascript:listEvent.planPage('${itemp.giveyear}','${itemp.givemonth}','group','I')"><p>사전계획<span>${itemp.plancnt}</span></p>
											<div class="tailMsg">
												<ul>
													<li>그룹: ${itemp.plangrpamount }원</li>
													<li>차액: ${itemp.plansumamount }원</li>
												</ul>
											</div>
										</li>
			  							<li><p>지출증빙 <span>계획필요</span></p></li>
									</c:otherwise>
								</c:choose>
							</c:when>
							<c:when test="${scrData.giveopen eq 'Y' and itemp.giveflag eq 'N'}">
								<c:choose>
									<c:when test="${item.planstatus eq 'Y'}">
										<li onclick="javascript:listEvent.planPage('${itemp.giveyear}','${itemp.givemonth}','group','S')"><p>사전계획<span>조회</span></p></li>
										<c:choose>
											<c:when test="${itemp.spendstatus eq 'Y'}">
												<li onclick="javascript:listEvent.spendPage('${itemp.giveyear}','${itemp.givemonth}','group','S')"><p>지출증빙<span>조회</span></p></li>
											</c:when>
											<c:otherwise>
												<li><p>지출증빙 <span>-</span></p></li>
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<td>
											<li><p>사전계획 <span>-</span></p></li>
											<li><p>지출증빙 <span>-</span></p></li>	
										</td>
									</c:otherwise>
								</c:choose>
							</c:when>
							<c:when test="${scrData.giveopen eq 'N'}">
								<c:choose>
									<c:when test="${item.planstatus eq 'Y'}">
										<li onclick="javascript:listEvent.planPage('${itemp.giveyear}','${itemp.givemonth}','group','S')"><p>사전계획<span>조회</span></p></li>
										<c:choose>
											<c:when test="${itemp.spendstatus eq 'Y'}">
												<li onclick="javascript:listEvent.spendPage('${itemp.giveyear}','${itemp.givemonth}','group','S')"><p>지출증빙<span>조회</span></p></li>
											</c:when>
											<c:otherwise>
												<li class="on" onclick="javascript:listEvent.spendPage('${itemp.giveyear}','${itemp.givemonth}','group','I')"><p>지출증빙<span>등록</span></p>
												<c:if test="${itemp.spendcnt eq '등록중' }">
													<div class="tailMsg">
														<ul>
														<li>그룹: ${itemp.grpamount }원</li>
														<li>개인: ${itemp.peramount }원</li>
														</ul>
													</div>
												</c:if>
												</li>
											</c:otherwise>
										</c:choose>						
									</c:when>
									<c:otherwise>
										<li><p>사전계획 <span>-</span></p></li>
										<li><p>지출증빙 <span>-</span></p></li>
									</c:otherwise>
								</c:choose>	
							</c:when>
							<c:otherwise>
								<li><p>사전계획 <span>-</span></p></li>
								<li><p>지출증빙 <span>-</span></p></li>
							</c:otherwise>
						</c:choose>
						</c:if>
						<c:if test="${itemp.btntype eq 'NOT'}">
							<li><p>사전계획 <span>-</span></p></li>
							<li><p>지출증빙 <span>-</span></p></li>
						</c:if>
						<!-- 사전계획서 영역 end -->
							<li>
							<c:choose>
								<c:when test="${itemp.planstatus eq 'Y' and itemp.spendstatus eq 'Y' }">
									<c:choose>
										<c:when test="${itemp.processstatus eq 'Y' }">
											<p>승인완료 <span>(${itemp.processstatusdt})</span></p>
										</c:when>
										<c:when test="${itemp.processstatus eq 'R' }">
											<p>처리현황 <span>반려</span></p>
										</c:when>
										<c:otherwise>
											<p>처리현황 <span>승인중</span></p>
										</c:otherwise>
									</c:choose>
								</c:when>
								<c:otherwise>
									<p>처리현황 <span>-</span></p>
								</c:otherwise>
							</c:choose>
							</li>
						</ul>
						<c:if test="${!empty itemp.rejecttext}"><p class="listExc">${itemp.rejecttext}</p></c:if>
						<!-- 그룹 리스트  -->
						<c:choose>
							<c:when test="${scrData.authgroup ne '0' }">
								<div class="memberCon">
								<c:forEach var="itemS" items="${groupTargetList}" varStatus="status">
									<c:if test="${itemp.giveyear eq itemS.giveyear and itemp.givemonth eq itemS.givemonth }">
										<dl>
											<dt><span>${itemS.depaboname}(${itemS.depaboNo})<c:if test="${itemS.authmanageflag eq 'Y' }"> / 총무</c:if></span>
												<c:if test="${scrData.authgroup eq '2'}">
												<span class="detailView"><a href="javascript:;" onclick="javascript:listEvent.uiLayerPop_w02('${itemp.giveyear}','${itemp.givemonth}','${itemS.depaboNo}')">상세보기</a></span>
												</c:if>
											</dt>
											<dd><strong>교육비</strong><strong>${itemS.trfeetext}</strong></dd>
											<dd><span>사전계획 차액</span><span>${itemS.planamountsumtext }원</span></dd>
											<dd><span>지출증빙 차액</span><span>${itemS.spandamountsumtext }원</span></dd>
											<dd><span>처리현황</span><span>등록전</span></dd>
										</dl>
									</c:if>
								</c:forEach>
								</div>
							</c:when>
						</c:choose>
					</div>
				</div>
			</c:forEach>
		</c:if>
		<c:if test="${scrData.procType eq 'person' }">
			<c:forEach var="itemp" items="${personList}" varStatus="status">
				<c:if test="${itemp.giveflag ne 'N'}">
					<c:set var="okdata" value="${okdata }, ${itemp.giveyear}${itemp.givemonth}"></c:set>
				</c:if>
				<div class="articleBox">
					<div class="articleTit">
						<span><strong>${itemp.giveyear}-${itemp.givemonth}<em> / </em>${itemp.trfeetext}</strong> 원 <c:if test="${itemp.trfeetype eq 'NOTFOUND'}"> 예상</c:if></span>
						<c:if test="${scrData.authperson eq '2'}">
							<a href="javascript:;" class="btnDetail" onclick="javascript:listEvent.uiLayerPop_w02('${itemp.giveyear}','${itemp.givemonth}','${itemp.depaboNo}')"><span>상세보기</span></a>
						</c:if>
					</div>
					<div class="articleCon">
	<%-- 					btntype:${itemp.btntype} planstatus:${itemp.planstatus} giveflag:${itemp.giveflag } giveopen:${scrData.giveopen } --%>
						<ul class="manageStep step${status.index + 1 }">
						<!-- 사전계획서 영역 -->
						<c:if test="${itemp.btntype eq 'PLAN'}">
						<c:choose>
							<c:when test="${scrData.giveopen eq 'Y' and itemp.giveflag ne 'N'}">
								<c:choose>
									<c:when test="${itemp.planstatus eq 'Y'}">
										<li onclick="javascript:listEvent.planPage('${itemp.giveyear}','${itemp.givemonth}','person','S')"><p>사전계획<span>조회</span></p>
											<div class="tailMsg">
												<ul>
													<li>그룹: ${itemp.plangrpamount }원</li>
													<li>개인: ${itemp.planperamount }원</li>
													<li>차액: ${itemp.plansumamount }원</li>
												</ul>
											</div>
										</li>
										<li><p>지출증빙 <span>-</span></p></li>
									</c:when>
									<c:otherwise>
										<li class="on" onclick="javascript:listEvent.planPage('${itemp.giveyear}','${itemp.givemonth}','person','I')"><p>사전계획<span>${itemp.plancnt}</span></p>
											<div class="tailMsg">
												<ul>
													<li>그룹: ${itemp.plangrpamount }원</li>
													<li>개인: ${itemp.planperamount }원</li>
													<li>차액: ${itemp.plansumamount }원</li>
												</ul>
											</div>
										</li>
			  							<li><p>지출증빙 <span>-</span></p></li>
									</c:otherwise>
								</c:choose>
							</c:when>
							<c:when test="${scrData.giveopen eq 'Y' and itemp.giveflag eq 'N'}">
								<c:choose>
									<c:when test="${item.planstatus eq 'Y'}">
										<li onclick="javascript:listEvent.planPage('${itemp.giveyear}','${itemp.givemonth}','person','S')"><p>사전계획<span>조회</span></p></li>
										<li><p>지출증빙 <span>-</span></p></li>
									</c:when>
									<c:otherwise>
										<td>
											<li><p>사전계획 <span>-</span></p></li>
											<li><p>지출증빙 <span>-</span></p></li>	
										</td>
									</c:otherwise>
								</c:choose>
							</c:when>
							<c:when test="${scrData.giveopen eq 'N'}">
								<c:choose>
									<c:when test="${item.planstatus eq 'Y'}">
										<li onclick="javascript:listEvent.planPage('${itemp.giveyear}','${itemp.givemonth}','person','S')"><p>사전계획<span>조회</span></p></li>
										<li><p>지출증빙 <span>-</span></p></li>
									</c:when>
									<c:otherwise>
										<li><p>사전계획 <span>-</span></p></li>
										<li><p>지출증빙 <span>-</span></p></li>
									</c:otherwise>
								</c:choose>	
							</c:when>
						</c:choose>
						</c:if>
						<c:if test="${itemp.btntype eq 'ALL'}">
						<c:choose>
							<c:when test="${scrData.giveopen eq 'Y' and itemp.giveflag ne 'N'}">
								<c:choose>
									<c:when test="${itemp.planstatus eq 'Y'}">
										<li onclick="javascript:listEvent.planPage('${itemp.giveyear}','${itemp.givemonth}','person','S')"><p>사전계획<span>조회</span></p>
											<div class="tailMsg">
												<ul>
													<li>그룹: ${itemp.plangrpamount }원</li>
													<li>개인: ${itemp.planperamount }원</li>
													<li>차액: ${itemp.plansumamount }원</li>
												</ul>
											</div>
										</li>
										<c:choose>
											<c:when test="${itemp.spendstatus eq 'Y'}">
												<li onclick="javascript:listEvent.planPage('${itemp.giveyear}','${itemp.givemonth}','person','S')"><p>지출증빙<span>조회</span></p>
													<div class="tailMsg">
														<ul>
															<li>그룹: ${itemp.grpamount }원</li>
															<li>개인: ${itemp.peramount }원</li>
															<li>차액: ${itemp.spandsumamount }원</li>
														</ul>
													</div>
												</li>
											</c:when>
											<c:otherwise>
												<li class="on" onclick="javascript:listEvent.spendPage('${itemp.giveyear}','${itemp.givemonth}','person','I')"><p>지출증빙<span>${itemp.spendcnt}</span></p>
													<div class="tailMsg">
														<ul>
															<li>그룹: ${itemp.grpamount }원</li>
															<li>개인: ${itemp.peramount }원</li>
															<li>차액: ${itemp.spandsumamount }원</li>
														</ul>
													</div>
												</li>
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<li class="on" onclick="javascript:listEvent.planPage('${itemp.giveyear}','${itemp.givemonth}','person','I')"><p>사전계획<span>${itemp.plancnt}</span></p>
											<div class="tailMsg">
												<ul>
													<li>그룹: ${itemp.plangrpamount }원</li>
													<li>개인: ${itemp.planperamount }원</li>
													<li>차액: ${itemp.plansumamount }원</li>
												</ul>
											</div>
										</li>
			  							<li><p>지출증빙 <span>계획필요</span></p></li>
									</c:otherwise>
								</c:choose>
							</c:when>
							<c:when test="${scrData.giveopen eq 'Y' and itemp.giveflag eq 'N'}">
								<c:choose>
									<c:when test="${item.planstatus eq 'Y'}">
										<li onclick="javascript:listEvent.planPage('${itemp.giveyear}','${itemp.givemonth}','person','S')"><p>사전계획<span>조회</span></p></li>
										<c:choose>
											<c:when test="${itemp.spendstatus eq 'Y'}">
												<li onclick="javascript:listEvent.spendPage('${itemp.giveyear}','${itemp.givemonth}','person','S')"><p>지출증빙<span>조회</span></p></li>
											</c:when>
											<c:otherwise>
												<li><p>지출증빙 <span>-</span></p></li>
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<td>
											<li><p>사전계획 <span>-</span></p></li>	
											<li><p>지출증빙 <span>-</span></p></li>
										</td>
									</c:otherwise>
								</c:choose>
							</c:when>
							<c:when test="${scrData.giveopen eq 'N'}">
								<c:choose>
									<c:when test="${item.planstatus eq 'Y'}">
										<li onclick="javascript:listEvent.planPage('${itemp.giveyear}','${itemp.givemonth}','person','S')"><p>사전계획<span>조회</span></p></li>
										<c:choose>
											<c:when test="${itemp.spendstatus eq 'Y'}">
												<li onclick="javascript:listEvent.spendPage('${itemp.giveyear}','${itemp.givemonth}','person','S')"><p>지출증빙<span>조회</span></p></li>
											</c:when>
											<c:otherwise>
												<li><p>지출증빙 <span>-</span></p>
												<c:if test="${itemp.spendcnt eq '등록중' }">
													<div class="tailMsg">
														<ul>
														<li>그룹: ${itemp.grpamount }원</li>
														<li>개인: ${itemp.peramount }원</li>
														</ul>
													</div>
												</c:if>
												</li>
											</c:otherwise>
										</c:choose>						
									</c:when>
									<c:otherwise>
										<li><p>사전계획 <span>-</span></p></li>
										<li><p>지출증빙 <span>-</span></p></li>
									</c:otherwise>
								</c:choose>	
							</c:when>
						</c:choose>
						</c:if>
						<c:if test="${itemp.btntype eq 'NOT'}">
							<li><p>사전계획 <span>-</span></p></li>
							<li><p>지출증빙 <span>-</span></p></li>
						</c:if>
						<!-- 사전계획서 영역 end -->
							<li>
							<c:choose>
								<c:when test="${itemp.planstatus eq 'Y' and itemp.spendstatus eq 'Y' }">
									<c:choose>
										<c:when test="${itemp.processstatus eq 'Y' }">
											<p>승인완료 <span>(${itemp.processstatusdt})</span></p>
										</c:when>
										<c:when test="${itemp.processstatus eq 'R' }">
											<p>처리현황 <span>반려</span></p>
										</c:when>
										<c:otherwise>
											<p>처리현황 <span>-</span></p>
										</c:otherwise>
									</c:choose>
								</c:when>
								<c:otherwise>
									<c:choose>
										<c:when test="${itemp.processstatus eq 'R' }">
											<p>처리현황 <span>반려</span></p>
										</c:when>
										<c:otherwise>
											<p>처리현황 <span>-</span></p>
										</c:otherwise>	  													
									</c:choose>									
								</c:otherwise>
							</c:choose>
							</li>
						</ul>
						<c:if test="${!empty itemp.rejecttext}"><p class="listExc">${itemp.rejecttext}</p></c:if>
						
					</div>
				</div>
			</c:forEach>
		</c:if>
		<input type="hidden" value="${okdata }" id="okdata" />
		<ul class="listDot mgtS">
			<li>교육비 예산은 각 다이아몬드 그룹 단위 순매출액의 2%로 산정됩니다.</li>
			<li>사전 교육 계획서를 전월에 선행 하신 후, 지출증빙을 진행 해 주시기 바랍니다.</li>
			<li>문의 시에는 02)3468-6000 으로 연락 주시기 바랍니다.</li>
		</ul>
		<div class="btnWrapL">
			<a href="javascript:;" id="helfLayerPop" class="btnTbl">교육비 항목 도움말</a>
		</div>
	
	</div>
	
	<!-- 교육비 항목 도움말 -->
	<div class="pbLayerPopup fixedFullsize" id="uiLayerPop_mTFHelp" style="display: none; top: 0px;" tabindex="0" aria-hidden="true">
		<div class="pbLayerHeader">
			<strong>교육비 항목 도움말</strong>
		</div>
		<div class="pbLayerContent" style="height: 881px; overflow: auto;">
			<div class="mTF_pop">
				<h3>교육비예산</h3><!-- @edit 20160803 -->
				<p>교육비 예산은 각 다이아몬드 그룹 단위 순매출액의 2%로 산정되며, 확정전에는 최근 교육비를 예상값으로 사전계획을 수립하시면 됩니다.</p>
				
				<h3>사전계획</h3>
				<p>지출증빙을 위한 필수 단계입니다.</p> 
				<p>각 단계는 다음의 경우에 발생됩니다.</p>
				<ul class="listDash">
				<li>- 계획조회 : 계획이 완료된 단계로 수립한 계획 조회 가능</li>
				<li>- [등록] : 계획 수립이 필요한 경우 발생</li>
				<li>- 등록중 : 계획을 수립중이나 완료되지 않은 단계에서 발생</li>
				</ul>
				
				<h3>지출증빙</h3>
				<p>사전계획이 수립된 경우에만 가능하며, 영수증이 필요합니다.</p>
				<ul class="listDash">
				<li>- 지출조회 : 지출증빙이 완료된 단계로 제출한 증빙 조회 가능</li>
				<li>- [등록] : 지출증빙이 필요한 경우 발생</li>
				<li>- 등록중 : 지출증빙중이나 완료되지 않은 단계에서 발생</li>
				</ul>
				
				<h3>처리현황</h3>
				<p>지출증빙 제출 후 처리현황을 알려드립니다.</p>
				<ul class="listDash">						
				<li>- " – " : 지출증빙 제출 불가 단계</li>
				<li>- 등록 : 처리 대상이나 사전계획/지출증빙이 등록 전</li>
				<li>- 등록전 : 등록은 하였으나 제출 전</li>
				<li>- 제출완료 : 지출증빙까지 제출 후 접수한 단계</li>
				<li>- 승인중 : 등록 후 (담당자 확인 중)</li>
				<li>- 승인완료(승인일자)  : 등록 후 승인완료시 발생</li>
				</ul>
			</div>
			<div class="btnWrap aNumb1 pdNone2">
				<a href="#none" class="btnBasicGL btnPopCloseEvent">닫기</a>
			</div>
		</div>
		<a href="#none" class="btnPopClose btnPopCloseEvent"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
	</div>
	<!-- //교육비 항목 도움말 -->
	
	<!-- //교육비 관리 -->	
</section>
	<!-- //content area | ### academy IFRAME End ### -->
		
<!-- 	<div class="skipNaviReturn"> -->
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>
