try {
	document.domain = "abnkorea.co.kr";
} catch(e) {}

$(document).ready(function () {
	//location.href 
	// 필수 체크 표시
//	$(this).find(".requd").each(function() {
//		var $checkElement = $(this).parent().prev();
//
//	    if($checkElement.length > 0 && ($checkElement[0].tagName == "TH" || $checkElement[0].tagName == "th") ) {
//	         $checkElement.html($checkElement.text().replace(/\*/g, "") + "<span class='fcR'> *</span>");
//	    }
//	});
	
});

(function($) {

	$(function(){
		chkValidation = function(options){	// 입력 유효성 체크
			var default_value =  {			
					chkId : ".inner"
					, chkObj : "input"
			};
			var opts = $.extend({}, default_value, options);
			var arrChkObj = opts.chkObj.split('|');
			var bChk = false;
			var msg = "";
			var rtnOjb = null;

			for(var i = 0; i < arrChkObj.length; i++){
				$(opts.chkId).find(arrChkObj[i]).each(function(){
					if(!bChk){
						// 필수 Check 여부
						if($(this).hasClass("check")){
							if($.trim($(this).val()).length < 1){
								msg = "중복체크를 하지 않았습니다.\n" + $(this).attr("title") + " 체크는 필수입니다.";
								bChk = true;
								rtnOjb = $(this).attr("id");
							}
						}
						// 필수값 Null Check
						if($(this).hasClass("requd")){
							if(arrChkObj[i] == "input" || arrChkObj[i] == "textarea" ){
								if($.trim($(this).val()).length < 1){
									msg = $(this).attr("title") + " 값이 없습니다. \n" + $(this).attr("title") +"은(는) 필수 입력값입니다." ;
									bChk = true;					
									rtnOjb = $(this).attr("id");
								}
							} else if(arrChkObj[i] == "select") {
								if($.trim($(this).val()).length < 1){
									msg = $(this).attr("title") + " 값이 없습니다.\n" + $(this).attr("title") +"은(는) 필수 입력값입니다." ;
									bChk = true;					
									rtnOjb = $(this).attr("id");
								}
							}
						}
						// 숫자여부 체크 Check
						if($(this).hasClass("isNum")){
							var cutcommanum = $(this).val().replace(/,/g, "");
							if(!isNumber(cutcommanum)){
								msg = $(this).attr("title") +"은(는) 숫자만 입력 가능합니다." ;
								bChk = true;					
								rtnOjb = $(this).attr("id");
							}
						}
						// E-mail 체크 Check
						if($(this).hasClass("isEmail")){
							if(!isEmail($(this).val())){
								msg = $(this).attr("title") +"은(는) E-mail 형식이 아닙니다." ;
								bChk = true;					
								rtnOjb = $(this).attr("id");
							}
						}
					}
				});	
				if(bChk){
	          		alert(msg);
	          		moveFocus(rtnOjb)
					return false;
				}
			} // end for
			return true;
			
		} // end Validation	
		, isNumber = function(number) {	// 숫자 체크
			if($.trim(number) == '')
				return true;

			return /^[0-9\.?]+$/.test(number);
		}
		, isEngNumber = function(number) {	// 영어와 숫자만 체크
			if($.trim(number) == '')
				return true;

			return /^[a-zA-Z0-9\.?]+$/.test(number);
		}
		, isEmail = function(email) {	// 이메일 체크
			if($.trim(email) == ''){
				return true;
			}
			return /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i.test(email);
		}
		, moveFocus = function(obj){
			$("#" + obj).focus();
		}
		// end chkValidation
		, setSelectBox = function(data, targetObj){
			var obj = null;
			try{
				obj = JSON.parse(data);
				if(obj.length == 0){
					return ;
				}
			} catch(e) {	
				return;
			}
			
			var HTML = "<option value='__CODE_VALUE__'>__CODE_TEXT__</option>";
			var tmpHTML = "";
			var realHTML = "<option value=''>전체</option>";

			for(var i = 0; i < obj.resultList.length; i++){
				tmpHtml = HTML;

				tmpHtml = tmpHtml.replace(/__CODE_VALUE__/g, obj.resultList[i].minorCd);
				tmpHtml = tmpHtml.replace(/__CODE_TEXT__/g, obj.resultList[i].cdName);
				realHTML += tmpHtml;
			}
			
			$("#" + targetObj + " option").remove();
			$("#" + targetObj).append(realHTML);
		}
		// end chkValidation
		, setSelectChooseBox = function(data, targetObj){
			var obj = null;
			try{
				obj = JSON.parse(data);
				if(obj.length == 0){
					return ;
				}
			} catch(e) {	
				return;
			}
			
			var HTML = "<option value='__CODE_VALUE__'>__CODE_TEXT__</option>";
			var tmpHTML = "";
			var realHTML = "<option value=''>선택</option>";

			for(var i = 0; i < obj.resultList.length; i++){
				tmpHtml = HTML;

				tmpHtml = tmpHtml.replace(/__CODE_VALUE__/g, obj.resultList[i].minorCd);
				tmpHtml = tmpHtml.replace(/__CODE_TEXT__/g, obj.resultList[i].cdName);
				realHTML += tmpHtml;
			}
			
			$("#" + targetObj + " option").remove();
			$("#" + targetObj).append(realHTML);
		}
		// end SetSelectBox
		, setSelectAbilityBox = function(data, targetObj, selected, allText){
			var obj = null;
			try{
				obj = data;
				if(obj.length == 0){
					return ;
				}
			} catch(e) {	
				return;
			}
			
			if(typeof allText == "undefined" || allText == ""){
				allText = "전체";
			}
			
			var HTML = "<option value='__CODE_VALUE__' __SELECTED__>__CODE_TEXT__</option>";
			var tmpHTML = "";
			var realHTML = "<option value='' >" + allText + "</option>";
			
			for(var i = 0; i < obj.resultList.length; i++){
				tmpHtml = HTML;
				
				tmpHtml = tmpHtml.replace(/__CODE_VALUE__/g, obj.resultList[i].abilityCd);
				tmpHtml = tmpHtml.replace(/__CODE_TEXT__/g, obj.resultList[i].abilityNm);
				if(selected == obj.resultList[i].abilityCd){
					tmpHtml = tmpHtml.replace(/__SELECTED__/g, " selected");
				} else {
					tmpHtml = tmpHtml.replace(/__SELECTED__/g, "");
				}
				realHTML += tmpHtml;
			}
			
			$("#" + targetObj + " option").remove();
			$("#" + targetObj).append(realHTML);
		}
		// end SetSelectBox
		, setInitSelectBox = function(targetObj, allText){
			
			if(typeof allText == "undefined" || allText == ""){
				allText = "전체";
			}
			var realHTML = "<option value=''>" + allText + "</option>";
			
			
			$("#" + targetObj + " option").remove();
			$("#" + targetObj).append(realHTML);
		}
		// end SetSelectBox
		,  postGoto = function(url, parm, target, enctype) {		// JSON 으로 넘어온 값을 param으로 담아서 submit
			var frm = document.createElement("form");
			var objs, value;
			
			for (var key in parm) {
			    value = parm[key];
			    objs = document.createElement("input");
			    objs.setAttribute("type", "hidden");
			    objs.setAttribute("name", key);
			    objs.setAttribute("value", value);
			    frm.appendChild(objs);
			}
			
			if (target) {
			    frm.setAttribute("target", target);
			}
			if(enctype){				
				frm.setAttribute("enctype", "multipart/form-data");
			}
			frm.setAttribute("method", "post");
			frm.setAttribute("action", url);
			document.body.appendChild(frm);
			frm.submit();
		}
		// end PostGoto
		, commonErrorImg = function(obj){
			$(obj).attr("src", "/images/hanwha/win/ehrd/common/img/img_noimg.jpg");
		}
		, kAlert = function(message, options){
			if($("body").find(".__b-popup2__").length == 0){ // Iframe에서 호출한 경우
				window.parent.doCommonAlert(message, options);
			} else {// 2번째 팝업일 경우
				doCommonAlert(message, options);
			}
		}
	});
})(jQuery);

