package com.wzh.test;

import com.wzh.bean.Department;
import com.wzh.bean.Employee;
import com.wzh.dao.DepartmentMapper;
import com.wzh.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;

/**
 * dao层测试
 * 使用spring的单元测试
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {

    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmployeeMapper employeeMapper;

    @Autowired
    SqlSession sqlSession;

    /**
     * 测试departmentMapper
     */
    @Test
    public void testCRUD(){
//        // 1. create
//        ApplicationContext ioc = new ClassPathXmlApplicationContext("applicationContext.xml");
//        // 2. get mapper
//        DepartmentMapper bean = ioc.getBean(DepartmentMapper.class);
//        System.out.println(departmentMapper);
//        Department department = new Department(null, "设计部");
//        departmentMapper.insertSelective(department);

        // employee
//        employeeMapper.insertSelective(new Employee(null, "Jerry", "M", "Jerry@qq.com", 1));

//        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
//        for(int i = 0; i < 100; i ++ ){
//            String uid = UUID.randomUUID().toString().substring(0, 5) + i;
//
//            mapper.insertSelective(new Employee(null, uid, "", uid + "@qq.com", 1));
//        }
    }
}
