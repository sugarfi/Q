class Node
    @name : String
    @arrow : String
    @blob : String | Node
    def initialize(name : String, arrow : String, blob : String | Node)
        @name = name
        @arrow = arrow
        @blob = blob
    end
    def name
        @name
    end
    def arrow
        @arrow
    end
    def blob
        @blob
    end
end

class Lexer
    @@BLOB = /\[([0-9]+ *)+\]/
    @@NAME = /[^ ]+/
    @@ARROW = /(<-|->)/

    def self.match(code : String, token : Regex)
        match = code.match token
        if match == nil
            raise "Invalid syntax"
        end
        match = match.as(Regex::MatchData)[0]
        return match, code[match.size, code.size - match.size].lstrip
    end

    def self.lex(code : String, wait : Bool = true)
        out = [] of Node
        while code.size > 0
            if code[0] == '('
                code = code[1, code.size - 1]
                name, code = self.match code, @@NAME
                arrow, code = self.match code, @@ARROW
                if arrow == "<-"
                    blob, code = self.match code, @@BLOB
                    if code[0] == ')'
                        code = code[1, code.size - 1].lstrip
                        out << Node.new name, arrow, blob
                        if ! wait
                            break
                        end
                    end
                elsif arrow == "->"
                    if code[0] == '('
                        out << Node.new name, arrow, self.lex(code, false)[0]
                        while code[0] != ')'
                            code = code[1, code.size - 1].lstrip
                        end
                        code = code[1, code.size - 1].lstrip
                        code = code[1, code.size - 1].lstrip
                    end
                end
            end
        end
        out
    end
end
