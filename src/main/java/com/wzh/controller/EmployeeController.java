package com.wzh.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wzh.bean.Employee;
import com.wzh.bean.Msg;
import com.wzh.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 处理员工crud
 */
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    /**
     * 如果批量删除，多个用‘-’隔开
     * @param empIds
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{empIds}", method = RequestMethod.DELETE)
    public Msg deleteEmp(@PathVariable("empIds") String empIds){
        if(empIds.contains("-")){
            List<Integer> delList = new ArrayList<Integer>();
            String[] ids = empIds.split("-");
            for(String id : ids){
                delList.add(Integer.parseInt(id));
            }
            employeeService.deleteBatch(delList);
        } else {
            int empId = Integer.parseInt(empIds);
            employeeService.deleteEmp(empId);
        }
        return Msg.success();
    }

    /**
     * 如果直接发送ajax type=PUT的请求
     * 封装的数据只有id（Tomcat的问题）
     * PUT请求体中的数据不能用Tomcat拿到，只有POST才封装为MAP请求
     *
     * 解决：
     * 配置Filter，使能读取PUT的封装的数据
     * 作用： 将直接解析的数据封装成map
     *        重新包装request，重写request.getParameter()方法，从自己的map中取数据
     * 员工更新
     * @param employee
     * @return
     */
    @RequestMapping(value = "/emp/{empId}", method = RequestMethod.PUT)
    @ResponseBody
    public Msg saveEmp(Employee employee){
        //System.out.println(employee);
        employeeService.updateEmp(employee);
        return Msg.success();
    }

    /**
     * 根据id查询
     * @param id
     * @return
     */
    @RequestMapping(value = "/emp/{id}", method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("id") Integer id) {
        Employee employee = employeeService.getEmp(id);
        return Msg.success().add("emp", employee);
    }

    /**
     * 检查用户名是否可用
     *
     * @param empName
     * @return
     */
    @ResponseBody
    @RequestMapping("/checkUser")
    public Msg checkUser(@RequestParam("empName") String empName) {
        // 先判断用户名是否合法
        String regx = "^([a-zA-Z0-9_-]{3,16}$)|(^[\\u2E80-\\u9FFF]{2,5})/";
        if (!empName.matches(regx)) {
            return Msg.fail().add("validate_msg", "用户名必须是2-16位！");
        }

        // 数据用户名重复校验
        boolean isValidate = employeeService.checkUser(empName);
        if (isValidate) {
            return Msg.success();
        } else {
            return Msg.fail().add("validate_msg", "用户名不可用！");
        }
    }

    /**
     * 员工保存
     * 1. 支持JSR303
     *
     * @return
     */
    @RequestMapping(value = "/emp", method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid Employee employee, BindingResult result) {
        if (result.hasErrors()) {
            Map<String, Object> map = new HashMap<String, Object>();
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError error : errors) {
                map.put(error.getField(), error.getDefaultMessage());
            }
            return Msg.fail().add("errorFields", map);
        } else {
            employeeService.saveEmp(employee);
            return Msg.success();
        }
    }

    /**
     * 导入jackson
     *
     * @param pn
     * @return
     */
    @RequestMapping("/emps")
    @ResponseBody
    public Msg getEmpsWithJson(@RequestParam(value = "pn", defaultValue = "1") Integer pn) {
        // 100 条，非分页
        // 传入页码和分页大小
        PageHelper.startPage(pn, 10);
        // 紧跟的这个查询就是分页
        List<Employee> emps = employeeService.getAll();
        // 使用PageInfo包装，只要将pageInfo交给页面，传入连续显示的页数
        PageInfo page = new PageInfo(emps, 5);
        return Msg.success().add("pageInfo", page);
    }

    /**
     * 查询员工数据（分页），非json
     *
     * @return
     */
    //@RequestMapping("/emps")
    public String getEmps(@RequestParam(value = "pn", defaultValue = "1") Integer pn, Model model) {
        // 100 条，非分页
        // 传入页码和分页大小
        PageHelper.startPage(pn, 5);
        // 紧跟的这个查询就是分页
        List<Employee> emps = employeeService.getAll();
        // 使用PageInfo包装，只要将pageInfo交给页面，传入连续显示的页数
        PageInfo page = new PageInfo(emps, 5);
        model.addAttribute("pageInfo", page);
        return "list";
    }

}
