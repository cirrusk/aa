var _fileinfo_ = {
	version : "1.0.0"
};

(function() {
	var QS = require("querystring");
	var FS = require("fs");
	var URL = require("url");
	var CRYPTO = require("crypto");
	
	var UT = {
		log : function(data) {
			console.log(this.formatDate(new Date(), "yyyy-MM-dd hh:mm:ss.sss") + " - " + data);
		},
		formatDate : function(date, format) {
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
		stringToDateStartDtime : function(s) {
			var d = new Date(Date.parse(s));
			d.setHours(0);
			d.setMinutes(0);
			d.setSeconds(0);
			return d;
		},
		stringToDateEndDtime : function(s) {
			var d = new Date(Date.parse(s));
			d.setHours(23);
			d.setMinutes(59);
			d.setSeconds(59);
			return d;
		},
		addDate : function(d, add) {
			d.setDate(d.getDate() + add);
			return d;
		},
		getYesterday : function() {
			var d = this.addDate(new Date(), -1);
			return this.stringToDateStartDtime(d);
		},
		startsWith : function(s, starts) {
			return (s.match("^" + starts) == starts);
		},
		endsWith : function(s, ends) {
			return (s.match(ends + "$") == ends);
		},
		getParameter : function(req, callback) {
			if (req.method == "GET") {
				req.parameters = URL.parse(req.url, true).query;
				callback();
			} else if (req.method == "POST") {
				var queryData = "";
				req.on("data", function(data){
					queryData += data;
					if (queryData.length > 1e6) {
						queryData = "";
						req.connection.destory();
					}
				});
				req.on("end", function(){
					req.parameters = QS.parse(queryData);
					callback();
				});
			}
		},
		response : {
			json : function(res, error, data, jsonpCallback) {
				if (typeof jsonpCallback === "string") {
					res.writeHead(200, {
						"Content-Type" : "application/javascript"
					});
					if (error) {
						res.end();
					} else {
						res.end(jsonpCallback + "(" + JSON.stringify(data) + ")");
					}
				} else {
					res.writeHead(200, {
						"Content-Type" : "application/json"
					});
					if (error) {
						res.end();
					} else {
						res.end(JSON.stringify(data));
					}
				}
			},
			html : function(res, data) {
				res.writeHead(200, {
					"Content-Type" : "text/html"
				});
				res.end(data);
			},
			404 : function(res) {
				res.writeHead(404);
				res.end();
			}
		},
		listFiles : function(path) {
			return FS.readdirSync(path);
		},
		readFile : function(filename) {
			return FS.readFileSync(filename, "utf-8");
		},
		removeFile : function(filename) {
			return FS.unlink(filename);
		},
		renameFile : function(oldname, newname) {
			return FS.rename(oldname, newname);
		},
		mkdir : function(path) {
			if (FS.existsSync(path) == false) {
				FS.mkdirSync(path);
			}
		},
		encrypt : function(param) {
			var algorithm = param.algorithm || "des-ede3"; // default : 3des-ecb
			var output = param.output || "base64";
			var key = param.key || defaultKey();
			var text = param.text || "";
			
			if (key == "" || text == "") {
				return "";
			}
			
			var cipher = CRYPTO.createCipheriv(algorithm, key, '');
			cipher.setAutoPadding(true);
			var crypted = cipher.update(text, "utf8", output);
			crypted += cipher.final(output);
			
			if ("base64" === output) {
				crypted = crypted.replace(/=/g, "@").replace(/\//g, "!");
			}
			return crypted;
		},
		decrypt : function(param) {
			var algorithm = param.algorithm || "des-ede3"; // default : 3des-ecb
			var output = param.output || "base64";
			var key = param.key || defaultKey();
			var text = param.text || "";
			
			if (key == "" || text == "") {
				return "";
			}
			var decipher = CRYPTO.createDecipheriv(algorithm, key, '');
			decipher.setAutoPadding(true);

			if ("base64" === output) {
				text = text.replace(/@/g, "=").replace(/!/g, "/").replace(/\s/g, "+");
			}
			var derypted = decipher.update(text, output, "utf8");
			derypted += decipher.final("utf8");
			return derypted;
		}
	};
	var defaultKey = function() {
		return UT.decrypt({
			key : "!AOF5-MayThe4CbeWithYou!",
			output : "hex",
			text : "36159a1f5d64321b8811f919b7e2b5ab7ab489bbf849a4b4a5140600cc7421e1" // StringUtil.java에서 사용하는 값과 동일 해야한다.
		});
	};
	
	exports.UT = UT;
}());