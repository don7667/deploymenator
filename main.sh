#!/bin/bash

REPOS=(
    "github.com/openbankit/abs.git"
    "github.com/openbankit/api.git"
    "github.com/openbankit/cards-bot.git"
    "github.com/openbankit/merchant-bot.git"
    "github.com/openbankit/exchange.git"
    "github.com/openbankit/frontend.git"
)

GIT_BRANCH='mirror'
CUR_DIR=${PWD}

function makeconfig {
    cd $1 && cp -f ${CUR_DIR}/default.env .env
}

clear old default config file
rm -rf ./default.env

cp -f ./clear.env default.env

echo "" >> ./default.env
echo "PROJECT_NAME=OpenbankIT" >> ./default.env
read -p "Enter SMTP host:" smtp_host; echo "SMTP_HOST=$smtp_host" >> ./default.env;
read -p "Enter SMTP port:" smtp_port; echo "SMTP_PORT=$smtp_port" >> ./default.env;
read -p "Enter SMTP security:" smtp_security; echo "SMTP_SECURITY=$smtp_security" >> ./default.env;
read -p "Enter SMTP username:" smtp_user; echo "SMTP_USER=$smtp_user" >> ./default.env;
read -p "Enter SMTP password:" smtp_pass; echo "SMTP_PASS=$smtp_pass" >> ./default.env;

for i in "${REPOS[@]}"
do
    dir=$(basename "$i" ".git")
    dir=${CUR_DIR}/../${dir}

   if [[ -d "$dir" ]]; then
       cd $dir && makeconfig $dir && make build && cd ..
   else
       git clone -b $GIT_BRANCH "https://$i" $dir
       cd $dir && makeconfig $dir && make build && cd ..
   fi
done

echo "make indexes on api..."
cd ./api && sleep 1 && make indexes
echo "Complete"
