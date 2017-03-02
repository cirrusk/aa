package amway.com.academy.manager.common.util;

import java.util.List;
import java.util.Map;
import java.io.IOException;

import javax.servlet.jsp.JspException;

import org.springframework.web.servlet.tags.RequestContextAwareTag;

public class CommonCodeTag  extends RequestContextAwareTag {

	static final long serialVersionUID = -217221500006866921L;

	CommomCodeUtil commomCodeUtil;

	private String type = "";
	private String grpCd = "";
	private String majorCd = "";
	private String relationUpperCd = "";

	private String name = "";
	private String selected = "";
	private String except = "";	
	private String styleClass = "";
	private String style = "";
	private boolean disabled = false;
	private String onclick = "";
	private String reference = "";
	private boolean br = false;
	private int brPerCnt = 1;
	private boolean selectAll = true;
	private String spanStyle = "";
	private String allText = "전체";
	
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	
	public String getGrpCd() {
		return grpCd;
	}
	public void setGrpCd(String grpCd) {
		this.grpCd = grpCd;
	}

	public String getMajorCd() {
		return majorCd;
	}
	public void setMajorCd(String majorCd) {
		this.majorCd = majorCd;
	}
	
	public String getRelationUpperCd() {
		return relationUpperCd;
	}
	public void setRelationUpperCd(String relationUpperCd) {
		this.relationUpperCd = relationUpperCd;
	}

	public String getSelected() {
		return selected;
	}
	public void setSelected(String selected) {
		this.selected = selected;
	}	

	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	public String getExcept() {
		return except;
	}
	public void setExcept(String except) {
		this.except = except;
	}

	public String getStyleClass() {
		return styleClass;
	}
	public void setStyleClass(String styleClass) {
		this.styleClass = styleClass;
	}

	public String getStyle() {
		return style;
	}
	public void setStyle(String style) {
		this.style = style;
	}

	public boolean isDisabled() {
		return disabled;
	}
	public void setDisabled(boolean disabled) {
		this.disabled = disabled;
	}

	public String getOnclick() {
		return onclick;
	}
	public void setOnclick(String onclick) {
		this.onclick = onclick;
	}

	public String getReference() {
		return reference;
	}
	public void setReference(String reference) {
		this.reference = reference;
	}

	public boolean isBr() {
		return br;
	}
	public void setBr(boolean br) {
		this.br = br;
	}

	public boolean isSelectAll() {
		return selectAll;
	}
	public void setSelectAll(boolean selectAll) {
		this.selectAll = selectAll;
	}
	
