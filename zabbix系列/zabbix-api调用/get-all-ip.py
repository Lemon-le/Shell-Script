import requests
import json

zabbix_root = 'http://XXXXXXXX/zabbix'
url = zabbix_root + '/api_jsonrpc.php'


#登录

post_login = {
    "jsonrpc": "2.0",
    "method": "user.login",
    "params": {
        "user": "lile",
        "password": "Le@Li1809"
    },
    "id": 1
}

post_header = {
    "Content-Type": "application/json"
}

#json.load() 将一个存储在文件中的json对象(str)转换为相对应得python对象
#json.loads() 将一个json对象(str)转换为相对应得python对象
#json.dump() 将python对象转换为对应的json对象，并存储在文件中
#json.dumps() 将python的对象转换为json对象


#返回的是json对象
req = requests.post(url, data=json.dumps(post_login), headers=post_header)

#这里使用req.text的原因：
#requests对象的get和post方法都会返回一个Response对象，这个对象里面存的是服务器返回的所有信息，报货响应头、
#响应状态码等；其中返回的网页部分会存在.context和.text两个对象中。
zabbix_req = json.loads(req.text)

#获取所有ip
get_ip = {
    "jsonrpc": "2.0",
    "method": "host.get",
    "params": {
        "output": ["hostid"],
        "selectInterfaces": ["ip"]
    },
    "auth": zabbix_req.get('result'),
    "id": 1
}

get_ip_post = requests.post(url, data=json.dumps(get_ip), headers=post_header)
get_ip_res = json.loads(get_ip_post.text)

#得到一个所有IP的列表
all=get_ip_res.get('result')
print(get_ip_res.get('result'))

#打印IP的个数
print(len(all))

#处理格式，打印所有的IP
for a in all:
    for b in a['interfaces']:
        print(b['ip'])








