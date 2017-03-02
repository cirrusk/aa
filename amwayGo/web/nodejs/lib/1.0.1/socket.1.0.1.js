var _fileinfo_ = {
	version : "1.0.1"
};

(function() {
	var SOCKET = require("socket.io");
	var UT = require("./utils.1.0.1.js").UT;
	var DAO = require("./dao.1.0.1.js").DAO;

	var ERRORS = {
		INVALID_PARAMETER   : {code : "1000", message : "invalid parameter"},
		DATABASE_ERROR      : {code : "1100", message : "database error", detail : ""},
		ROOM_CREATE_FAILURE : {code : "1200", message : "room create failure"},
		ROOM_JOIN_FAILURE   : {code : "1210", message : "room join failure"},
		ROOM_LEAVE_FAILURE  : {code : "1220", message : "room leave failure"},
		ROOM_EMPTY          : {code : "1230", message : "room is empty"},
		ROOM_FULL           : {code : "1240", message : "room is full"},
		ROOM_NOT_JOINED     : {code : "1250", message : "not joined room"},
		DISCONNECTED_USER   : {code : "1300", message : "disconnected target user"}
	};
	var SOC = {
		print : function(event, socket) {
			var text = [];
			text.push("SOC");
			text.push(event);
			var args = Array.prototype.slice.call(arguments, 2);
			for (var arg in args) {
				text.push(args[arg]);
			}
			text.push(typeof socket["_user_"] === "object" ? socket["_user_"].id : "socket user undefined");
			UT.log(text.join(" :: "));
		},
		evaluateParam : function(param) { // 모바일에서 json 형태의 스트링으로 전송이 되는 경우 처리.
			if ("string" === typeof param) { 
				try {
					var json = JSON.parse(param);
					return "object" === typeof json ? json : param; 
				} catch (e) {
					return param;
				}
			} else {
				return param;
			}
		},
		
		on : function(server) {
			var _this = this;

			DAO.initialize();

			var io = SOCKET.listen(server);
			io.configure(function() {
				io.set("log level", 1);
			});

			io.sockets.on("connection", function(socket) {
				_this.print("connection", socket, true);

				// client로 부터 [disconnect] 수신
				socket.on("disconnect", function() {
					var event = "disconnect";
					var data = {
						user : socket["_user_"],
						date : new Date().getTime()
					};

					// 접속중이었던 채팅방 목록
					var roomIds = [];
					for (var roomId in io.sockets.manager.roomClients[socket.id]) {
						if (roomId != "" && UT.startsWith(roomId, "/")) {
							roomIds.push(roomId.substring(1));
						}
					}
					for (var i in roomIds) {
						io.sockets.sockets[socket.id].leave(roomIds[i]); // 채팅방 나가기.
						if ("undefined" === typeof io.sockets.manager.rooms["/" + roomIds[i]]) { // 채팅방에 접속자가 없음
							DAO.chatRoom.remove({"room.roomId" : roomIds[i]}); // db에서 채팅방 정보 삭제
						}
					}

					DAO.socketUser.remove({"user.socketId" : socket.id}); // db에서 user정보 삭제
					
					socket.broadcast.emit(event, data); // 다른 client에게로 [disconnect] 송신

					_this.print(event, socket, true);
				});

				// client로 부터 [접속자정보] 수신
				socket.on("hello", function(user) {
					var event = "hello";

					user = _this.evaluateParam(user);

					var data = {
						user : user,
						date : new Date().getTime()
					};
					if ("object" !== typeof user) {
						socket.emit(event, data, false, ERRORS.INVALID_PARAMETER); // 요청자에게 에러 송신
						_this.print(event, socket, false, ERRORS.INVALID_PARAMETER);
						return;
					}

					user.socketId = socket.id; // user 에 socketId 추가
					socket["_user_"] = user; // socket object에 user정보 저장.

					socket.broadcast.emit(event, data); // 다른 client에게로 [접속자정보] 송신
					_this.print(event, socket, true);

					DAO.socketUser.save(data); // db에 user정보 저장
				});

				// client로 부터 [users] 수신 - 접속자 목록(검색)
				socket.on("users", function(condition) {
					var event = "users";

					condition = _this.evaluateParam(condition);

					if ("object" !== typeof condition) {
						socket.emit(event, [], false, ERRORS.INVALID_PARAMETER); // 요청자에게 에러 송신
						_this.print(event, socket, false, ERRORS.INVALID_PARAMETER);
						return;
					}
					DAO.socketUser.select(condition, function(error, selectData) {
						if (error) {
							var e = ERRORS.DATABASE_ERROR;
							e.detail = error.message;
							socket.emit(event, [], false, e); // 요청자에게 에러 송신
							_this.print(event, socket, false, e);
						} else {
							socket.emit(event, selectData, true); // 요청자에게 접속자 목록 송신
							_this.print(event, socket, true);
						}
					});
				});

				// client로 부터 [rooms] 수신 - 채팅방 목록
				socket.on("rooms", function() {
					var event = "rooms";

					DAO.chatRoom.select({}, function(error, selectData) {
						if (error) {
							var e = ERRORS.DATABASE_ERROR;
							e.detail = error.message;
							socket.emit(event, [], false, e); // 요청자에게 에러 송신
							_this.print(event, socket, false, e);
						} else {
							for (var index in selectData) {
								var room = selectData[index].room;
								room.currentUser = io.sockets.clients(room.roomId).length; // 현재 채팅방 접속자 수. 
							}
							socket.emit(event, selectData, true); // 요청자에게 채팅방 목록 송신
							_this.print(event, socket, true);
						}
					});
				});

				// client로 부터 [room-join] 수신 - 채팅방 입장
				socket.on("room-join", function(room) {
					var event = "room-join";
					
					var data = {
						user : socket["_user_"],
						date : new Date().getTime()
					};

					room = _this.evaluateParam(room);

					if ("object" !== typeof room) {
						socket.emit(event, data, false, ERRORS.INVALID_PARAMETER); // 요청자에게 에러 송신
						_this.print(event, socket, false, ERRORS.INVALID_PARAMETER);
						return;
					}
					data.room = room;
					if ("string" !== typeof data.room.roomId || data.room.roomId.length == 0) { // roomId 가 없다
						socket.emit(event, data, false, ERRORS.INVALID_PARAMETER); // 요청자에게 실패 통보
						_this.print(event, socket, false, ERRORS.INVALID_PARAMETER);
						return;
					}
					
					var roomId = data.room.roomId;
					var clients = io.sockets.clients(roomId); // 현재 접속자.
					
					if (clients.length == 0) { // 첫번째 입장
						io.sockets.sockets[socket.id].join(roomId); // 채팅방에 생성
						
						var saveError = false;
						if (true == io.sockets.manager.roomClients[socket.id]["/" + roomId]) { // 입장(생성) 성공
							io.sockets.manager.rooms["/" + roomId]["_maxUserCount_"] = typeof data.room.maxUser === "number" ? data.room.maxUser : -1; 
							DAO.chatRoom.save(data, function(error) { // db에 채팅방 정보 저장
								if (error) {
									var e = ERRORS.DATABASE_ERROR;
									e.detail = error.message;
									socket.emit(event, data, false, e); // 요청자에게 생성 실패 통보
									_this.print(event, socket, false, e, roomId);
									saveError = true;
								}
							});
						}
						if (saveError == true) {
							return;
						}
					} else {
						var maxUserCount = io.sockets.manager.rooms["/" + roomId]["_maxUserCount_"];
						if (typeof maxUserCount === "number" && maxUserCount > 0 && maxUserCount <= clients.length) { // 최대 인원 초과
							socket.emit(event, data, false, ERRORS.ROOM_FULL); // 요청자에게 실패 통보
							_this.print(event, socket, false, ERRORS.ROOM_FULL);
							return;
						}
						io.sockets.sockets[socket.id].join(roomId); // 채팅방에 입장
					}

					if (true == io.sockets.manager.roomClients[socket.id]["/" + roomId]) { // 입장 성공
						var saveData = {
							event : event,
							roomId : data.room.roomId,
							user : data.user,
							date : data.date
						};
						DAO.chatMessage.save(saveData, function(error) {
							if (error) {
								var e = ERRORS.DATABASE_ERROR;
								e.detail = error.message;
								socket.emit(event, data, false); // 요청자에게 입장 실패 통보
								_this.print(event, socket, false, roomId);
							} else {
								socket.broadcast.to(roomId).emit(event, data); // 채팅방의 다른 접속자들에게 입장 성공 통보.
								socket.emit(event, data, true); // 요청자에게 성공 통보
								_this.print(event, socket, true, roomId);
							}
						});
						
					} else {
						socket.emit(event, data, false, ERRORS.ROOM_JOIN_FAILURE); // 요청자에게 실패 통보
						_this.print(event, socket, false, ERRORS.ROOM_JOIN_FAILURE, roomId);
						return;
					}
				});
				
				// client로 부터 [room-leave] 수신 - 채팅방 나가기
				socket.on("room-leave", function(roomId) {
					var event = "room-leave";
					var data = {
						roomId : roomId,
						user : socket["_user_"],
						date : new Date().getTime()
					};

					// roomId 가 없다
					if ("string" !== typeof roomId || roomId.length == 0) {
						socket.emit(event, data, false, ERRORS.INVALID_PARAMETER); // 요청자에게 실패 통보
						_this.print(event, socket, false, ERRORS.INVALID_PARAMETER);
						return;
					}

					io.sockets.sockets[socket.id].leave(roomId); // 채팅방 나가기.

					if (true == io.sockets.manager.roomClients[socket.id]["/" + roomId]) {
						socket.emit(event, data, false, ERRORS.ROOM_LEAVE_FAILURE); // 요청자에게 나가기 실패 송신
						_this.print(event, socket, false, ERRORS.ROOM_LEAVE_FAILURE, roomId);
						return;
					} else {
						if ("undefined" === typeof io.sockets.manager.rooms["/" + roomId]) { // 채팅방에 접속자가 없음
							DAO.chatRoom.remove({"room.roomId" : roomId}); // db에서 채팅방 정보 삭제
						}
						var saveData = {
							event : event,
							roomId : data.roomId,
							user : data.user,
							date : data.date
						};
						DAO.chatMessage.save(saveData, function(error) {
							if (error) {
								_this.print(event, socket, false, roomId);
								var e = ERRORS.DATABASE_ERROR;
								e.detail = error.message;
								socket.emit(event, data, false, e); // 요청자에게 에러 송신
								_this.print(event, socket, false, e, roomId);
								
							} else {
								socket.broadcast.to(roomId).emit(event, data); // 채팅방의 다른 접속자들에게 나가기 성공 송신
								socket.emit(event, data, true); // 요청자에게 나가기 성공 송신
								_this.print(event, socket, true, roomId);
							}
						});
					}
				});

				// client로 부터 [room-users] 수신 - 채팅방 접속자 목록
				socket.on("room-users", function(roomId) {
					var event = "room-users";
					var data = {
						roomId : roomId,
						users : []
					};

					// roomId 가 없다
					if ("string" !== typeof roomId || roomId.length == 0) {
						socket.emit(event, data, false, ERRORS.INVALID_PARAMETER); // 요청자에게 실패 통보
						_this.print(event, socket, false, ERRORS.INVALID_PARAMETER);
						return;
					}

					var clients = io.sockets.clients(roomId); // 채팅방의 접속자
					for (var i in clients) {
						data.users.push(clients[i]["_user_"]);
					}
					socket.emit(event, data, true); // 요청자에게 채팅방 접속자 목록 송신
					_this.print(event, socket, true, roomId);
				});

				// client로 부터 [room-messages] 수신 - 채팅방 메시지 목록
				socket.on("room-messages", function(roomId, condition, orderby, limit, page) {
					var event = "room-messages";

					// roomId 가 없다
					if ("string" !== typeof roomId || roomId.length == 0) {
						socket.emit(event, {}, false, ERRORS.INVALID_PARAMETER); // 요청자에게 실패 통보
						_this.print(event, socket, false, ERRORS.INVALID_PARAMETER, roomId, condition);
						return;
					}
					var where = {
						roomId : roomId
					};
					if (typeof condition === "object") {
						for (var p in condition) {
							where[p] = condition[p];
						}
					}
					
					var sort = {date : parseInt(orderby, 10)}; // _id asc
					var skip = limit * (page - 1);
					DAO.chatMessage.select(where, sort, parseInt(skip, 10), parseInt(limit, 10), function(error, selectData) {
						if (error) {
							var e = ERRORS.DATABASE_ERROR;
							e.detail = error.message;
							socket.emit(event, [], false, e); // 요청자에게 에러 송신
							_this.print(event, socket, false, e);
						} else {
							socket.emit(event, selectData, true); // 요청자에게 메시지 목록 송신
							_this.print(event, socket, true);
						}
					});
				});
				
				// client로 부터 [room-send] 수신
				// msg = {"roomId" : "xxx", "message" : "yyy"}
				socket.on("room-send", function(msg) {
					var event = "room-send";

					msg = _this.evaluateParam(msg);

					var data = {
						user : socket["_user_"],
						date : new Date().getTime()
					};
					if ("object" !== typeof msg || "string" !== typeof msg.roomId || msg.roomId.length == 0 || "undefined" === typeof msg.message) {
						// msg 형식이 정확하지 않으면 return
						socket.emit(event, data, false, ERRORS.INVALID_PARAMETER); // 요청자에게 에러 송신
						_this.print(event, socket, false, ERRORS.INVALID_PARAMETER);
						return;
					}
					var roomId = msg.roomId;
					data.roomId = msg.roomId;
					data.message = msg.message;

					// 요청자가 room에 접속이 되어 있지 않음.
					if (true !== io.sockets.manager.roomClients[socket.id]["/" + roomId]) {
						socket.emit(event, data, false, ERRORS.ROOM_NOT_JOINED); // 요청자에게 전송 실패 통보
						_this.print(event, socket, false, ERRORS.ROOM_NOT_JOINED);
						return;
					}

					var saveData = {
						event : event,
						roomId : data.roomId,
						user : data.user,
						message : data.message,
						date : data.date	
					};
					DAO.chatMessage.save(saveData, function(error) {
						if (error) {
							var e = ERRORS.DATABASE_ERROR;
							e.detail = error.message;
							socket.emit(event, data, false, e); // 요청자에게 전송 실패 통보
							_this.print(event, socket, false, e, roomId);
						} else {
							socket.broadcast.to(roomId).emit(event, data); // 다른 client에게로 message 송신
							socket.emit(event, data, true); // 요청자에게 message 송신
							_this.print(event, socket, true, roomId);
						}
					});
				});

				// client로 부터 [one-send] 수신 - 귓속말(1:1) 메시지
				// msg = {"socketId" : "xxx", "message" : "yyy"}
				socket.on("one-send", function(msg) {
					var event = "one-send";

					msg = _this.evaluateParam(msg);

					var data = {
						roomId : "_one_",
						user : socket["_user_"],
						date : new Date().getTime()
					};
					if ("object" !== typeof msg || "string" !== typeof msg.socketId || "undefined" === typeof msg.message) {
						// msg 형식이 정확하지 않으면 return
						socket.emit(event, data, false, ERRORS.INVALID_PARAMETER); // 요청자에게 에러 송신
						_this.print(event, socket, false, ERRORS.INVALID_PARAMETER);
						return;
					}
					if ("object" === typeof io.sockets.sockets[msg.socketId]) {
						data.toUser = io.sockets.sockets[msg.socketId]["_user_"];
					}
					if ("object" !== typeof data.toUser){ // 대상이 접속중이 아니면 return
						socket.emit(event, data, false, ERRORS.DISCONNECTED_USER); // 요청자에게 에러 송신
						_this.print(event, socket, false, ERRORS.DISCONNECTED_USER);
						return;
					}
					data.message = msg.message;

					var saveData = {
						event : event,
						roomId : data.roomId,
						user : data.user,
						toUser : data.toUser,
						message : data.message,
						date : data.date	
					};
					DAO.chatMessage.save(saveData, function(error) {
						if (error) {
							var e = ERRORS.DATABASE_ERROR;
							e.detail = error.message;
							socket.emit(event, data, false, e); // 요청자에게 message 실패 송신
							_this.print(event, socket, false, e);
						} else {
							io.sockets.socket(msg.socketId).emit(event, data); // 대상 client에게로 message 송신
							socket.emit(event, data, true); // 요청자에게 message 송신
							_this.print(event, socket, true);
						}
					});
				});

				// client로 부터 [all-send] 수신 - 전체 메시지
				socket.on("all-send", function(msg) {
					var event = "all-send";

					msg = _this.evaluateParam(msg);
					
					var data = {
						roomId : "_all_",
						user : socket["_user_"],
						date : new Date().getTime()
					};
					if ("object" !== typeof msg || "undefined" === typeof msg.message) {
						// msg 형식이 정확하지 않으면 return
						socket.emit(event, data, false, ERRORS.INVALID_PARAMETER); // 요청자에게 에러 송신
						_this.print(event, socket, false, ERRORS.INVALID_PARAMETER);
						return;
					}
					data.message = msg.message;

					var saveData = {
						event : event,
						roomId : data.roomId,
						user : data.user,
						message : data.message,
						date : data.date	
					};
					DAO.chatMessage.save(saveData, function(error) {
						if (error) {
							var e = ERRORS.DATABASE_ERROR;
							e.detail = error.message;
							socket.emit(event, data, false, e); // 요청자에게 message 실패 송신
							_this.print(event, socket, false, e);
						} else {
							socket.broadcast.emit(event, data); // 다른 client에게로 message 송신
							socket.emit(event, data, true); // 요청자에게 message 송신
							_this.print(event, socket, true);
						}
					});
				});

			});
		}
	};
	
	exports.SOC = SOC;
}());
