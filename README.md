# Setting up MagicMirror in Mac through Docker

新建文件夹叫做 `magic_mirror`，路径为 `~/docker/magic_mirror`

进入 `magic_mirror` 文件夹，新建文件夹 `config` 和 `modules` 来存放 `config.js` 文件 和 自己建的 `module`。

新建文件 `run.sh`

```bash 
#!/bin/bash

docker run  -d \
	--publish 80:8080 \
	--restart always \
	--volume ~/docker/magic_mirror/config:/opt/magic_mirror/config \
	--volume ~/docker/magic_mirror/modules:/opt/magic_mirror/modules \
	--name magic_mirror \
    bastilimbach/docker-magicmirror
```

注意 ：
`--publish 80:8080 \ ` 表示通过 80 端口去访问 docker container 的 `8080` 端口。

`--volume ~/docker/magic_mirror/config:/opt/magic_mirror/config \ ` 使用的是当前的 config 文件夹。意思是同步挂载文件夹内容至 `Docker 中 magic_mirror/config`。

进入 config 文件夹中新建 `config.js` 文件，并填入

```javascript
var config = {
	address: "",
	port: 8080,
  	ipWhitelist: ["127.0.0.1", "::ffff:127.0.0.1", "::1", "::ffff:192.168.2.1/120", "192.168.199.192", "172.17.0.1"],
	language: "en",
	timeFormat: 24,
	units: "metric",

	modules: [
		{
			module: "alert",
		},
		{
			module: "updatenotification",
			position: "top_bar"
		},
		{
			module: "clock",
			position: "top_left"
		},
	]

};

/*************** DO NOT EDIT THE LINE BELOW ***************/
if (typeof module !== "undefined") {module.exports = config;}
 0
```

其中 `ipWhitelist: ["127.0.0.1", "::ffff:127.0.0.1", "::1", "::ffff:192.168.2.1/120", "192.168.199.192", "172.17.0.1"]`, 用来白名单主机的 ip 地址，进行访问。

设置 docker 的主机地址 “0.0.0.0” 为 “127.0.0.1” 进行 `localhost:80` 的访问：

进入 `Docker > Preferences > Daemon > Advanced` 从 Docker 菜单栏，添加：
"ip" : "127.0.0.1",
添加后如下：
```
{
	"ip" : "127.0.0.1",
  "debug" : true,
  "experimental" : false
}
```

点击 Apply & Restart，重启 Docker，让配置生效。

回到 magic_mirror 目录，运行 `./run.sh`，来运行 magic_mirror contianer。

打开浏览器，访问 `http://localhost:80` 这时候就可以访问到 Docker 中运行的 MagicMirror 了

## 升级 MagicMirror

访问 `localhost:80` ，这时候可能出现 MagicMirror 需要升级。

进入 docker 的 bash 中，host terminal 中运行。


```
docker exec -it magic_mirror /bin/bash
```

运行 `git pull && npm install`

运行完毕后打开 lazydocker，重启 container 即可。刷新浏览器，已经升级到最新的版本了。


## 参考
- [MM docker container problem with mac and linux](https://forum.magicmirror.builders/topic/6652/mm-docker-container-problem-with-mac-and-linux?page=1)
- [Can I change the default IP from 0.0.0.0 when binding?](https://forums.docker.com/t/can-i-change-the-default-ip-from-0-0-0-0-when-binding/30358/3)
- [MichMich/MagicMirror > Docker](https://github.com/MichMich/MagicMirror#docker)
- [bastilimbach/docker-MagicMirror](https://github.com/bastilimbach/docker-MagicMirror)

