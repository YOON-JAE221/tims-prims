package com.prims.common.mybatis;

import org.apache.ibatis.reflection.MetaObject;
import org.apache.ibatis.reflection.property.PropertyTokenizer;
import org.apache.ibatis.reflection.wrapper.MapWrapper;

import java.util.Map;

public class CamelCaseMapWrapper extends MapWrapper {

    private final Map<String, Object> map;

    public CamelCaseMapWrapper(MetaObject metaObject, Map<String, Object> map) {
        super(metaObject, map);
        this.map = map; // 이 줄 꼭 필요함!
    }

    @Override
    public String findProperty(String name, boolean useCamelCaseMapping) {
        return underlineToCamel(name);
    }

    @Override
    public void set(PropertyTokenizer prop, Object value) {
        String key = prop.getName();
        map.put(key, value);
    }

    private String underlineToCamel(String key) {
        if (key == null) return null;

        StringBuilder result = new StringBuilder();
        boolean nextUpper = false;

        for (int i = 0; i < key.length(); i++) {
            char c = key.charAt(i);
            if (c == '_') {
                nextUpper = true;
            } else {
                if (result.length() == 0) {
                    // 첫 글자는 무조건 소문자
                    result.append(Character.toLowerCase(c));
                } else {
                    result.append(nextUpper ? Character.toUpperCase(c) : Character.toLowerCase(c));
                }
                nextUpper = false;
            }
        }

        return result.toString();
    }
}
