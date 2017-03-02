/**
 * jquery.learning.simple.api.js 
 * author : jkk5246@gmail.com 
 * version : 1.0.0 
 * created : 2012.01.26
 */
var _fileinfo_ = {
	version : "3.2.1"
};
var API_ERROR = {
	NO_ERROR : {code : 0, string : I18N["Aos:Learing:NoError"]}, // 정상처리 되었습니다
	INITIALIZE_FAILURE : {code : 100, string : I18N["Aos:Learing:InitializeFailure"]}, // 초기화에 실패하였습니다
	INITIALIZE_AFTER_INITIALIZE : {code : 101, string : I18N["Aos:Learing:InitializeAfterInitialize"]}, // 이미 초기화 되었습니다
	INITIALIZE_AFTER_TERMINATE : {code : 102, string : I18N["Aos:Learing:InitializeAfterTerminate"]}, // 이미 종료되었습니다
	INITIALIZE_ARGUMENT : {code : 103, string : I18N["Aos:Learing:InitializeArgument"]}, // Argument가 정확하지 않습니다
	
	TERMINATE_FAILURE : {code : 200, string : I18N["Aos:Learing:TerminateFailure"]}, // 정상적인 종료가 되지않았습니다
	TERMINATE_BEFORE_INITIALIZE : {code : 201, string : I18N["Aos:Learing:TerminateBeforeInitialize"]}, // 초기화되기 전 상태입니다
	TERMINATE_AFTER_TERMINATE : {code : 202, string : I18N["Aos:Learing:TerminateAfterTerminate"]}, // 이미 종료되었습니다
	TERMINATE_ARGUMENT : {code : 203, string : I18N["Aos:Learing:TerminateArgument"]}, // Argument가 정확하지 않습니다

	COMMIT_FAILURE : {code : 300, string : I18N["Aos:Learing:CommitFailure"]}, // 서버 또는 네트워크 상태가 불안정합니다.<br>종료 후 다시 시도하십시오
	COMMIT_BEFORE_INITIALIZE : {code : 301, string : I18N["Aos:Learing:CommitBeforeInitialize"]}, // 초기화되기 전 상태입니다
	COMMIT_AFTER_TERMINATE : {code : 302, string : I18N["Aos:Learing:CommitAfterTerminate"]}, // 이미 종료되었습니다
	COMMIT_ARGUMENT : {code : 303, string : I18N["Aos:Learing:CommitArgument"]}, // Argument가 정확하지 않습니다
	
	GETVALUE_FAILURE : {code : 400, string : I18N["Aos:Learing:GetvalueFailure"]}, // 학습데이터 읽기 오류가 발생하였습니다
	GETVALUE_BEFORE_INITIALIZE : {code : 401, string : I18N["Aos:Learing:GetvalueBeforeInitialize"]}, // 초기화되기 전 상태입니다
	GETVALUE_AFTER_TERMINATE : {code : 402, string : I18N["Aos:Learing:GetvalueAfterTerminate"]}, // 이미 종료되었습니다
	GETVALUE_ARGUMENT : {code : 403, string : I18N["Aos:Learing:GetvalueArgument"]}, // Argument가 정확하지 않습니다
	
	SETVALUE_FAILURE : {code : 500, string : I18N["Aos:Learing:SetvalueFailure"]}, // 학습데이터 쓰기 오류가 발생하였습니다
	SETVALUE_BEFORE_INITIALIZE : {code : 501, string : I18N["Aos:Learing:SetvalueBeforeInitialize"]}, // 초기화되기 전 상태입니다
	SETVALUE_AFTER_TERMINATE : {code : 502, string : I18N["Aos:Learing:SetvalueAfterTerminate"]}, // 이미 종료되었습니다
	SETVALUE_ARGUMENT : {code : 503, string : I18N["Aos:Learing:SetvalueArgument"]} // Argument가 정확하지 않습니다
};

