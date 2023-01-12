import os
import psycopg2
from flask import Flask, render_template, request, url_for, redirect
from flask import jsonify
app = Flask(__name__)

def get_db_conn():
  try:
      conn = psycopg2.connect(
                  host="localhost",
                  database="proyectofinal",
                  #user=os.environ['DB_USERNAME'],
                  #password=os.environ['DB_PASSWORD']
                  user='postgres',
                  password='WUFn5HcJ')
      return conn    
  except (Exception, psycopg2.Error) as error :
    print ("Error while connecting to PostgreSQL: ", error)

@app.route('/')
def index():
    # Retorno de clientes.
    conn = get_db_conn()
    cur = conn.cursor()
    try:
        cur.execute('SELECT *'
                    'FROM cliente;')
    except (Exception, psycopg2.Error) as error :
        print ("Error while performing API #1 (cliente): ", error)
        pass 

    cliente = cur.fetchall()
    cur.close()
    conn.close()

    return render_template('index.html', clientes=cliente)

# Crear 'cliente'
@app.route('/create/', methods=('GET', 'POST'))
def create():
    if request.method == 'POST':
        nombre_cliente = request.form['nombre_cliente']
        email = request.form['email']

        try:
            conn = get_db_conn()
        except psycopg2.Error as e:
            pass
        try:
            cur = conn.cursor()
            cur.execute('INSERT INTO cliente (nombre_cliente, email)'
                        'VALUES (%s, %s)',
                        (nombre_cliente, email))
        except (Exception, psycopg2.Error) as error :
            print ("Error while inserting a cliente: ", error)
            pass
        conn.commit()
        cur.close()
        conn.close()
        return redirect(url_for('index'))

    return render_template('create.html')

# Eliminar 'cliente'
@app.route('/delete/', methods=('GET', 'POST'))
def delete():
    if request.method == 'POST':
        id = int(request.form['id'])

        conn = get_db_conn()
        cur = conn.cursor()
        cur.execute('DELETE FROM cliente'
                    'WHERE id=%s',
                    (id, ))
        conn.commit()
        cur.close()
        conn.close()
        return redirect(url_for('index'))

    return render_template('delete.html')

# Actualizar cliente
@app.route('/update/', methods=('GET', 'POST'))
def update():
    if request.method == 'POST':
        id_cliente = int(request.form['id_cliente'])
        nombre_cliente = request.form['nombre_cliente']
        email = request.form['email']

        conn = get_db_conn()
        cur = conn.cursor()
        cur.execute('UPDATE cliente'
                    ' SET nombre_cliente = %s, email = %s'
                    ' WHERE id=%s',
                    (nombre_cliente, email, id_cliente))
        conn.commit()
        cur.close()
        conn.close()
        return redirect(url_for('index'))

    return render_template('update.html')

# About
@app.route('/about/')
def about():
    return render_template('about.html')
     
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
