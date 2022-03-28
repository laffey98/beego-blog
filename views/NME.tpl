NME<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ .title}}</title>
    <link rel="stylesheet" type="text/css" href="static\css\normal.css"/>
    <link rel="stylesheet" type="text/css" href="static\css\markdown.css"/>
    <link rel="shortcut icon " type="images/x-icon" href="static\img\32.ico">
</head>
<body>
    <div>{{.LayoutContent}}</div>
    <div>{{.markdown}}</div>
    <div>{{.ex_blog}}</div>
</body>
</html>