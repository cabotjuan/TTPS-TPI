module RN
  module Commands
    module Notes
      class Create < Dry::CLI::Command
        desc 'Create a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Creates a note titled "todo" in the global book',
          '"New note" --book "My book" # Creates a note titled "New note" in the book "My book"',
          'thoughts --book Memoires    # Creates a note titled "thoughts" in the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          begin
            if title[/\W/].nil?
              if book
                File.new("#{MY_RNS_PATH}/#{book}/#{title}.rn","w")
              else
                File.new("#{MY_RNS_PATH}/global/#{title}.rn","w")
              end
            else
              warn 'Titulo invalido.'
            end
          rescue
            warn "No se pudo crear la nota #{title}.rn"
          end
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Deletes a note titled "todo" from the global book',
          '"New note" --book "My book" # Deletes a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Deletes a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          begin
            if book
              File.delete("#{MY_RNS_PATH}/#{book}/#{title}.rn") 
            else
              File.delete("#{MY_RNS_PATH}/global/#{title}.rn")
            end
          rescue
            warn "No se pudo eliminar #{title}.rn"
          end
        end
      end

      class Edit < Dry::CLI::Command

        require 'tty-editor'
        desc 'Edit the content a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Edits a note titled "todo" from the global book',
          '"New note" --book "My book" # Edits a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Edits a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          if book && File.exist?("#{MY_RNS_PATH}/#{book}/#{title}.rn")
            TTY::Editor.open("#{MY_RNS_PATH}/#{book}/#{title}.rn")
          elsif not book && File.exist?("#{MY_RNS_PATH}/global/#{title}.rn")
            TTY::Editor.open("#{MY_RNS_PATH}/#{book}/#{title}.rn")
          else
            warn "No se pudo abrir el archivo."
          end
        end
      end

      class Retitle < Dry::CLI::Command
        desc 'Retitle a note'

        argument :old_title, required: true, desc: 'Current title of the note'
        argument :new_title, required: true, desc: 'New title for the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo TODO                                 # Changes the title of the note titled "todo" from the global book to "TODO"',
          '"New note" "Just a note" --book "My book" # Changes the title of the note titled "New note" from the book "My book" to "Just a note"',
          'thoughts thinking --book Memoires         # Changes the title of the note titled "thoughts" from the book "Memoires" to "thinking"'
        ]

        def call(old_title:, new_title:, **options)
          book = options[:book]
          begin
            if (old_title[/\W/].nil?) && (new_title[/\W/].nil?)
              if book && File.exist?("#{MY_RNS_PATH}/#{book}")
                File.rename("#{MY_RNS_PATH}/#{book}/#{old_title}.rn", "#{MY_RNS_PATH}/#{book}/#{new_title}.rn")  
              else
                File.rename("#{MY_RNS_PATH}/global/#{old_title}.rn", "#{MY_RNS_PATH}/global/#{new_title}.rn")  
              end
            else
              warn 'Nombre Invalido.'
            end
          rescue => exception
            warn "No se pudo renombrar #{old_title}.rn"
          end
        end
      end

      class List < Dry::CLI::Command
        desc 'List notes'

        option :book, type: :string, desc: 'Book'
        option :global, type: :boolean, default: false, desc: 'List only notes from the global book'

        example [
          '                 # Lists notes from all books (including the global book)',
          '--global         # Lists notes from the global book',
          '--book "My book" # Lists notes from the book named "My book"',
          '--book Memoires  # Lists notes from the book named "Memoires"'
        ]

        def call(**options)
          book = options[:book]
          global = options[:global]

          if global
            Dir.chdir("#{MY_RNS_PATH}/global")
            puts Dir.glob('*')
          elsif book && File.exist?("#{MY_RNS_PATH}/#{book}")
            Dir.each_child("#{MY_RNS_PATH}/#{book}") { |nota| puts nota }
          elsif (not book) && (not global)
            Dir.each_child("#{MY_RNS_PATH}") do |b|
              Dir.new("#{MY_RNS_PATH}/#{b}").each_child() { |nota| puts nota }             
            end
          else
            warn "El Cuaderno #{book} no existe."
          end
        end
      end

      class Show < Dry::CLI::Command

        require 'colorputs'

        desc 'Show a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Shows a note titled "todo" from the global book',
          '"New note" --book "My book" # Shows a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Shows a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)

          book = options[:book]
          if book && File.exist?("#{MY_RNS_PATH}/#{book}/#{title}.rn")
            puts File.read("#{MY_RNS_PATH}/#{book}/#{title}.rn"), :cyan 
          elsif not book && File.exist?("#{MY_RNS_PATH}/global/#{title}.rn")
            puts File.read("#{MY_RNS_PATH}/#{book}/#{title}.rn"), :cyan
          else
            warn "No se pudo abrir el archivo."
          end

        end
      end
    end
  end
end
