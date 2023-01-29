set -u # to verify variables are defined
: $KUBECTL
: $OSMNS
: $H11
: $H12
: $H21
: $H22

export VACC="deploy/$OSMACC"
export VCPE="deploy/$OSMCPE"


ACC_EXEC="$KUBECTL exec -n $OSMNS $VACC --"
CPE_EXEC="$KUBECTL exec -n $OSMNS $VCPE --"


$ACC_EXEC curl -X PUT -d '"tcp:127.0.0.1:6632"' http://localhost:8080/v1.0/conf/switches/0000000000000001/ovsdb_addr

# Configuramos 12 Mbps de bajada de la red residencial y la bajada en las colas (hX1(Cola 1) y hX2(Cola 0))

$ACC_EXEC curl -X POST -d '{"port_name": "vxlanacc", "type": "linux-htb", "max_rate": "12000000", "queues": [{"max_rate": "4000000"}, {"min_rate": "8000000"}]}' http://localhost:8080/qos/queue/0000000000000001

$ACC_EXEC curl -X POST -d '{"match": {"nw_dst": "'$H22'"}, "actions":{"queue": "0"}}' http://localhost:8080/qos/rules/0000000000000001
$ACC_EXEC curl -X POST -d '{"match": {"nw_dst": "'$H21'"}, "actions":{"queue": "1"}}' http://localhost:8080/qos/rules/0000000000000001
