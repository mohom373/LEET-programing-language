
#$variables = [{}] 
$functions = {}
$function_param = {} 
$scope = 0
$return = nil 

$bool_table = {TrueClass => "b00l", FalseClass => "b00l"}
#@@type_value = {"57r1ng" => "", "1n7" => 0, "fl0a7" => 0.0, "b00l" => "true", "l157" => []}

#================================= Global functions

=begin
def type_checker(expr)
    if (expr.eval.is_a?(Integer) or expr.eval.is_a?(Float) or expr.eval.is_a?(String))
        object = FactorNode.new(expr.eval)
    elsif(expr_in.eval == true)
        object= BOOL_C.new(expr_in.eval)
    elsif(expr_in.eval == false)
        object= BOOL_C.new(expr_in.eval)
    end
    return object
end
=end


#================================ Leet classes

def start_scope
    $scope += 1
    $variables.push({})
end

def end_scope
    $variables.pop
    $scope -= 1
    if $scope < 0
        abort("ABOOOOOOOOOOOOOOORT")
    end
end

def return_var(var, table)
    if table == $function_param
        table[var]
    elsif table == $variables
        index = $scope
        while( index >= 0 )
            if $variables[index][var] != nil
                return $variables[index][var]
            end
            index -= 1
        end
        if $variables[0][var] == nil
            abort("Abort --> The variable \'#{var}\' doesn't exist!")
        end
    end
end
  
class Scope_manager
    attr_accessor :variables
    def initialize
        @variables = [{}] 
        #puts "HEHFHEHFEHFIHEIFHEIFH"
    end

    def add_scope
        #puts "=============================================0"
        @variables.unshift({})
    end

    def end_scope
        #puts "ENNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNND"
    
        @variables.shift()
    end

    def re_assign(var_name, value)
        found = false
        for i in 0..@variables.length
            if @variables[i].include?(var_name)
                @variables[i][var_name] = value
                found = true
                break
            end
        end
        
        if found == false
            abort("Abort --> Variable doesnt exist")
        end
    end

    def get_var(var_name)
        for i in 0..@variables.length
            #puts @variables[i].class
            if @variables[i].include?(var_name)
                return @variables[i][var_name]
                
            end
        end
        
        abort("Abort --> Variable doesnt exist")
    end

    def declare_var(var_name, value)
        @variables[0][var_name] = value
    end
end
                
$scope_manager = Scope_manager.new


        

        




class StmtListNode
    attr_accessor :stmt_list, :stmt
    def initialize (stmt_list, stmt)
        @stmt_list = stmt_list
        @stmt = stmt
    end
    def eval
        @stmt_list.eval unless @stmt_list.nil?
        @stmt.eval
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
        #puts BoolNode.new(instance_eval("#{@lhs.eval} #{@op} #{@rhs.eval}")).eval
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
=begin
        index = $scope
        #if $function_param.has_key?(@identifier) == true
            #return Scope.return_var(@identifier, $function_param) 
        #else 
        if $variables[index].has_key?(@identifier) == true 
            return return_var(@identifier, $variables) 
        end
=end
    end

end

class DeclareNode
    attr_accessor :type, :var, :expr
    def initialize(type, var, expr)
      @type = type
      @var = var
      @expr = expr
    end

    def eval()
        
        if $bool_table.value?(@type) and (@expr.eval == true or @expr.eval == false)
            $scope_manager.declare_var(@var.identifier, @expr.eval)
        elsif @type == @expr.eval.class
            $scope_manager.declare_var(@var.identifier, @expr.eval)
        else
            abort("Abort --> Value is of a different type.")
        end
        #puts $scope_manager.variables
    
=begin
        if @expr != nil
            value = @expr.eval
        end
        #index = $scope
    
        if $variables[index].has_key?(@var.identifier)
            abort("Abort --> Variable exists already!")
        else 
            if ($bool_table.value?(@type)) and (value == true or value == false)
                $variables[index][@var.identifier] = value
            else
                if value.class == @type
                    $variables[index][@var.identifier] = value
                else
                    abort("Abort --> Value is of a different type.")
                end
            end
        #puts $variables
        end
=end
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

=begin
        index = $scope
        value = type_checker(@expr)

        while( index >=0) do
            if $variables[index][@var.identifier] != nil
                data_type = $variables[index][@var.identifier].class
                if (data_type == @expr.eval.class )
                    $variables[index][@var.identifier] = @expr.eval
                else
                    abort("FEEEEEEEEEEEEEEEEEEEEEEEL DATAT TYPPPPEPEE")
                end

            end
            index -= 1
        end
        #puts $variables
=end
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
        #start_scope
        $scope_manager.add_scope
        while @condition.eval== true or @condition.eval == '7ru3' do
            @statement_list.eval
        end
        $scope_manager.end_scope
        #end_scope
    end
end

class IfNode
    attr_accessor :condition, :statement_list
    def initialize(condition, statement_list)
        @condition = condition
        @statement_list = statement_list
    end

    def eval
        
        #puts condition_val
        if @condition.eval == true or @condition.eval == '7ru3'
            #start_scope
            $scope_manager.add_scope
            value = @statement_list.eval
            #end_scope
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
        if condition_val == true or condition_val == '7ru3'
            #start_scope
            $scope_manager.add_scope
            value = @statement_list1.eval
            $scope_manager.end_scope
            #end_scope
        else
            #start_scope
            $scope_manager.add_scope
            value = @statement_list2.eval
            $scope_manager.end_scope
            #end_scope
        end
        return value
    end
end






