package amway.com.academy.manager.common.ldap.web;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.w3c.dom.*;
import org.xml.sax.SAXException;

import framework.com.cmm.lib.RequestBox;

/**
 * -----------------------------------------------------------------------------
 * 
 * @PROJ :AI ECM 1.5 
 * @NAME :LdapController.java
 * @DESC :ldap 관리
 * @Author:김택겸
 * @DATE : 2016-08-31 최초작성
 *      -----------------------------------------------------------------------------
 */

@Controller
@RequestMapping("/manager/common/ldap")
public class LdapController {
	
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LdapController.class);	
	
	public static String connectionWebService(URL url, String soapXml)throws Exception {
		StringBuffer response = new StringBuffer();
		HttpURLConnection urlConnection = (HttpURLConnection)url.openConnection();
		urlConnection.setDoOutput(true);
		urlConnection.setRequestMethod("POST");
		urlConnection.addRequestProperty("Content-Type", "text/xml");
		
		OutputStreamWriter wr = null;
		BufferedReader in = null;
		try {
			wr = new OutputStreamWriter(urlConnection.getOutputStream(), "UTF-8");
			wr.write(soapXml);
			wr.flush();
			String inputLine = null;
			in = new BufferedReader(new InputStreamReader(urlConnection.getInputStream()) );
			while((inputLine = in.readLine()) != null ){
				response.append(inputLine.replaceAll("SOAP:", "").replaceAll("soap:", ""));
			}

LOGGER.debug("ldap return = " + response.toString());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw e;
		} finally {
			if( in != null ){ in.close(); }
			if( wr != null ){ wr.close(); }
		}
		return response.toString();
	}
	
	public static Map<String,String> getXmlRead(InputStream inputVal, String startNodeName) {
		
		Map<String,String> retMap = new HashMap<String,String>();
		
		try {
			DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();

			Document doc = dBuilder.parse(inputVal);
			
			NodeList nList = doc.getElementsByTagName(startNodeName);
			int noteCount = nList.getLength();
		
			for( int i=0; i<noteCount; i++ ) {
				Element el = (Element) nList.item(i);
				
				if( el.getNodeName() != null && el.getFirstChild().getNodeValue() != null ) {
					retMap.put("Authenticated", el.getFirstChild().getNodeValue());
				}
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
}