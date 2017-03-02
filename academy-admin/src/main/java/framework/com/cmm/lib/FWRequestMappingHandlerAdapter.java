package framework.com.cmm.lib;

import java.util.ArrayList;
import java.util.List;

import org.springframework.web.method.annotation.MapMethodProcessor;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter;

public class FWRequestMappingHandlerAdapter extends RequestMappingHandlerAdapter {
	/**
	 * CommandMapMethodArgumentResolver를 쓰기 위하여
	 * ArgumentResolver list에서 MapMethodProcessor보다 앞에 CommandMapMethodArgumentResolver를 추가한다.
	 * MapMethodProcessor의 기능을 살리기 위해 CommandMapArgument를 쓸 때는 @CommandMap을 붙여야 한다.
	 *
	 * @see CommandMap
	 */
	@Override
	public void afterPropertiesSet() {
		super.afterPropertiesSet();

		if (getArgumentResolvers() != null) {
			//List<HandlerMethodArgumentResolver> resolvers = new ArrayList<HandlerMethodArgumentResolver>(getArgumentResolvers().getResolvers());
			List<HandlerMethodArgumentResolver> resolvers = new ArrayList<HandlerMethodArgumentResolver>(getArgumentResolvers());

			int mapMethodProcessorInx = -1;
			int commandMapInx = -1;
			HandlerMethodArgumentResolver commandMapArgResolver = null;

			for (int inx = 0; inx < resolvers.size(); inx++) {
				HandlerMethodArgumentResolver resolver = resolvers.get(inx);
				if (resolver instanceof MapMethodProcessor) {
					mapMethodProcessorInx = inx;
				} else if (resolver instanceof AnnotationCommandMapArgumentResolver) {
					commandMapInx = inx;
				}
			}

			if (commandMapInx != -1) {
				commandMapArgResolver = resolvers.remove(commandMapInx);
				resolvers.add(mapMethodProcessorInx, commandMapArgResolver);
				setArgumentResolvers(resolvers);
			}
		}
	}
}