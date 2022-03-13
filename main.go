package main

import (
	"hello/controllers"
	_ "hello/routers"

	beego "github.com/beego/beego/v2/server/web"
)

func main() {
	beego.ErrorController(&controllers.ErrorController{})
	beego.SetStaticPath("/download", "static/download")
	beego.Run()
}
