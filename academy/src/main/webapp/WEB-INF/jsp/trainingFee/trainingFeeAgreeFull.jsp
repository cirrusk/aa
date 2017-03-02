<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/framework/include/header.jsp"%>
<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<!-- //page unique -->
<title>교육비 관리 - ABN Korea</title>

<script type="text/javascript">
var bChk = false;

	$(document.body).ready(function() {
		
		$("input[name='agreeflag']").change(function(){
			bChk = true;
		});
		
		// 교육비 동의 1
		$("#trainingFeeAgreeSubmit").on("click", function(){
			if($("input[name='tfAgree1']:checked").val() == "Y"){
				$("input[name='agreeflag']").val("Y");
			}else{
				alert("동의 후 이용할 수 있습니다.");
				return false;
			}
			
			// 약관 동의 후 index페이지 호출
			$.ajaxCall({
				url : "<c:url value="${pageContext.request.contextPath}/trainingFee/saveAgreeText.do"/>",
				data : $("#trainingFeeAgree").serialize(),
				success : function(data, textStatus, jqXHR) {
					$("#trainingFeeAgree").attr("action", "${pageContext.request.contextPath}/trainingFee/trainingFeeIndex.do")
					$("#trainingFeeAgree").submit();
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("처리도중 오류가 발생하였습니다.");
				}
			});

		});
		
		if( !isNull(document.getElementById("ptxt")) ) {
			var text = $("#ptxt > p").length;
			for(var i=0; i < text; i++) {
				if(i>2) $("#ptxt > p")[i].empty();
			}	
		}
		
		if( !isNull(document.getElementById("delegTxt")) ) {
			var text = $("#delegTxt > p").length;
			for(var i=0; i < text; i++) {
				if(i>2) $("#delegTxt > p")[i].empty();
			}	
		}
		
		if( !isNull(document.getElementById("personTxt")) ) {
			var text = $("#personTxt > p").length;
			for(var i=0; i < text; i++) {
				if(i>2) $("#personTxt > p")[i].empty();
			}
		}
				
		//스크롤 사이즈
		setTimeout(function(){ abnkorea_resize(); }, 500);
	});
	
	function fn_init() {
		$.ajaxCall({
			url : "<c:url value="${pageContext.request.contextPath}/trainingFee/trainingFeeAgreeText.do"/>",
			data : $("#trainingFeeAgree").serialize(),
			success : function(data, textStatus, jqXHR) {
				var html = data.dataList.agreetext;
				
				$("#agreeTxt").html(html);
				$("input[name='agreeid']").val(data.dataList.agreeid);
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("처리도중 오류가 발생하였습니다.");
			}
		});
	}
	
	var reload = {
			pagego : function(){
				$("#trainingFeeForm").attr("action", "${pageContext.request.contextPath}/trainingFee/trainingFeeIndex.do")
				$("#trainingFeeForm").submit();
			},
			popUp : function(){
				var specs = "width=712px,height=740px,location=no,menubar=no,resizable=no,scrollbars=no,status=no,toolbar=no";
				var testPopup = window.open("/trainingFee/trainingFeeAgreePop.do?fiscalyear="+$("#trainingFeeForm input[name='fiscalyear']").val()+"&depaboNo="+$("#trainingFeeForm input[name='depaboNo']").val(), "agreePop" ,specs);
				
// 				var frm = document.trainingFeeForm;
// 				frm.action = "/trainingFee/trainingFeeAgreePop.do";
// 				frm.target = "agreePop";
// 				frm.method = "post";
// 				frm.submit();
			},
			confrim : function() {
				if(bChk) {
					var result = confirm("제3자 약관 동의 여부를 변경 하시겠습니까?");
					
					if(result){
						// 약관 동의 후 index페이지 호출
						$.ajaxCall({
							url : "<c:url value="${pageContext.request.contextPath}/trainingFee/updateThirdpersonAgree.do"/>",
							data : $("#trainingFeeAgree").serialize(),
							success : function(data, textStatus, jqXHR) {
								alert("변경 완료 하였습니다.");
								$("#trainingFeeAgree").attr("action", "${pageContext.request.contextPath}/trainingFee/trainingFeeIndex.do")
								$("#trainingFeeAgree").submit();
							},
							error : function(jqXHR, textStatus, errorThrown) {
								alert("처리도중 오류가 발생하였습니다.");
							}
						});
					}
				} else {
					$("#trainingFeeAgree").attr("action", "${pageContext.request.contextPath}/trainingFee/trainingFeeIndex.do")
					$("#trainingFeeAgree").submit();
				}
			}
	}
	
</script>
</head>

