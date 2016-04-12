sudo apt-get install -y build-essential
sudo apt-get install -y golang
sudo apt-get install -y mercurial
git clone https://github.com/inconshreveable/ngrok.git ngrok
cd ngrok
mkdir -p keys
cd keys
openssl genrsa -out base.key 2048
openssl req -new -x509 -nodes -key base.key -days 10000 -subj "/CN=$1" -out base.pem
openssl genrsa -out server.key 2048
openssl req -new -key server.key -subj "/CN=$1" -out server.csr
openssl x509 -req -in server.csr -CA base.pem -CAkey base.key -CAcreateserial -days 10000 -out server.crt
cd ..
cp keys/base.pem assets/client/tls/ngrokroot.crt
make release-server release-client
echo "./bin/ngrokd -tlsKey=keys/server.key -tlsCrt=keys/server.crt -domain=\"$1\" -httpAddr=\":8080\" -httpsAddr=\":8081\" > /dev/null 2>&1 &" > start.sh
chmod +x start.sh
