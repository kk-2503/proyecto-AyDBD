DROP TABLE IF EXISTS compra_contiene_prod;
DROP TABLE IF EXISTS dependiente;
DROP SEQUENCE IF EXISTS public.dependiente_id_empleado_seq;
DROP TABLE IF EXISTS encargado_tienda;
DROP SEQUENCE IF EXISTS public.encargado_tienda_id_enc_seq;
DROP TABLE IF EXISTS compra;
DROP SEQUENCE IF EXISTS public.compra_id_compra_seq;
DROP TABLE IF EXISTS cliente;
DROP SEQUENCE public.cliente_id_cliente_seq;
DROP TABLE IF EXISTS tienda_tiene_prod;
DROP TABLE IF EXISTS tienda;
DROP SEQUENCE IF EXISTS public.tienda_id_tienda_seq;
DROP TABLE IF EXISTS ciudad;
DROP SEQUENCE IF EXISTS public.ciudad_id_ciudad_seq;
DROP TABLE IF EXISTS marca;
DROP SEQUENCE IF EXISTS public.marca_id_marca_seq;
DROP TABLE IF EXISTS producto;
DROP SEQUENCE IF EXISTS public.producto_id_producto_seq;
DROP TABLE IF EXISTS campana;
DROP SEQUENCE IF EXISTS public.campana_id_campana_seq;
DROP TABLE IF EXISTS departamento;
DROP SEQUENCE IF EXISTS public.departamento_id_dep_seq;
DROP TABLE IF EXISTS prod_pertenece_camp;

CREATE SEQUENCE public.ciudad_id_ciudad_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE ciudad (
	id_ciudad integer PRIMARY KEY DEFAULT nextval('public.ciudad_id_ciudad_seq'::regclass) NOT NULL,
	c_a VARCHAR(200) NOT NULL,
	pais VARCHAR(100) NOT NULL,
  CONSTRAINT unique_vals 
  UNIQUE (c_a, pais)
);

INSERT INTO ciudad
VALUES(DEFAULT, 'canarias', 'españa');

INSERT INTO ciudad
VALUES(DEFAULT, 'madrid', 'españa');

SELECT *
FROM ciudad;

---------------------------------------------TABLA MARCA-----------------------------------------

CREATE SEQUENCE public.marca_id_marca_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE marca (
  id_marca integer PRIMARY KEY DEFAULT nextval('public.marca_id_marca_seq'::regclass) NOT NULL,
  nom_marca VARCHAR(150) NOT NULL,
  prod_principal VARCHAR(200) NOT NULL,
  CONSTRAINT unique_vals_marca
  UNIQUE (nom_marca)
);

INSERT INTO marca
VALUES(DEFAULT, 'Zara', 'Prendas');

INSERT INTO marca
VALUES(DEFAULT, 'Zara Home', 'Decoracion de Casa');

SELECT *
FROM marca;

-------------------------------------------TABLA TIENDA-----------------------------

CREATE SEQUENCE public.tienda_id_tienda_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE tienda (
	id_tienda integer PRIMARY KEY DEFAULT nextval('public.tienda_id_tienda_seq'::regclass) NOT NULL,
	nombre VARCHAR(200) NOT NULL,
	direccion VARCHAR(300) NOT NULL,
  id_ciudad INTEGER NOT NULL,
  id_marca INTEGER NOT NULL,
	CONSTRAINT fk_ciudad
	FOREIGN KEY(id_ciudad)
	REFERENCES ciudad(id_ciudad)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
  CONSTRAINT fk_marca
	FOREIGN KEY(id_marca)
	REFERENCES marca(id_marca),
  CONSTRAINT unique_vals_tienda
  UNIQUE (nombre)
);

INSERT INTO tienda
VALUES(DEFAULT, 'zara-la laguna', 'abc', 1, 1);

INSERT INTO tienda
VALUES(DEFAULT, 'zara home-gran via', 'def', 2, 2);

SELECT *
FROM tienda;

------------------------------------------TABLA CLIENTE----------------------------------------

CREATE SEQUENCE public.cliente_id_cliente_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE cliente (
  id_cliente integer PRIMARY KEY DEFAULT nextval('public.cliente_id_cliente_seq'::regclass) NOT NULL,
  nombre_cliente VARCHAR(300),
  email VARCHAR(350),
  CONSTRAINT unique_vals_cliente
  UNIQUE (nombre_cliente, email)
);

INSERT INTO cliente
VALUES(DEFAULT, 'Maria', 'abc@def.com');

INSERT INTO cliente
VALUES(DEFAULT, 'Pepe', 'abc@def.com');

INSERT INTO cliente
VALUES(DEFAULT);

SELECT *
FROM cliente;

---------------------------------------------TABLA COMPRA-------------------------------------------------

CREATE SEQUENCE public.compra_id_compra_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE compra (
  id_compra integer PRIMARY KEY DEFAULT nextval('public.compra_id_compra_seq'::regclass) NOT NULL,
  precio_total NUMERIC(8,2) NOT NULL,
  fecha DATE NOT NULL,
  id_tienda INTEGER NOT NULL,
  id_cliente INTEGER NOT NULL,
  CONSTRAINT fk_tienda
	FOREIGN KEY(id_tienda)
	REFERENCES tienda(id_tienda)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
  CONSTRAINT fk_cliente
	FOREIGN KEY(id_cliente)
	REFERENCES cliente(id_cliente)
);