	public String getSpanStyle() {
		return spanStyle;
	}
	public void setSpanStyle(String spanStyle) {
		this.spanStyle = spanStyle;
	}
	public int getBrPerCnt() {
		return brPerCnt;
	}
	public void setBrPerCnt(int brPerCnt) {
		this.brPerCnt = brPerCnt;
	}
	public String getAllText() {
		return allText;
	}
	public void setAllText(String allText) {
		this.allText = allText;
	}
	
	
	@Override
	public int doStartTagInternal() throws JspException {

		try {
			commomCodeUtil = (CommomCodeUtil) getRequestContext().getWebApplicationContext().getBean(CommomCodeUtil.class);

			if (type == null || ("").equals(type)) {
				return super.doStartTag();
			}

			if (majorCd == null || ("").equals(majorCd)) {
				return super.doStartTag();
			}
			
			StringBuilder html = new StringBuilder();
			boolean viewYn = false;
			String[] exceptValues = null;

			String sMinorCd   = ""; 
			String sMinorText = "";
			String sMajorCd   = majorCd;
			String sExcept    = except;
			
			List<Map<String, String>> list = commomCodeUtil.codeListCommonTag(sMajorCd, sExcept);

			if (except != null && !("").equals(except)) {
				exceptValues = except.split(",");
			}
			int idx = 0;

			if (list != null) {
				if ("option".equals(type)) {
					
					for(int i = 0; i < list.size(); i++){
						viewYn = true;
						sMinorCd = list.get(i).get("minorCd");
						sMinorText = list.get(i).get("cdName");
						
						if (exceptValues != null) {
							for (String value : exceptValues) {
								if (value.equals(sMinorCd ) ) {
									viewYn = false;
								}
							}
						}

						if (viewYn) {
							if(selectAll && idx == 0){
								html.append("<option value=''>" + allText + "</option>");								
							}
							
							html.append("<option value='" + sMinorCd + "'");	
							if (selected.equals(sMinorCd) ) {
								html.append(" selected ");
							}
							html.append(">" + sMinorText + "</option>");
						}
						idx++;
					} // end for
				} 
				
				else if ("print".equals(type)) {
					String tmpValue = "";
					for (int i = 0; i < list.size(); i++) {
						sMinorCd = list.get(i).get("minorCd");
						sMinorText = list.get(i).get("cdName");
						if(selectAll){
							tmpValue = sMinorCd+"|"+ sMinorText;
						} else {
							tmpValue = sMinorText;
						}
						if(i == 0){
							html.append(tmpValue);
						} else {
							html.append("," + tmpValue);
						}
					}
				} 
				else if ("radio".equals(type)) {
					for(int i = 0; i < list.size(); i++){
						viewYn = true;
						sMinorCd = list.get(i).get("minorCd");
						sMinorText = list.get(i).get("cdName");

						if (exceptValues != null) {
							for (String value : exceptValues) {
								if (value.equals(sMinorCd )) {
									viewYn = false;
								}
							}
						}

						if (viewYn) {
							html.append("<input type='radio' name='" + name + "' value='"
									+ sMinorCd + "'");
							html.append(" id='" + name + "_" + majorCd + "_"
									+ sMinorCd + "'");

							if (styleClass != null && !"".equals(styleClass)) {
								html.append(" class='" + styleClass + "'");
							}

							if (style != null && !"".equals(style)) {
								html.append(" style='" + style + "'");
							}

							if (onclick != null && !"".equals(onclick)) {
								html.append(" onclick='" + onclick + "'");
							}

							if (disabled) {
								html.append(" disabled='" + disabled + "'");
							}

							if (selected.equals(sMinorCd )) {
								html.append(" checked ");
							}

							html.append(">");
							
							html.append("&nbsp;<label for='" + name + "_" + majorCd + "_"
									+ sMinorCd + "'>");
							html.append( sMinorText );
							html.append("</label>");

							if (br) {
								html.append("<br />");
							} else {
								html.append("&nbsp;");
							}
						}
					}
				} else if ("checkbox".equals(type)) {
					String[] selectValues = null;
					if (selected != null && !"".equals(selected)) {
						selectValues = selected.split(",");
					}

					for(int i = 0; i < list.size(); i++){
						viewYn = true;
						sMinorCd = list.get(i).get("minorCd");
						sMinorText = list.get(i).get("cdName");

						if (exceptValues != null) {
							for (String value : exceptValues) {
								if (value.equals( sMinorCd )) {
									viewYn = false;
								}
							}
						}

						if (viewYn) {
							if (spanStyle != null && !"".equals(spanStyle)) {
								html.append("<span style='" + spanStyle + "' >");
							}
							html.append("<input type='checkbox' name='" + name + "' value='"
									+ sMinorCd + "'");
							html.append(" id='" + name + "_" + majorCd + "_"
									+ sMinorCd + "'");

							if (styleClass != null && !"".equals(styleClass)) {
								html.append(" class='" + styleClass + "'");
							}

							if (style != null && !"".equals(style)) {
								html.append(" style='" + style + "'");
							}

							if (onclick != null && !"".equals(onclick)) {
								html.append(" onclick='" + onclick + "'");
							}

							if (disabled) {
								html.append(" disabled='" + disabled + "'");
							}

							if (selectValues != null) {
								for (String value : selectValues) {
									if (value.equals(sMinorCd )) {
										html.append(" checked ");
									}
								}
							}

							html.append(">");
							
							html.append("&nbsp;<label for='" + name + "_" + majorCd + "_"
									+ sMinorCd + "'>");
							html.append( sMinorText );
							html.append("</label>");

							if (spanStyle != null && !"".equals(spanStyle)) {
								html.append("</span>");
							}

							if (br) {
								if(brPerCnt > 0 && (i+1) % brPerCnt == 0){
									html.append("<br />");
								} else if(brPerCnt == 0) {
									html.append("<br />");
								}
							} else {
								html.append("&nbsp;");
							}
						}
					}
				}
			}

			pageContext.getOut().write(html.toString());
		} catch (IOException e) {
			throw new JspException(e);
		}
		return SKIP_BODY;
	}
	
}
