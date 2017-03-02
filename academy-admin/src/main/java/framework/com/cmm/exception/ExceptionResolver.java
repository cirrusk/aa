package framework.com.cmm.exception;

import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;

/**
 * Servlet implementation class ExceptionResolver
 */
public class ExceptionResolver extends SimpleMappingExceptionResolver {
	/*private static final Logger LOGGER = LoggerFactory.getLogger(ExceptionResolver.class);

	@Autowired
	private CommonService commonService;
	
	@Override
	public ModelAndView resolveException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
		LOGGER.error("#resolveException#ERROR::resolveException::", ex);
		System.out.println("##resolveException#ERROR::resolveException 11 ::" + ex + "::####::" + request.getRequestURI());
		//오류페이지에서 사용할 수 있도록 세팅
		if( request != null){
			request.setAttribute("errorMsg", ex);
		}
		System.out.println("##resolveException#ERROR::resolveException 22 ::" + ex + "::####::" + request.getRequestURI());

		// 예외 클래스에서 오류메세지 추출
		StringBuffer msgBuffer = new StringBuffer();
		StackTraceElement[] ste = ex.getStackTrace();
		for( StackTraceElement e : ste ){
			msgBuffer.append( e.toString() + "\r\n");
		}
		request.setAttribute("stackTrace", msgBuffer.toString());
		String userId = null;
		
		// 세션에서 사용자정보 추출
		HttpSession session = request.getSession();
		if( session != null ){
			AuthVO userInfo = (AuthVO)session.getAttribute( SessionUtils.HRD_SESSION_KEY );
			if( userInfo != null ){
				userId = userInfo.getUserId();
			}
		}		
		
		Map<String, String> params = new HashMap<String, String>();
		params.put("userId", userId == null ? "" : userId );
		params.put("statusCode","500");
		params.put("msg", msgBuffer.toString().substring(0,500));
		commonService.insertErrorLog(params);
		return super.resolveException(request, response, handler, ex);
	}*/
}