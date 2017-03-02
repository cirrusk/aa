(function($) {
	$.sponsor = {
			init : function(){
				// 본인확인
				if($("#personallyCertify").length){
					personallyCertify = null;
					personallyCertify = new certify({
						init : function(){
							$(".searchChangeSponsorResult").hide();
							
							// 모바일 본인 인증 화면 전환 후 처리
							if($("#certifyPost").val() == "true")
							{
								if($.trim($("#certifyErrMessage").val()).length <= 0)
								{
									this.processCertify(this);
								}
								else
								{
									this.applyInitCertify();
								}
							}
							else
							{
								this.applyInitCertify();
							}
						},
						successCertify : function(){
							$("div.authOk").show();
							
							if($("#pbContent").hasClass("requestPage")){
								$.sponsor.getPreSponsor();
								$(".searchPreSponsorResult").show();
							} else if($("#pbContent").hasClass("approvalPage")) {
								$.approval.getList();
							}
						}
					});
					
					$("a.certifyPopup").bind("click", function(){					
						personallyCertify.applyInitCertify();
					});
				}
				
				// 후원자 정정 페이지일 경우
				if($("#pbContent").hasClass("requestPage")){
					
					// 후원자 정정 불가능 시 ( 회원가입 후 90일이 지난 경우 ) 알림 후 redirect.
					if($("#isPossibleSponsorChange").val() == 'false') {
						alert($.msg.sponsor.impossible);
						window.location.href = "/mypage/personalinfo/change";
					}
					
					// 후원자 정정 신청이 완료되었지만, process 상태가 fail일 경우 알림 후 parent를 reload 후 팝업창 닫음.
					if($("#processStatus").length > 0 && $("#failProcessed").length > 0){
						if($("#processStatus").val() == "APPROVED" && $("#failProcessed").val() == "true"){
							alert($.msg.sponsor.processing);
							window.location.href = "/mypage/personalinfo/change";
						}
					}
				}
			},
			callAjax : function(type, url, dataType, form, successCallBack, errorCallBack){
				$.ajax({
					type     : type,
					url      : url,
					dataType : dataType,
					data: $(form).serialize(),
					success: function (data){
						if( typeof successCallBack === 'function' ) { successCallBack(data); }
						return false;
					},
					error: function(xhr, st, err){
						xhr = null;
						if( typeof errorCallBack === 'function' ) { 
							errorCallBack(); 
						} else {
							alert($.msg.err.system);
						}
						return false;
					}
				});				
			},
			getPreSponsor : function() {
				// 기존의 후원자를 가지고 오는 메소드
				$.sponsor.callAjax('GET', $.comm.ajaxUrl.sponsorChangePreSponsor, 'json', null, function successCallBack(data){
					$("#preSponsorNo").html(data.uid);
					$("#preSponsorName").html(data.name);
				}, null);
			},
			searchSponsor : function() {
				// 변경할 후원자 조회 메소드 
				var sponNum = $.trim($("#sponserNo").val());
				if(!$.sponsor.checkSponsorNo(sponNum)) return;
				
				loadingLayerS();
				$.comm.searchSponsor(sponNum, function(data){
					
					if(data.result == true)
					{
						$.sponsor.searchResult(".exists", ".notExists", data.sponsorNo, data.sponsorName);
						$("#sponsorUid").val(data.sponsorNo);
						loadingLayerSClose();
					}
					else
					{
						alert(data.message);
						
						$.sponsor.searchResult(".notExists", ".exists", "", "");
						$("#sponsorUid").val("");
						loadingLayerSClose();
					}
				}, function(){
					alert($.msg.err.system);
					loadingLayerSClose();
				});
			},
			searchResult : function(eShow, eHide, sSponsorNo, sSponsorNm){
				if(eShow || eHide){
					$(".searchChangeSponsorResult").show();
				}
				$(eShow).show();
				$(eHide).hide();
				$("#changeSponsorNo").html("<strong>후원자 번호 :</strong> " + sSponsorNo);
				$("#changeSponsorName").html("<strong>후원자 이름 :</strong> " + sSponsorNm);
			},
			checkSponsorNo : function(sponNum) {
				
				// 후원자  조회 시 입력 값 체크
				if (sponNum == null || sponNum.length <= 0 || /\D/.test(sponNum)) {
					alert($.msg.sponsor.doNotSponsorNo);
					$("#sponsorUid").val("");
					$("#sponserNo").focus();
					return false;
				}
				
				// 변경할 후원자와 기존의 후원자가 동일한지 확인
				var preSponsor = $("#preSponsorNo").html();
				if (sponNum == preSponsor) {
					alert($.msg.sponsor.equalPreSponsorToChangeSponsor);
					$("#sponsorUid").val("");
					$("#sponserNo").focus();
					return false;
				}
				
				return true;
			},
			checkPhoneNIpinAuth : function() {
				// 후원자 요청 및 승인 할 때 본인인증 여부를 확인한다.
				if(!personallyCertify.getStatus()) {
					alert($.msg.sponsor.checkPhoneNIpinAuthNo);
					return false;
				}
				
				return true;
			}
	},
	$.request = {
			save : function() {
				// 후원자 정정 신청 메소드
				var sponsorNo = $("#sponsorUid").val();
				
				if(!$.sponsor.checkSponsorNo(sponsorNo)) return;
				
				if(!$.sponsor.checkPhoneNIpinAuth()) return;
				
				$.sponsor.callAjax('POST', $.comm.ajaxUrl.sponsorChangeRequestSave, 'json', "#sponsorChangeAppralRequestForm", function successCallBack(data){
					if(data.result == true){
						alert(data.message);
						window.location.reload();
					}else{
						$.ajaxUtil.errorMessage(data);
					}
				}, null);
			},
			cancel : function() {
				// 후원자 정정 취소 메소드
				if(confirm($.msg.sponsor.changeSponsorRequestCanel)) {
					$.sponsor.callAjax('POST', $.comm.ajaxUrl.sponsorChangeRequestCancel, 'json', "#sponsorChangeAppralRequestForm", function successCallBack(data){
						if(data.result == true){
							alert(data.message);
						}else{
							$.ajaxUtil.errorMessage(data);
						}
						window.location.reload();
					}, null);
				}
			}
	},
	$.approval = {
			getList : function() {
				// 후원자 현황 리스트를 가져오는 메소드
				$.sponsor.callAjax('GET', $.comm.ajaxUrl.sponsorChangeApprovalListGet, 'html', null, function successCallBack(data) {
					$("#approvalList").html(data);
				}, null);
			},
			setForm : function(approvalBtn) {
				$("#sponsorChangeAppralRequestForm #code").val($(approvalBtn).data("code"));
				$("#sponsorChangeAppralRequestForm #approval").val($(approvalBtn).data("approval"));
			},
			save : function() {
				// 후원자 정정 (미)승인 메소드 
				if(!$.sponsor.checkPhoneNIpinAuth()) return;
				
				if(confirm($("#approval").val() == 'true' ? $.msg.sponsor.changeSponsorApprovalOk : $.msg.sponsor.changeSponsorApprovalNo)) {
					$.sponsor.callAjax('POST', $.comm.ajaxUrl.sponsorChangeApprovalSave, 'json', "#sponsorChangeAppralRequestForm", function successCallBack(data){
						if(data.result == true){
							alert(data.message);
						}else{
							$.ajaxUtil.errorMessage(data);
						}
						$.approval.getList();
					}, null);
				}
			}
	}
})(jQuery);

//후원자 조회
$(document).on("click", "#searchSponsor", function(){
	$.sponsor.searchSponsor();
});

//후원자 번호 입력후 엔터키 이벤트 조회
$(document).on("keydown", "#sponserNo", function(e) {
	if (e.which == 13) {
		$.sponsor.searchSponsor();
	}
});

// 후원자 정정 신청
$(document).on("click", "#requestSaveSponsor", function() {
	if($("#chkRequestSaveSponsor").length > 0){
		if($("#chkRequestSaveSponsor").is(":checked")){
			$.request.save();
		}else{
			alert($.msg.sponsor.chkMsg);
			return false;
		}
	}else{
		$.request.save();
	}
});

// 후원자 정정 취소
$(document).on("click", "#requestCancelSponsor", function() {
	$.request.cancel();
});

// 후원자 정정 현황 (미)승인
$(document).on("click", ".approvalBtn", function() {
	$.approval.setForm(this);
	$.approval.save();
});

$("document").ready(function(){
	$.sponsor.init();
});