// 공통 Ajax Call
jQuery.ajaxCall = function(options) {
	var default_value =  {			
		timeout : 15 * 1000
		, async : true
		, cache: false
		, dataType: "json"
		, type: "POST"
		, contentType : "application/x-www-form-urlencoded; charset=UTF-8"
		, bLoading : "Y"
	};
	var opts = $.extend({},default_value, options);
	
	/*
	// 검색 조건
	var autoHistory = setHistoryAction();
	opts.data.autoHistory = autoHistory;
	*/
	var xhr = this.ajax({
	    url: opts.url,
//	    timeout: opts.timeout,
	    async: opts.async,
	    cache: opts.cache,
	    type: opts.type,
	    processData: opts.processData,
	    contentType: opts.contentType,
	    dataType: opts.dataType,
	    data: opts.data,
	    beforeSend: function(xhr, settings) {
	    	if(opts.bLoading == "Y"){
	    		showLoading();	// 로딩 시작	    		
	    	}
	    	xhr.setRequestHeader("call_type", "ajax");
	    	if (opts.beforeSend) {
	    		opts.beforeSend(xhr, settings);
	    	}
	    },
	    success: function (data, textStatus, xhr) {
	    	if (opts.success) {
    	    	hideLoading();	//로딩 끝
    	    	try{
    	    		opts.success(data, textStatus, xhr);
    	    	} catch(e){
    	    		alert("화면 로딩 중 에러가 발생했습니다. [" + data + "]");
    	    		return;
    	    	}
	    	}
	    }, 
	    error: function (xhr, textStatus, errorThrown) {
	    	hideLoading();	//로딩 끝
	    	if (opts.error) {
	    		opts.error(xhr, textStatus, errorThrown);
	    	}
	    },
	    complete: function (xhr, textStatus) {
	    	hideLoading();	//로딩 끝
	    	if (opts.complete) {
	    		opts.complete(xhr, textStatus);
	    	}
	    }
	}); 
 	return xhr;
};


