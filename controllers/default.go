package controllers

import (
	"hello/print"
	"io/ioutil"

	beego "github.com/beego/beego/v2/server/web"
	"gopkg.in/yaml.v2"
)

const (
	place = "controllers"
)

type Config struct {
	Data map[int64]string
}

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
	Id   int64 `form:"id"`
	name string
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
	/* 序号逻辑
	二级页面：
		#范围：1-99
		博客归档：2
		站内自用：3
		关于我：4
		QQ微信：5
	三级页面：
		#范围：10000000-99999999
		具体博客：年月日+今日生成顺序	如：22031401
	*/
	config := Config{}
	config.Config()
	blog.name = config.Find(blog.Id)
	print.Printvar(place, blog.Id)
	print.Printvar(place, blog.name)
	if blog.name == "nofind" {
		c.Abort("Notfind")
	}

	switch {
	case blog.Id > 0 && blog.Id < 100:
		c.TplName = "NorAndMd.tpl"
	case blog.Id > 10000000 && blog.Id < 99999999:
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
		c.Data["upload"] = true
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

//------------------------------------------------
//parse config
//------------------------------------------------
func (c *Config) Config() {
	yamlS, readErr := ioutil.ReadFile("conf/blog.yaml")
	if readErr != nil {
		//fmt.Print(readErr)
		print.Printerr(readErr, "ConfigParse")
		return
	}
	// yaml解析的时候c.data如果没有被初始化，会自动为你做初始化
	err := yaml.Unmarshal(yamlS, &c.Data)
	if err != nil {
		//fmt.Print(err)
		print.Printerr(err, "ConfigPrase")
	}
	print.Printvar("ConfigParse", c.Data)
}

func (c *Config) Find(id int64) string {
	if c.Data[id] == "" {
		print.Printvar("ConfigParse", "Not Find")
		return "nofind"
	}
	return c.Data[id]
}
