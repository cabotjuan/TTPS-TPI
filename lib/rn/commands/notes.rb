module RN
  require 'rn/model'
  module Commands
    module Notes
      require 'colorputs'
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
          book=options[:book]
          begin
            book = 'global' unless book 
            if Model::Book.fetch(book)
              note = Model::Note.fetch(book, title)
              if not note
                if Model::Note.validate_name title
                  new_note = Model::Note.new title, book
                  new_note.store
                  puts "✓ [🔖#{title}] fue creada en 📘'#{book}' !", :cyan
                else
                  puts "✘ '#{title}' no es un nombre válido. Probá otro nombre!", :red
                end
              else
                puts "✘ [🔖#{title}] ya existe en [📘#{book}] . Probá otro nombre!", :red
              end
            else
              puts "✘ [📘#{book}] no existe.", :red
            end
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
          book = 'global' unless options[:book]
          note = Model::Note.fetch(book, title)
          if note
            note.remove 
            puts "✓ [🔖#{title}] fue eliminada de [📘#{book}] !", :cyan
          else
            puts "✘ [🔖#{title}] No se pudo borrar.", :red
          end
        end
      end

      class Edit < Dry::CLI::Command
        desc 'Edit the content a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Edits a note titled "todo" from the global book',
          '"New note" --book "My book" # Edits a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Edits a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = 'global' unless options[:book]
          note = Model::Note.fetch(book, title)
          if note 
            note.edit
            puts "✓ Editando [🔖#{title}]...", :cyan
          else
            puts "✘ [🔖#{title}] No se pudo abrir.", :red
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
          book = 'global' unless book            
          begin
            note = Model::Note.fetch(book, old_title)
            if note
              result = note.rename(new_title)
              if result
                puts "✓ [🔖#{result}] ha sido renombrada!", :green
              else
                puts "✘ No se pudo renombrar la nota [🔖#{old_title}]. El nuevo titulo no es válido.", :red
              end
            else
              puts "✘ No se pudo encontrar la nota [🔖#{old_title}]. Probá otro nombre!", :red
            end
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
          if book
            book_name =  book 
          elsif global
            book_name =  'global'
          else
            book_name = nil
          end
          if book_name
            book = Model::Book.fetch(book_name)
            if book
              puts ''
              puts "📘#{book_name}", :cyan
              Dir.each_child("#{MY_RNS_PATH}/#{book_name}") { |nota| puts "├🔖#{nota}", :cyan }                         
              puts ''
            else
              puts "✘ [📘#{book_name}] No existe.", :red
            end
          else
            Model::Book.get_all.each do |b|
              puts ''
              puts "📘#{b.name}", :cyan
              Dir.each_child("#{MY_RNS_PATH}/#{b.name}") { |nota| puts "├🔖#{nota}", :cyan  }             
              puts ''
            end
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
          book = 'global' unless book
          note = Model::Note.fetch(book, title)
          if note
            puts "✓ Abriendo [🔖#{title}]...", :cyan
            puts note.content
          else
            puts "✘ No se pudo abrir la nota [🔖#{title}].", :red
          end
        end
      end

      class Export < Dry::CLI::Command

        desc 'Export a markup note to HTML'

        option :note, type: :string, desc: 'note title'
        option :book, type: :string, desc: 'book name'
        option :all, type: :boolean, default: false, desc: 'Export all notes to HTML'

        example [
          '--note nota1                      # Exports a note titled "nota1" from the global book',
          '"--note nota2 --book "My book"    # Exports a note titled "nota2" from the book "My book"',
          '--all                             # Exports all notes"'
        ]
        def call(**options)
          
          all = options[:all]
          nota = options[:note]
          book = options[:book]
          if nota
            book = 'global' unless book
            ## Nota particular en book indicado
            puts book
            puts nota
            n = Model::Note.fetch(book, nota)
            if n
              n.export
              puts "✓ [🔖#{nota}] exportada !", :cyan
            else
              puts "✘ [🔖#{nota}] no encontrada.", :red
            end
          elsif book 
            ## Todas las notas en Book indicado
            book = Model::Book.fetch(book)
            if book
              book.notes.each do |n|
                n = Model::Note.fetch(book.name, n)
                n.export
                puts "✓ [🔖#{n.title}] exportada !", :cyan
              end
              if book.notes.empty?
                puts "[📘#{book.name}] no tiene notas para exportar.", :red
              end
            else 
              puts "✘ [📘#{book}] no existe.", :red
            end
          elsif all
            Model::Book.get_all.each do |book|
              book.notes.each do |n|
                n = Model::Note.fetch(book.name, n)
                n.export
                puts "✓ [🔖#{n.title}] exportada !", :cyan
              end
            end
          end
        end
      end
    end
  end
end
