##1.RStudio
制作RStudio，直接用R步骤繁琐，使用RStudio-"New Project"，把R函数文件放到R文件夹下，点击"Build & Reload"是在本机测试，点击"More-Build Source/Binary Package"就是生成包了
##2.Roxygen函数注释
点击"Configure Build Tools"，可以选择使用Roxygen生成文档说明书，也就是CRAN上看到的那种函数说明书，如果需要完整的一个PDF说明文档，可以使用
    path <- find.package(pack)
    system(paste(shQuote(file.path(R.home("bin"), "R")),
    "CMD", "Rd2pdf", shQuote(path)))
将光标放到函数里，点击"Insert Roxygen Skeleton"，会自动插入一些注释关键字，输入@，可以看到完整的关键字信息
##3.面向对象
何时使用R的面向对象编程呢：
比如你要对每个种植物画不同的图形，不同的图形有特定的配色，这个时候就需要用到面向对象，比如写plot.orchid（兰花）函数，专门绘制兰花的图形。
S3编程很简单：

1. 给对象赋一个类名
2. 写一个泛型方法，然后再写具体方法(对于plot等内置方法，可以直接写plot.orchid)
3. 调用定义的方法

虽然Google推荐使用S4编程，但SS3使用起来显然更加快速方便，如果不是要写类似于神经网络那种含有大量对象且有复杂关系的包，建议使用S3。
S4编程时，不要让用户操作new()，应该把new()用函数封装起来，让用户直接调用一个可用的函数，可以注意一下很多包里的"ZZZ.R"
##4.依赖包
你包里的函数可能用了其他包的函数，如果在函数里面使用"library()"，一是管理起来不方便，二是会造成重复引用，代码不简洁，应该在DESCRIPTION里写，其中Depends的包是在library你的包的时候自动加载，Imports包是用到"::, @import, or @importFrom"的时候自动调用。
安装包的时候，如果选择dependencies=TRUE，可以自动安装依赖的包，需要注意的是，你在此处最好了解下关于"本地repos"的知识。
##5.tips
 - 如果你想在library时自动运行一些东西，可以使用.onAttach和.onLoad函数，相应的，还有.unAttach和.unLoad
 - 函数返回对象时，如果后面还要调用这个对象做其他事情，最好先赋一下class和attr的信息再返回
 - 给函数起一个好用的名字，封装(wrapper)你的函数
 - 使用git管理你的每一次包的更新
