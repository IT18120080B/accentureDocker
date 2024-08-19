from flask import Flask
import snowflake.connector

app = Flask(__name__)

def get_snowflake_connection():
    conn = snowflake.connector.connect(
        user='ISURU14',
        password='Isuru1214.',
        account='KRNJCVN.DD96128',
        warehouse='COMPUTE_WH',
        database='SYSTEM_SERVICES',
        schema='ELASTICSEARCH'
    )
    return conn

def get_logs_by_level(log_level):
    conn = get_snowflake_connection()
    cursor = conn.cursor()
    query = f"SELECT * FROM APPLICATION_LOGS WHERE Log_Level = '{log_level}'"
    cursor.execute(query)
    rows = cursor.fetchall()
    cursor.close()
    conn.close()
    return rows

@app.route('/logs/<level>')
def show_logs(level):
    logs = get_logs_by_level(level.upper())
    return '<br>'.join([f"ID: {log[0]}, Timestamp: {log[1]}, Log_Level: {log[2]}, Message: {log[3]}" for log in logs])

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

