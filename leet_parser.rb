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
            token(/\d+[.]\d+/) {|x| x.to_f} # Match float
            token(/\d+/) { |x| x.to_i } # Match integer
            token(/[a-zA-Z]+/) {|x| x.to_s} # Match chars
            token(/"[\w\W]*"/) {|x| x.to_s} #String
            token(/true/) {|x| x}
            token(/false/) {|x| x}
            token(/and/) {|x| x}
            token(/or/) {|x| x}
            token(/not/) {|x| x}
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
                  
                # match(:repetition)
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
                match('pr1n7', '(', :expr, ')') {|_, _, print_val ,_|PrintNode.new(print_val) }
                
                match('pr1n7', '(', :assign, ')') {|_, _, print_val ,_|PrintNode.new(print_val) }

                match('pr1n7', '(', :var, ')') {|_, _, print_val ,_|PrintNode.new(print_val) }
            end
              
=begin
            rule :assign do
                match(:var, '=', :expr){|var, _, expr|@@variables[var]= expr}
            end
=end

            rule :declare do
                match(:type_name, :var, '=', :expr) {|type, var, _, expr| DeclareNode.new(type, var, expr)}
            end

            rule :type_name do
                match(/1n7/) {Integer}
                match(/fl047/) {Float}
                match(/b00l/) 
                match(/57r1ng/) {String}

            end
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
                match(:data_type)
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
                match('and')
                match('or')
            end

            rule :not_logic_op do
                match('not')
            end

            rule :comp_op do
				match('<')
				match('>')
				match('>=')
				match('<=')
				match('==')
				match('!=')
			end


            rule :data_type do
                match(:float) 
                match(:integer)
                match(:string)
                match(:bool)
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
                match(/"[\w\W]*"/) {|string| FactorNode.new(string)}
            end

            rule :bool do
                match(/true/) {|bool| BoolNode.new(bool) }
                match(/false/) {|bool| BoolNode.new(bool) }
            end
=begin
            rule :var do
                #match(String)
                match(/[a-zA-Z]+/) {|var| @@variables.include?(var) ?@@variables[var] : var}
            end
=end
            rule :var do
                match(/[a-zA-Z]+/) {|var| VarNode.new(var)}
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


		end
	end
#Leet.new.run "tja = true"

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
        puts "=> #{@leetparser.parse code}"
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