package amway.com.academy.reservation.basicPackage;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.net.ssl.*;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.X509Certificate;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/common/util")
public class GlmsAPI {
    private static final String daishinBaseUrl = "https://qa2.abnkorea.co.kr";

    private enum URL_TYPE {
        LOGIN,
        GET_TOKEN,
        GET_AWAYGO_LOGIN,
        GET_CARD_COMPANY,
        GET_AP_INFO,
        CHECK_SSO

    }

    private static URL getUrl(URL_TYPE type, String param) throws Exception {
        URL url = null;

        switch (type) {
            case LOGIN:
                url = new URL(daishinBaseUrl + "/rest/store/pointOfServices");
                break;

            case GET_TOKEN:
                url = new URL(daishinBaseUrl + "/rest/oauth/token" + param);
                break;

            case GET_AWAYGO_LOGIN:
                url = new URL(daishinBaseUrl + "/rest/oauth/token" + param);
                break;

            case GET_CARD_COMPANY:
                url = new URL(daishinBaseUrl + "/rest/store/creditCardCompany");
                break;

            case GET_AP_INFO:
                url = new URL(daishinBaseUrl + "/rest/store/pointOfServices");
                break;

            case CHECK_SSO:
                url = new URL(daishinBaseUrl + "/rest/authorize");
                break;

            default:
                break;
        }

        return url;
    }
    public String getUrl(URL url) throws Exception {
        StringBuilder sb = new StringBuilder();

        String urlString = url.toString();

        return urlString;
    }

    public String getObject(URL url, String ... queryArgs)  throws Exception {

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

        // 기존 쿼리스트링이 존재하지 않는다면 ? 부터 새로 만들어준다.
        if (urlString.indexOf("?") != -1) {
            if (urlString.endsWith("?")) {
                urlString += sb.toString();
            } else {
                urlString += "&" + sb.toString();
            }
        } else {
            urlString += "?" + sb.toString();
        }
        return urlString;
    }

    @RequestMapping(value = "/creditCardCompany.do")
    public ModelAndView creditCardCompany() throws Exception {
        ModelAndView mav = new ModelAndView();
        String comp = "";
        String token = token();
        String urlString = getUrl(getUrl(URL_TYPE.GET_CARD_COMPANY, comp));
        System.out.println(token);
        URL url = new URL(urlString);
        String cardCompany = conWebService(url,token);

        //읽어온 데이터 파싱하기
        Map<String,String> cardMap = getXmlRead(new ByteArrayInputStream(cardCompany.getBytes()), "bankInfo");

        mav.addObject("readData", cardMap);

        return mav;
    }


    @RequestMapping(value = "/ssoCheck.do")
    public ModelAndView ssoCheck(HttpServletRequest request) throws Exception {
        ModelAndView mav = new ModelAndView();
        String comp = "";
        String token = token();
        String urlString = getUrl(getUrl(URL_TYPE.CHECK_SSO, comp));

        String ssoToken = "";

        Cookie [] cookies = request.getCookies();

        if(null != cookies) {
			/* 유효한 연결이면 requestMap 객체 생성 */
            for(Cookie cookie : cookies){
                String cookieName = cookie.getName();
                String cookieValue = cookie.getValue();

                if("i_mar".equals(cookieName)){
                    ssoToken = cookieValue;
                    break;
                }
            }
        }
        if(ssoToken.equals("")) {
            ssoToken = "GPj645lX1JKIazV";
        }

        URL url = new URL(urlString);
        String cardCompany = conWebServiceCheckSSO(url,token, ssoToken);

        //읽어온 데이터 파싱하기
        Map<String,String> cardMap = getXmlRead(new ByteArrayInputStream(cardCompany.getBytes()), "bankInfo");

        mav.addObject("readData", cardMap);

        return mav;
    }


    public String token() throws Exception {
        String comp = "";
        ModelAndView mav = new ModelAndView();

        String urlString = getObject(
                getUrl(URL_TYPE.GET_TOKEN, comp),
                "client_id=t7OBlETHAD",
                "client_secret=eab393de-5ce9-454a-a062-25f08671da54",
                "grant_type=client_credentials"
        );

        URL url = new URL(urlString);
        String returnValue = connectionWebServiceToken(url);

        //읽어온 데이터 파싱하기
        Map<String,String> readMap = getXmlRead(new ByteArrayInputStream(returnValue.getBytes()), "defaultOAuth2AccessToken");

        mav.addObject("readData", readMap);
        String token = "bearer "+readMap.get("value");

        return token;
    }

    public String connectionWebServiceToken(URL url)throws Exception {
        StringBuffer response = new StringBuffer();
        getCommHTTPS("SSL");
        HttpURLConnection urlConnection = (HttpURLConnection)url.openConnection();
        urlConnection.setDoOutput(true);
        urlConnection.setRequestMethod("GET");

        OutputStreamWriter wr = null;
        BufferedReader in = null;
        try {
            getCommHTTPS("SSL");
            wr = new OutputStreamWriter(urlConnection.getOutputStream(), "UTF-8");
            wr.flush();
            String inputLine = null;
            in = new BufferedReader(new InputStreamReader(urlConnection.getInputStream()) );
            while((inputLine = in.readLine()) != null ){
                response.append(inputLine);
            }
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            throw e;
        } finally {
            if( in != null ) in.close();
            if( wr != null ) wr.close();
        }
        return response.toString();
    }

