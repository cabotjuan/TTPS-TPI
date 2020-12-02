module Helpers
    module ClassMethods
        def validate_name(name)
            name[/\W/].nil?
        end        
    end
    def self.included(base)
        base.extend(ClassMethods)
    end
end