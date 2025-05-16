cd /opt/keycloak/bin
./kcadm.sh config credentials --server http://localhost:8080 --realm master --user user --password password
./kcadm.sh create realms -s realm=PolarBookshop -s enabled=true
./kcadm.sh create roles -r PolarBookshop -s name=employee
./kcadm.sh create roles -r PolarBookshop -s name=customer
./kcadm.sh create users -r PolarBookshop -s username=isabelle -s firstName=Isabelle -s lastName=Dahl -s email=isa@gmail.com -s enabled=true
./kcadm.sh add-roles -r PolarBookshop --uusername isabelle --rolename employee --rolename customer
./kcadm.sh create users -r PolarBookshop -s username=bjorn -s firstName=Bjorn -s lastName=Vinterberg -s email=vinter@gmail.com -s enabled=true
./kcadm.sh add-roles -r PolarBookshop --uusername bjorn --rolename customer
./kcadm.sh set-password -r PolarBookshop --username isabelle --new-password password
./kcadm.sh set-password -r PolarBookshop --username bjorn --new-password password
./kcadm.sh create clients -r PolarBookshop -s clientId=edge-service -s enabled=true -s publicClient=false -s secret=polar-keycloak-secret -s 'redirectUris=["http://localhost:9000","http://localhost:9000/login/oauth2/code/*"]'
