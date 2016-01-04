#! /bin/bash

if [ $# -eq 1 ]
  then username="$1"
  else echo -e "\033[31m miss param:please input param 1 for github username \033[0m";exit 1
fi

root_path=$(cd "$(dirname "$0")/../"; pwd)
cur_path=$(cd "$(dirname "$0")"; pwd)
repo_path=${cur_path}/repository

if [ ! -d "$repo_path" ]
then
mkdir "${repo_path}"
fi

cd ${repo_path}

rm -rf ${repo_path}/${username}/
git clone https://github.com/dsgygb/blog-hugo.git ${username}

cp -rf ${repo_path}/${username}/content/ ${root_path}/content/

cd ${root_path}

${root_path}/deploy.sh

echo -e "\033[0;32m success! \033[0m"

exit 1;




