/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.web;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.net.URLEncoder;
import java.security.KeyManagementException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.cert.X509Certificate;
import java.util.HashMap;
import java.util.Map;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.springframework.web.servlet.ModelAndView;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;


/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UtilApi.java
 * @Title : UtilApi
 * @date : 
 * @author : 
 * @descrption : AmwayGO ABO넘버 회원인증
 */
public class UtilApi {
	
    /* name : AmwayGO 회원인증 .
    ** param : user id , password
    */
    public String checkUser(String userId, String userPass) throws Exception {
        String result = "";
        String urlCheck = "https://qa2.abnkorea.co.kr/rest/customers/auth";
        System.out.println("====================> getUrl 출력 : " + urlCheck);
        
        URL getUrl = new URL("https://qa2.abnkorea.co.kr/rest/customers/auth");	//dev2->dev서버, qa2->qa서버, apihub->agp운영서버
        String token = token();
        
        String ecmSalt = "hybris blue pepper can be used to prepare delicious noodle meals";
        String delimiter = "::";

        // hybris blue pepper can be used to prepare delicious noodle meals::05050101::7480003
        String plaintext = ecmSalt + delimiter + userPass + delimiter + userId;
        System.out.println("=====================> Plaintext 출력 : " + plaintext);

        String enPass = encodingSHA256(plaintext);

        String urlString = getObject(getUrl, userId, enPass, "checkUser");

        URL url = new URL(urlString);
        String userInfo = conWebService(url, token);

        //읽어온 데이터 파싱하기
        Map<String,String> userInfoMap = getXmlRead(new ByteArrayInputStream(userInfo.getBytes()), "Response");

        System.out.println(userInfoMap);
        result = userInfoMap.get("result");

        return result;
    }
    
    public String token() throws Exception {
        URL getUrl = new URL("https://qa2.abnkorea.co.kr/rest/oauth/token");	//dev2->dev서버, qa2->qa서버, apihub->agp운영서버
        ModelAndView mav = new ModelAndView();

        String urlString = getTokenObject(
        		getUrl,
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

    
    // token 호출 용.
    public String getTokenObject(URL url, String ... queryArgs)  throws Exception {

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
    
    
    // token을 가져온다.
    public String connectionWebServiceToken(URL url)throws Exception {
        StringBuffer response = new StringBuffer();
        getCommHTTPS("SSL");
        HttpsURLConnection urlConnection = (HttpsURLConnection)url.openConnection();
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
    
    // 단건의 xml 을 가져온다.
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
    
    public String encodingSHA256(String str) {
        String sha = "";
        try {
            MessageDigest sh = MessageDigest.getInstance("SHA-256");
            sh.update(str.getBytes());
            byte byteData[] = sh.digest();
            StringBuffer sb = new StringBuffer();
            for(int i=0; i<byteData.length; i++){
                sb.append(Integer.toString((byteData[i]&0xff) + 0x100, 16).substring(1));
            }
            sha = sb.toString();
        } catch(NoSuchAlgorithmException e) {
            //e.printStackTrace();
            System.out.println("Encrypt Error - NoSuchAlgorithmException");
            sha = null;
        }
        return sha;
    }
    
    public String getObject(URL url, String valueOne, String valueTwo, String type) throws Exception {
        String urlString = url.toString() + "/" + valueOne;

        if(type.equals("checkUser")) {
            urlString = urlString + "?customerPwd=" + valueTwo;
        } else {
            urlString = urlString + "/" + valueTwo;
        }

        return urlString;
    }
    
    // token 값을 HTTP Header 에 얻어서 보내, 원하는 데이터를 가져온다.
    public String conWebService(URL url, String token)throws Exception {
        StringBuffer response = new StringBuffer();
        getCommHTTPS("SSL");
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

        } catch(Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } finally {
            if(null != br){br.close();}
            if(null != in){in.close();}
        }

        return response.toString();
    }
}
