package com.cyl.manage.user;

import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import com.cyl.manage.core.entity.Evaluation;
import com.cyl.manage.system.dao.UserDao;
import com.cyl.manage.system.entity.User;
import com.cyl.manage.system.service.SystemService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractJUnit4SpringContextTests;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import com.google.common.collect.Lists;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"classpath*:spring-context.xml"})
public class UserDeviceTest extends AbstractJUnit4SpringContextTests {


	@Autowired
	private UserDao uesrDao ;

	@Test
	public void test(){
		User user = uesrDao.get("1");
		System.out.println(user.getRoleList().size());
	}

	@Test
	public void evaTest(){
		List<Evaluation> list = Lists.newArrayList() ;
		Evaluation e1 = new Evaluation() ;
		e1.setScore(50);
		Evaluation e2 = new Evaluation() ;
		e2.setScore(60);
		list.add(e1) ; list.add(e2);
		/***********************/
		List<Integer> scoreList = list.stream().map(Evaluation::getScore).collect(Collectors.toList());
		List<Evaluation> rtnList = Lists.newArrayList() ;
		list.stream().forEach(e -> {
			long ranking =   scoreList.stream().filter(score -> e.getScore() < score).count();
			System.out.println("rank : "+ranking);
			e.setRanking(ranking == 0 ?1:((int)ranking +1) );
			System.out.println("e rank : "+e.getRanking());
			rtnList.add(e);
		});
	}

	@Test
	public void test3(){

		System.out.println("just test");
		try {
			System.out.println("just test 2");
			int i = 2/0 ;
			System.out.println(" okok");
		} catch (Exception e) {
			System.out.println("just test 3");
			System.out.println(e.getMessage());
			System.out.println("just test 4");
		}
		System.out.println("final");
	}
	
	
	
}
