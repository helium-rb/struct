module Helium
  module Struct
    module Formattable
      if defined? Helium::Console
        Helium::Console.define_formatter_for self do
          def call
            table = Helium::Console::Table.new format_keys: false, runner: '| '

            object.class.attributes.each do |attr|
              table.row light_blue("#{attr}:"), object.send(:values)[attr]
            end

            object.class.nested_structs.keys.each do |nested|
              table.row light_blue("#{nested}:"), object.send(:nested)[nested], name: false
            end

            name = options.fetch :name, object.respond_to?(:struct_name, true) ? object.send(:struct_name) : object.class.name

            yield_lines do |y|
              y << "# #{light_yellow name}" if name
              format(table).lines.each { |line| y << line }
            end
          end
        end
      end
    end
  end
end
