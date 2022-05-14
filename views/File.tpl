<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{.title}}</title>
    <link rel="stylesheet" type="text/css" href="static\css\normal.css" />
    <link rel="stylesheet" href="http://at.alicdn.com/t/font_3280378_epazboq4thv.css">
    <link rel="stylesheet" href="static/css/cursor.css">
    <link rel="shortcut icon " type="images/x-icon" href="static\img\32.ico">
    <style>
        body {
            background-color: rgb(255, 255, 242);
            /* background-color: rgb(255, 233, 236); */

        }

        input[type=password] {
            width: 70%;
            padding: 12px 20px;
            margin: 8px 0;
            box-sizing: border-box;
            border: 3px solid #ccc;
            -webkit-transition: 0.5s;
            transition: 0.5s;
            outline: none;
            font-size: 15px;
        }

        input[type=file] {
            height: 52px;
            width: 30%;
            padding: 12px 20px;
            margin: 8px 0;
            box-sizing: border-box;
            border: 3px solid #ccc;
            -webkit-transition: 0.5s;
            transition: 0.5s;
            outline: none;
            font-size: 15px;
        }

        input[type=password]:focus {
            border: 3px solid #555;
        }

        input[type=submit] {
            height: 46px;
            width: 110px;
            border-radius: 12px;
            background-color: #94e4ff;
            font-size: 12px;
            color: rgb(8, 23, 152);
            border: 2px solid #64c1ff;
            -webkit-transition-duration: 0.4s;
            transition-duration: 0.4s;
            box-shadow: 0 8px 16px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
            font-size: medium;
        }

        input[type=submit]:hover {
            background-color: #64c1ff;
            color: white;
            box-shadow: 0 12px 16px 0 rgba(0, 0, 0, 0.24), 0 17px 50px 0 rgba(0, 0, 0, 0.19);
        }

        .submit {
            display: {{.upload}};
        }

        .submit p {
            color: rgb(118, 221, 255);
            font-size: 40px;
        }

        .blog {
            position: relative;
            top: 20px;
            padding-left: 290px;
            padding-right: 40px;
            padding-bottom: 50px;
        }

        .file {
            position: relative;
            top: 20px;
            padding-left: 290px;
            padding-right: 40px;
            padding-bottom: 30px;
        }

        .submit {
            position: relative;
            padding-bottom: 80px;
            text-align: center;
        }

        .downblog {
            padding-left: 100px;
        }

        form {
            padding-top: 20px;
            padding-bottom: 10px;
            color: rgb(96, 96, 96);
            font-size: 20px;
        }

        .downblog input {
            height: 55px;
            width: 130px;
            border-radius: 12px;
            background-color: #ffe17e;
            font-size: 20px;
            color: rgb(0, 6, 65);
            border: 2px solid #ffe895;
            -webkit-transition-duration: 0.4s;
            transition-duration: 0.4s;
            box-shadow: 0 8px 16px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
        }

        .downblog input:hover {
            background-color: #ffd139;
            color: white;
            box-shadow: 0 12px 16px 0 rgba(0, 0, 0, 0.24), 0 17px 50px 0 rgba(0, 0, 0, 0.19);
        }
    </style>
</head>

<body>
    <div>{{.LayoutContent}}</div>
    <div class="blog">
        <h1>在线文件服务</h1>
        <form action="http://laffey98.cn/downloadblog" class="downblog">
            <input type="submit" value="下载博客" />
        </form>
        <form action="http://laffey98.cn/file" method="post" enctype="multipart/form-data">
            上传博客：<input type="file" name="blogname" />
            <input type="password" name="blogpassword" placeholder="上传博客密钥">
            <input type="submit" value="提交" />
        </form>
    </div>
    <div class="file">
        <form action="http://laffey98.cn/downloadfile" class="downblog">
            <input type="submit" value="下载文件" />
        </form>
        <form action="http://laffey98.cn/file" method="post" enctype="multipart/form-data">
            上传文件：<input type="file" name="filename" />
            <input type="password" name="filepassword" placeholder="上传文件密钥">
            <input type="submit" value="提交" />
        </form>
    </div>
    <div class="submit">
        <p>成功提交！</p>
    </div>
</body>

</html>