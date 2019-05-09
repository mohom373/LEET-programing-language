require './debug_fix_rdparse.rb'
#require './rdparse'
require './leet_node.rb'
require 'test/unit'

class Leet

    attr_reader :leetparser 
    def initialize 
        @leetparser = Parser.new("L33t lang") do
            token(/\s+/) # Ignore whitespaces
            token(/\#.*/) # Ignore comments
            token(/pr1n7/) {|x| x} # Match print function
            token(/1n7/) {|x| x}
            token(/fl047/) {|x| x}
            token(/b00l/) {|x| x}
            token(/57r1ng/) {|x| x}
            token(/1f/) {|x| x}
            token(/3l53/) {|x| x}
            token(/n07/) {|x| x}
            token(/7ru3/) {|x| x}
            token(/f4l53/) {|x| x}
            token(/4nd/) {|x| x}
            token(/0r/) {|x| x}
            token(/\d+[.]\d+/) {|x| x.to_f} # Match float
            token(/\d+/) { |x| x.to_i } # Match integer
            token(/[a-zA-ZåäöÅÄÖ]+/) {|x| x.to_s} # Match chars
            token(/"[^\"]*"/) {|m| m.to_s } # Double quote string
            token(/'[^\"]*'/) {|m| m.to_s } # Single quote string
            token(/while/) {|x| x}
            token(/{/) {|x| x }
            token(/}/) {|x| x }
            token(/\=\=/) {|x| x}  
            token(/\!\=/) {|x| x} 
            token(/\>\=/) {|x| x}
            token(/\<\=/) {|x| x}
            token(/./) {|x| x}

            start :program do
                match(:statement_list)
            end

            rule :statement_list do 
                match(:statement_list, :statement) { |stmt_list, stmt| StmtListNode.new(stmt_list, stmt) }
                match(:statement) { |stmt| stmt }
            end

            rule :statement do 
                  
                match(:repetition)
                # match(:return)
                # match(:break)
                # match(:function_definition)
                # match(:function_call)
                match(:print_stmt) {|x| x}
                match(:declare) {|x| x}
				match(:assign) {|x| x}
                match(:condition) {|x| x}
                match(:expr)  {|x| x}
            end

            rule :print_stmt do
                match('pr1n7', '(', :expr, ')', ';') {|_, _, print_val ,_ ,_|PrintNode.new(print_val) }
                
                match('pr1n7', '(', :assign, ')', ';') {|_, _, print_val ,_ ,_|PrintNode.new(print_val) }

            end
              
            rule :declare do
                match(:type_name, :var, '=', :expr) {|type, var, _, expr| DeclareNode.new(type, var, expr)}
            end

            rule :type_name do
                match(/1n7/) {Integer}
                match(/fl047/) {Float}
                match(/b00l/) 
                match(/57r1ng/) {String}
            end

            
            rule :assign do
                match(:var, '=', :expr){|var, _, expr| AssignNode.new(var, expr) }
                
                #match(:var, :assign_op , :expr){|var, _, expr| }
            end
=begin
            rule :assign_op do
                match('*=') {|m| m }
                match('/=') {|m| m }
                match('+=') {|m| m }
                match('-=') {|m| m }
                match('=') {|m| m }
            end
=end

            rule :repetition do 
                match('while', '(', :comparison, ')', '{', :statement_list,'}'){|_, _, comparison, _, _, statement_list, _| WhileNode.new(comparison, statement_list)}
            end 


            rule :condition do
                #match('if', '(', :expr, ')', '{', :statement_list, :midcond,'}') {|_, _, condition, _, _, statement_list1, _, statement_list2| ElseIfNode.new(condition, statement_list ) }
                


                match('1f', '(', :expr, ')', '{', :statement_list, '}','3l53', 
                '{', :statement_list,'}') {|_, _, condition, _, _, statement_list1, _, _, _, statement_list2, _| ElseNode.new(condition, statement_list1, statement_list2) }
                


                match('1f', '(', :expr, ')', '{', :statement_list, '}') {|_, _, condition, _, _, statement_list, _| IfNode.new(condition, statement_list ) }
            end

=begin
            rule :midcond do
                match('elseif', '(', :expr, ')', '{', :statement_list, :endcond, '}' )
                match('elseif', '(', :expr, ')', '{', :statement_list, '}' )
            end

            rule :endcond do
                match('else', '{', :statement_list, '}')
            end                
=end
			rule :expr do 
				match(:expr, :arithm_op , :term) {|lhs, op, rhs| ArithmNode.new(lhs, op, rhs)}
				match(:term) 
			end

			rule :term do 
				match(:term, :term_op, :logic) {|lhs, op, rhs| ArithmNode.new(lhs, op, rhs)}
				match(:logic)
			end

            rule :logic do
                match(:logic, :logic_op, :comparison) {|lhs, op, rhs| LogicNode.new(lhs, op, rhs)} 
                match(:not_logic_op, :comparison) {|op, rhs| NotLogicNode.new(op, rhs)}
                match(:comparison)
            end

			rule :comparison do
				match(:comparison, :comp_op, :factor) {|lhs, op, rhs| CompNode.new(lhs, op, rhs)}
				match(:factor)
            end
                        
            rule :factor do 
                match('(', :expr, ')') {|_, expr, _| expr}  
                match(:float) 
                match(:integer)
                match(:string)
                match(:bool)
                match(:var)
            end

			rule :arithm_op do
				match('+')
				match('-')
			end

            rule :term_op do
				match('*')
                match('/')
                match('%')
			end
            
            rule :logic_op do
                match('4nd')
                match('0r')
            end

            rule :not_logic_op do
                match('n07')
            end

            rule :comp_op do
				match('<') 
				match('>')  
				match('>=')
				match('<=')
				match('==')
				match('!=')
			end


			rule :float do
                match('-', Float) {|_, float| FactorNode.new(-float)}
                match(Float) {|float| FactorNode.new(float) } 
            end
            
			rule :integer do
                match('-', Integer) {|_, integer| FactorNode.new(-integer)}
                match(Integer) {|integer| FactorNode.new(integer) } 
			end

            rule :string do
                match(/"[^\"]*"/) {|string| FactorNode.new(string)}
                match(/'[^\"]*'/) {|string| FactorNode.new(string)}
            end

            rule :bool do
                match(/7ru3/) {|bool| BoolNode.new(bool) }
                match(/f4l53/) {|bool| BoolNode.new(bool) }
            end

            rule :var do
                match(/[a-zA-Z]+/) {|var| VarNode.new(var)}
            end
		end
	end


    def done(str)
        ["quit","exit","bye",""].include?(str.chomp)
    end


    def start_with_file(file)
    	result = Array.new()
    	file = File.read(file)
      	result = @leetparser.parse(file)
      	result.eval
    end


    
    def run_file(filename)
        code = "";
        File.open(filename, "r") do |f|
            f.each_line do |line|
            code += line
            end
        end
        puts "============> #{@leetparser.parse code}"
    end


    def roll
        print "[LeetLang] "
        str = gets
        if done(str) then
            puts "Bye."
        else
            puts "=> #{@leetparser.parse str}"
            roll
        end
    end
    

    def log(state = true)
      	if state
        	@leetparser.logger.level = Logger::DEBUG
      	else
        	@leetparser.logger.level = Logger::WARN
      	end
    end
end



p = Leet.new
p.log(true)
p.start_with_file("leet.txt")

#p.run_file("leet.txt")
#p.roll



=begin
class TestFaculty < Test::Unit::TestCase

  def test_logic1
    reader = Leet.new
    reader = reader.leetparser
	assert_equal(reader.parse('1 + 2'), 3)
	assert_equal(reader.parse('5 - 2'), 3)
  end
end
=end













=begin
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
=end