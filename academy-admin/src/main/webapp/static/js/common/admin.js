/**
 * Require Files for AXISJ UI Component...
 * Based		: jQuery
 * Javascript 	: AXJ.js, AXInput.js
 * CSS			: AXJ.css, AXInput.css
 */	
var pageID = "Default";
var fnObj = {
	pageStart: function(){
		// input 금액
		$(".AXInputMoney").bindMoney({
			min:0,
			max:99999999999
		});
		
	}
};

$(document).ready(function () {
	fnObj.pageStart.delay(0.1)
	
	// 필수 체크 표시
	$(this).find(".required").each(function() {
		var $checkElement = $(this).parent().prev();

	    if($checkElement.length > 0 && ($checkElement[0].tagName == "TH" || $checkElement[0].tagName == "th")) {
	         $checkElement.html($checkElement.text().replace(/\*/g, "") + "<i>*</i>");
	    }
	});
	
	var getDate = new Date();
	
	if(getDate.getMonth()+1>10) {
		getDate = $.datepicker.formatDate("yy-mm-dd", new Date(getDate.getFullYear()+1,getDate.getMonth(),getDate.getDate()));
	}
	
	//Axisj 달력(yyyy) 
	$(".datepYear").bindDate({separator:"-", selectType:"y"});
	$(".setDateYear").val(setToDay().substring(0,4));
	$(".setFiscalYear").val(getDate.getFullYear());
	//Axisj 달력(yyyy-mm)
	$(".datepMon").bindDate({separator:"-", selectType:"m"});
	$(".setDateMon").val(setToDay().substring(0,7));
	//Axisj 달력(yyyy-mm-dd)
	$(".datepDay").bindDate({separator:"-", selectType:"d"});
	$(".setDateDay").val(setToDay());
	
});

