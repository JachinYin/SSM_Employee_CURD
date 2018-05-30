package com.jachin.crud.service;

import com.jachin.crud.mapper.EmployeeMapper;
import com.jachin.crud.po.Employee;
import com.jachin.crud.po.EmployeeExample;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
public class EmployeeService {
    private ApplicationContext ioc = new
            ClassPathXmlApplicationContext("applicationContext.xml");
    @Autowired
    private EmployeeMapper employeeMapper;

    public List<Employee> getAll() {
        employeeMapper = (EmployeeMapper) ioc.getBean("employeeMapper");
        EmployeeExample employeeExample = new EmployeeExample();
        employeeExample.setOrderByClause("emp_Id");
        List<Employee> employees = employeeMapper.selectByExampleWithDept(employeeExample);
        return employees;
    }

    // 新增员工
    public void save(Employee employee) {
        employeeMapper.insertSelective(employee);
    }

    // 修改员工
    public void update(Employee employee){
        employeeMapper.updateByPrimaryKeySelective(employee);
    }

    public boolean isEmail(String email){
        boolean flag = true;
        EmployeeExample employeeExample = new EmployeeExample();
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        criteria.andEmailEqualTo(email);
        if(employeeMapper.countByExample(employeeExample)==0) flag=false;
        return flag;
    }

    public Employee getEmp(Integer id){
        Employee employee = employeeMapper.selectByPrimaryKey(id);
        return employee;
    }

    // 单个删除
    public void deleteEmp(Integer id) {
        employeeMapper.deleteByPrimaryKey(id);
    }
    // 批量删除
    public void deleteEmpBatch(List<Integer> ids) {
        EmployeeExample employeeExample = new EmployeeExample();
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        criteria.andEmpIdIn(ids);
        employeeMapper.deleteByExample(employeeExample);
    }
}
