package framework.com.cmm.common.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;

import framework.com.cmm.lib.RequestBox;

@Controller
public class CommonController {
    @ModelAttribute("requestBox")
	public RequestBox getRequestBox(RequestBox requestBox) {
		return requestBox;
	}
}