<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>

<script type="text/javascript">	

	$(document.body).ready(function(){

		//샘플파일다운 클릭시
		$("#sampleBtn").on("click", function(){
			var result = confirm("엑셀 내려받기를 시작 하겠습니까?\n 네트워크 상황에 따라서 1~3분 정도 시간이 걸릴 수 있습니다.");
			if(result) {
				showLoading();
				var initParam = {
					exceltype : "authexcel"
				};
				postGoto("<c:url value="/manager/common/auth/authGroupListPopExcelDownload.do"/>", initParam);
				hideLoading();
			}
		});

		//등록버튼 클릭시
		$("#excelRegister").on("click", function(){
			var fileYn = false;
			var fileExt = "";
			$( "input:file" ).each(function( index ){
				if($( this ).val().length>0 ){
					fileYn = true;
					var _lastDot = $( this ).val().lastIndexOf('.');
					fileExt = $( this ).val().substring(_lastDot+1, $( this ).val().length).toLowerCase();
				}
			});

			if(!fileYn){
				alert("등록할 엑셀파일을 선택하세요.");
				return;
			}
			if( fileExt != "xlsx" && fileExt != "xls" ) {
				alert("엑셀파일만 입력하세요.");
				return;
			}
			if( !confirm("운영자를 엑셀파일로 추가하시겠습니까?") ) {
				return;
			}

			$("#frm").ajaxForm({
				dataType:"json",
				data:{mode:"excel"},
				url:'/manager/lms/common/lmsFileUploadAjax.do',
				beforeSubmit:function(data, form, option){
					return true;
				},
				success: function(result, textStatus){

					for(i=0; i<result.length;i++){
						$("#"+result[i].fieldName+"file").val(result[i].FileSavedName);
					}
					saveSubmit();
				},
				error: function(){
					alert("파일업로드 중 오류가 발생하였습니다.");
					return;
				}
			}).submit();
		});

	});

	//엑셀파일 등록 로직
	function saveSubmit(){
		var param = $("#frm").serialize();
		$.ajaxCall({
			url : "<c:url value="/manager/common/auth/authGroupListPopExcelUploadAjax.do"/>"
			, data : param
			, type: 'POST'
			, contentType: 'application/x-www-form-urlencoded; charset=UTF-8'
			, success: function( data, textStatus, jqXHR){
				if(data.comment != null && data.comment != "")
					{
						alert(data.comment);
					}
				else
					{
						alert(data.cnt+"건 등록 되었습니다.");
					}
			},
			error: function( jqXHR, textStatus, errorThrown) {
				var msg = '<spring:message code="errors.load"/>';
				alert(msg);
				return;
			}
		});
	}

	//chkSubmit(유효성 체크 대상, 메시지)
	function chkSubmit(v_item, v_msg) {
		if(v_item.val().replace(/\s/g,"")==""){
			alert(v_msg+" 입력해 주세요");
			v_item.val("");
			v_item.focus();
			return false;
		} else {
			return true;
		}
	}

	function goInsertUpdate(mode) {
		if(!chkSubmit($("#adno"),"AD계정을")) return;
		else if(!chkSubmit($("#managename"),"이름을")) return;
		else if(!chkSubmit($("#managedepart"),"부서를")) return;
		else {
			var param = $("#dataForm").serialize()

			$.ajaxCall({
				url: "<c:url value="/manager/common/auth/authGroupListPopInsertUpdateAjax.do"/>"
				, data : param+"&mode="+mode
				, type: 'POST'
				, contentType: 'application/x-www-form-urlencoded; charset=UTF-8'
				, success: function( data, textStatus, jqXHR){
					if(data.result < 1){
						var msg = '<spring:message code="errors.load"/>';
						alert(msg);
						return;
					} else if(data.result == 2){
						alert(data.comment);
					} else {
						alert("등록 되었습니다.");
						$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.goAuthorize(data.adno);

						var frmId = $("input[name='frmId']").val();
						eval($('#ifrm_main_'+frmId).get(0).contentWindow.doReturn());

						closeManageLayerPopup("authPopup");
					}
				},
				error: function( jqXHR, textStatus, errorThrown) {
					var msg = '<spring:message code="errors.load"/>';
					alert(msg);
					return;
				}
			});
		}
	}

	
