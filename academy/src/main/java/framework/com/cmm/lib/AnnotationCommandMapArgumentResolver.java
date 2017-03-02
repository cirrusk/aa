package framework.com.cmm.lib;

import java.util.Enumeration;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.core.MethodParameter;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

import egovframework.rte.fdl.property.EgovPropertyService;
import framework.com.cmm.util.StringUtil;

public class AnnotationCommandMapArgumentResolver implements HandlerMethodArgumentResolver {
    /** EgovPropertyService */
    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;
    
	@Override
	public boolean supportsParameter(MethodParameter parameter) {
		if(RequestBox.class.isAssignableFrom(parameter.getParameterType())) {
			return true;
		}
		else {
			return false;
		}
	}
 
	@Override
	public Object resolveArgument(MethodParameter parameter,
			ModelAndViewContainer mavContainer, NativeWebRequest webRequest,
			WebDataBinderFactory binderFactory) throws Exception {
		HttpServletRequest request = (HttpServletRequest)webRequest.getNativeRequest();
		HttpSession session = null;
		RequestBox box = null;
		
		try {
			session = request.getSession(true);
	        box = new RequestBox("requestbox");
	        Enumeration<?> e1 = request.getParameterNames();
	        box.put("reqeustServletName", request.getRequestURI());
	        while(e1.hasMoreElements()) {
	            String key = (String)e1.nextElement();
	            if(request.getParameterValues(key).length == 1) {
	            	box.put(StringUtil.replace(key, "[]", ""), request.getParameter(key));
	            } else {
	            	box.put(StringUtil.replace(key, "[]", ""), request.getParameterValues(key));
	            }
	        }
	        
            box.put("session", session);
            box.put("userip", request.getRemoteAddr());
            box.put("contextPath", request.getContextPath());
        } catch ( Exception ex ) {
            ex.printStackTrace();
        }
		
		return box;
	}
}