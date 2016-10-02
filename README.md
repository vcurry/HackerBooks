# HackerBooks

La aplicación parsea los datos del fichero “books_readable.json”, crea sus correspondientes entidades libros, bookTags, tags, autores, etc y los muestra en una tabla.
El controlador de esta tabla tiene una barra de búsqueda que permite listar los libros en los que aparece la cadena que introduce el usuario, bien en el título, en el nombre de alguno de sus autores o en alguno de sus tags.

Cuando entramos en el controlador de un libro determinado, tenemos la opción de guardarlo como favorito. Cuando hay algún libro marcado como favorito, en la tabla de libros aparece como primera sección favoritos y cuando se deseleccionan todos los favoritos, desaparece este tag.

Otra opción del controlador de un libro es visualizar el pdf. Este se muestra en otro controlador, que además nos permite incluir anotaciones al libro. Primero se muestran las anotaciones existentes del libro, permite añadir nuevas. En el controlador de cada anotación se puede introducir un texto, una imagen, mostrar la ubicación donde se ha creado y compartir el texto en Facebook.

*** No funciona la descarga asíncrona de imágenes y pdf, tampoco persisten las anotaciones que introduce el usuario. Me acabo de dar cuenta de que tengo un error: en el controlador que muestra la tabla con todos los libros BooksViewController, en lugar de tomar el fetchedResultsController que se pasa en el inicializador, creé un nuevo CoreDataStack, distinto del creado en el AppDelegate, sospecho que esa es la fuente de estos problemas. Intento arreglarlo en el tiempo que me queda, pero es poco.
Por lo menos me veo mucho más suelta programando en Swift, ya no se me hace extraño y puedo traducir desde Objective-C si necesito.

**** Unas horas más tarde.... efectivamente, el error era crear un CoreDataStack nuevo en el controlador de la tabla de libros, BooksViewController, al corregirlo me aparecen las imágenes. Los pdfs me dan error, aún no sé por qué, también se me descuajeringan los favoritos al borrarlos y las anotaciones. Te dejo el push anterior, porque si no no vas a poder ver apenas funcionalidades, sólo las imágenes descargadas.
