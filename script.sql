DROP TABLE IF EXISTS ciudad;
DROP SEQUENCE IF EXISTS public.ciudad_id_ciudad_seq;
DROP TABLE IF EXISTS tienda;
DROP SEQUENCE IF EXISTS public.tienda_id_tienda_seq;

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
	CONSTRAINT fk_ciudad
	FOREIGN KEY(id_ciudad)
	REFERENCES ciudad(id_ciudad)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
  CONSTRAINT unique_vals_tienda
  UNIQUE (nombre)
);

INSERT INTO tienda
VALUES(DEFAULT, 'zara-la laguna', 'abc', 1);

INSERT INTO tienda
VALUES(DEFAULT, 'zara-gran via', 'def', 2);