$.fn.datepkin = function () {
	$("#ui-datepicker-div").remove();
	var $obj = $(this);
	return this.each(function () {
		$obj.datepicker({
			showOn: "button",
			buttonImage: "/static/axisj/ui/arongi/images/icon_calendar.jpg",
			buttonImageOnly: true,
			dayNamesMin: [ "일", "월", "화", "수", "목", "금", "토" ],
			showMonthAfterYear: false,
			monthNames: [ "01월(JAN)", "02월(FEB)", "03월(MAR)", "04월(APR)", "05월(MAY)", "06월(JUN)", "07월(JUL)", "08월(AUG)", "09월(SEP)", "10월(OCT)", "11월(NOV)", "12월(DEC)" ],
			monthNamesShort: [ "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"],
			//yearSuffix: '년',
			dateFormat: "yy-mm-dd",
			changeMonth : true,
			changeYear : true,
		    beforeShow:function(input) {
		        $(input).css({
		            "position": "relative",
		            "z-index": 9999
		        });
		    }
		})
	});
};

var showLoading = function () {
	var tmp  = '<div id="loading" class="loading">'
			+ '    <div class="loadingCont">'
			+ '        <img src="/_ui/desktop/images/common/loading.gif" alt="로딩중">'
			+ '    </div>'
			+ '</div>'
	        + '<div class="loadMask" id="loadMask" style="display:block"></div>';
	$(parent.document).find("body").append(tmp);
};

var hideLoading = function () {
	$(parent.document).find("#loading").remove();
	$(parent.document).find("#loadMask").remove();
};

// 교육비 지출항목
$.fn.spenditem = function (pHtml) {
	var $obj = $(this),
		$addBtn = $obj.find(".spenditemAdd"),
		$tgt = $obj.find(".spendItemList"),

		addDom = ""
	;
	var num = $(".spendItemList > li").length;
	
	addDom += "<li>";
	addDom += "	<select title='지출항목 선택' name='nomalSpendItem' class='requd'>";
	addDom += pHtml;
	addDom += "	</select>";
	addDom += "	<label for='num3' class='mgLabel'>예상금액</label>";
	addDom += "	<input type='tel' id='amount"+$('.spendItemList > li').length+"'      class='onlyMoney' onkeyup='changeSpendAmount("+num+")' />";
	addDom += "	<input type='tel' id='spendamount"+num+"' name='spendamount' title='예상금액' class='requd' /> <a href='javascript:;' class='mgLabel btnTbl btnItemDelete'><span>삭제</span></a>";
	addDom += "</li>";
		
	// Item Add
//	$addBtn.on("click", function () {
//		$tgt.append(addDom);
//		return false;
//	});

	// Item Delete
	$obj.on("click", ".btnItemDelete", function () {
		var result = confirm("삭제 하시겠습니까?");
		
		if(result){
			$(this).closest("li").remove();
		}

		return false;
	});
	
};
/**
 * 사전계획서 - 지출 항목
 */
$.fn.spenditemMoblie = function (pHtml) {
	var $obj = $(this);
	var btnHtml = "<a href='javascript:;' class='btnTblL'>삭제</a><a href='javascript:;' class='btnTblLGray'>추가</a>";
	
	function html(num) {
		var addDom="";
		addDom += "<div class='inputWrap addInput'>";
		addDom += "<div class='textBox unit'>";
		addDom += "<p class='selectBox1'>";
		addDom += "	<select title='지출항목 선택' name='nomalSpendItem' class='requd'>";
		addDom += pHtml;
		addDom += "	</select>";
		addDom += "	<p class='unit'><input type='text' id='amount"+num+"' name='spendamount' title='예상금액' placeholder='금액입력' onkeyup='changeSpendAmount("+num+")' class='requd' /><em>원</em></p>";
		addDom += "	<p class='btns' id='spendBtn"+num+"'><a href='javascript:;' class='btnTblL'>삭제</a><a href='javascript:;' class='btnTblLGray'>추가</a></p>";
		addDom += "</div>";
		addDom += "</div>";
		
		return addDom;
	}
	
	// Item Add
	$obj.on("click", ".btnTblLGray", function () {
		var num = $(".spendItemWrap > .inputWrap").length;
		
		if( !isNull($(".spendItemWrap > amount"+num)) ) {
			num = num + "" + 1
		}
		
		// 일단 추가 버튼 일괄 삭제
		$(this).closest(".btnTblLGray").remove();
		
		$(".spendItemWrap").append(html(num));
		
		setTimeout(function(){ abnkorea_resize(); }, 500);
		
		return false;
	});
	
	// Item Delete
	$obj.on("click", ".btnTblL", function () {
		var result = confirm("삭제 하시겠습니까?");
		
		if(result){
			$(this).closest(".addInput").remove();
			
			var num = $(".spendItemWrap > .inputWrap").length;
			var btnHtml = "<a href='javascript:;' class='btnTblL'>삭제</a><a href='javascript:;' class='btnTblLGray'>추가</a>";
			if(num==1) {
				$("#spendBtn0").html("<a href='javascript:;' class='btnTblLGray'>추가</a>");
			} else {
				// 마지막 row에 추가 버튼 삽입
				var objId = $(".spendItemWrap").find(".btns")[num-1].id;		
				$("#"+objId).html(btnHtml);	
			}
			
			setTimeout(function(){ abnkorea_resize(); }, 500);
		}
		
		return false;
	});
	
};
/**
 * 지출증빙 - 지출항목
 */
