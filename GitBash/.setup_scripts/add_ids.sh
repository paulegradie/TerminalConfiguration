#!bin/sh
cd ~/.ssh/
# ssh-agent auto-launch (0 = agent running with key; 1 = w/o key; 2 = not run.)
IDS=$(ls ~/.ssh/*id_rsa | xargs -n 1 basename)
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

for id in $IDS;
do
if   [ $agent_run_state = 2 ]; then
  eval $(ssh-agent -s)
  ssh-add ~/.ssh/$id
elif [ $agent_run_state = 1 ]; then
  ssh-add ~/.ssh/$id
fi
done;

cd ~
