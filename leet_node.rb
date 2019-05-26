$bool_table = {TrueClass => "b00l", FalseClass => "b00l"}

#================================ Leet classes
 
class ScopeManager
    attr_accessor :variables
    def initialize
        @variables = [{}] 
    end

    def add_scope
        @variables.unshift({})
    end

    def end_scope
        @variables.shift()
    end

    def re_assign(var_name, value)
        found = false
        for i in 0...@variables.length
            if @variables[i].include?(var_name)
                @variables[i][var_name] = value
                found = true
                break
            end
        end
        
        if found == false
            abort("Abort --> Cannot reassign variable '#{var_name}' because it doesn't exist ")
        end
    end

    def get_var(var_name)
        found = false 
        for i in 0...@variables.length
            if @variables[i].include?(var_name)
                return @variables[i][var_name]
                found = true
                break
            end
        end

        if found == false
            abort("Abort --> Variable with the name '#{var_name}' doesn't exist ")
        end
    end

    def declare_var(var_name, value)
        @variables[0][var_name] = value
    end
end
                
$scope_manager = ScopeManager.new

class StmtListNode
    attr_accessor :stmt_list
    def initialize(stmt_list)
        @stmt_list = stmt_list
    end
    def eval
        @stmt_list.each do |stmt|
            stmt.eval
        end
    end
end

#========================================== CALCULATIONS

class ArithmNode
    attr_accessor :lhs, :op, :rhs
    def initialize(lhs, op, rhs)
        @lhs = lhs
        @op = op
        @rhs = rhs
    end
  
    def eval
        return instance_eval("#{@lhs.eval} #{@op} #{@rhs.eval}")
    end
end

class CompNode
    attr_accessor :lhs, :op, :rhs
    def initialize(lhs, op, rhs)
        @lhs = lhs
        @op = op
        @rhs = rhs
    end

    def eval
        return BoolNode.new(instance_eval("#{@lhs.eval} #{@op} #{@rhs.eval}")).eval
    end
end

class LogicNode
    attr_accessor :lhs, :op, :rhs
    def initialize(lhs, op, rhs)
        @lhs = lhs
        @op = op
        @rhs = rhs
    end

    def eval
        if @op == "4nd"
            @op = "and"
        elsif @op == "0r"
            @op = "or"
        end        
        return BoolNode.new(instance_eval("#{@lhs.eval} #{@op} #{@rhs.eval}")).eval
    end
end

class NotLogicNode
    attr_accessor :op, :rhs
    def initialize(op, rhs)
        @op = op
        @rhs = rhs
    end

    def eval
        if @op == "n07"
            @op = "not"
        end        

        return BoolNode.new(instance_eval("#{@op} #{@rhs.eval}")).eval
    end
end 

#========================================== VALUES

class FactorNode
    attr_accessor :value
    def initialize(value)
        @value = value
    end
    
    def eval
        return @value
    end
end

class BoolNode
    attr_accessor :value
    def initialize(value)
        if value == true or value == '7ru3'
            value = true
        elsif value == false or value == 'f4l53'
            value = false
        end
        @value = value
    end

    def eval
        return @value
    end
end

#========================================== PRINT & RETURN

class PrintNode
    attr_accessor :value
    def initialize(value)
        @value = value
    end

    def eval
        print_value = @value.eval
        if print_value.class == Array
            print_array = []
            print_value.each do |element|
                print_array.append(element.eval)
            end
            print "#{print_array}\n"
        else
            print "#{print_value}\n"
        end
    end
end

class ReturnNode
    attr_accessor :value
    def initialize(value)
        @value = value
    end

    def eval
        return @value.eval
    end
end

#========================================== VARIABLES

class VarNode 
    attr_accessor :identifier
    def initialize(var)
        @identifier = var
    end

    def eval
        return $scope_manager.get_var(@identifier)
    end

end

class DeclareNode
    attr_accessor :type, :var, :expr
    def initialize(type, var, expr)
        @type = type
        @var = var
        @expr = expr
    end

    def eval
        return_val = @expr.eval
        if $bool_table.value?(@type) and (return_val == true or return_val == false)
            $scope_manager.declare_var(@var.identifier, return_val)
        elsif @type == return_val.class
            $scope_manager.declare_var(@var.identifier, return_val)
        else
            abort("Abort --> Value is of a different type.")
        end
    end
end