INSERT INTO compra
VALUES(DEFAULT, 25.30, '2023-01-05', 1, 1);

INSERT INTO compra
VALUES(DEFAULT, 10, '2023-01-06', 2, 2);

INSERT INTO compra
VALUES(DEFAULT, 10, '2023-01-06', 1, 3);

SELECT *
FROM compra;

----------------------------------------------TABLA PRODUCTO------------------------------------------------

CREATE SEQUENCE public.producto_id_producto_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE producto (
  id_producto integer PRIMARY KEY DEFAULT nextval('public.producto_id_producto_seq'::regclass) NOT NULL,
  nombre_prod VARCHAR(300) NOT NULL,
  precio_prod NUMERIC(8,2) NOT NULL,
  tipo VARCHAR(100),
  talla VARCHAR(10),
  genero VARCHAR(5),
  material VARCHAR(100),
  color VARCHAR(100),
  categoria VARCHAR(200),
  proposito VARCHAR(200),
  CHECK((tipo = 'prenda' AND 
          talla IS NOT NULL AND 
          genero IS NOT NULL AND 
          material IS NOT NULL AND 
          color IS NULL AND 
          categoria IS NULL AND 
          proposito IS NULL) OR
        (tipo = 'calzado' AND
          genero IS NOT NULL AND
          color IS NOT NULL AND
          talla IS NOT NULL AND
          material IS NULL AND 
          categoria IS NULL AND 
          proposito IS NULL) OR 
        (tipo = 'complemento' AND 
          talla IS NULL AND 
          genero IS NULL AND 
          material IS NULL AND
          color IS NULL AND 
          categoria IS NOT NULL AND 
          proposito IS NULL) OR 
        (tipo = 'articulo de hogar' AND 
          talla IS NULL AND 
          genero IS NULL AND 
          material IS NULL AND
          color IS NULL AND 
          categoria IS NULL AND 
          proposito IS NOT NULL) OR 
        (tipo IS NULL))
);

INSERT INTO producto
VALUES(DEFAULT, 'Camisa hombre', 6.99, 'prenda', 'M', 'H', 'algodon', NULL, NULL, NULL);

INSERT INTO producto
VALUES(DEFAULT, 'Tacones rojo', 12, 'calzado', '40', 'M', NULL, 'rojo');

INSERT INTO producto
VALUES(DEFAULT, 'Auriculares Mickey Mouse', 9.99);

SELECT *
FROM producto;

-------------------------------------TABLA CAMPAÑA----------------------------------------

CREATE SEQUENCE public.campana_id_campana_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE campana (
  id_campana integer PRIMARY KEY DEFAULT nextval('public.campana_id_campana_seq'::regclass) NOT NULL,
  temporada VARCHAR(100),
  fecha_ini DATE NOT NULL,
  fecha_fin DATE NOT NULL
);

INSERT INTO campana
VALUES(DEFAULT, 'Invierno', '2022-01-01', '2022-03-01');

INSERT INTO campana
VALUES(DEFAULT, 'Verano', '2022-05-01', '2022-08-31');

SELECT *
FROM campana;

---------------------------------------------TABLA PROD-PERTENECE-CAMP----------------------------------

CREATE TABLE prod_pertenece_camp (
	id_producto INTEGER NOT NULL,
  id_campana INTEGER NOT NULL,
	CONSTRAINT fk_campana
	FOREIGN KEY(id_campana)
	REFERENCES campana(id_campana),
	CONSTRAINT fk_producto
	FOREIGN KEY(id_producto)
	REFERENCES producto(id_producto)
);

INSERT INTO prod_pertenece_camp
VALUES(1, 1);

INSERT INTO prod_pertenece_camp
VALUES(2, 2);

SELECT id_producto, id_campana, nombre_prod, fecha_ini, fecha_fin
FROM prod_pertenece_camp NATURAL JOIN campana NATURAL JOIN producto;

---------------------------------------------TABLA TIENDA-TIENE-PRODUCTO----------------------------------

CREATE TABLE tienda_tiene_prod (
	id_tienda INTEGER NOT NULL,
	id_producto INTEGER NOT NULL,
	cantidad INT NOT NULL,
	CONSTRAINT fk_tienda
	FOREIGN KEY(id_tienda)
	REFERENCES tienda(id_tienda),
	CONSTRAINT fk_producto
	FOREIGN KEY(id_producto)
	REFERENCES producto(id_producto)
);

INSERT INTO tienda_tiene_prod
VALUES(1, 1, 73);

INSERT INTO tienda_tiene_prod
VALUES(1, 2, 21);

SELECT id_producto, id_tienda, cantidad, nombre, nombre_prod
FROM tienda_tiene_prod NATURAL JOIN tienda NATURAL JOIN producto;

-------------------------------------------------TABLA DEPENDIENTE----------------------------------------

