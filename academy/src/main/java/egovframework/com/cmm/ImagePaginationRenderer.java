package egovframework.com.cmm;

import egovframework.rte.ptl.mvc.tags.ui.pagination.AbstractPaginationRenderer;

import javax.servlet.ServletContext;

import org.springframework.web.context.ServletContextAware;
/**
 * ImagePaginationRenderer.java 클래스
 *
 * @author 서준식
 * @since 2011. 9. 16.
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    -------------    ----------------------
 *   2011. 9. 16.   서준식       이미지 경로에 ContextPath추가
 * </pre>
 */
public class ImagePaginationRenderer extends AbstractPaginationRenderer implements ServletContextAware{

	private ServletContext servletContext;

	public ImagePaginationRenderer() {

	}

	public void initVariables(){
		firstPageLabel    = "<a href=\"?pageIndex={1}\" onclick=\"{0}({1});return false; \" class='prevnext'>&lt;&lt;</a>&#160;";
        previousPageLabel = "<a href=\"?pageIndex={1}\" onclick=\"{0}({1});return false; \" class='prevnext'>&lt;&nbsp&nbsp</a>&#160;";
        currentPageLabel  = "<span class=\"list\"><a href=\"#\" class='on'><strong>{0}</strong></a>&#160;</span>";
        otherPageLabel    = "<span class=\"list\"><a href=\"?pageIndex={1}\" onclick=\"{0}({1});return false; \">{2}</a>&#160;</span>";
        nextPageLabel     = "<a href=\"?pageIndex={1}\" onclick=\"{0}({1});return false; \" class='prevnext'>&nbsp&nbsp&gt;</a>&#160;";
        lastPageLabel     = "<a href=\"?pageIndex={1}\" onclick=\"{0}({1});return false; \" class='prevnext'>&gt;&gt;</a>&#160;";
	}



	@Override
	public void setServletContext(ServletContext servletContext) {
		this.servletContext = servletContext;
		initVariables();
	}

}
