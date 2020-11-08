module RN
  autoload :VERSION, 'rn/version'
  autoload :Commands, 'rn/commands'
  
  # Agregar aquí cualquier autoload que sea necesario para que se cargue las clases y
  # módulos del modelo de datos.
  # Por ejemplo:
  # autoload :Note, 'rn/note'

  Dir.mkdir("#{Dir.home}/.my-rns") unless File.exist?("#{Dir.home}/.my-rns")
  Dir.mkdir("#{Dir.home}/.my-rns/global") unless File.exist?("#{Dir.home}/.my-rns/global")
    
end
