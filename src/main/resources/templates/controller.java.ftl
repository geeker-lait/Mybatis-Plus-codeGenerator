package ${package.Controller};

import org.springframework.web.bind.annotation.*;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.springframework.validation.annotation.Validated;
import javax.annotation.Resource;
import ${cfg.parentPackageName}.exception.model.ApiResponse;
import ${cfg.parentPackageName}.exception.JsonException;
import ${package.Entity}.${entity};
import ${package.Service}.${table.serviceName};
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import java.util.ArrayList;
import java.time.LocalDateTime;
import java.util.List;
<#if restControllerStyle>
    import org.springframework.web.bind.annotation.RestController;
<#else>
    import org.springframework.stereotype.Controller;
</#if>
<#if superControllerClassPackage??>
    import ${superControllerClassPackage};
</#if>
<#list table.fields as field>
    <#if field.keyFlag>
        <#assign keyPropertyName="${field.propertyName}"/>
        <#assign keyPropertyType="${field.propertyType}"/>
        <#assign keyComment="${field.comment}"/>
    </#if>
</#list>
/**
* <p>
    * ${table.comment!} 前端控制器
    * </p>
*
* @author ${author}
* @since ${date}
*/
<#if restControllerStyle>
    @RestController
<#else>
    @Controller
</#if>
@RequestMapping("/api")
@Validated
@Api(tags = "${table.comment!}管理")
<#if kotlin>
    class ${table.controllerName}<#if superControllerClass??> : ${superControllerClass}()</#if>
