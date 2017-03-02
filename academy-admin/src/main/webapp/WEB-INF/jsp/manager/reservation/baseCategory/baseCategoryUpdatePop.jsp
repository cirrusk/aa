<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>
		
<script type="text/javascript">	

$(document).ready(function(){
	
	/* 상태 초기설정 */
	if('' != '${parentCategory.statuscode}'){
		$("#statuscode").val('${parentCategory.statuscode}');
	}
});

// function planSave (){
	
// 	//입력여부 체크
// 	if(!chkValidation({chkId:"#tblSearch", chkObj:"hidden|input|select"}) ){
// 		return;
// 	}
	
// 	sUrl = "<c:url value='/manager/reservation/baseCategory/baseCategoryUpdateAjax.do'/>";
	
// 	var result = confirm("저장 하시겠습니까?");
	
// 	if(result) {
// 		$.ajaxCall({
// 			method : "POST",
// 			url : sUrl,
// 			dataType : "json",
// 			data : $("#baseCategory").serialize(),
// 			success : function(data, textStatus, jqXHR) {
// 				if (data.result > 0) {
// 					alert("저장 완료 하였습니다.");
// 				}else{
// 					alert("처리도중 오류가 발생하였습니다.");
// 				}
// 				closeManageLayerPopup("searchPopup");
// 			},
// 			error : function(jqXHR, textStatus, errorThrown) {
// 				alert("처리도중 오류가 발생하였습니다.");
// 			}
// 		});
// 	}
// }
function planSave (){
	
	//입력여부 체크
	if(!chkValidation({chkId:"#tblSearch", chkObj:"hidden|input|select"}) ){
		return;
	}
	
	showLoading();
	
	 var word; 
	 var version = "N/A"; 

	 var agent = navigator.userAgent.toLowerCase(); 
	 var name = navigator.appName; 
	 
	// IE old version ( IE 10 or Lower ) 
	 if ( name == "Microsoft Internet Explorer" ) word = "msie "; 

		else { 
		 // IE 11 
		 if ( agent.search("trident") > -1 ) word = "trident/.*rv:"; 

		 // Microsoft Edge  
		 else if ( agent.search("edge/") > -1 ) word = "edge/"; 
	 } 

	 var reg = new RegExp( word + "([0-9]{1,})(\\.{0,}[0-9]{0,1})" ); 

	if (  reg.exec( agent ) != null  ) version = RegExp.$1 + RegExp.$2; 
	
	$("#browserName").val("");
	$("#browserVersion").val("");
	
	$("#browserName").val(word);
	$("#browserVersion").val(version);
	
	var result = confirm("저장 하시겠습니까?");
	
	if(result) {
		$("#baseCategory").ajaxForm({
			url : "<c:url value='/manager/reservation/baseCategory/baseCategoryUpdateAjax.do'/>",
            type : "json", 
			method : "post",
            async : false,
            contentType: "text/html",
// 			data : $("#baseCategory").serialize(),
			success : function(data) {
				
				hideLoading();	//로딩 끝
				alert("저장 완료 하였습니다.");
				
				eval($('#ifrm_main_'+"${lyData.frmId}").get(0).contentWindow.doReturn());
				
				closeManageLayerPopup("searchPopup");

			},
			error : function(jqXHR, textStatus, errorThrown) {
				hideLoading();	//로딩 끝
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		}).submit();
	} else {
		hideLoading();	//로딩 끝
	}
}

</script>

<form id="baseCategory" name="baseCategory" method="POST" enctype="multipart/form-data">

	<input type="hidden" name="categoryseq" value="${parentCategory.categoryseq}" />
	<input type="hidden" name="typeseq" value="${parentCategory.typeseq}" />
	<input type="hidden" name="typelevel" value="${parentCategory.typelevel}" />
	<input type="hidden" name="categorytype1" value="${parentCategory.categorytype1}" />
	<input type="hidden" name="categoryname1" value="${parentCategory.categoryname1}" />
	<input type="hidden" name="categorytype2" value="${parentCategory.categorytype2}" />
	<input type="hidden" name="categoryname2" value="${parentCategory.categoryname2}" />
	<input type="hidden" name="categorytype3" value="${parentCategory.categorytype3}" />
	<input type="hidden" name="categoryname3" value="${parentCategory.categoryname3}" />
	
<%-- 	<input type="text" name="tt" value="${lyData.frmId}" /> --%>
	
	<input type="hidden" name="browserName" id="browserName"/>
	<input type="hidden" name="browserVersion" id="browserVersion"/>
	
	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">브랜드 카테고리 분류 수정</h2>
			<span class="fr"><a href="javascript:;" class="close-layer btn_close">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
		<div id="popcontainer"  style="height:270px">
			<div id="popcontent">
				
				<div class="tbl_write">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="30%" />
							<col width="70%" />
						</colgroup>
						
						<tr>
							<th>상위코드</th>
							<td>
								<c:if test="${parentCategory.typelevel eq '1'}">
									상위 코드 없음 (제일 상위 입니다.)
								</c:if>
								<c:if test="${parentCategory.typelevel eq '2'}">
									<c:out value="${parentCategory.categoryname1}" /> (<c:out value="${parentCategory.categorytype1}" />)
								</c:if>
								<c:if test="${parentCategory.typelevel eq '3'}">
									<c:out value="${parentCategory.categoryname2}" /> (<c:out value="${parentCategory.categorytype2}" />)
								</c:if>
							</td>
						</tr>
						<tr>
							<th>분류레벨</th>
							<td>
								<fmt:parseNumber var="iTypeLevel" type="number" value="${parentCategory.typelevel}" />
								카테고리 <c:out value="${iTypeLevel}"/>
							</td>
						</tr>
						<tr>
							<th>분류코드</th>
							<td>
								<c:if test="${parentCategory.typelevel eq '1'}">
									<input type="hidden" id="categorytype" name="categorytype" value="${parentCategory.categorytype1}" class="required" title="분류코드">
									${parentCategory.categorytype1}
								</c:if>
								<c:if test="${parentCategory.typelevel eq '2'}">
									<input type="hidden" id="categorytype" name="categorytype" value="${parentCategory.categorytype2}" class="required" title="분류코드">
									${parentCategory.categorytype2}
								</c:if>
								<c:if test="${parentCategory.typelevel eq '3'}">
									<input type="hidden" id="categorytype" name="categorytype" value="${parentCategory.categorytype3}" class="required" title="분류코드">
									${parentCategory.categorytype3}
								</c:if>
							</td>
						</tr>
						<c:if test="${parentCategory.categorytype2 eq 'E0301' }">
						<tr>
							<th>브랜드이미지</th>
							<td>
								<input type="file" id="brandImg" name="brandImg" class="" accept="image/*;capture=camera"  title="브랜드이미지" /><br/>
<%-- 								<input type="hidden" name="fileKey" value="${parentCategory.filekey }" title="브랜드이미지" /> --%>
								<a href="${pageContext.request.contextPath}/manager/common/trfeefile/trfeeFileDownload.do?work=RSVBRAND&fileKey=${parentCategory.filekey }&uploadSeq=${parentCategory.uploadseq }" >${parentCategory.realfilename }</a>
							</td>
						</tr>
						</c:if>
						<tr>
							<th>(하위)카테고리 명</th>
							<td>
								<c:if test="${parentCategory.typelevel eq '1'}">
									<input type="text" id="categoryname" name="categoryname" value="${parentCategory.categoryname1}" class="required" title="분류코드명">
								</c:if>
								<c:if test="${parentCategory.typelevel eq '2'}">
									<input type="text" id="categoryname" name="categoryname" value="${parentCategory.categoryname2}" class="required" title="분류코드명">
								</c:if>
								<c:if test="${parentCategory.typelevel eq '3'}">
									<input type="text" id="categoryname" name="categoryname" value="${parentCategory.categoryname3}" class="required" title="분류코드명">
								</c:if>
							</td>
						</tr>
						<tr>
							<th>상태</th>
							<td>
								<select id=statuscode name="statuscode" style="width:auto; min-width:100px" class="required" title="상태">
									<option value="">선택</option>
									<c:forEach var="item" items="${useStateCodeList}">
										<option value="${item.commonCodeSeq}">${item.codeName}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						
					</table>
				</div>
				<div class="btnwrap clear">
					<a href="javascript:planSave();" id="aInsert" class="btn_green">저장</a>
					<a href="javascript:;" id="aInsertEnd" class="btn_green close-layer">닫기</a>
				</div>
			</div>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
</form>
