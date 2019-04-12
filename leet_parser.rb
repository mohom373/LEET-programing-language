require './debug_fix_rdparse.rb'
require './leet_node.rb'

class Leet

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
                # match(:assignment)
                # match(:input)
                # match(:output)
                # match(:condition)
                # match(:repetition)
                # match(:return)
                # match(:break)
                # match(:function_definition)
                # match(:function_call)
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
            rule :expr do 
                match(:a_expr)
                match(:m_expr)
            end

            rule :a_expr do
                match(:integer, "+", :integer) {|a,_,b| AddNode.new(a,b)}
                #match(:integer, "-", :integer) {|a,_,b| MinusNode.new(a,b)}
                #match(:m_expr, "+", :integer){|a,_,b| AddNode.new(a,b)}
            end
=begin
            rule :m_expr do 
                match(:expr, "*", :integer) { |a,_,b| MultiNode.new(a,b) }
            end
=end


            rule :integer do
                match(Integer)
            end

        end
    end

    def run(str)
        @leetparser.parse(str).eval
    end

end

Leet.new.run "1 + 2"

#Leet.new.run "5 - 3"