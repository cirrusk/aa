package amway.com.academy.lms.common;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Repository;


@Repository("lmsCalendar")
public class LmsCalendar {
	
	public static ArrayList<Map<String,String>> getCalendar( String year, String month ) {
		
		ArrayList<Map<String,String>> calList = new ArrayList<Map<String,String>>(); 
		

			Map<String,String> retMap = new HashMap<String,String>();
			
			Calendar cal = Calendar.getInstance();
			
			int today = cal.get(Calendar.DATE);
			int toyear = cal.get(Calendar.YEAR);
			int tomonth = cal.get(Calendar.MONTH)+1;
			String toyearStr = Integer.toString(toyear);
			String tomonthStr = Integer.toString(tomonth);
			int number10 = 10;
			if(tomonth<number10){
				StringBuffer tempStr = new StringBuffer("0").append(tomonthStr);
				tomonthStr = tempStr.toString();
			}
			int toyearmonth = Integer.parseInt(toyearStr+tomonthStr);
			int yearmonth = Integer.parseInt(year+month);
			
			cal.set(Calendar.YEAR, Integer.parseInt(year));
			cal.set(Calendar.MONTH, Integer.parseInt(month)-1);
			cal.set(Calendar.DATE, 1);
			
			int width = 7; // 배열 가로 넓이
			int startDay = cal.get(Calendar.DAY_OF_WEEK); // 월 시작 요일, 일=1 ~ 토=7
			int lastDay = cal.getActualMaximum(Calendar.DATE); // 월 마지막 날짜
			int inputDate = 1;

			// 2차 배열에 날짜 입력
			int col = 0;
			for(int i=1; inputDate<=lastDay; i++){
				
				retMap.put("weekday_"+col, col + "");
				retMap.put("coursetypeR_"+col, "");
				retMap.put("coursetypeF_"+col, "");
				retMap.put("coursetypeL_"+col, "");
				
				if( i<startDay ) {
					retMap.put("day_"+col, "");
					retMap.put("useyn_"+col, "N");
				} else {
					if( inputDate < number10 ) {
						retMap.put("day_"+col, "0"+ inputDate);
					}else {
						retMap.put("day_"+col, ""+ inputDate);
					}
					
					if(toyearmonth ==  yearmonth){ // 검색달이 현재 달이면
						if( inputDate < today ) { //종료
							retMap.put("useyn_"+col, "E");
						} else if( inputDate == today ) {
							retMap.put("useyn_"+col, "Y"); //오늘
						} else {
							retMap.put("useyn_"+col, "R"); //남은 날
						}
					}else if(toyearmonth <  yearmonth){ // 검색달이 미래 달이면
						retMap.put("useyn_"+col, "R"); //남은 날
					}else{
						retMap.put("useyn_"+col, "E"); //종료
					}

					inputDate++;
				}
				
				col ++;
				
				if(col % width == 0 ) {
					calList.add(retMap);
					col = 0;
					retMap = new HashMap<String,String>();
				}
			}
			
			if( col > 0 ) {
				for(int i=col; i<width; i++) {
					retMap.put("weekday_"+i, i + "");
					retMap.put("day_"+i, "");
					retMap.put("useyn_"+i, "N");
					retMap.put("coursetypeR_"+i, "");
					retMap.put("coursetypeF_"+i, "");
					retMap.put("coursetypeL_"+i, "");
				}
				calList.add(retMap);
			}

		return calList;
	}
}