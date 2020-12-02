# Ruby Notes - rn

  

*Ruby Notes*, o simplemente `rn`, es un gestor de notas concebido como un clon simplificado de la excelente herramienta [TomBoy](https://wiki.gnome.org/Apps/Tomboy).

  

La herramienta permite realizar una sencilla gestión de notas personales en tus propios cuadernos Y modificar a gusto tanto las notas como los cuadernos que las contienen.

  

La herramienta se encuentra actualmente en desarrollo como Trabajo Práctico Integrador de la cursada 2020 de la materia Taller de Tecnologías de Producción de Software - Opción Ruby, de la Facultad de Informática de la Universidad Nacional de La Plata.

  

## Usando rn

Para ejecutar la aplicación, ingresa en una interfaz de línea de comandos (CLI) el siguiente comando:

```bash
$ bin/rn [args] 
```

## Gestionando los Cuadernos

> El nombre de los cuadernos no debe incluir caracteres especiales. Solo se permiten letras, numeros y guion bajo.

Para crear un cuaderno con nombre 'mi_cuaderno' :
```bash
$ bin/rn books create mi_cuaderno
```
Para cambiar un cuaderno con nombre 'mi_cuaderno' a 'mi_cuaderno2' :
```bash
$ bin/rn books rename mi_cuaderno mi_cuaderno2
```
Para ver todos los cuadernos :
```bash
$ bin/rn books list
```
Para eliminar un cuaderno con nombre 'mi_cuaderno2' :
```bash
$ bin/rn books delete mi_cuaderno2
```
> Por defecto, rn crea el cuaderno "global" en donde irán las notas que no tengan un cuaderno asignado. 
# Gestionando las notas

> El nombre de las notas no debe incluir caracteres especiales. Solo se permiten letras, numeros y guion bajo.

Para crear una nota con nombre 'todo_tpI' en el cuaderno 'TTPSRuby' :
```bash
$ bin/rn notes create todo_tpI --book TTPSRuby
```

Para crear una nota con nombre 'todo' en el cuaderno global :
```bash
$ bin/rn notes create todo
```
Para listar todas las notas :
```bash
$ bin/rn notes list
```
Para listar las notas de cuaderno 'TTPSRuby':
```bash
$ bin/rn notes list --book TTPSRuby
```
Para listar las notas de cuaderno global:
```bash
$ bin/rn notes list --global

```

Para editar la nota 'todo' de cuaderno 'TTPSRuby':

  

```bash

$ bin/rn notes edit todo --book TTPSRuby

```

> Para editar la nota podrás elegir el editor de texto que prefieras luego de ingresar el comando.

  

Para renombrar la nota 'todo' de cuaderno 'TTPSRuby' a 'finished':

  

```bash

$ bin/rn notes rename todo finished --book TTPSRuby

```

Para eliminar la nota 'finished':

  

```bash

$ bin/rn notes delete finished --book TTPSRuby

```

  

# (v1.2) Exportar notas

  

> Las notas pueden ser escritas en **Markdown** para ser exportadas. Cada nota exportada se guarda en formato HTML en su directorio (cuaderno) original.

Para exportar a HTML una nota de global:

  
```bash
$ bin/rn notes export --note note_name
```

Para exportar a HTML una nota de un cuaderno:

  
```bash
$ bin/rn notes export --note note_name --book book_name
```

Para exportar a HTML todas las notas de un cuaderno:
```bash
$ bin/rn notes export --book book_name
```

Para exportar a HTML todas las notas de la aplicacion:

  

```bash
$ bin/rn notes export --all
```

  
  
### Aclaraciones 
 Para la ejecución de la herramienta, es necesario tener una versión reciente de Ruby (2.5 o posterior) y tener instaladas sus dependencias, las cuales se manejan con Bundler.
