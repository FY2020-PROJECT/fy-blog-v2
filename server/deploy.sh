#! /bin/bash

if [ $# -eq 2 ]
  then username="$1"; repo_name="$2";
  else echo -e "\033[31m miss param:please input 2 params  for github username and repository,like ./deploy.sh dsgygb blog-hugo \033[0m";exit 1
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
git clone https://github.com/${username}/${repo_name}.git ${username}/${repo_name}

cd ${repo_path}/${username}/${repo_name}/content
for i in `find * -type f`
do
mv -f $i `echo ${i%.*}-${username}.${i##*.}`;
done


cd ${root_path}
git pull origin master

#copy
echo "copy from ${repo_path}/${username}/${repo_name}/content to ${root_path}/content/"

cp -rf ${repo_path}/${username}/${repo_name}/content/ ${root_path}/content/
${root_path}/deploy.sh "${username}/${repo_name} auto rebuilt site at `date`"

echo -e "\033[0;32m success! \033[0m"

exit 1;




