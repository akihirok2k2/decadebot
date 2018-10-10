#!/bin/bash
## iscon用ベンチマークを実行する際にごみ出力が多いため、スクリプトで整理
## require ; jq kataribe

# kataribe 対応
mv /var/log/nginx/access.log{,$(date +%Y%m%d_%H%M%S)}
systemctl restart nginx

## bench
HOME=/home/isucon/isubata/bench
GOPATH=/home/isucon/go
BENCHOUT=/tmp/bench.result
cd /home/isucon/isubata/bench
./bin/bench -remotes localhost:80 -output $BENCHOUT  >/dev/null 2>&1
echo "= BENCH SCORE =================================================================================="
python -c "import json;print('score : '+str(json.load(open('$BENCHOUT'))['score']))"
echo "===ERROR ========================================================================================"
cat $BENCHOUT | jq -r '.error[]'

## kataribe output
echo "= KATARIBE  =================================================================================="
cat /var/log/nginx/access.log | kataribe -f /usr/local/bin/kataribe.toml

echo "================================================================================================"
