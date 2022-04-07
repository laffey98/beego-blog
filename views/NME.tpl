<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{.title}}</title>
    <link rel="stylesheet" type="text/css" href="static\css\normal.css" />
    <link rel="stylesheet" type="text/css" href="static\css\markdown.css" />
    <link rel="shortcut icon " type="images/x-icon" href="static\img\32.ico">
    <link rel="stylesheet" href="http://at.alicdn.com/t/font_3280378_epazboq4thv.css">
    <link rel="stylesheet" href="static/css/github-markdown-light.css">
    <style>
        body {
            background-color: rgb(255, 255, 242);
            /* background-color: rgb(255, 233, 236); */

        }

        .markdown-body {
            background-color: rgb(255, 255, 242);
            /* background-color: rgb(255, 233, 236); */
        }

        .markdown-body code {
            background-color: rgb(213, 245, 255);
            /* background-color: rgb(255, 233, 236); */
        }

        .markdown-body pre {
            background-color: rgb(242, 249, 255);
            /* background-color: rgb(255, 233, 236); */
        }

        .markdown-body blockquote {
            background-color: azure;
            border-left: .25em solid #46a2ff;
        }

        .md {
            /* 
            left: 300px;
            width: 500px;
            top:30px; */
            position: relative;
            top: 35px;
            padding-left: 290px;
            padding-right: 60px;
            padding-bottom: 80px;
        }
    </style>
</head>

<body>
    <div>{{str2html .LayoutContent}}</div>
    <div class="md">
        <div class="markdown-body">{{.markdown}}</div>
        <div class="extra">{{.ex_blog}}</div>
    </div>
</body>

</html>