$.fn.spendItemsMoblie = function (pHtml) {
	var $obj = $(this);
	var btnHtml = "<a href='javascript:;' class='btnTblL'>삭제</a><a href='javascript:;' class='btnTblLGray'>추가</a>";
	
	function html(num) {
		var addDom="";
		var userAgent = navigator.userAgent.toLowerCase();
		var check_mobile = "android";
		
		if (userAgent.search("android") > -1){
			if(userAgent.search("amway") > -1) {
			} else {
				check_mobile = "amway_android";
			}			
		} else {
			check_mobile = "amway_android";
		}
		
		addDom += "<div class='inputWrap addInput'>";
		addDom += "<form id='fileForm"+num+"' method='POST' enctype='multipart/form-data' class='textBox unit'>";
		
		if(check_mobile=="android") {
			addDom += "<p><a href='javascript:html.filecall("+num+");' class='btnTbl mgbS'>파일선택</a>";
			addDom += "<input type='text' id='file"+num+"' class='file requd' name='file"+num+"' title='사진 찾기' placeholder='선택된 파일 없음' readonly />";
		} else {
			addDom += "<p><input type='file' name='file"+num+"' id='file"+num+"' title='사진 찾기' onChange='javascript:html.filesize(this,"+num+");' />";
		}
		
		addDom += "<input type='hidden' name='filekey' id='filekey"+num+"' title='파일번호' value='' />";
		addDom += "<input type='hidden' name='oldfilekey' id='oldfilekey"+num+"' title='파일번호' value='' /> </p>";		
		addDom += "<p class='selectBox1'>";
		addDom += "	<select title='지출항목 선택' id='spendItem"+num+"' name='nomalSpendItem'>";
		addDom += pHtml;
		addDom += "	</select>";
		addDom += "	<p class='unit'><input type='tel'  title='지출금액' placeholder='금액입력' id='spendAmount"+num+"' name='spendAmount' onkeyup='changeSpendAmount(this)' /><em>원</em></p>";
		addDom += "	<p class='btns' id='spendBtn"+num+"'><a href='javascript:;' class='btnTblL'>삭제</a><a href='javascript:;' class='btnTblLGray'>추가</a></p>";
		addDom += "</form>";
		addDom += "</div>";
		
		return addDom;
	}
	
	// Item Add
	$obj.on("click", ".btnTblLGray", function () {
		var num = $(".spendItemWrap > .inputWrap").length;
		
		if( !isNull($(".spendItemWrap > amount"+num)) ) {
			num = num + "" + 1
		}
		
		// 일단 추가 버튼 일괄 삭제
		$(this).closest(".btnTblLGray").remove();
		
		$(".spendItemWrap").append(html(num));
		
		var num = $(".spendItemWrap > .inputWrap").length;
		var btnHtml = "<a href='javascript:;' class='btnTblL'>삭제</a><a href='javascript:;' class='btnTblLGray'>추가</a>";
		if(num==1) {
			$("#spendBtn0").html("<a href='javascript:;' class='btnTblLGray'>추가</a>");
		} else {
			// 마지막 row에 추가 버튼 삽입
			var objId = $(".spendItemWrap").find(".btns")[num-1].id;		
			$("#"+objId).html(btnHtml);	
		}
		
		//스크롤 사이즈
		setTimeout(function(){ abnkorea_resize(); }, 500);
		
		return false;
	});
	
	// Item Delete
	$obj.on("click", ".btnTblL", function () {
		var result = confirm("삭제 하시겠습니까?");
		
		if(result){
			$(this).closest(".addInput").remove();
			
			var num = $(".spendItemWrap > .inputWrap").length;
			var btnHtml = "<a href='javascript:;' class='btnTblL'>삭제</a><a href='javascript:;' class='btnTblLGray'>추가</a>";
			if(num==1) {
				$("#spendBtn0").html("<a href='javascript:;' class='btnTblLGray'>추가</a>");
			} else {
				// 마지막 row에 추가 버튼 삽입
				var objId = $(".spendItemWrap").find(".btns")[num-1].id;		
				$("#"+objId).html(btnHtml);	
			}
			
			//스크롤 사이즈
			setTimeout(function(){ abnkorea_resize(); }, 500);
		}
		
		return false;
	});
	
};


