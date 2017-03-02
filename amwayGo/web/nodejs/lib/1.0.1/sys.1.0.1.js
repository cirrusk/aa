var _fileinfo_ = {
	version : "1.0.1"
};

(function() {
	var UT = require("./utils.1.0.1.js").UT;
	var OS = require('os'); 
	var DAO = require("./dao.1.0.1.js").DAO;
	
	var cpusInfo = function() {
		var cpus = [];
		OS.cpus().forEach(function(cpu, index) {
			var t = cpu.times;
			cpus[index] = {
				total: t.user + t.nice + t.sys + t.irq + t.idle,
				idle: t.idle    
			};  
		});
		return cpus;
	};
	var cpuInfo = function() {
		var total = 0;
		var idle = 0;
		cpusInfo().forEach(function(cpu) {
			total += cpu.total;
			idle += cpu.idle;
		});
		return {
			total: total,
			idle: idle
		};
	};
	var SYS = {
		cpusUsage : function(callback) {
			var begin = cpusInfo();
			setTimeout(function() {
				var cpus = cpusInfo().map(function(cpu, index) {
					var cpuBegin = begin[index];
					var perc = (cpu.idle - cpuBegin.idle) / (cpu.total - cpuBegin.total);
					return 1 - perc;
				});
				callback(cpus);
			}, 1000);
		},
		status : function(callback) {
			var begin = cpuInfo();
			setTimeout(function() {
				var end = cpuInfo();
				var cpuRate = (end.idle - begin.idle) / (end.total - begin.total);
				var memRate = (OS.totalmem() - OS.freemem()) / OS.totalmem();
				
				callback({
					cpuUsage : Math.round((1 - cpuRate) * 100),
					memoryUsage : Math.round(memRate * 100)
				});  
			}, 1000);
		},
		saveInfo : function(serverName) {
			UT.log("Saving system info");
			DAO.systemInfo.save({
				"serverName" : serverName,
				"totalMemory" : OS.totalmem()
			});
		},
		saveStatus : function(date, serverName) {
			UT.log("Saving system status");
			this.status(function(data) {
				data.serverName = serverName;
				data.regDtime = date.getTime();
				DAO.systemStatus.save(data);
			});
		}
	};
	exports.SYS = SYS;
}());