class AssignNode
    attr_accessor :var, :expr
    def initialize(var, expr)
        @var = var
        @expr = expr
    end

    def eval
        scope_man = $scope_manager.get_var(@var.identifier)
        if ($bool_table.include?(scope_man.class)) and (@expr.eval == true or @expr.eval == false)
            $scope_manager.re_assign(@var.identifier, @expr.eval)
        elsif scope_man.class == @expr.eval.class 
            $scope_manager.re_assign(@var.identifier, @expr.eval)
        else
            abort("Abort --> Value is of a different type.")
        end
    end
end

#========================================== ITERATION & CONDITION

class WhileNode
    attr_accessor :condition, :statement_list
    def initialize(condition, statement_list)
        @condition = condition
        @statement_list = statement_list
    end

    def eval
        while @condition.eval == true 
            $scope_manager.add_scope
            @statement_list.each do |statement|
                statement.eval
            end
            $scope_manager.end_scope
        end
    end
end

class IfNode
    attr_accessor :condition, :statement_list
    def initialize(condition, statement_list)
        @condition = condition
        @statement_list = statement_list
    end

    def eval
        if @condition.eval == true 
            $scope_manager.add_scope
            value = 0
            @statement_list.each do |statement|
                value = statement.eval
            end
            $scope_manager.end_scope
            return value
        end
    end
end

class ElseNode
    attr_accessor :condition, :statement_list
    def initialize(condition, statement_list1, statement_list2)
        @condition = condition
        @statement_list1 = statement_list1
        @statement_list2 = statement_list2
    end

    def eval
        condition_val = @condition.eval 
        if condition_val == true 
            $scope_manager.add_scope
            @statement_list1.each do |statement|
                statement.eval
            end
            $scope_manager.end_scope
        else
            $scope_manager.add_scope
            @statement_list2.each do |statement|
                statement.eval
            end
            $scope_manager.end_scope
        end
    end
end

#========================================== FUNCTIONS

class FunctionSaver
    def initialize(parameter_list, statement_list)
        @parameter_list = parameter_list
        @statement_list = statement_list
    end
    
    def eval(argument_list)
        if (argument_list == [] or @parameter_list == []) and (argument_list != [] or @parameter_list != [])
            abort ("Abort --> Either a paramater or an argument is missing!")
        end

        paramater_list_length = @parameter_list.length 
        argument_list_length = argument_list.length

        if argument_list == [] and @parameter_list == []
            $scope_manager.add_scope
            @statement_list.each do |statement|
                if statement.class == ReturnNode
                    return statement.eval
                    break
                else
                    statement.eval
                end
            end
            $scope_manager.end_scope
        elsif argument_list != [] and @parameter_list != []
            if argument_list_length != paramater_list_length 
                abort ("Abort --> Number of parameters and arguments dont match!")
            end
            $scope_manager.add_scope
            counter = 0 
            
            @parameter_list.zip(argument_list).each do |pair|
                parameter_val = pair[1].eval
                if (pair[0][0] == parameter_val.class) or (TrueClass == parameter_val.class or FalseClass == parameter_val.class )
                    $scope_manager.declare_var(pair[0][1], parameter_val) 
                else 
                    abort("Abort --> argument type doesn't match with parameter type!")   
                end
            end
            
            @statement_list.each do |statement|
                if statement.class == ReturnNode
                    return statement.eval
                    break
                else
                    statement.eval
                end
            end   
            $scope_manager.end_scope
        end
    end
end

class FunctionDefNode
    def initialize(func_name, parameter_list, statement_list)
        @func_name = func_name
        @parameter_list = parameter_list
        @statement_list = statement_list
    end

    def eval
        func_saver = FunctionSaver.new(@parameter_list, @statement_list)      
        $scope_manager.declare_var(@func_name.identifier, func_saver)
    end        
end

class FunctionCallNode
    def initialize(func_name, argument_list)
        @func_name = func_name
        @argument_list = argument_list
    end

    def eval
        var = $scope_manager.get_var(@func_name.identifier)
        var.eval(@argument_list)
    end
end

#========================================== LIST

class ListNode 
    def initialize(list = [])
        @list = list 
    end

    def eval 
        return @list
    end
end

class ListFunctionsNode
    def initialize(operator, list,expression = nil, index = 0)
        @operator = operator
        @list = list 
        @expression = expression
        @index = index
    end

    def eval 
        case @operator
        when '51z3' then
            return @list.eval.size
        when '4pp3nd' then
            if @expression.class == Array
                return @list.eval.concat(@expression)
            else 
                return @list.eval.append(@expression)
            end 
        when 'r3m0v3' then 
            return @list.eval.delete_at(@index)
        when '1n53r7' then 
            return @list.eval.insert(@index, @expression)
        when 'g37' then 
            return @list.eval.at(@index).eval
        end
    end
end