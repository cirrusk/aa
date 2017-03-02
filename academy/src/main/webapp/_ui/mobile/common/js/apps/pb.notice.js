(function($) {
	$.notice = {
			init : function(){
				
				// 비로그(member)인 사용자
				$.notice.isLogin = $("#isLoginTarget").val();
				$.notice.data.page = $("#noticeSearchForm #page").val() || 1;
				$.notice.data.noticeType = $("#noticeSearchForm #noticeType").val() || "";
				$.notice.data.searchType = $("#noticeSearchForm #searchType").val() || "ALL";
				$.notice.data.searchVal = $("#noticeSearchForm #searchVal").val() ||"";
				$.notice.data.readMessageAuth = $("#noticeSearchForm #readMessageAuth").val() || "customergroup";
				$.notice.data.isSeeMore = (Number($("#noticeSearchForm #totPage").val()) || 1) > (Number($.notice.data.page) || 1) ? "true" : "false"; // 더 보기 정보 세팅
				$.notice.setSeeMore();
				
				$.notice.data.tempNoticeType = $("#noticeSearchForm #noticeType").val() || "ALL";
				
				if($("#res_h_refresh").val() == "Y"){
					//공지사항 type 설정
					$("section").removeClass("on");
					$("#"+($.notice.data.noticeType || "ALL")).parent().parent().addClass("on");
					
					//권한 설정
					var authority = ($.notice.data.readMessageAuth).split(",");
					var authorityId = authority[0];
					if($("#res_h_authorityName").val()){
						$("section div div.titP").html($("#res_h_authorityName").val());
						
						$("#uiLayerPop_notiSearch li").removeClass("on");
						$("#uiLayerPop_notiSearch").find("#"+authorityId).addClass("on");
					}
					$("#uiLayerPop_notiSearch").find("#"+authorityId).children(":radio[name='inquiryAuth']").attr("checked", true);
					
				}
				
			},
			focusTitle : function(){
				if( $("#noticeSearchForm #startId").val() ){
					$("li").find("a[data-id='"+$("#noticeSearchForm #startId").val()+"']").focus();
				}
			},
			currUserGroup : "customergroup",
			isLogin : false,
			data : {},
			currNoticeType : function(){
				var type = $.trim($("section.on h2 a").attr("id")) || "";
				return type=="ALL" ? "" : type;
			},
			currSearchType : function(){
				return $("div.listSchB #SearchType option:selected").val();
			},
			callAjax : function(type, url, dataType, form, successCallBack, errorCallBack){
				loadingLayerS();
				$.ajax({
					type     : type,
					url      : url,
					dataType : dataType,
					data: $(form).serialize(),
					success: function (data){
						if( typeof successCallBack === 'function' ) { successCallBack(data); }
						loadingLayerSClose();
						return false;
					},
					error: function(xhr, st, err){
						xhr = null;
						if( typeof errorCallBack === 'function' ) {
							loadingLayerSClose();
							errorCallBack(); 
						} else {
							loadingLayerSClose();
							alert($.msg.err.system);
						}
						return false;
					}
				});				
			},
			returnList : function(element){
				$.detail.pageMove(element);
			},
			applyReadMessageAuth : function(){
				param = {};
				param.readMessageAuth = $.notice.data.readMessageAuth || "customergroup";
				$.ajax({
					type     : "GET",
					url      : "/customer/notification/apply-ReadMessageAuth",
					dataType : "json",
					data	 : param,
					success: function (data){						
						alert($.msg.notice.authorityChangeSuccess);
						$.list.getSearchData();	
						
						var authority = ($.notice.data.readMessageAuth).split(",");
						var authorityName = '$.msg.notice.'+authority[0].toLowerCase();
						var authorityHtml = '<strong class="colorM">현재 조회권한 :</strong> '+eval(authorityName)+'<a href="/account/login" class="btnTbl" id="changAuth"><span class="hide">조회권한</span>변경</a>';
						$("#res_h_authorityName").val(authorityHtml);
						$("section div div.titP").html(authorityHtml);

						$(".btnPopClose").trigger("click");
						return false;
					},
					error: function(xhr, st, err){
						alert($.msg.err.system);
					}
				});
			},
			setSeeMore : function(){
				if($.notice.data.isSeeMore == "false"){
					$("section.on div .listMore").hide();
				}else{
					$("section.on div .listMore").show();
				}
			},
		    utils : {
		        castData : function(isReverse)
		        {
		              $.each($("input.reflashVal"), function()
		              {
		                     var field = $(this).data("cast");
		                     if(field)
		                     {
		                           var castObj = isReverse ? $(field) : $(this);
		                           var orgObj  = isReverse ? $(this)  : $(field);
		                           if(castObj.length && orgObj.length){
		                                  castObj.val(orgObj.val());
		                           }
		                     }
		              });
		        }
		    }
			
	},
	$.detail = {		
			pageMove : function(element){
				$("#noticeSearchForm").attr("action", $(element).attr("href"));
				
				$("#noticeSearchForm #id").val($(element).data("id")||"");
				
				if($(element).data("startid")){
					$("#noticeSearchForm #startId").val($(element).data("startid")||"");
				}
				$("#noticeSearchForm #detailPage").val($(element).data("detailpage")|| $("#noticeSearchForm #page").val());
				$("#noticeSearchForm #noticeType").val($(element).data("noticetype") || "");
				$("#noticeSearchForm #searchType").val($(element).data("searchtype") || "ALL");
				$("#noticeSearchForm #searchVal").val($(element).data("searchval") || "");
				$("#noticeSearchForm #popup").val($(element).data("isPopup") || "false");
				
				$("#res_h_refresh").val("Y");
				$.notice.utils.castData();
				
				if($("section.on div.newsList li").size() > 100){
					$("#res_h_page").val(1);
				}
				
				$("#noticeSearchForm").submit();
			}
	},
	$.list = {			
			getSearchData : function(){
				var actionUrl  = "/customer/notification/search";
				
				if($("#res_h_refresh").val() == "Y"){
					actionUrl = "/customer/notification/ajax/reloadList";
				}
				
				$.list.searchData($.notice);
				
				$.notice.callAjax('POST', actionUrl, 'html', "#noticeSearchForm", function successCallBack(data){
					if((Number($.notice.data.page) || 1) > 1 && $("#res_h_refresh").val() != "Y"){
						$("section.on div div.newsList ul").append(data);
					}else{
						var id = $.notice.data.noticeType == "" ? "ALL" : $.notice.data.noticeType;
						$("section").find("#"+id).parent().parent().find("div.newsList ul").html(data);
					}
					$("section.on div .listHead .listSearch fieldset input").blur();
					$.notice.setSeeMore();
					
					var result;
					if($.trim($.notice.data.searchVal).length){
						result = "검색 : "+$.notice.data.totCnt+"건";
					}else{
						result = "전체 "+$.notice.data.totCnt+" 건";
					}
					
					$("section.on .listHead span.listInfo").text(result);
					$(".listSearch fieldset .searchVal").val($.notice.data.searchVal);
					
					//백버튼으로 목록이동한 경우
					if($("#res_h_refresh").val() == "Y"){
						$.notice.focusTitle();
						$("#res_h_refresh").val("N");
					}
					
				}, function errorCallBack(){
					if($("#res_h_refresh").val() == "Y"){
						$("#res_h_refresh").val("N");
					}
					alert($.msg.err.system);
				});
				
			},
			search : function(){
				var searchVal = $.trim($("section.on input.searchVal").val());
				if(searchVal.length && searchVal.length < 2){
					//"검색어는 최소 2글자 이상 입력해 주세요."
					alert($.getMsg($.msg.common.minSearchText, "2"));
					$("section.on input.searchVal").focus();
					return;
				}
				
				$.notice.data.searchType = $.notice.currSearchType();
				$.notice.data.searchVal = searchVal;
				$.notice.data.page = 1;
				$.list.getSearchData();				
			},			
			searchData : function(notice){
				$("#noticeSearchForm #page").val(notice.data.page || 1);
				$("#noticeSearchForm #noticeType").val(notice.data.noticeType || "");
				$("#noticeSearchForm #searchType").val("ALL");
				$("#noticeSearchForm #searchVal").val(notice.data.searchVal || "");	
				$("#noticeSearchForm #readMessageAuth").val(notice.data.readMessageAuth || "customergroup");
				$("#noticeSearchForm #notEmptyText").val($.trim($("#noticeSearchForm #searchVal").val()).length >=1);
			}
	}

	
})(jQuery);

