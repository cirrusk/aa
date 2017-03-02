(function($) {
	$.opinion ={
			init : function(){
				$.opinion.validation.init();
				$.opinion.search.init();
				$.opinion.answer.init();
				
				$.opinion.data.page = ( Number($("#page").val()) || 1 ) < 1 ? 1 : ( Number($("#page").val()) || 1 ); // 페이지 세팅
				$.opinion.data.isSeeMore = ( Number($("#totPage").val()) || 1 ) > (Number($.opinion.data.page) || 1) ? "true" : "false"; // 더 보기 정보 세팅
				$.opinion.setSeeMore(); // 더 보기 적용
				
			},
			focusTitle : function(){
				if( $("#id").val() ){
					$("ul").find("a[data-id='"+$("#id").val()+"']").focus();
				}
			},
			data : {
				page : 1,
				id : null,  // 글 상세 보기 pk값
				isSeeMore : ""
			},
			page : {
				list     		: "/business/opinion/list",
				listAjax 		: "/business/opinion/list/ajax",
				reloadListAjax	: "/business/opinion/list/ajax/reloadList",
				writeView		: "/business/opinion/write",
				answerView	  	: "/business/opinion/reply",
				write    		: "/business/opinion/write/register",
				answer   		: "/business/opinion/reply/register",
				answerAuth  	: "/business/opinion/reply/ajax/write-auth", // 작정자만 재질문 가능
			},
			validation : {
				init : function(){
					$.validator.setDefaults({
						ignoreTitle 	: true,  focusCleanup 	: false, 
						focusInvalid 	: false, onclick 		: false, 
						onkeyup 		: false, onfocusout 	: false,
						showErrors 		: function(errorMap, errorList){
							if(errorList[0]){
								var oError = errorList[0];
								alert(oError.message);
								$(oError.element).focus();
							}
						},
						submitHandler: function(form){
							if($.opinion.answer.isPage()){
								$.opinion.callAjax("GET", $.opinion.page.answerAuth, {code : $("#id").val()}, "json", 
								function (data){
									if(data){
										form.submit();
									}else{
										alert($.msg.opinion.againQuestions);
										return false;
									}
								}, function(){
									
								});
							}else{
								form.submit();
							}
						}
					});
					
				    $("#opinionForm").validate();
				    $.opinion.validation.addValidaionRule();
				},
				addValidaionRule : function(){

					if($("#title").length){
				    	$("#title").rules("add", {
				    		required 		: true,
				    		maxlength		: 100,
				        	messages 		: {
				        		required	: $.getMsg($.msg.opinion.notEnterField, "제목"),
				        		maxlength 	: $.msg.opinion.enterLessThanCharacters
				        	}
				        });
					}
					
					if($("#detail").length){
				    	$("#detail").rules("add", {
				    		required 		: true,
				        	messages 		: {
				        		required	: $.getMsg($.msg.opinion.notEnterField, "내용")
				        	}
				        });	
					}
				},
				removeValidaionRule : function(){
					if($("#title").length){
						$( "#title" ).rules( "remove" );
					}
					
					if($("#detail").length){
						$( "#detail" ).rules( "remove" );
					}
				}
			},
			formSubmit : function(form, url, pass){
				$.opinion.search.set();
				$(form).attr("action", url);
				(pass ? $(form)[0] : $(form)).submit();
			},
			callAjax : function(type, url, oData, dataType, successCallBack, errorCallBack){
				$.opinion.search.set();

				$.ajax({
					type     : type,
					url      : url,
					dataType : dataType,
					data: $.isPlainObject(oData) ? oData : $(oData).serialize(),
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
			search : {
					init : function(){
						$.each($.opinion.data, function(key, value){
							if($("#opinionForm").find("#" + key).length){
								try{
									var value = $("#opinionForm").find("#" + key).val();
									eval("$.opinion.data." + key + " = " + value);
								}catch(e){}
							}
						});

						$.opinion.data.page = $.opinion.data.page || 1;
						$.opinion.data.id = $.opinion.data.id || null;
					},					
					set : function(){
						$.each($.opinion.data, function(key, value){
							$("#opinionForm").find("#" + key).val(value);
						});
					}
			},
			// 목록
			list : {
					search : function(){
						$.opinion.formSubmit($("#opinionForm"), $.opinion.page.list, true);
					},
					searchAjax : function(){
						
						var url = $.opinion.page.listAjax;
						
						if($("#res_h_refresh").val() == "Y"){
							url = $.opinion.page.reloadListAjax;
						}
						
						$.opinion.callAjax("POST", url, "#opinionForm", "html", function (data){
							if((Number($.opinion.data.page) || 1) > 1 && $("#res_h_refresh").val() != "Y"){
								$("#opinionForm ul").append(data);
							}else{
								$("#opinionForm ul").html(data);
							}
		    				$.opinion.setSeeMore();
		    				
		    				if($("#res_h_refresh").val() == "Y"){
		    					$.opinion.focusTitle();
								$("#res_h_refresh").val("N");
							}
		    				
						}, function errorCallBack(){
							if($("#res_h_refresh").val() == "Y"){
								$("#res_h_refresh").val("N");
							}
							alert($.msg.err.system);
						});
					}
			},
			// 글쓰기
			write : {	
					// 글쓰기 화면
					move : function(id){
						$.opinion.data.id = id;
						$.opinion.formSubmit($("#opinionForm"), $.opinion.page.writeView);
					},
					// 글등록
					register  : function(){
						$.opinion.formSubmit($("#opinionForm"), $.opinion.page.write);
					},
					cancel : function(){
						$.opinion.validation.removeValidaionRule();
						$.opinion.list.search();
					},
			},
			// 답글쓰기
			answer : {
					// 현페이지 답글 페이지 여부
					isPage : function(){
						return $("#answer").length >= 1;
					},
					init : function(){
						if($.opinion.answer.isPage() != true) return;
						
						var cntReplyAnswer = $("div.replyAnswer").length;
						var cntReplyQuestion = $("div.replyQuestion").length;

						// 달린 답글이 없을 경우 || 질문에 대한 답변이 없을 경우
						if(cntReplyAnswer <= 0 || cntReplyAnswer <= cntReplyQuestion){
							$("#anwerRegister").hide();
						}
					},
					// 답글쓰기 화면
					move : function(id){
						$.opinion.data.id = id;
						
						$.opinion.search.set();
						$("#res_h_refresh").val("Y");
						$.opinion.utils.castData();
						
						$.opinion.formSubmit($("#opinionForm"), $.opinion.page.answerView);
					},
					// 답글 등록
					register  : function(){
						var superAnswerId = $("div.replyAnswer:last").data("id");
						
						if($.trim(superAnswerId).length <= 0){
							return;
						}
						
						$("#superAnswer").val(superAnswerId);
						$.opinion.formSubmit($("#opinionForm"), $.opinion.page.answer);
					},
					cancel : function(){
						$.opinion.validation.removeValidaionRule();
						$.opinion.list.search();
					},					
			},
			//더보기 버튼
			setSeeMore : function(){
				if($.opinion.data.isSeeMore == "false"){
					$("#btnSeeMore").hide();
				}else{
					$("#btnSeeMore").show();
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
			
			
	}
	
	
	// 페이징
	$(document).on("click", "a[name=opinionListPage_page]", function(e){
		$.opinion.data.page = $(this).children("input").attr("value");
		$.opinion.list.searchAjax(); 
	});
	
})(jQuery);

//더보기
$(document).on("click", "a#btnSeeMore", function(){
	$.opinion.data.page++;
	$.opinion.list.searchAjax();
});

$(document).on("click", 'a[href^="#uiLayerPop_"]', function(){
	$("#detail").val("");
	layerPopupOpen(this);
});

$(document).ready(function(){
	//뉴핀 페이지 사용
	
	$(".newPinInfo tr").each(function(){
		if($(this).find("td").length < 3){
			var count = (3 - $(this).find("td").length);
			var oTd = "";
			for(var i=0; i< count; i++){
				oTd += "<td></td>";
			}
			$(this).append(oTd);
		}
	});
	
	if($("#res_h_refresh").val() == "Y"){
		$.opinion.utils.castData(true);
		$.opinion.init();
		$.opinion.list.searchAjax();
	}else{
		$.opinion.init();
		$.opinion.focusTitle();
	}
	
})