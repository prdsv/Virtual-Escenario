set -u # to verify variables are defined
: $KUBECTL
: $OSMNS
: $VACC
: $VCPE
: $H11
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

ACC_EXEC="$KUBECTL exec -n $OSMNS $VACC --"
CPE_EXEC="$KUBECTL exec -n $OSMNS $VCPE --"


$ACC_EXEC curl -X PUT -d '"tcp:10.255.0.2:6632"' http://localhost:8080/v1.0/conf/switches/0000000000000001/ovsdb_addr


$ACC_EXEC curl -X POST -d '{"port_name": "vxlanint1", "type": "linux-htb", "max_rate": "6000000", "queues": [{"max_rate": "2000000"}, {"min_rate": "4000000"}]}' http://localhost:8080/qos/queue/0000000000000001


$ACC_EXEC curl -X POST -d '{"match": {"nw_src": "'$H12'"}, "actions":{"queue": "0"}}' http://localhost:8080/qos/rules/0000000000000001
$ACC_EXEC curl -X POST -d '{"match": {"nw_src": "'$H11'"}, "actions":{"queue": "1"}}' http://localhost:8080/qos/rules/0000000000000001

