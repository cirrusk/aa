var SOCKET = {
	version : "1.0.1",
	iam : {},
	client : null,
	serverAddress : "",
	callback : {
		connect : null, // 본인 접속 성공 수신.
		disconnect : null, // 접속 해제 수신. (data)
		hello : null, // 다른 접속자 정보 수신. (data, success, error)
		users : null, // 접속자 목록 수신. (data, success, error)
		rooms : null, // 채팅방 목록 수신. (data, success, error)
		roomJoin : null, // 채팅방 입장 수신. (data, success, error)
		roomLeave : null, // 채팅방 나가기 수신. (data, success, error)
		roomUsers : null, // 채팅방 접속자 목록 수신. (data, success, error)
		roomMessages : null, // 채팅방 접속자 목록 수신. (data, success, error)
		roomSend : null, // 채팅방 메시지 수신. (data, success, error)
		oneSend : null, // 귓속말(1:1) 메시지 수신. (data, success, error)
		allSend : null // 전체 메시지 수신. (data, success, error)
	},
	log : function() {
		var text = [];
		for (var arg in arguments) {
			text.push(arguments[arg]);
		}
		console.log(text.join(" :: "));
	},
	connect : function() {
		if (typeof io === "object") {
			var _this = this; 
			_this.client = io.connect(_this.serverAddress);

			// 서버로부터 [접속성공] 수신
			_this.client.on("connect", function () {
				_this.log("connect", true, _this.iam);

				_this.client.emit("hello", _this.iam); // 서버로 [접속자정보] 송신

				if ("function" === typeof _this.callback.connect) {
					_this.callback.connect.apply(this, arguments);
				}
			});

			// 서버로부터 [disconnect] 수신. 
			// data가 object 이면 다른 접속자가 disconnect, 아니면 본인 disconnect
			_this.client.on("disconnect", function (data) {
				_this.log.apply(this, ["disconnect", true, data]);

				if ("function" === typeof _this.callback.disconnect) {
					_this.callback.disconnect.apply(this, arguments);
				}
			});

			// 서버로부터 [접속자정보] 수신 - 다른 접속자 정보
			_this.client.on("hello", function (data, success, error) {
				_this.log.apply(this, ["hello"].concat(Array.prototype.slice.call(arguments)));
				
				if ("function" === typeof _this.callback.hello) {
					_this.callback.hello.apply(this, arguments);
				}
			});

			// 서버로부터 [users] 수신. - 접속자 목록
			// success 가 true 이면 성공, false 이면 실패
			_this.client.on("users", function (data, success, error) {
				_this.log.apply(this, ["users"].concat(Array.prototype.slice.call(arguments)));

				if ("function" === typeof _this.callback.users) {
					_this.callback.users.apply(this, arguments);
				}
			});

			// 서버로부터 [rooms] 수신. - 채팅방 목록
			// success 가 true 이면 성공, false 이면 실패
			_this.client.on("rooms", function (data, success, error) {
				_this.log.apply(this, ["rooms"].concat(Array.prototype.slice.call(arguments)));
				
				if ("function" === typeof _this.callback.rooms) {
					_this.callback.rooms.apply(this, arguments);
				}
			});
			
			// 서버로부터 [room-join] 수신. - 채팅방 입장
			// success 가 undefined 이면 다른 접속자가 채팅방에 입장
			// success 가 true 이면 본인 채팅방에 입장, false 이면 실패
			_this.client.on("room-join", function (data, success, error) {
				_this.log.apply(this, ["room-join"].concat(Array.prototype.slice.call(arguments)));
				
				if ("function" === typeof _this.callback.roomJoin) {
					_this.callback.roomJoin.apply(this, arguments);
				}
			});
			
			// 서버로부터 [room-leave] 수신. - 채팅방 나가기 
			// success 가 undefined 이면 다른 접속자가 채팅방 나감
			// success 가 true 이면 본인 채팅방 나감, false 이면 실패
			_this.client.on("room-leave", function (data, success, error) {
				_this.log.apply(this, ["room-leave"].concat(Array.prototype.slice.call(arguments)));

				if ("function" === typeof _this.callback.roomLeave) {
					_this.callback.roomLeave.apply(this, arguments);
				}
			});

			// 서버로부터 [room-users] 수신. - 채팅방 접속자 목록
			// success 가 true 이면 성공, false 이면 실패
			_this.client.on("room-users", function (data, success, error) {
				_this.log.apply(this, ["room-users"].concat(Array.prototype.slice.call(arguments)));

				if ("function" === typeof _this.callback.roomUsers) {
					_this.callback.roomUsers.apply(this, arguments);
				}
			});

			// 서버로부터 [room-messages] 수신. - 채팅방 메시지 목록
			// success 가 true 이면 성공, false 이면 실패
			_this.client.on("room-messages", function (data, success, error) {
				_this.log.apply(this, ["room-messages"].concat(Array.prototype.slice.call(arguments)));
				
				if ("function" === typeof _this.callback.roomMessages) {
					_this.callback.roomMessages.apply(this, arguments);
				}
			});

			// 서버로부터 [room-send] 수신.
			// success 가 undefined 이면 다른 접속자 메시지
			// success 가 true 이면 본인 메시지, false 이면 실패
			_this.client.on("room-send", function (data, success, error) {
				_this.log.apply(this, ["room-send"].concat(Array.prototype.slice.call(arguments)));

				if ("function" === typeof _this.callback.roomSend) {
					_this.callback.roomSend.apply(this, arguments);
				}
			});

			// 서버로부터 [one-send] 수신.
			// success 가 undefined 이면 다른 접속자 메시지
			// success 가 true 이면 본인 메시지, false 이면 실패
			_this.client.on("one-send", function (data, success, error) {
				_this.log.apply(this, ["one-send"].concat(Array.prototype.slice.call(arguments)));
				
				if ("function" === typeof _this.callback.oneSend) {
					_this.callback.oneSend.apply(this, arguments);
				}
			});
			
			// 서버로부터 [all-send] 수신.
			// success 가 undefined 이면 다른 접속자 메시지
			// success 가 true 이면 본인 메시지, false 이면 실패
			_this.client.on("all-send", function (data, success, error) {
				_this.log.apply(this, ["all-send"].concat(Array.prototype.slice.call(arguments)));

				if ("function" === typeof _this.callback.allSend) {
					_this.callback.allSend.apply(this, arguments);
				}
			});

		}
	},

	// 접속자 목록
	users : function(condition) {
		var _this = this;
		if (_this.client === null) {
			alert("Not connected.");
		} else {
			_this.client.emit("users", condition); // 서버로 송신
		}
	},

	// 채팅방 목록
	rooms : function() {
		var _this = this;
		if (_this.client === null) {
			alert("Not connected.");
		} else {
			_this.client.emit("rooms"); // 서버로 송신
		}
	},
	
	// 채팅방 입장
	roomJoin : function(room) {
		var _this = this;
		if (_this.client === null) {
			alert("Not connected.");
		} else {
			if ("object" === typeof room) {
				_this.client.emit("room-join", room); // 서버로 송신
			} else {
				alert("roomId is undefined.");
			}
		}
	},
	
	// 채팅방 나가기
	roomLeave : function(roomId) {
		var _this = this;
		if (_this.client === null) {
			alert("Not connected.");
		} else {
			if ("string" === typeof roomId && roomId.length > 0) {
				_this.client.emit("room-leave", roomId); // 서버로 송신
			} else {
				alert("roomId is undefined.");
			}
		}
	},
	
	// 채팅방 접속자 목록 요청
	roomUsers : function(roomId) {
		var _this = this;
		if (_this.client === null) {
			alert("Not connected.");
		} else {
			if ("string" === typeof roomId && roomId.length > 0) {
				_this.client.emit("room-users", roomId); // 서버로 송신
			} else {
				alert("roomId is undefined.");
			}
		}
	},

	// 메시지 목록
	roomMessages : function(roomId, condition, orderby, perPage, page) {
		var _this = this;
		if (_this.client === null) {
			alert("Not connected.");
		} else {
			if ("string" === typeof roomId && roomId.length > 0) {
				_this.client.emit("room-messages", roomId, condition, orderby, perPage, page); // 서버로 송신
			} else {
				alert("roomId is undefined.");
			}
		}
	},

	// 채팅방 메시지 송신
	roomSend : function(msg) {
		var _this = this;
		if (_this.client === null) {
			alert("Not connected.");
		} else {
			if ("object" === typeof msg && "string" === typeof msg.roomId && msg.roomId.length > 0 && "string" === typeof msg.message && msg.message.length > 0) {
				_this.client.emit("room-send", msg); // 서버로 송신
			} else {
				alert("parameter is undefined.");
			}
		}
	},

	// 귓속말(1:1) 메시지 송신
	oneSend : function(msg) {
		var _this = this;
		if (_this.client === null) {
			alert("Not connected.");
		} else {
			if ("object" === typeof msg && "string" === typeof msg.socketId && msg.socketId.length > 0 && "string" === typeof msg.message && msg.message.length > 0) {
				_this.client.emit("one-send", msg); // 서버로 송신
			} else {
				alert("parameter is undefined.");
			}
		}
	},
	
	// 전체 메시지 송신
	allSend : function(message) {
		var _this = this;
		if (_this.client === null) {
			alert("Not connected.");
		} else {
			_this.client.emit("all-send", message); // 서버로 송신
		}
	}

};
