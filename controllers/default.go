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

type UploadController struct {
	beego.Controller
}

type FileController struct {
	beego.Controller
}

type blog struct {
	Id int64 `form:"id"`
}

//------------------------------------------------
//MainController
//------------------------------------------------

func (c *MainController) Get() {
	/* 	//text
	   	word, _ := beego.AppConfig.String("uploadpassword")
	   	print.Printvar(place, word) */
	c.TplName = "First.tpl"
}

//------------------------------------------------
//BlogController
//------------------------------------------------

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

//------------------------------------------------
//FileController
//------------------------------------------------

func (c *FileController) Post() {
	password := c.GetString("password")
	word, err := beego.AppConfig.String("uploadpassword")
	if err != nil {
		print.Printerr(err, place)
		c.Abort("Uploaderror")
	}
	if password == word {
		f, h, err := c.GetFile("uploadname")
		if err != nil {
			print.Printerr(err, place)
		}
		defer f.Close()
		c.SaveToFile("uploadname", "static/download/"+h.Filename)
	} else {
		c.Abort("Uploaderror")
	}
}

func (c *FileController) Get() {
	c.TplName = "File.tpl"
}

//------------------------------------------------
//ErrorController
//------------------------------------------------

func (c *ErrorController) ErrorNotfind() {
	//c.Data["content"] = "page not found"
	c.TplName = "Notfind.tpl"
}

func (c *ErrorController) ErrorUploaderror() {
	//c.Data["content"] = "page not found"
	c.TplName = "Uploaderror.tpl"
}