function authButton(param) {
	var frmId = "#ifrm_main_"+param.frmId;
	var menuAuth = param.menuAuth;

	if(menuAuth=="W") {
		$(".authWrite").show();
	} else {
		$(".authWrite").hide();
	}
}

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
						if($(this).hasClass("required")){
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
							if(!isNumber($(this).val())){
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
		, setSelectBoxList = function(data, targetObj, allTxt){
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
			var realHTML = "<option value=''>"+allTxt+"</option>";
			
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
		  timeout : 30 * 1000
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
	    timeout: opts.timeout,
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
    	    		alert("화면 로딩 중 에러가 발생했습니다. \nerr_message : " + e);
    	    		return;
    	    	}
	    	}
	    }, 
	    error: function (xhr, textStatus, errorThrown) {
	    	if(xhr.responseText != undefined){
		    	if(xhr.responseText.indexOf("<title>Login Error</title>")>0){
		    		top.location.href="/manager/login.do";
		    		return;
		    	}
	    	}
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
// Grid Start
var fnGrid = {
	initGrid : function(objGrid, params){
		
		var default_value =  {
			targetID : "AXGridTarget"
            , theme : "AXGrid"
            , height : "520px"
            , fitToWidth : true
            , mergeCells : false
            , autoChangeGridView: { // autoChangeGridView by browser width
                mobile:[0,600], grid:[600]
            }
			, page : {
				paging:true,
				sort:false,
				onchange: function(pageNo){
					//showLoading();	// 로딩 시작
					params.doPageSearch(pageNo);
				}
			} 
			, colHead : {heights:[20,30]}
			, body : {				
                onclick: function(){
                    //toast.push(Object.toJSON({index:this.index, item:this.item}));
//					params.doClick(this.item);
                },
                ondblclick: function(){
	                //toast.push(Object.toJSON({index:this.index, item:this.item}));
	//				params.doClick(this.item);
	            } 
            }
		};

		var opts = $.extend({}, default_value, params);
		
		objGrid.setConfig({
            targetID : opts.targetID
            , theme : opts.theme
            , sort : true
            //, remoteSort : true
            , fitToWidth  : opts.fitToWidth // 너비에 자동 맞춤
            , mergeCells : opts.mergeCells
            , autoChangeGridView: opts.autoChangeGridView
            , resizeable : false
            , colGroup : opts.colGroup
            , height : opts.height
            , body : opts.body
            , foot : opts.foot
            , page : opts.page
            , fixedColSeq : opts.fixedColSeq
            //, colHeadTool : true
            , colHeadAlign: "center" // 헤드의 기본 정렬 값
			, colHead : {
				rows : opts.colHead.rows
				, heights : opts.colHead.heights
				, onclick : function(data){
					params.sortFunc(this.colHead.addClass);
				}
			}
        });
    	
	}
	, sortGridOrder : function(defaultParam, sortKey){
		var sSortOrder = "DESC";
		if(defaultParam.sortIndex == sortKey){
			if(defaultParam.sortOrder == "DESC"){
				sSortOrder = "ASC";
			} else {
				sSortOrder = "DESC";
			}
		} else {
			sSortOrder = "DESC";
		}
		return sSortOrder;
		
	}
	, nonPageGrid : function(objGrid, params){
		var default_value =  {
			targetID : "AXGridTarget"
			, theme : "AXGrid"
			, height : "520px"
			, autoChangeGridView: { // autoChangeGridView by browser width
				mobile:[0,600], grid:[600]
			}
			, page : {
				paging:false,
				sort:false,
				onchange: function(pageNo){
					//showLoading();	// 로딩 시작
					params.doPageSearch(pageNo);
				}
			}
			, colHead : {heights:[20,30]}
			, body : {
				onclick: function(){
					//toast.push(Object.toJSON({index:this.index, item:this.item}));
//					params.doClick(this.item);
				}
			}
		};

		var opts = $.extend({}, default_value, params);

		objGrid.setConfig({
			targetID : opts.targetID
			, theme : opts.theme
			, sort : true
			//, remoteSort : true
			, fitToWidth  : opts.fitToWidth // 너비에 자동 맞춤
			, autoChangeGridView: opts.autoChangeGridView
			, resizeable : false
			, colGroup : opts.colGroup
			, height : opts.height
			, body : opts.body
			, page : opts.page
			, fixedColSeq : opts.fixedColSeq
			//, colHeadTool : true
			, colHeadAlign: "center" // 헤드의 기본 정렬 값
			, colHead : {
				rows : opts.colHead.rows
				, heights : opts.colHead.heights
				, onclick : function(data){
					params.sortFunc(this.colHead.addClass);
				}
			}
		});

	}
};
// end Grid

// Tab
var fnTab = {
	setValueTab: function(tabID, tabValue){
		$("#"+tabID).setValueTab(tabValue);
	}
};

// Ax Tree
var fnTree = {
	initTree : function(objTree, params){
		var default_value =  {
			targetID : "AXTreeTarget"
            , theme : "AXTree_none"
            , height : "auto"
			, xscroll : false
			, indentRatio : 0.7
			, checkboxRelationFixed:false // true | false | null
			, reserveKeys : {
				parentHashKey : "pHash"		// 부모 트리 포지션
				, hashKey : "hash" 			// 트리 포지션
				, openKey : "open" 			// 확장여부
				, subTree : "subTree" 		// 자식개체키
				, displayKey : "display" 	// 표시여부
			}
			, relation: {
				parentKey: "pno"	// 부모아이디 키
				, childKey: "no" 	// 자식아이디 키 
			}
			, body : {				
                onclick: function(idx, item){
                    //toast.push(Object.toJSON({index:this.index, item:this.item}));
					params.doClick(idx, this.item);
                }
            }		
		};

		var opts = $.extend({}, default_value, params);

		objTree.setConfig({
            targetID : opts.targetID
            , theme : opts.theme
            , height : opts.height
            , xscroll : opts.xscroll
            , indentRatio : opts.indentRatio
            , reserveKeys : opts.reserveKeys
            , relation : opts.relation
            , colGroup : opts.colGroup
            , body : opts.body
        });    	
	} // end initTree
}

var showLoading = function () {
	var tmp  = '<div id="loading" class="loadingWrap" style="z-index: 9999;" >'
			+ '    <div class="loadingCont">'
			+ '        <img src="/images/loading.gif" alt="로딩중">'
			+ '    </div>'
			+ '    <div class="dimmed"></div>'
			+ '</div>';

	$(parent.document).find("body").append(tmp);
};

var hideLoading = function () {
	$(parent.document).find("#loading").remove();
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
function setComma(num){
	if(num==0) return 0;
	var reg = /(^[+-]?\d+)(\d{3})/;
	var n = (num + '');
	while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');
	return n;
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
		format = 'yy-mm-dd';
	}
	return $.datepicker.formatDate(format, new Date());
};
// 날짜 차이
var setDatediff = function(tDate, aDate, format){
	if(typeof format == "undefined" || format == ""){
		format = 'yy-mm-dd';
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
	
	var _firstDayOfMonth = [ year, month, 1].join('-');  
	var _firstDayOfMonthDate = new Date(_firstDayOfMonth);  
	
	_firstDayOfMonthDate.setMonth(_firstDayOfMonthDate.getMonth() + 1);  
	_firstDayOfMonthDate.setDate(_firstDayOfMonthDate.getDate() - 1); 
	
    // return
	return _firstDayOfMonthDate.getDate();
}
// 해당 월에 마지막날까지 combo 그리기
var setSelectMonthDay = function(lastDay, targetObj, selected){
	
	var HTML = "<option value='__CODE_VALUE__'>__CODE_TEXT__</option>";
	var tmpHTML = "";
	var realHTML = "<option value=''>선택</option>";
	var iValue = "";

	for(var i = 1; i <= lastDay; i++){
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
var chkFileImg = function(obj){
	var chkData = {
			"chkFile" : "gif,png,jpg,jpeg"
	};
	var opts = $.extend({},chkData);
	
//	var bChk = true;
	$("input[name=" + obj +"]").each(function(){
		var ext = $(this).val().split('.').pop().toLowerCase();
		if(opts.chkFile.indexOf(ext) == -1) {
			alert(opts.chkFile + ' 파일만 업로드 할수 있습니다.');
			$(this).val("");
		}
	});
	
};

$.fn.fileUpload = function (pHtml) {
	var $obj = $(this);
	var btnHtml = "<a href='javascript:;' class='btnTblL'>삭제</a><a href='javascript:;' class='btnTblLGray'>추가</a>";
	
	function html(num) {
		var addDom="";
		addDom += "<li><input type=\"file\" id='file"+num+"' name='file"+num+"' onchange=\"javascript:chkFileImg('file"+num+"');\"><input type='text' name='altText'><a href='javascript:;' class='btn_gray btnFileDelete'>삭제</a></li>";
		
		return addDom;
	}
	
	// Item Add
	$obj.on("click", ".btnFileAdd", function () {
		var num = $(".fileWrap ul li").length;
		
		if(num>4) {
			alert("5개 이상 파일 업로드를 할 수 없습니다.");
		};
		
		if( !isNull($(".fileWrap > input[id='file"+num+"']")) ) {
			num = num + "" + 1;
		}
		
		$(".fileWrap > ul").append(html(num));
		
		return false;
	});
	
	// Item Delete
	$obj.on("click", ".btnFileDelete", function () {
		$(this).closest("li").remove();
		
		return false;
	});
	
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

/** 파람형식의 문자열을 object로 리턴
 * 
 */
function getParamObject( str ) {
    var valueObject = {}, hash, value;
    var hashes = str.split('&');
    for(var i = 0; i < hashes.length; i++) {
        hash = hashes[i].split('=');
        valueObject[hash[0]] = hash[1];
    }
    return valueObject;
}

/** 이미지 미리보기
 * 
 */
function getThumbnailPrivew(html, $target, w, h) {
	if(html.value == ""){
		return;
	}
	var _lastDot = html.value.lastIndexOf('.');
	var fileExt = html.value.substring(_lastDot+1, html.value.length).toLowerCase();
	if( fileExt != "jpg" && fileExt != "gif" && fileExt != "png" ) {
		alert("이미지 파일(jpg,gif,png)만 입력하세요.");
		try{$(html).replaceWith($(html).clone(true))}catch(e){};
		try{html.value = ""}catch(e){};
		return;
	}
   
	if (html.files && html.files[0]) {
        var reader = new FileReader();
        reader.onload = function (e) {
            $target.css('display', '');
            var wStr = "";
            var hStr = "";
            if(w !='' && w != null ){
            	wStr = "width="+w;
            }
            if(h !='' && h != null ){
            	hStr = "height="+h;
            }
            $target.html('<img src="' + e.target.result + '" border="0" alt="" '+wStr+' '+hStr+' />');
        }
        reader.readAsDataURL(html.files[0]);
    }
}
/** 탭메뉴 닫기
 * 
 */
function closeTabMenu(id){
	if($("#ifrm_main_"+id).length>0){
		$("#tabMenuTop").closeTab(id);
	}
}
/** 탭메뉴 바로 가기
 * 
 */
function setValueTabMenu(id){
	if($("#ifrm_main_"+id).length>0){
		$("#tabMenuTop").setValueTab(id);
	}
}
/** 자식창 재검색
 * 
 */
function listRefresh(id){
	if($("#ifrm_main_"+id).length>0){
		$("#ifrm_main_"+id).get(0).contentWindow.listRefresh();
	}
}
/** 자기 아이프레임 높이 설정
 * 
 */
function myIframeResizeHeight(id){
	$("#ifrm_main_"+id, parent.document).height($(document).height() + 50);
}

/** 에이작스 땡겨서 옵셥값 설정하기
 * 
 */
var setSelectBoxByAjax = function(ajaxUrl, param, targetObj, codefield, codenamefield, selectedvalue, firstText, firstValue, lastText, lastValue){
	$.ajaxCall({
   		url: ajaxUrl
   		, data: param
   		, async : false
   		, success: function( data, textStatus, jqXHR){
   			var HTML = "<option value='__CODE_VALUE__'>__CODE_TEXT__</option>";
   			var realHTML = "";
   			if(firstText!="" || firstValue!=""){
   				realHTML = "<option value='"+firstValue+"'>"+firstText+"</option>";
   			}
   			if(data != null){
   				var dataList = "data.dataList";
   				var len = data.dataList.length;
   				if(len > 0){
   					for(var i = 0; i < len; i++){
   						tmpHtml = HTML;
   						tmpHtml = tmpHtml.replace(/__CODE_VALUE__/g, eval(dataList+"[i]."+codefield));
   						tmpHtml = tmpHtml.replace(/__CODE_TEXT__/g, eval(dataList+"[i]."+codenamefield));
   						realHTML += tmpHtml;
   					}
   				}
   			}
   			if(lastText!="" || lastValue!=""){
   				realHTML += "<option value='"+firstValue+"'>"+firstText+"</option>";
   			}
   			$("#" + targetObj + " option").remove();
   			$("#" + targetObj).append(realHTML);
   			$("#" + targetObj).val(selectedvalue);
   		},
   		error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
   		}
   	});
};

/**
 * inputNm : 입력받는 input
 * btnNm   : 검색 버튼
 * type    : 검색옵션(번호, 성명)
 * 2016-08-03 홍석조
 */
$.fn.aboSearch = function (inputNm, btnNm, type, frmId) {
	var $obj = $(this),
	    $tgt = $obj.find("[name="+btnNm+"]"),
	    item = "";
		
	$obj.on("keydown","[name="+inputNm+"]", (function (e) {
			// 엔터키 이벤트
			if( e.keyCode == 13 ) {
				item = $("input[name='"+inputNm+"']").val();
				
				if( isNull($.trim(item)) ) {
					$("input[name='"+inputNm+"']").val("");
				} else {
					var params={
							  searchType : $("select[name='"+type+"']").val()
							, searchName : item
							, frmId      : frmId
							, inputNm    : inputNm
					}
					$.ajaxCall({
						url: "/manager/common/searchabo/searchAbo.do"
				   		, data: params
				   		, bLoading : "N"
				   		, success: function( data, textStatus, jqXHR){
				   			if(data.errCode==100) {
				   				alert("존재 하지 않는 ABO 입니다.");
				   				$("input[name='"+inputNm+"']").val("");
				   			} else if(data.errCode==1) {
				   				// 팝업 오픈
				   				var popParam = {
				   						url : "/manager/common/searchabo/searchAboPopup.do"
				   						, width : "800"
				   						, height : "980"
				   						, params : params
				   						, targetId : "searchAbo"
				   				}
				   				window.parent.openManageLayerPopup(popParam);
				   			} else {
				   				if(inputNm.substring(0,3)=="pop") {
				   					doReturnValue(data);
				   				} else {
				   					$("#btnSearch").click();
				   				}
				   			}
				   		},
				   		error: function( jqXHR, textStatus, errorThrown) {
				           	alert("처리도중 오류가 발생하였습니다.");
				   		}
				   	});
				}
			}
	
			return true;
		})
	);
	
	$tgt.on("click", function(){
		var params={
				  searchType : $("select[name='"+type+"']").val()
				, searchName : $("select[name='"+inputNm+"']").val()
				, frmId      : frmId
				, inputNm    : inputNm
		}
		var popParam = {
				url : "/manager/common/searchabo/searchAboPopup.do"
				, width : "800"
				, height : "980"
				, params : params
				, targetId : "searchAbo"
		}
		window.parent.openManageLayerPopup(popParam);
	});
	
};

$.fn.alphanumeric = function(p) { 
	 p = $.extend({ ichars: "!@#$%^&*()+=[]\\\';,/{}|\":<>?~`.-_ ", nchars: "", allow: "" }, p);
	 return this.each( function() {
	  
	  if (p.nocaps) p.nchars += "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	  if (p.allcaps) p.nchars += "abcdefghijklmnopqrstuvwxyz";
	  if (p.allcaps) p.nchars += "1234567890";
	  
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
 
// 교육비 원격지원
function remoteCall() {
	alert("원격지원 URL 호출 admin");
}

//maxlength 체크
function maxLengthCheck(object){
	if (object.value.length > object.maxLength){
		object.value = object.value.slice(0, object.maxLength);
	}    
}

//권한에 따른 스크립트 실행
function checkManagerAuth(auth){
	if(auth != "W"){
		alert("등록및 수정권한이 없습니다.")
		return true;
	}else{
		return false;
	}
}

function getGridDetailView(obj){
	var specs = "width=900px,height=740px,location=no,menubar=no,status=no,toolbar=no,scrollbars=yes";
	var popUp = window.open("/manager/common/main/gridDetail.do", "getGridDetailView" ,specs);
	popUp.document.write(Object.toJSON(obj));
}