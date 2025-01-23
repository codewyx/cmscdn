from flask import Flask, request, jsonify
import psutil
from datetime import datetime

app = Flask(__name__)

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
    data = request.args
    if data.get('type') == 'process':
        processes_info = get_processes_info()
        return jsonify(processes_info)
    else:
        return jsonify(message='invalid type'), 400

if __name__ == '__main__':
    app.run(debug=True, port=21909)