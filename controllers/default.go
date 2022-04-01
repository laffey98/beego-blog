package controllers

import (
	"fmt"
	"hello/print"
	"io/ioutil"
	"os"
	"strings"
	"time"

	beego "github.com/beego/beego/v2/server/web"
	"github.com/russross/blackfriday"
	"gopkg.in/yaml.v2"
)

const (
	place = "controllers"
)

var blog_num int
var blog_today string

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
	//md to html
	md := md2html(blog.name)
	if md != "success" {
		c.Abort(md)
	}

	switch {
	case blog.Id > 0 && blog.Id < 100:
		c.Data["title"] = blog.name
		c.Layout = "NorAndMd.tpl"
		c.TplName = "normal.tpl"
		c.LayoutSections = make(map[string]string)
		c.LayoutSections["markdown"] = "markdown.tpl"
	case blog.Id > 10000000 && blog.Id < 99999999:
		c.Data["title"] = blog.name
		c.Layout = "NME.tpl"
		c.TplName = "normal.tpl"
		c.LayoutSections = make(map[string]string)
		c.LayoutSections["markdown"] = "markdown.tpl"
		c.LayoutSections["ex_blog"] = "ex_blog.tpl"
	default:
		c.Abort("Notfind")
	}
}

//------------------------------------------------
//FileController
//------------------------------------------------

func (c *FileController) Post() {
	file_password := c.GetString("filepassword")
	blog_password := c.GetString("blogpassword")
	file_word, err := beego.AppConfig.String("fileword")
	if err != nil {
		print.Printerr(err, place)
		c.Abort("Uploaderror")
	}
	blog_word, err := beego.AppConfig.String("blogword")
	if err != nil {
		print.Printerr(err, place)
		c.Abort("Uploaderror")
	}
	if file_password == file_word {
		f, h, err := c.GetFile("filename")
		if err != nil {
			print.Printerr(err, place)
		}
		defer f.Close()
		c.SaveToFile("filename", "static/download/"+h.Filename)
		c.Data["upload"] = true
	} else {
		c.Abort("Uploaderror")
	}

	if blog_password == blog_word {
		f, h, err := c.GetFile("blogname")
		if err != nil {
			print.Printerr(err, place)
		}
		defer f.Close()
		c.SaveToFile("blogname", "blog/"+h.Filename)
		er := write2yaml(h.Filename)
		if er == "Uploaderror" {
			c.Abort(er)
		}
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

func (c *ErrorController) ErrorSthwrong() {
	//c.Data["content"] = "page not found"
	c.TplName = "Sthwrong.tpl"
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
	//print.Printvar("ConfigParse", c.Data)
}

func (c *Config) Find(id int64) string {
	if c.Data[id] == "" {
		print.Printvar("ConfigParse", "Not Find")
		return "nofind"
	}
	return c.Data[id]
}

//------------------------------------------------
//md to html
//------------------------------------------------

func md2html(name string) string {
	file_path := `blog\` + name + ".md"
	md, readErr := ioutil.ReadFile(file_path)
	if readErr != nil {
		print.Printerr(readErr, "md2html")
		return "Sthwrong"
		//c.Abort("Sthwrong")
	}
	output := blackfriday.MarkdownCommon(md)
	err := ioutil.WriteFile("views\\markdown.tpl", output, 0644)
	if err != nil {
		print.Printerr(err, "md2html")
		return "Sthwrong"
		//c.Abort("Sthwrong")
	} else {
		print.Printvar("md2html", "WriteFile Success!")
	}
	return "success"
}

//------------------------------------------------
//write to yaml
//------------------------------------------------

func write2yaml(name string) string {
	//file_path := `conf\` + "blog.yaml"
	yaml, readErr := os.OpenFile(`conf\blog.yaml`, os.O_RDWR, 0666)
	if readErr != nil {
		print.Printerr(readErr, "write2yaml")
		return "Uploaderror"
	}
	yaml_value := strings.Replace(name, ".md", "", 1)
	year := time.Now().Year() - 2000
	month := time.Now().Month()
	day := time.Now().Day()
	syear := fmt.Sprintf("%d", year)
	smonth := fmt.Sprintf("%d", month)
	sday := fmt.Sprintf("%d", day)
	if month < 10 {
		smonth = "0" + smonth
	}
	if day < 10 {
		sday = "0" + sday
	}

	today := syear + smonth + sday
	if blog_today == today {
		blog_num++
	} else {
		blog_today = today
	}
	sblog_num := fmt.Sprintf("%d", blog_num)
	if blog_num < 10 {
		sblog_num = "0" + sblog_num
	}
	n, err := yaml.Seek(0, os.SEEK_END)
	if err != nil {
		print.Printerr(err, "write2yaml")
	}
	_, err = yaml.WriteAt([]byte(today+sblog_num+": "+yaml_value+"\n"), n)

	//_, err := yaml.WriteString(string(year) + string(month) + string(day) + yaml_value + "\n")
	if err != nil {
		print.Printerr(err, "write2yaml")
		return "Uploaderror"
	}
	defer yaml.Close()
	return "OK"
}
