#!/bin/bash
sudo yum update -y
sudo cat >> /etc/yum.repos.d/mongodb-org-5.0.repo <<EOL
[mongodb-org-5.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/5.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-5.0.asc
EOL
sudo yum install -y mongodb-org
sudo yum install -y jq
sudo systemctl start mongod
sudo systemctl daemon-reload
sudo systemctl status mongod
sudo systemctl enable mongod
STRING1="bindIp: 127.0.0.1"
STRING2="bindIp: 0.0.0.0"
sudo sed -i "s/$STRING1/$STRING2/" /etc/mongod.conf
STRING3="#replication:"
STRING4='replication:'\\n'  replSetName: "rs0"'
sudo sed -i "s/$STRING3/$STRING4/" /etc/mongod.conf
sudo systemctl stop mongod
sudo systemctl start mongod
RWPWD=$(aws secretsmanager get-secret-value --secret-id ${appsmithrw} --region us-east-1 | jq -r ".SecretString" | jq -r ".password")
ADMINPWD=$(aws secretsmanager get-secret-value --secret-id ${appsmithadmin} --region us-east-1 | jq -r ".SecretString" | jq -r ".password")
sudo cat >> ./mongosetup.js <<EOL
rs.initiate()
use admin
db.createUser({user:"appsmithadmin",
pwd:"$ADMINPWD",
roles:[{role:"clusterAdmin", db:"admin"},
{role:"readAnyDatabase", db:"admin"},
{role:"dbAdminAnyDatabase", db:"admin"}]})
use appsmithdb
db.createUser({user:"appsmithrw",
pwd:"$RWPWD",
roles:[{role:"clusterMonitor", db:"admin"},
{role:"readWrite", db:"appsmithdb"}]})
EOL
sudo chmod 700 mongosetup.js
sudo su
mongosh < mongosetup.js
rm mongosetup.js
sudo echo "${mongo_key}" > /var/lib/mongo/keyfile
sudo chmod 400 /var/lib/mongo/keyfile
sudo chown mongod:mongod /var/lib/mongo/keyfile
STRING5="#security:"
STRING6='security:'\\n'  authorization: "enabled"'
sudo sed -i "s/$STRING5/$STRING6/" /etc/mongod.conf
STRING7='authorization: "enabled"'
STRING8='authorization: "enabled"'\\n'  keyFile: /var/lib/mongo/keyfile'
sudo sed -i "s|$STRING7|$STRING8|" /etc/mongod.conf
sudo systemctl restart mongod
