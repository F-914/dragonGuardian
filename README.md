Northeastern University Internship Project
# dragonGuardian

## data
data中的base存储了BaseModel基类，此外的类都在data文件夹中。
在这一部分中，为了避免一次向构造函数传入太多参数导致混乱，父类的构造函数所需要的参数需要单独传入。
例如：BaseModel -> Reward -> CurrencyReward 这条继承线，如果创建了CurrencyReward对象T，需要使用Reward的属性，那么需要执行语句`T:setReward(args)`。BaseModel同理。
这种设计可以让传参更有层次，同时可以有选择地对功能进行保留与割舍。