<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{.title}}</title>
    <link rel="stylesheet" type="text/css" href="static\css\normal.css" />
    <link rel="shortcut icon " type="images/x-icon" href="static\img\32.ico">
    <link rel="stylesheet" href="http://at.alicdn.com/t/font_3280378_epazboq4thv.css">
    <link rel="stylesheet" href="static/css/github-markdown-light.css">
    <style>
        body {
            background-color: rgb(255, 255, 242);
            /* background-color: rgb(255, 233, 236); */

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

        .md form {
            text-decoration: none;
            left: 70px;
        }

        .md input {
            color: rgb(81, 185, 220);
            background-color: rgb(255, 255, 242);
            font-size: 18px;
            margin-bottom: 10px;
            margin-top: 30px;
            border: none;
        }

        .md form input:hover {
            text-decoration: underline;
        }

        .md h1 {
            font-size: 40px;
        }
    </style>
</head>

<body>
    <div>{{str2html .LayoutContent}}</div>
    <div class="md">
        <h1>归档</h1>
        {{range $id,$name:= .blog_map}}
        <form action="http://localhost:8080/blog">
            {{if gt $id 100}}
            <input type="submit" value={{$name}} />
            <input type="hidden" name="id" value={{printf "%d" ($id) }} />
            {{end}}
        </form>{{end}}
    </div>

</body>

</html>