set -u # to verify variables are defined
: $KUBECTL
: $OSMNS
: $A2
: $B2
: $H21
: $H22


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

ACC_EXEC="$KUBECTL exec -n $OSMNS $A2 --"
CPE_EXEC="$KUBECTL exec -n $OSMNS $B2 --"


 $ACC_EXEC curl -X PUT -d '"tcp:10.255.0.4:6632"' http://localhost:8080/v1.0/conf/switches/0000000000000001/ovsdb_addr


 $ACC_EXEC curl -X POST -d '{"port_name": "vxlanint1", "type": "linux-htb", "max_rate": "6000000", "queues": [{"max_rate": "2000000"}, {"min_rate": "4000000"}]}' http://localhost:8080/qos/queue/0000000000000001

    


 $ACC_EXEC curl -X POST -d '{"match": {"nw_src": "'$H22'"}, "actions":{"queue": "0"}}' http://localhost:8080/qos/rules/0000000000000001
 $ACC_EXEC curl -X POST -d '{"match": {"nw_src": "'$H21'"}, "actions":{"queue": "1"}}' http://localhost:8080/qos/rules/0000000000000001

