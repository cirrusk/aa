<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.io.*" %>
<%
URL u = new URL("https://qa2.abnkorea.co.kr/rest/oauth/token?client_id=1ztr8zUTLBdlj2k&client_secret=8342251a-77d8-43bd-9145-d1fd997483c2&grant_type=client_credentials");
URLConnection uc = u.openConnection();

BufferedReader in = new BufferedReader(
new InputStreamReader(uc.getInputStream()));
String res = in.readLine();
System.out.println(res);
in.close();
%>