<#else>
    <#if superControllerClass??>
        public class ${table.controllerName} extends ${superControllerClass} {
    <#else>
        public class ${table.controllerName} {
    </#if>
    @Resource
    private ${table.serviceName} ${table.serviceName?uncap_first};

    @ApiOperation("添加${table.comment!}")
    @PostMapping("/${cfg.urlName}")
    public ApiResponse insert(
    <#assign isFirst = 1/>
    <#list table.fields as field>
        <#assign isOk = 1/>
        <#if keyPropertyName == field.propertyName >
            <#assign isOk = 0/>
        </#if>
        <#if cfg.saveAndUpdateIgnoreFields?? && (cfg.saveAndUpdateIgnoreFields?size > 0) >
            <#list cfg.saveAndUpdateIgnoreFields as ignore>
                <#if ignore == field.propertyName >
                    <#assign isOk = 0/>
                    <#break>
                </#if>
            </#list>
        </#if>
        <#if isOk == 1>
            <#if isFirst == 1>
                @RequestParam @ApiParam(value = "${field.comment}",required = true) ${field.propertyType} ${field.propertyName}
                <#assign isFirst = 0/>
            <#else>
                ,@RequestParam @ApiParam(value = "${field.comment}",required = true) ${field.propertyType} ${field.propertyName}
            </#if>
        </#if>
    </#list>
    ) throws Exception {
    ${entity} ${entity?uncap_first} = ${entity}.builder()
    <#list table.fields as field>
        <#assign isOk = 1/>
        <#if keyPropertyName == field.propertyName >
            <#assign isOk = 0/>
        </#if>
        <#if cfg.saveAndUpdateIgnoreFields?? && (cfg.saveAndUpdateIgnoreFields?size > 0) >
            <#list cfg.saveAndUpdateIgnoreFields as ignore>
                <#if ignore == field.propertyName >
                    <#assign isOk = 0/>
                    <#break>
                </#if>
            </#list>
        </#if>
        <#if isOk == 1>
            .${field.propertyName}(${field.propertyName})
        </#if>
    </#list>
    .build();
    ${entity?uncap_first}.insert();
    return ApiResponse.ofSuccess(${entity?uncap_first});
    }

    @ApiOperation("修改${table.comment!}")
    @PutMapping("/${cfg.urlName}/{${keyPropertyName}}")
    public ApiResponse update(
    @PathVariable @ApiParam(value = "${keyComment}", required = true) ${keyPropertyType} ${keyPropertyName}
    <#list table.fields as field>
        <#assign isOk = 1/>
        <#if keyPropertyName == field.propertyName >
            <#assign isOk = 0/>
        </#if>
        <#if cfg.saveAndUpdateIgnoreFields?? && (cfg.saveAndUpdateIgnoreFields?size > 0) >
            <#list cfg.saveAndUpdateIgnoreFields as ignore>
                <#if ignore == field.propertyName >
                    <#assign isOk = 0/>
                    <#break>
                </#if>
            </#list>
        </#if>
        <#if isOk == 1>
            ,@RequestParam(required = false) @ApiParam(value = "${field.comment}") ${field.propertyType} ${field.propertyName}
        </#if>
    </#list>
    ) throws Exception {
    ${entity} ${entity?uncap_first} = ${entity}.builder()
    <#list table.fields as field>
        <#assign isOk = 1/>
        <#if cfg.saveAndUpdateIgnoreFields?? && (cfg.saveAndUpdateIgnoreFields?size > 0) >
            <#list cfg.saveAndUpdateIgnoreFields as ignore>
                <#if ignore == field.propertyName >
                    <#assign isOk = 0/>
                    <#break>
                </#if>
            </#list>
        </#if>
        <#if isOk == 1>
            .${field.propertyName}(${field.propertyName})
        </#if>
    </#list>
    .build();
    if (${entity?uncap_first}.selectById() == null) throw new JsonException(404, "${table.comment!}不存在");
    ${entity?uncap_first}.updateById();
    return ApiResponse.ofMessage("修改成功");
    }

    @ApiOperation("获取${table.comment!}列表")
    @GetMapping("/${cfg.urlName}")
    public ApiResponse list(
    <#if (cfg.enablePage!"") == true>
        @RequestParam(defaultValue = "0") @ApiParam(value = "偏移量") Integer offset,
        @RequestParam(defaultValue = "10") @ApiParam(value = "限制") Integer limit,
    </#if>
    <#assign isFirst = 1/>
    <#list table.fields as field>
        <#assign isOk = 1/>
        <#if keyPropertyName == field.propertyName >
            <#assign isOk = 0/>
        </#if>
        <#if cfg.selectIgnoreFields?? && (cfg.selectIgnoreFields?size > 0) >
            <#list cfg.selectIgnoreFields as ignore>
                <#if ignore == field.propertyName >
                    <#assign isOk = 0/>
                    <#break>
                </#if>
            </#list>
        </#if>
        <#if isOk == 1>
            <#if isFirst == 1>
                @RequestParam(required = false) @ApiParam(value = "${field.comment}") ${field.propertyType} ${field.propertyName}
                <#assign isFirst = 0/>
            <#else>
                ,@RequestParam(required = false) @ApiParam(value = "${field.comment}") ${field.propertyType} ${field.propertyName}
            </#if>
        </#if>
    </#list>
    ) throws Exception {
    ${entity} condition = ${entity}.builder()
    <#list table.fields as field>
        <#assign isOk = 1/>
        <#if keyPropertyName == field.propertyName >
            <#assign isOk = 0/>
        </#if>
        <#if cfg.selectIgnoreFields?? && (cfg.selectIgnoreFields?size > 0) >
            <#list cfg.selectIgnoreFields as ignore>
                <#if ignore == field.propertyName >
                    <#assign isOk = 0/>
                    <#break>
                </#if>
            </#list>
        </#if>
        <#if isOk == 1>
            .${field.propertyName}(${field.propertyName})
        </#if>
    </#list>
    .build();
    Integer total = ${table.serviceName?uncap_first}.count(condition);
    List<${entity}> list = new ArrayList<>();
    if (total > 0) {
    <#if (cfg.enablePage!"") == true>
        condition.setOffset(offset);
        condition.setLimit(limit);
    </#if>
    list = ${table.serviceName?uncap_first}.list(condition);
    }
    Page<${entity}> result =new Page<>();
    result.setTotal(total);
    result.setRecords(list);
    <#if (cfg.enablePage!"") == true>
        result.setCurrent(offset);
        result.setSize(limit);
    </#if>
    return ApiResponse.ofSuccess(result);
    }
    <#if (cfg.enableTree!"") == true>
        @ApiOperation("获取${table.comment!}树")
        @GetMapping("/${cfg.urlName}/tree")
        public ApiResponse getTree(
        <#assign isFirst = 1/>
        <#list table.fields as field>
            <#assign isOk = 1/>
            <#if keyPropertyName == field.propertyName >
                <#assign isOk = 0/>
            </#if>
            <#if cfg.selectIgnoreFields?? && (cfg.selectIgnoreFields?size > 0) >
                <#list cfg.selectIgnoreFields as ignore>
                    <#if ignore == field.propertyName >
                        <#assign isOk = 0/>
                        <#break>
                    </#if>
                </#list>
            </#if>
            <#if isOk == 1>
                <#if isFirst == 1>
                    @RequestParam(required = false) @ApiParam(value = "${field.comment}") ${field.propertyType} ${field.propertyName}
                    <#assign isFirst = 0/>
                <#else>
                    ,@RequestParam(required = false) @ApiParam(value = "${field.comment}") ${field.propertyType} ${field.propertyName}
                </#if>
            </#if>
        </#list>
        ) throws Exception {
        ${entity} condition = ${entity}.builder()
        <#list table.fields as field>
            <#assign isOk = 1/>
            <#if keyPropertyName == field.propertyName >
                <#assign isOk = 0/>
            </#if>
            <#if cfg.selectIgnoreFields?? && (cfg.selectIgnoreFields?size > 0) >
                <#list cfg.selectIgnoreFields as ignore>
                    <#if ignore == field.propertyName >
                        <#assign isOk = 0/>
                        <#break>
                    </#if>
                </#list>
            </#if>
            <#if isOk == 1>
                .${field.propertyName}(${field.propertyName})
            </#if>
        </#list>
        .build();
        List<${entity}> tree = ${table.serviceName?uncap_first}.getTree(condition);
        return ApiResponse.ofSuccess(tree);
        }
    </#if>
    @ApiOperation("获取${table.comment!}详情")
    @GetMapping("/${cfg.urlName}/{${keyPropertyName}}")
    public ApiResponse get(
    @PathVariable @ApiParam(value = "${keyComment}", required = true) ${keyPropertyType} ${keyPropertyName}
    ) throws Exception {
    ${entity} condition = ${entity}.builder().${keyPropertyName}(${keyPropertyName}).build();
    ${entity} result = condition.selectById();
    if (result == null) throw new JsonException(404, "标签不存在");
    return ApiResponse.ofSuccess(result);
    }

    @ApiOperation("删除${table.comment!}")
    @DeleteMapping("/${cfg.urlName}/{${keyPropertyName}}")
    public ApiResponse delete(
    @PathVariable @ApiParam(value = "${keyComment}", required = true) ${keyPropertyType} ${keyPropertyName}
    ) throws Exception {
    ${entity} condition = ${entity}.builder().${keyPropertyName}(${keyPropertyName}).build();
    if (condition.selectById() == null) throw new JsonException(404, "${table.comment!}不存在");
    condition.deleteById();
    return ApiResponse.ofMessage("删除成功");
    }
    }
</#if>
