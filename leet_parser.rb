require './debug_fix_rdparse.rb'
require './leet_node.rb'
require 'test/unit'

class Leet

    attr_reader :leetparser 
    def initialize 
        @leetparser = Parser.new("L33t lang") do
            token(/\s+/) # Ignore whitespaces
            #token(/--.+/) # Ignore comments
            token(/pr1n7/) {|x| x} # Match print function
            token(/4nd/)
            token(/0r/)
            token(/\d+[.]\d+/) {|x| x.to_f} # Match float
            token(/\d+/) { |x| x.to_i } # Match integer
            token(/[a-zA-Z]+/) {|x| x.to_s} # Match chars
            token(/\=\=/) {|x| x}  
            token(/\!\=/) {|x| x} 
            token(/\>\=/) {|x| x}
            token(/\<\=/) {|x| x}
            #token(/and/) {|x| x}
            #token(/or/) {|x| x}
            token(/./) {|x| x}



            start :program do
                match(:statement_list)
            end

            rule :statement_list do 
                match(:statement_list, :statement) { |stmt_list, stmt| StmtList.new(stmt_list, stmt) }
                match(:statement) { |stmt| stmt }
            end

            rule :statement do 
                  
                # match(:input)
                # match(:output)
                # match(:condition)
                # match(:repetition)
                # match(:return)
                # match(:break)
                # match(:function_definition)
                # match(:function_call)
                match(:print_stmt)  
				
				#match(:assign)
				match(:expr) 
            end

            rule :print_stmt do
                match('pr1n7', '"', :expr, '"') {|_, _, print_val ,_|PrintNode.new(print_val) }
            end
              
		
=begin
            rule :assign do
                match(:var, '=', :expr){|var, _, expr|@@variables[var]= expr}
            end
=end
			rule :expr do 
				match(:bool_expr)
			end

			rule :bool_expr do 
				match(:bool_expr, '0r', :bool_term) {|lhs, op, rhs| RelationAndLogicNode.new(lhs, op, rhs)}
				match(:bool_term)
			end

			rule :bool_term do 
				match(:bool_term, '4nd', :bool_factor) {|lhs, op, rhs| RelationAndLogicNode.new(lhs, op, rhs)}
				match(:bool_factor)
			end

            rule :bool_factor do
                match('(', :bool_expr, ')') {|_, expr, _| expr}
				#match('true') {|bool| Factor.new(bool)}
                #match('false') {|bool| Factor.new(bool)}
                #match(:var)
                match(:bool_val)
                match(:comparison)
            end

            rule :bool_val do
                match('true')
                match('false')
            end
            
			rule :comparison do
				match(:comparison, :comp_op, :arithmetic) {|lhs, op, rhs| RelationAndLogicNode.new(lhs, op, rhs)}
				match(:arithmetic)
			end

			rule :comp_op do
				match('<')
				match('>')
				match('>=')
				match('<=')
				match('==')
				match('!=')
			end

			rule :arithmetic do
				match(:arithmetic, :add_op, :term) {|lhs,op,rhs| ArithmNode.new(lhs,op,rhs)}
				match(:term)
			end

			rule :add_op do
				match('+')
				match('-')
			end

			rule :term do
				match(:term, :mult_op, :factor) {|lhs,op,rhs| TermNode.new(lhs,op,rhs)}
				match(:factor)
			end

			rule :mult_op do
				match('*')
				match('/')
			end
			rule :factor do
                match('(', :expr, ')') {|_, expr, _| expr}  
                #match(:var)
                match(:integer)
                match(:float)
            end


			rule :integer do
                match(Integer) {|integer| Factor.new(integer) } 
                match('-', Integer) {|_, integer| Factor.new(-integer)}
			end

			rule :float do
                match(Float) {|float| Factor.new(float) } 
                match('-', Float) {|_, float| Factor.new(-float)}
			end

=begin
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
=end


		end
	end
=begin
            rule :literal do
                match('<1n7>') 
                match('<fl047>')
                match('<57r1ng>') 
                match('b00l')
                match('<l157>')
            end
=end


=begin
    def run(str)
       @leetparser.parse(str)
    end
=end


#Leet.new.run "tja = true"

    def done(str)
        ["quit","exit","bye",""].include?(str.chomp)
    end


    def start_with_file(file)
    	result = Array.new()
    	file = File.read(file)
      	result = @leetparser.parse(file)
      	puts result.eval
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