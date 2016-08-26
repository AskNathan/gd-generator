package ${meta.queryModelPackage};

import java.util.Set;
import java.util.HashSet;

import io.gd.generator.api.Direction;
<#if meta.useLombok>
import lombok.Getter;
import lombok.Setter;
import lombok.Builder;
</#if>

<#if meta.importFullTypes??>
<#list meta.importFullTypes as importFullType>
import ${importFullType};
</#list>
</#if>

<#if meta.useLombok>
@Getter
@Setter
@Builder
</#if>
public class ${meta.type} {

	private static Set<String> filedNames = new HashSet<>();

	static {
		<#if meta.fieldNames??>
		<#list meta.fieldNames as fieldName>
		filedNames.add("${fieldName}");
		</#list>
		</#if>
	}

	<#if meta.queryModelFields??>
	<#list meta.queryModelFields as queryModelField>

	private ${queryModelField.type} ${queryModelField.name};
	</#list>
	</#if>

	private Integer pageNumber;

	private Integer pageSize;

	private String orderBy;

	private Direction direction;
	<#if !meta.useLombok>
	<#if meta.queryModelFields??>
	<#list meta.queryModelFields as queryModelField>

	public ${queryModelField.type} get${queryModelField.name?cap_first}() {
		return ${queryModelField.name};
	}

	public void set${queryModelField.name?cap_first}(${queryModelField.type} ${queryModelField.name}) {
		this.${queryModelField.name} = ${queryModelField.name};
	}
	</#list>
	</#if>

	public Integer getPageNumber() {
		return pageNumber;
	}

	public void setPageNumber(Integer pageNumber) {
		this.pageNumber = pageNumber;
	}

	public Integer getPageSize() {
		return pageSize;
	}

	public void setPageSize(Integer pageSize) {
		this.pageSize = pageSize;
	}

	public String getOrderBy() {
		return orderBy;
	}

	public Direction getDirection() {
		return direction;
	}

	public void setDirection(Direction direction) {
		this.direction = direction;
	}	
	</#if>

	public void setOrderBy(String orderBy) {
		if (orderBy == null) {
			this.orderBy = orderBy;
		} else if (!filedNames.contains(orderBy)) {
			throw new IllegalArgumentException("order by is invalid");
		}
	}

	public Long getOffset() {
		if (pageNumber == null || pageSize == null) {
			return null;
		}
		return ((long) pageNumber) * pageSize;
	}

	public String getOrderByAndDirection() {
		String orderByStr = camelToUnderline(orderBy);
		String directionStr = direction == null ? "desc" : direction.toString().toLowerCase();
		return orderByStr + " " + directionStr;
	}

	private String camelToUnderline(String param) {
		if (param == null || "".equals(param.trim())) {
			return "";
		}
		int len = param.length();
		StringBuilder sb = new StringBuilder(len);
		for (int i = 0; i < len; i++) {
			char c = param.charAt(i);
			if (Character.isUpperCase(c)) {
				sb.append("_");
				sb.append(Character.toLowerCase(c));
			} else {
				sb.append(c);
			}
		}
		return sb.toString();
	}

}