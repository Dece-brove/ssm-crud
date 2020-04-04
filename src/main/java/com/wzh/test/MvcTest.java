package com.wzh.test;

import com.github.pagehelper.PageInfo;
import com.wzh.bean.Employee;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MockMvcBuilder;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;

/**
 * Spring测试模块的测试请求
 */
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"classpath:applicationContext.xml", "file:src/main/webapp/WEB-INF/dispatcherServlet-servlet.xml"})
public class MvcTest {
    // 传入SpringMvc的ioc
    @Autowired
    WebApplicationContext context;

    // 虚拟Mvc请求
    MockMvc mockMvc;

    @Before
    public void initMockMvc() {
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Test
    public void testPage() throws Exception {
        // get return
        MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pn", "5")).andReturn();

        // after success request scope has a page info
        MockHttpServletRequest request = result.getRequest();
        PageInfo pageInfo = (PageInfo) request.getAttribute("pageInfo");
        System.out.println("current page is " + pageInfo.getPageNum());
        System.out.println("total page is " + pageInfo.getPages());
        System.out.println("total item number is " + pageInfo.getTotal());
        System.out.println("series pages are ");
        int[] pages = pageInfo.getNavigatepageNums();
        for(Integer page : pages){
            System.out.print(page + " ");
        }
        System.out.println();

        // get employee information
        List<Employee> employees = pageInfo.getList();
        for(Employee employee : employees){
            System.out.println(employee);
        }
    }
}
