   
set -u # to verify variables are defined
: $KUBECTL
: $OSMNS
: $VACC
: $VCPE
: $H11
: $H12
: $H21
: $H22

if [[ ! $VACC =~ "helmchartrepo-accesschart"  ]]; then
    echo ""       
    echo "ERROR: incorrect <access_deployment_id>: $VACC"
    exit 1
fi

if [[ ! $VCPE =~ "helmchartrepo-cpechart"  ]]; then
    echo ""       
    echo "ERROR: incorrect <cpe_deployment_id>: $VCPE"
    exit 1
fi

if [[ ! $A2 =~ "helmchartrepo-accesschart"  ]]; then
    echo ""       
    echo "ERROR: incorrect <access_deployment_id>: $A2"
    exit 1
fi

if [[ ! $B2 =~ "helmchartrepo-cpechart"  ]]; then
    echo ""       
    echo "ERROR: incorrect <cpe_deployment_id>: $B2"
    exit 1
fi

ACC_EXEC="$KUBECTL exec -n $OSMNS $VACC --"
CPE_EXEC="$KUBECTL exec -n $OSMNS $VCPE --"

ACC_EXEC2="$KUBECTL exec -n $OSMNS $A2 --"
CPE_EXEC2="$KUBECTL exec -n $OSMNS $B2 --"

$ACC_EXEC curl -X PUT -d '"tcp:127.0.0.1:6632"' http://localhost:8080/v1.0/conf/switches/0000000000000001/ovsdb_addr

# Configuramos 12 Mbps de bajada de la red residencial y la bajada en las colas (hX1(Cola 1) y hX2(Cola 0))

$ACC_EXEC curl -X POST -d '{"port_name": "vxlanacc", "type": "linux-htb", "max_rate": "12000000", "queues": [{"max_rate": "4000000"}, {"min_rate": "8000000"}]}' http://localhost:8080/qos/queue/0000000000000001

$ACC_EXEC curl -X POST -d '{"match": {"nw_dst": "'$H12'"}, "actions":{"queue": "0"}}' http://localhost:8080/qos/rules/0000000000000001
$ACC_EXEC curl -X POST -d '{"match": {"nw_dst": "'$H11'"}, "actions":{"queue": "1"}}' http://localhost:8080/qos/rules/0000000000000001


$ACC_EXEC2 curl -X POST -d '{"match": {"nw_dst": "'$H22'"}, "actions":{"queue": "0"}}' http://localhost:8080/qos/rules/0000000000000001
$ACC_EXEC2 curl -X POST -d '{"match": {"nw_dst": "'$H21'"}, "actions":{"queue": "1"}}' http://localhost:8080/qos/rules/0000000000000001
