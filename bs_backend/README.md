备忘录:
1. 因为不用redis进行结果缓存，使用资源占用率很低，选择使用
2. celery当写完mysql,同步es出错时，报错error,上报sentry，手工处理
   1. 不使用事物，将写mysql和es放在一起，因为写es是一个次要操作，只要确保mysql写入成功就可以了，使用事物很影响用户体验

部署细节:
mysql:
1. 创建db,
2. 创建用户和密码

redis:
1. 使用db10
   ```bash
   select 10
   set comment "------bs_backend celery----"
   ```

nginx:
1. 配置头像图片访问路径
2. 配置代理后端bs_backend
   ```conf
    # bs images
    location /bs/images {
        alias /nginx/bs/images;
        access_log off;
    }

    # bs backend
    location /bs/api/ {
        # 将/bs/api/去掉之后转发给后端
        rewrite ^/bs/api/(.*)$ /$1 break;
        
        # 设置为容器名
        proxy_pass http://host.docker.internal:8080/;

        # 设置Nginx从后端服务器读取响应的超时时间（默认60s）
        proxy_read_timeout 120s;

    }
   ```
3. nginx和bs_celery共享文件容器卷
   ```yaml
    volumes:
      
      - bs-images:/nginx/bs/images
    networks:
      - ser-network

   networks:
      ser-network:
         name: ser-network

   volumes:
      bs-images:
         name: bs-images
         external: true
   ```


es: