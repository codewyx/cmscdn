from flask import Flask, request, jsonify
import psutil
from datetime import datetime
import requests

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
    if data.get('type') == 'detail':
        token = data.get('token')
        processes_info = get_processes_info()
        
        # 发送 GET 请求到指定 URL，并携带 token
        response = requests.get('http://localhost:8090/module/base/identify.php', params={'token': token})
        
        response_data = response.json()
        print(response_data.get('status'))
        if response_data.get('status') == '200':
            return jsonify(processes_info)  # 输出响应内容
        elif response_data.get('status') == '700':
            return jsonify(message='Unauthorized'), 403  # 提醒未授权
        else:
            return jsonify(message='Request failed', status=response_data.get('status')), response.status_code
    else:
        return jsonify(message='Invalid type'), 400

if __name__ == '__main__':
    app.run(debug=True, port=21909)
