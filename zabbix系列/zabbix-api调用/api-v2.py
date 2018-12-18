import requests
import json


#注意事项：
#1、创建item的时候注意创建的类型"value_type": 1值，看需要的是Character还是numeric unsigned等，如果这里设置的为numeric unsigned，而
#后面的trigger需要匹配的是字符串类型的，那么就会创建不成功
#
#2、要注意创建父service与创建子Service有不同的地方
#
#3、根据需求以及文档更改就可以用
#
#

#zabbix的URL、账号、密码
zabbix_root = 'http://XXXXXXXX/zabbix'
url = zabbix_root + '/api_jsonrpc.php'
user = "lile"
password = "Le@Li1809"

#监控模板信息
groups_name = "consul_service_counts"          #组名
template_name = "consul_services_counts_prod"  #模板名
father_services_name = "consul_services_counts_prod"

#所有的模块
items_name_list = ["account", "account-service", "airtime", "basic-data", "bill", "c-front", "cash-in-out", "collect",
                   "config-server", "device", "flutterwave", "loan", "loyalty", "m-aa", "m-customer-management",
                   "m-front", "m-workflow", "mail", "marketing", "member", "merchant", "message", "pay-route", "paystack",
                   "product-service", "push", "query", "quickteller", "risk-control", "send-money", "settlement", "sms",
                  "trade", "validator"]

env_message = "-Prod health status"        #trigger的name描述信息
contry = "-NG"

#trigger的name描述信息
post_header = {
        "Content-Type": "application/json"
    }



#登录获取Session
def get_session():
    post_login = {
        "jsonrpc": "2.0",
        "method": "user.login",
        "params": {
            "user": user,
            "password": password
        },
        "id": 1
    }

    req = requests.post(url, data=json.dumps(post_login), headers=post_header)
    zabbix_req = json.loads(req.text)

    print("Session为：" + zabbix_req.get('result'))
    return zabbix_req.get('result')

#获取hostgroup ID
def get_host_group_ids():
    host_group_id = {
        "jsonrpc": "2.0",
        "method": "hostgroup.get",
        "params": {
            "output": "extend",
            "filter": {
                "name": groups_name
            }
        },
        "auth": get_session(),
        "id": 1
    }

    host_group_id_post = requests.post(url, data=json.dumps(host_group_id), headers=post_header)
    host_group_id_res = json.loads(host_group_id_post.text)

    if host_group_id_res['result']:
        for a in host_group_id_res.get('result'):
            get_host_group_id = a['groupid']
            print(groups_name + "的groups ID 为：" + get_host_group_id)
        return get_host_group_id
    else:
        print("指定的组" + groups_name + "不存在")
        return -200

#创建hostgroup
def create_host_group():
    host_group = {
        "jsonrpc": "2.0",
        "method": "hostgroup.create",
        "params": {
            "name": groups_name
        },
        "auth": get_session(),
        "id": 1
    }

    host_group_post = requests.post(url, data=json.dumps(host_group), headers=post_header)
    print(groups_name + " 创建成功 ")

#获取templates的id
def get_template_ids():
    get_template_id = {
    "jsonrpc": "2.0",
    "method": "template.get",
    "params": {
        "output": "templateid",
        "filter": {
            "name": [
                template_name
            ]
        }
    },
    "auth": get_session(),
    "id": 1
}

    get_template_id_post = requests.post(url, data=json.dumps(get_template_id), headers=post_header)
    get_template_id_res = json.loads(get_template_id_post.text)
    print(get_template_id_res['result'])

    if get_template_id_res['result']:
        for a in get_template_id_res['result']:
            template_id = a['templateid']
            print(template_name + " 的ID为：" + template_id)
        return template_id
    else:
        print("指定的组" + template_name + "不存在")
        return -200

#创建templates
def create_templates():
    create_template = {
    "jsonrpc": "2.0",
    "method": "template.create",
    "params": {
        "host": template_name,
        "groups": {
            "groupid": get_host_group_ids(),
        }
    },
    "auth": get_session(),
    "id": 1
    }

    create_template_post = requests.post(url, data=json.dumps(create_template),  headers=post_header)
    create_template_res = json.loads(create_template_post.text)
    print(template_name + "创建成功")


