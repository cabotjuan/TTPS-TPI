module Model
    require 'rn/helpers.rb'
    MY_RNS_PATH = Pathname.new("#{Dir.home}/.my-rns")

    class Book
        include Helpers
        attr_accessor :name
        
        def initialize(name)
            self.name = name 
        end


        def self.exists_dir? name
            if name.nil?
                return nil
            else
                return File.exists?("#{MY_RNS_PATH}/#{name}")
            end
        end
        
        
        def self.fetch(name, global=nil)
            if self.exists_dir?(name)
                return new name 
            elsif global
                return new 'global'
            else
                return nil
            end
        end

        def self.get_all
            books = []
            Dir.each_child("#{MY_RNS_PATH}").each do |name|
                books.push self.new name
            end
            books
        end

        ## - Instance Methods - ##

        def remove
            FileUtils.rm_r("#{MY_RNS_PATH}/#{self.name}")
            return self.name
        end

        def store
            Dir.mkdir("#{MY_RNS_PATH}/#{self.name}")
        end

        def rename(new_name)
            if Book::validate_name(new_name)
                File.rename("#{MY_RNS_PATH}/#{self.name}", "#{MY_RNS_PATH}/#{new_name}")  
                return new_name
            else
                return nil
            end
        end

        def notes
            notes = []
            Dir[File.join("#{MY_RNS_PATH}/#{self.name}", '*.rn')].each do |note|                
               notes.push(File.basename(note, '.rn'))
            end
            notes
        end


    end

    class Note
        require 'tty-editor'
        require 'redcarpet'
        include Helpers
        attr_accessor :title, :book, :content
        
        def self.fetch(book, title)
            if File.exists?("#{MY_RNS_PATH}/#{book}/#{title}.rn")
                content = File.read("#{MY_RNS_PATH}/#{book}/#{title}.rn")
                return Note.new title, book, content
            else
                return nil
            end
        end

        def self.get_all()
        end
        ## - Instance Methods - ##
        
        def initialize(title, book, content='')
            self.title = title 
            self.book = book 
            self.content = content
        end
        
        def store
            File.new("#{MY_RNS_PATH}/#{self.book}/#{self.title}.rn","w")
        end

        def rename(new_name)
            if Note::validate_name(new_name)
                File.rename("#{MY_RNS_PATH}/#{self.book}/#{self.title}.rn", "#{MY_RNS_PATH}/#{self.book}/#{new_name}.rn")  
                return new_name
            else
                return nil
            end
        end

        def edit
            TTY::Editor.open("#{MY_RNS_PATH}/#{self.book}/#{self.title}.rn")
            self.content = File.read("#{MY_RNS_PATH}/#{self.book}/#{self.title}.rn"), :cyan 
        end

        def remove
            FileUtils.rm_r("#{MY_RNS_PATH}/#{self.book}/#{self.title}.rn")
        end

        def export
            source_content = self.content
            renderer = Redcarpet::Render::HTML.new()
            markdown = Redcarpet::Markdown.new(renderer, extensions = {})
            parsed_content = markdown.render(source_content)
            if File.exists?("#{MY_RNS_PATH}/#{self.book}/#{self.title}.html")
                parsed_file = File.open("#{MY_RNS_PATH}/#{self.book}/#{self.title}.html", 'w')
            else
                parsed_file = File.new("#{MY_RNS_PATH}/#{self.book}/#{self.title}.html", 'w')
            end
            parsed_file.puts(parsed_content)
            parsed_file.close
        end
    end
end