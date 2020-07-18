import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;
import redis.clients.jedis.JedisShardInfo;
import redis.clients.jedis.ShardedJedisPool;

import java.util.LinkedList;
import java.util.List;

public class PoolUtil {
    private static ShardedJedisPool pool=null;

    public static ShardedJedisPool open(String host,int port){
        if(pool==null){
            JedisPoolConfig config=new JedisPoolConfig();
            config.setMaxTotal(10);
            config.setMaxIdle(3);
            config.setTestOnBorrow(true);


            JedisShardInfo jedisShardInfo1 = new JedisShardInfo("192.168.64.128",6379);

            jedisShardInfo1.setPassword("123");

            List<JedisShardInfo> list = new LinkedList<JedisShardInfo>();

            list.add(jedisShardInfo1);

            pool = new ShardedJedisPool(config, list);

        }
        return  pool;
    }
    public  static  void  close(){
        if(pool!=null){
            pool.close();
        }
    }
}