<body>
<!-- content area | ### academy IFRAME Start ### -->
	<form id="trainingFeeForm" name="trainingFeeForm" method="post">
		<input type="hidden" name="fiscalyear"    value="${scrData.fiscalyear }"    />
		<input type="hidden" name="depaboNo"      value="${scrData.depaboNo }"      />
		<input type="hidden" name="delegtypecode" value="${scrData.delegtypecode }" />
	</form>
	<section id="pbContent" class="bizroom">
		<div class="hWrap">
			<h1><img src="/_ui/desktop/images/academy/h1_w020400430.gif" alt="교육비 동의관리"></h1>
			<p><img src="/_ui/desktop/images/academy/txt_w020400430.gif" alt="교육비 관리에 필요한 교육비 권한 부여, 교육비 수령, 개인 정보 제3자 조회 동의를 관리합니다"></p>
		</div>
		<!-- 교육비 동의관리 -->
		<div id="trainingFee">
			
			<div class="btnWrapR"><a href="javascript:reload.pagego();" class="btnTbl"><span>교육비관리 목록</span></a></div>
			
			<c:if test="${!empty agreeDeleg}">
			<div class="borderBox">
				<div class="borderBoxHeader"><strong>[필수]</strong> ${scrData.fiscalyear } 회계연도 교육비 권한 부여(소득세 포함)에 대한 동의 <span>${agreeDeleg.agreedate} 동의함</span></div>
				<div class="borderBoxContent bBC01">
					<div class="floatL" id="delegTxt">
						${agreeDeleg.agreetext}
						
						<p class="mgtM">&lt; 교육비 권한을 부여하는 ABO &gt;</p>
						<table class="tblList lineLeft mgtS">
						<caption>교육비 권한을 부여받는 ABO</caption>
						<colgroup>
							<col style="width:50%">
							<col style="width:50%">
						</colgroup>
						<thead>
							<tr>
								<th scope="col">ABO 번호</th>
								<th scope="col">위임자</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<c:forEach var="item" items="${agreeDelegList}" varStatus="status">
								<tr>
									<td>${item.delegatoraboNo }</td>
									<td>${item.delegatoraboname }</td>
								</tr>
								</c:forEach>
							</tr>
						</tbody>
						</table>
					</div>					
					<div class="floatR"><a href="javascript:reload.popUp();" class="btnTbl"><span>전체보기</span></a></div>
				</div>
			</div>
			</c:if>
			
			<div class="borderBox">
				<div class="borderBoxHeader"><strong>[필수]</strong> ${scrData.fiscalyear } 회계연도 교육비(소득세 포함) 수령에 대한 동의 <span>${agreePledge.agreedate} 동의함</span></div>
				<div class="borderBoxContent bBC02">
					<div class="floatL" id="ptxt">
						${agreePledge.agreetext}
					</div>
					<div class="floatR"><a href="javascript:reload.popUp();" class="btnTbl"><span>전체보기</span></a></div>
				</div>
			</div>
			
			<c:if test="${!empty thirdPerson}">
				<div class="borderBox mgbS">
					<div class="borderBoxHeader"><strong>[선택]</strong> ${scrData.fiscalyear } 회계연도 개인정보 제3자 조회 동의 <c:if test="${thirdPerson.agreeflag eq 'Y'}"><span>${thirdPerson.agreedate} 동의함</span></c:if></div>
					
					<div class="borderBoxContent bBC03">
						<div class="floatL" id="personTxt">
							${thirdPerson.agreetext}
						</div>					
						<div class="floatR"><a href="javascript:reload.popUp();" class="btnTbl" ><span>전체보기</span></a></div>
					</div>
				</div>
				
				<form id="trainingFeeAgree" name="trainingFeeAgree" method="post">
				<!-- @edit 20160701 -->
				<div class="btnWrapR mgtS pdtSs">
					<input type="radio" name="agreeflag" <c:if test="${thirdPerson.agreeflag eq 'Y'}"> checked</c:if> value="Y" ><label for="tfAgree01">동의함</label> 
					<input type="radio" name="agreeflag" <c:if test="${thirdPerson.agreeflag eq 'N'}"> checked</c:if> value="N" ><label for="tfAgree02">동의하지 않음</label>
					<input type="hidden" name="fiscalyear"    value="${scrData.fiscalyear }" />
					<input type="hidden" name="depaboNo"      value="${scrData.depaboNo }"   />
				</div>
				</form>
				
				<div class="btnWrapC">
					<a href="javascript:reload.confrim();" class="btnBasicBL">확인</a>
				</div>
			</c:if>
			
		</div>
		<!-- //교육비 동의관리 -->	
	</section>
<!-- //content area | ### academy IFRAME End ### -->
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp"%>
