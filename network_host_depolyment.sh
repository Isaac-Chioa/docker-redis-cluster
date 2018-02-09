for red in 0 1 2 3 4 5 ; do   \
sed -i "1c port 500$red" "$PWD"/redis/redis.conf &&\
docker run -d \
-p "500$red:500$red" \
-v "$PWD"/redis/:/usr/local/etc/redis/   \
--name "redis-$red" \
--net host   \
redis:3.2.6 \
redis-server /usr/local/etc/redis/redis.conf &&\
sleep 1;done


docker run -it --rm --net host ruby sh -c '\
  gem install redis \
  && wget http://download.redis.io/redis-stable/src/redis-trib.rb \
  && ruby redis-trib.rb create --replicas 1 \
  '"$(for red in 0 1 2 3 4 5 ; do \
    echo -n 10.28.19.194:"500$red"' '; \
  done)"


for red in 0 1 2 3 4 5; do docker kill "redis-$red" && docker rm "redis-$red"; done
