require './debug_fix_rdparse.rb'

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
                match(:expr)
                # match(:assignment)
                # match(:input)
                # match(:output)
                # match(:condition)
                # match(:repetition)
                # match(:return)
                # match(:break)
                # match(:function_definition)
                # match(:function_call)
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
                match(:integer, "+", :integer) {|a,_,b| AddNode.new(a,b)}
            end

            rule :integer do
                match(Integer)
            end

        end
    end

    def run(str)
        @leetparser.parse(str).eval
    end

end

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

Leet.new.run "1 + 2"