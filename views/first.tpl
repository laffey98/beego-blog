<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>laffey98的知识宝库</title>
    <link rel="stylesheet" href="http://at.alicdn.com/t/font_3280378_epazboq4thv.css">
    <link rel="shortcut icon " type="images/x-icon" href="static\img\32.ico">
    <style>
        body {
            background-color: rgb(211, 137, 0);
            display: flex;
            justify-content: center;
            background-repeat: no-repeat;
            background-position:top;
            background-size:100%;
        }

        .a {
            position: relative;
            width: 700px;
            height: 400px;
            border: #fff 10px solid;
            background-color: rgb(142, 166, 240);
            top: 120px;
            border-radius: 20px;
            overflow: hidden;
        }

        .b {
            position: absolute;
            width: 260px;
            height: 300px;
            left: 0;
            margin: 60px 50px;
            /* 75 50 */
            transition: 1s;
        }

        .b a {
            text-decoration: none;
            color: #fff;
            font: 900 28px '';
        }

        .b h2 {
            /* 鼠标放开时的动画，第一个值是动画的过渡时间
            第二个值是延迟一秒后执行动画 */
            transition: .5s 1s;
            opacity: 0;
            color: rgb(30, 210, 200);
        }

        .b span {
            transition: .5s 1s;
            color: #fff;
            font: 500 15px '';
            position: absolute;
            top: 70px;
        }

        .c {
            position: absolute;
            top: -130px;
            right: -240px;
        }

        .d,
        .e {
            position: absolute;
            right: calc(var(--i)*100px);
            width: calc(var(--w)*40px);
            height: 500px;
            overflow: hidden;
            border-radius: 100px;
            transform: rotateZ(220deg) translate(0, 0);
            background: rgb(240, 220, 150);
            transition: .5s .5s;
        }

        .d:nth-child(2) {
            background: rgb(240, 190, 230);
        }

        .d:nth-child(3) {
            background: rgb(30, 210, 200);
        }

        .e {
            left: -470px;
            top: -140px;
            width: 70px;
            background-color: rgb(90, 220, 150);
        }

        .a:hover .c div {
            /* 设置延迟动画 */
            transition: .5s calc(var(--i)*.1s);
            /* 移动的轨迹 */
            transform: rotateZ(220deg) translate(-200px, 400px);
        }

        .a:hover .b {
            transition: 1s .5s;
            left: 370px;
        }

        .a:hover .b span {
            transition: 1s .5s;
            top: 105px;
        }

        .a:hover .b h2 {
            transition: 1s .5s;
            opacity: 1;
        }

        #baoxiang {
            color: gold
        }

        #yinliao {
            color: rgb(255, 166, 0)
        }

        .f {
            width: 50px;
            height: 100px;
            position: absolute;
            /* background-image: url("a.png");
            background-size: cover; */
            margin: 70px;
            opacity: 0;
            transition: .5s;
        }

        .f k {
            display: flex;
        }

        .f k a {
            text-decoration: none;
            margin: 35px;
            color: white;
        }

        .f k a i {
            width: 60px;
            height: 60px;
            line-height: 45px;
            text-align: center;
            vertical-align: middle;
            font-size: 30px;
        }

        .f k form {
            /* width: 100px; */
            height: 40px;
            margin: 20px;

        }

        .f k form input {
            height: 46px;
            width: 110px;
            border-radius: 12px;
            background-color: #94e4ff;
            font-size: 12px;
            color: rgb(0, 6, 65);
            border: 2px solid #64c1ff;
            -webkit-transition-duration: 0.4s;
            transition-duration: 0.4s;
            box-shadow: 0 8px 16px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
            font-size: medium;

        }

        .f k form input:hover {
            background-color: #64c1ff;
            color: white;
            box-shadow: 0 12px 16px 0 rgba(0, 0, 0, 0.24), 0 17px 50px 0 rgba(0, 0, 0, 0.19);
        }

        .a:hover .f {
            transition: 1s 1.3s;
            opacity: 1;
        }

    </style>
</head>

<body background="static\img\cl005.png">
    <!-- 名片分三大块
    最外层的一块a
    文字一大块b
    平面圆柱一块c 
    <i class="iconfont icon-baoxiang"></i> -->
    <div class="a">
        <div class="b">
            <a>laffey98的知识宝库</a>
            <h2>welcome to you!</h2>
            <span>请将鼠标移动进来,开启宝库吧！<br><br>宝库中存放着两堆宝藏 <i id="baoxiang" class="iconfont icon-baoxiang"></i> :<br>1.
                随心随性写的个人博客<br>2.
                收集的各种资源（可公开的）</br><br>主要是为自己而写，方便以后查找，有兴趣的话就看看吧，欢迎你的到来！<br /><br />对了，我喜欢创造和茉莉蜜茶<i id="yinliao"
                    class="iconfont icon-yinliao"></i>！<br>再次欢迎你的来访！</span>
        </div>
        <div class="c">
            <!-- --i是用来计算平面圆柱的动效延迟和距离的
            --w则是用来计算平面圆柱的宽度 -->
            <div class="d" style="--i:1;--w:1.5"></div>
            <div class="d" style="--i:2;--w:1.6"></div>
            <div class="d" style="--i:3;--w:1.4"></div>
            <div class="d" style="--i:4;--w:1.7"></div>
            <div class="e" style="--i:1"></div>
        </div>
        <!-- 设置二维码 -->
        <div class="f">
            <k>
                <form action="http://localhost:8080/blog">
                    <input type="submit" value="博客归档" />
                    <input type="hidden" name="id" value="2" />
                </form>
                <form action="http://localhost:8080/blog">
                    <input type="submit" value="站内自用" />
                    <input type="hidden" name="id" value="3" />
                </form>
            </k>
            <k>
                <form action="http://localhost:8080/blog">
                    <input type="submit" value="关于我" />
                    <input type="hidden" name="id" value="4" />
                </form>
                <form action="http://localhost:8080/file">
                    <input type="submit" value="资源下载" />
                </form>
            </k>
            <k>
                <a target="_blank" href="https://github.com/laffey98"><i class="iconfont icon-github"
                        title="GitHub"></i></a>
                <a href="http://localhost:8080/blog?id=5"><i class="iconfont icon-qq" title="QQ"></i></a>
                <a href="http://localhost:8080/blog?id=5"><i class="iconfont icon-weixin" title="WeiXin"></i></a>
            </k>

        </div>
    </div>
</body>

</html>