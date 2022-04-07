package routers

import (
	"hello/controllers"

	beego "github.com/beego/beego/v2/server/web"
)

func init() {
	beego.Router("/first", &controllers.MainController{})
	beego.Router("/blog", &controllers.BlogController{})
	beego.Router("/file", &controllers.FileController{})
}
