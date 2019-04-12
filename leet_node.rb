
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