</script>

<div id="popwrap">
	<input type="hidden" name="frmId" value="${layerMode.frmId}"/>
	<!--pop_title //-->
	<div class="title clear">
		<h2 class="fl">운영자 기본정보 등록</h2>
		<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
	</div>

	<!-- Contents -->
	<div id="popcontainer"  style="height:430px">
		<div id="popcontent">

			<form id="frm" name="fileform" method="post" enctype="multipart/form-data">
				<div class="tbl_write">
					<input type="hidden" id="authregisterexcelfile" name="authregisterexcelfile" value="" title="" />
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="25%"  />
							<col width="75%" />
						</colgroup>
						<tr>
							<th>일괄 등록</th>
							<td>
								<input type="file" id="authregisterexcel" name="authregisterexcel"  class="required"  accept=".xlsx,.xls" title="첨부파일" style="width:auto; min-width:200px" required="required">
								<a href="javascript:;" id="sampleBtn" class="btn_green"> 샘플파일다운로드</a>
								<a href="javascript:;" id="excelRegister" class="btn_green"> 일괄등록</a>
							</td>
						</tr>
						<tr>
							<th>PP List</th>
							<td>
								<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
									<colgroup>
										<col width="17%"  />
										<col width="8%" />
										<col width="17%"  />
										<col width="8%" />
										<col width="17%"  />
										<col width="8%" />
										<col width="17%"  />
										<col width="8%" />
									</colgroup>
									<tr>
										<th>장소</th>
										<th>번호</th>
										<th>장소</th>
										<th>번호</th>
										<th>장소</th>
										<th>번호</th>
										<th>장소</th>
										<th>번호</th>
									</tr>
									<c:forEach items="${ppList}" var="ppList" varStatus="status">
										<c:if test="${status.index%4 eq 0 }">
											<tr>
										</c:if>
											<td>${ppList.ppname }</td>
											<td>${ppList.ppseq }</td>
										<c:if test="${status.index%4 eq 3 or status.last }">
											</tr>
										</c:if>
									</c:forEach>
								</table>
							</td>
						</tr>
					</table>
				</div>
			</form>

			<div class="tbl_write">
				<form id="dataForm">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="25%"  />
							<col width="20%" />
							<col width="20%" />
							<col width="20%" />
							<col width="10%" />
						</colgroup>
						<tr>
							<th>AD계정</th>
							<th>이름</th>
							<th>부서</th>
							<th>PP소속 해당</th>
							<th>등록</th>
						</tr>
						<tr>
							<c:if test="${param.mode eq 'I' }">
								<td><input type="text" name="adno" id="adno" class="required"  title="AD계정"  required="required"></td>
							</c:if>
							<c:if test="${param.mode eq 'U' }">
								<td><input type="text" name="adno"   id="adno" class="required"   value="${param.adno }"  readonly="readonly"  required="required"></td>
							</c:if>

							<td><input type="text" id="managename" name="managename" title="이름" class="required"   required="required" value="${info.managename }"></td>
							<td><input type="text" id="managedepart" name="managedepart"  title="부서"  class="required"   required="required" value="${info.managedepart }"></td>
							<td>
								<select name="ppseq">
									<option value="">전국 AP</option>
									<c:forEach items="${ppList}" var="ppList">
										<c:choose>
											<c:when test="${ppList.ppseq eq info.apseq }">
												<option value="${ppList.ppseq }" selected="selected">${ppList.ppname }</option>
											</c:when>
											<c:otherwise>
												<option value="${ppList.ppseq }">${ppList.ppname }</option>
											</c:otherwise>
										</c:choose>
									</c:forEach>
								</select>
							</td>
							<td>
								<input type="button" onclick="goInsertUpdate('${param.mode}')" value="저장">
							</td>
						</tr>
					</table>
				</form>
			</div>

			<div class="contents_title clear">
				<div class="fr">
					<a href="javascript:;" id="closeBtn" class="btn_green close-layer"> 닫기</a>
				</div>
			</div>

		</div>
	</div>
</div>