#创建items
def create_items(src_items):
    create_item = {
    "jsonrpc": "2.0",
    "method": "item.create",
    "params": {
        "name": src_items,
        "key_": "prod.service[%s]"%src_items,
        "hostid": get_template_ids(),
        "type": 0,
        "value_type": 1,
        "delay": "60s"
    },
    "auth": get_session(),
    "id": 1
}

    create_item_post = requests.post(url, data=json.dumps(create_item), headers=post_header)
    create_item_res = json.loads(create_item_post.text)
    print(create_item_res)
    print(src_items + " item 创建成功 ")


#获取trigger ID
def get_trigger_ids(src_items):
    get_trigger_id = {
    "jsonrpc": "2.0",
    "method": "trigger.get",
    "params": {
        "output": "extend",
        "filter": {
            "description": [
                "%s%s%s"%(src_items,contry,env_message)
            ]
        }
    },
    "auth": get_session(),
    "id": 1
}

    get_trigger_id_post = requests.post(url, data=json.dumps(get_trigger_id), headers=post_header)
    get_trigger_id_res = json.loads(get_trigger_id_post.text)
   # print(get_trigger_id_res['result'])

    for a in get_trigger_id_res['result']:
        trigger_id = a['triggerid']
    return trigger_id



#创建trigger
def create_triggers(src_items):
    create_trigger = {
    "jsonrpc": "2.0",
    "method": "trigger.create",
    "params": {
            "description": "%s%s%s"%(src_items,contry,env_message),
            "expression": "{%s:prod.service[%s].str(172.30.8.10 not online)}=1 or {%s:prod.service[%s].str(172.30.11.6 not online)}=1 or {%s:prod.service[%s].str(\"172.30.8.10,172.30.11.6 both not online\")}=1"%(template_name,src_items,template_name,src_items,template_name,src_items),
            "priority": "2"

        },

    "auth": get_session(),
    "id": 1
}
    create_trigger_post = requests.post(url, data=json.dumps(create_trigger), headers=post_header)
    print(src_items + "  trigger创建成功")



#获取service ID
def get_service_ids(services_name):
    get_service_id = {
    "jsonrpc": "2.0",
    "method": "service.get",
    "params": {
        "output": "extend",
         "filter": {
            "name": [
                services_name
            ]
        }
    },
    "auth": get_session(),
    "id": 1
}

    get_service_id_post = requests.post(url, data=json.dumps(get_service_id), headers=post_header)
    get_service_id_res = json.loads(get_service_id_post.text)
    if get_service_id_res['result']:
        for a in get_service_id_res['result']:
            service_id = a['serviceid']
            print(father_services_name + " 的ID为：" + service_id)
        return service_id
    else:
        print("指定的组" + father_services_name + "不存在")
        return -200


#创建父service
def create_services():
    create_service = {
    "jsonrpc": "2.0",
    "method": "service.create",
    "params": {
        "name": father_services_name,
        "algorithm": 1,
        "showsla": 1,
        "goodsla": 99.99,
        "sortorder": 1
    },
    "auth": get_session(),
    "id": 1
}
    create_service_post = requests.post(url, data=json.dumps(create_service), headers=post_header)
    print(father_services_name + "创建成功")

#创建子service
def create_child_services(src_items,trigger_id):
    create_child_service = {
    "jsonrpc": "2.0",
    "method": "service.create",
    "params": {
        "name": src_items,
        "algorithm": 1,
        "showsla": 1,
        "goodsla": 99.99,
        "sortorder": 1,
        "triggerid": trigger_id,
        "parentid": get_service_ids(father_services_name)
    },
    "auth": get_session(),
    "id": 1
}
    create_child_service_post = requests.post(url, data=json.dumps(create_child_service), headers=post_header)
    print(src_items + " service创建成功")
    print(trigger_id)

#删除子service
def delete_services(service_id):
    delete_service = {
    "jsonrpc": "2.0",
    "method": "service.delete",
    "params": [
        service_id
    ],
    "auth": get_session(),
    "id": 1
}
    delete_service_post = requests.post(url, data=json.dumps(delete_service), headers=post_header)
    print("删除成功")



def main():
    if get_host_group_ids() == -200:
        create_host_group()
    if get_template_ids() == -200:
        create_templates()
    if get_service_ids(father_services_name) == -200:
        create_services()
    for item in items_name_list:
#        create_items(item)
#        create_triggers(item)
        create_child_services(item, get_trigger_ids(item))

#删除
#for item in items_name_list:
#    delete_services(get_service_ids(item))

main()