require "./types"
require "./lexer"

class Runner
    @root : Queue

    def initialize
        @root = Queue.new "root", [] of Queue | Blob | Promise
    end

    def run(lexed : Array(Node))
        lexed.each do |item|
            if item.arrow == "<-"
                @root.push Promise.new item.name, Blob.new item.blob.as String
            elsif item.arrow == "->"
                name = (item.blob.as Node).name
                blob = (item.blob.as Node).blob
                @root.handler Handler.new item.name, Promise.new name, Blob.new blob.as String
            end
        end
        while ! @root.empty
            item = @root.pop
            if item.is_a? Promise
                name = item.name
                if (@root.find name).size > 0
                    ((@root.find name)[0].as Queue).push item.blob
                    @root.handlers.each do |handler|
                        if handler.name == name
                            @root.push handler.promise
                        end
                    end
                else
                    @root.push Queue.new name, [item.blob.as Blob | Promise | Queue]
                    @root.handlers.each do |handler|
                        if handler.name == name
                            @root.push handler.promise
                        end
                    end
                end
            elsif item.is_a? Blob | Queue
                @root.push item
            end
        end
        @root.print
    end
end
