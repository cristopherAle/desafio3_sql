/*1. Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo
pedido. (1 Punto)*/
CREATE DATABASE desafio3_cristopher_vargas_315
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Spanish_Chile.1252'
    LC_CTYPE = 'Spanish_Chile.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;


create table usuarios(id serial, email varchar(20), nombre varchar(50), apellido varchar(50), rol varchar(15));

select * from usuarios

insert into usuarios(email, nombre, apellido, rol) values('usuario1@mail.com','Bastian', 'Vargas', 'administrador'), ('usuario2@mail.com','Jorge', 'Collao', 'usuario'),
('usuario3@mail.com','Manuel', 'Miranda', 'usuario'),('usuario4@mail.com','Victor', 'Opazo', 'usuario'),('usuario5@mail.com','Franco', 'Liberon', 'usuario');

create table posts(id serial, titulo varchar(20), contenido varchar(50), fecha_creacion date, fecha_actualizacion date, destacado boolean, usuario_id bigint)

insert into posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) 
values ('Titulo 1', 'Comentario 1', '29/03/1990', '29/03/2023', 'true', 1),
('Titulo 2', 'Comentario 2', '15/05/2013', '18/12/2014', 'true', 1),
('Titulo 3', 'Comentario 3', '05/10/2012', '23/07/2015', 'true', 2),
('Titulo 4', 'Comentario 4', '06/02/2013', '22/01/2017', 'false', 2),
('Titulo 5', 'Comentario 5', '30/05/2021', '17/12/2022', 'false', null)

create table comentarios(id serial, contenido varchar(50), fecha_creacion date, usuario_id bigint, post_id bigint)


insert into comentarios(contenido, fecha_creacion, usuario_id, post_id) 
values ('Comentario 1', '13/05/2016', 1, 1),
('Comentario 2', '05/05/2018', 2, 1),
('Comentario 3', '24/02/2020', 3, 1),
('Comentario 4', '28/08/2010', 1, 2),
('Comentario 5', '01/12/2014', 2, 2)

/*2. Cruza los datos de la tabla usuarios y posts mostrando las siguientes columnas.
nombre e email del usuario junto al título y contenido del post. (1 Punto)*/

select u.nombre, u.email, p.titulo, p.contenido
from usuarios u
inner join posts p on u.id = p.usuario_id

/*3. Muestra el id, título y contenido de los posts de los administradores. El
administrador puede ser cualquier id y debe ser seleccionado dinámicamente.
(1 Punto).*/

select * from usuarios u
inner join posts p on u.id = p.usuario_id
where rol = 'administrador';

/*4. Cuenta la cantidad de posts de cada usuario. La tabla resultante debe mostrar el id
e email del usuario junto con la cantidad de posts de cada usuario. (1 Punto)
Hint importante: Aquí hay diferencia entre utilizar inner join, left join o right join,
prueba con todas y con eso determina cual es la correcta. No da lo mismo desde
cual tabla partes.*/

select u.id, email, count(p.id) as cantidad 
from usuarios u left join posts p ON u.id = p.usuario_id
group by u.id, u.email order by cantidad desc;

/*5. Muestra el email del usuario que ha creado más posts. Aquí la tabla resultante tiene
un único registro y muestra solo el email. (1 Punto)*/

select email 
from usuarios u inner join posts p ON u.id = p.usuario_id
group by u.id, u.email order by max(p.id);

/*solucion 2*/

select max(email) 
from usuarios u inner join posts p ON u.id = p.usuario_id

/*6. Muestra la fecha del último post de cada usuario. (1 Punto)
Hint: Utiliza la función de agregado MAX sobre la fecha de creación.*/

select nombre, max(fecha_creacion) 
from (select p.id, p.contenido, p.fecha_creacion, u.nombre 
	  from usuarios u join posts p ON u.id = p.usuario_id) as t
group by t.nombre;

/*7. Muestra el título y contenido del post (artículo) con más comentarios. (1 Punto)*/

select titulo, contenido 
from posts p 
	inner join (select post_id, count(post_id) as cantidad
					from comentarios 
					group by post_id 
					order by cantidad desc limit 1) as t ON t.post_id = p.id

/*8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido
de cada comentario asociado a los posts mostrados, junto con el email del usuario
que lo escribió. (1 Punto)*/

select p.titulo as titulo_post, p.contenido as contenido_post, c.contenido as contenido_comentario, u.email 
from posts p inner join comentarios c on p.id = c.post_id
inner join usuarios u on c.usuario_id = u.id;

/*9. Muestra el contenido del último comentario de cada usuario. (1 Punto)*/

select fecha_creacion, contenido, usuario_id 
from comentarios c inner join usuarios u on c.usuario_id = u.id 
where fecha_creacion = (select max(fecha_creacion) from comentarios where usuario_id = u.id);

/*10. Muestra los emails de los usuarios que no han escrito ningún comentario. (1 Punto)
Hint: Recuerda el Having*/

select u.email 
from usuarios u left join comentarios c on u.id = c.usuario_id
group by u.email having count(c.id) = 0;
