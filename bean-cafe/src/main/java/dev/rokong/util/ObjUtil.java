package dev.rokong.util;

import java.util.List;
import java.util.Map;

/**
 * util of List
 * @see java.util.List
 */
public class ObjUtil {

    /**
     * check Map<?, ?> is empty
     * @param map to be verified Map
     * @return if return true, parameter is empty
     */
    public static boolean isEmpty(Map<?, ?> map){
        return map == null || map.size() == 0;
    }

    /**
     * check Map<?, ?> is empty
     * @param map to be verified Map
     * @return if return true, parameter is not empty
     * @see #isEmpty(Map)
     */
    public static boolean isNotEmpty(Map<?, ?> map){
        return !isEmpty(map);
    }

    /**
     * check List<?> is empty
     * @param list to be verified List
     * @return if return true, parameter is empty
     */
    public static boolean isEmpty(List<?> list){
        return list == null || list.size() == 0;
    }

    /**
     * check List<?> is empty
     * @param list to be verified List
     * @return if return true, parameter is not empty
     * @see #isEmpty(List)
     */
    public static boolean isNotEmpty(List<?> list){
        return !isEmpty(list);
    }

    /**
     * check T[] array is empty
     * 
     * @param <T> array element's class
     * @param array to be verifed array
     * @return return true if array is empty
     */
    public static <T> boolean isEmpty(T[] array){
        return array == null || array.length == 0;
    }

    /**
     * check T[] array is not empty
     * 
     * @param <T> array element's class
     * @param array to be verifed array
     * @return return true if array is not empty
     * @see #isEmpty(Object[])
     */
    public static <T> boolean isNotEmpty(T[] array){
        return !isEmpty(array);
    }

    /**
     * check String is empty
     * 
     * @param string to be verified string
     * @return if return true, parameter is empty
     */
    public static boolean isEmpty(String string){
        return string == null || "".equals(string);
    }

    /**
     * check String is not empty
     * 
     * @param string to be verified string
     * @return if return true, parameter is not empty
     * @see #isEmpty(String)
     */
    public static boolean isNotEmpty(String string){
        return !isEmpty(string);
    }

    /**
     * check Integer is defined
     * @param integer to be verified Integer
     * @return if return true, parameter is defined
     */
    public static boolean isEmpty(Integer integer){
        return integer == null;
    }

    /**
     * check Integer is defined
     * @param integer to be verified Integer
     * @return if return true, parameter is not defined
     */
    public static boolean isNotEmpty(Integer integer){
        return !isEmpty(integer);
    }
}