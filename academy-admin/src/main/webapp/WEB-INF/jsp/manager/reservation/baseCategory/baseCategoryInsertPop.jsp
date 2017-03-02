<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>
		
<script type="text/javascript">	

$(document).ready(function(){

});

/* 저장전 체크사항 */
function planSave (){
	
	if('E0301' == $("input[name='categorytype2']").val() && $("#brandImg").val().length <= '0'){
		alert("브랜드이미지는 필수값입니다. 브랜드이미지를 첨부해주십시오.");
		return;
	}
	
	//입력여부 체크
	if(!chkValidation({chkId:"#tblSearch", chkObj:"hidden|text|select"}) ){
		return;
	}
	
	
// 	if( '1' == $("#typelevel").val() && 5 != $("#categorytype").val().length){
// 		alert("코드는 5자리로 관리되고 있습니다. 5자리를 입력해주세요.");
// 		return;
// 	}
	
// 	if( '2' == $("#typelevel").val() && 7 != $("#categorytype").val().length){
// 		alert("코드는 7자리로 관리되고 있습니다. 7자리를 입력해주세요.");
// 		return;
// 	}
	
// 	$.ajaxCall({
// 		url : "<c:url value='/manager/reservation/baseCategory/isAvailableCategoryTypecode.do'/>",
// 		data : $("#baseCategory").serialize(),
// 		success : function( data, textStatus, jqXHR){
//    			if(data.result){
//    				saveProcess();
//    			}else{
//    				alert("분류코드가 이미 존재합니다. 다른코드를 입력하세요.");
//    				return;
//    			}
// 		},
// 		error : function( jqXHR, textStatus, errorThrown) {
//        		alert("처리도중 오류가 발생하였습니다.");
// 		}
// 	});
	
	saveProcess();
}

/* 저장 트랜젝션 */
function saveProcess() {
	
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
			method : "post",
			url : "<c:url value='/manager/reservation/baseCategory/baseCategoryInsertAjax.do'/>",
			type : "json", 
// 			data : $("#baseCategory").serialize(),
			contentType: "text/html",
            async : false,
			success : function(data, textStatus, jqXHR) {
				
				hideLoading();	//로딩 끝
				
				if(data.result == 0){
					alert("저장에 실패하였습니다. 예약타입을 먼저 등록 바랍니다.");
				}else{
					alert("저장 완료 하였습니다.");

				}
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

	<c:if test="${!(parentCategory.typelevel eq '') and !(parentCategory.typelevel eq NULL)}">
		<input type="hidden" name="typeseq" value="${parentCategory.typeseq}" />
	</c:if>
	<input type="hidden" name="typelevel" id="typelevel" value="${parentCategory.typelevel}" />
	<input type="hidden" name="categorytype1" value="${parentCategory.categorytype1}" />
	<input type="hidden" name="categoryname1" value="${parentCategory.categoryname1}" />
	<input type="hidden" name="categorytype2" value="${parentCategory.categorytype2}" />
	<input type="hidden" name="categoryname2" value="${parentCategory.categoryname2}" />
	<input type="hidden" name="categorytype3" value="${parentCategory.categorytype3}" />
	<input type="hidden" name="categoryname3" value="${parentCategory.categoryname3}" />
<%-- 	<input type="text" name="tt" value="${lyData.frmId}" /> --%>
	
	
	<input type="hidden" name="browserName" id="browserName"/>
	<input type="hidden" name="browserVersion" id="browserVersion"/>
	
	
	<input type="hidden" name="browserName" id="browserName"/>
	<input type="hidden" name="browserVersion" id="browserVersion"/>
	
	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">브랜드 카테고리 분류 등록</h2>
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
								<c:if test="${parentCategory.typelevel eq '' || parentCategory.typelevel eq NULL}">
									상위 코드 없음 (제일 상위 입니다.)
								</c:if>
								<c:if test="${parentCategory.typelevel eq '1'}">
									<c:out value="${parentCategory.categoryname1}" /> (<c:out value="${parentCategory.categorytype1}" />)
								</c:if>
								<c:if test="${parentCategory.typelevel eq '2'}">
									<c:out value="${parentCategory.categoryname2}" /> (<c:out value="${parentCategory.categorytype2}" />)
								</c:if>
							</td>
						</tr>
						<tr>
							<th>분류레벨</th>
							<td>
								<fmt:parseNumber var="iTypeLevel" type="number" value="${parentCategory.typelevel}" />
								카테고리 <c:out value="${iTypeLevel + 1}"/>&nbsp;&nbsp;
							</td>
						</tr>
						<tr>
							<th>분류코드</th>
							<td>
								<c:if test="${parentCategory.typelevel eq '' || parentCategory.typelevel eq NULL}">
									<c:out value="자동 생성"/>
<!-- 									<input type="text" id="categorytype" name="categorytype" maxlength="3" oninput="maxLengthCheck(this)" class="required" title="분류코드" />&nbsp;(3charactor) -->
								</c:if>
								<c:if test="${parentCategory.typelevel eq '1'}">
									<c:out value="자동 생성"/>
<!-- 									<input type="text" id="categorytype" name="categorytype" maxlength="5" oninput="maxLengthCheck(this)" class="required" title="분류코드" />&nbsp;(5charactor) -->
								</c:if>
								<c:if test="${parentCategory.typelevel eq '2'}">
									<c:out value="자동 생성"/>
<!-- 									<input type="text" id="categorytype" name="categorytype" maxlength="7" oninput="maxLengthCheck(this)" class="required" title="분류코드" />&nbsp;(7charactor) -->
								</c:if>
							</td>
						</tr>
						<c:if test="${parentCategory.categorytype2 eq 'E0301' }">
							<tr id="imgFile">
								<th>브랜드이미지</th>
								<td>
									<input type="file" id="brandImg" name="brandImg" class="required" title="브랜드이미지" />
								</td>
							</tr>
						</c:if>
						
						<tr>
						<c:if test="${parentCategory.typelevel eq '1' || parentCategory.typelevel eq '2'}">
							<th>(하위)카테고리 명</th>
							<td>
								<input type="text" id="categoryname" name="categoryname" class="required" title="분류코드명">
							</td>
						</c:if>
						
						<c:if test="${parentCategory.typelevel eq '' || parentCategory.typelevel eq NULL}">
							<th>카테고리 명</th>
							<td>
								<input type="text" id="categoryname" name="categoryname" class="required" title="분류코드명">
							</td>
						</c:if>
						</tr>
						<c:if test="${parentCategory.typelevel eq '' || parentCategory.typelevel eq NULL}">
						<tr>
							<th>예약 타입</th>
							<td>
									<select id="typeseq" name="typeseq" style="width:auto; min-width:100px" class="required" title="카테고리">
										<option value="">선택</option>
										<c:forEach var="item" items="${expTypeInfoCodeLIst}">
											<option value="${item.commonCodeSeq}">${item.codeName}</option>
										</c:forEach>
									</select>
							</td>
						</tr>
						</c:if>
						
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
				<br />
				<div class="btnwrap clear">
					<a href="javascript:planSave();" id="aInsert" class="btn_green">저장</a>
					<a href="javascript:void(0);" id="aInsertEnd" class="btn_green close-layer">취소</a>
				</div>
			</div>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
</form>
