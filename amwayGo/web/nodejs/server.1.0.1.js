(function() {
	var UT = require("./lib/1.0.1/utils.1.0.1.js").UT;
	
	if (process.argv.length !== 5) {
		UT.log("Usage : node server.js local[service] master[slave1/slave2] port");
		return;
	}

	// local or service
	var service = process.argv[2];
	// master or slave
	var which = process.argv[3];
	// 서버 포트
	var port = parseInt(process.argv[4], 10);
	
	global.config = require("./lib/server.config." + service + ".json");
	// 서버 이름
	var serverName = UT.decrypt({text : global.config.server.name[which]});
	
	var HTTP = require("http");
	var SYS = require("./lib/1.0.1/sys.1.0.1.js").SYS;
	var LOG = require("./lib/1.0.1/log.1.0.1.js").LOG;
	var WEB = require("./lib/1.0.1/web.1.0.1.js").WEB;
	var DAO = require("./lib/1.0.1/dao.1.0.1.js").DAO;
	var SOC = require("./lib/1.0.1/socket.1.0.1.js").SOC;

	// 서버 생성.
	var server = HTTP.createServer();
	
	// 스케줄러 역할.
	server.listen(port, function(){
		UT.log(serverName + " server running at " + port + " port.");
		
		SYS.saveInfo(serverName);
		setInterval(function() {
			var date = new Date();
			var sec = date.getSeconds();
			var min = date.getMinutes();
			var hour = date.getHours();

			// 저장시점 분리
			if (sec == 0 && min % 1 == 0) { // systemInfo 저장 주기 : 매분 0초 마다.
				SYS.saveStatus(date, serverName);
			}
			if (sec == 10 && min == 0 && hour % 1 == 0) { // trace 로그 저장 주기 : 매시 0분 10 초 마다
				LOG.save(date, "trace");
			}
			if (sec == 20 && min == 1 && hour % 1 == 0) { // sql 로그 저장 주기 : 매시 1분 20 초 마다
				LOG.save(date, "sql");
			}
			
		}, 1000);
	});
	
	if ("master" == which) {
		// 웹서버 시작
		WEB.on(server);
		
		// 채팅 소켓 시작
		SOC.on(server);
	} 

	// server 가 영원히 죽지 않게 한다.
	process.on("uncaughtException", function(error) {
		UT.log("caught exception : " + error.stack);
		DAO.exception.save({
			"regDtime" : (new Date()).getTime(),
			"message" : error.message,
			"stack" : error.stack
		});
	});
}());