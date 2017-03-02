<%@ page pageEncoding="utf-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<c:set var="ssId" value="${aoffn:encrypt(pageContext.session.id)}"/>
<c:set var="domainNodejs" value="${aoffn:config('domain.nodejs')}"/>

<html decorator="blank">
<head>
<title></title>
<script type="text/javascript" src="<c:out value="${domainNodejs}"/>/socket.io/socket.io.js"></script>
<script type="text/javascript" src="<c:out value="${domainNodejs}"/>/html/js/client.js"></script>
<script type="text/javascript">
doInitSocket = function() {
    
    <c:if test="${!empty ssMemberName}"> <%-- 로그인 했을 경우에만. --%>
    // serverAddress
    SOCKET.serverAddress = "<c:out value="${domainNodejs}"/>";
    
    // 내 정보 정의 - id는 필수
    SOCKET.iam = {
        "id" : new Date().getTime() + "-<c:out value="${ssMemberSeq}"/>",
        "name" : "<c:out value="${ssMemberName}"/>",
        "memberId" : "<c:out value="${ssMemberId}"/>",
        "photo" : "<c:out value="${ssMemberPhoto}"/>",
        "ip" : "<c:out value="${pageContext.request.remoteAddr}"/>"
    };
    
    // callback 함수 정의
    SOCKET.callback.connect = function() { // 본인 접속 성공 수신.
    };
    SOCKET.callback.disconnect = function(data) { // 접속 해제 수신. (data) 
        // data가 object 이면 다른 접속자가 disconnect, 아니면 본인 disconnect
    };
    SOCKET.callback.hello = function(data, success, error) { // 다른 접속자 정보 수신. (data, success, error)
        // success 가 undefined 이면 다른 접속자 정보
        // success 가 false 이면 본인 정보 전송 실패
    };
    SOCKET.callback.users = function(data, success, error) { // 접속자 목록 수신. (data, success, error)
        // success 가 true 이면 성공, false 이면 실패
    };
    SOCKET.callback.rooms = function(data, success, error) { // 채팅방 목록 수신. (data, success, error)
        // success 가 true 이면 성공, false 이면 실패
    };
    SOCKET.callback.roomJoin = function(data, success, error) { // 채팅방 입장 수신. (data, success, error)
        // success 가 undefined 이면 다른 접속자가 채팅방에 입장
        // success 가 true 이면 본인 채팅방에 입장, false 이면 실패
    };
    SOCKET.callback.roomLeave = function(data, success, error) { // 채팅방 나가기 수신. (data, success, error)
        // success 가 undefined 이면 다른 접속자가 채팅방 나감
        // success 가 true 이면 본인 채팅방 나감, false 이면 실패
    };
    SOCKET.callback.roomUsers = function(data, success, error) { // 채팅방 접속자 목록 수신. (data, success, error)
        // success 가 true 이면 성공, false 이면 실패
    };
    SOCKET.callback.roomMessages = function(data, success, error) { // 채팅방 접속자 목록 수신. (data, success, error)
        // success 가 true 이면 성공, false 이면 실패
    };
    SOCKET.callback.roomSend = function(data, success, error) { // 채팅방 메시지 수신. (data, success, error)
        // success 가 undefined 이면 다른 접속자 메시지
        // success 가 true 이면 본인 메시지, false 이면 실패
    };
    SOCKET.callback.oneSend = function(data, success, error) { // 귓속말(1:1) 메시지 수신. (data, success, error)
        // success 가 undefined 이면 다른 접속자 메시지
        // success 가 true 이면 본인 메시지, false 이면 실패
    };
    SOCKET.callback.allSend = function(data, success, error) { // 전체 메시지 수신. (data, success, error)
        // success 가 undefined 이면 다른 접속자 메시지
        // success 가 true 이면 본인 메시지, false 이면 실패
    };
    
    // 소켓 연결
    SOCKET.connect();
    </c:if>
};
doAction = function(action) {
    switch(action) {
    case "rooms":
        SOCKET.rooms();
        break;
    case "users":
        var condition = {};
        SOCKET.users(condition);
        break;
    case "room-create":
        var room = {
            id : "",
            name : ""
        }
        SOCKET.roomJoin(room);
        break;
    case "room-join":
        var roomId = "";
        SOCKET.roomJoin(roomId);
        break;
    case "room-leave":
        var roomId = "";
        SOCKET.roomLeave(roomId);
        break;
    case "room-users":
        var roomId = "";
        SOCKET.roomUsers(roomId);
        break;
    case "room-messages":
        var roomId = "";
        SOCKET.roomMessages(roomId);
        break;
    case "room-send":
        var msg = {
            roomId : "",
            message : ""
        }
        SOCKET.roomSend(msg);
        break;
    case "one-send":
        var msg = {
            socketId : "",
            message : ""
        }
        SOCKET.oneSend(msg);
        break;
    case "all-send":
        var message = "";
        SOCKET.allSend(message);
        break;
    }
};
</script>
<body>
    
</body>
</html>