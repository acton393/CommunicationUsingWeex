   在开发 Weex 过程中，遇到问题比较多的，比较高频的是通信问题，今天我们来聊聊，如何在 Weex 场景下做通信，通信的方式，原理等。
   
   首先对于 Weex 这个框架来讲，简单来讲它接受的输入是上层的 DSL(Domain Specific Language) 转换之后的 JavaScript 代码，最后呈现给用户的是原生的 UI，在这个过程中存在了以下环境: 
 
 * Weex Context         执行 [js-framework](https://mp.weixin.qq.com/s/K6wXSGPywc7Ltm0T3lz-Sg) 和 输入的上层的 DSL(Domain Specific Language) 转换之后的 JavaScript 代码， Weex Page 的 runtime 环境

* native 原生环境         集成 WeexSDK，创建 Weex SDK 的 instance，以及调用框架的渲染方法，处理框架产物(根据 DSL 产生 的 native UI)

* web 环境(optional)   [web](http://weex.apache.org/references/components/web.html) 组件提供的 html 的渲染和执行环境， web 组件依赖的 webView 内部实现自带一个 javaScript 的执行环境。


     ![image.png | center](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/5b784c04cf12a62c50107e979bf75525.png "")


一般考虑到的通信就本质来看就是在上述三个环境中的通信问题
#### native 到 Weex js 通信
##### 在 native 部分向 Weex js 发送消息传递数据
* 通过自定义 [Android](http://weex.apache.org/cn/guide/extend-android.html)  和 [iOS](http://weex.apache.org/cn/guide/extend-ios.html#zi-ding-yi-module-de-bu-zou)  `module` 或者 `component` 方法的时候，在方法中增加 callback 参数, 通过回调机制将数据传递到 Weex js 环境中。
* 通过全局事件发送消息传递数据，让你的 app 支持 [全局事件](http://weex.apache.org/cn/references/modules/globalevent.html) 

1. 例子Android/iOS 客户端  ：

```java
//Java
Map<String,Object> params=new HashMap<>();
params.put("key","value");
mWXSDKInstance.fireGlobalEventCallback("deviceBeganShake",params);
```
    
```objectivec
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [_sdkInstance fireGlobalEvent:@"deviceBeganShake" params:@{@"eventName":@"deviceBeganShake",@"timestamp":@(event.timestamp)}];
}
```

          Weex javaScript 中接受全局事件:
```javascript
var globalEvent = weex.requireModule('globalEvent');
globalEvent.addEventListener("deviceBeganShake", function (e) {
  console.log(JSON.stringify(e))
});
```

2. 原理:  全局事件底层实现是依赖系统的iOS notification(Android intent)实现,会通知到每一个监听了该事件的页面，在 notification 的处理函数中通过 callback 形式返回到 weex jsContext 的环境中。

#### Weex js 到 native 之间的通信
##### 在 Weex js 中向 native 发送消息传递数据
* 通过自定义 [Android](http://weex.apache.org/cn/guide/extend-android.html)  和 [iOS](http://weex.apache.org/cn/guide/extend-ios.html#zi-ding-yi-module-de-bu-zou)  `module` 或者 `component` 方法, 实现将 js 的数据传递到 native 端。JavaScript 、Android 和 iOS 的数据类型映射如下表格。

| iOS | Android | javaScript |
| :--- | :--- | :--- |
| NSDictionary | JSONObject | Object |
| NSNumber | Integer | Number |
| BOOL | boolean | Boolean |
| NSString | String | String |

原理：框架会在启动阶段收集已经注册的 `module`或者`component` 方法，在 javaScript 端调用（执行在Weex js context）中，通过 bridge 方式到 框架 native 部分 ，框架 runtime 将构建自定义 module 对象或者找到要调用组件对象，然后调用对应的方法。

#### Weex js 之间的通信
##### 在已经打开的页面之间通信
     对于在当前栈里（已经打开）的页面，可以使用 [broadcastChannel](https://weex.apache.org/cn/references/broadcast-channel.html) 实现页面间通信。在每个页面中创建监听了相同频道(channel)的 BroadcastChannel 实例，并且添加 onmessage 方法。如果某些页面使用 postMessage 向频道中发送了消息，所有监听者都能接收到。

![image.png | center | 586x344](https://gw.alipayobjects.com/zos/skylark/2ab92a9e-d18b-476c-8ea5-82895e5bc395/2018/png/24df3fed-78cc-466d-9f31-f671b54df934.png "")

broadcastChannel 是一个全双工(双向)通道，在 postMessage 的同时也可以监听当前 Channel 发过来的 message  
在 [dotWe](http://dotwe.org/vue/3f20f083da0d01e50ad3fd635f718cbf) 体验， 在跳转后的第二个页面中输入任意字符，然后点击 Back 返回第一个页面，可以看到第一个页面的渲染内容已经发生了变化。
  
原理：这两个页面都创建了频道名称为 `whatever` 的 BroadcastChannel 对象，第一个页面中实现了 `onmessage` 方法接受频道中的信息，并且赋值给 `text` 属性；第二个页面中监听输入框的变化，每次数据改变都向频道中 `postMessage` 把最新输入的数据发送出去，此时第一个页面会接收到消息并且重新渲染 `text` 的文本。


####  Web 到 Weex js 通信
[Web 相关的通信目前在社区的讨论中](https://mail-archives.apache.org/mod_mbox/incubator-weex-dev/201802.mbox/%3Ctencent_D912DB45BB915D1B52B3A2ADCACA4132DA06%40qq.com%3E)， 在这边可以大概做一个方案的介绍

![image.png | center | 686x349](https://gw.alipayobjects.com/zos/skylark/af32d1f3-c2cd-4b97-b7d3-988a80a2f75d/2018/png/d5bca03f-8649-446f-84f9-5ceed13d95ee.png "")

Web 组件中渲染 HTML 和执行 JavaScript ,它内部有自己的一个上下文环境, 和 Weex jsContext 或者纯 native 环境都是隔离开的。
* web 向 weex jsContext通信

     在 webview 中执行 JavaScript 通过bridge 的方式，调用到native, 然后在通过 native 调用 weex 组件的 fireEvent 方法就可以通信到Weex jsContext.
* weex jsContext 向 web 发消息  

    weex js 中调用到 native 的 component 或者 module 方法，native 通过在 webView 的context 里面 发送MessageEvent 对象， web中监听该对象就可以收到消息。



查看完整例子: [https://github.com/acton393/CommunicationUsingWeex.git](https://github.com/acton393/CommunicationUsingWeex.git)
 
