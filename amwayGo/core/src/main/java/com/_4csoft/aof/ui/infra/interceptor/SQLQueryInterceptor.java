package com._4csoft.aof.ui.infra.interceptor;

import java.lang.reflect.Method;
import java.sql.Statement;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.ibatis.executor.statement.StatementHandler;
import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.mapping.ParameterMapping;
import org.apache.ibatis.plugin.Interceptor;
import org.apache.ibatis.plugin.Intercepts;
import org.apache.ibatis.plugin.Invocation;
import org.apache.ibatis.plugin.Plugin;
import org.apache.ibatis.plugin.Signature;
import org.apache.ibatis.session.ResultHandler;

import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.LogUtil;
import com._4csoft.aof.infra.vo.base.BaseVO;
import com._4csoft.aof.infra.vo.base.SearchConditionVO;

/**
 * 
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.infra.interceptor
 * @File : SQLQueryInterceptor.java
 * @Title : 쿼리 수행 속도 및 이력 체크
 * @date : 2014. 3. 5.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Intercepts ({ @Signature (type = StatementHandler.class, method = "update", args = { Statement.class }),
		@Signature (type = StatementHandler.class, method = "query", args = { Statement.class, ResultHandler.class }) })
public class SQLQueryInterceptor implements Interceptor {

	protected final LogUtil logger = new LogUtil("SQL_LOGGER");

	@SuppressWarnings ("rawtypes")
	public Object intercept(Invocation invocation) throws Throwable {
		long utrKey = Thread.currentThread().getId();

		long startTime, endTime, executeTime;
		startTime = System.currentTimeMillis();

		StatementHandler handler = (StatementHandler)invocation.getTarget();

		BoundSql boundSql = handler.getBoundSql();
		String sql = boundSql.getSql();

		String sqlType = invocation.getMethod().getName();
		List<ParameterMapping> paramMapping = boundSql.getParameterMappings();
		Object param = handler.getParameterHandler().getParameterObject();
		String propValue = "";
		String paramString = "";

		for (ParameterMapping mapping : paramMapping) {
			propValue = mapping.getProperty();
		}

		if (param == null) {
			paramString = "null";
			sql = sql.replaceFirst("\\?", "''");
		} else {
			if (param instanceof Integer || param instanceof Float || param instanceof Double || param instanceof Long) {
				paramString = propValue + " : " + param;
				sql = sql.replaceFirst("\\?", param.toString());
			} else if (param instanceof String) {
				paramString = propValue + " : " + "'" + param + "'";
				sql = sql.replaceFirst("\\?", "'" + param + "'");
			} else if (param instanceof Map) {
				paramString = param.toString();
				for (ParameterMapping mapping : paramMapping) {
					propValue = mapping.getProperty();
					Object value = ((Map)param).get(propValue);
					if (value instanceof String) {
						sql = sql.replaceFirst("\\?", "'" + value + "'");
					} else {
						sql = sql.replaceFirst("\\?", value.toString());
					}
				}
			} else if (param instanceof BaseVO || param instanceof SearchConditionVO) {
				paramString = param.getClass().getName();
				Class cls = null;
				for (ParameterMapping mapping : paramMapping) {
					String fieldName = mapping.getProperty();
					try {
						cls = searchClass(Class.forName(param.getClass().getName()), fieldName);

						String getMethod = "get" + fieldName.substring(0, 1).toUpperCase() + fieldName.substring(1, fieldName.length());

						Method method = cls.getDeclaredMethod(getMethod, new Class[] {});

						Object value = method.invoke(param, new Object[0]);
						if (value != null) {
							paramString = paramString + ", " + fieldName + ":" + value.toString();

							if (value instanceof String) {
								sql = sql.replaceFirst("\\?", "'" + value + "'");
							} else {
								sql = sql.replaceFirst("\\?", value.toString());
							}

						} else {
							paramString = paramString + ", " + fieldName + ": null";
							sql = sql.replaceFirst("\\?", "null");
						}

					} catch (Exception e) {
						logger.debug("getMethod Error");
						e.printStackTrace();
					}
				}

			}
		}

		Object result = invocation.proceed();
		endTime = System.currentTimeMillis();
		executeTime = endTime - startTime;

		Pattern pattern = Pattern.compile("/\\*\\s+(\\w+\\.\\w+)\\s+\\*/");
		Matcher matcher = pattern.matcher(sql);
		String queryId = "";
		if (matcher.find()) {
			queryId = matcher.group(1);
		}

		// sqlType|ThreadId|queryId|parameter|startTime|endTime|executeTime\nsql
		StringBuffer buffer = new StringBuffer();
		buffer.append(sqlType);
		buffer.append("|" + utrKey);
		buffer.append("|" + queryId);
		buffer.append("|" + paramString);
		buffer.append("|" + DateUtil.getFormatString(startTime, "yyyy-MM-dd HH:mm:ss.SSS"));
		buffer.append("|" + DateUtil.getFormatString(endTime, "yyyy-MM-dd HH:mm:ss.SSS"));
		buffer.append("|" + executeTime + " milliseconds");
		buffer.append("\n" + sql);

		logger.info(buffer.toString());
		return result;
	}

	public Object plugin(Object target) {
		return Plugin.wrap(target, this);
	}

	public void setProperties(Properties properties) {

	}

	/**
	 * 상속 받은 클래스를 까지 찾아서 해당 필드의 Getter Method가 있는 Class
	 * 
	 * @param cls
	 * @param fieldName
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings ("rawtypes")
	private Class searchClass(Class cls, String fieldName) throws Exception {
		Class modelCls = null;
		String getMethod = "get" + fieldName.substring(0, 1).toUpperCase() + fieldName.substring(1, fieldName.length());
		try {
			modelCls = cls;
			cls.getDeclaredMethod(getMethod, new Class[] {});
		} catch (NoSuchMethodException nsme) {
			try {
				modelCls = cls.getSuperclass();
				cls.getDeclaredMethod(getMethod, new Class[] {});
			} catch (NoSuchMethodException name) {
				if (cls.getSuperclass() != null) {
					modelCls = searchClass(cls.getSuperclass(), fieldName);
				} else {
					return null;
				}
			}
		}
		return modelCls;
	}

}
