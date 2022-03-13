package controllers

import (
	"hello/print"

	beego "github.com/beego/beego/v2/server/web"
)

const (
	place = "controllers"
)

type MainController struct {
	beego.Controller
}

type BlogController struct {
	beego.Controller
}

type ErrorController struct {
	beego.Controller
}

type blog struct {
	Id int64 `form:"id"`
}

func (c *MainController) Get() {
	c.TplName = "First.tpl"
}

func (c *BlogController) Get() {
	blog := blog{}
	//test
	//fmt.Println("/blog")
	if err := c.ParseForm(&blog); err != nil {
		print.Printerr(err, place)
		c.StopRun()
	}
	//test
	print.Printvar(place, blog.Id)
	switch {
	case blog.Id > 0 && blog.Id < 100:
		c.TplName = "NorAndMd.tpl"
	case blog.Id > 100 && blog.Id < 1000:
		c.TplName = "NME.tpl"
	default:
		c.Abort("Notfind")
	}
}

func (c *ErrorController) ErrorNotfind() {
	//c.Data["content"] = "page not found"
	c.TplName = "Notfind.tpl"
}
