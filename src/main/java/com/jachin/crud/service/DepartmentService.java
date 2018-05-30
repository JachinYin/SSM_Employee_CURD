package com.jachin.crud.service;

import com.jachin.crud.mapper.DepartmentMapper;
import com.jachin.crud.po.Department;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.List;

public class DepartmentService {

    // TODO 注入为null
    private ApplicationContext ioc = new
            ClassPathXmlApplicationContext("applicationContext.xml");

    @Autowired
    private DepartmentMapper departmentMapper = (DepartmentMapper) ioc.getBean("departmentMapper");

    public List<Department> getAll(){
        List<Department> list = departmentMapper.selectByExample(null);
        return list;
    }

}
