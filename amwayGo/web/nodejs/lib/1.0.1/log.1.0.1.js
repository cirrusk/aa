var _fileinfo_ = {
	version : "1.0.1"
};

(function() {
	var UT = require("./utils.1.0.1.js").UT;
	var DAO = require("./dao.1.0.1.js").DAO;
	
	var logPath = UT.decrypt({text : global.config.logPath});
	
	var LOG = {
		save : function(date, logType) {
			UT.log("Saving " + logType + " log");

			var files = UT.listFiles(logPath);
			var logs = [];
			for (var i in files) {
				var filename = files[i]; 
				if (UT.endsWith(filename, ".log") == true && (UT.startsWith(filename, logType + ".admin.log.") == true || UT.startsWith(filename, logType + ".www.log.") == true)) {
					logs.push(filename);
				}
			}
			switch(logType) {
			case "trace":
				for (var i in logs) {
					var filename = logs[i];
					try {
						var data = UT.readFile(logPath + "/" + filename);
						if (data != null) {
							UT.log(filename + " opened");
							data.split("\n").forEach(function(line) {
								// TRACE|endTime|memberId|rolegroupSeq|ip|url|end|executeTime
								line = line.trim();
								if (UT.startsWith(line, "TRACE") && UT.endsWith(line, "milliseconds")) {
									var prop = line.split("|");
									var row = {
										"target" : prop[5], // 공통 - url
										"executeTime" : parseInt(prop[7], 10), // 공통 - 실행시간
										"regDtime" : Date.parse(prop[1]),
										"memberId" : prop[2],
										"rolegroupSeq" : prop[3],
										"ip" : prop[4]
									};
									DAO.traceLog.save(row);
								}
							});
						}
					} catch (e) {
						UT.log(e);
					}
					UT.mkdir(logPath + "/bak/" + logType);
					UT.renameFile(logPath + "/" + filename, logPath + "/bak/" + logType + "/" + filename);
				}
				break;
			case "sql":
				for (var i in logs) {
					var filename = logs[i];
					try {
						var data = UT.readFile(logPath + "/" + filename);
						if (data != null) {
							UT.log(filename + " opened");
							data.split("\n").forEach(function(line) {
								// INFO|sqlType|ThreadId|queryId|parameter|startTime|endTime|executeTime
								line = line.trim();
								
								if (UT.startsWith(line, "INFO") && UT.endsWith(line, "milliseconds")) {
									var prop = line.split("|");
									var row = {
										"target" : prop[3], // 공통 - queryId
										"executeTime" : parseInt(prop[7], 10), // 공통 - 실행시간
										"sqlType" : prop[1],
										"threadId" : prop[2],
										"parameters" : prop[4],
										"startDtime" : Date.parse(prop[5]),
										"endDtime" : Date.parse(prop[6])
									};
									DAO.sqlLog.save(row);
								}
							});
						}
					} catch (e) {
						UT.log(e);
					}
					UT.mkdir(logPath + "/bak/" + logType);
					UT.renameFile(logPath + "/" + filename, logPath + "/bak/" + logType + "/" + filename);
				}
				break;
			}
		}
	};
	exports.LOG = LOG;
}());