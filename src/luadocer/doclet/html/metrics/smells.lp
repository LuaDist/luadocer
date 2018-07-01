
<% if metricsAST then %>
<div>
    <div style='float: left; margin-right: 20px;'>
        <h3>Long lines</h3>
        <table class="metric_index">
            <tr>
                <th>Line number</th>
                <th>Line length</th>
            </tr>
            
            <% for k, v in pairs(metricsAST.smells.longLines) do %>
                    <tr>
                        <td><%= v.lineNumber %></td>
                        <td><%= v.length %></td>                
                    </tr>
                <% end %>
        </table>
    </div>
    <div style='float: left; margin-right: 20px;'>
        <h3>Table with many fields</h3>
        <table class="metric_index">
            <tr>
                <th>Table name</th>
                <th>Number of fields</th>
            </tr>
            
            <% 
            for k, v in pairs(globalMetrics.documentSmells.smellsTable) do 
                if(filename == v.file) then
                    if(v.smells.tableSmells.manyFields.count > 0) then
                        for tableName, s in pairs(v.smells.tableSmells.manyFields) do
                            if(type(s) == "table") then
            %>
                                <tr>
                                    <td><%= tableName %></td>    
                                    <td><%= s.count %></td>        
                                </tr>
                <%              
                            end
                        end
                    else %>
                        <tr>
                            <td>-/-</td>    
                            <td>-/-</td>        
                        </tr>
              <%    end
                    break
                end
            end %>
        </table>
    </div>
    <div style='float: left; margin-right: 20px;'>
        <h3>Table depth</h3>
        <table class="metric_index">
            <tr>
                <th>Table name</th>
                <th>Depth</th>
            </tr>
            
            <% 
            for k, v in pairs(globalMetrics.documentSmells.smellsTable) do 
                if(filename == v.file) then
                    if(v.smells.tableSmells.depth.count > 0) then
                        for tableName, s in pairs(v.smells.tableSmells.depth) do
                            if(type(s) == "table") then
            %>
                                <tr>
                                    <td><%= tableName %></td>    
                                    <td><%= s.level %></td>        
                                </tr>
                <%              
                            end
                        end
                    else %>
                        <tr>
                            <td>-/-</td>    
                            <td>-/-</td>        
                        </tr>
              <%    end
                    break
                end
            end %>
        </table>
    </div>
    <div style='float: left; margin-right: 20px;'>
        <h3>Function depth</h3>
        <table class="metric_index">
            <tr>
                <th>Function name</th>
                <th>Depth</th>
            </tr>
            
            <% 
            for k, v in pairs(globalMetrics.documentSmells.smellsTable) do 
                if(filename == v.file) then
                    if(v.smells.functionSmells.count > 0) then
                        for tableName, s in pairs(v.smells.functionSmells) do
                            if(type(s) == "table") then
            %>
                                <tr>
                                    <td><%= tableName %></td>    
                                    <td><%= s.level %></td>        
                                </tr>
                <%              
                            end
                        end
                    else %>
                        <tr>
                            <td>-/-</td>    
                            <td>-/-</td>        
                        </tr>
              <%    end
                    break
                end
            end %>
        </table>
    </div>
    <div style='float: left; margin-right: 20px;'>
        <h3>Upvalues</h3>
        <table class="metric_index">
            <tr>
                <th>Function name</th>
                <th>Number of upvalues</th>
            </tr>
             
            <%
                for k, v in pairs(globalMetrics.documentSmells.smellsTable) do 
                    if(filename == v.file) then
                        for name, count in pairs(v.upvalues.functions) do
            %>
                <tr>   
                    <td><%= name %></td>    
                    <td><%= count %></td>        
                </tr>  
            <%
                        end
                    end
                end
             %>                  

        </table>
    </div>
</div>
<% end %>
