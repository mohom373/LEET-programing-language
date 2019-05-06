
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
            abort("EROOOOOOOOOORRRRR")
        end
    end

    def check_if_exist(var, table)
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
                abort("ERROR: The variable \'#{var}\' doesn't exist!")
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
        return instance_eval("#{lhs.eval} #{op} #{rhs.eval}")
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
        return BoolNode.new(instance_eval("#{lhs.eval} #{op} #{rhs.eval}")).eval
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
        if @op == "and"
            @op = "and"
        elsif @op == "or"
            @op = "or"
        end        
        return BoolNode.new(instance_eval("#{lhs.eval} #{op} #{rhs.eval}")).eval
    end
end

class NotLogicNode
    attr_accessor :op, :rhs
    def initialize(op, rhs)
        @op = op
        @rhs = rhs
    end

    def eval
        if @op == "not"
            @op = "not"
        end        

        return BoolNode.new(instance_eval("#{op} #{rhs.eval}")).eval
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
        if value == true or value == "true" 
            value = true
        elsif value == false or value == "false"
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
        print "#{@value.eval}\n"
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


class VarNode 
    attr_accessor :identifier
    def initialize(var)
        @identifier = var
    end

    def eval
        start = @@scope
        #if @@function_param.has_key?(@identifier) == true
            #return Scope.check_if_exist(@identifier, @@function_param) 
        #else 
        if @@variables[start].has_key?(@identifier) == true 
            return $scope.check_if_exist(@identifier, @@variables) 
        end
    end
end

=begin
class DeclareNode
    attr_accessor :type, :var, :expr
    def initialize(type, var, expr)
        @type = type
        @var = var
        @expr = expr
    end

    def eval

        value = expr.eval
        puts value.class
        puts @type
        if value.class != @type
            abort("ERROR: Variabeln finns redan!")      
        end
        @@variables[@@scope][@var.identifier] = value
        puts @@variables
    end
end
=end

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
            abort("Error: Variable exists already!")
        else
            if (@type == 'b00l') and (value == 'true' or value == 'false')
                @@variables[start][@var.identifier] = value
            else
                if value.class == @type
                    @@variables[start][@var.identifier] = value
                else
                    abort("ERROR: Value is of a different type.")
            end
        end
        puts @@variables    
        end
    end
end











=begin
class VarNode
    attr_accessor :identifier
    def initialize(var)
        @identifier = var
    end

    def eval


    end
=end


