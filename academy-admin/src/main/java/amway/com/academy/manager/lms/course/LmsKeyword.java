package amway.com.academy.manager.lms.course;

import java.util.HashMap;
import java.util.Map;

public class LmsKeyword {

	public Map<String,String> lmsKeywordUrl(String courseType , int categoryId)
	{	
		Map<String,String> url = new HashMap<String, String>();
		
		int check1 = 1;
		int check2 = 2;
		int check3 = 3;
		int check4 = 4;
		int check5 = 5;
		int check6 = 6;
		int check7 = 7;
		int check8 = 8;
		int check9 = 9;
		int check10 = 10;
		int check11 = 11;
		int check12 = 12;
		int check13 = 13;
		int check14 = 14;
		int check15 = 15;
		int check16 = 16;
		
		//정규과정
		if(courseType.equals("R"))
		{
			url.put("academyUrl","/lms/request/lmsCourseView.do");
			url.put("hybrisUrl","/lms/request/lmsCourseView");
		}
		//오프라인 과정
		else if(courseType.equals("F"))
		{
			url.put("academyUrl", "/lms/request/lmsOfflineView.do");
			url.put("hybrisUrl", "/lms/request/lmsOfflineView");
		}
		//라이브 과정
		else if(courseType.equals("L"))
		{
			url.put("academyUrl", "/lms/request/lmsLiveView.do");
			url.put("hybrisUrl", "/lms/request/lmsLiveView");
		}
		//온라인강의
		else if(courseType.equals("O"))
		{
				if(categoryId == check1)
				{
					url.put("academyUrl", "/lms/online/lmsOnlineBiz.do");
					url.put("hybrisUrl", "/lms/online/lmsOnlineBiz"); 
				}
				else if (categoryId == check2) {			
					url.put("academyUrl", "/lms/online/lmsOnlineBizSolution.do");
					url.put("hybrisUrl", "/lms/online/lmsOnlineBizSolution"); 
				}
				else if (categoryId == check3) {
					url.put("academyUrl", "/lms/online/lmsOnlineNutrilite.do");
					url.put("hybrisUrl", "/lms/online/lmsOnlineNutrilite"); 
				}
				else if(categoryId == check4)
				{
					url.put("academyUrl", "/lms/online/lmsOnlineArtistry.do");
					url.put("hybrisUrl", "/lms/online/lmsOnlineArtistry");
				}
				else if(categoryId == check5)
				{
					url.put("academyUrl", "/lms/online/lmsOnlineHomeliving.do");
					url.put("hybrisUrl", "/lms/online/lmsOnlineHomeliving");
				}
				else if(categoryId == check6)
				{
					url.put("academyUrl", "/lms/online/lmsOnlinePersonalcare.do");
					url.put("hybrisUrl", "/lms/online/lmsOnlinePersonalcare");
				}
				else if(categoryId == check7)
				{
					url.put("academyUrl", "/lms/online/lmsOnlineRecipe.do");
					url.put("hybrisUrl", "/lms/online/lmsOnlineRecipe");
				}
				else if(categoryId == check8)
				{
					url.put("academyUrl", "/lms/online/lmsOnlineHealthNutrition.do");
					url.put("hybrisUrl", "/lms/online/lmsOnlineHealthNutrition");
				}
				
		}
		//교육자료
		else if (courseType.equals("D")) {
			
			url.put("academyUrl","/lms/eduResource/lmsEduResourceView.do");
			
			if(categoryId == check9)
			{
				url.put("hybrisUrl", "/lms/eduResource/lmsEduResourceBiz?listCategoryCode="+categoryId);
			}
			else if(categoryId == check10)
			{
				url.put("hybrisUrl", "/lms/eduResource/lmsEduResourceNutrilite?listCategoryCode="+categoryId);
			}
			else if(categoryId == check11)
			{
				url.put("hybrisUrl", "/lms/eduResource/lmsEduResourceArtistry?listCategoryCode="+categoryId);
			}
			else if(categoryId == check12)
			{
				url.put("hybrisUrl", "/lms/eduResource/lmsEduResourcePersonalcare?listCategoryCode="+categoryId);
			}
			else if(categoryId == check13)
			{
				url.put("hybrisUrl", "/lms/eduResource/lmsEduResourceHomeliving?listCategoryCode="+categoryId);
			}
			else if(categoryId == check14)
			{
				url.put("hybrisUrl", "/lms/eduResource/lmsEduResourceRecipe?listCategoryCode="+categoryId);
			}
			else if(categoryId == check15)
			{
				url.put("hybrisUrl", "/lms/eduResource/lmsEduResourceHealthNutrition?listCategoryCode="+categoryId);
			}
			else if(categoryId == check16)
			{
				url.put("hybrisUrl", "/lms/eduResource/lmsEduResourceMusic?listCategoryCode="+categoryId);
			}
			
		}
		
		return url;
	}
}
