require './debug_fix_rdparse.rb'
require './leet_node.rb'
require 'test/unit'

class Leet
    attr_reader :leetparser 
    def initialize 
        @leetparser = Parser.new("L33t lang") do
            token(/\s+/) # Ignore whitespaces
            token(/{--(.|\n)*--}/) # Ignore multiline comments
            token(/--.*/) # Ignore single line comments
            token(/pr1n7/) {|x| x} # Match print function
            token(/1n7/) {|x| x} # Int type
            token(/fl047/) {|x| x} # Float type 
            token(/b00l/) {|x| x} # Bool type
            token(/57r1ng/) {|x| x} # String type
            token(/1f/) {|x| x} # If
            token(/3l53/) {|x| x} # Else
            token(/n07/) {|x| x} # Not operator
            token(/7ru3/) {|x| x} # True
            token(/f4l53/) {|x| x} # False 
            token(/4nd/) {|x| x} # And operator
            token(/0r/) {|x| x} # Or operator
            token(/wh1l3/) {|x| x} # While loop
            token(/\d+[.]\d+/) {|x| x.to_f} # Match float
            token(/\d+/) { |x| x.to_i } # Match integer
            token(/[a-zA-ZåäöÅÄÖ]+/) {|x| x.to_s} # Match chars
            token(/"[^\"]*"/) {|x| x.to_s } # Double quote string
            token(/'[^\"]*'/) {|x| x.to_s } # Single quote string
            token(/func/)
            token(/{/) {|x| x } # Block
            token(/}/) {|x| x } # Block
            token(/\=\=/) {|x| x} # Relational operator check
            token(/\!\=/) {|x| x} # Relational operator check
            token(/\>\=/) {|x| x} # Relational operator check
            token(/\<\=/) {|x| x} # Relational operator check
            token(/./) {|x| x}

            start :program do
                match(:statement_list)
            end

            rule :statement_list do 
                match(:statement_list, :statement) { |stmt_list, stmt| StmtListNode.new(stmt_list, stmt) }
                match(:statement) { |stmt| stmt }
            end

            rule :statement do 
                match(:print_stmt) {|x| x}
                # match(:return)
                match(:function_definition) {|x| x}
                match(:function_call) {|x| x}
                match(:declare) {|x| x}
				match(:assign) {|x| x}
                match(:repetition) {|x| x}
                match(:condition) {|x| x}
                match(:expr)  {|x| x}
            end

            rule :print_stmt do
                match('pr1n7', '(', :expr, ')', ';') {|_, _, print_val ,_ ,_|PrintNode.new(print_val)}
                
                match('pr1n7', '(', :assign, ')', ';') {|_, _, print_val ,_ ,_|PrintNode.new(print_val)}

            end
              
            rule :function_definition do
                match('func', :var, '(', ')', '{', :statement_list, '}') { |_, function_name, _, _, _, statement_list, _| FunctionDefNode.new(function_name, statement_list)}
            end

            rule :function_call do
                match(:var, '(', ')', ';') {|function_name| FunctionCallNode.new(function_name)}
            end

            rule :declare do
                match(:type_name, :var, '=', :expr) {|type, var, _, expr| DeclareNode.new(type, var, expr)}
            end

            rule :assign do
                match(:var, '=', :expr) {|var, _, expr| AssignNode.new(var, expr)}    
            end

            rule :repetition do 
                match('wh1l3', '(', :logic, ')', '{', :statement_list,'}'){|_, _, condition, _, _, statement_list, _| WhileNode.new(condition, statement_list)}
            end 

            rule :condition do
                match('1f', '(', :logic, ')', '{', :statement_list, '}','3l53', 
                '{', :statement_list,'}') {|_, _, condition, _, _, statement_list1, _, _, _, statement_list2, _| ElseNode.new(condition, statement_list1, statement_list2) }
                
                match('1f', '(', :logic, ')', '{', :statement_list, '}') {|_, _, condition, _, _, statement_list, _| IfNode.new(condition, statement_list ) }
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
                match(:function_call)
                match(:float) 
                match(:integer)
                match(:string)
                match(:bool)
                match(:var)
            end

            rule :type_name do
                match(/fl047/) {Float}
                match(/1n7/) {Integer}
                match(/57r1ng/) {String}
                match(/b00l/) 
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

    def log(state = true)
      	if state
        	@leetparser.logger.level = Logger::DEBUG
      	else
        	@leetparser.logger.level = Logger::WARN
      	end
    end
end

p = Leet.new
p.log(false)
#p.start_with_file("leet.txt")
p.start_with_file("leet_test2.txt")








