set -u # to verify variables are defined
: $KUBECTL
: $OSMNS
: $H21
: $H22



export VACC1="deploy/$ACCPOD2"
export VCPE1="deploy/$CPEPOD2"

ACC_EXEC="$KUBECTL exec -n $OSMNS $VACC1 --"
CPE_EXEC="$KUBECTL exec -n $OSMNS $VCPE1 --"


 $ACC_EXEC curl -X PUT -d '"tcp:10.255.0.4:6632"' http://localhost:8080/v1.0/conf/switches/0000000000000001/ovsdb_addr


 $ACC_EXEC curl -X POST -d '{"port_name": "vxlanint1", "type": "linux-htb", "max_rate": "6000000", "queues": [{"max_rate": "2000000"}, {"min_rate": "4000000"}]}' http://localhost:8080/qos/queue/0000000000000001

    


 $ACC_EXEC curl -X POST -d '{"match": {"nw_src": "'$H22'"}, "actions":{"queue": "0"}}' http://localhost:8080/qos/rules/0000000000000001
 $ACC_EXEC curl -X POST -d '{"match": {"nw_src": "'$H21'"}, "actions":{"queue": "1"}}' http://localhost:8080/qos/rules/0000000000000001

