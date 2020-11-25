# Explorers

## Explorer 1

This explorer was build with [appforce/dappforce-tendermint-explorer](https://github.com/dappforce/dappforce-tendermint-explorer)

```bash=
# install yarn 
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
apt-get update
apt-get install yarn

# clone repo
git clone https://github.com/dappforce/dappforce-tendermint-explorer.git
cd dappforce-tendermint-explorer

# install dependencies
yarn

# build
yarn build

# launch http server
cd dist
python3 -m http.server 8080

# ngrok
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
unzip ngrok-stable-linux-amd64.zip 
./ngrok http 8080 --region=jp
```

## Explorer 2

This explorer was build with


```bash=
# install nodejs
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
apt install nodejs
apt-get -y install nodejs-dev node-gyp libssl1.0-dev
apt-get -y install npm





```
