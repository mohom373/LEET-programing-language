
@@variables = [{}] 
@@functions = {}
@@function_param = {} 
@@scope = 0
@@return = nil 

@@bool_table = {TrueClass => "b00l", FalseClass => "b00l"}
#@@type_value = {"57r1ng" => "", "1n7" => 0, "fl0a7" => 0.0, "b00l" => "true", "l157" => []}

#================================= Global functions


def type_checker(expr)
    if (expr.eval.is_a?(Integer))
        object = FactorNode.new(expr.eval)
    elsif(expr_in.eval == :FALSE)
        object= BOOL_C.new(expr_in.eval)
    elsif(expr_in.eval == :TRUE)
        object= BOOL_C.new(expr_in.eval)
    end
    return object
end



#================================ Leet classes
class Scope
    def start_scope
        @@scope += 1
        @@variables.push({})
    end

    def end_scope
        @@variables.pop
        @@scope -= 1
        if @@scope < 0
            abort("ABOOOOOOOOOOOOOOORT")
        end
    end

    def return_var(var, table)
        if table == @@function_param
            table[var]
        elsif table == @@variables
            start = @@scope
            while( start >= 0 )
                if @@variables[start][var] != nil
                    return @@variables[start][var]
                end
                start -= 1
            end
            if @@variables[0][var] == nil
                abort("Abort --> The variable \'#{var}\' doesn't exist!")
            end
        end
    end
end  
$scope = Scope.new

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
        start = @@scope
        #if @@function_param.has_key?(@identifier) == true
            #return Scope.return_var(@identifier, @@function_param) 
        #else 
        if @@variables[start].has_key?(@identifier) == true 
            return $scope.return_var(@identifier, @@variables) 
        end
    end
end

class DeclareNode
    attr_accessor :type, :var, :expr
    def initialize(type, var, expr = nil)
      @type = type
      @var = var
      @expr = expr
    end

    def eval()
        if @expr != nil
            value = @expr.eval
        #else
            #value = @@type_value[@type]
        end
        start = @@scope
        
        if @@variables[start].has_key?(@var.identifier)
            abort("Abort --> Variable exists already!")
        else 
            if (@@bool_table.value?(@type)) and (value == true or value == false)
                @@variables[start][@var.identifier] = value
            else
                if value.class == @type
                    @@variables[start][@var.identifier] = value
                else
                    abort("Abort --> Value is of a different type.")
                end
            end
        puts @@variables    
        end
    end
end

class AssignNodes
    attr_accessor :var, :op, :expr
    def initialize(var, op, expr)
        @var = var
        @op = op
        @expr = expr
    end

    def eval
        if @expr != nil
            value = @expr.eval
        end

        start = @@scope

    end
end



#===================================== Iteration & condition

class WhileNode
    attr_accessor :comparison, :statement_list
    def initialize(comparison, statement_list)
        @comparison = comparison
        @statement_list = statement_list
    end

    def eval
        $scope.start_scope
        while @comparison.eval == true do
            @statement_list.eval
        end
        $scope.end_scope
    end
end

class IfNode
    attr_accessor :condition, :statement_list
    def initialize(condition, statement_list)
        @condition = condition
        @statement_list = statement_list
    end

    def eval
        $scope.start_scope
        condition_val = @condition.eval 
        #puts condition_val
        if condition_val == true or condition_val == '7ru3'
            value = @statement_list.eval
            $scope.end_scope
            return value
        end
        $scope.end_scope
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
        $scope.start_scope
        condition_val = @condition.eval 
        if condition_val == true or condition_val == '7ru3'
            value = @statement_list1.eval
        else
            value = @statement_list2.eval
        end
        $scope.end_scope
        return value
    end
end






