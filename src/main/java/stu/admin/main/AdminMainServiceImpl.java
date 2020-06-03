package stu.admin.main;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import stu.common.common.CommandMap;

@Service("adminMainService")
public class AdminMainServiceImpl implements AdminMainService {
	
	Logger log = Logger.getLogger(this.getClass()); // 로그
	
	@Resource(name="adminDao")
	private AdminDao adminDao;

	@Override
	public List<Map<String, Object>> dashBoard(CommandMap map) throws Exception { //adminMain대쉬보드
		// TODO Auto-generated method stub
		return adminDao.dashBoard(map);
	}
	
	@Override
	public List<Map<String, Object>> order_admin_a(CommandMap map) throws Exception { //주문/배송-신규주문
		// TODO Auto-generated method stub
		return adminDao.order_admin_a(map);
	}

}