    public String conWebServiceCheckSSO(URL url, String token, String ssoToken)throws Exception {
        StringBuffer response = new StringBuffer();

        HttpsURLConnection urlConnection = (HttpsURLConnection)url.openConnection();
        urlConnection.setDoOutput(true);
        urlConnection.setDoInput(true);
        urlConnection.setUseCaches(false);

        urlConnection.setRequestMethod("GET");
        urlConnection.setRequestProperty("Accept", "application/xml");
        urlConnection.setRequestProperty("Authorization", token);
        urlConnection.setRequestProperty("ssoToken", ssoToken);

        OutputStreamWriter wr = null;
        BufferedReader in = null;

        try {
            getCommHTTPS("SSL");
            wr = new OutputStreamWriter(urlConnection.getOutputStream(), "UTF-8");
            wr.flush();
            String inputLine;
            in = new BufferedReader(new InputStreamReader(urlConnection.getInputStream(), "UTF-8") );

            while((inputLine = in.readLine()) != null ){
                response.append(inputLine);
            }
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            throw e;
        } finally {
            if( in != null ) in.close();
            if( wr != null ) wr.close();
        }
        return response.toString();
    }

    public String conWebService(URL url, String token)throws Exception {
        StringBuffer response = new StringBuffer();

        //HttpURLConnection urlConnection = (HttpURLConnection)url.openConnection();
        
        /* open Https connection */
        TrustManager[] trustAllCerts = new TrustManager[] { new X509TrustManager() {
			public java.security.cert.X509Certificate[] getAcceptedIssuers() {
				return null;
			}

			public void checkClientTrusted(X509Certificate[] certs,
					String authType) {
			}

			public void checkServerTrusted(X509Certificate[] certs,
					String authType) {
			}
		} };
        
        SSLContext sc = SSLContext.getInstance("SSL");
		sc.init(null, trustAllCerts, new java.security.SecureRandom());
        HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
        HttpsURLConnection urlConnection = (HttpsURLConnection)url.openConnection(); 
        
        urlConnection.setDoOutput(true);
        urlConnection.setDoInput(true);
        urlConnection.setUseCaches(false);

        urlConnection.setRequestMethod("GET");
        urlConnection.setRequestProperty("Accept", "application/xml");
        urlConnection.setRequestProperty("Authorization", token);
        
        /* skip verifier */
        urlConnection.setHostnameVerifier(new CustomizedHostNameVerifier());

        InputStreamReader in = null;
        BufferedReader br = null;
        
        try{
            /* request */
            in = new InputStreamReader((InputStream) urlConnection.getContent());
    		br = new BufferedReader(in);

    		String line;
    		while ((line = br.readLine()) != null) {
    			response.append(line).append("\n");
    		}

    		System.out.println(response.toString());
    		br.close();
    		in.close();
    		urlConnection.disconnect();
            
        }catch (Exception e){
        	System.out.println(e);
        }finally{
        	if(null != br){br.close();}
        	if(null != in){in.close();}
        }
        
        return response.toString();
        
        /* OutputStreamWriter wr = null;
        BufferedReader in = null;

        try {
            getCommHTTPS("SSL");
            wr = new OutputStreamWriter(urlConnection.getOutputStream(), "UTF-8");
            wr.flush();
            String inputLine;
            in = new BufferedReader(new InputStreamReader(urlConnection.getInputStream(), "UTF-8") );

            while((inputLine = in.readLine()) != null ){
                response.append(inputLine);
            }
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            throw e;
        } finally {
            if( in != null ) in.close();
            if( wr != null ) wr.close();
        }
        return response.toString();*/
    }

    public String connectionWebService(URL url, String soapXml)throws Exception {
        StringBuffer response = new StringBuffer();
        HttpURLConnection urlConnection = (HttpURLConnection)url.openConnection();
        urlConnection.setDoOutput(true);
        urlConnection.setRequestMethod("POST");
        urlConnection.addRequestProperty("Content-Type", "text/xml");

        OutputStreamWriter wr = null;
        BufferedReader in = null;
        try {
            wr = new OutputStreamWriter(urlConnection.getOutputStream(), "UTF-8");
            wr.write(soapXml.toString());
            wr.flush();
            String inputLine = null;
            in = new BufferedReader(new InputStreamReader(urlConnection.getInputStream()) );
            while((inputLine = in.readLine()) != null ){
                response.append(inputLine.replaceAll("SOAP:", ""));
            }
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            throw e;
        } finally {
            if( in != null ) in.close();
            if( wr != null ) wr.close();
        }
        return response.toString();
    }

    public Map<String,String> getXmlRead(InputStream inputVal, String startNodeName) {
        Map<String,String> retMap = new HashMap<String,String>();

        try {
            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();

            Document doc = dBuilder.parse(inputVal);

            NodeList nList = doc.getElementsByTagName(startNodeName);
            int noteCount = nList.getLength();
            for( int i=0; i<noteCount; i++ ) {
                Element el = (Element) nList.item(i);
                Node title = el.getFirstChild();
                for(Node node = title; node != null; node = node.getNextSibling()){
                    retMap.put(node.getNodeName(), node.getTextContent());
                }
            }
        } catch( Exception e) {
            e.printStackTrace();
        }

        return retMap;
    }

    /*
    ** ssl 인증서 스킵
     */
    private boolean getCommHTTPS(String protocol) {
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
                    return null;
                }

                public void checkClientTrusted(X509Certificate[] certs, String authType) {
                }

                public void checkServerTrusted(X509Certificate[] certs, String authType) {
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
            // TODO Auto-generated catch block
        } catch (KeyManagementException e) {
            // TODO Auto-generated catch block
        }
        return true;
    }

}