# AXBadgeView-Swift
# 介绍
[![Build Status](https://travis-ci.org/devedbox/AXBadgeView-Swift.svg?branch=master)](https://travis-ci.org/devedbox/AXBadgeView-Swift)[![Version](https://img.shields.io/cocoapods/v/AXBadgeView-Swift.svg?style=flat)](http://cocoapods.org/pods/AXBadgeView-Swift)[![License](https://img.shields.io/cocoapods/l/AXBadgeView-Swift.svg?style=flat)](http://cocoapods.org/pods/AXBadgeView-Swift)[![Platform](https://img.shields.io/cocoapods/p/AXBadgeView-Swift.svg?style=flat)](http://cocoapods.org/pods/AXBadgeView-Swift)

[AXBadgeView-Swift](https://github.com/devedbox/AXBadgeView-Swift)是一个badge view管理类，是之前我写的[AXBadgeView](https://github.com/devedbox/AXBadgeView)的Swift版本（以下的介绍中统一使用__AXBadgeView__），在新版本中没有太大的改动，主要的是把原有的功能实用swift实现了，使用方法是一样的。

![image](http://ww2.sinaimg.cn/large/d2297bd2gw1f1kwshfqhwg20ab0i94b2.gif)

__AXBadgeView__是一个badge view视图，继承于__UILabel__，子类的实现完成了UI的自动布局，自动计算content的bounds大小并可以通过指定`minSize`实现badge view最终的bounds大小。

__AXBadgeView__使用的是自动布局来控制显示的位置的，为什么要用自动布局呢？在我之前做的一个项目中，我使用的是第三方的badge view管理类，在GitHub上的星星还是很多的，但是我使用了之后发现，布局是有问题的，在发现问题之后我就去看了看源码，结果问题显而易见，那个类使用的不是自动布局。那么在这样一个对布局精准度要求较高的地方的话，使用自动布局可以减少很多布局上面的隐患，其实这点来说，我也推荐是用自动布局，因为自动布局的强大之处已经不用我来多说了。

__AXBadgeView__中怎样控制badge view显示的偏移量呢？通过设置badge instance的`offSets`属性来控制，`offSets`的默认值采用了`CGFloat.max`和`CGFloat.min`两个值，max表示就是x的最大值或者y的最小值，min就用来表示x的最小值和y的最小值。`offSets`的默认值是`（CGFloat.max, CGFloat.min）`，表示x的最右边和y的最上边，也就是superView的右上角。那么，在使用的过程中，如果想表示边界值的话就通过以上两个值来表示，就不用手动去计算superView的高宽了。同样的，如果想给定指定的`offSets`值的话，就可以设置这个属性，坐标系就是iOS的默认坐标系。
## 特性
以上已经对__AXBadgeView__做了一定的介绍了，那么这里将做一些总结性的东西，出了以上介绍的几点之外，__AXBadgeView__还具有以下特性：

>- 设置数字显示`99+`的样式，可以自定义显示的数字.
>- 自定义显示的样式.
>- 自定义动画效果.
>- 当内容为`0`的时候可以设置隐藏.
>- 当内容更新的时候，是否动画更新内容.

## 样式
__AXBadgeView__默认提供了4样式，每一种样式显示的内容都有所区别，在使用的过程中可以根据需求设置不同的样式以达到不痛的效果。样式默认为：`.Normal`。使用的过程中可以指定`style`来确定显示的样式和内容：

```
enum AXBadgeViewStyle: Int {
    /// Normal shows a red dot.
    case Normal
    /// Number shows a number form text.
    case Number
    /// Text shows a custom text.
    case Text
    /// New shows a new text.
    case New
}
```
- .Normal：显示小红点.
- .Number：显示数字.
- .Text：显示普通文本.
- .New：显示`new`文本.

通过代码实现更改样式：

objective-c：

```
_showsView.badgeView.style = AXBadgeViewNew;
```
swift：

```
showsView.badgeView.style = AXBadgeViewStyle.New
```
## 动画
__AXBadgeView__提供了4种动画，每一种动画都有不同的显示效果。在使用的过程中可以设置不同的动画类型来实现不同的显示效果。动画默认为`.None`即无动画，那么在设置相应的动画类型的话可以通过设置`animation`来指定响应的动画类型：

```
enum AXBadgeViewAnimation: Int {
    /// Animation none, badge view stay still.
    case None
    /// Animation scale.
    case Scale
    /// Animation shake.
    case Shake
    /// Animation bounce.
    case Bounce
    /// Animation breathe.
    case Breathe
}
```
- .None：默认，不显示任何动画.
- .Scale：缩放动画.
- .Shake：震动动画.
- .Bounce：反弹动画.
- .Breathe：渐变动画.

代码示例：

objective-c：

```
_showsView.badgeView.animation = AXBadgeViewAnimationScale
```
swift：

```
showsView.badgeView.animation = AXBadgeViewAnimation.Scale
```
# API
我在写这个工具类的时候就考虑到API友好的这个实际问题了，那么这样的一个工具应该怎样去设计它的API接口呢？在软件开发中，耦合度越低对我们整个项目的研发和维护是有很大帮助的，所以我们在设计一个API的时候，就要尽量去考虑到耦合度的因素。

__AXBadgeView__接口很简单，在使用的过程中过我们只需要关心`显示`和`隐藏`的接口就行了，其他的细节已经处理好了：

`show(animated:inView:)`

`hide(animated:completion:)`

__AXBadgeView__采用了协议和类扩展的形式，直接在`UIView`、`UIBarButtonItem`、`UITabBarItem`中直接添加并实现了相应的接口，使用起来很方便。在__OC__中使用了运行时添加__Associated Objects__的方式添加了__badgeView__属性和相关的饿方法。那么在__Swift__中的话就有点差别，__Swift__中在添加了以上三个类的扩展以外，还实现了对应的协议：

```
protocol AXBadgeViewDelegate {
    /// Badge view property.
    var badgeView: AXBadgeView {get set}
    /// Animated to show the badge view.
    func showBadge(animated animated: Bool) -> Void
    /// Animated to hide the badge view.
    func clearBadge(animated animated: Bool) -> Void
}
```

# 怎样接入我的项目？
## 源文件
直接引用就是直接在GitHub下载代码源文件[AXBadgeView-Swift](https://github.com/devedbox/AXBadgeView-Swift)----->[Objective-C版](https://github.com/devedbox/AXBadgeView)，并将下载的源文件导入工程：

1. swift直接使用.

2. oc在需要使用的地方`#import "AXBadgeView.h"`.

## CocoaPods

[CocoaPods](http://cocoapods.org) 依赖管理是比较使用起来比较方便的一种方式，只需要添加相应的依赖描述，便可直接接入现有项目：

1. 添加pod描述到你的Podfile问家里边： `pod 'AXPopoverView', '~> 0.1.0'`
2. 运行安装命令： `pod install`.
3. - swift直接使用.
   - oc在需要使用的地方`#import "AXBadgeView.h"`.
   
# License

This code is distributed under the terms and conditions of the [MIT license](LICENSE). 
