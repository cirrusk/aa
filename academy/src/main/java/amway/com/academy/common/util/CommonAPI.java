package amway.com.academy.common.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.net.ssl.*;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import java.io.*;
import javax.xml.parsers.ParserConfigurationException;
import org.xml.sax.SAXException;
import java.net.URL;
import java.net.URLEncoder;
import java.security.KeyManagementException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.cert.X509Certificate;
import java.util.*;

/**
 * Created by KR620242 on 2016-09-06.
 */
public class CommonAPI {

	/** LOGGER */
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonAPI.class);

	/**
	 * 
	 * @param url
	 * @return
	 * @throws Exception
	 */
    public static String getObject(URL url) throws Exception {
        String urlString = url.toString();

        return urlString;
    }

    /**
     * 
     * @param url
     * @param valueOne
     * @param valueTwo
     * @param type
     * @return
     * @throws Exception
     */
    public static String getObject(URL url, String valueOne, String valueTwo, String type) throws Exception {
        String urlString = url.toString() + "/" + valueOne;
        StringBuffer urlBuffer = new StringBuffer(urlString);

        if (type.equals("checkUser")) {
        	urlBuffer.append("?customerPwd=" + valueTwo);
        } else if (type.equals("receipts")) {
        	urlBuffer.append("/" + valueTwo);
        }
        urlString = urlBuffer.toString();

        return urlString;
    }

    /**
     * token 호출 용.
     * @param url
     * @param queryArgs
     * @return
     * @throws Exception
     */
    public static String getTokenObject(URL url, String... queryArgs) throws Exception {

        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < queryArgs.length; i++) {
            String[] splitString = queryArgs[i].split("=");
            if (splitString.length == 2 && splitString[1] != null) {
                if (i > 0) {
                    sb.append("&");
                }
                sb.append(splitString[0]);
                sb.append("=");
                sb.append(URLEncoder.encode(splitString[1], "UTF-8"));
            }
        }
        String urlString = url.toString();
        StringBuffer urlBuffer = new StringBuffer(urlString);

        // 기존 쿼리스트링이 존재하지 않는다면 ? 부터 새로 만들어준다.
        if (urlString.indexOf("?") != -1) {
            if (urlString.endsWith("?")) {
            	urlBuffer.append(sb.toString());
            } else {
            	urlBuffer.append("&"+sb.toString());
            }
        } else {
        	urlBuffer.append("?"+sb.toString());
        }
        urlString = urlBuffer.toString();
        return urlString;
    }

    /**
     * token을 가져오는 기능
     * @param url
     * @return
     * @throws Exception
     */
    public static String connectionWebServiceToken(URL url) throws Exception {
        StringBuffer response = new StringBuffer();
        getCommHTTPS("SSL");
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
                response.append(inputLine);
            }
            
            in.close();
            wr.close();
            urlConnection.disconnect();

        } catch (IOException e) {
        	LOGGER.error(e.getMessage(), e);
            throw e;
        } finally {
            if (in != null){ in.close(); }
            if (wr != null){ wr.close(); }
        }
        return response.toString();
    }

    /**
     * token 값을 HTTP Header 에 얻어서 보내, 원하는 데이터를 가져오는 기능
     * @param url
     * @param token
     * @param method
     * @return
     * @throws Exception
     */
    public static String conWebService(URL url, String token, String method) throws Exception {
        StringBuffer response = new StringBuffer();
        getCommHTTPS("SSL");
        HttpsURLConnection urlConnection = (HttpsURLConnection) url.openConnection();
        urlConnection.setDoOutput(true);
        urlConnection.setDoInput(true);
        urlConnection.setUseCaches(false);

        urlConnection.setRequestMethod(method);
        urlConnection.setRequestProperty("Accept-Charset", "UTF-8");
        urlConnection.setRequestProperty("Accept", "application/xml");
        urlConnection.setRequestProperty("Authorization", token);

        /* skip verifier */
        urlConnection.setHostnameVerifier(new CustomizedHostNameVerifier());

        InputStreamReader in = null;
        BufferedReader br = null;

        try {
            /* request */
            in = new InputStreamReader((InputStream) urlConnection.getContent());
            br = new BufferedReader(in);

            String line;
            while ((line = br.readLine()) != null) {
                response.append(line).append("\n");
            }

            br.close();
            in.close();
            urlConnection.disconnect();

        } catch (IOException e) {
        	LOGGER.error(e.getMessage(), e);
        } finally {
            if (null != br) {
                br.close();
            }
            if (null != in) {
                in.close();
            }
        }

        return response.toString();
    }

    /**
     * 
     * @param url
     * @param token
     * @param xmlSource
     * @param method
     * @return
     * @throws Exception
     */
    public static String conXmlWebService(URL url, String token, String xmlSource, String method) throws Exception {
        StringBuffer response = new StringBuffer();
        getCommHTTPS("SSL");
        HttpsURLConnection urlConnection = (HttpsURLConnection) url.openConnection();
        urlConnection.setDoOutput(true);

        urlConnection.setRequestMethod(method);
        urlConnection.setRequestProperty("Content-Type", "application/xml; charset=utf-8");
        urlConnection.setRequestProperty("Accept", "application/xml");
        urlConnection.setRequestProperty("Authorization", token);

        /* skip verifier */
        urlConnection.setHostnameVerifier(new CustomizedHostNameVerifier());

        OutputStreamWriter wr = null;
        BufferedReader in = null;
        try {
            wr = new OutputStreamWriter(urlConnection.getOutputStream(), "UTF-8");
            wr.write(xmlSource);
            wr.flush();
            String inputLine = null;
            in = new BufferedReader(new InputStreamReader(urlConnection.getInputStream()));
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            
            in.close();
            wr.close();
            urlConnection.disconnect();

        } catch (IOException e) {
        	LOGGER.error(e.getMessage(), e);
            throw e;
        } finally {
        	if (in != null){ in.close(); }
            if (wr != null){ wr.close(); }
        }
        return response.toString();
    }


    /**
     * 단건의 xml 을 가져오는 기능
     * @param inputVal
     * @param startNodeName
     * @return
     */
    public static Map<String, String> getXmlRead(InputStream inputVal, String startNodeName) {
        Map<String, String> retMap = new HashMap<String, String>();

        try {
			DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
			Document doc = dBuilder.parse(inputVal);

			NodeList nList = doc.getElementsByTagName(startNodeName);
			int noteCount = nList.getLength();
			for (int i = 0; i < noteCount; i++) {
			    Element el = (Element) nList.item(i);
			    Node title = el.getFirstChild();
			    for (Node node = title; node != null; node = node.getNextSibling()) {
			        retMap.put(node.getNodeName(), node.getTextContent());
			    }
			}
        } catch (DOMException e) {
        	LOGGER.error(e.getMessage(), e);
        } catch (ParserConfigurationException e) {
        	LOGGER.error(e.getMessage(), e);
        } catch (IOException e){
        	LOGGER.error(e.getMessage(), e);
        } catch (SAXException e){
        	LOGGER.error(e.getMessage(), e);
        }

        return retMap;
    }

    /**
     * xml 을 object 로 가져 오는 기능
     * @param inputVal
     * @param startNodeName
     * @return
     */
    public static Map<String, Object> getListXmlRead(InputStream inputVal, String startNodeName) {
        Map<String, Object> retMap = new HashMap<String, Object>();

        try {
            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();

            Document doc = dBuilder.parse(inputVal);

            NodeList headList = null;
            if (startNodeName.equals("noList")) {
                headList = doc.getDocumentElement().getChildNodes(); //xml노드를 가져온다.
            } else {
                headList = doc.getDocumentElement().getElementsByTagName(startNodeName); //반복되는 xml 노드를 가져온다.
            }
            int listLength = headList.getLength();

            ArrayList list = new ArrayList();//결과를 담을 배열 list생성

            for (int i = 0; i < listLength; i++) {
                Node row = headList.item(i);
                NodeList childNodeList = row.getChildNodes();

                HashMap map = new HashMap();
                for (int j = 0; j < childNodeList.getLength(); j++) {
                    Node nodeList = childNodeList.item(j);
                    map.put(nodeList.getNodeName(), nodeList.getTextContent());
                }
                list.add(map);
            }
            retMap.put("list", list);

        } catch (DOMException e) {
        	LOGGER.error(e.getMessage(), e);
        } catch (ParserConfigurationException e) {
            LOGGER.error(e.getMessage(), e);
        } catch (IOException e){
        	LOGGER.error(e.getMessage(), e);
        } catch (SAXException e){
        	LOGGER.error(e.getMessage(), e);
        }
        return retMap;
    }

    /**
     * xml 을 object 로 가져오는 기능
     * @param inputVal
     * @param type
     * @return
     */
    public static Map<String, String> getCheckXmlRead(InputStream inputVal, String type) {
        Map<String, String> retMap = new HashMap<String, String>();

        try {
            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
            Document doc = dBuilder.parse(inputVal);
            String result = "";

            NodeList nList = doc.getElementsByTagName("header");
            int noteCount = nList.getLength();
            for (int i = 0; i < noteCount; i++) {
                Element el = (Element) nList.item(i);
                Node title = el.getFirstChild();
                for (Node node = title; node != null; node = node.getNextSibling()) {
                	
                	if(node.getNodeName().equals("dateAndTimeStamp")){
                		for (Node reNode = node.getFirstChild(); reNode != null; reNode = reNode.getNextSibling()) {
                            if (reNode.getNodeName().equals("response")) {
                                retMap.put("responseTimestamp", reNode.getTextContent());
                            }
                        }
                	}
                	
                    if(node.getNodeName().equals("result")) {
                        for (Node reNode = node.getFirstChild(); reNode != null; reNode = reNode.getNextSibling()) {
                            if (reNode.getNodeName().equals("status")) {
                                retMap.put("result", reNode.getTextContent());
                                result = reNode.getTextContent();
                            }
                            if (reNode.getNodeName().equals("errorCode")) {
                                retMap.put("errorCode", reNode.getTextContent());
                            }
                            if (reNode.getNodeName().equals("errorMsg")) {
                            	StringBuilder sb = new StringBuilder();
                            	sb.append(" API : ").append(reNode.getTextContent());
                                retMap.put("errorMsg", sb.toString());
                            }
                        }
                    }
                }
            }

            if(result.equals("SUCCESS")) {
                if("check".equals(type)) {
                    NodeList mList = doc.getElementsByTagName("amwaySuperintendentOrderCreate");
                    int moteCount = mList.getLength();
                    for (int i = 0; i < moteCount; i++) {
                        Element elp = (Element) mList.item(i);
                        Node reTitle = elp.getFirstChild();
                        for (Node nodes = reTitle; nodes != null; nodes = nodes.getNextSibling()) {
                            if (nodes.getNodeName().equals("result")) {
                                for (Node reNode = nodes.getFirstChild(); reNode != null; reNode = reNode.getNextSibling()) {
                                    if (reNode.getNodeName().equals("orderAmount")) {
                                        retMap.put(reNode.getNodeName(), reNode.getTextContent());
                                    }
                                }
                            }
                        }
                    }
                } else if("order".equals(type)) {
                    NodeList mList = doc.getElementsByTagName("amwaySuperintendentOrderCreate");
                    int moteCount = mList.getLength();
                    for (int i = 0; i < moteCount; i++) {
                        Element elp = (Element) mList.item(i);
                        Node reTitle = elp.getFirstChild();
                        for (Node nodes = reTitle; nodes != null; nodes = nodes.getNextSibling()) {
                            if (nodes.getNodeName().equals("result")) {
                                for (Node reNode = nodes.getFirstChild(); reNode != null; reNode = reNode.getNextSibling()) {
                                    if (reNode.getNodeName().equals("invoiceQueue")) {
                                        retMap.put(reNode.getNodeName(), reNode.getTextContent());
                                    }
                                }
                            }
                        }
                    }
                } else if("cancel".equals(type)) {
                    retMap.put("result", result);
                }
            } else {
                retMap.put("result", "ERROR");
            }
            
        } catch (DOMException e) {
        	LOGGER.error(e.getMessage(), e);
        } catch (ParserConfigurationException e) {
            LOGGER.error(e.getMessage(), e);
        } catch (IOException e){
        	LOGGER.error(e.getMessage(), e);
        } catch (SAXException e){
        	LOGGER.error(e.getMessage(), e);
        }

        retMap.put("productCode", "2904");
        return retMap;
    }

    /**
     * ssl 인증서 스킵
     * @param protocol
     * @return
     */
    public static boolean getCommHTTPS(String protocol) {
        try {
            /*
        　　 * fix for
        　　 * Exception in thread "main" javax.net.ssl.SSLHandshakeException:
        　　 * sun.security.validator.ValidatorException:
        　　 * PKIX path building failed: sun.security.provider.certpath.SunCertPathBuilderException:
        　　 * unable to find valid certification path to requested target
        　　 */
            TrustManager[] trustAllCerts = new TrustManager[] { new X509TrustManager() {
                public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                    return new X509Certificate[0];
                }

                public void checkClientTrusted(X509Certificate[] certs, String authType) {
                	return;
                }

                public void checkServerTrusted(X509Certificate[] certs, String authType) {
                	return;
                }
            } };
            SSLContext sslcontext = null;
            sslcontext = SSLContext.getInstance(protocol);  // TLS, SSL 등 프로토콜 레벨 정의
            sslcontext.init(null, trustAllCerts, new java.security.SecureRandom());
            HttpsURLConnection.setDefaultSSLSocketFactory(sslcontext.getSocketFactory());
            // Create all-trusting host name verifier
            HostnameVerifier allHostsValid = new HostnameVerifier() {
                public boolean verify(String hostname, SSLSession session) {
                    return true;
                }
            };
            // Install the all-trusting host verifier
            HttpsURLConnection.setDefaultHostnameVerifier(allHostsValid);

        } catch (NoSuchAlgorithmException e) {
        	LOGGER.error(e.getMessage(), e);
        } catch (KeyManagementException e) {
        	LOGGER.error(e.getMessage(), e);
        } catch (Exception e) {
        	LOGGER.error(e.getMessage(), e);
        }
        return true;
    }

    /**
     * encode SHA256
     * @param str
     * @return
     */
    public static String encodingSHA256(String str) {
        String sha = "";
        try {
            MessageDigest sh = MessageDigest.getInstance("SHA-256");
            sh.update(str.getBytes());
            byte byteData[] = sh.digest();
            StringBuffer sb = new StringBuffer();
            for(int i=0; i<byteData.length; i++){
                sb.append(Integer.toString((byteData[i]&0xff) + 0x100, 16).substring(1));
            }
            StringBuffer hexString = new StringBuffer();
            for(int i=0; i<byteData.length; i++){
                String hex = Integer.toHexString(0xff & byteData[i]);
                int lengSize = 1;
                if(hex.length() == lengSize) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            sha = hexString.toString();
            
        } catch(NoSuchAlgorithmException e) {
        	LOGGER.error("Encrypt Error - NoSuchAlgorithmException");
            LOGGER.error(e.getMessage(), e);
            sha = null;
        } catch(Exception e) {
        	LOGGER.error(e.getMessage(), e);
        	sha = null;
        }
        return sha;
    }

}
