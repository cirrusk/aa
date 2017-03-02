<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>

<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<!-- //page unique -->
<title>교육비 관리 - ABN Korea</title>
		
<script type="text/javascript">
	$(document.body).ready(function(){
		//스크롤 사이즈
		abnkorea_resize();
		
		$(".rowTr").on("click", function(){
			$('.selectTr').removeClass('selectTr');
			$(this).removeClass('rowTr').addClass('selectTr');
		});
	});
	
	var pageEvent = {
			agreePage : function() {
				$("#trainingFeeForm").attr("action", "${pageContext.request.contextPath}/trainingFee/trainingFeeAgreeFull.do")
				$("#trainingFeeForm").submit();
			},
			pfList : function() {
				$("#trainingFeeForm > input[name='pfyear']").val($("#pfyear option:selected").val());
				$("#trainingFeeForm").attr("action", "${pageContext.request.contextPath}/trainingFee/trainingFeeIndex.do")
				$("#trainingFeeForm").submit();
			}
	}
	
	var tabEvent = {
			groupTab : function() {
				$("#groupTab").show();
				$("#personTab").hide();
				$("#trainingFeeForm > input[name='procType']").val("group");
				$('#groupTabClass').removeClass('logTabSection').addClass('logTabSection on');
				$('#personTabClass').removeClass('logTabSection on').addClass('logTabSection');
			},
			personTab : function() {
				$("#groupTab").hide();
				$("#personTab").show();
				$("#trainingFeeForm > input[name='procType']").val("person");
				$('#groupTabClass').removeClass('logTabSection on').addClass('logTabSection');
				$('#personTabClass').removeClass('logTabSection').addClass('logTabSection on');
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
				$("#trainingFeeForm").attr("action", "${pageContext.request.contextPath}/trainingFee/trainingFeePlan.do")
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
				$("#trainingFeeForm").attr("action", "${pageContext.request.contextPath}/trainingFee/trainingFeeSpend.do")
				$("#trainingFeeForm").submit();
			},
			groupList : function(idno, giveyear, givemonth, groupcode) {
				$("#groupView"+idno).hide();
				$("#groupClose"+idno).show();
				$("."+giveyear+givemonth).show();
				
				//스크롤 사이즈
				abnkorea_resize();
			},
			groupListClose : function(idno, giveyear, givemonth) {
				$("#groupView"+idno).show();
				$("#groupClose"+idno).hide();
				$("."+giveyear+givemonth).hide();
				//스크롤 사이즈
				abnkorea_resize();
			},
			uiLayerPop_w02 : function(giveyear, givemonth, depaboNo) {
				var popParam = {
						url : "/trainingFee/trainingFeeMainLayerPop.do"
						, width : "450"
						, height : "400"
						, params : {giveyear  : giveyear
									, givemonth : givemonth
									, depaboNo  : depaboNo}
				}
				
				openLayerPopup(popParam);
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
						url : "/trainingFee/trainingFeeMainLayerPop.do"
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
	<input type="hidden" name="pfyear"         value=""/>
</form>
	<!-- content area | ### academy IFRAME Start ### -->
<section id="pbContent" class="bizroom">
	<div class="hWrap">
		<h1><img src="/_ui/desktop/images/academy/h1_w020400400.gif" alt="교육비관리"></h1>
		<p><img src="/_ui/desktop/images/academy/txt_w020400400.gif" alt="본인의 교육비 현황 및 다운라인의 상세 내역을 조회할 수 있습니다."></p>
	</div>
	<!-- 교육비 관리 -->
	<div id="trainingFee">
	
		<div class="relative">
			<h2><img src="/_ui/desktop/images/academy/h2_w020400400.gif" alt="교육비 안내"></h2>
			<a href="javascript:pageEvent.agreePage();" class="btnCont btnR"><span>교육비 동의관리</span></a>
		</div>	
		<div class="tfInfo">
			<span><img src="/_ui/desktop/images/academy/img_w020400400_01.gif" alt="교육비 예산은 각 다이아몬드 그룹 단위 순매출액의 2%로 산정됩니다."></span>
			<span><img src="/_ui/desktop/images/academy/img_w020400400_02.gif" alt="사전 교육 계획서를 전월에 선행 하신 후, 지출증빙을 진행해 주시기 바랍니다."></span>
			<span><img src="/_ui/desktop/images/academy/img_w020400400_03.gif" alt="관련 문의는  02) 3468-6000 이용 시간은 09:00 ~ 18:00 (월~금) 입니다."></span>
		</div>

		<div class="tabWrapLogical">
			<section class="logTabSection">
					
					<table class="tblTraningFee">
						<caption>교육비 관리 테이블</caption>
						<colgroup>
							<col style="width:10%;">
							<col style="width:30%;">
							<col style="width:20%;">
							<col style="width:20%;">
							<col style="width:20%;">
						</colgroup>
						<thead>
							<tr>
								<th scope="col"><div>월</div></th>
								<th scope="col"><div>교육비예산(원)</div></th>
								<th scope="col"><div>사전계획 <a href="#uiLayerPop_help01" class="iconTip">설명</a></div></th>
								<th scope="col"><div>지출증빙(원) <a href="#uiLayerPop_help01" class="iconTip" style="right:10px">설명</a></div></th>
								<th scope="col"><div>처리현황 <a href="#uiLayerPop_help01" class="iconTip">설명</a></div></th>
							</tr>
						</thead>
						<tbody>
							<!-- 단계를 나타내는 화살표 td class="bg", 진행중인 단계 td class="bg on" -->
							<c:forEach var="itemp" items="${personList}" varStatus="status">
								<c:if test="${itemp.giveflag ne 'N'}"> 
									<c:set var="okdata" value="${okdata }, ${itemp.giveyear}${itemp.givemonth}"></c:set>
								</c:if>
								<tr>
									<td>${itemp.giveyear}<br><strong><span class="num">${itemp.givemonth}</span>월</strong></td>
									<td class="preWon">
										<span class="textPre"><c:if test="${itemp.trfeetype eq 'NOTFOUND'}"><c:if test="${itemp.btntype ne 'NOT'}">예상</c:if></c:if></span>
										<span class="num">${itemp.trfeetext}</span>
										<c:if test="${scrData.authperson eq '2'}">
											<span class="detailView"><a href="javascript:;" onclick="javascript:listEvent.uiLayerPop_w02('${itemp.giveyear}','${itemp.givemonth}','${itemp.depaboNo}')">상세보기</a></span>
										</c:if> 
<%-- 										${itemp.btntype} planstatus:${itemp.planstatus} giveflag:${itemp.giveflag } giveopen:${scrData.giveopen } --%>
									</td>
									<c:if test="${itemp.btntype eq 'PLAN'}">
										<c:choose>
  											<c:when test="${scrData.giveopen eq 'Y' and itemp.giveflag ne 'N'}">
  												<c:choose>
		  											<c:when test="${itemp.planstatus eq 'Y'}">
		  												<td class="bg"><a href="#none" class="insertBtn" onclick="javascript:listEvent.planPage('${itemp.giveyear}','${itemp.givemonth}','person','S')"><span>계획조회</span></a>
		  													<span class="subText"> 
																<span><span class="fl">그룹 :</span><span class="fr">${itemp.plangrpamount }</span></span>
																<span><span class="fl">개인 :</span><span class="fr">${itemp.planperamount }</span></span>
																<span><span class="fl">차액 :</span><span class="fr">${itemp.plansumamount }</span></span>
															</span>
		  												</td>
		  											</c:when>
		  											<c:otherwise>
		  												<td class="bg on">
		  													<a href="#none" class="insertBtn on" onclick="javascript:listEvent.planPage('${itemp.giveyear}','${itemp.givemonth}','person','I')">
		  													<span>${itemp.plancnt }</span>
		  													</a>
		  													<span class="subText"> 
																<span><span class="fl">그룹 :</span><span class="fr">${itemp.plangrpamount }</span></span>
																<span><span class="fl">개인 :</span><span class="fr">${itemp.planperamount }</span></span>
																<span><span class="fl">차액 :</span><span class="fr">${itemp.plansumamount }</span></span>
															</span>
		  												</td>
		  											</c:otherwise>
		  										</c:choose>
  											</c:when>
  											<c:when test="${scrData.giveopen eq 'Y' and itemp.giveflag eq 'N'}">
  												<c:choose>
		  											<c:when test="${item.planstatus eq 'Y'}">
		  												<td class="bg"><a href="#none" class="insertBtn" onclick="javascript:listEvent.planPage('${item.giveyear}','${item.givemonth}','group','S')"><span>계획조회</span></a>
		  												</td>
		  											</c:when>
		  											<c:otherwise>
		  												<td>
		  													<span class="insertPre">-</span>
		  												</td>
		  											</c:otherwise>
		  										</c:choose>
  											</c:when>
  											<c:when test="${scrData.giveopen eq 'N' }">
	  											<c:choose>
		  											<c:when test="${item.planstatus eq 'Y'}">
		  												<td class="bg"><a href="#none" class="insertBtn" onclick="javascript:listEvent.planPage('${item.giveyear}','${item.givemonth}','group','S')"><span>계획조회</span></a></td>
		  											</c:when>
		  											<c:otherwise>
		  												<td><span class="insertPre">-</span></td>
		  											</c:otherwise>
		  										</c:choose>
	  										</c:when>
										</c:choose>
										<td><span class="insertPre">-</span></td>
										<td><span class="insertPre">-</span></td>
									</c:if>
									<c:if test="${itemp.btntype eq 'ALL'}">
										<c:choose>
  											<c:when test="${scrData.giveopen eq 'Y' and itemp.giveflag ne 'N'}">
  												<c:choose>
		  											<c:when test="${itemp.planstatus eq 'Y'}">
		  												<td class="bg"><a href="#none" class="insertBtn" onclick="javascript:listEvent.planPage('${itemp.giveyear}','${itemp.givemonth}','person','S')"><span>계획조회</span></a>
		  													<span class="subText"> 
																<span><span class="fl">그룹 :</span><span class="fr">${itemp.plangrpamount }</span></span>
																<span><span class="fl">개인 :</span><span class="fr">${itemp.planperamount }</span></span>
																<span><span class="fl">차액 :</span><span class="fr">${itemp.plansumamount }</span></span>
															</span>
		  												</td>
		  											</c:when>
		  											<c:otherwise>
		  												<td class="bg on"><a href="#none" class="insertBtn on" onclick="javascript:listEvent.planPage('${itemp.giveyear}','${itemp.givemonth}','person','I')"><span>${itemp.plancnt }</span></a>
		  													<span class="subText"> 
																<span><span class="fl">그룹 :</span><span class="fr">${itemp.plangrpamount }</span></span>
																<span><span class="fl">개인 :</span><span class="fr">${itemp.planperamount }</span></span>
																<span><span class="fl">차액 :</span><span class="fr">${itemp.plansumamount }</span></span>
															</span>
		  												</td>
		  											</c:otherwise>
		  										</c:choose>
		  										<c:choose>
		  											<c:when test="${itemp.planstatus eq 'Y'}">
		  												<c:choose>
				  											<c:when test="${itemp.spendstatus eq 'Y'}">
				  												<td class="bg"><a href="#none" class="insertBtn" onclick="javascript:listEvent.spendPage('${itemp.giveyear}','${itemp.givemonth}','person','S')"><span>지출조회</span></a>
				  													<span class="subText"> 
																		<span><span class="fl">그룹 :</span><span class="fr">${itemp.grpamount }</span></span>
																		<span><span class="fl">개인 :</span><span class="fr">${itemp.peramount }</span></span>
																		<span><span class="fl">차액 :</span><span class="fr">${itemp.spandsumamount }</span></span>
																	</span>
				  												</td>
				  											</c:when>
				  											<c:otherwise>
				  												<td class="bg on"><a href="#none" class="insertBtn on" onclick="javascript:listEvent.spendPage('${itemp.giveyear}','${itemp.givemonth}','person','I')"><span>${itemp.spendcnt }</span></a>
					  												<span class="subText"> 
																		<span><span class="fl">그룹 :</span><span class="fr">${itemp.grpamount }</span></span>
																		<span><span class="fl">개인 :</span><span class="fr">${itemp.peramount }</span></span>
																		<span><span class="fl">차액 :</span><span class="fr">${itemp.spandsumamount }</span></span>
																	</span>
				  												</td>
				  											</c:otherwise>
				  										</c:choose>
		  											</c:when>
		  											<c:otherwise>
		  												<td class="bg"><span class="insertPre">계획필요</span></td>
		  											</c:otherwise>
		  										</c:choose>
  											</c:when>
  											<c:when test="${scrData.giveopen eq 'Y' and itemp.giveflag eq 'N'}">
  												<c:choose>
		  											<c:when test="${itemp.planstatus eq 'Y'}">
		  												<td class="bg"><a href="#none" class="insertBtn" onclick="javascript:listEvent.planPage('${itemp.giveyear}','${itemp.givemonth}','person','S')"><span>계획조회</span></a></td>
		  											</c:when>
		  											<c:otherwise>
		  												<td class="bg"><span class="insertPre">-</span></td>
		  											</c:otherwise>
		  										</c:choose>
		  										<c:choose>
		  											<c:when test="${itemp.planstatus eq 'Y'}">
		  												<c:choose>
				  											<c:when test="${itemp.spendstatus eq 'Y'}">
				  												<td class="bg"><a href="#none" class="insertBtn" onclick="javascript:listEvent.spendPage('${itemp.giveyear}','${itemp.givemonth}','person','S')"><span>지출조회</span></a>
				  													<span class="subText"> 
																		<span><span class="fl">그룹 :</span><span class="fr">${itemp.grpamount }</span></span>
																		<span><span class="fl">개인 :</span><span class="fr">${itemp.peramount }</span></span>
																		<span><span class="fl">차액 :</span><span class="fr">${itemp.spandsumamount }</span></span>
																	</span>
				  												</td>
				  											</c:when>
				  											<c:otherwise>
				  												<td class="bg on"><a href="#none" class="insertBtn on" onclick="javascript:listEvent.spendPage('${itemp.giveyear}','${itemp.givemonth}','person','I')"><span>${itemp.spendcnt }</span></a>
					  												<span class="subText"> 
																		<span><span class="fl">그룹 :</span><span class="fr">${itemp.grpamount }</span></span>
																		<span><span class="fl">개인 :</span><span class="fr">${itemp.peramount }</span></span>
																		<span><span class="fl">차액 :</span><span class="fr">${itemp.spandsumamount }</span></span>
																	</span>
				  												</td>
				  											</c:otherwise>
				  										</c:choose>
		  											</c:when>
		  											<c:otherwise>
		  												<td class="bg"><span class="insertPre">-</span></td>
		  											</c:otherwise>
		  										</c:choose>
  											</c:when>
  											<c:when test="${scrData.giveopen eq 'N'}">
  												<c:choose>
		  											<c:when test="${itemp.planstatus eq 'Y'}">
		  												<td class="bg"><a href="#none" class="insertBtn" onclick="javascript:listEvent.planPage('${itemp.giveyear}','${itemp.givemonth}','person','S')"><span>계획조회</span></a></td>
		  											</c:when>
		  											<c:otherwise>
		  												<td><span class="insertPre">-</span></td>
		  											</c:otherwise>
		  										</c:choose>
		  										<c:choose>
		  											<c:when test="${itemp.planstatus eq 'Y'}">
		  												<c:choose>
				  											<c:when test="${itemp.spendstatus eq 'Y'}">
				  												<td class="bg"><a href="#none" class="insertBtn" onclick="javascript:listEvent.spendPage('${itemp.giveyear}','${itemp.givemonth}','person','S')"><span>지출조회</span></a></td>
				  											</c:when>
				  											<c:otherwise>
				  												<td class="bg on"><a href="#none" class="insertBtn on" onclick="javascript:listEvent.spendPage('${itemp.giveyear}','${itemp.givemonth}','person','I')"><span>${itemp.spendcnt }</span></a>
				  													<span class="subText"> 
																		<span><span class="fl">그룹 :</span><span class="fr">${itemp.grpamount }</span></span>
																		<span><span class="fl">개인 :</span><span class="fr">${itemp.peramount }</span></span>
																		<span><span class="fl">차액 :</span><span class="fr">${itemp.spandsumamount }</span></span>
																	</span>
				  												</td>
				  											</c:otherwise>
				  										</c:choose>
		  											</c:when>
		  											<c:otherwise>
		  												<td><span class="insertPre">-</span></td>
		  											</c:otherwise>
		  										</c:choose>
  											</c:when>
  										</c:choose>
  										<td>
											<c:choose>
  												<c:when test="${itemp.planstatus eq 'Y' and itemp.spendstatus eq 'Y' }">
  													<c:choose>
  														<c:when test="${itemp.processstatus eq 'Y' }">
  															<span class="insert end">승인완료<br/>(${itemp.processstatusdt})</span>
  														</c:when>
  														<c:when test="${itemp.processstatus eq 'R' }">
  															<span class="insert">반려</span>
															<span class="textTip">${itemp.rejecttext}</span>
  														</c:when>
  														<c:otherwise>
  															<span class="insert">승인중</span>
  														</c:otherwise>
  													</c:choose>
  												</c:when>
  												<c:otherwise>
													<c:choose>
  														<c:when test="${itemp.processstatus eq 'R' }">
  															<span class="insert">반려</span>
															<span class="textTip">${itemp.rejecttext}</span>
  														</c:when>
  														<c:otherwise>
  															<span class="insertPre">-</span>
  														</c:otherwise>	  													
  													</c:choose>
												</c:otherwise>
  											</c:choose>
											<span class="insertPre">${itemp.processstatusname}</span>
										</td>
									</c:if>
									<c:if test="${itemp.btntype eq 'NOT'}">
										<td><span class="insertPre">-</span></td>
										<td><span class="insertPre">-</span></td>
										<td><span class="insertPre">-</span></td>
									</c:if>
								</tr>
							</c:forEach>
							<input type="hidden" value="${okdata }" id="okdata" />
						</tbody>
					</table>
					
			</section>
			<select class="btnR" id="pfyear" onchange="javascript:pageEvent.pfList();">
				<option value="0">등록 가능 기간</option>
				<c:forEach var="pf" items="${pfList}" varStatus="status">
					<option value="${pf.pfyear }" <c:if test="${scrData.pfyear eq pf.pfyear}">selected="selected"</c:if>>${pf.pfyearname}</option>
				</c:forEach>
				
			</select>
		</div>
		
		<!-- 교육비 도움말 -->
		<div class="pbLayerWrap" id="uiLayerPop_help01" style="width: 600px; display: block; position: fixed; top: 30%; left: 50%; margin-top: 100px; margin-left: -300px;" tabindex="0">
			<div class="pbLayerHeader">
				<strong><img src="/_ui/desktop/images/academy/h1_w020500400_pop.gif" alt="교육비 항목 도움말"></strong>
				<a href="#" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="교육비 항목 도움말 닫기"></a>
			</div>
			<div class="pbLayerContent">
				<ul class="listDotFS">
					<li><strong>교육비예산</strong><!-- @edit 20160803 -->
						<p>교육비 예산은 각 다이아몬드 그룹 단위 순매출액의 2%로 산정되며, 확정전에는 최근 교육비를 예상값으로 사전계획을 수립하시면 됩니다.</p>
					</li>
					<li class="mgtM"><strong>사전계획</strong>
						<p>지출증빙을 위한 필수 단계입니다. 각 단계는 다음의 경우에 발생됩니다.</p>
						<ul class="listDot pdNone">
							<li>계획조회 : 계획이 완료된 단계로 수립한 계획 조회 가능</li>
							<li>[등록] : 계획 수립이 필요한 경우 발생</li>
							<li>등록중 : 계획을 수립중이나 완료되지 않은 단계에서 발생</li>
						</ul>
					</li>
					<li class="mgtM"><strong>지출증빙</strong><!-- @edit 20160803 -->
						<p>사전계획이 수립된 경우에만 가능하며, 영수증이 필요합니다.</p>
						<ul class="listDot pdNone">
							<li>지출조회 : 지출증빙이 완료된 단계로 제출한 증빙 조회 가능</li>
							<li>[등록] : 지출증빙이 필요한 경우 발생</li>
							<li>등록중 : 지출증빙중이나 완료되지 않은 단계에서 발생</li>
						</ul>
					</li>
					<li class="mgtM"><strong>처리현황</strong>
						<p>지출증빙 제출 후 처리현황을 알려드립니다.</p>
						<ul class="listDot pdNone">
							<li>" – " : 지출증빙 제출 불가 단계</li>
							<li>등록 : 처리 대상이나 사전계획/지출증빙이 등록 전</li>
							<li>등록전 : 등록은 하였으나 제출 전</li>
							<li>제출완료 : 지출증빙까지 제출 후 접수한 단계</li>
							<li>승인중 : 등록 후 (담당자 확인 중)</li>
							<li>승인완료(승인일자)  : 등록 후 승인완료시 발생</li>
						</ul>
					</li>
				</ul>
			</div>
		</div>
		<!-- //layer popup -->
		
	</div>
	<!-- //교육비 관리 -->	
</section>
	<!-- //content area | ### academy IFRAME End ### -->
		
<!-- 	<div class="skipNaviReturn"> -->
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>
