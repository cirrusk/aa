package framework.com.cmm.web;

import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.web.servlet.view.document.AbstractExcelView;

public class ExcelDownloadView extends AbstractExcelView {
	 
	 /**
	 * @DESC  :엑셀 다운로드
	 *
	 * @param model
	 * @param workbook
	 * @param req
	 * @param res
	 * @throws Exception
	 */
	@Override
	protected void buildExcelDocument(Map<String, Object> model, HSSFWorkbook workbook, HttpServletRequest req, HttpServletResponse res) throws Exception {
	 
	      	  String filename;
	      	  String type = (String)model.get("type");
	      	  if (type!= null && type.equals("xlsx")){
	      		  XSSFWorkbook wb = (XSSFWorkbook)model.get("workbook");
		      	  
		          filename = java.net.URLEncoder.encode( (String)model.get("fileName") , "UTF-8");
	
		          // TODO Auto-generated catch block
	
		          res.setHeader("Content-Disposition", "attachment;filename=" + filename + ";");
		          res.setHeader("Content-Type","application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;");
	
		          ServletOutputStream fs;
		          fs = res.getOutputStream();
		          wb.write(fs);
	      	  }
	      	  else {
		      	  HSSFWorkbook wb = (HSSFWorkbook)model.get("workbook");
		      	  
		          filename = java.net.URLEncoder.encode( (String)model.get("fileName") , "UTF-8");
	
		          // TODO Auto-generated catch block
	
		          res.setHeader("Content-Disposition", "attachment;filename=" + filename + ";");
		          res.setHeader("Content-Type","application/vnd.ms-excel;");
	
		          ServletOutputStream fs;
		          fs = res.getOutputStream();
		          wb.write(fs);
	      	  }

	}

}
