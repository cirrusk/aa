<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>

<script type="text/javascript">	
	var excelPopup = {
		excelUpload:function(){
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
				alert("등록할 엑셀파일을 선택해주십시오.");
				return;
			}
			if( fileExt != "xlsx" && fileExt != "xls" ) {
				alert("엑셀파일만 가능합니다.");
				return;
			}

			if(!chkValidation({chkId:"#tblSearch", chkObj:"hidden|input|select"}) ){
				return;
			}

			var result = confirm("엑셀 일괄 업로드를 진행 하시겠습니까?");

			if(result) {
				var params = {
					groupseq : $("#groupseq").val(),
					targetgroupname : $("#targetgroupname").val(),
					targetuse : $("#targetuse").val(),
					cookmastercode : $("#cookmastercode").val(),
					gubun : "one"
				};

				$("#frmFile").ajaxForm({
					url     : "<c:url value="/manager/common/targetUpload/excelFileUpload.do"/>"
					, method  : "post"
					, data    : params
					, async   : false
					, beforeSend: function(xhr, settings) { showLoading(); }
					, complete: function (xhr, textStatus) { hideLoading(); }
					, success : function(data){
						hideLoading();
						var item = JSON.parse(data);

						if( item.errCode == 0 ) {
							var frmId = $("input[name='frmId']").val();
							alert(item.importCount+"건 엑셀 업로드가 완료 되었습니다.");
							eval($('#ifrm_main_'+frmId).get(0).contentWindow.doReturn());
							closeManageLayerPopup("searchPopup");
						} else if(item.errCode < 0){
							alert("존재 하지 않는 ABO번호가 있습니다.");
						}
					}, error : function(data){
						hideLoading();
						alert("엑셀 업로드 처리 중 오류가 발생 하였습니다.");
					}
				}).submit();
			} else {
				hideLoading();
			}
		}
  	}

</script>

	<div id="popwrap">
		<input type="hidden" name="frmId" value="${layerMode.frmId}"/>
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">
				Window
			</h2>
			<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
		<div id="popcontainer"  style="height:270px">
			<div id="popcontent">
				<!-- Sub Title -->
				<div class="poptitle clear">
					<h3>대상자일괄업로드</h3>
				</div>
				<!--// Sub Title -->
			<form id="frmFile" name="fileform" method="post" enctype="multipart/form-data">
				<div class="tbl_write">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th scope="row" style="text-align: center;">대상자그룹코드</th>
							<td>
								<label>0000000000(코드는 자동 생성됩니다.)</label>
								<input type="hidden" id="groupseq" class="AXInput" style="min-width:303px;"/>
							</td>
						</tr>
						<tr>
							<th scope="row" style="text-align: center;">대상자그룹명</th>
							<td>
								<input type="text" id="targetgroupname" value="" class="AXInput required" maxlength="33" title="대상자그룹명" style="min-width:303px;" id="targetgroupname"/>
							</td>							
						</tr>
						<tr>
							<th scope="row" style="text-align: center;">사용용도</th>
							<td>
								사용용도를 적어 주세요<br>
								<input type="text" id="targetuse" class="AXInput required" maxlength="66"  title="사용용도" style="min-width:303px;"/>
							</td>
						</tr>
						<tr>
							<th scope="row" style="text-align: center;">요리명장여부</th>
							<td>
								<select id="cookmastercode" class="required" title="요리명장여부">
									<option value="">전체</option>
									<option value="C01">Y</option>
									<option value="C02">N</option>
								</select>

							</td>
						</tr>
						<tr>
							<th scope="row" style="text-align: center;">대상자그룹<br>엑셀등록파일<br>업로드</th>
							<td>
								<label>내컴퓨터에 작성된 엑셀 등록파일을 등록하도록 합니다. 입력결과 오류메시지가 발생할 경우, 등록파일을 재수정하여 등록하도록 합니다.</label>
								<br>
								<div style="background: aliceblue; height: 85px;">
									<div style="text-align: center; padding-top: 25px;">·업로드&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="file" id="file" name="file" title="첨부파일" class="required" accept=".xlsx,.xls" title="첨부파일" style="min-width:500px;"/>
									</div>
								</div>
							</td>
						</tr>
					</table>
				</div>				
			</form>
				<div class="btnwrap mb10">
					<a href="javascript:;" class="btn_green" id="testBtn" onclick="excelPopup.excelUpload();">업로드</a>
					<button id="closebTn" class="btn_close close-layer" >취소</button>
				</div>
			</div>
		</div>
	</div>
