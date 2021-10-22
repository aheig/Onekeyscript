# 常用一键脚本

# 1、Snipe-IT  v5.3.0.sh 脚本
  Snipe-IT 是一个免费的开源IT资产管理Web应用程序。是一款基于Laravel5.4的免费的开源IT资产管理系统。Snipe-IT用于IT资产管理，IT部门可通过它能够跟踪谁拥有哪些笔记本电脑，何时购买、包含哪些软件许可证和可用的附件等。
  
  本脚本仅适用于CentOS7。脚本来源：[Late Winter](https://www.itca.cc/%E7%BD%91%E7%AB%99%E7%A8%8B%E5%BA%8F/89.html)
  
```
yum update /y
sudo curl -o Snipe-IT.sh https://raw.githubusercontent.com/aheig/Onekeyscript/main/Snipe-IT.sh && chmod +x Snipe-IT.sh && bash ./Snipe-IT.sh
```

# 5、changesource  一键更换国内软件仓库源

  脚本来源：[苍穹の下](https://www.blueskyxn.com/202101/3828.html)
```
yum update /y
sudo curl -o changesource.sh https://raw.githubusercontent.com/aheig/Onekeyscript/main/changesource.sh && chmod +x changesource.sh && bash ./changesource.sh
```
    
# 
