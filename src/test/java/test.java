import org.junit.Test;
import redis.clients.jedis.*;

public class test {


    @Test
    public void test01(){
        Jedis jedis=new Jedis("192.168.64.128",6379);
        jedis.auth("123");
        jedis.flushAll();

        jedis.set("abc","abc");
        String  s1=jedis.get("abc");
        System.out.println(s1);




    }
    @Test
    public void test2(){
        JedisPoolConfig config=new JedisPoolConfig();
        config.setMaxIdle(3);
        config.setMaxTotal(10);

        JedisPool jedisPool=new JedisPool(config,"192.168.64.128",6379);

        Jedis jedis=jedisPool.getResource();
        jedis.auth("123");
        jedis.set("a","a");
        String a=jedis.get("a");
        System.out.println(a);

    }
}

