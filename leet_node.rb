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

@@variables ={} 


class StmtList
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
    def initialize a,b
        @a = a
        @b = b
    end
    def eval
        puts @a + @b
        @a + @b
    end
end

class MinusNode
    def initialize a,b
        @a = a
        @b = b
    end
    def eval
        puts @a - @b
        @a - @b
    end
end


class MultiNode
    def initialize a,b
        @a = a
        @b = b
    end
    def eval
        puts @a * @b
        @a * @b
    end
end


class PrintNode
    attr_accessor :value
    def initialize(value)
      @print = value
    end
    def eval()
      puts @print.eval
    end
  end

