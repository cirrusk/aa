var _fileinfo_ = {
	version : "3.2.0"
};
var apiHandle = null;
var findAPITries = 0;
var noAPIFound = "false";
var tryCount = 0;
var pageData = {
	"totalPageCount" : 1,
	"currentPageNo" : 1,
	"relativePath" : "",
	"contentsFrameId" : "contentsFrame"
};
function findAPI( win ) {
   while ( (win.API_1484_11 == null) && (win.parent != null) && (win.parent != win) ) {
      findAPITries++;

      if ( findAPITries > 500 ) {
         alert( "Error finding API -- too deeply nested.");
         return null;
      }
      win = win.parent;
   }
   return win.API_1484_11;
}
function getAPI() {
	var theAPI = findAPI( window );
	if ( (theAPI == null) && (window.opener != null) && (typeof(window.opener) != "undefined") ) {
		theAPI = findAPI( window.opener );
	}
	if (theAPI == null) {
		noAPIFound = "true";
	}
	return theAPI;
}
function getAPIHandle() {
	if (apiHandle == null) {
		if (noAPIFound == "false") {
			apiHandle = getAPI();
		}
	}
	return apiHandle;
}
function retrieveDataValue(name) {
    var api = getAPIHandle();
    if ( api == null ) {
        return "";
    } else {
        var value = api.GetValue( name );
        return api.GetLastError() == "0" ? value : "";
    }
}
function storeDataValue(name, value) {
	var api = getAPIHandle();
	if ( api == null ) {
		return false;
	} else {
		return api.SetValue(name, value) == "true" ? true : false;
	}
}
function isInitialized() {
	var api = getAPIHandle();
	if ( api == null ) {
		return false;
	} else {
		return api.isInitialized();
	}
}
function leftPad(str, size, padStr) {
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
}
function start() {
	if (isInitialized() == false && tryCount < 60) {
		setTimeout("start()", 1000 * 1);
		tryCount++;
		return;
	}
	var startPage = "page_01.html";
	var location = retrieveDataValue("cmi.location");
	if (location != "") {
		startPage = location;
	}
	doGo(startPage);
}
function doGo(src) {
	var currentPageNo = src.substring(5, 7);
	pageData.currentPageNo = parseInt(currentPageNo, 10);
	if (currentPageNo < 1) {
		src = "page_01.html";
		pageData.currentPageNo = 1;
	} else if (currentPageNo > pageData.totalPageCount) {
		src = "page_" + leftPad(String(pageData.totalPageCount), 2, "0") + ".html";
		pageData.currentPageNo = pageData.totalPageCount;
	}
	pageData.relativePath = src;
	document.getElementById(pageData.contentsFrameId).src = src;
}
function doPrev() {
	doGo("page_" + leftPad(String(pageData.currentPageNo - 1), 2, "0") + ".html");
}
function doNext() {
	doGo("page_" + leftPad(String(pageData.currentPageNo + 1), 2, "0") + ".html");
}
function setPage() {
	var totalPageCount = 1;
	var currentPageNo = 1;
	var relativePath = "";
	if (typeof pageData.totalPageCount !== "undefined") {
		totalPageCount = parseInt(pageData.totalPageCount, 10);
	}
	if (typeof pageData.currentPageNo !== "undefined") {
		currentPageNo = parseInt(pageData.currentPageNo, 10);
	}
	if (typeof pageData.relativePath !== "undefined") {
		relativePath = pageData.relativePath;
	}
	var objectivesCount = retrieveDataValue("cmi.objectives._count");
	if (objectivesCount == "") {
		storeDataValue("cmi.objectives._count", totalPageCount);
		for (var i = 0; i < totalPageCount; i++) {
			storeDataValue("cmi.objectives." + i + ".id", i);
			storeDataValue("cmi.objectives." + i + ".completion_status", "incomplete");
		}
		storeDataValue("cmi.progress_measure", "0.0");
	}
	storeDataValue("cmi.objectives." + (currentPageNo - 1) + ".completion_status", "completed");
	storeDataValue("cmi.suspend_data", currentPageNo + "/" + totalPageCount);
	if (relativePath != "") {
		storeDataValue("cmi.location", relativePath);
	}
	var completedCount = 0;
	objectivesCount = retrieveDataValue("cmi.objectives._count");
	var count = parseInt(objectivesCount, 10);
	for (var i = 0; i < count; i++) {
		if (retrieveDataValue("cmi.objectives." + i + ".completion_status") == "completed") {
			completedCount++;
		}
	}
	var progressMeasure = retrieveDataValue("cmi.progress_measure");
	var measure = parseFloat(progressMeasure);
	if (parseFloat(progressMeasure) < (completedCount / count)) {
		storeDataValue("cmi.progress_measure", (completedCount / count));
	}
	if (currentPageNo == 1) {
		var iframe = document.getElementById(pageData.contentsFrameId);
		var el = iframe.contentWindow.document.getElementById("prevButton");
		if (el) {
			el.style.display = "none";
		}
	}
	if (currentPageNo == totalPageCount) {
		var iframe = document.getElementById(pageData.contentsFrameId);
		var el = iframe.contentWindow.document.getElementById("nextButton");
		if (el) {
			el.style.display = "none";
		}
	}
}