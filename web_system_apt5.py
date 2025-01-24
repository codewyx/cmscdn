from flask import Flask, request, jsonify
from flask_cors import CORS
import psutil
from datetime import datetime
import requests

app = Flask(__name__)
CORS(app)  

def get_processes_info():
    processes = []
    for proc in psutil.process_iter(['pid', 'name', 'username', 'status', 'memory_info', 'cpu_percent', 'create_time', 'cmdline']):
        try:
            cmdline = proc.info['cmdline']
            if isinstance(cmdline, list):
                command = ' '.join(cmdline)
            else:
                command = str(cmdline)
            
            process_info = {
                'id': proc.info['pid'],
                'name': proc.info['name'],
                'command': command,
                'cpu': f"{proc.info['cpu_percent']:.2f}",
                'memory': f"{(proc.info['memory_info'].rss / psutil.virtual_memory().total * 100):.2f}",
                'username': proc.info['username'],
                'time': datetime.fromtimestamp(proc.info['create_time']).strftime('%Y-%m-%d %H:%M:%S')
            }
            processes.append(process_info)
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            pass
    return processes

@app.route('/process', methods=['GET'])
def process():

    if request.remote_addr != '127.0.0.1':
        return jsonify(message='Unauthorized')
    
    data = request.args
    if data.get('type') == 'detail':
        token = request.headers.get('token')
        response = requests.get('http://localhost:8090/module/base/identify.php', params={'token': token})
        
        response_data = response.json()
        print(response_data.get('status'))
        if response_data.get('status') == '200':
            processes_info = get_processes_info()
            return jsonify(processes_info)  
        elif response_data.get('status') == '700':
            return jsonify(message='Unauthorized')
        else:
            return jsonify(message='Request failed', status=response_data.get('status')), response.status_code
    elif data.get('type') == 'kill':
        token = request.headers.get('token')
        response = requests.get('http://localhost:8090/module/base/identify.php', params={'token': token})
        response_data = response.json()
        if response_data.get('status') == '200':
            pid = data.get('pid')
            try:
                process = psutil.Process(pid)
                process.kill()
                return jsonify(message='Process killed successfully')
            except psutil.NoSuchProcess:
                return jsonify(message='Process not found'), 404
        elif response_data.get('status') == '700':
            return jsonify(message='Unauthorized')
        else:
            return jsonify(message='Request failed', status=response_data.get('status')), response.status_code
    else:
        return jsonify(message='Invalid type')

if __name__ == '__main__':
    app.run(debug=True, port=21909)