CREATE SEQUENCE public.dependiente_id_empleado_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE dependiente (
  id_empleado integer PRIMARY KEY DEFAULT nextval('public.dependiente_id_empleado_seq'::regclass) NOT NULL,
  nombre_dep VARCHAR(100) NOT NULL,
  apellido1_dep VARCHAR(100) NOT NULL,
  apellido2_dep VARCHAR(100),
  email VARCHAR(200) NOT NULL,
  direccion VARCHAR(300) NOT NULL,
  fecha_ini DATE NOT NULL,
  telefono VARCHAR(9) NOT NULL,
  id_tienda INTEGER NOT NULL,
  CONSTRAINT fk_tienda
	FOREIGN KEY(id_tienda)
	REFERENCES tienda(id_tienda),
  CONSTRAINT unique_vals_dep
  UNIQUE (nombre_dep, apellido1_dep, direccion)
);

INSERT INTO dependiente
VALUES(DEFAULT, 'Karina', 'Kalwani', NULL, 'alu0101109046@ull.edu.es', 'abc', '2023-01-04', '123456789', 1);

INSERT INTO dependiente
VALUES(DEFAULT, 'Noelia', 'Ibañez', 'Silvestre', 'alu0101225555@ull.edu.es', 'abc', '2023-01-04', '123456789', 2);

SELECT *
FROM dependiente;

-------------------------------------------------TABLA ENCARGADO TIENDA----------------------------------------

CREATE SEQUENCE public.encargado_tienda_id_enc_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE encargado_tienda (
  id_enc integer PRIMARY KEY DEFAULT nextval('public.encargado_tienda_id_enc_seq'::regclass) NOT NULL,
  nombre_enc VARCHAR(100) NOT NULL,
  apellido1_enc VARCHAR(100) NOT NULL,
  apellido2_enc VARCHAR(100),
  email VARCHAR(200) NOT NULL,
  direccion VARCHAR(300) NOT NULL,
  fecha_ini DATE NOT NULL,
  telefono VARCHAR(9) NOT NULL,
  id_tienda INTEGER NOT NULL UNIQUE,
  CONSTRAINT fk_tienda
	FOREIGN KEY(id_tienda)
	REFERENCES tienda(id_tienda),
  CONSTRAINT unique_vals_enc
  UNIQUE (nombre_enc, apellido1_enc, direccion)
);

INSERT INTO encargado_tienda
VALUES(DEFAULT, 'ABC', 'DEF', NULL, 'alu0101109046@ull.edu.es', 'abc', '2023-01-04', '123456789', 1);

INSERT INTO encargado_tienda
VALUES(DEFAULT, 'GHI', 'JKL', 'MNO', 'alu0101225555@ull.edu.es', 'abc', '2023-01-04', '123456789', 2);

SELECT *
FROM encargado_tienda;

----------------------------------------------TABLA DEPARTAMENTO--------------------------------------------

CREATE SEQUENCE public.departamento_id_dep_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE departamento (
  id_dep integer PRIMARY KEY DEFAULT nextval('public.departamento_id_dep_seq'::regclass) NOT NULL,
  nombre_dep VARCHAR(200) NOT NULL,
  puesto VARCHAR(200) NOT NULL,
  nombre_emp VARCHAR(100) NOT NULL,
  apellido1_emp VARCHAR(100) NOT NULL,
  apellido2_emp VARCHAR(100),
  email VARCHAR(200) NOT NULL,
  direccion VARCHAR(300) NOT NULL,
  fecha_ini DATE NOT NULL,
  telefono VARCHAR(9) NOT NULL,
  CONSTRAINT unique_vals_departamento
  UNIQUE (nombre_dep, puesto, nombre_emp, apellido1_emp, direccion)
);

INSERT INTO departamento
VALUES(DEFAULT, 'Producto', 'Diseñador','Ana', 'Locking', NULL, 'abc@def.com', 'abc', '2023-01-04', '123456789');

INSERT INTO departamento
VALUES(DEFAULT, 'RRHH', 'Talent Manager', 'Daniela', 'Vega', 'Torres', 'abc@def.com', 'abc', '2023-01-05', '123456789');

SELECT *
FROM departamento;

---------------------------------------------TABLA COMPRA-CONTIENE-PROD----------------------------------

CREATE TABLE compra_contiene_prod (
	id_compra INTEGER NOT NULL,
	id_producto INTEGER NOT NULL,
	CONSTRAINT fk_compra
	FOREIGN KEY(id_compra)
	REFERENCES compra(id_compra),
	CONSTRAINT fk_producto
	FOREIGN KEY(id_producto)
	REFERENCES producto(id_producto)
  ON DELETE RESTRICT
	ON UPDATE CASCADE
);

INSERT INTO compra_contiene_prod
VALUES(1, 1);

INSERT INTO compra_contiene_prod
VALUES(1, 2);

INSERT INTO compra_contiene_prod
VALUES(2, 2);

SELECT id_compra, id_producto, id_tienda, nombre_prod
FROM compra_contiene_prod NATURAL JOIN tienda_tiene_prod NATURAL JOIN PRODUCTO;