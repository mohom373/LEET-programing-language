
#$functions = {}
#$function_param = {} 
$return = nil 
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
                #puts @variables[i][var_name] = value
                found = true
                break
            end
        end
        
        if found == false
            abort("Abort --> Variable doesn't exist 1")
        end
    end

    def get_var(var_name)
        found = false 
        for i in 0...@variables.length
            #puts i
            #puts @variables[i]
            if @variables[i].include?(var_name)
                return @variables[i][var_name]
                found = true
                break
            end
        end
        if found == false
            abort("Abort --> Variable doesn't exist 2")
        end
    end

    def declare_var(var_name, value)
        @variables[0][var_name] = value
    end

=begin
    def declare_func(func_name, value)
        @functions = Hash.new
        @functions[func_name] = value
    end
=end
end
                
$scope_manager = ScopeManager.new

class StmtListNode
    attr_accessor :stmt_list, :stmt
    def initialize (stmt_list, stmt)
        @stmt_list = stmt_list
        @stmt = stmt
    end
    def eval
        @stmt_list.eval unless @stmt_list.nil?
        @stmt.eval
        #puts @stmt_list 
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

#========================================== Values

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

#========================================== Print and Return

class PrintNode
    attr_accessor :value
    def initialize(value)
        @value = value
    end

    def eval
        puts "#{@value.eval}"
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

#======================================== Variable
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
        if $bool_table.value?(@type) and (@expr.eval == true or @expr.eval == false)
            $scope_manager.declare_var(@var.identifier, @expr.eval)
        elsif @type == @expr.eval.class
            $scope_manager.declare_var(@var.identifier, @expr.eval)
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

#===================================== Iteration & condition

class WhileNode
    attr_accessor :condition, :statement_list
    def initialize(condition, statement_list)
        @condition = condition
        @statement_list = statement_list
    end

    def eval
        $scope_manager.add_scope
        while @condition.eval == true 
            @statement_list.eval
        end
        $scope_manager.end_scope
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
            value = @statement_list.eval
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
            value = @statement_list1.eval
            $scope_manager.end_scope
        else
            $scope_manager.add_scope
            value = @statement_list2.eval
            $scope_manager.end_scope
        end
        return value
    end
end


class FunctionSaver
    def initialize(parameter_list, statement_list)
        @parameter_list = parameter_list
        @statement_list = statement_list
    end
    
    #def eval
    def eval(argument_list)
        #$scope_manager.add_scope
        # Iterara över parameterlistan och argumentlistan samtidigt 
        # för att checka ifall objekten stämmer överens
        # isåfall gör en declare_var

        if (argument_list == nil or @parameter_list == nil) and (argument_list != nil or @parameter_list != nil)
            abort ("Abort --> Antingen saknas parametrar eller argument!")
        end
        #print "#{@parameter_list} \n"
        #print "#{argument_list}\n"


        param_list_length = @parameter_list.length 
        argument_list_length = argument_list.length

        if argument_list != nil and @parameter_list != nil
            if argument_list_length != param_list_length 
                abort ("Abort --> Size doesnt match broooo")
                #print "#{param_list_length}\n"
                #print "#{argument_list_length}\n"
            end
            $scope_manager.add_scope
            counter = 0 
            while counter < argument_list_length do
                argument_list.each do |arg|
                    puts @parameter_list[counter][0]
                    if ($bool_table.value?(arg.value.class) == $bool_table.key?(@parameter_list[counter][0])) or (arg.value.class == @parameter_list[counter][0])
                        test_var = $scope_manager.declare_var(@parameter_list[counter][1], arg.value) 
                        counter += 1   
                    end
                end
                @statement_list.eval
                $scope_manager.end_scope
            end
        elsif argument_list == nil and @parameter_list == nil
            @statement_list.eval
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
        #puts "Inne i FUNCTION DEFINITTIONNNNNNNNN"
        func_saver = FunctionSaver.new(@parameter_list, @statement_list)      
        #puts @statement_list
        $scope_manager.declare_var(@func_name.identifier, func_saver)
    end        
end

class FunctionCallNode
    def initialize(func_name, argument_list)
        @func_name = func_name
        @argument_list = argument_list
    end

    def eval
        #puts "INNNE U FUNCTION CALL---------------------------"
        var = $scope_manager.get_var(@func_name.identifier)
        var.eval(@argument_list)
    end
end








=begin
=end