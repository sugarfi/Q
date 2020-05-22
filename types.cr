class Blob
    @val : Array(Int32)
    def initialize(val : Array(Int32))
        @val = val
    end
    def initialize(val : String)
        @val = (val[1, val.size - 2].split ' ').map { |s| s.to_i }
    end
    def val
        @val
    end
end

class Promise
    @name : String
    @blob : Blob
    def initialize(name : String, blob : Blob)
        @name = name
        @blob = blob
    end
    def name
        @name
    end
    def blob
        @blob
    end
end

class Handler
    @name : String
    @promise : Promise
    def initialize(name : String, promise : Promise)
        @name = name
        @promise = promise
    end
    def name
        @name
    end
    def promise
        @promise
    end
end

class Queue
    @val : Array(Queue | Blob | Promise)
    @handlers : Array(Handler)
    @name : String
    def initialize(name : String, val : Array(Queue | Blob | Promise))
        @name = name
        @val = val
        @handlers = [] of Handler
    end
    def name
        @name
    end
    def push(val : Blob | Promise | Queue)
        @val << val
    end
    def pop
        val = @val[0]
        @val = @val[1, @val.size - 1]
        val
    end
    def empty
         @val.reject { |i| i.is_a?(Queue) }.size == 0 ? true : false
    end
    def find(name : String)
        return (@val.reject { |i| ! i.is_a?(Queue) }).reject { |i| i.as(Queue).name != name }
    end
    def handler(val : Handler)
        @handlers << val
    end
    def handlers
        @handlers
    end
    def print(indent : Int32 = 0)
        puts ("  " * indent) + @name
        @val.each do |item|
            if item.is_a? Blob
                puts ("  " * (indent + 1)) + "[" + item.val.join(" ") + "]"
            elsif item.is_a? Queue
                item.print(indent + 1)
            end
        end
    end
end