var API = {
	status : "",
	debug : {
		on : false,
		callback : null
	},
	url : {
		initialize : "/learning/api/simple/initialize.do",
		terminate : "/learning/api/simple/terminate.do",
		commit : "/learning/api/simple/commit.do",
		restore : "/learning/api/simple/restore.do",
		othersData : "/learning/api/simple/get/others/data.do"
	},
	timer : null,
	timerInterval : 1000 * 60 * 3, // 3분
	dataModel : null,
	learningData : {
		organizationSeq : "",
		itemSeq : "",
		courseId : "",
		applyId : "",
		startTime : "",
		contentTypeCd : "",
		accessToken : ""
	},
	exception : { 
		callback : function() {
			if (API.debug.on == false) {
				self.close();
			}
		}
	},
	error : API_ERROR.NO_ERROR,
	Initialize : function(param) {
		if (API.status === "exception") {
			return "false";
		}
		if (API.status === "terminated") {
			API.setError(API_ERROR.INITIALIZE_AFTER_TERMINATE, "[Initialize]");
			return "false";
		}
		if (API.status === "initialized") {
			API.setError(API_ERROR.INITIALIZE_AFTER_INITIALIZE, "[Initialize]");
			return "false";
		}
		if (typeof param !== "undefined" && param != "") {
			API.setError(API_ERROR.INITIALIZE_ARGUMENT, "[Initialize]");
			return "false";
		}
		var parameters = {
			url : API.url.initialize,
			data : API.getJsonParameters("", API.learningData)
		};
		var returnValue = API.ajax(parameters);
		if ("true" == returnValue.result) {
			API.status = "initialized";
			API.dataModel = returnValue.dataModel;
			var data = API.getJsonParameters("", API.dataModel) + "&" + API.getJsonParameters("", API.learningData);
			API.setError(API_ERROR.NO_ERROR, "[Initialize]", data.split("&").join("\n"));
			API.timer = setInterval("API.Commit('')", API.timerInterval);
			return "true";
		} else {
			API.status = "";
			API.dataModel = null;
			API.setError(API_ERROR.INITIALIZE_FAILURE, "[Initialize]");
			API.quitAlert();
			return "false";
		}
	},
	Terminate : function(param) {
		
		if(API.url.terminate == ''){
			return "true";
		}
		
		if (API.status === "exception") {
			return "false";
		}
		if (API.status === "terminated") {
			API.setError(API_ERROR.TERMINATE_AFTER_TERMINATE, "[Terminate]");
			return "false";
		}
		if (API.status !== "initialized") {
			API.setError(API_ERROR.TERMINATE_BEFORE_INITIALIZE, "[Terminate]");
			return "false";
		}
		if (typeof param !== "undefined" && param != "") {
			API.setError(API_ERROR.TERMINATE_ARGUMENT, "[Terminate]");
			return "false";
		}
		API.SetValue("cmi.exit", "exit");
		
		var parameters = {
			url : API.url.terminate,
			data : API.getJsonParameters("", API.dataModel) + "&" + API.getJsonParameters("", API.learningData)
		};
		var returnValue = API.ajax(parameters);
		if ("true" == returnValue.result) {
			API.status = "terminated";
			API.dataModel = null;
			API.setError(API_ERROR.NO_ERROR, "[Terminate]", parameters.data.split("&").join("\n"));
			clearInterval(API.timer);
			return "true";
		} else {
			API.setError(API_ERROR.TERMINATE_FAILURE, "[Terminate]", parameters.data.split("&").join("\n"));
			API.quitAlert();
			return "false";
		}
	},
	Commit : function(param) {
		
		if(API.url.commit == ''){
			return "true";
		}
		
		if (API.status === "exception") {
			return "false";
		}
		if (API.status === "terminated") {
			API.setError(API_ERROR.COMMIT_AFTER_TERMINATE, "[Commit]");
			return "false";
		}
		if (API.status !== "initialized") {
			API.setError(API_ERROR.COMMIT_BEFORE_INITIALIZE, "[Commit]");
			return "false";
		}
		if (typeof param !== "undefined" && param != "") {
			API.setError(API_ERROR.COMMIT_ARGUMENT, "[Commit]");
			return "false";
		}
		
		var parameters = {
			url : API.url.commit,
			data : API.getJsonParameters("", API.dataModel) + "&" + API.getJsonParameters("", API.learningData)
		};
		var returnValue = API.ajax(parameters);
		if ("true" == returnValue.result) {
			API.delCookie();
			API.setError(API_ERROR.NO_ERROR, "[Commit]", parameters.data.split("&").join("\n"));
			return "true";
		} else {
			API.setError(API_ERROR.COMMIT_FAILURE, "[Commit]", parameters.data.split("&").join("\n"));
			API.quitAlert();
			return "false";
		}
	},
	GetValue : function(dataModelElement) {
		if (API.status === "terminated") {
			API.setError(API_ERROR.GETVALUE_AFTER_TERMINATE, "[GetValue]");
			return "false";
		}
		if (API.status !== "initialized") {
			API.setError(API_ERROR.GETVALUE_BEFORE_INITIALIZE, "[GetValue]");
			return "false";
		}
		if (typeof dataModelElement === "undefined" || dataModelElement == "") {
			API.setError(API_ERROR.GETVALUE_ARGUMENT, "[GetValue]");
			return "false";
		}
		
		var result = "unknown";
		try {
			result = API.getDataModel(dataModelElement);
			API.setError(API_ERROR.NO_ERROR, "[GetValue]", dataModelElement + "=" + result);
		} catch (e) {
			API.setError(API_ERROR.GETVALUE_FAILURE, "[GetValue]", dataModelElement + "=" + result);
		}
		return result;
	},
	SetValue : function(dataModelElement, dataModelValue) {
		if (API.status === "terminated") {
			API.setError(API_ERROR.SETVALUE_AFTER_TERMINATE, "[SetValue]");
			return "false";
		}
		if (API.status !== "initialized") {
			API.setError(API_ERROR.SETVALUE_BEFORE_INITIALIZE, "[SetValue]");
			return "false";
		}
		if (typeof dataModelElement === "undefined" || dataModelElement == "" || typeof dataModelValue === "undefined") {
			API.setError(API_ERROR.SETVALUE_ARGUMENT, "[SetValue]");
			return "false";
		}

		try {
			API.setDataModel(dataModelElement, dataModelValue);
			API.setError(API_ERROR.NO_ERROR, "[SetValue]", dataModelElement + "=" + dataModelValue);
			return "true";
		} catch (e) {
			API.setError(API_ERROR.SETVALUE_FAILURE, "[SetValue]", dataModelElement + "=" + dataModelValue);
			return "false";
		}
	},
	getOthersData : function(dataName) {
		
		if(API.url.commit == ''){
			return "true";
		}
		
		if (API.status === "terminated") {
			API.setError(API_ERROR.GETVALUE_AFTER_TERMINATE, "[GetOthersData]");
			return "false";
		}
		if (API.status !== "initialized") {
			API.setError(API_ERROR.GETVALUE_BEFORE_INITIALIZE, "[GetOthersData]");
			return "false";
		}
		if (typeof dataName === "undefined" || dataName == "") {
			API.setError(API_ERROR.GETVALUE_ARGUMENT, "[GetOthersData]");
			return "false";
		}
		
		var parameters = {
			url : API.url.othersData,
			data : API.getJsonParameters("", API.dataModel) + "&" + API.getJsonParameters("", API.learningData) + "&dataName=" + dataName
		};
		var returnValue = API.ajax(parameters);
		if ("true" == returnValue.result) {
			API.setError(API_ERROR.NO_ERROR, "[GetOthersData]", parameters.data.split("&").join("\n"));
			return returnValue.data;
		} else {
			API.setError(API_ERROR.GETVALUE_FAILURE, "[GetOthersData]", parameters.data.split("&").join("\n"));
			return null;
		}
	},
	GetLastError : function() {
		API.doDebug("[GetLastError] " + API.error.code);
		return API.error.code;
		
	},
	GetErrorString : function(errorCode) {
		API.doDebug("[GetErrorString] " + API.error.string);
		return API.error.string;
		
	},
	GetDiagnostic : function(errorCode) {
		API.doDebug("[GetDiagnostic] " + API.error.string);
		return API.error.string;
		
	},
	restore : function() {
		
		if(API.url.restore == ''){
			return "true";
		}
		
		var parameters = {
			url : API.url.restore,
			data : API.getCookie()
		};
		if (parameters.data.length > 0) {
			var returnValue = API.ajax(parameters);
			if ("true" == returnValue.result) {
				if ("1" == returnValue.restore) {
					jQuery.alert({
						message : I18N["Aos:Learing:RestoreLearningData"] // 저장되지 않은 학습데이타를 복원하였습니다
					});
					API.delCookie();
				}
			} else {
				API.delCookie();
			}
		}
	},
	setError : function(error, state, message) {
		API.error = error;
		if (API.debug.on && typeof API.debug.callback === "function") {
			API.debug.callback.call(this, {
				"state" : state,
				"success" : API.error == API_ERROR.NO_ERROR,
				"message" : state + " [" + API.error.code + "] - " + API.error.string + (typeof message === "string" ? message : "")
			});
		}
	},
	doDebug : function(message) {
		if (API.debug.on && typeof API.debug.callback === "function") {
			API.debug.callback.call(this, {
				"message" : message
			});
		}
	},
	setDataModel : function(key, value) {
		if (API.dataModel == null) {
			API.dataModel = {};
		}
		API.dataModel[key] = value;
	},
	getDataModel : function(key) {
		if (API.dataModel == null) {
			API.dataModel = {};
		}
		if (typeof API.dataModel[key] === "undefined") {
			return "";
		} else {
			return API.dataModel[key];
		}
	},
	getJsonParameters : function(prefix, json) {
		var buffer = [];
		for(var property in json) {
			switch (typeof json[property]) {
			case "object" :
				var value = API.getJsonParameters(prefix + property + ".", json[property]);
				if (value.length > 0 ) {
					buffer.push(value);
				}
				break;
			case "string" :
			case "number" :
			case "boolean" :
				buffer.push(prefix + property + "=" + json[property]);
				break;
			}
		}
		return buffer.join("&");
	},
	ajax : function(param) {
		var result = {};
		jQuery.ajax({
			url : param.url,
			data : param.data,
			type : "post",
			dataType : "json",
			cache : false,
			async : false,
			contentType : "application/x-www-form-urlencoded",
			error : function(req, status, error) {
				if (API.debug.on) {
					API.doDebug("request [" + req.statusText + "] : " + error);
				}
				API.setCookie();
				result["result"] = false;
			},
			success : 
				function(data, textStatus, jqXHR) {
					result = data;
				}
		});
		return result;
	},
	quitAlert : function() {
		API.status = "exception";
		jQuery("iframe").hide();
		jQuery.alert({
			message : API.error.string,
			button1 : {
				callback : function() {
					if (typeof API.exception.callback === "function") {
						//API.exception.callback.apply(this);
					}
				}
			}
		});
	},
	isInitialized : function() {
		return API.status == "initialized" ? true : false;
	},
    getCookie : function() {
        var cookies = document.cookie.split(";");
        for (var i = 0; i < cookies.length; i++) {
            var cook = cookies[i].split("=");
            if (cook.length == 2) {
                cook[0] = cook[0].trim();
                cook[1] = cook[1].trim();
                if (cook[0] == "learningData") {
                    return unescape(cook[1]);
                }
            }
        }
        return "";
    },
    setCookie : function() {
    	var value = API.getJsonParameters("", API.dataModel) + "&" + API.getJsonParameters("", API.learningData);
    	var date = new Date((new Date()).getTime() + 24 * 60 * 60 * 1000); // 1일
        var cookie = ("learningData=" + escape(value));
        cookie += ("; path=/; expires=" + date.toGMTString());
        document.cookie = cookie;
        API.doDebug("[setCookie] " + cookie);
    },
    delCookie : function() {
    	var cookie = "learningData=; path=/; expires=;";
    	document.cookie = cookie;
    	API.doDebug("[delCookie] " + cookie);
    },
    // xinics 또는 scorm 1.2
    LMSInitialize : function(param) {
    	if (API.status === "initialized") {
    		return "true";
    	} else {
    		return API.Initialize(param);
    	}
    },
    LMSFinish : function(param) {
		if (API.status === "terminated") {
			return "true";
		} else {
			return API.Terminate(param);
		}
    },
    LMSGetValue : function(param) {
    	return API.GetValue(param);
    },
    LMSSetValue : function(param1, param2) {
    	return API.SetValue(param1, param2);
    },
    LMSCommit : function(param) {
    	return API.Commit(param);
    },
    LMSGetLastError : function() {
    	return API.GetLastError();
    },
    LMSGetErrorString : function(param) {
    	return API.GetErrorString(param);
    },
    LMSGetDiagnostic : function(param) {
    	return API.GetDiagnostic(param);
    }
};
