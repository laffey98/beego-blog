# golang实现http服务



## 1.简单搭起网站
> - import：net/http
> - http.ListenAndServe第一个参数访问ip和端口，第二个参数是处理器参数,返回err
> - 函数http.HandleFunc和http.Handle第一个参数执行一个注册的作用，收到对应请求会执行不同的函数
> - HandleFunc是第二个参数是函数名，自由编写，调用函数
> - Handle是面向对象的方法,第二个参数是接口类型，只有一个ServeHTTP(ResponseWriter, *Request)方法
> - 实际上，HandleFunc函数内部也是调用了handle的方法
>
> ```go
> //HandleFunc
> func index(w http.ResponseWriter, r *http.Request) {
> 	//读取html文件
> 	f, _ := os.Open(`./index.html`)
> 	//读取数据
> 	buf, _ := ioutil.ReadAll(f)
> 	//写入到响应
> 	w.Write(buf)
> }
> 
> func main() {
> 	http.HandleFunc(`/first`, index)
> 	err:=http.ListenAndServe(":8080", nil)
> 	if err != nil {
        log.Fatal(err)
    }
> }
> 
> //Handle
> type httpServer struct {
> }
> 
> func (server httpServer) ServeHTTP(w http.ResponseWriter, r *http.Request) {
> w.Write([]byte(r.URL.Path))
> }
> 
> func main() {
> var server httpServer
> http.Handle("/", server)
> log.Fatal(http.ListenAndServe("localhost:9000", nil))
> }
> 
> ```



## 2.传递html
> ```go
> import (
> "net/http"
> "os"
> )
> 
> func indexhtml(w http.ResponseWriter,r *http.Request){
	f,_:=os.Open(`./views/html`)
	defer f.Close()
	//method 1
	io.Copy(w,f)
>
	//method 2
	buf,_:=ioutil.ReadAll(f)
	w.Write(buf)
>	
	//method 3
	buf,_:=make([]byte,1024)
	ln,_:=f.Read(buf)
	w.Write(buf[:ln])
}
> ```



## 3.接收参数
`r.ParseFrom()`把TCP包里数据解析放到Form(From里存放所有数据)，PostFrom（存放数据包中Body里的数据）,MultipartForm（存放传递的文件）里。底层的数据结构是map。
```go
//举例(接收url里的参数)
r.ParseFrom()
name:=r.Form["name"][0]//利用底层的数据结构搜索Form
name:=r.Form.Get("name")//搜索Form
name:=r.FormValue("name")//会搜索上面的三个form，可以检索文件
```
## 4.注册静态文件（访问 css img js 等）
```go
//单个
w.Header().Set("Content-Type","application/javascript")
f,_:=os.Open("./1.js")
```
注册多个
```go
http.Handle("/static/",http.StripPrefix("/static/",http.FileServer(http.Dir("./static"))))
```
http.StripPrefix("/static/",这部分去除前缀"/static/"，http.FileServer(http.Dir("./static"))表示在这个路径下找，比如用下面的调用，会在static目录下找1.js
```
//例:html中调用js
<script src="/static/1.js"></script>
```

