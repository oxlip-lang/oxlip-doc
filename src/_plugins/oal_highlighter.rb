# Inspired by https://github.com/linkedin/rest.li/blob/gh-pages-source/src/_plugins/pdl_highlighter.rb
Jekyll::Hooks.register :site, :pre_render do |site|
    puts "Registering OAL lexer..."
    require "rouge"
  
    class OalLexer < Rouge::RegexLexer
      title 'OAL'
      desc 'Oxlip API Language'
      tag 'oal'
      filenames '*.oal'
   
      state :root do
        rule /\s+/, Text::Whitespace
        rule %r{//[^\r\n]*[\r\n]*}, Comment::Single
        rule %r{/\*([^*]|\*[^/])*\*/}m, Comment::Multiline
        rule /\b(num|str|uri|bool|int)\b/, Keyword::Type
        rule /\b(as|on|rec)\b/, Operator
        rule %r{(::|->)}, Operator
        rule /\b(get|put|post|patch|delete|options|head)\b/, Keyword::Constant
        rule /\b(media|headers|status)\b/, Name::Builtin
        rule /\b(let|res|use)\b/, Keyword::Reserved
        rule %r{/[0-9a-zA-Z%~_.-]*}, Literal
        rule %r{[a-zA-Z_][0-9a-zA-Z$_-]*}, Name::Variable
        rule %r{@[0-9a-zA-Z$_-]+}, Name::Variable::Global
        rule %r{[1-5]XX}, Literal::Number::Integer
        rule %r{[0-9]+}, Literal::Number::Integer
        rule %r{"[^"]*"}, Literal::String
        rule %r{'[0-9a-zA-Z$@_-]+}, Name::Property
        rule /[{}()\[\]<>;.,]/, Punctuation
        rule /[!?&~|=:]/, Operator
        rule %r{#[^\r\n]*[\r\n]*}, Comment::Preproc
        rule %r{`[^`]*`}, Comment::Preproc
      end
    end
  end