require './debug_fix_rdparse.rb'
require './leet_node.rb'

class Leet
    attr_reader :leetparser 
    def initialize 
        @leetparser = Parser.new("L33t lang") do

            #============================== TOKENS

            token(/\s+/) # Ignore whitespaces
            token(/{--(.|\n)*--}/) # Ignore multiline comments
            token(/--.*/) # Ignore single line comments

            #============================== RESERVED WORDS
            token(/l157/) {|x| x} # List container
            token(/r37urn/) {|x| x} # Match Return
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

            #============================== LIST WORDS
            token(/51z3/) {|x| x} # Size
            token(/4pp3nd/) {|x| x} # Append
            token(/r3m0v3/) {|x| x} # Remove
            token(/1n53r7/) {|x| x} # Insert
            token(/g37/) {|x| x} # Get

            #============================== OTHER
            token(/\d+[.]\d+/) {|x| x.to_f} # Match float
            token(/\d+/) { |x| x.to_i } # Match integer
            token(/[a-zA-Z]+/) {|x| x} # Match chars
            token(/"[^\"]*"/) {|x| x.to_s } # Double quote string
            token(/'[^\"]*'/) {|x| x.to_s } # Single quote string
            token(/func/) {|x| x} # Function
            token(/{/) {|x| x } # Block
            token(/}/) {|x| x } # Block
            token(/\[/) {|x| x}
            token(/\]/) {|x| x}
            token(/\=\=/) {|x| x} # Relational operator check
            token(/\!\=/) {|x| x} # Relational operator check
            token(/\>\=/) {|x| x} # Relational operator check
            token(/\<\=/) {|x| x} # Relational operator check
            token(/./) {|x| x}

            #============================== PROGRAM & STMTS

            start :program do
                match(:statement_list) {|stmt_list| StmtListNode.new(stmt_list)}
            end

            rule :statement_list do 
                match(:statement_list, :statement) {|statement_list, statement| statement_list.concat(statement)}
                match(:statement) { |stmt| stmt }
            end

            rule :statement do 
                match(:print_stmt) {|x| [x]}
                match(:return) {|x| [x]}
                match(:function_definition) {|x| [x]}
                match(:function_call) {|x| [x]}
                match(:repetition) {|x| [x]}
                match(:condition) {|x| [x]}
                match(:declare) {|x| [x]}
				match(:assign) {|x| [x]}
                match(:expression) {|x| [x]}
            end

            #============================== PRINT

            rule :print_stmt do
                match('pr1n7', '(', :expression, ')', ';') {|_, _, print_val, _ , _|PrintNode.new(print_val)}
            end
            
            #============================== RETURN

            rule :return do
                match('r37urn', '(', :expression, ')', ';'){|_, _, return_val, _, _| ReturnNode.new(return_val)}
            end

            #============================== FUNCTIONS

            rule :function_definition do
                match('func', :var, '(', :parameter_list,')', '{', :statement_list, '}') { |_, function_name, _, parameter_list, _, _, statement_list, _| FunctionDefNode.new(function_name, parameter_list , statement_list)}

                match('func', :var, '(', ')', '{', :statement_list, '}') { |_, function_name, _, _, _, statement_list, _| FunctionDefNode.new(function_name, [] ,statement_list)}
            end

            rule :parameter_list do
                match(:parameter_list, ',' ,:parameter) {|parameter_list, _, parameter| 
                    if parameter[0] != Array
                        parameter_list.concat([parameter])
                    else 
                        parameter_list.concat(parameter)
                    end}
                match(:parameter) {|parameter| [parameter]}
            end

            rule :parameter do 
                match('<', :type_name, '>', :var) {|_, type_name, _, var| [type_name, var.identifier] }
            end

            rule :function_call do
                match(:var, '(', :argument_list, ')', ';') {|function_name, _, argument_list, _, _| FunctionCallNode.new(function_name, argument_list)}
                
                match(:var, '(', ')', ';') {|function_name| FunctionCallNode.new(function_name, [])}
            end

            rule :argument_list do 
                match(:argument_list, ',', :argument) {|argument_list, _, argument| 
                    if argument.class != Array
                        argument_list.concat(argument)
                    else
                        argument_list.concat(argument)
                    end}
                match(:argument) 
            end

            rule :argument do 
                match(:expression) {|expression| [expression]}
            end

            #============================== CONTROL STRUCTURES

            rule :repetition do 
                match('wh1l3', '(', :expression, ')', '{', :statement_list,'}'){|_, _, condition, _, _, statement_list, _| WhileNode.new(condition, statement_list)}
            end 

            rule :condition do
                match('1f', '(', :expression, ')', '{', :statement_list, '}','3l53', 
                '{', :statement_list,'}') {|_, _, condition, _, _, statement_list1, _, _, _, statement_list2, _| ElseNode.new(condition, statement_list1, statement_list2) }
                
                match('1f', '(', :expression, ')', '{', :statement_list, '}') {|_, _, condition, _, _, statement_list, _| IfNode.new(condition, statement_list ) }
            end

            #============================== VARIABLE DECL & ASSIGN

            rule :declare do
                match('<', :type_name, '>', :var, '=', :expression) {|_, type, _, var, _, expression| DeclareNode.new(type, var, expression)}
            end

            rule :assign do
                match(:var, '=', :expression) {|var, _, expression| AssignNode.new(var, expression)}    
            end

            #============================== EXPRESSION

            rule :expression do 
				match(:or_expression)
			end

            rule :or_expression do 
                match(:or_expression, :or_logic_op, :and_expression) {|lhs, op, rhs| LogicNode.new(lhs, op, rhs)}
                match(:and_expression)
            end

            rule :and_expression do 
                match(:and_expression, :and_logic_op, :not_expression) {|lhs, op, rhs| LogicNode.new(lhs, op, rhs)}
                match(:not_expression)
            end
            
            rule :not_expression do
                match(:not_logic_op, :comparison) {|op, rhs| NotLogicNode.new(op, rhs)}
                match(:comparison)
            end

			rule :comparison do
				match(:comparison, :comp_op, :factor) {|lhs, op, rhs| CompNode.new(lhs, op, rhs)}
                match(:arithm)
            end

            rule :arithm do 
				match(:arithm, :arithm_op , :term) {|lhs, op, rhs| ArithmNode.new(lhs, op, rhs)}
                match(:term) 
            end
                        
            rule :term do 
				match(:term, :term_op, :factor) {|lhs, op, rhs| ArithmNode.new(lhs, op, rhs)}
				match(:factor)
			end

            #============================== FACTOR

            rule :factor do 
                match(:function_call)
                match('(', :expression, ')') {|_, expression, _| expression}  
                match(:type)
                match(:list)
                match(:list_functions)
                match(:var)
            end

            #============================== LIST 
            rule :list do 
                match('[', :argument_list,']') {|_, list, _| ListNode.new(list.flatten)}
                match('[', ']') {|_, _| ListNode.new([])}
            end

            rule :list_functions do 
                match(:list_append)
                match(:list_remove)
                match(:list_size)
                match(:list_insert)
                match(:list_get) 
            end

            rule :list_append do 
                match('4pp3nd', '!', '(', :var, ')', '{' , :argument_list, '}') {|operator, _, _, list, _, _, expression, _| ListFunctionsNode.new(operator, list, expression)}
            end

            rule :list_remove do 
                match('r3m0v3', '!', '(', :var, ')', '(' , Integer, ')', ';') {|operator, _, _, list, _, _, index, _, _| ListFunctionsNode.new(operator, list, nil, index)}
            end

            rule :list_size do 
                match('51z3', '?', '(', :var, ')', ';') {|operator, _, _, list, _, _| ListFunctionsNode.new(operator, list)}
            end

            rule :list_insert do 
                match('1n53r7', '!', '(', :var, ')', '(', Integer, ')', '{', :expression, '}') {|operator, _, _, list, _, _, index, _, _, expression, _| ListFunctionsNode.new(operator, list, expression, index)}
            end

            rule :list_get do  
                match('g37', '!', '(', :var, ')', '(' , Integer, ')', ';') {|operator, _, _, list, _, _, index, _, _| ListFunctionsNode.new(operator, list, nil, index)}
            end

            #============================== OPERATORS

			rule :arithm_op do
				match('+')
				match('-')
			end

            rule :term_op do
				match('*')
                match('/')
                match('%')
			end

            rule :or_logic_op do
                match('0r')
            end

            rule :and_logic_op do
                match('4nd')
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
            
            #============================== TYPES

            rule :type do 
                match(:float) 
                match(:integer)
                match(:string)
                match(:bool)
            end

            rule :type_name do
                match(/fl047/) {Float}
                match(/1n7/) {Integer}
                match(/57r1ng/) {String}
                match(/b00l/)
                match(/l157/) {Array} 
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
                match(/"[^\"]*"/) {|string| FactorNode.new(string.slice(1, string.length - 2).to_s)}
                match(/'[^\"]*'/) {|string| FactorNode.new(string.slice(1, string.length - 2).to_s)}
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

    def parse_file()
        if (ARGV.length() != 1)  
            puts "Error: No arguments given"
            puts "Usage: ruby leet_parser.rb FILE_TO_PARSE"
        else 
            file = File.read(ARGV[0])
            result = @leetparser.parse(file)
            result.eval
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
p.log(false)
p.parse_file()