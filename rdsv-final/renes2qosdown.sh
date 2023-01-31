
export VACC1="deploy/$OSMACC"
export VCPE1="deploy/$OSMCPE"

ACC_EXEC="$KUBECTL exec -n $OSMNS $VACC1 --"
CPE_EXEC="$KUBECTL exec -n $OSMNS $VCPE1 --"

$ACC_EXEC curl -X PUT -d '"tcp:127.0.0.1:6632"' http://127.0.0.1:8080/v1.0/conf/switches/0000000000000001/ovsdb_addr
sleep 10

$ACC_EXEC curl -X POST -d '{"port_name": "vxlanacc", "type": "linux-htb", "max_rate": "12000000", "queues": [{"max_rate": "4000000"}, {"min_rate": "8000000"}]}' http://127.0.0.1:8080/qos/queue/0000000000000001
sleep 10
$ACC_EXEC curl -X POST -d '{"match": {"dl_src": "02:fd:00:04:04:01", "dl_type": "IPv4"}, "actions":{"queue": "0"}}' http://127.0.0.1:8080/qos/rules/0000000000000001
$ACC_EXEC curl -X POST -d '{"match": {"dl_src": "02:fd:00:04:03:01", "dl_type": "IPv4"}, "actions":{"queue": "1"}}' http://127.0.0.1:8080/qos/rules/0000000000000001


