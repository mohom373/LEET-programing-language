# -*- coding: utf-8 -*-
=begin
@@variables = [{}] 
@@funcs = {} 
@@funcs_var = {} # parametrar i funktioner sparas ner tillfälligt
@@scope = 0 # indikerar vilket index vi bör använda i @@variables
@@return = nil # har koll på ifall en funktion har en retursats

@@type_table = {String => "<57r1ng>", Integer => "<1n7>", 
   Float => "<fl0a7>", Bool => "<b00l>", List => "<l175>"}
@@type_value = {"<57r1ng>" => "", "<1n7>" => 0, "fl0a7" => 0.0, "<b00l>" => "true", "<l157>" => []}
=end


#variables = {} 


class StmtList
    attr_accessor :stmt_list, :stmt
    def initialize (stmt_list, stmt)
        @stmt_list = stmt_list
        @stmt = stmt
    end
    def eval
        @stmt.eval
        @stmt_list.eval unless @stmt_list.nil?
    end
end


class ArithmNode
    attr_accessor :lhs, :op, :rhs
    def initialize(lhs, op, rhs)
        @lhs = lhs
        @op = op
        @rhs = rhs
    end
  
    def eval
        case @op
            when '+' then return (@lhs.eval + @rhs.eval)
            when '-' then return (@lhs.eval - @rhs.eval)
        end
    end
end

class TermNode
    attr_accessor :lhs, :op, :rhs
    def initialize(lhs, op, rhs)
        @lhs = lhs
        @op = op
        @rhs = rhs
    end
  
    def eval
        case @op
            when '*' then return (@lhs.eval * @rhs.eval)
            when '/' then return (@lhs.eval / @rhs.eval)
        end
    end
end

class RelationAndLogicNode
    attr_accessor :lhs, :op, :rhs
    def initialize(lhs, op, rhs)
        @lhs = lhs
        @op = op
        @rhs = rhs
    end

    def eval
        case @op
            when '==' then return check_true_or_false(@lhs.eval == @rhs.eval)
            when '!=' then return check_true_or_false(@lhs.eval != @rhs.eval)
            when '>' then return check_true_or_false(@lhs.eval > @rhs.eval)
            when '<' then return check_true_or_false(@lhs.eval < @rhs.eval)
            when '>=' then return check_true_or_false(@lhs.eval >= @rhs.eval)
            when '<=' then return check_true_or_false(@lhs.eval <= @rhs.eval)
            when '4nd' then return check_true_or_false(@lhs.eval && @rhs.eval)
            when '0r' then return check_true_or_false(@lhs.eval || @rhs.eval)
        end
    end

    def check_true_or_false(bool)
        if bool == true
            return true
        else 
            return false
        end
    end 
end




class Factor
    def initialize(value)
        @value = value
    end
    
    def eval
        return @value
    end
end

class PrintNode
    def initialize(value)
        @value = value
    end

    def eval
        puts @value.eval
    end
end
