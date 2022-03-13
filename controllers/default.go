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

type blog struct {
	Id int64 `form:"id"`
}

func (c *MainController) Get() {
	c.TplName = "first.tpl"
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
	print.Printvar(place, blog)
	if blog.Id == 1 {
		c.TplName = "normal.tpl"
	} else {
		c.StopRun()
	}
}
