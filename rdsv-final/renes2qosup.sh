set -u # to verify variables are defined
: $KUBECTL
: $OSMNS
: $H21
: $H22



export VACC1="deploy/$OSMACC"
export VCPE1="deploy/$OSMCPE"

ACC_EXEC="$KUBECTL exec -n $OSMNS $VACC1 --"
CPE_EXEC="$KUBECTL exec -n $OSMNS $VCPE1 --"

$ACC_EXEC curl -X PUT -d '"tcp:10.255.0.4:6632"' http://127.0.0.1:8080/v1.0/conf/switches/0000000000000002/ovsdb_addr
sleep 10

$ACC_EXEC curl -X POST -d '{"port_name": "vxlan1", "type": "linux-htb", "max_rate": "6000000", "queues": [{"max_rate": "2000000"}, {"min_rate": "4000000"}]}' http://127.0.0.1:8080/qos/queue/0000000000000002
sleep 10

$ACC_EXEC curl -X POST -d '{"match": {"dl_src": "02:fd:00:04:04:01", "dl_type": "IPv4"}, "actions":{"queue": "0"}}' http://127.0.0.1:8080/qos/rules/0000000000000002
$ACC_EXEC curl -X POST -d '{"match": {"dl_src": "02:fd:00:04:03:01", "dl_type": "IPv4"}, "actions":{"queue": "1"}}' http://127.0.0.1:8080/qos/rules/0000000000000002
