package amway.com.academy.common.util;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.io.IOException;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.common.commoncode.service.CommonCodeService;
import sun.misc.Request;

import javax.servlet.http.HttpServletRequest;

@Component
public class CommomCodeUtil  {

	@Autowired
	private CommonCodeService commonCodeService;
	
	public List<Map<String, String>> codeListCommonTag(String grpCd, String majorCd) throws IOException {
		
		Map<String, String> cMap = new HashMap<String, String>();
		cMap.put("majorCd", majorCd); // 유형 : 연구형, 학습형
//		cMap.put("grpCd", grpCd);

		List<Map<String, String>> list = commonCodeService.getCodeList(cMap);

		return list;
	}

	public DataBox getAnalyticsTag(HttpServletRequest request, RequestBox requestBox, String sConn) throws IOException {
		DataBox resultData = new DataBox();
		// 사이트 정보
		String requestUrl = request.getRequestURL().toString();  // WAS서버 URL
		String sProduction = "false";
		String sUrlAccess = "DEV";	// 접속서버URL 위치 - OPER:운영, DEV:개발
		
		if( requestUrl.indexOf("academy.abnkorea.co.kr") >= 0) {
			sProduction = "true";
			sUrlAccess = "OPER";
		}
		if(sConn == null ) {
			sConn = "mobile";
		} else if("".equals(sConn)) {
			sConn = "mobile";
		} else if("PC".equals(sConn)) {
			sConn = "desktop";
		} else {
			sConn = "mobile";
		}

		// 고객정보
		String customerID = "";
		String pinNumber = "";
		String userProfile = "";

		final int distNoLength = 11;
		StringBuffer imcID = new StringBuffer();

		if(null != requestBox && !requestBox.getSession("abono").equals("")) {
			requestBox.put("visitor", request.getSession().getAttribute("abono"));
			DataBox checkVisitor = commonCodeService.getCheckVisitor(requestBox);

			customerID = (null != checkVisitor.get("uid") ) ? checkVisitor.get("uid").toString() : "";
			pinNumber = (null != checkVisitor.get("groups") ) ? checkVisitor.get("groups").toString() : "";
			userProfile = (null != checkVisitor.get("customergubun") ) ? checkVisitor.get("customergubun").toString() : "";
		}

		if(customerID == null || customerID.equals("")) {
			customerID = " ";
			imcID.append(" ");
			pinNumber = " ";
			userProfile = " ";
		} else {
			imcID.append("180"); // Country Code

			for (int i = 0; i < distNoLength - customerID.length(); i++) {
				imcID.append("0");
			}
			imcID.append(customerID);

			if(!pinNumber.equals(""))  {
				pinNumber = pinNumber + ":kr";
			}

			if("M".equals(userProfile)) {
				userProfile = "member"; //member
			} else {
				userProfile = "abo";
			}
		}

		// 접속 페이지 정보
		String conUrl = request.getRequestURI().replaceAll(".do","");
		if("mobile".equals(sConn)){
			conUrl = conUrl.replaceAll("\\/mobile", "");
		}
		
		if( conUrl.equals("/trainingFee/trainingFeeIndex") ) {
			conUrl = requestBox.get("trfeeUrl");
			
			if("mobile".equals(sConn)){
				conUrl = conUrl.replaceAll("\\/mobile", "");
			}
		}		
		
		requestBox.put("conUrl", conUrl);
		DataBox checkResult = commonCodeService.getAnalyticsTag(requestBox);

		String section = "";
		String category = "";
		String subCategory = "";
		String detail = "";

		if(checkResult != null && checkResult.size() > 0) {
			String[] dept = checkResult.get("fullname").toString().split(">");

			int deptLen = dept.length;

			for (int i = 0; i < deptLen; i++) {
				if (i == 0) {
					section = dept[i];
				}
				if (deptLen == 2) {
					if (i == 1) {
						detail = dept[i];
					}
				}
				if (deptLen == 3) {
					if (i == 1) {
						category = dept[i];
					}
					if (i == 2) {
						detail = dept[i];
					}
				}
				if (deptLen == 4) {
					if (i == 1) {
						category = dept[i];
					}
					if (i == 2) {
						subCategory = dept[i];
					}
					if (i == 3) {
						detail = dept[i];
					}
				}
				if (deptLen > 4) {
					if (i == 1) {
						category = dept[i];
					}
					if (i == 2) {
						subCategory = dept[i];
					}
					if (i == 3) {
						detail = dept[i];
					}
					if (i > 3) {
						detail = detail + "," + dept[i];
					}
				}
			}
		}

		resultData.put("isproduction", sProduction);
		resultData.put("type", sConn);
		resultData.put("country", "kr");
		resultData.put("language", "ko");
		resultData.put("currencycode", "krw");
		resultData.put("region", "apac");
		resultData.put("subregion", "korea");
		resultData.put("subgroup", "korea");
		resultData.put("webproperty", "ecm");
		resultData.put("urlaccess", sUrlAccess);

		resultData.put("customerid", customerID);
		resultData.put("imcid", imcID.toString());
		resultData.put("pinNumber", pinNumber);
		resultData.put("userprofile", userProfile);

		resultData.put("section", section);
		resultData.put("category", category);
		resultData.put("subcategory", subCategory);
		resultData.put("detail", detail);

		return resultData;
	}
	
}