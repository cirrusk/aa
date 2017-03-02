<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>
<%@ page import = "amway.com.academy.manager.lms.common.LmsCode" %>
<%-- 
<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
 --%>
<script type="text/javascript">	

$(document).ready(function(){
	var managerMenuAuth =$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.managerMenuAuth;
	$("#insertBtn").on("click", function(){
		if(checkManagerAuth(managerMenuAuth)){return;}
		//입력여부 체크
		if(!chkValidation({chkId:"#tblSearch", chkObj:"hidden|input|select"}) ){
			return;
		}
		
		if( isNull($("#surveyname").val()) ) {
			alert("설문문항을 입력하세요.");
			return;
		}
		
		var sampleList = new Array;
		if( $("#surveytype").val() == "1" || $("#surveytype").val() == "2" ) {
			var valueCheck = false;
			var valueCount = 0;
			var idx = 0;
			for( idx=0; idx<$("#samplecount").val(); idx++ ) {
				//입력값 체크				
				if( isNull($("#samplename_"+(idx+1)).val()) ) {
					alert("보기를 입력하세요.");
					return;
				}
				
				if( !isNull($("#samplevalue_"+(idx+1)).val()) ) {
					if( !isNumber($("#samplevalue_"+(idx+1)).val()) ) {
						alert("척도를 숫자로 입력하세요.");
						return;
					}
					valueCount ++;
					valueCheck = true;
				}
				
				var sampleArr = new Array; 
				//배열에 값 담기
				if( $("input:checkbox[id='sampleseqCheckbox_"+(idx+1)+"']").is(":checked") ) {
					sampleArr[0] = "Y";
				} else {
					sampleArr[0] = "N";
				}
				sampleArr[1] = $("#samplename_"+(idx+1)).val();
				sampleArr[2] = $("#samplevalue_"+(idx+1)).val();
				
				sampleList.push(sampleArr);
			}
			
			if( valueCheck && valueCount != $("#samplecount").val() ) {
				alert("척도를 모두 입력하세요.");
				return;
			}
			
			for(; idx<10; idx++ ) {
				var sampleArr = ["","",""];
				sampleList.push(sampleArr);
			}
		} else {
			for(var idx=0; idx<10; idx++ ) {
				var sampleArr = ["","",""];
				sampleList.push(sampleArr);
			}
		}
		
		if( !confirm("저장 하겠습니까?") ) {
			return;
		}
		
		var inputVal = {
			surveyseq : $("#surveyseq").val()	
			, surveyname : $("#surveyname").val()
			, surveytype : $("#surveytype").val()
			, surveytypename : $("#surveytype option:selected").text()
			, samplecount : $("#samplecount").val()
			, sampleList : sampleList,
		};
		
		//아래의 grid 콘트롤 하기
		if( $("#inputtype").val() == "I" ) {
			$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.fn_addGrid( inputVal );	
		} else {
			$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.fn_updateGrid( inputVal );
		}
		
		closeManageLayerPopup("searchPopup");
	});
	
	$("#surveytype").on("change", function(){
		if( $("#surveytype").val() == "1" || $("#surveytype").val() == "2" ) {
			$("#sampleArea").show();
			$("#samplecount").show();
			
			//선다형은 척도점수를 삭제함
			if( $("#surveytype").val() == "1" ) {
				$("input[name=samplevalue]").attr("readonly", false);
			} else if( $("#surveytype").val() == "2" ) {
				$("input[name=samplevalue]").val("");
				$("input[name=samplevalue]").attr("readonly", true);
			}
			
		} else {
			$("#sampleArea").hide();
			$("#samplecount").hide();
		}
	});
	
	$("#samplecount").on("change", function(){
		var idx = 0;
		for(idx=0;idx<$("#samplecount").val(); idx++) {
			$("#samplelist_"+(idx+1)).show();
		}
		for(;idx<10; idx++) {
			$("#samplelist_"+(idx+1)).hide();
		}
	});
	
});
</script>

	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">설문문항 등록</h2>
			<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
		<div id="popcontainer"  style="height:600px">
			<div id="popcontent">
				<div class="tbl_write">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="15%" />
							<col width="85%"  />
						</colgroup>
						<tr>								
							<th>설문문항 </th>
							<td>
								<input type="hidden" id="inputtype" name="inputtype" value="${detail.inputtype}">
								<input type="hidden" id="surveyseq" name="surveyseq" value="${detail.surveyseq}">
								<textarea id="surveyname" name="surveyname" class="AXInput required" style="width:90%;height:100px;" title="설문문항명">${detail.surveyname}</textarea>
							</td>
						</tr>
						<tr>								
							<th>유형 </th>
							<td>
								<select id="surveytype" name="surveytype" class="required" style="width:auto; min-width:100px" >
									<c:forEach var="codeList" items="${surveyTypeList}" varStatus="idx">
										<option value="${codeList.value}" <c:if test="${codeList.value == detail.surveytype}">selected</c:if> >${codeList.name}</option>
									</c:forEach>
								</select>
								
								<select id="samplecount" name="samplecount" style="width:auto; min-width:80px;<c:if test="${detail.surveytype == '3' || detail.surveytype == '4'}">display:none;</c:if>" >
									<c:forEach var="codeList" varStatus="idx" begin="2" end="10">
										<option value="${codeList}" <c:if test="${codeList == detail.samplecount}">selected</c:if> >${codeList}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr id="sampleArea" <c:if test="${detail.surveytype == '3' || detail.surveytype == '4'}">style="display:none;"</c:if>>
							<th>보기-척도 </th>
							<td>
								<table id="tblObjSample" class="required" width="100%" border="0" cellspacing="0" cellpadding="0">
									<colgroup>
										<col width="10%" />
										<col width="80%"  />
										<col width="10%"  />
									</colgroup>
									<tr>
										<th style="text-align:center;">텍스트</th>
										<th style="text-align:center;">보기</th>
										<th style="text-align:center;">척도</th>
									</tr>
									<c:forEach var="dataList" items="${dataList}" varStatus="idx">
									<tr id="samplelist_${idx.count}" <c:if test="${dataList.sampledisplay == 'N'}">style="display:none;"</c:if>>
										<td style="text-align:center;">
											<input type="checkbox" id="sampleseqCheckbox_${idx.count}" name="sampleseqCheckbox" value="${dataList.sampleseq}" <c:if test="${dataList.directyn == 'Y'}">checked</c:if>/>
										</td>
										<td>
											<input type="text" id="samplename_${idx.count}" name="samplename" style="width:auto; min-width:450px" maxlength="50" value="${dataList.samplename}" />
										</td>
										<td style="text-align:center;">
											<input type="text" id="samplevalue_${idx.count}" name="samplevalue" style="width:20px" maxlength="2" value="${dataList.samplevalue}" />
										</td>
									</tr>
									</c:forEach>
								</table>
							</td>
						</tr>
					</table>
				</div>	
 		
				<div align="center">
					<a href="javascript:;" id="insertBtn" class="btn_green">저장</a>
					<a href="javascript:;" id="closeBtn" class="btn_green close-layer">취소</a>
				</div>						
			</div>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
