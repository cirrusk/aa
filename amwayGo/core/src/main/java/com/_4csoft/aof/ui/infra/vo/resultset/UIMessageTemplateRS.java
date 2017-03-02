package com._4csoft.aof.ui.infra.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIMessageTemplateVO;

public class UIMessageTemplateRS  extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private UIMessageTemplateVO template;

	public UIMessageTemplateVO getTemplate() {
		return template;
	}

	public void setTemplate(UIMessageTemplateVO template) {
		this.template = template;
	}

}
