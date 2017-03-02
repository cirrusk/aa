/**
 * jquery.aos.util.js
 * author : jkk5246@gmail.com
 * created : 2011.11.17
 */
var _fileinfo_ = {
	version : "3.2.1"
};
var UT = {
	getById : function(id) {
		return document.getElementById(id);
	},	
	/**
	 * 주어진 길이만큼 랜덤 문자를 리턴한다.
	 */
	getRandomString : function(length) {
		var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
		var random = "";
		for (var i = 0; i < length; i++) {
			random += chars.charAt(Math.round(Math.random() * 100) % chars.length);
		}
		return random;
	},
	/**
	 * 파일 크기 형태로 표현하기 : 1024 -> 1 MB
	 */
	getFilesize : function(size) {
		var suffix = ["B", "KB", "MB", "GB", "TB", "PB", "EB"]; 
		var unit = 1024;
		if (size < unit) {
			return size + " " + suffix[0];
		}
		var exp = Math.floor(Math.log(size) / Math.log(unit));
		return (Math.floor(size / Math.pow(unit, exp) * 10) / 10) + " " + suffix[exp]; 
	},
	/**
	 * 시작글자가 한글인지 검사
	 */
	startsWithHangul : function(str) {
		var pattern = /^[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;
		return str == null || str.length == 0 || !pattern.test(str) ? false : true; 
	},
	/**
	 * 주어진 문자열 왼쪽에 문자 채우기
	 */
	leftPad : function(str, size, padStr) {
		if (str == null) {
			return null;
		}
		if (padStr == null || padStr.length == 0) {
			padStr = " ";
		}
		var padLen = padStr.length;
		var strLen = str.length;
		var pads = size - strLen;
		if (pads <= 0) {
			return str; // returns original String when possible
		}
		if (pads == padLen) {
			return padStr + str;
		} else if (pads < padLen) {
			return padStr.substring (0, pads) + str;
		} else {
			var padding = "";
			for (var i = 0; i < pads; i++) {
				padding += padStr.charAt(i % padLen);
			}
			return padding + str;
		}
	},
	/**
	 * 주어진 문자열 오른쪽에 문자 채우기
	 */
	rightPad : function(str, size, padStr) {
		if (str == null) {
			return null;
		}
		if (padStr == null || padStr.length == 0) {
			padStr = " ";
		}
		var padLen = padStr.length;
		var strLen = str.length;
		var pads = size - strLen;
		if (pads <= 0) {
			return str; // returns original String when possible
		}
		if (pads == padLen) {
			return str + padStr;
		} else if (pads < padLen) {
			return str + padStr.substring (0, pads);
		} else {
			var padding = "";
			for (var i = 0; i < pads; i++) {
				padding += padStr.charAt(i % padLen);
			}
			return str + padding;
		}
	},
	/**
	 * array 안의 item을 제거
	 */
	removeArray : function(array, item) {
		return jQuery.grep(array, function(value) {
			return value !== item;
		});
	},
	/**
	 * array 안의 item을 unique 하게.
	 */
	uniqueArray : function(array) {
		var unique = [];
		for (var i = 0; i < array.length; i++) {
			if (jQuery.inArray(array[i], unique) == -1) {
				unique.push(array[i]);
			}
		}
		return unique;
	},
	/**
	 * array 안의 empty 값을 제거 (undefined 이거나 "")
	 */
	removeEmptyArray : function(array) {
	    return jQuery.grep(array, function(value) {
	        return typeof value !== "undefined" && value != "";
	    });
	},
	/**
	 * 체크된 checkbox(radio)의 값을 리턴하는 함수.
	 */
	getCheckedValue : function(form, name, seperator) {
		var $form = null;
		if (typeof form === "string") {
			$form = jQuery("#" + form);
		} else {
			$form = form;
		}
		var checked = [];
		jQuery(":input[name='" + name + "']:checked", $form).each(function() {
			checked.push(jQuery(this).val());
		});
		if (typeof seperator === "undefined") {
			seperator = ",";
		}
		return checked.join(seperator);
	},
	/**
	 * select 의 선택된 text 값 구하기.
	 */
	getSelectedText : function(form, selectName, seperator) {
		var $form = null;
		if (typeof form === "string") {
			$form = jQuery("#" + form);
		} else {
			$form = form;
		}
		var text = [];
		$form.find(":input[name='" + selectName + "']").each(function() {
			jQuery(this).find("option:selected").each(function(){
				text.push(this.text);
			});
		});
		if (typeof seperator === "undefined") {
			seperator = ",";
		}
		return text.join(seperator);
	},	
	/**
	 * select 의 선택된 value 값 구하기.
	 */
	getSelectedValue : function(form, selectName, seperator) {
		var $form = null;
		if (typeof form === "string") {
			$form = jQuery("#" + form);
		} else {
			$form = form;
		}
		var text = [];
		$form.find(":input[name='" + selectName + "']").each(function() {
			jQuery(this).find("option:selected").each(function(){
				text.push(this.value);
			});
		});
		if (typeof seperator === "undefined") {
			seperator = ",";
		}
		return text.join(seperator);
	},	
	/**
	 * sourceForm의 input elements의 값을 targetForm의 elements로 값을 복사 한다.
	 * sourceForm의 input element name 이 targetForm input element name 과 일치 하는 경우에만.
	 * :image, :submit, :reset, :button 는 제외함. 
	 */
	copyValueFormToForm : function(sourceForm, targetForm) {
		if (typeof sourceForm === "undefined" || typeof sourceForm === "undefined") {
			return;
		}
		var $source = null;
		if (typeof sourceForm === "string") {
			$source = jQuery("#" + sourceForm);
		} else {
			$source = sourceForm;
		}
		var map = {};
		jQuery(":input", $source).each(function () {
			var type = this.type.toLowerCase();
			if (type === "radio" || type === "checkbox") {
				map[this.name] = UT.getCheckedValue($source, this.name);
			} else {
				map[this.name] = jQuery(this).val();
			}
		});
		UT.copyValueMapToForm(map, targetForm);
	},
	/**
	 * map data 의 값을 targetForm의 elements로 값을 복사 한다.
	 * map = {"formElementName1" : "value", "formElementName2" : "value"}
	 */
	copyValueMapToForm : function(map, targetForm) {
		if (typeof map === "undefined" || typeof targetForm === "undefined") {
			return;
		}
		if (typeof targetForm === "string") {
			$target = jQuery("#" + targetForm);
		} else {
			$target = targetForm;
		}
		jQuery(":input", $target).each(function () {
			if (typeof map[this.name] !== "undefined" ) {
				var type = this.type.toLowerCase();
				if ((type === "radio" || type === "checkbox") && this.value == map[this.name]) {
					this.checked = true;
				} else {
					jQuery(this).val(map[this.name]);
				}
			}
		});
	},
	/**
	 * 주어진 form의 checkbox를 check 또는 uncheck 시키기.
	 * index 값을 주면 해당 index 만 처리된다. 
	 */
	checkedCheckbox : function(form, checkboxName, checked, index) {
		var $form = null;
		if (typeof form === "string") {
			$form = jQuery("#" + form);
		} else {
			$form = form;
		}
		jQuery(":checkbox[name='" + checkboxName + "']", $form).each(function(i) {
			if (typeof index === "undefined" || i === index) {
				this.checked = checked;
			}
		});
	},
	/**
	 * 주어진 form의 checkbo의 check를 toggle 시키기(check -> uncheck, uncheck -> check)
	 * index 값을 주면 해당 index 만 처리된다.
	*/
	toggleCheckbox : function(form, checkboxName, index) {
		var $form = null;
		if (typeof form === "string") {
			$form = jQuery("#" + form);
		} else {
			$form = form;
		}
		jQuery(":checkbox[name='" + checkboxName + "']", $form).each(function(i) {
			if (jQuery(this).is(":visible")) {
				if (typeof index === "undefined" || i === index) {
					if (this.disabled == false) {
						this.checked = !this.checked;
					}
				}
			}
		});
	},
	/**
	 * 포맷스트링
	 * text 내의 {0}, {name} 등의 문자열을 치환한다.
	 * 
	 * 
	 */
	// 
	formatString : function (string, col) {
		col = typeof col === "object" ? col : Array.prototype.slice.call(arguments, 1);

		return string.replace(/\{([^}]+)\}/gm, function () {
			return col[arguments[1]];
		});		
	},
	/**
	 * Date를 format String 으로 리턴한다.
	 */
	formatDateToString : function(date, format) {
		var replaces = {
			"year" : {
				pattern : /(y+)/gi,
				fn : function(match, p1, offset, string) {
					var y = "" + date.getFullYear();
					return match.length == 2 ? y.substring(2) : y; 
				} 
			},
			"month" : {
				pattern : /(M+)/g,
				fn : function(match, p1, offset, string) {
					var m = date.getMonth() + 1; 
					return match.length == 2 && m < 10 ? "0" + m : "" + m;
				}
			},
			"date" : {
				pattern : /(d+)/gi,
				fn : function(match, p1, offset, string) {
					var d = date.getDate();
					return match.length == 2 && d < 10 ? "0" + d : "" + d;
				}
			},
			"hour" : {
				pattern : /(h+)/gi,
				fn : function(match, p1, offset, string) {
					var h = date.getHours();
					if (string.toLowerCase().indexOf("a") > -1) {
						h = h % 12;
					}
					return match.length == 2 && h < 10 ? "0" + h : "" + h;
				}
			},
			"minute" : {
				pattern : /(m+)/g,
				fn : function(match, p1, offset, string) {
					var m = date.getMinutes(); 
					return match.length == 2 && m < 10 ? "0" + m : "" + m;
				}
			},
			"second" : { // "millisecond"
				pattern : /(s+)/gi,
				fn : function(match, p1, offset, string) {
					var s = date.getSeconds();
					if (match.length == 3) {
						s = date.getMilliseconds();
					}
					return match.length == 3 && s < 10 ? "00" + s : (match.length == 3 && s < 100) || (match.length == 2 && s < 10) ? "0" + s : "" + s;
				}
			},
			"ampm" : {
				pattern : /(a+)/gi,
				fn : function(match, p1, offset, string) {
					return date.getHours() > 12 ? "PM" : "AM";
				}
			}
		};
		for (var p in replaces) {
			format = format.replace(replaces[p].pattern, replaces[p].fn);
		}
		return format;	
	},
	/**
	 * date format String 을 Date로 리턴한다
	 */
	formatStringToDate : function(strDate, format) {
		if (typeof format === "undefined") {
			format = "yyyy.mm.dd";
		}
		var date = UT.getYMD({format : format, value : strDate});
		return new Date(date.year, date.month, date.date);
	},
	/**
	 * 주어진 format의 날짜형식 value에서 년,월,일 값을 구분해서 리턴.
	 * param : {format : "yyyy.MM.dd", value : "2010.03.04"}
	 * return : {year : "2010", month : "03", date : "04"}
	 */
	getYMD : function(param) {
		var ymd = {year : 0, month : 0, date : 0};
		if (param.value == "") return ymd;
		try {
			var delimiter = param.format.indexOf(".") >= 0 ? "." 
						  : param.format.indexOf("-") >= 0 ? "-"
						  : param.format.indexOf("/") >= 0 ? "/" : "";
			var y_pos = 1;
			var m_pos = 1;
			var d_pos = 1;
			param.format = param.format.toLowerCase();
			var y = param.format.indexOf("y");
			var m = param.format.indexOf("m");
			var d = param.format.indexOf("d");
			if (y == -1) y = 99;
			if (m == -1) m = 99;
			if (d == -1) d = 99;
			y_pos = y < m ? y < d ? 0 : 1 : 2;
			m_pos = m < d ? m < y ? 0 : 1 : 2;
			d_pos = d < y ? d < m ? 0 : 1 : 2;
					
			if (delimiter == "") {
				var yy = param.format.indexOf("y");
				param.format = param.format.substring(0, yy) + "." + param.format.substring(yy);
				param.value = param.value.substring(0, yy) + "." + param.value.substring(yy);
				var mm = param.format.indexOf("m");
				param.format = param.format.substring(0, mm) + "." + param.format.substring(mm);
				param.value = param.value.substring(0, mm) + "." + param.value.substring(mm);
				var dd = param.format.indexOf("d");
				param.format = param.format.substring(0, dd) + "." + param.format.substring(dd);
				param.value = param.value.substring(0, dd) + "." + param.value.substring(dd);
				delimiter = ".";
				var arr = param.value.split(delimiter);
				ymd.year  = arr.length > y_pos ? parseInt(arr[y_pos+1], 10) : 0;
				ymd.month = arr.length > m_pos ? parseInt(arr[m_pos+1], 10) - 1: 0;
				ymd.date  = arr.length > d_pos ? parseInt(arr[d_pos+1], 10) : 0;
			} else {
				var arr = param.value.split(delimiter);
				ymd.year  = arr.length > y_pos ? parseInt(arr[y_pos], 10) : 0;
				ymd.month = arr.length > m_pos ? parseInt(arr[m_pos], 10) - 1 : 0;
				ymd.date  = arr.length > d_pos ? parseInt(arr[d_pos], 10) : 0;
			}
		} catch (e) {
		}
		return ymd;
	},
	/**
	 * 두 날짜의 차이(일수)를 구한다, sDate가 크면 - 
	 */
	getInterval : function(sDate, eDate) {
		
		var time = eDate.getTime() - sDate.getTime();
		return (time / 1000 / 60 / 60 / 24);
	},
	/**
	 * 해당 월의 마지말 날짜를 format String 으로 리턴한다
	 */
	getLastDateOfMonth : function(year, month, format) {
		return UT.formatDateToString(new Date((new Date(year, month, 1)) -1), format);
	},
	/**
	 * HTML table 의 행을 이동한다.
	 */
	moveTableRow : function(table, fromIndex, toIndex) {
		if (table == null || fromIndex == null || toIndex == null) {
			return;
		}
		if (fromIndex == toIndex) {
			return;
		}
		if (fromIndex < 0 || toIndex < 0) {
			return;
		}
		var $fromRow = jQuery(table.rows[fromIndex]);
		var $toRow = jQuery(table.rows[toIndex]);
		if (fromIndex > toIndex) {
			$fromRow.insertBefore($toRow);
		} else {
			$fromRow.insertAfter($toRow);
		}
		if (jQuery.browser.msie && parseInt(jQuery.browser.version, 10) == 8) { // ie8 에서 table 의 공간이 생기는 경우가 있다.
			jQuery(table).hide().show();
		}
	},

	/**
	 * 현재 창이 팝업윈도우인지 검사.
	 */
	isPopup : function() {
		try {
			if (typeof opener === "object" && opener !== self) {
				return opener.document ? true : false;
			} else {
				return false;
			}
		} catch (e) {
			return false;
		}
	},
	/**
	 * 현재 창이 IFrame 인지 검사.
	 */
	isIframe : function() {
		if (self !== top) {
			try {
				return parent.document.getElementsByName(self.name)[0].tagName.toLowerCase() == "iframe" ? true : false;
			} catch (e) {
				return false;
			}
		} else {
			return false;
		}
	},
	/**
	 * 현재 창이 프레임인지 검사.
	 */
	isFrame : function() {
		return self !== top;
	},
	/**
	 * 이미지 바꾸기
	 */
	changeImage : function(img, filename) {
		var paths = img.src.split("/");
		paths[paths.length - 1] = filename;
		img.src = paths.join("/");
	},
	/**
	 * video tag를 지원하는지 검사
	 * @returns
	 */
	isSupportVideoTag : function() {
		return !!document.createElement('video').canPlayType;
	},
	/**
	 * iframe이 로드된 후에 스크롤 안생기게 하기
	 * <iframe name="iframeName" onload="noscrollIframe(this)"></iframe>
	 * 
	 * deprecated -> 아래 함수 쓰자.
	 */
	noscrollIframe : function(iframe) {
		setTimeout(function(){
			var iframeDoc = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
			jQuery(iframe).show();
			var h = iframeDoc.body.scrollHeight;
			jQuery(iframe).show().css({
				"width" : "100%", 
				"height" : (h) + "px"
			});
		}, 500);
	},
	/**
	 * iframe 의 height 에 scroll 이 생기지 않게 함. 
	 * 해당 iframe 에서 호출할것.
	 * jQuery(document).ready(function(){
	 *     UT.noscrollingIframe();
     * });
	 */
	noscrollingIframe : function(iframeName, height) {
		if (typeof iframeName === "string" && iframeName != "") {
				jQuery("iframe[name='" + iframeName + "']").css("height", height + "px");
				UT.noscrollingIframe();

		} else {
			if (self !== top) {
				setTimeout(function() {
					if (typeof parent.UT === "object") {
						parent.UT.noscrollingIframe(self.name, jQuery(self.document.body).height());
					}
				}, 100);
			}
		}
	},
	/**
	 * window의 스크롤을 최상단으로 보내기
	 */
	scrollTop : function(win) {
		if (typeof win === "undefined") {
			self.window.scrollTo(0, 0);
		} else {
			top.window.scrollTo(0, 0);
		}
	},
	/**
	* flash object를 출력한다.
	* <div id="elementId"></div>  
	* <script>displayFlash(swfUrl, replaceElementId, width, height, options)</script> 
	* swfobject.js 가 필요함.
	*/
	displayFlash : function(swfUrl, replaceElementId, width, height, options) {
		options = jQuery.extend(true, {}, options);
		var swfVersion = typeof options.swfVersion === "string" ? options.swfVersion : "9.0.0";
		var xiSwfUrl = typeof options.xiSwfUrl === "string"  ? options.xiSwfUrl : "";
		var callback = typeof options.callback === "function"  ? options.callback : null;
		var flashvars = jQuery.extend(true, {}, typeof options.flashvars === "object" ? options.flashvars : {});
		var params = jQuery.extend(true, {
			menu : "false",
			quality : "high",
			wmode : "transparent"
		}, typeof options.params === "object" ? options.params : {});
		var attrs = jQuery.extend(true, {}, typeof options.attrs === "object" ? options.attrs : {});
		swfobject.embedSWF(swfUrl, replaceElementId, width, height, swfVersion, xiSwfUrl, flashvars, params, attrs, callback);
	},
	/**
	 * get cookie
	 */
    getCookie : function(name) {
        var cookies = document.cookie.split(";");
        for (var i = 0; i < cookies.length; i++) {
            var cook = cookies[i].split("=");
            if (cook.length == 2) {
                cook[0] = cook[0].trim();
                cook[1] = cook[1].trim();
                if (cook[0] == name) {
                    return unescape(cook[1]);
                }
            }
        }
        return "";
    },
    /**
     * set cookie
     */
    setCookie : function(name, value, seconds, path, domain, secure) {
    	var cookie = [];
    	cookie.push(name + "=" + escape(value));
    	if (path != "") {
    		cookie.push("path=" + path);
    	}
    	if (domain != "") {
    		cookie.push("domain=" + domain);
    	}
    	if (secure != "") {
    		cookie.push("secure");
    	}
    	if (typeof seconds === "number") {
    		var date = new Date((new Date()).getTime() + (seconds * 1000));
    		cookie.push("expires=" + date.toGMTString());
    	} else if (typeof seconds === "object") {
    		cookie.push("expires=" + seconds.toGMTString());
    	}
    	document.cookie = cookie.join(";");
    },
    /**
     * del cookie
     */
    delCookie : function(name, path, domain, secure) {
    	var cookie = [];
    	cookie.push(name + "=");
    	if (path != "") {
    		cookie.push("path=" + path);
    	}
    	if (domain != "") {
    		cookie.push("domain=" + domain);
    	}
    	if (secure != "") {
    		cookie.push("secure");
    	}
    	cookie.push("expires=");
    	document.cookie = cookie.join(";");
    },
    /**
     * 배열인지 검사
     */
    isArray : function(obj) {
    	return Object.prototype.toString.call(obj) == "[object Array]";
    },
    /**
     * 스트링으로.
     */
    toString : function(obj) {
    	var str = "";
    	switch(typeof obj) {
    	case "number":
    	case "string":
    	case "boolean":
    		str = String(obj);
    		break;
    	case "function":
    		str = "[function]";
    		break;
    	case "object":
        	if (UT.isArray(obj) == true) {
        		str = "[" + obj + "]";
        		break;
        	}
    		var buffer = [];
    		for (var key in obj) {
    			var type = typeof obj[key];
   				var value = '"' + key + '":';
   				value += type === "string" ? '"' : '';
   				value += UT.toString(obj[key]);
   				value += type === "string" ? '"' : '';
   				buffer.push(value);
    		}
    		str = "{" + buffer.join(",") + "}";
    		break;
    	default:
       		str = "";
    		break;
    	}
    	return str;
    },
    /**
     * F5 키 막기 
     */
    preventF5 : function(event) {
		switch(event.keyCode) {
		case 116: // F5
			if(jQuery.browser.msie) {
				event = window.event;
				event.keyCode = 0;
				event.cancelBubble = true; 
				event.returnValue = false;
			} else {
				if (event.preventDefault ) {
					event.preventDefault();
				}
			}
			break;
		}
    },
    /**
     * backspace key 막기
     */
	preventBackspace : function(event) {
		switch(event.keyCode) {
		case 8: // backspace
			var prevent = true;
			if (event.target.nodeName == "INPUT" || event.target.nodeName == "TEXTAREA") {
				switch(event.target.type.toUpperCase()) {
			    case "TEXT":
			    case "PASSWORD":
			    case "TEXTAREA":
			    case "FILE":
			    	var readonly = jQuery(event.target).attr("readonly");
					if(true === readonly || "readonly" === readonly) {
						prevent = true;
					} else {
						prevent = false;
					}
			        break;
			    default :
					prevent = true;
			        break;
				}
			}
			if (prevent == true) { // 막기
				if (event.preventDefault) {
					event.preventDefault();
				} else {
					event.returnValue = false;
				}
			}
			break;
		}
	},
	/**
	 * json object를 string으로 변환
	 */
	jsonToString : function (json) {  
		if (json instanceof Object) {  
			var sOutput = "";  
			if (json.constructor === Array) {  
				for (var nId = 0; nId < json.length; nId++) {
					sOutput += UT.jsonToString(json[nId]) + ",";
				}
				return "[" + sOutput.substr(0, sOutput.length - 1) + "]";  
			}  
			if (json.toString !== Object.prototype.toString) { 
				return "\"" + json.toString().replace(/"/g, "\\$&") + "\""; 
			}  
			for (var sProp in json) { 
				sOutput += "\"" + sProp.replace(/"/g, "\\$&") + "\":" + UT.jsonToString(json[sProp]) + ","; 
			}  
			return "{" + sOutput.substr(0, sOutput.length - 1) + "}";  
		}  
		return typeof json === "string" ? "\"" + json.replace(/"/g, "\\$&") + "\"" : String(json);  
	},
	/**
	 * json 형태의 string을 json object로 변환
	 */
	stringToJson : function(s) {
		return eval("(" + s + ")");
	},
	/**
	 * input object에서 enter를 쳤을경우 다음 함수를 호출한다.
	 * Usage : onKeyup="UT.callFunctionByEnter(event, doSearch);"
	 *   arg : [option]
	 */
	callFunctionByEnter : function(event, func) {
		var args = Array.prototype.slice.call(arguments, 2);
		if (event.keyCode == 13) {
			if (typeof func === "function") {
				func.apply(this, args);
			}
		} else {
			return;
		}
	},
	/**
	 * img tag 에서 error 가 발생했을 경우, 대체 이미지 적용하기
	 * jQuery(document).ready() 에서 호출할 것.
	 * UT.defalutImage(jQuery(".photo"), src); 
	 * 다른 방법 : <img src="xxx.gif" onerror="this.src='yyy.gif'">
	 */
	defalutImage : function($selector, src) {
		if (typeof $selector !== "object") {
			return;
		}
		if (jQuery.browser.msie) {
			$selector.each(function() {
				if (this.complete === false) {
					this.src = src;
				}
			});
		} else if (jQuery.browser.opera) {
			$selector.each(function() {
				if (this.naturalWidth == 0) {
					this.src = src;
				}
			});
		} else {
			$selector.error(function() {
				this.src = src;
			});
		}
	},
	/**
	 * <foo&bar> -> "&lt;foo&amp;bar&gt"
	 */
	escapeXml : function(s) {
		return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");
	},
	/**
	 * flash 가 설치되어있는지. 설치되어있으면 버전번호 리턴.
	 */
	installedFlashPlugin : function() {
		if (typeof ActiveXObject === "function") {
			try {
				var f = new ActiveXObject("ShockwaveFlash.ShockwaveFlash");
				var version = f.getVariable("$version").replace(/WIN/,'').split(","); // "WIN 11,5,502,110" 이런 형태임
				return version[0] + "." + version[1];
			} catch (e) {
				return null;
			}
		} else {
			var version = null;
			for (var p in navigator.plugins) {
				if (typeof navigator.plugins[p].name === "string" && navigator.plugins[p].name.indexOf("Shockwave Flash") > -1) {
					var desc = navigator.plugins[p]["description"].split(" "); // "Shockwave Flash 11.4 r402" 이런 형태임
					return desc[2];
					break;
				}
			}
			return version; 
		}
	},
	/**
	 * Windowns Media Player 가 설치되어있는지 여부 리턴
	 */
	installedMediaPlayerPlugin : function() {
		if (typeof ActiveXObject === "function") {
			try {
				new ActiveXObject("WMPlayer.OCX");
				return true;
			} catch (e) {
				return false;
			}
		} else {
			var installed = false;
			for (var p in navigator.plugins) {
				if (typeof navigator.plugins[p].name === "string" && navigator.plugins[p].name.indexOf("Windows Media Player") > -1) {
					installed = true;
					break;
				}
			}
			return installed ? true : false; 
		}
	},
	/**
	 * popup 에서 unload 이벤트에 callback을 연결시킬 때 사용한다.
	 * unload event 를 만든다. callback 함수를 연결한다. win이 팝업일 경우에는 아무 문제없음.
	 * win이 iframe(layer) 이고 브라우저가 크롬일때, 크롬은 iframe에서 unload 이벤트가 발생하지 않는다. 
	 * 따라서 layer의 경우에는 action.config.callback = function() {...}; 의 방법을 이용해야한다.
	 * UT.unloadWindow(self, function() {...});
	 */
	unloadWindow : function(win, callback) {
		var event = "unload";
		if (jQuery.browser.msie || jQuery.browser.mozilla) {
			event = "beforeunload";
		} else {
			event = "unload";
		} 
		jQuery(win).bind(event, function() {
			if (typeof callback === "function") {
				callback.call(this);
			}
		});
	},
	/**
	 * window location 의 hash가 변경되면 callback 함수 호출됨.
	 * a href="#abcd" 와 같이 정의하고, callback 함수에서 실제의 행위를 정의한다.
	 * ajax의 history back, forward 기능이 가능하다.
	 */
	changedHash : function(win, callback) {
	    if(jQuery.browser.msie && (parseInt(jQuery.browser.version, 10) < 8 || parseInt(win.document.documentMode, 10) < 8)) {
	    	_lastHash_ = win.location.hash;
	    	if (typeof _hashTimer_ !== "undefined") {
	    		clearInterval(_hashTimer_);
	    	}
	    	// _hashTimer_는 전역변수
	    	_hashTimer_ = setInterval(function() {
	    		var hash = win.location.hash;
	    		if (hash != _lastHash_) {
	    			if (typeof callback === "function") {
	    				callback.call(this, hash);
	    			}
	    			_lastHash_ = hash;
	    		}
	    	}, 100);
	    } else if("onhashchange" in win) {
	    	$(win).on("hashchange", function(event) {
	            var hash = win.location.hash;
	            if (typeof callback === "function") {
	            	callback.call(this, hash);
	            }
	    	});
	    }
		jQuery(win.document).find("a[href^='#']").on("click", function(event) { // location.hash 가 변경되지 않고 클릭시 반응.
			var hash = win.location.hash;
			var $this = jQuery(this);
			if (typeof $this.attr("onclick") === "undefined" && hash == $this.attr("href")) {
				if (typeof callback === "function") {
					callback.call(this, hash);
				}
			}
		});
	},
	/**
	 * firefox의 입력창 input, textarea에서 keydown 이벤트를 처리하려고 할 때, 
	 * 한글이 입력되면 event가 발생하지 않는 경우를 위해 이용한다.
	 */
	firefoxInputEvent : function($element, triggerEvent) {
		if (jQuery.browser.mozilla) {
			var timer = null;
			$element.focus(function() {
				timer = setInterval(function() {
					$element.trigger(triggerEvent);
				}, 200);
			});
			$element.blur(function() {
				clearInterval(timer);
			});
		}
	},
	/**
	 * 배열의 indexOf
	 */
	indexOfArray : function(arr, el) {
		for (var i = 0; i < arr.length; i++) {
			if (arr[i] === el) {
				return i;
			}
		}
		return -1;
	},
	/**
	 * msie 8 이하 버전에서 css의 border가 thin, medium, thick으로 지정 된 경우 px로 다시 지정한다.
	 * thin : 1px, medium : 3px, thick : 5px
	 */
	resetCssBorderWidth : function(element) {
		var $element = jQuery(element);

		if (jQuery.browser.msie && parseInt(jQuery.browser.version, 10) <= 8) { 
			var getBorderWidth = function(direct) {
				var width = {
					thin : "1px",
					medium : "3px",
					thick : "5px"
				};
				var cssStyle = $element.css("border-" + direct + "-style"); 
				var cssWidth = $element.css("border-" + direct + "-width"); 
				if (cssStyle == "none") {
					return "0px";
				} else {
					return typeof width[cssWidth] === "string" ? width[cssWidth] : cssWidth;
				}
			};
			$element.css({
				borderLeftWidth : getBorderWidth("left"), 
				borderRightWidth : getBorderWidth("right"), 
				borderTopWidth : getBorderWidth("top"), 
				borderBottomWidth : getBorderWidth("bottom") 
			});
		}
	}
};





