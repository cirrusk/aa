<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
/**
 *
 */
var FN = {
	/**
	 * 소팅 아이콘 처리 및 소팅 이벤트 설정
	 * 
	 * @param elementId
	 * @param orderbyValue
	 * @param formId
	 * @param callback
	 */
	doSortList : function(elementId, orderbyValue, formId, callback) {
		jQuery(".sort", jQuery("#" + elementId)).each(function() {
			orderbyValue = parseInt(orderbyValue, 10);
			if (Math.abs(orderbyValue) == parseInt(jQuery(this).attr("sortid"), 10)) {
				jQuery(this).attr("sortid", orderbyValue);
				if (orderbyValue > 0) {
					jQuery(this).addClass("sort_asc");
				} else {
					jQuery(this).addClass("sort_desc");
				}
			}
			var span = this;
			var parent = jQuery(this).parent();
			jQuery(parent).css("cursor", "pointer");
			jQuery(parent).click(function() {
				var form = UT.getById(formId);
				form.elements["orderby"].value = parseInt(
						jQuery(span).attr("sortid"), 10)
						* (-1);
				if (typeof callback === "function") {
					callback.call(this);
				}
			});
		});
	},
	/**
	 * 메뉴 이동
	 * 
	 * @param url
	 */
	doGoMenu : function(url, menuId, formId, target) {
		if (url == "") {
			return;
		}
		var action = $.action();
		if(url.indexOf("http://") > -1 || url.indexOf("https://") > -1){
			action.config.url = url;
		}else{
			action.config.url = '<c:out value="${appSystemDomain}"/>' + url;
		}
		
		action.config.formId = formId;
		if (typeof action.config.formId !== "string"
				|| action.config.formId.length == 0
				|| typeof UT.getById(action.config.formId) !== "object") {
			action.config.formId = "FormParameters";
		}
		var form = UT.getById(action.config.formId);
		if (typeof form.elements["currentMenuId"] === "undefined") {
			jQuery("<input type='hidden' name='currentMenuId' value='" + menuId + "'>").appendTo(jQuery(form));
		} else {
			form.elements["currentMenuId"].value = menuId;
		}
		action.config.target = typeof target === "string" && target.length > 0 ? target : "_self";
		action.run();
	},
	/**
	 * 동적게시판 메뉴 이동
	 * 
	 * @param url
	 */
	doGoMenuBbs : function(url, menuId, formId, seq, title, target) {
		if (url == "") {
			return;
		}
		var action = $.action();
		action.config.url = url;
		action.config.formId = formId;
		if (typeof action.config.formId !== "string"
				|| action.config.formId.length == 0
				|| typeof UT.getById(action.config.formId) !== "object") {
			action.config.formId = "FormParameters";
		}
		var form = UT.getById(action.config.formId);
		if (typeof form.elements["currentMenuId"] === "undefined") {
			jQuery("<input type='hidden' name='currentMenuId' value='" + menuId + "'>").appendTo(jQuery(form));
		} else {
			form.elements["currentMenuId"].value = menuId;
		}

		if (typeof form.elements["srchBoardSeq"] === "undefined") {
			jQuery("<input type='hidden' name='srchBoardSeq' value='" + seq + "'>").appendTo(jQuery(form));
		} else {
			form.elements["srchBoardSeq"].value = seq;
		}

		if (typeof form.elements["dynamicTitle"] === "undefined") {
			jQuery("<input type='hidden' name='dynamicTitle' value='" + title + "'>").appendTo(jQuery(form));
		} else {
			form.elements["dynamicTitle"].value = title;
		}
		action.config.target = typeof target === "string" && target.length > 0 ? target : "_self";
		action.run();
	},
	/**
	 * 우편번호 팝업
	 * 
	 * @param param = {url:'',title:'',callback:''}
	 */
	doOpenZipcodePopup : function(param) {
		var action = $.action("layer");
		action.config.formId = "FormParameters";
		action.config.formEmpty = true;
		action.config.url = param.url == null ? "<c:url value="/zipcode/list/popup.do"/>" : param.url;
		if (typeof param.callback === "string") {
			action.config.parameters = "callback=" + param.callback;
		}
		action.config.options.width = 500;
		action.config.options.height = 500;
		action.config.options.title = param.title;
		action.run();
	},
	/**
	 * 소속 팝업
	 * 
	 * @param param = {url:'',title:'',callback:''}
	 */
	doOpenCompanyPopup : function(param) {
		var action = $.action("layer");
		action.config.formId = "FormParameters";
		action.config.formEmpty = true;
		action.config.url = param.url == null ? "<c:url value="/company/list/popup.do"/>" : param.url;
		if (typeof param.callback === "string") {
			action.config.parameters = "callback=" + param.callback;
		}
		action.config.options.width = 600;
		action.config.options.height = 500;
		action.config.options.title = param.title;
		action.run();
	},
	/**
	 * 회원 팝업
	 * 
	 * @param param = {url:'',title:'',callback:''}
	 */
	doOpenMemberPopup : function(param) {
		var action = $.action("layer");
		action.config.formId = "FormParameters";
		action.config.formEmpty = true;
		action.config.url = param.url == null ? "<c:url value="/member/list/popup.do"/>" : param.url;
		if (typeof param.callback === "string") {
			action.config.parameters = "callback=" + param.callback;
		}
		action.config.options.width = 600;
		action.config.options.height = 500;
		action.config.options.title = param.title;
		action.run();
	},
	/**
	 * 회원 상세 팝업
	 * 
	 * @param param = {url:'',title:'',callback:''}
	 */
	doDetailMemberPopup : function(param) {
		var action = $.action("layer");
		action.config.formId = "FormParameters";
		action.config.formEmpty = true;
		action.config.url = param.url == null ? "<c:url value="/member/detail/popup.do"/>" : param.url;
		action.config.parameters = "memberSeq=" + param.memberSeq;
		action.config.options.width = 1000;
		action.config.options.height = 500;
		action.config.options.title = param.title;
		action.run();
	},	
	/**
	 * 메모, sms, 이메일 회원 팝업
	 * 
	 * @param param = {url:'',title:'',callback:'',messageType:''}
	 */
	doOpenMemoMemberPopup : function(param) {
		var action = $.action("layer");
		action.config.formId = "FormParameters";
		action.config.formEmpty = true;
		action.config.url = param.url == null ? "<c:url value="/member/memo/list/popup.do"/>" : param.url;
		
		var tempParam = [];
		var messageType = param.messageType;
		var callback = param.callback;
					
		if(typeof messageType !== "undefined"){
			tempParam.push("messageType=" + messageType);
		}
		if (typeof callback !== "undefined") {
			tempParam.push("callback=" + callback);
		}
		action.config.parameters = tempParam.join("&");
		action.config.options.width = 900;
		action.config.options.height = 700;
		action.config.options.title = param.title;
		action.run();
	},
	/**
	 * 첨부파일 다운로드
	 */
	doAttachDownload : function(attachSeq) {
		var action = $.action();
		action.config.formId = "FormParameters";
		action.config.url = "<c:url value="/attach/file/response.do"/>";
		jQuery("#" + action.config.formId).find(":input[name='attachSeq']").remove();
	
		var param = [];
		param.push("attachSeq=" + attachSeq);
		action.config.parameters = param.join("&");
		action.run();
	},	
	/**
	 * 첨부파일 이미지 response
	 */
	doResponseAttachImage : function(selector, url, www) {
		url += "?" + Global.parameters;
		jQuery(selector).each(function() {
			this.src = url + "&attachSeq=" + jQuery(this).attr("key") + "&www=" + www;
		});
	},
	/**
	 * 좌측 메뉴 보이기/숨기기
	 */
	doToggleSideMenu : function() {
		var $sideMenu = jQuery("#section_west");
		if ($sideMenu.is(":visible")) {
			UI.effectTransfer("section_west", "breadCrumb", "effectTransfer", function() {
				$sideMenu.hide();
				$sideMenu.children().hide();
				UT.setCookie("sideMenuVisible", "hidden", 60 * 60 * 24,
						"/", "", "");
				jQuery("#breadCrumb").addClass("cursorPointer");
			});
		} else {
			$sideMenu.show();
			UI.effectTransfer("breadCrumb", "section_west", "effectTransfer", function() {
				$sideMenu.children().show();
				UT.delCookie("sideMenuVisible", "/", "", "");
				jQuery("#breadCrumb").removeClass("cursorPointer");
			});
		}
	},
	/**
	 * 좌측 메뉴 보이기
	 */
	doShowSideMenu : function() {
		var $sideMenu = jQuery("#section_west");
		if ($sideMenu.is(":visible") == false) {
			FN.doToggleSideMenu();
		}
	},
	/**
	 * 목록의 체크박스 클릭시 삭제버튼 보이기(한개 이상 체크되어있을 때)/숨기기(하나도 체크가 되어 있지 않을 때)
	 * 
	 * @param checkbox
	 * @param toggleButtonIds(...)
	 *            복수 가능
	 */
	onClickCheckbox : function(checkbox) {
		var $checkbox = jQuery(checkbox);
		var checkboxName = $checkbox.attr("name");
		var $form = $checkbox.parents("form");
		var checked = false;
		jQuery(":input[name=" + checkboxName + "]", $form).each(function() {
			if (this.checked == true) {
				if (this.disabled == false) {
					checked = true;
				}
			}
		});

		var toggleButtonIds = Array.prototype.slice.call(arguments, 1);
		if (checked == true) {
			for ( var index in toggleButtonIds) {
				jQuery("#" + toggleButtonIds[index]).show();
			}
		} else {
			for ( var index in toggleButtonIds) {
				jQuery("#" + toggleButtonIds[index]).hide();
			}
		}
	},
	/**
	 * 목록 타이틀에서 토글 체크박스 선택시.
	 * 
	 * @param formId
	 * @param checkboxName
	 * @param toggleButtonIds(...) -
	 *            복수 가능
	 */
	toggleCheckbox : function(formId, checkboxName) {
		UT.toggleCheckbox(formId, checkboxName);
		var toggleButtonIds = Array.prototype.slice.call(arguments, 2);
		var args = [];
		args.push(jQuery("#" + formId + " :input[name=" + checkboxName + "]").filter(":first"));
		args = args.concat(toggleButtonIds);
		FN.onClickCheckbox.apply(this, args);

	},
	/**
	 * 검색 폼 reset - srch로 시작하는 form element 에 대해서, startName을 주면 해당 하는 값에 대해서도.
	 * srch 또는 startName 로 시작하지 않는 elememt는 값을 유지한다. selectbox 는 0 번째를 select
	 * 하고, checkbox or radio 는 모두 checked 를 false 하고, 나머지는 값을 모두 지운다. 디폴트 값이 필요한
	 * element는 default='xx' 와 같이 attribute default 에 값을 준다. (checkbox, radio는
	 * default='checked' 와 같이 하면 선택되도록 한다.)
	 */
	resetSearchForm : function(formId, startName) {
		var $form = jQuery("#" + formId);
		$form.find(":input[name^='srch']").each(function() {
			if (this.tagName.toLowerCase() == "select") {
				this.selectedIndex = 0;
			} else {
				switch (this.type.toLowerCase()) {
				case "checkbox":
				case "radio":
					this.checked = false;
					break;
				default:
					this.value = "";
					break;
				}
			}
		});
		if (typeof startName === "string") {
			$form.find(":input[name^='" + startName + "']").each(function() {
				if (this.tagName.toLowerCase() == "select") {
					this.selectedIndex = 0;
				} else {
					switch (this.type.toLowerCase()) {
					case "checkbox":
					case "radio":
						this.checked = false;
						break;
					default:
						this.value = "";
						break;
					}
				}
			});
		}
		$form.find(":input").each(function() {
			var defaultValue = jQuery(this).attr("default");
			if (typeof defaultValue === "string") {
				if (this.tagName.toLowerCase() == "select") {
					this.value = defaultValue;
				} else {
					switch (this.type.toLowerCase()) {
					case "checkbox":
					case "radio":
						if (defaultValue == "checked") {
							this.checked = true;
						}
						break;
					default:
						this.value = defaultValue;
						break;
					}
				}
			}
		});
	},
	/**
	 * layer popup의 레이아웃의 padding과 스크롤 설정을 한다.
	 */
	layerPopupWrap : function(layoutElementId, padding, scroll) {
		var $window = jQuery(window);
		var $element = jQuery("#" + layoutElementId);
		$element.css({
			padding : padding,
			position : "relative"
		});
		
		UT.resetCssBorderWidth($element); // ie 8이하 버전에서 적용됨.
		
		var w = $window.width();
		w -= ($element.outerWidth() - $element.innerWidth()); // 단위가 px로 설정 되지 않았을 경우를 위해.
		w -= (parseInt($element.css("padding-left"), 10) + parseInt($element.css("padding-right"), 10));

		var h = $window.height();
		h -= ($element.outerHeight() - $element.innerHeight()); // 단위가 px로 설정 되지 않았을 경우를 위해.
		h -= (parseInt($element.css("padding-top"), 10) + parseInt($element.css("padding-bottom"), 10));

		$element.css({
			width : w + "px",
			height : h + "px"
		});
		switch (scroll) {
		case "scroll-x" :
			$element.css({
				overflowX : "auto",
				overflowY : "hidden"
			});
			break;
		case "scroll-y" :
			$element.css({
				overflowX : "hidden",
				overflowY : "auto"
			});
			break;
		case "scroll-xy" :
			$element.css({
				overflowX : "auto",
				overflowY : "auto"
			});
			break;
		}
	},
	
		
	/**
 	 * 회원 쪽지전송 레이어 호출
 	 * 넘겨진 form에 기본 필수 hidden 값:
 	 								체크박스로 선택하여 여러사람한테 보낼시 사용시 : checkkeys, memberSeqs, memberNames
 	 								한 사람한테 보낼시 사용시 (회원정보) : memberSeq, memberName
 	 * callback을 사용할시 예 : FN.doMemoCreate(formId, callback);
 	 * callback을 사용안할시 예 : FN.doMemoCreate(formId);
	 */
	doMemoCreate : function(formId, callback) {
		forMemoCreate = $.action("layer", {formId : formId});
		forMemoCreate.config.url = "<c:url value="/usr/message/group/send/popup.do"/>";
		forMemoCreate.config.options.width  = 600;
		forMemoCreate.config.options.height = 400;
		forMemoCreate.config.options.position = "middle";
		forMemoCreate.config.options.title  = "<spring:message code="글:쪽지:쪽지쓰기"/>";
		if (typeof callback !== "undefined"){
			forMemoCreate.config.options.callback = callback;
		}
		forMemoCreate.run();
	},
	
	/**
 	 * 회원 이메일 전송 레이어 호출
 	 * 넘겨진 form에 기본 필수 hidden 값:
 	 								체크박스로 선택하여 여러사람한테 보낼시 사용시 : checkkeys, memberSeqs, memberNames
 	 								한 사람한테 보낼시 사용시 (회원정보) : memberSeq, memberName
 	 * callback을 사용할시 예 : FN.doCreateEmail(formId, callback);
 	 * callback을 사용안할시 예 : FN.doCreateEmail(formId);
	 */
	doCreateEmail : function(formId, callback) {
		forCreateEmail = $.action("layer", {formId : formId});
	    forCreateEmail.config.url            = "<c:url value="/usr/message/email/popup.do"/>";
	    forCreateEmail.config.options.width  = 800;
	    forCreateEmail.config.options.height = 600;
	    forCreateEmail.config.options.position = "middle";
	    forCreateEmail.config.options.title  = "<spring:message code="글:이메일:이메일발송"/>";
	    if (typeof callback !== "undefined"){
	    	forCreateEmail.config.options.callback = callback;
	    }
	    forCreateEmail.run();
	},
	
	/**
 	 * 회원 SMS 전송 레이어 호출
 	 * 넘겨진 form에 기본 필수 hidden 값:
 	 								체크박스로 선택하여 여러사람한테 보낼시 사용시 : checkkeys, memberSeqs, memberNames, phoneMobiles
 	 								한 사람한테 보낼시 사용시 (회원정보) : memberSeq, memberName, phoneMobile
 	 * callback을 사용할시 예 : FN.doCreateEmail(formId, callback);
 	 * callback을 사용안할시 예 : FN.doCreateEmail(formId);
	 */
	doCreateSms : function(formId, callback) {
		forCreateSms = $.action("layer", {formId : formId});
	    forCreateSms.config.url            = "<c:url value="/usr/message/sms/popup.do"/>";
	    forCreateSms.config.options.width  = 505;
	    forCreateSms.config.options.height = 600;
	    forCreateSms.config.options.position = "middle";
	    forCreateSms.config.options.title  = "<spring:message code="글:sms:sms발송"/>";
	    if (typeof callback !== "undefined"){
	    	forCreateSms.config.options.callback = callback;
	    }
	    forCreateSms.run();
	},
	
	/**
	 * 다국어 언어 변경
	 */
	doChangeLanguage : function(lang) {
		UT.setCookie("lang", lang, 60*60*24*30, "/", "", "");
		top.location.href = "/";
	}
};