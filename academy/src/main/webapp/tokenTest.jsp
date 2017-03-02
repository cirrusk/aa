<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.net.URI"%>
<%@ page import="org.apache.http.impl.client.DefaultHttpClient"%>
<%@ page import="org.apache.http.client.HttpClient"%>
<%@ page import="org.apache.http.client.methods.HttpPost"%>
<%@ page import="org.apache.http.HttpResponse"%>
<%@ page import="org.apache.http.HttpEntity"%>
<%@ page import="java.io.InputStream"%>
<%@ page import="java.io.OutputStreamWriter"%>

<% 
  URI uri = new URI("http://qa2.abnkorea.co.kr/rest/oauth/token?client_id=1ztr8zUTLBdlj2k&client_secret=8342251a-77d8-43bd-9145-d1fd997483c2&grant_type=client_credentials");
  HttpClient httpclient = new DefaultHttpClient();
  HttpPost httpPost = new HttpPost(uri);
       
  HttpResponse response2 = httpclient.execute(httpPost); 
  //System.out.println(response2.getStatusLine());//응답결과 값이 넘어온다.
  
  HttpEntity entity = response2.getEntity();
  if (entity != null) {
      InputStream instream = entity.getContent();
      int l;
      byte[] tmp = new byte[1024];
      StringBuffer sb = new StringBuffer();
      int readCnt = instream.read(tmp);
      
      
      for (int i = 0; i < readCnt; i++){
       sb.append(tmp[i]);
      }
     
      System.out.println(new String(tmp));// 응답body값이 넘어온다.
  }

%>    
    
<html>
<head>
<title>Insert title here</title>
</head>
<body>
	<%= response2.getStatusLine()%> <br/>
</body>
</html>