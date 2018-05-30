package com.jachin.crud.controller;

import com.jachin.crud.bean.Msg;
import com.jachin.crud.po.Department;
import com.jachin.crud.service.DepartmentService;
import org.junit.jupiter.api.Test;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class DepartmentControllor {
    private DepartmentService departmentService = new DepartmentService();

    @RequestMapping("/depts")
    @ResponseBody
    public Msg getAll(){
        List<Department> list = departmentService.getAll();
        System.out.println(list);
        return Msg.success().add("depts",list);
    }

    @Test
    public void test(){
        System.out.println(departmentService.getAll());
    }
}
