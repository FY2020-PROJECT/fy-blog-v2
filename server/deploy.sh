#! /bin/bash

if [ $# -eq 1 ]
  then username="$1"
  else echo "pleace input param 1 for github username";exit 1
fi

root_dir=$(cd "$(dirname "$0")/../"; pwd)
cur_dir=$(cd "$(dirname "$0")"; pwd)
repo_path=${cur_dir}/repository

if [ ! -d "$repo_path" ]
then
mkdir "${repo_path}"
fi

cd ${repo_path}

rm -rf ${repo_path}/${username}/
git clone https://github.com/dsgygb/blog-hugo.git ${username}

cp -rf ${repo_path}/${username}/content/ ${root_dir}/content/

${root_dir}/deploy.sh




#
#cd repository
#
##echo ${username}
#
#git clone https://github.com/dsgygb/blog-hugo.git ${username}
#
#cd ${username}
#
#git pull
#
#cp -r -f ../../repository/${username}/content/ ../../../content/
#
#cd ../../../
#
#./deploy.sh




