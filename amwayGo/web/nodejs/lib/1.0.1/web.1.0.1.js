var _fileinfo_ = {
	version : "1.0.1"
};

(function() {

	var URL = require("url");
	var FS = require("fs");
	var UT = require("./utils.1.0.1.js").UT;
	var DAO = require("./dao.1.0.1.js").DAO;

	var HTML_PATH = __dirname + "/../.."; // __dirname : 현재 스크립트 파일의 절대경로
	
	var WEB = {
		on : function(server) {
			server.on("request", function(request, response) {
				try {
					if (checkAccessIp(request, response) == false) {
						return;
					}
					var pathname = URL.parse(request.url).pathname;
					switch(pathname) {
					case "/":
						UT.response.html(response, getHtml("server is alive."));
						break;
					case "/encoding":
						UT.getParameter(request, function() {
							var param = {
								algorithm : request.parameters.algorithm,
								key : request.parameters.key,
								text : request.parameters.text,
								output : request.parameters.output
							};
							var type = request.parameters.type; 
							
							var html = [];
							try {
								if ("decoding" == type) {
									html.push(UT.decrypt(param));
								} else {
									html.push(UT.encrypt(param));
								}
							} catch (e) {
								html.push(e.message);
							}
							UT.response.html(response, getHtml(html.join("")));
						});
						break;
					case "/system/info/list":
						UT.getParameter(request, function() {
							var jsonpCallback = request.parameters.callback; 
							
							DAO.systemInfo.select(request.parameters, function(error, data) {
								UT.response.json(response, error, data, jsonpCallback);
							});
						});
						break;
					case "/system/status/lately":
						UT.getParameter(request, function() {
							var jsonpCallback = request.parameters.callback; 
							
							DAO.systemStatus.selectLately(request.parameters, function(error, data) {
								UT.response.json(response, error, data, jsonpCallback);
							});
						});
						break;
					case "/log/list":
						UT.getParameter(request, function() {
							var jsonpCallback = request.parameters.callback; 
							var srchLogType = request.parameters.srchLogType;
							
							switch (srchLogType) {
							case "trace":
								DAO.traceLog.select(request.parameters, function(error, data) {
									UT.response.json(response, error, data, jsonpCallback);
								});
								break;
							case "sql":
								DAO.sqlLog.select(request.parameters, function(error, data) {
									UT.response.json(response, error, data, jsonpCallback);
								});
								break;
							}
						});
						break;
					default:
						if (UT.startsWith(pathname, "/html")) {
							if (typeof cacheFile[pathname] === "undefined") {
								FS.readFile(HTML_PATH + pathname, "utf-8", function(error, data){
									if (error) {
										UT.log("not found " + pathname);
										UT.response["404"](response);
									} else {
										UT.response.html(response, data);
										saveCacheFile(pathname, data);
									}
								});
							} else {
								UT.response.html(response, cacheFile[pathname]);
							}
						} else {
							UT.log("is not start with html " + pathname);
							UT.response["404"](response);
						}
						break;
					}
				} catch (e) {
					UT.log(e);
				}
			});
		}
	};
	
	var checkAccessIp = function(request, response) {
		var remoteAddr = request.connection.remoteAddress;
		
		var denyIps = []; // 설정안하면 모두 allow
		//var allowIps = ["127.0.0.1", "211.56.10.*"]; // 설정안하면 모두 allow
		var allowIps = []; // 설정안하면 모두 allow
		
		// deny ip 검사
		var deny = false;
		if (denyIps.length > 0) {
			for (var index = 0; index < denyIps.length; index++) {
				var pattern = new RegExp(denyIps[index].replace(/\*/g, "\\d{1,3}"));
				if (pattern.test(remoteAddr)) {
					deny = true;
					break;
				}
			}
		}
		if (deny) {
			UT.response.html(response, getHtml(remoteAddr + " - access denied."));
			return false;
		}
		
		// allow ip 검사
		var allow = false;
		if (allowIps.length > 0) {
			for (var index = 0; index < allowIps.length; index++) {
				var pattern = new RegExp(allowIps[index].replace(/\*/g, "\\d{1,3}"));
				if (pattern.test(remoteAddr)) {
					allow = true;
					break;
				}
			}
		} else {
			allow = true;
		}
		if (allow) {
			return true;
		} else {
			UT.response.html(response, getHtml(remoteAddr + " - access denied."));
			return false;
		}
	};
	
	var getHtml = function(body) {
		var html = [];
		html.push("<html><head>");
		html.push("<meta http-equiv='Content-type' content='text/html; charset=utf-8' />");
		html.push("</head>");
		html.push("<body>");
		html.push(body);
		html.push("</body>");
		html.push("</html>");
		return html.join("");
	};
	
	var cacheFile = {};
	var saveCacheFile = function(name, data) {
		var len = 0;
		var first = null;
		for (var p in cacheFile) {
			if (first == null) {
				first = p;
			}
			len++;
		}
		if (len >= 30) { // cache size 30
			delete cacheFile[first];
		}
		cacheFile[name] = data;
	};
	
	exports.WEB = WEB;
}());