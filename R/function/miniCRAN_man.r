#used for solving local R packages management,especially in local area network(office place)
library(miniCRAN)
cran <- c(CRAN="https://cran.rstudio.org") #设置一个源
pkgs <- c("RODBC")#初始化时可以先直接下载一批包
pkgList <- pkgDep(pkgs, repos=cran, type="source", suggests = FALSE, availPkgs = cranJuly2014)
pkgList#查看初始定义了哪些包

dir.create(pth <- file.path("D:\\program\\r\\miniCRAN"))#在哪里建库repos

# Make repo for source andwin.binary
makeRepo(pkgList, path=pth, repos=cran, type=c("source", "win.binary")) #建repos
# List all files in miniCRAN,这个意义不大
list.files(pth, recursive=TRUE, full.names=FALSE)

pkgAvail(pth, type="source")[, c(1:3, 5)] # 查看有哪些可用的source源包
pkgAvail(pth, type="win.binary")[, c(1:3, 5)] # 查看有哪些可用的二进制包(windows)

addPackage("RODBC", path=pth, repos=cran, type=c("source", "win.binary")) #从cran上下载包，可以选择包的类型
# Check if updated packages are available。检查是否有需要更新的包
oldPackages(path=pth, repos=cran, type="source")[, 1:3] # should need update
oldPackages(path=pth, repos=cran, type="win.binary")[, 1:3] # should be current
# Update available packages
updatePackages(path=pth, repos=revolution, type="source", ask=FALSE) # should need update
updatePackages(path=pth, repos=revolution, type="win.binary", ask=FALSE) # should be current

# create a data frame with the package and version info  添加某个旧版本的包
oldVers <- data.frame(package=c("foreach", "codetools", "iterators"),
                      version=c("1.4.0", "0.2-7", "1.0.5"),
                      stringsAsFactors=FALSE)

# download old source package version and create repo index
addOldPackage(pkgList, path=pth, vers=oldVers$version, repos=revolution, type="source")

tempdir="D:/program/r/sequence/"
file.copy(list.files(tempdir,pattern = "*.zip", full.names = TRUE), file.path(pth, "bin", "windows","contrib","3.3"))#添加本地的包到repos里
file.copy(list.files(tempdir,pattern = "*.tar.gz", full.names = TRUE), file.path(pth, "src", "contrib"))

updateRepoIndex(pth, type=c("source", "win.binary"))#每次添加包，无论是本地还是网上，都需要update一下

install.packages("sequence", repos =pth,dependencies = TRUE,type = "source") #使用本地repos安装包
install.packages("sequence", repos = c(paste0("file:///", pth),cran),dependencies = TRUE,type = "win.binary")#repos多个选择，如果本地没有，就自动在其他的源里寻找并下载安装，注意：windows下必须选择"win.binary"