//Contents - File Upload
$.fn.fileup = function () {
	var $obj = $(this),
	    $tgt = $obj.find(".fileup"),
	    addDom = "";
	
//	var num = $(".fileUploadWrap > li").length;
	
//	if( !isNull(document.getElementById("file"+num)) ) {
//		num = num + "" + 1
//	}
//	
//	addDom = addDom + "<li>";
//	addDom = addDom + "<input type='file' id='file"+num+"' name='file"+num+"' title='첨부파일' class='file' />";
//	addDom = addDom + "<a href='javascript:;' class='mgLabel btnTbl btnFileItemDelete' title='파일삭제'><span>파일삭제</span></a>";
//	addDom = addDom + "</li>";
//	
//	// 추가
//	$obj.on("click", ".btnFileItemAdd", function () {
//		$tgt.append(addDom);
//
//		return false;
//	});

	$obj.on("click", ".btnFileItemDelete", function () {
		$(this).closest("li").remove();

		return false;
	});

};

// 사전계획서 - 임대차지출 파일추가
$.fn.fileupMobile = function () {
	var $obj = $(this),
	    $tget = $obj.find(".inputWrap > div");
	var btnHtml = "<a href='javascript:;' class='btnTblL'>파일삭제</a><a href='javascript:;' class='btnTblLGray'>파일추가</a>";
	
	// 추가
	$obj.on("click", ".btnTblLGray", function () {
		var userAgent = navigator.userAgent.toLowerCase();
		var check_mobile = "android";
		
		if (userAgent.search("android") > -1){
			if(userAgent.search("amway") > -1) {
			} else {
				check_mobile = "amway_android";
			}			
		} else {
			check_mobile = "amway_android";
		}
		
		var num = $(".fileUploadWrap").find("form").length;
		var addDom = "";
		
		// 일단 추가 버튼 일괄 삭제
		$(this).closest(".btnTblLGray").remove();
		
		if( !isNull(document.getElementById("file"+num)) ) {
			num = num + "" + 1
		}
				
		addDom += "<form id='fileForm"+num+"' method='POST' enctype='multipart/form-data'>";
		addDom += "<p>";
		if(check_mobile=="android") {
			addDom += "<a href='javascript:html.filecall("+num+");' class='btnTbl mgbS'>파일선택</a>";
			addDom += "<input type='text' id='file"+num+"' class='file requd' name='file"+num+"' title='사진 찾기'  placeholder='선택된 파일 없음' readonly />";
		} else {
			addDom += "<input type='file' id='file"+num+"' class='file requd' name='file"+num+"' title='사진 찾기' onChange='javascript:html.filesize(this,"+num+");' accept='image/*;capture=camera' />";
		}
		addDom += "</p>";
		addDom += "<p class='btns' id='rentBtn"+num+"'>";
		addDom += "<a href='javascript:;' class='btnTblL' title='파일삭제'>파일삭제</a>";
		addDom += "<a href='javascript:;' class='btnTblLGray' title='파일추가'>파일추가</a>";
		addDom += "</p>";
		addDom += "	<input type='hidden' id='filekey"+num+"' name='filekey' title='파일번호' />";
		addDom += "	<input type='hidden' id='oldfilekey"+num+"' name='oldfilekey' title='파일번호' />";
		addDom += "</from>";
		
		$(".fileUploadWrap > .inputWrap").append(addDom);
		
		//스크롤 사이즈
		setTimeout(function(){ abnkorea_resize(); }, 500);
		
		return false;
	});
	
	$obj.on("click", ".btnTblL", function () {
		var result = confirm("삭제 하시겠습니까?");
		
		if(result){
			$(this).closest("form").remove();
			
			var num = $(".fileUploadWrap").find("form").length;
			
			if(num==1) {
				$("#retnBtn0").html("<a href='javascript:;' class='btnTblLGray'>파일추가</a>");
			} else {
				// 마지막 row에 추가 버튼 삽입
				var objId = $(".fileUploadWrap").find(".btns")[num-1].id;
				$("#"+objId).html(btnHtml);
			}
			
			setTimeout(function(){ abnkorea_resize(); }, 500);
		}
		
		return false;
	});
	
};

String.prototype.format = function() {
	var s = this;
	for (var i = 0; i < arguments.length; i++) {       
		var reg = new RegExp("\\{" + i + "\\}", "gm");             
		s = s.replace(reg, arguments[i]);
	}
	
	return s;
}

//통화형 콤마
function setComma(x){
	var temp = "";
	x = x+"";	// undefined 방지
	
    num_len = x.length;
    co = 3;
    while (num_len > 0) {
        num_len = num_len - co;
        if (num_len < 0) {
            co = num_len + co;
            num_len = 0;
        }
        temp = "," + x.substr(num_len, co) + temp;
    }
    return temp.substr(1);
}

/** null체크
 * */
