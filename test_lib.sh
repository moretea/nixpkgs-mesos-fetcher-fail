testapp() {
app_id=$1
file_name=$2
echo "#### Add app with $file_name URI"

curl_cmd="
curl -s \
-H 'Content-Type: application/json' \
-X POST -d \
'{ \"id\": \"$app_id\", \"cmd\": \"find; while true; do date; sleep 30; done\", \"cpus\": 0.1, \"mem\": 10.0, \"instances\": 1, \"uris\": [ \"http://master/$file_name\" ] }' \
master:8080/v2/apps
"

nixops ssh -d fetcher-fail master "$curl_cmd"
echo

echo "### Waiting until the app is ready"
sleep 15

failed_task_id=`nixops ssh -d fetcher-fail slave "curl -s master:8080/v2/apps/$app_id| jq .app.lastTaskFailure.taskId"`
echo "task id: $failed_task_id"
if [ "x$failed_task_id" == "xnull" ]; then
  echo "#### Task did not fail :)"
else
  echo "#### Task failed! Showing logs for last failure"
  nixops ssh -d fetcher-fail slave "find /var/lib/mesos | grep "$task_id/runs/.*/std*" | xargs cat"
fi

echo "#### Delete app again"
nixops ssh -d fetcher-fail slave "curl -s -XDELETE master:8080/v2/apps/$app_id"

sleep 5

}
