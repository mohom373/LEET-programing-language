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

@@variables = {} 


class StmtList
    attr_accessor :stmt_list, :stmt
    def initialize stmt_list, stmt
        @stmt_list = stmt_list
        @stmt = stmt
    end
    def eval
        @stmt.eval
        @stmt_list.eval unless @stmt_list.nil?
    end
end

class AddNode
    attr_accessor :a, :op, :b
    def initialize a,op,b
        @a = a.eval
        @op = op
        @b = b.eval
    end
    def eval
        if op == '+'
            puts @a + @b
        elsif op == '-'
            puts @a - @b
        end
    end
end

=begin
class MinusNode
    attr_accessor :a, :b
    def initialize a,b
        @a = a
        @b = b
    end
    def eval
        @a - @b
    end
end
=end

class MultiNode
    attr_accessor :a, :op, :b
    def initialize a, op, b
        @a = a
        @op = op
        @b = b
    end
    def eval
        #puts @a * @b
        return @a * @b
    end
end




=begin
class PrintNode
    attr_accessor :value
    def initialize(value)
      @print = value
    end
    def eval()
      @print.eval
    end
end

=end