function isNull(txt) {
	if(txt != null && txt != '' && txt != 'undefined') {
		return false;
	} else {
		return true;
	}
} 
// 오늘 날짜
var setToDay = function(format){
	if(typeof format == "undefined" || format == ""){
		format = 'yy/mm/dd';
	}
	return $.datepicker.formatDate(format, new Date());
};
// 날짜 차이
var setDatediff = function(tDate, aDate, format){
	if(typeof format == "undefined" || format == ""){
		format = 'yy/mm/dd';
	}
	var date = new Date (tDate);	
	date.setDate(date.getDate() + aDate);
	return $.datepicker.formatDate(format, date);
};
// 날짜 비교 : false/true 리턴
var chkDate = function(tDate, dDate){
	var bChk = false;
	tDate = new Date(tDate);
	if(typeof dDate == "undefined" || dDate == ""){
		dDate = new Date();
	} else {
		dDate = new Date(dDate);
	}
	if(tDate >= dDate){
		bChk = true;
	}
	return bChk;
};
// 해당일 주차 구하기
// tDate : target Date default toDay
var weekPerYear = function weekAndDay(tDate) {
	var date = null;
	if(typeof tDate == "undefined" || tDate == ""){
		date = new Date();
	} else {
		date = new Date(tDate);
	}
	//days = ['Sunday','Monday','Tuesday','Wednesday', 'Thursday','Friday','Saturday'],
	prefixes = ['1', '2', '3', '4', '5'];

	return prefixes[0 | date.getDate() / 7];
}
var setFormatDay = function(date, format){
	if(typeof format == "undefined" || format == ""){
		format = 'yy.mm.dd';
	}
	return $.datepicker.formatDate(format, new Date(date));
};
function weekAndYear(date, format){	
	if(typeof format == "undefined" || format == ""){
		format = 'yy.mm.dd';
	}
	var weekday = new Date(date).getDay();
	
	ss1 = setDatediff(date, -(7 - weekday), format);
	ss2 = setDatediff(date, 7 - ( 8- weekday), format);
	
	return "("  + ss1 + " ~ " + ss2 + ")";
}

// 달의 마지막일자
function LastDayOfMonth(year, month) {
	var _firstDayOfMonth = [ year, month, '01'].join('-');  
	var _firstDayOfMonthDate = new Date(_firstDayOfMonth);  
	
	var Now = (new Date(year,month,0)).getDate();
	
//	_firstDayOfMonthDate.setMonth(_firstDayOfMonthDate.getMonth() + 1);  
//	_firstDayOfMonthDate.setDate(_firstDayOfMonthDate.getDate() - 1); 
	
    // return
	return Now;
}
// 해당 월에 마지막날까지 combo 그리기
var setSelectMonthDay = function(lastDay, targetObj, selected){
	
	var HTML = "<option value='__CODE_VALUE__'>__CODE_TEXT__</option>";
	var tmpHTML = "";
	var realHTML = "";
	var iValue = "";

	for(var i = 1; i <= lastDay; i++){
		tmpHtml = HTML;
		
		if(i <= 9){
			iValue = "0" + i;
		} else {
			iValue = i;
		}
		tmpHtml = tmpHtml.replace(/__CODE_VALUE__/g, iValue);
		tmpHtml = tmpHtml.replace(/__CODE_TEXT__/g, iValue+"일");
		
		realHTML += tmpHtml;
	}
	
	$("#" + targetObj + " option").remove();
	$("#" + targetObj).append(realHTML);
	$("#" + targetObj).val(selected);
}

// 연도 combo 그리기(역순으로)
var setCommonYear = function(startYear, lastYear, targetObj, selected){
	
	var HTML = "<option value='__CODE_VALUE__'>__CODE_TEXT__</option>";
	var tmpHTML = "";
	var realHTML = "<option value=''>선택</option>";
	var iValue = "";
	
	for(var i = lastYear; i >= startYear; i--){
		tmpHtml = HTML;
		
		if(i <= 9){
			iValue = "0" + i;
		} else {
			iValue = i;
		}
		tmpHtml = tmpHtml.replace(/__CODE_VALUE__/g, iValue);
		tmpHtml = tmpHtml.replace(/__CODE_TEXT__/g, iValue);
		realHTML += tmpHtml;
	}
	$(targetObj).children("option").remove();
	$(targetObj).append(realHTML);
	$(targetObj).val(selected);
}

/** null 공백 리턴 
 * */
function isStringNull(txt) {
	if(txt != null && txt != '' && txt != 'undefined') {
		return txt;
	} else {
		return "";
	}
}

/** 문자가 null이면 지정 택스트로 변환하여 리턴한다.
 * 
 */
function isNvl(txt, char) {
	if(txt != null && txt != '' && txt != 'undefined') {
		return txt;
	} else {
		return char;
	}
}

//업로드 확장자 체크
var chkFileImg = function(obj, options){
	var chkData = {
			"chkFile" : "gif,png,jpg,jpeg"
	};
	var opts = $.extend({},chkData, options);
	
	var bChk = true;
	$("[name=" + obj +"]").each(function(){
		var ext = $(this).val().split('.').pop().toLowerCase();
		if(opts.chkFile.indexOf(ext) == -1) {
			alert(opts.chkFile + ' 파일만 업로드 할수 있습니다.');
			bChk =  false;
		}
	});
	
	return bChk;
};

