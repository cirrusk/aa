var _fileinfo_ = {
	version : "1.0.1"
};

(function() {
	var UT = require("./utils.1.0.1.js").UT;

	var collections = ["systemInfo", "systemStatus", "traceLog", "sqlLog", "socketUser", "chatRoom", "chatMessage", "exception"];
	var DB = require("mongojs").connect(UT.decrypt({text : global.config.db.url}), collections);
	
	var applyCallback = function(callback) {
		if ("function" === typeof callback) {
			callback.apply(this, Array.prototype.slice.call(arguments, 1));
		}
	};
	var DAO = {
		initialize : function() {
			DB.socketUser.remove(); // 접속자
			DB.chatRoom.remove(); // 채팅방 
		},

		exception : { // node server 에 exception 에 대한 기록
			save : function(data) {
				var log = "exception :: ";

				DB.exception.save(data, function(error, savedObject) {
					if (error || !savedObject) {
						UT.log(log + " not saved because of error " + error);
					} else {
						UT.log(log + " saved");
					}
				});
			}
		},

		socketUser : { // 채팅방 정보
			save : function(data, callback) {
				var log = "socketUser :: " + data.user.socketId;
				
				var where = {user : {socketId : data.user.socketId}};
				DB.socketUser.count(where, function(error, count) {
					if (count > 0) {
						DB.socketUser.update(where, data, function(error, savedObject) {
							if (error || !savedObject) {
								UT.log(log + " not saved because of error " + error);
							} else {
								UT.log(log + " updated");
							}
							applyCallback(callback, error, savedObject);
						});
					} else {
						DB.socketUser.save(data, function(error, savedObject) {
							if (error || !savedObject) {
								UT.log(log + " not saved because of error " + error);
							} else {
								UT.log(log + " inserted");
							}
							applyCallback(callback, error, savedObject);
						});
					}
				});
			},
			remove : function(where, callback) {
				var log = "socketUser :: " + JSON.stringify(where);
				
				DB.socketUser.remove(where, function(error) {
					if (error) {
						UT.log(log + " not removed because of error " + error);
					} else {
						UT.log(log + " removed");
					}
					applyCallback(callback, error);
				});
			},
			select : function(where, callback) {
				var log = "socketUser :: " + JSON.stringify(where);
				
				var sort = {date : 1}; // _id asc
				DB.socketUser.find(where).sort(sort, function(error, data) {
					if (error) {
						UT.log(log + " not found because of error " + error);
					} else {
						UT.log(log + " selected");
					}
					applyCallback(callback, error, data);
				});
			}
		},

		chatRoom : { // 채팅방 정보
			save : function(data, callback) {
				var log = "chatRoom :: " + data.room.id;

				var where = {room : {id : data.room.id}};
				DB.chatRoom.count(where, function(error, count) {
					if (count > 0) {
						DB.chatRoom.update(where, data, function(error, savedObject) {
							if (error || !savedObject) {
								UT.log(log + " not saved because of error " + error);
							} else {
								UT.log(log + " updated");
							}
							applyCallback(callback, error, savedObject);
						});
					} else {
						DB.chatRoom.save(data, function(error, savedObject) {
							if (error || !savedObject) {
								UT.log(log + " not saved because of error " + error);
							} else {
								UT.log(log + " inserted");
							}
							applyCallback(callback, error, savedObject);
						});
					}
				});
			},
			remove : function(where, callback) {
				var log = "chatRoom :: " + JSON.stringify(where);
				
				DB.chatRoom.remove(where, function(error) {
					if (error) {
						UT.log(log + " not removed because of error " + error);
					} else {
						UT.log(log + " removed");
					}
					applyCallback(callback, error);
				});
			},
			select : function(where, callback) {
				var log = "chatRoom :: " + JSON.stringify(where);
				
				var sort = {date : 1}; // _id asc
				DB.chatRoom.find(where).sort(sort, function(error, data) {
					if (error) {
						UT.log(log + " not found because of error " + error);
					} else {
						UT.log(log + " selected");
					}
					applyCallback(callback, error, data);
				});
			}
		},

		chatMessage : { // 채팅 메시지 정보
			save : function(data, callback) {
				var log = "chatMessage :: " + data.roomId;

				DB.chatMessage.save(data, function(error, savedObject) {
					if (error || !savedObject) {
						UT.log(log + " not saved because of error " + error);
					} else {
						UT.log(log + " inserted");
					}
					applyCallback(callback, error, savedObject);
				});
			},
			select : function(where, sort, skip, limit, callback) {
				var log = "chatMessage :: " + JSON.stringify(where);
				
				DB.chatMessage.find(where).sort(sort).skip(skip).limit(limit, function(error, data) {
					if (error) {
						UT.log(log + " not found because of error " + error);
					} else {
						UT.log(log + " selected");
					}
					applyCallback(callback, error, data);
				});
			}
		},

		systemInfo : { // system 정보
			save : function(data, callback) {
				var log = "systemInfo :: " + data.serverName;

				var where = {serverName : data.serverName};
				DB.systemInfo.count(where, function(error, count) {

					if (count > 0) {
						DB.systemInfo.update(where, data, function(error, savedObject) {
							if (error || !savedObject) {
								UT.log(log + " not saved because of error " + error);
							} else {
								UT.log(log + " updated");
							}
							applyCallback(callback, error, savedObject);
						});
					} else {
						DB.systemInfo.save(data, function(error, savedObject) {
							if (error || !savedObject) {
								UT.log(log + " not saved because of error " + error);
							} else {
								UT.log(log + " inserted");
							}
							applyCallback(callback, error, savedObject);
						});
					}
				});
			},
			select : function(condition, callback) {
				var log = "systemInfo :: ";
				
				var sort = {_id : 1}; // _id asc
				var where = {};
				if ("string" === typeof condition.srchServerName) {
					where.serverName = condition.srchServerName; 
				}
				log = log + JSON.stringify(where);
				
				DB.systemInfo.find(where).sort(sort, function(error, data) {
					if (error) {
						UT.log(log + " not found because of error " + error);
					} else {
						UT.log(log + " selected");
					}
					applyCallback(callback, error, data);
				});
			}
		},

		systemStatus : { // 시스템 상태
			save : function(data, callback) {
				var log = "systemStatus :: " + data.serverName;
				
				DB.systemStatus.save(data, function(error, savedObject) {
					if (error || !savedObject) {
						UT.log(log + " not saved because of error " + error);
					} else {
						UT.log(log + " inserted");
					}
					applyCallback(callback, error, savedObject);
				});
			},
			selectLately : function(condition, callback) {
				var log = "systemStatus :: ";
				
				var sort = {regDtime : -1};
				var where = {};
				if ("string" === typeof condition.srchServerName) {
					where.serverName = condition.srchServerName; 
				}
				log = log + JSON.stringify(where);

				var limit = 1;
				if ("string" === typeof condition.srchLimit) {
					limit = parseInt(condition.srchLimit, 10); 
				}

				DB.systemStatus.find(where).sort(sort).limit(limit, function(error, data) {
					if (error) {
						UT.log(log + " not found because of error " + error);
					} else {
						UT.log(log + " selected");
					}
					applyCallback(callback, error, data);
				});
			}
		},

		traceLog : { // trace 로그 
			save : function(data, callback) {
				var log = "traceLog :: ";
				
				DB.traceLog.save(data, function(error, savedObject) {
					if (error || !savedObject) {
						UT.log(log + " not saved because of error " + error);
					} else {
						UT.log(log + " inserted");
					}
					applyCallback(callback, error, savedObject);
				});
			},
			select : function(condition, callback) {
				var log = "traceLog :: ";
				var where = {};
				if ("string" === typeof condition.srchStartDate || "string" === typeof condition.srchEndDate) {
					where.regDtime = {};
					if ("string" === typeof condition.srchStartDate) {
						where.regDtime["$gte"] = UT.stringToDateStartDtime(condition.srchStartDate).getTime();
					}
					if ("string" === typeof condition.srchEndDate) {
						where.regDtime["$lte"] = UT.stringToDateEndDtime(condition.srchEndDate).getTime();
					}
				}
				log = log + JSON.stringify(where);

				DB.traceLog.find(where, function(error, data) {
					if (error) {
						UT.log(log + " not found because of error " + error);
					} else {
						UT.log(log + " selected");
					}
					applyCallback(callback, error, data);
				});
			}
		},

		sqlLog : { // sql 로그
			save : function(data, callback) {
				var log = "sqlLog :: ";

				DB.sqlLog.save(data, function(error, savedObject) {
					if (error || !savedObject) {
						UT.log(log + " not saved because of error " + error);
					} else {
						UT.log(log + " inserted");
					}
					applyCallback(callback, error, savedObject);
				});
			},
			select : function(condition, callback) {
				var log = "sqlLog :: ";
				var where = {};
				if ("string" === typeof condition.srchStartDate || "string" === typeof condition.srchEndDate) {
					where.endDtime = {};
					if ("string" === typeof condition.srchStartDate) {
						where.endDtime["$gte"] = UT.stringToDateStartDtime(condition.srchStartDate).getTime();
					}
					if ("string" === typeof condition.srchEndDate) {
						where.endDtime["$lte"] = UT.stringToDateEndDtime(condition.srchEndDate).getTime();
					}
				}
				log = log + JSON.stringify(where);

				DB.sqlLog.find(where, function(error, data) {
					if (error) {
						UT.log(log + " not found because of error " + error);
					} else {
						UT.log(log + " selected");
					}
					applyCallback(callback, error, data);
				});
			}
		}
	};
	exports.DAO = DAO;
}());