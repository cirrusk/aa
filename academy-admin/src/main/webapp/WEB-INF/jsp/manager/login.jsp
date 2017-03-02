<!doctype html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<head>
    <title>Amway Academy Admin</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">

    <style type="text/css">
        body{padding:0; margin:0; background-color:#276c22; font-family:"Microsoft New Tai Lue Bold", Sans-serif}
        .loginWrap{width:500px; margin:350px auto 0; color:#fff}
        .login-header{display:block; width:100%; height:63px; line-height:1}
        .login-header .logo{display:inline-block; width:149px; height:49px; vertical-align:-15px}
        .login-header .logo img{display:inline-block; width:149px; height:49px; margin:0; padding:0}
        .login-header .title{display:inline-block; margin:0; padding:0; font-size:48px; letter-spacing:-2px}
        .login-contents{width:368px; margin:65px 0 20px 55px}
        .login-contents .cont_input{position:relative}
        .login-contents .cont_input .inputBox{display:block; margin-bottom:14px}
        .login-contents .cont_input .inputBox label{display:inline-block; width:36px; height:30px; margin:0; padding:0; line-height:30px; font-size:20px}
        .login-contents .cont_input .inputBox input{width:182px; padding:0 7px; height:30px; line-height:30px; font-size:20px}
        .login-contents .cont_input .btn_login{position:absolute; top:0; right:0; width:104px; height:82px; background-color:#3b8736; border-color:#3b8736; border-style:hidden; color:#fff; font-size:17px}
        .login-contents .cont_check{margin-left:40px; padding-top:14px}
        .login-contents .cont_check input[type="checkbox"]{width:14px; height:14px; margin:3px 4px 5px 0}
        .login-contents .cont_check label{font-size:16px; vertical-align:2px}
        .login-contents .cont_info{margin:40px 0 0 40px; color:#a2bca0; font-size:12px}
        .login-contents .cont_info ul{margin:0; padding:0; list-style-type:none}
        .login-contents .cont_info ul li{margin-top:5px}
    </style>
    <link rel="shortcut icon" href="/static/axisj/ui/axisj.ico" type="image/x-icon" />
    <link rel="icon" href="/static/axisj/ui/axisj.ico" type="image/x-icon" />
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="/static/axisj/ui/AXJ.png" />
    <link rel="apple-touch-icon-precomposed" href="/static/axisj/ui/AXJ.png" />

    <script type="text/javascript" src="/static/axisj/jquery/jquery.min.js"></script>
    <!-- 추가하는 UI 요소 : Grid + input(알림창) -->
    <script type="text/javascript" src="/static/axisj/lib/AXJ.js"></script>
    <script type="text/javascript" src="/static/axisj/lib/AXInput.js"></script>

    <script type="text/javascript" charset="UTF-8" src="/static/js/jquery/jquery.bpopup.min.js"></script>
    <script type="text/javascript" src="/static/js/common/admin.js"></script>
    <script type="text/javascript" src="/static/js/jquery/jquery-ui.js"></script>
    <script type="text/javascript" src="/static/js/jquery/jquery.form.js"></script>

    <!-- naver smart editor -->
    <script type="text/javascript" src="/se2/js/HuskyEZCreator.js" charset="utf-8"></script>
    <script type="text/javascript">
        $(document).ready(function(){
            $("#adminPwd").keyup(function(event) {
                if (event.keyCode == 13) {
                    doLogin();
                }
            });
        });

        function doLogin() {
            var adminId = $("#adminId").val();
            var adminPwd = $("#adminPwd").val();
            if( $("#aiTftCheck").is(":checked") ) {
                $("#tftCheck").val("Y");
            }

            if( adminId == "" || adminPwd == "" ) {
                alert("관리자 아이디와 비밀번호를 입력하세요.");
                return;
            }
            var tftCheck = $("#tftCheck").val();

            var param = {
                adminId : adminId
                , adminPwd : adminPwd
                , tftCheck : tftCheck
            };

            $.ajaxCall({
                url: "<c:url value="/manager/loginAjax.do"/>"
                , data : param
                , success: function( data, textStatus, jqXHR){
                    if(data.result < 1){
                        var msg = '<spring:message code="errors.load"/>';
                        alert(msg);
                    } else {

                        if( data.Authenticated == "true" ) {
                            location.href="/manager/common/main/main.do";
                        } else if( data.Authenticated == "non" ) {
                            var msg = '<spring:message code="errors.login.non"/>';
                            alert(msg);
                        } else {
                            var msg = '<spring:message code="errors.login.false"/>';
                            alert(msg);
                        }
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
                    var msg = '<spring:message code="errors.system"/>';
                    alert(msg);
                }
            });
        }

        //쿠키를 이용한 아이디저장
        $("#idRemember").ready(function(){
            // 저장된 쿠키값을 가져와서 ID 칸에 넣어준다. 없으면 공백으로 들어감.
            var userInputId = getCookie("userInputId");
            $("#adminId").val(userInputId);
            // 그 전에 ID를 저장해서 처음 페이지 로딩 시, 입력 칸에 저장된 ID가 표시된 상태라면,
            if($("#adminId").val() != ""){
                $("#idRemember").attr("checked", true); // ID 저장하기를 체크 상태로 두기.
            }

            $("#idRemember").change(function(){     // 체크박스에 변화가 있다면,
                if($("#idRemember").is(":checked")){    // ID 저장하기 체크했을 때,
                    var userInputId = $("#adminId").val();
                    setCookie("userInputId", userInputId, 7); // 7일 동안 쿠키 보관
                }else{   // ID 저장하기 체크 해제 시,
                    deleteCookie("userInputId");
                }
            });

            // ID 저장하기를 체크한 상태에서 ID를 입력하는 경우, 이럴 때도 쿠키 저장.
            $("#adminId").keyup(function(){   // ID 입력 칸에 ID를 입력할 때,
                if($("#idRemember").is(":checked")){   // ID 저장하기를 체크한 상태라면,
                    var userInputId = $("#adminId").val();
                    setCookie("userInputId", userInputId, 7);   // 7일 동안 쿠키 보관
                }
            });
        });
        function setCookie(cookieName, value, exdays){  //쿠키얻기
            var exdate = new Date();
            exdate.setDate(exdate.getDate() + exdays);
            var cookieValue = escape(value) + ((exdays==null) ? "" : "; expires=" + exdate.toGMTString());
            document.cookie = cookieName + "=" + cookieValue;
        }

        function deleteCookie(cookieName){   //쿠키삭제
            var expireDate = new Date();
            expireDate.setDate(expireDate.getDate() - 1);
            document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString();
        }

        function getCookie(cookieName) {  //쿠키얻기
            cookieName = cookieName + '=';
            var cookieData = document.cookie;
            var start = cookieData.indexOf(cookieName);
            var cookieValue = '';
            if(start != -1){
                start += cookieName.length;
                var end = cookieData.indexOf(';', start);
                if(end == -1)end = cookieData.length;
                cookieValue = cookieData.substring(start, end);
            }
            return unescape(cookieValue);
        }

    </script>

</head>
<body>
<div class="loginWrap">
    <div class="login-header">
        <span class="logo"><img src="/static/axisj/login/adminLogo.png" alt="Amway" /></span>
        <span class="title">Academy Admin</span>
    </div>
    <div class="login-contents">
        <div class="cont_input">
            <div class="inputBox">
                <label for="adminId">ID</label>
                <input type="text" id="adminId" name="adminId" value="" style="ime-mode:disabled;">
            </div>
            <div class="inputBox">
                <label for="adminPwd">PW</label>
                <input type="password" id="adminPwd" name="adminPwd" maxlength="32" autocomplete="off" style="ime-mode:disabled;">
            </div>

            <button id="login" class="btn_login" onclick="javascript:doLogin();">
                <span>LOGIN</span>
            </button>
        </div>
        
        <div class="cont_check">
        	<input type="hidden" id="tftCheck" name="tftCheck" value="N">
            <input type="checkbox" id="idRemember" name="idRemember">
            <label for="idRemember">ID REMEMBER</label>
        </div>
        
        <div class="cont_check">
            <input type="checkbox" id="aiTftCheck" name="aiTftCheck" value="">
            <label for="aiTft">AI TEST</label>
        </div>
        
        <div class="cont_info">
            &lt;안내사항&gt;
            <ul>
                <li>1.관리자 접속 권한 신청에 대한 안내 내용 기재</li>
                <li>2.비번 문의에 대한 안내 내용 기재</li>
            </ul>
        </div>
    </div>
</div>
</body>
</html>