/** JSON object를 String으로 리턴
 * 
 */
function JSONtoString(object) {
    var results = [];
    for (var property in object) {
        var value = object[property];
        if (value)
            results.push(property.toString() + ': ' + value);
        }
                
        return '{' + results.join(', ') + '}';
}

(function($) {

	$(function(){
		chnageNumberTxt = function(money){
			arrayNum=new Array("","일","이","삼","사","오","육","칠","팔","구");
			arrayUnit=new Array("","십","백","천","만 ","십만 ","백만 ","천만 ",
			                    "억 ","십억 ","백억 ","천억 ","조 ","십조 ","백조");
			arrayStr= new Array()
			money = money + "";
			len = money.length;
			hanStr = "";
			
			for(i=0;i<len;i++) { arrayStr[i] = money.substr(i,1) }
			
			code = len;
			
			for(i=0;i<len;i++) {
				code--;
				tmpUnit = "";
				
				if(arrayNum[arrayStr[i]] != ""){
					tmpUnit = arrayUnit[code];
					if(code>4) {
						if(( Math.floor(code/4) == Math.floor((code-1)/4) && arrayNum[arrayStr[i+1]] != "") || 
						   ( Math.floor(code/4) == Math.floor((code-2)/4) && arrayNum[arrayStr[i+2]] != "")) {
							tmpUnit=arrayUnit[code].substr(0,1);
						} 
					}
				}
				
				hanStr +=  arrayNum[arrayStr[i]]+tmpUnit;
		    }
			
			return hanStr+"원";
		}
	});
})(jQuery);

// 아이프레임 높이 조정
function abnkorea_resize()
{
	var topPadding = $("#pbContent").css("padding-top").replace("px","");
	var bottomPadding = $("#pbContent").css("padding-bottom").replace("px","");
	var iHeight = $("#pbContent").height();
	try{
		iHeight = Number(iHeight) + Number(topPadding) + Number(bottomPadding); // 탑패딩이 어딘 있고 어딘 없어서 탑 패딩 잡아서 해당 사이즈 만큼 더해줌
	}catch(e){}
	var isResize = false;
	if(iHeight == null){
		iHeight = $(document).height();
	}
	try
	{
		window.parent.postMessage(iHeight, "*");
		isResize = true;
	}
	catch(e){
		isResize = false;
	}
	if(!isResize)
	{
		try{
		}
		catch(e){
		}
	}
}

$.fn.alphanumeric = function(p) {
 
	p = $.extend({ ichars: "!@#$%^&*+=\\\';/{}|\":<>?~`.-_ ", nchars: "", allow: "" }, p);
 
	 return this.each( function() {
	  
	  if (p.nocaps) p.nchars += "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	  if (p.allcaps) p.nchars += "abcdefghijklmnopqrstuvwxyz";
	  
	  s = p.allow.split('');
	  for ( i=0;i<s.length;i++) if (p.ichars.indexOf(s[i]) != -1) s[i] = "\\" + s[i];
	  p.allow = s.join('|');
	  var reg = new RegExp(p.allow,'gi');
	  var ch = p.ichars + p.nchars;
	  ch = ch.replace(reg,'');
	
	  $(this).keypress( function (e) {
	   if (!e.charCode) k = String.fromCharCode(e.which);
	    else k = String.fromCharCode(e.charCode);
	   if (ch.indexOf(k) != -1) e.preventDefault();
	   if (e.ctrlKey&&k=='v') e.preventDefault();
	     
	  });
	  
	  $(this).bind('contextmenu',function () {return false});
	 });
};
	
//숫자만 가능하게(점, 콤마 불가)
$.fn.numeric = function(p) {
this.css("ime-mode", "disabled");
var az = "abcdefghijklmnopqrstuvwxyz";
az += az.toUpperCase();
p = $.extend({ nchars: az }, p); 
return this.each( function() { $(this).alphanumeric(p); });
};

//문자/2byte문자만 가능하게(공백, 숫자 불가)
$.fn.alpha = function(p) {
var nm = "1234567890";
p = $.extend({ nchars: nm }, p); 
return this.each( function() { $(this).alphanumeric(p); });
};

//숫자/문자/2byte문자/공백만 가능하게
$.fn.alphanumericWithSpace = function(p) {
var nm = "";
p = $.extend({ nchars: nm, allow: " " }, p); 
return this.each( function() { $(this).alphanumeric(p); });
};

//문자만 가능하게(숫자, 2byte문자, 공백 불가)
$.fn.alphaAsciiOnly = function(p) {
this.css("ime-mode", "disabled");
var nm = "1234567890";
p = $.extend({ nchars: nm }, p); 
return this.each( function() { $(this).alphanumeric(p); });
};
  
