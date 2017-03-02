package amway.com.academy.manager.common.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import javax.net.ssl.*;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import java.io.*;
import java.net.URL;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.X509Certificate;
import java.util.*;

/**
 * Created by KR620242 on 2016-09-05.
 */
public class NavigationAPI {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(NavigationAPI.class);
	
    //private static String daishinBaseUrl = "https://dev2.abnkorea.co.kr";
    
    public static String getApiUrl() {
    	LOGGER.debug("invoke getApiUrl");
    	
		String returnUrl = "";
		String reName = "/config/props/framework.properties";
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		Properties prop = new Properties();
		try( InputStream resourceStream = loader.getResourceAsStream(reName) ) {
            prop.load(resourceStream);
			//api-url
            returnUrl = prop.getProperty("api.server.location");
		} catch( IOException e) {
			e.printStackTrace();
		}
		return returnUrl;
	}

    // name : token 정보
    public static String token() throws Exception {
    	LOGGER.debug("invoke token");
    	
        String daishinBaseUrl = getApiUrl();

        String urlString = daishinBaseUrl + "/rest/oauth/token?client_id=t7OBlETHAD&client_secret=eab393de-5ce9-454a-a062-25f08671da54&grant_type=client_credentials";
        LOGGER.debug("urlString : {}", urlString);

        URL url = new URL(urlString);
        String returnValue = conWebServiceToken(url);

        //읽어온 데이터 파싱하기
        Map<String,String> readMap = getXmlRead(new ByteArrayInputStream(returnValue.getBytes()), "defaultOAuth2AccessToken");

        String token = "bearer "+readMap.get("value");

        return token;
    }

    // token을 가져온다.
    public static String conWebServiceToken(URL url) throws Exception {
    	LOGGER.debug("invoke conWebServiceToken");
    	
        StringBuffer respon = new StringBuffer();
        getCommHTTPS("SSL");
        HttpsURLConnection urlCon = (HttpsURLConnection) url.openConnection();
        urlCon.setDoOutput(true);
        urlCon.setRequestMethod("GET");

        /* skip verifier */
        urlCon.setHostnameVerifier(new CustomizedHostNameVerifier());

        OutputStreamWriter wr = null;
        BufferedReader in = null;
        try {
        	LOGGER.debug("open stream");
            wr = new OutputStreamWriter(urlCon.getOutputStream(), "UTF-8");
            wr.flush();
            String inputLine = null;
            in = new BufferedReader(new InputStreamReader(urlCon.getInputStream()));
            while ((inputLine = in.readLine()) != null) {
                respon.append(inputLine);
            }
        } catch (IOException e) {
            //e.printStackTrace();
        	LOGGER.error(e.getMessage(), e);
            throw e;
        } finally {
        	LOGGER.debug("close stream");
            if (in != null){ in.close(); }
            if (wr != null){ wr.close(); }
        }
        return respon.toString();
    }

    public static List<Map<String, Object>> navigation() throws Exception {
        String daishinBaseUrl = getApiUrl();
        String token = token();
        String urlString = daishinBaseUrl + "/rest/cms/navigation/all";

        URL url = new URL(urlString);
        String apInfo = conWebService(url, token, "GET");
        apInfo = apInfo.replaceAll("&","<![CDATA[&]]>");

        //읽어온 데이터 파싱하기
        List<Map<String,Object>> apInfoMap = getListXmlRead(new ByteArrayInputStream(apInfo.getBytes()), "cmsNavigationNode");

        //LOGGER.debug((String)apInfoMap.get("list"));

        return apInfoMap;
    }

    // token 값을 HTTP Header 에 얻어서 보내, 원하는 데이터를 가져온다.
    public static String conWebService(URL url, String token, String method) throws Exception {
    	LOGGER.debug("conWebService");
    	
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
            // TODO Auto-generated catch block
            e.printStackTrace();
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

    /* name : 임시주문번호(VPS오더넘버) - 주문번호매핑
    ** request : 주문일자 , 임시주문번호
    */
    public static Map getInvoice(String orderCreationTime, String invoiceQueue) throws Exception {
    	
    	LOGGER.debug("invoke getInvoice");
    	
        String comp = "";
        String daishinBaseUrl = getApiUrl();
        String token = token();
        String urlString = daishinBaseUrl + "/rest/orders/invoiceCode/"+orderCreationTime+"/"+invoiceQueue;

        /* API request url */
        LOGGER.debug("urlString : {}", urlString);
        
        URL url = new URL(urlString);
        String orderInfo = conWebService(url, token, "POST").replaceAll("&", "&amp;");

        //읽어온 데이터 파싱하기
        Map<String,String> orderInfoMap = getXmlRead(new ByteArrayInputStream(orderInfo.getBytes()), "invoiceCode");

        return orderInfoMap;
    }

    // xml 을 object 로 가져온다.
    public static List<Map<String, Object>> getListXmlRead(InputStream inputVal, String startNodeName) {

        List<Map<String, Object>> retMap = new ArrayList<Map<String, Object>>();

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

            for (int i = 0; i < listLength; i++) {
                Node row = headList.item(i);
                NodeList childNodeList = row.getChildNodes();

                HashMap map = new HashMap();
                for (int j = 0; j < childNodeList.getLength(); j++) {
                    Node nodeList = childNodeList.item(j);
                    map.put(nodeList.getNodeName(), nodeList.getTextContent());
                }
                retMap.add(map);
            }

        } catch (ParserConfigurationException e) {
            e.printStackTrace();
        } catch (IOException e){
        	e.printStackTrace();
        } catch (SAXException e){
        	e.printStackTrace();
        }
        return retMap;
    }

    /*
    ** ssl 인증서 스킵
     */
    public static boolean getCommHTTPS(String protocol) {
        try {
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
            HostnameVerifier allHostsValid = new HostnameVerifier() {
                public boolean verify(String hostname, SSLSession session) {
                    return true;
                }
            };
            HttpsURLConnection.setDefaultHostnameVerifier(allHostsValid);
        } catch (NoSuchAlgorithmException e) {
            // TODO Auto-generated catch block
        } catch (KeyManagementException e) {
            // TODO Auto-generated catch block
        }
        return true;
    }

    // 단건의 xml 을 가져온다.
    public static Map<String, String> getXmlRead(InputStream inputVal, String startNodeName) throws Exception{
    	LOGGER.debug("getXmlRead");
    	
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
        } catch (ParserConfigurationException e) {
            LOGGER.error(e.getMessage(), e);
        } catch (IOException e){
        	LOGGER.error(e.getMessage(), e);
        } catch (SAXException e){
        	LOGGER.error(e.getMessage(), e);
        }

        return retMap;
    }

}
