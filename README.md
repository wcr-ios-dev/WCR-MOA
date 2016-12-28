# WCR-MOA
16年 -12 - 14 ============================
从今天开始利用业余时间写一写我的移动办公OA,作为一种尝试我会考虑是否在项目中加入React-native 的混编.
16年 -12 -28 ============================
前几天停下来做公司的项目没有空更新这里了,今天在项目里面添加一个afn 3.0. 
  遇到一个问题这里记录一下:
    afn3.0 在AFURLRequestSerialization类里面的requestBySerializingRequest方法 
		通过  query = AFQueryStringFromParameters(parameters);对参数的编码进行了处理.
		导致在我的这个项目的代理端接受请求参数的时候出错.
		所以我把这一句注释了,改为 query = parameters;
		这样就可以了.
	对了,今天还添加了touchXML这个第三方的xml解析库,在正式项目中我们也是使用这个来解析	,所以这个项目我就用这个咯.能够满足我的需求
