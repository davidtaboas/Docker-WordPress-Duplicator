[Completar: referencias, agradecimientos, inglés...]

Imagen de Docker que permite ser usada con Kitematic y en línea de comandos.

Utiliza una copia realizada con Duplicator para replicar un sitio y trabajar con él en local, con la posibilidad de modificar archivos desde la máquina host.

Están definidos dos volúmenes para ser usados:

* wp-install: aquí irán los archivos descargados de duplicator
* wordpress: en esta carpeta estarán los archivos de wp-content

Para utilizarlo con Kitematic hay que copiar y pegar los archivos de duplicator en la carpeta wp-install antes de iniciarla.
Respecto a wp-content, se muestra automáticamente.

Si se quiere utilizar desde terminal, hay que utilizar los volúmenes compartidos:
```
docker run -i -v ~/dev/duplicator:/wp-install -v ~/dev/wordpress:/wordpress nameimage
```