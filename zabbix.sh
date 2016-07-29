#refresh_auth is setting up the expiration time for authentication token generated from the following api call
refresh_auth=125
#find's the auth.txt whether its greater than refresh_auth if not it will ignore token generation api call
[ "$(find auth.txt -cmin -$refresh_auth)" = "" ] && curl  -X POST -H "Content-Type: application/json" -d '{"jsonrpc": "2.0","method":"user.login","params": {"user":"admin","password":"zabbix"},"id": 1 }' http://52.41.139.191/zabbix/api_jsonrpc.php | sed 's/.*"result":"//' | sed 's/",".*//' > auth.txt
auth=$(cat auth.txt)
#if the argument to the zabbix.sh is hostgroup it will fetch the hostgroups data
[ "$1" = "hostgroup" ] && curl  -X POST  -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"hostgroup.get","params": {"output":"extend", "sortfield":"name"}, "id":1, "auth":"'"$auth"'" }'  http://52.41.139.191/zabbix/api_jsonrpc.php
#if the argument to the zabbix.sh is hostinfo it will fetch the details of host which are specefied in host. Note:we can specify multiple hosts
[ "$1" = "hostinfo" ] && curl -X POST  -H 'Content-Type: application/json' -d '{"jsonrpc": "2.0","method": "host.get","params": {"output": "extend","filter": {"host": ["logstash_zabbix","client"]}},"auth":"'"$auth"'" ,"id": 1 }' http://52.41.139.191/zabbix/api_jsonrpc.php
#if the argument to the zabbix.sh is hosttrigger it  allows to retrieve triggers based on hostid
[ "$1" = "hosttrigger" ] &&   curl  -X POST  -H 'Content-Type: application/json' -d   '{"jsonrpc": "2.0","method": "trigger.get","params": {"hostids": "10105","output": "extend","selectFunctions": "extend"},"auth": "'"$auth"'","id": 1 }' http://52.41.139.191/zabbix/api_jsonrpc.php
#if the argument to the zabbix.sh is hostalert, this method allows to retrieve alerts
[ "$1" = "hostalert" ] &&  curl  -X POST  -H 'Content-Type: application/json' -d   ' {"jsonrpc": "2.0","method": "alert.get","params": {"output": "extend",         "hostids": "10105"},"auth": "'"$auth"'","id": 1 }' http://52.41.139.191/zabbix/api_jsonrpc.php
#if the argument to the zabbix.sh is hostitemtriggers, The method allows to retrieve items which consists of cpu idletime,available memory for each host
[ "$1" = "hostitemtriggers" ] &&  curl -X POST -H 'Content-Type: application/json' -d '{"jsonrpc": "2.0","method": "item.get","params": {"output": "extend","hostids": "10105","with_triggers": "true","sortfield": "name"},"auth": "'"$auth"'","id": 1 }' http://52.41.139.191/zabbix/api_jsonrpc.php
