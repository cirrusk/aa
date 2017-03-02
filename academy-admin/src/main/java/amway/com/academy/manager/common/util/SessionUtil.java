package amway.com.academy.manager.common.util;


import java.io.InputStream;
import java.util.List;
import java.util.Properties;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Controller
@RequestMapping("/manager/common/util")
public class SessionUtil {
	public static String sessionAdno = "sessionAdno";
	public static String sessionApno = "sessionApno";
	
	public String getManagerMenuAuth(RequestBox requestBox, String linkurl) {
		HttpSession session = requestBox.getHttpSession();
		String menuauth = "";
		if(session.getAttribute(sessionAdno) == null || menuauth.equals(session.getAttribute(sessionAdno))){
			// 세션이 없는 경우
			return menuauth;
		}
		
		// 세션이 있는경우
		@SuppressWarnings("unchecked")
		List<DataBox> authList = (List<DataBox>) session.getAttribute("authList");
		if(authList != null){
			for(int i=0;  i<authList.size(); i++){
				DataBox auth = authList.get(i);
				if(linkurl.equals(auth.getString("linkurl"))){
					menuauth = auth.getString("menuauth");
				}
			}
		}
		
		return menuauth;
	}
	
	
}