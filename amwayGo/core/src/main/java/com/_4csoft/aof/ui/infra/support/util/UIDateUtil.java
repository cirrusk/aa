package com._4csoft.aof.ui.infra.support.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.DateUtil;

public class UIDateUtil extends DateUtil {
	
	/**
	 * 날짜를 format String 으로 반환
	 * 
	 * @return String
	 * @throws ParseException 
	 */
	public static String getFormatString(String date, String pattern) throws ParseException {
		if (date == null || "".equals(date)) {
			return null;
		}
		
		SimpleDateFormat formatter = new SimpleDateFormat(Constants.FORMAT_DBDATETIME);
		Date d = formatter.parse(date);
		
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(d);
		
		SimpleDateFormat formatter1 = new SimpleDateFormat(pattern);
		
		return formatter1.format(calendar.getTime());
	}
	
	/**
	 * 날짜를 오늘날짜와 비교
	 * 
	 * @return Boolean
	 * @throws ParseException 
	 */
	public static Boolean getTodayCompareDate(String date) throws ParseException {
		boolean falg = false;
		
		if (date == null || "".equals(date)) {
			return false;
		}
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
		Date d = formatter.parse(date);
		
		Calendar calendar = Calendar.getInstance();
		if(d.after(calendar.getTime())){
			falg = true;
		} 
		
		return falg;
	}
	

}
