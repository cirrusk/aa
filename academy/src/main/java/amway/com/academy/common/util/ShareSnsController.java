package amway.com.academy.common.util;

import java.net.URLDecoder;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * <pre>
 * </pre>
 * Program Name  : ShareSnsController.java
 * Author : KR620207
 * Creation Date : 2016. 11. 24.
 */
@Controller
@RequestMapping("/framework/com")
public class ShareSnsController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ShareSnsController.class);

	/**
	 * <pre>
	 *   facebook share
	 * </pre>
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/shareSnsFacebook.do")
	public String shareSnsFacebook(HttpServletRequest request, ModelMap model) throws Exception {
		
		String title       = request.getParameter("title");
		String url         = request.getParameter("url");
		String image       = request.getParameter("image");
		String description = request.getParameter("description");
		
		title = URLDecoder.decode(title, "UTF-8");
		url = URLDecoder.decode(url, "UTF-8");
		image = URLDecoder.decode(image, "UTF-8");
		description = URLDecoder.decode(description, "UTF-8");
		
		model.addAttribute("siteName",    "ABN KOREA");
		model.addAttribute("title",       title);
		model.addAttribute("url",         url);
		model.addAttribute("image",       image);
		model.addAttribute("description", description);
		
		return "/framework/com/cmm/shareSnsFacebook";
	}
	
}
