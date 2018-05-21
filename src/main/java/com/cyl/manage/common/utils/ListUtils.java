package com.cyl.manage.common.utils;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import com.google.common.collect.Lists;

public class ListUtils {
     
	/**
	 * 
	 * @author  xuchang
	 * @Description  求两个集合的交集,集合中的元素类型必须继承了Comparable接口 
	 * @param list
	 * @param lis
	 * @return
	 */
	 public  <T extends Comparable<T>> List<T> getintersection(List<T> list ,List<T> lis){
		 List<T> li = Lists.newArrayList();
		 if(null != list && 0 != list.size()){
			 if(null != lis && 0 != list.size()){
				 for(T l :list){
					 for(T ls : lis){
						if(0==l.compareTo(ls)){
							li.add(l);
							break;
						}
					 }
				 }
			 }else{
				 return list;
			 }
		 }else if(null != lis && 0 != lis.size()){
			 return lis;
		 }
		 return li;
	 }
	
	 /**
	  * 
	  * @author  xuchang
	  * @Description 求两个集合的交集,comp是该元素实现Comparator接口的类
	  * @param list
	  * @param lis
	  * @param comp
	  * @return
	  */
	 public  <T> List<T> getintersection(List<T> list ,List<T> lis,Comparator<T> comp){
		 List<T> li = Lists.newArrayList();
		 if(null != list && 0 != list.size()){
			 if(null != lis && 0 != list.size()){
				 for(T l :list){
					 for(T ls : lis){
						if(0 == comp.compare(l, ls)){
							li.add(l);
						}
					 }
				 }
			 }else{
				 return list;
			 }
		 }else if(null != lis && 0 != lis.size()){
			 return lis;
		 }
		 return  li;
	 }
     
	 /**
	  * 
	  * @author  xuchang
	  * @Description 求两个集合的并集,集合中的元素类型必须继承了Comparable接口  
	  * @param list
	  * @param lis
	  * @return
	  */
	 public <T extends Comparable<T>> List<T> getUnionList(List<T> list,List<T> lis){
		 List<T> li = Lists.newArrayList();
		 if(null != list && 0 != list.size()){
			 if(null != lis && 0 != list.size()){
				 Set<T> set = new TreeSet<T>();
				 for(T l :list){
					 set.add(l);
				 }
				 for(T ls : lis){
					 set.add(ls);
				 }
				 Iterator<T> it = set.iterator();
				 while(it.hasNext()){
					 T t = it.next();
					 li.add(t);
				 }
			 }else{
				 return list;
			 }
		 }else if(null != lis && 0 != lis.size()){
			 return lis;
		 }
		 return li;
	 }
	 
	 /**
	  * 
	  * @author  xuchang
	  * @Description 求两个集合的并集,comp是该元素实现Comparator接口的类
	  * @param list
	  * @param lis
	  * @param comp
	  * @return
	  */
	 public  <T> List<T> getUnionList(List<T> list ,List<T> lis,Comparator<T> comp){
		 if(null != list && 0 != list.size()){
			 if(null != lis && 0 != list.size()){
				 int size = list.size();
				 list.addAll(lis);
				 Iterator<T> it = list.iterator() ;
				 for(int i =0;i<size;i++){
					 T t = it.next();
					 for(T ls : lis){
						if(0 == comp.compare(t, ls)){
							it.remove();
						}
					 }
				 }
				 return list;
			 }else{
				 return list;
			 }
		 }else if(null != lis && 0 != lis.size()){
			 return lis;
		 }
		 return  new ArrayList<T>();
	 }
	 
}
