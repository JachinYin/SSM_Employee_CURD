package com.jachin.crud.bean;

import java.util.HashMap;
import java.util.Map;

public class Msg {
    // 响应状态码,100-成功，200-失败
    private int statusCode;

    // 响应信息
    private String info;

    // 响应返回给客户端的数据
    private Map<String, Object> extendInfo = new HashMap<>();

    // 设置成功状态码
    public static Msg success(){
        Msg result = new Msg();
        result.setStatusCode(100);
        result.setInfo("成功");
        return result;
    }
    // 设置失败状态码
    public static Msg fail(){
        Msg result = new Msg();
        result.setStatusCode(200);
        result.setInfo("失败");
        return result;
    }

    // 设置添加拓展信息的方法
    public Msg add(String key, Object value){
        this.getExtendInfo().put(key, value);
        return this;
    }

    // setter getter 方法

    public int getStatusCode() {
        return statusCode;
    }

    public String getInfo() {
        return info;
    }

    public Map<String, Object> getExtendInfo() {
        return extendInfo;
    }

    public void setStatusCode(int statusCode) {

        this.statusCode = statusCode;
    }

    public void setInfo(String info) {
        this.info = info;
    }

    public void setExtendInfo(Map<String, Object> extendInfo) {
        this.extendInfo = extendInfo;
    }
}
