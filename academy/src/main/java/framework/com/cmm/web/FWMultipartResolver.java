package framework.com.cmm.web;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import org.apache.commons.fileupload.FileItem;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

public class FWMultipartResolver  extends CommonsMultipartResolver {

	private static final Logger LOGGER = LoggerFactory.getLogger(FWMultipartResolver.class);

	public FWMultipartResolver() {}

    /**
     * 첨부파일 처리를 위한 multipart resolver를 생성한다.
     *
     * @param servletContext
     */
    public FWMultipartResolver(ServletContext servletContext) {
    	super(servletContext);
    }

    /**
     * multipart에 대한 parsing을 처리한다.
     */
    @SuppressWarnings("rawtypes")
	@Override
    protected MultipartParsingResult parseFileItems(List fileItems, String encoding) {

    //스프링 3.0변경으로 수정한 부분
    MultiValueMap<String, MultipartFile> multipartFiles = new LinkedMultiValueMap<String, MultipartFile>();
	Map<String, String[]> multipartParameters = new HashMap<String, String[]>();

	// Extract multipart files and multipart parameters.
	for (Iterator<?> it = fileItems.iterator(); it.hasNext();) {
	    FileItem fileItem = (FileItem)it.next();

	    if (fileItem.isFormField()) {

		String value = null;
		if (encoding != null) {
		    try {
			value = fileItem.getString(encoding);
		    } catch (UnsupportedEncodingException ex) {
		    	LOGGER.warn("Could not decode multipart item '{}' with encoding '{}': using platform default"
		    			, fileItem.getFieldName(), encoding);
			value = fileItem.getString();
		    }
		} else {
		    value = fileItem.getString();
		}
		String[] curParam = multipartParameters.get(fileItem.getFieldName());
		if (curParam == null) {
		    // simple form field
		    multipartParameters.put(fileItem.getFieldName(), new String[] { value });
		} else {
		    // array of simple form fields
		    String[] newParam = StringUtils.addStringToArray(curParam, value);
		    multipartParameters.put(fileItem.getFieldName(), newParam);
		}
	    } else {

		if (fileItem.getSize() > 0) {
		    // multipart file field
		    CommonsMultipartFile file = new CommonsMultipartFile(fileItem);

		    //스프링 3.0 업그레이드 API변경으로인한 수정
		    List<MultipartFile> fileList = new ArrayList<MultipartFile>();
		    fileList.add(file);

		    if (multipartFiles.put(fileItem.getName(), fileList) != null) { // CHANGED!!
		    	throw new MultipartException("Multiple files for field name [" + file.getName() + "] found - not supported by MultipartResolver");
		    }
		    
		    Object [] obj = new Object [4];
		    obj[0]=file.getName();
		    obj[1]=file.getSize();
		    obj[2]=file.getOriginalFilename();
		    obj[3]=file.getStorageDescription();

 			LOGGER.debug  ("Found multipart file [{}] of size {} bytes with original filename [{}], stored {} ", obj);
		}

	    }
	}

	return new MultipartParsingResult(multipartFiles, multipartParameters, null);
    }

}
