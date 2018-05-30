package com.jachin.crud.test;

import com.jachin.crud.mapper.EmployeeMapper;
import com.jachin.crud.po.EmployeeExample;
import org.junit.jupiter.api.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Repository;

/**
 * 测试 dao 层的方法
 */

/**
 * spring Test 测试模块
 * 1.导入 spring-test.jar
 * 2.@ContextConfiguration 指定 spring 配置文件的位置
 * 3.@Autowired 需要指定的模块即可
 */

//指定单元测试使用的模块
//@RunWith(SpringJUnit4ClassRunner.class)
// 指定 spring 配置文件位置，locations 属性接收一个 String[]
//@ContextConfiguration(locations = {"classpath:spring.xml"})
@Repository
public class MapperTest  {
    @Test
    public void testCRUD(){
        ApplicationContext ioc = new
                ClassPathXmlApplicationContext("applicationContext.xml");
        EmployeeMapper employeeMapper = (EmployeeMapper) ioc.getBean("employeeMapper");
        System.out.println(employeeMapper.selectByExample(new EmployeeExample()));

    }
}
