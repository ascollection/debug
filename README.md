# debug tool
支持logger面板日志输出，浏览器控制台日志输出，AIR工具arthropod日志输出以及本地调试时trace日志输出
其中logger面板有附带Stats——flash运行时检测器，可监测帧率，内存占用等方面的变化

## Usage 使用
```actionscript
//配置  
Debug.allowAdvancedTrace = true; //允许日志定位  
Debug.allowArthropodLog = true; //允许arthropod日志输出  
Debug.allowConsole = true; //允许浏览器控制台输出  
Debug.allowOutputTrace = true; //允许trace输出以及logger输出  
//testing  
var date:Date = new Date();  
var obj:Object = {'hello': 'world'};  
var arr:Array = ['hello', 'world'];  
Debug.log("year={}, month={}, day={}", date.getFullYear(), date.getMonth() + 1, date.getDate());  
Debug.color(Debug.PINK).log("This is a pink log");  
Debug.warning("warning warning warning");  
Debug.error("This is an error!");  
Debug.object(obj);  
Debug.array(arr);  
Debug.object(date);  
```
若需要logger面板，则需要配置Debug.allowOutputTrace为true，并且将logger添加到舞台
```actionscript
Debug.allowOutputTrace = true; //允许trace输出以及logger输出
addChild(Logger.getInstance());
```

## Preview 预览图
logger Logger面板（包含stats log）输出  
![](https://github.com/ascollection/simple-list/raw/master/bin/preview/logger.jpg)  
console 浏览器控制台输出  
![](https://github.com/ascollection/simple-list/raw/master/bin/preview/console.jpg)  
trace AVM输出  
![](https://github.com/ascollection/simple-list/raw/master/bin/preview/trace.jpg)  
arthropod 通过localconnection输出到air工具（arthropod）  
![](https://github.com/ascollection/simple-list/raw/master/bin/preview/arthropod.jpg)  

## Arthropod tool
[Arthropod air安装文件](https://github.com/ascollection/debug/tree/master/tool)  
PS: 由于arthropod每次启动都会检查更新，而arthropod站点停止维护了，因此将会遇到ssl证书出错的警告提示。  
可以使用tool/Arthropod.swf替换air安装目录中的同名文件