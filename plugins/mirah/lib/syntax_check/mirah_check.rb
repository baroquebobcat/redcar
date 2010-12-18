require 'java'

module Redcar
  module SyntaxCheck
    class Mirah < Checker
      supported_grammars "Mirah"
      
      require 'mirah-parser.jar'
      import 'mirah.impl.MirahParser'
      import 'jmeta.ErrorHandler'
      
      class MyErrorHandler
        include ErrorHandler

        def problem(m)
          (@problems||=[]) << m
        end
        
        def problems
          @problems || []
        end

        def warning(messages, positions)
          messages.zip(positions).each do |message, position|
            problem "Warning: #{message} #{position}"             
          end
        end

        def error(messages, positions)
          messages.zip(positions).each do |message, position|
            problem "Warning: #{message} #{position}"             
          end
        end
      end
      

      def check(*args)
        path = manifest_path(doc)
        
        parser = MirahParser.new
        parser.filename = path
        # If you want to get warnings
        parser.errorHandler = MyErrorHandler.new
        
        begin
          parser.parse(IO.read(path))
        rescue
          m = $!.message
          error = m.split(" (").first
          if info = m.match(/line: ([0-9]+), char: ([0-9]+)\)/)
            SyntaxCheck::Error.new(doc, info[1].to_i-1, error).annotate
          end
        end
        
        handler.problems.each { |problem|
          if info = problem.match(/line: ([0-9]+), char: ([0-9]+)\)/)
            SyntaxCheck::Error.new(doc, info[1].to_i-1, problem.split(" (").first).annotate
          end
        }
      end
    end
  end
end
