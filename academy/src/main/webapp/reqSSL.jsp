<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="org.slf4j.Logger"%>
<%@ page import="org.slf4j.LoggerFactory"%>
<%@ page import="org.w3c.dom.Document"%>
<%@ page import="org.w3c.dom.Element"%>
<%@ page import="org.w3c.dom.Node"%>
<%@ page import="org.w3c.dom.NodeList"%>
<%@ page import="javax.net.ssl.*"%>
<%@ page import="javax.xml.parsers.DocumentBuilder"%>
<%@ page import="javax.xml.parsers.DocumentBuilderFactory"%>
<%@ page import="java.io.*"%>
<%@ page import="javax.xml.parsers.ParserConfigurationException"%>
<%@ page import="org.xml.sax.SAXException"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.security.KeyManagementException"%>
<%@ page import="java.security.MessageDigest"%>
<%@ page import="java.security.NoSuchAlgorithmException"%>
<%@ page import="java.security.cert.X509Certificate"%>
<%@ page import="java.util.*"%>
<%@ page import="java.lang.*"%>
<%@ page import="amway.com.academy.common.util.CommonAPI"%>
<%@ page import="amway.com.academy.common.util.CustomizedHostNameVerifier"%>

<%

	URL url = new URL("https://qa2.abnkorea.co.kr/rest/oauth/token?client_id=1ztr8zUTLBdlj2k&client_secret=8342251a-77d8-43bd-9145-d1fd997483c2&grant_type=client_credentials");
	//URL url = new URL("https://qa2.abnkorea.co.kr/rest/store/maintenance/sm-as400");

	StringBuffer responseSb = new StringBuffer();
    CommonAPI.getCommHTTPS("SSL");
    HttpsURLConnection urlConnection = (HttpsURLConnection) url.openConnection();
    urlConnection.setDoOutput(true);
    urlConnection.setRequestMethod("GET");

    /* skip verifier */
    urlConnection.setHostnameVerifier(new CustomizedHostNameVerifier());

    OutputStreamWriter wr = null;
    BufferedReader in = null;
    try {
        wr = new OutputStreamWriter(urlConnection.getOutputStream(), "UTF-8");
        wr.flush();
        String inputLine = null;
        in = new BufferedReader(new InputStreamReader(urlConnection.getInputStream()));
        while ((inputLine = in.readLine()) != null) {
            responseSb.append(inputLine);
        }
        
        in.close();
        wr.close();
        urlConnection.disconnect();

    } catch (IOException e) {
    	//LOGGER.error(e.getMessage(), e);
    	e.printStackTrace();
        throw e;
    } finally {
        if (in != null){ in.close(); }
        if (wr != null){ wr.close(); }
    }
        
	//return response.toString();
	out.print(responseSb.toString());
	System.out.println(responseSb.toString());

%>
