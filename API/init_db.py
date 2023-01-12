import os
import psycopg2
try:
    conn = psycopg2.connect(
                host="localhost",
                database="proyectofinal",
                #user=os.environ['DB_USERNAME'],
                #password=os.environ['DB_PASSWORD']
                user='postgres',
                password='WUFn5HcJ')

    # Open a cursor to perform database operations
    cur = conn.cursor()

    # Creamos tabla 'prenda', eliminándola si antes si ya existe
    cur.execute('DROP TABLE IF EXISTS prenda;')

    try:
        cur.execute('CREATE TABLE prenda (id INT generated always as identity PRIMARY KEY,'
                                        'nombre varchar (150) NOT NULL,'
                                        'precio decimal(4,2) NOT NULL,'
                                        'material varchar (150) NOT NULL,'
                                        'talla varchar (50) NOT NULL,'
                                        'genero varchar (50));'
                                        )
    except (Exception, psycopg2.Error) as error :
        print ("Error while creating the table: ", error)

    # Insert data into the table
    try: 
        cur.execute('INSERT INTO prenda (nombre, precio, material, talla, genero)'
                    'VALUES (%s, %s, %s, %s, %s)',
                    ('Camiseta basica',
                    10.80,
                    'Algodon',
                    'L',
                    'Mujer')
                    )
    except (Exception, psycopg2.Error) as error :
        print ("Error while inserting a prenda: ", error)
        pass

    # Creamos tabla 'calzado', eliminándola si antes si ya existe
    cur.execute('DROP TABLE IF EXISTS calzado;')

    try:
        cur.execute('CREATE TABLE calzado (id serial PRIMARY KEY,'
                                        'nombre varchar (150) NOT NULL,'
                                        'precio decimal(4,2) NOT NULL,'
                                        'color varchar (150) NOT NULL,'
                                        'talla int NOT NULL,'
                                        'genero varchar (50));'
                                        )
    except (Exception, psycopg2.Error) as error :
        print ("Error while creating the table: ", error)

    # Insert data into the table 'calzado'
    try: 
        cur.execute('INSERT INTO calzado (nombre, precio, color, talla, genero)'
                    'VALUES (%s, %s, %s, %s, %s)',
                    ('Botín biker tachas',
                    49.99,
                    'Negro',
                    41,
                    'Mujer')
                    )
    except (Exception, psycopg2.Error) as error :
        print ("Error while inserting a calzado: ", error)
        pass

    # Creamos tabla 'complementos', eliminándola si antes si ya existe
    cur.execute('DROP TABLE IF EXISTS complementos;')

    try:
        cur.execute('CREATE TABLE complementos (id serial PRIMARY KEY,'
                                        'nombre varchar (150) NOT NULL,'
                                        'precio decimal(4,2) NOT NULL,'
                                        'categoria text []);'
                                        )
    except (Exception, psycopg2.Error) as error :
        print ("Error while creating the table: ", error)

    # Insert data into the table 'complementos'
    try: 
        cur.execute('INSERT INTO complementos (nombre, precio, categoria)'
                    'VALUES (%s, %s, %s)',
                    ('Pack calcetines canale',
                    7.99,
                    '{"Calcetines"}')
                    )
    except (Exception, psycopg2.Error) as error :
        print ("Error while inserting a complementos: ", error)
        pass

    # Creamos tabla 'hogar', eliminándola si antes si ya existe
    cur.execute('DROP TABLE IF EXISTS hogar;')

    try:
        cur.execute('CREATE TABLE hogar (id serial PRIMARY KEY,'
                                        'nombre varchar (150) NOT NULL,'
                                        'precio decimal(4,2) NOT NULL,'
                                        'tipo text []);'
                                        )
    except (Exception, psycopg2.Error) as error :
        print ("Error while creating the table: ", error)

    # Insert data into the table 'hogar'
    try: 
        cur.execute('INSERT INTO hogar (nombre, precio, tipo)'
                    'VALUES (%s, %s, %s)',
                    ('Funda nordica bordados',
                    39.99,
                    '{"Dormitorio", "Ropa cama"}')
                    )
    except (Exception, psycopg2.Error) as error :
        print ("Error while inserting a hogar: ", error)
        pass

    conn.commit()

    cur.close()
    conn.close()
    
except (Exception, psycopg2.Error) as error :
    print ("Error while connecting to PostgreSQL: ", error)