//다음 20개
$(document).on("click", "a.listMore", function(){
	$.notice.isLogin = $("#isLoginTarget").val();
	$.notice.data.page = Number($.notice.data.page || 1) + 1;
	$.notice.data.noticeType = $("#noticeSearchForm #noticeType").val();
	$.notice.data.searchVal = $("#noticeSearchForm #searchVal").val();
	
	$.list.getSearchData(); 
	
});

// 공지사항 게시물 조회
$(document).on("click", "a[class^='noticeItem']", function(e){
	e.preventDefault();
	$.detail.pageMove(this);
	
	
});

// 조회권한 변경
$(document).on("click", "input[name='inquiryAuth']", function(){
	
	$(".dotLineList.seachChgList li").removeClass("on");
	$(this).parent().addClass('on');
});

// 권한 변경 적용
$(document).on("click", "#applyAuthority", function(){
	$.notice.data.readMessageAuth =$("#uiLayerPop_notiSearch div.pbLayerContent ul.dotLineList.seachChgList li.on").data("readauth");
	$.notice.data.page = 1;	
	$.notice.applyReadMessageAuth();
});


// 검색버튼 클릭
$(document).on("click", "section.on div .btnSearch", function(e){
	$.list.search();
});

//검색 엔터클릭
$(document).on("keydown", "section.on input.searchVal", function(e){
	if(e.which == 13){
		$.list.search();
	}
});

