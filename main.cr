require "./lexer"
require "./runner"

code = File.read ARGV[0]
lexed = Lexer.lex code
(Runner.new).run lexed