//숫자만 가능하게(점, 콤마 가능)
$.fn.decimal = function(p) {
this.css("ime-mode", "disabled");
var az = "abcdefghijklmnopqrstuvwxyz";
az += az.toUpperCase();
p = $.extend({ nchars: az, allow: ".,"}, p); 
return this.each( function() { $(this).alphanumeric(p); });
};


$(document).ready(function(){
	//URL 복사하기
	$('.snsUrlBox a.snsUrl').click(openSnsUrlSystem);
	function openSnsUrlSystem(){
		var $this = $(this);
		var $target = $($this.next('.alert'));
		var target = $this.next('.alert');
		$target.show();

		$target.attr('tabindex','0').focus();
		
		var $input = $target.find('.alertIn input');
		$input.select();
		var copyYn = copyToClipboard($input.get(0));
		snsUrlTextChange($target, copyYn);
		return false;
	}
	$(".snsLink > a").on("click",function(){
		var sns = $(this).attr("class");
		if(sns == "pPrint"){return;}
		var url = $(this).prevAll('.snsUrlBox').find(".alert .alertIn input").val() ;
		var courseid = $(this).prevAll('.snsUrlBox').find(".alert .alertIn input").attr("data-courseid") ;
		sendSns(sns, courseid, url);
	});
});

// SNS공유
$.snsMsg = {
		err : {
			system : "시스템 관리자에게 문의해 주세요."
		},
		shareContent : {
			disclaimer				: "•한국암웨이 ABN에서 서비스되는 일체의 콘텐츠에 대한 지적 재산권은 한국암웨이(주)에 있으며, 임의로 자료를 수정/변경하여 사용하거나, 기타 개인의 영리 목적으로 사용할 경우에는 지적 재산권 침해에 해당하는 사안으로, 그 모든 법적 책임은 콘텐츠를 불법으로 남용한 개인 또는 단체에 있습니다.\n•모든 자료는 원저작자의 요청이나 한국암웨이의 사정에 따라 예고 없이 삭제될 수 있습니다."
			, snsUrlCopyTrue				: "주소가 복사되었습니다.<br>원하는 곳에 붙여넣기(Ctrl+V) 해주세요"
			, snsUrlCopyFalse				: "복사하기(Ctrl+C) 하여, <br>원하는 곳에 붙여넣기(Ctrl+V) 해주세요"
			, enableOnlyMobile			: "이 기능은 모바일에서만 사용할 수 있습니다."
		},
}


var sendSns = function(sns, courseid, url) {
	//if(courseid != "" && courseid != undefined){
	if(url != "" && url != undefined && url != null  && url.indexOf("lmsCourseView.do")>=0 ){
		$.ajaxCall({
	   		url: "/lms/common/lmsCommonSnsCountAjax.do"
	   		, data: {courseid:courseid}
	   		, dataType: "json"
	   		, success: function( data, textStatus, jqXHR){
				//alert(data.cnt)
	   		}
	   	});
	}
	
	alert($.snsMsg.shareContent.disclaimer);
	var _url = encodeURIComponent(url);

	switch (sns) {
		case 'snsCs':
			window.open('https://story.kakao.com/share?url=' + _url);
			break;
		case 'snsBand':
			window.open('http://www.band.us/plugin/share?body=' + _url + '&route=www.abnkorea.co.kr', "share_band", "width=410, height=540, resizable=yes");
			break;
		case 'snsFb':
			window.open('http://www.facebook.com/sharer/sharer.php?u=' + _url);
			break;
		default:
		return false;
	}
};

function copyToClipboard(target) {
	target.focus();
	// copy the selection
	var succeed;
	try{
		target.setSelectionRange(0, target.value.length);
		try {
			  succeed = document.execCommand("copy");
		} catch(e) {
		    succeed = false;
		}
	} catch(e) {
	    succeed = false;
	}

	return succeed;
}
function snsUrlTextChange(obj, copyYn){
	var msg = $.snsMsg.shareContent.snsUrlCopyFalse;
	if(copyYn){
		msg = $.snsMsg.shareContent.snsUrlCopyTrue;
	}
	obj.find('.alertIn em').html(msg);
}
//SNS공유

//maxlength 체크
function maxLengthCheck(object){
	if (object.value.length > object.maxLength){
		object.value = object.value.slice(0, object.maxLength);
		alert( object.title + "은(는) " + object.maxLength + " 자리 이상 입력 할 수 없습니다.");
	}
}

// 숫자 maxlength
function maxNumberLength(object){
	if (object.value.length > object.maxLength){
		rtnNum = number.slice(0, object.maxLength);
		object.value = setComma(rtnNum);
		alert( object.title + "은(는) " + object.maxLength + " 자리(콤마포함) 이상 입력 할 수 없습니다.");
	}
}

//상단에 포커스 이동시키기
var fnAnchor2 = function() {
	try {
		parent.window.scrollTo(0,0);
	} catch(e) {}
}

function check_mobile() {
	var x = navigator.userAgent;
	if(x.match(/Android/)) {
		return "Android"; 
	}		
}