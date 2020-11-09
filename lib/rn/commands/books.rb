module RN
  module Commands
    module Books
      require 'fileutils'

      class Create < Dry::CLI::Command
        desc 'Create a book'

        argument :name, required: true, desc: 'Name of the book'

        example [
          '"My book" # Creates a new book named "My book"',
          'Memoires  # Creates a new book named "Memoires"'
        ]

        def call(name:, **)
          if name[/\W/].nil?
            if File.exist?("#{Commands::MY_RNS_PATH}/#{name}")
              warn "El libro #{name} ya existe."
            else
              Dir.mkdir("#{Commands::MY_RNS_PATH}/#{name}")
            end
          else 
            warn 'Nombre invalido'
          end
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a book'

        argument :name, required: false, desc: 'Name of the book'
        option :global, type: :boolean, default: false, desc: 'Operate on the global book'

        example [
          '--global  # Deletes all notes from the global book',
          '"My book" # Deletes a book named "My book" and all of its notes',
          'Memoires  # Deletes a book named "Memoires" and all of its notes'
        ]
  

        def call(name: nil, **options)
          global = options[:global]
          if global
            FileUtils.rm_r("#{MY_RNS_PATH}/global")
            warn "'global' eliminado."
          elsif File.exist?("#{MY_RNS_PATH}/#{name}")
            FileUtils.rm_r("#{MY_RNS_PATH}/#{name}")
            warn "'#{name}' eliminado."
          else
            warn "No se pudo eliminar el cuaderno '#{name}' (No existe). "
          end
        end
      end

      class List < Dry::CLI::Command
        desc 'List books'

        example [
          '          # Lists every available book'
        ]

        def call(*)
          Dir.each_child("#{MY_RNS_PATH}") {|cuaderno| puts cuaderno}
        end
      end

      class Rename < Dry::CLI::Command
        desc 'Rename a book'

        argument :old_name, required: true, desc: 'Current name of the book'
        argument :new_name, required: true, desc: 'New name of the book'

        example [
          '"My book" "Our book"         # Renames the book "My book" to "Our book"',
          'Memoires Memories            # Renames the book "Memoires" to "Memories"',
          '"TODO - Name this book" Wiki # Renames the book "TODO - Name this book" to "Wiki"'
        ]

        def call(old_name:, new_name:, **)
          begin
            if not new_name[/\W/].nil?
              File.rename("#{MY_RNS_PATH}/#{old_name}", "#{MY_RNS_PATH}/#{new_name}")  
            else
              warn 'Nuevo nombre invalido'
            end
          rescue 
            warn 'No se pudo renombrar.'
          end
        end
      end
    end
  end
end