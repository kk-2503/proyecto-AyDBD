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
    # Retorno de las prendas.
    conn = get_db_conn()
    cur = conn.cursor()
    try:
        cur.execute('SELECT *'
                    'FROM prenda;')
    except (Exception, psycopg2.Error) as error :
        print ("Error while performing API #1 (prenda): ", error)
        pass 

    prenda = cur.fetchall()
    cur.close()
    conn.close()

    return render_template('index.html', prendas=prenda)

# Crear 'prenda'
@app.route('/create/', methods=('GET', 'POST'))
def create():
    if request.method == 'POST':
        nombre = request.form['nombre']
        precio = float(request.form['precio'])
        material = request.form['material']
        talla = request.form['talla']
        genero = request.form['genero']

        try:
            conn = get_db_conn()
        except psycopg2.Error as e:
            pass
        try:
            cur = conn.cursor()
            cur.execute('INSERT INTO prenda (nombre, precio, material, talla, genero)'
                        'VALUES (%s, %s, %s, %s, %s)',
                        (nombre, precio, material, talla, genero))
        except (Exception, psycopg2.Error) as error :
            print ("Error while inserting a prenda: ", error)
            pass
        conn.commit()
        cur.close()
        conn.close()
        return redirect(url_for('index'))

    return render_template('create.html')

# Eliminar 'prenda'
@app.route('/delete/', methods=('GET', 'POST'))
def delete():
    if request.method == 'POST':
        id = int(request.form['id'])

        conn = get_db_conn()
        cur = conn.cursor()
        cur.execute('DELETE FROM prenda'
                    'WHERE id=%s',
                    (id, ))
        conn.commit()
        cur.close()
        conn.close()
        return redirect(url_for('index'))

    return render_template('delete.html')

# Actualizar prenda
@app.route('/update/', methods=('GET', 'POST'))
def update():
    if request.method == 'POST':
        id = int(request.form['id'])
        nombre = request.form['nombre']
        precio = float(request.form['precio'])
        material = request.form['material']
        talla = request.form['talla']
        genero = request.form['genero']

        conn = get_db_conn()
        cur = conn.cursor()
        cur.execute('UPDATE prenda'
                    ' SET nombre = %s, precio = %s, material = %s, talla = %s, genero = %s'
                    ' WHERE id=%s',
                    (nombre, precio, material, talla, genero, id))
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
