require './debug_fix_rdparse.rb'
require './leet_node.rb'
require 'test/unit'

class Leet

    attr_reader :leetparser 
    def initialize 
        @leetparser = Parser.new("L33t lang") do
            token(/\s+/) # ignore whitespaces
            #token(/--.+/) # ignore comments
            token(/\d+/) { |x| x.to_i } # Match integer
            token(/[a-zA-Z]+/) {|x| x.to_s} # Match chars
            token(/./) {|x| x}



            start :program do
                match(:statement_list)
            end

            rule :statement_list do 
                match(:statement_list, :statement) { |stmt_list, stmt| StmtList.new(stmt_list, stmt) }
                match(:statement) { |stmt| stmt }
            end

            rule :statement do 
                match(:assign)  
                # match(:input)
                # match(:output)
                # match(:condition)
                # match(:repetition)
                # match(:return)
                # match(:break)
                # match(:function_definition)
                # match(:function_call)
                #match(:print_stmt)  
                match(:expr)
            end

=begin
            rule :or_expr do
                match(:expr, "+", :and_expr) { |a,_,b| AddNode.new(a,b) }
            end

            rule :or_expr do
                match(:and_expr, "+", :not_expr) { |a,_,b| AddNode.new(a,b) }
            end
=end
            rule :assign do
                match(:var, '=', :expr){|var, _, expr|@@variables[var]= expr} 
            end

            rule :expr do
                match(:expr, 'or', :expr) {|exp1, _,exp2| exp1 || exp2}
                match(:expr, 'and', :expr) {|exp1, _, exp2| exp1 && exp2}
                match('not', :expr) {|_, expr| !expr}
                match(:term)
            end
    
            rule :term do
                match('true'){true}
                match('false'){false}
                match(:var)
            end
    
            rule :var do
                #match(String)
                match(/[a-zA-Z]+/) {|var| @@variables.include?(var) ?@@variables[var] : var}
            end
    
=begin
            rule :print do
                match('pr1n7', '(', :expr, ')') {|_, _,print, _| 
                Print_node.new(print) }
            end
=end

=begin
            rule :expr do 
                match(:a_expr)
                match(:m_expr)
            end

            rule :a_expr do
                match(:integer, "+", :integer) {|a,_,b| AddNode.new(a,b)}
                #match(:integer, "-", :integer) {|a,_,b| MinusNode.new(a,b)}
                #match(:m_expr, "+", :integer){|a,_,b| AddNode.new(a,b)}
            end

            rule :m_expr do 
                match(:expr, "*", :integer) { |a,_,b| MultiNode.new(a,b) }
            end
=end

=begin
            rule :integer do
                match(Integer)
            end

            rule :literal do
                match('<1n7>') 
                match('<fl047>')
                match('<57r1ng>') 
                match('b00l')
                match('<l157>')
            end

=end
        end
    end

    def run(str)
       @leetparser.parse(str)
    end

end

#Leet.new.run "tja = true"

#Leet.new.run "5 - 3"






class TestFaculty < Test::Unit::TestCase

  def test_logic1
    reader = Leet.new
    reader = reader.leetparser
    assert_equal(reader.parse("a = true"), true)
    assert_equal(reader.parse("b = false"), false)
    assert_equal(reader.parse("a"), true)
    assert_equal(reader.parse("b"), false)
    assert_equal(reader.parse("a or b"), true)
    assert_equal(reader.parse("a and b"), false)
    assert_equal(reader.parse("not a"), false)
    assert_equal(reader.parse("not b"), true)
  end
end