// 조회권한 변경
$(document).on("click", "a#changAuth", function(e){
	if($.notice.isLogin == "true"){		
		if(!confirm($.msg.notice.loginRequired)){
			e.preventDefault();
		}
	}else{
		e.preventDefault();
		$("#loginTarger").trigger("click");
	}
});



// notice type 클릭 (전체 , 일반, 비즈니스, 아카데미)
$(document).on("click", "section h2[class^='tab0'] a", function(e){
	
	if($(this).attr("id") == $.notice.data.tempNoticeType){
		return;
	}
	// all일 경우 전체 검색
	$.notice.data.noticeType = $(this).attr("id") == "ALL" ? "" : $(this).attr("id");
	
	$.notice.data.tempNoticeType = $.notice.data.noticeType
	
	$.notice.data.page = 1;
	$.list.getSearchData();
});


// 목록
$(document).on("click", "#returnList", function(e){
	e.preventDefault();
	$.notice.returnList(this);
});

//팝업 취소버튼(팝업닫기)
$(document).on("click", "#cancelAuthority", function(){
	$(".btnPopClose").trigger("click");
});


$(document).ready(function(){
	if($("#res_h_refresh").val() == "Y"){
		$.notice.utils.castData(true);
		$.notice.init();
		$.list.getSearchData();
	}else{
		$.notice.init();
		$.notice.focusTitle();
	}
	// 공지사항 a tag url이 pilot limited bug report url이면 aboNo 추가
	$("#pbContent .tblDetailCont a[id='noticeBugReport']").each(function(){
		if(!PILOT_LIMITED_IS_LOGIN) {
			$(this).attr("href", "/account/login");
			$(this).removeAttr("target");
		}
		else if(!PILOT_LIMITED_IS_ABO) {
			$(this).attr("href", "javascript:alert('" + PILOT_LIMITED_ABO_MESSAGE + "');");
			$(this).removeAttr("target");			
		} else {
			if(PILOT_LIMITED_BUGREPORT_URL == $(this).attr("href")) {
				$(this).attr("href", PILOT_LIMITED_BUGREPORT_URL + "&aboNo=" + PILOT_LIMITED_ENCODE_ABO_NO);
			}
		}
	});
});

