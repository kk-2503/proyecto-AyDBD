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

    # Creamos tabla 'cliente', eliminándola si antes si ya existe
    cur.execute('DROP TABLE IF EXISTS cliente;')

    try:
        cur.execute('CREATE TABLE cliente (id INT generated always as identity PRIMARY KEY,'
                                        'nombre_cliente varchar (300) NOT NULL,'
                                        'email varchar(350));'
                                        )
    except (Exception, psycopg2.Error) as error :
        print ("Error while creating the table: ", error)

    # Insert data into the table 'cliente'
    try: 
        cur.execute('INSERT INTO cliente (nombre_cliente, email)'
                    'VALUES (%s, %s)',
                    ('Shakira',
                    'pique_casio@gmail.com')
                    )
    except (Exception, psycopg2.Error) as error :
        print ("Error while inserting a cliente: ", error)
        pass

    try: 
        cur.execute('INSERT INTO cliente (nombre_cliente, email)'
                    'VALUES (%s, %s)',
                    ('Clara',
                    'clara-mentegmail.com')
                    )
    except (Exception, psycopg2.Error) as error :
        print ("Error while inserting a cliente: ", error)
        pass


    conn.commit()

    cur.close()
    conn.close()
    
except (Exception, psycopg2.Error) as error :
    print ("Error while connecting to PostgreSQL: ", error)