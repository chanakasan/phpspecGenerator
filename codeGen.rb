require "thor"
require 'erubis'

class PhpSpecGenerator
    attr_accessor :namespace, :fields

    def namespace=(namespace)
        @namespace = namespace
        @namespace.to_s.gsub! '/', '\\'
    end

    def fields=(f)
        @fields = f.to_str.gsub(/\s+/, "").split(',')
    end

    def generate(output_path)
        specs_input = File.read('templates/specs.eruby')
        specs_template = Erubis::Eruby.new(specs_input)

        class_input = File.read('templates/class.eruby')
        class_template = Erubis::Eruby.new(class_input)

        specs = ''
        @fields.each do |f|
            specs << specs_template.result(binding())
        end

        output = class_template.result(binding())
        File.write(output_path, output)
    end
end

class CodeGenerator < Thor
    desc "go OUTPUT_PATH", "start the tool"

    def go(output_path = '/home/cs/Desktop/someSpec.php')
        @generator = PhpSpecGenerator.new
        @generator.namespace = ask("Enter namespace: ")
        @generator.fields = ask("Enter field names (separated by commmas): ")

        @generator.generate(output_path)
        puts "\nDone!"
        puts "Generated at #{output_path}"
    end

end

CodeGenerator.start(ARGV)
