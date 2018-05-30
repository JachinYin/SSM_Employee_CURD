package com.jachin.crud.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.jachin.crud.bean.Msg;
import com.jachin.crud.po.Employee;
import com.jachin.crud.service.EmployeeService;
import org.junit.jupiter.api.Test;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class EmployeeController {

    private EmployeeService employeeServicce = new EmployeeService();

    // 获取所有员工
    @RequestMapping(value = "/emps", method = RequestMethod.GET)
    @ResponseBody
    public Msg listAllWithJSON(@RequestParam(required = false, defaultValue = "1",
            value = "pn")Integer pn){
        PageHelper.startPage(pn,7);
        List<Employee> employees = employeeServicce.getAll();
        PageInfo pageInfo = new PageInfo<>(employees,5);
        return Msg.success().add("pageInfo",pageInfo);
    }

    // 新增员工
    @RequestMapping(value = "/emp", method = RequestMethod.POST)
    @ResponseBody
    public Msg add(@Valid Employee employee, BindingResult result) {
        if (result.hasErrors()) {
            // 校验有失败信息，应该将数据传送到前端去显示出来
            // 使用一个 map 对象来封装发生错误的字段以及对应的信息
            Map<String, Object> map = new  HashMap<>();
            List<FieldError> errors = result.getFieldErrors();
            for(FieldError e: errors){
                map.put(e.getField(),e.getDefaultMessage());
            }
            // 将封装了错误信息的 map 对象传到前端
            return Msg.fail().add("errorInfo",map);
        } else {
            employeeServicce.save(employee);
            return Msg.success();
        }
    }

    // 修改员工
    @RequestMapping(value = "/emp/{empId}", method = RequestMethod.PUT)
    @ResponseBody
    public Msg save(Employee employee){
        employeeServicce.update(employee);
        return Msg.success();
    }

    // 根据 ID 获取员工信息
    @RequestMapping(value = "/emp/{id}", method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmployee(@PathVariable(value = "id")Integer id){
        Employee employee = employeeServicce.getEmp(id);
        return Msg.success().add("emp",employee);
    }

    // 邮箱校验
    @RequestMapping(value = "/checkEamil", method = RequestMethod.GET)
    @ResponseBody
    public Msg checkEmail(@RequestParam(value = "email") String email){
        String regEmail = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$";
        // 后端进行正则表达式判断
        if(!regEmail.matches(email)){
            return Msg.fail().add("isEamil","邮箱格式不正确");
        }

        boolean flag = employeeServicce.isEmail(email);
        if(flag)
            return Msg.fail().add("isEmail", "邮箱已存在");
        else
            return Msg.success();
    }

    // 删除员工
    // 包括单个员工的删除和批量的删除
    @RequestMapping(value = "/emp/{ids}", method = RequestMethod.DELETE)
    @ResponseBody
    public Msg deleteById(@PathVariable("ids") String ids){
        if(ids.contains(",")){
            List<Integer> list = new ArrayList<>();
            String[] str_ids = ids.split(", ");
            for(String id : str_ids){
                list.add(Integer.parseInt(id));
            }
            employeeServicce.deleteEmpBatch(list);
        }else{
            int id = Integer.parseInt(ids);
            employeeServicce.deleteEmp(id);
        }
        return Msg.success();
    }


    @Test
    public void test(){
        String test = "32, 31, 30";
        String[] list = test.split(", ");
        for(String l : list) System.out.println(l);
        System.out.println(employeeServicce);
    }
}
