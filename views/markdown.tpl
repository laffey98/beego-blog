<h1>golang context包</h1>

<h2>简介</h2>

<blockquote>
<p>以下来自golang官方文档</p>
</blockquote>

<ul>
<li><p>包context定义了context类型，它携带截止日期、取消信号以及跨API边界和进程之间的其他请求作用域值。</p></li>

<li><p>向服务器发出的请求应该创建一个Context，向服务器发出的调用应该接受一个Context。 它们之间的函数调用链必须传播Context，可以使用WithCancel、WithDeadline、WithTimeout或WithValue创建的派生context替换它。 当一个Context被取消时，所有从它派生的Context也被取消。</p></li>

<li><p>WithCancel, WithDeadline和WithTimeout函数接受一个Context(父函数)并返回一个派生的Context(子函数)和一个CancelFunc函数。 调用CancelFunc函数可以取消子进程及其子进程，移除父进程对子进程的引用，并停止所有相关的计时器。 如果调用CancelFunc失败，则会泄漏子进程及其子进程，直到父进程被取消或定时器触发。 go vet工具检查CancelFuncs是否在所有控制流路径上使用。</p></li>

<li><p>使用context的程序应该遵循以下规则来保持包之间的接口一致，并启用静态分析工具来检查context传播:</p></li>

<li><p>不要在结构类型中存储context; 相反，应该将Context显式地传递给需要它的每个函数。 Context应该是第一个参数，通常命名为ctx</p></li>

<li><p>不要传递nil Context，即使函数允许。通过context.TODO，如果您不确定使用哪个context。</p></li>

<li><p>仅对传递进程和api的请求作用域数据使用context值，而不要将可选参数传递给函数。</p></li>

<li><p>相同的Context可以传递给运行在不同goroutines中的函数;context被多个goroutines同时使用是安全的。</p></li>
</ul>

<h2>type</h2>

<blockquote>
<p>源码如下，解析思考直接写在里面</p>
</blockquote>

<pre><code class="language-go">type Context interface {
	// Deadline returns the time when work done on behalf of this context
	// should be canceled. Deadline returns ok==false when no deadline is
	// set. Successive calls to Deadline return the same results.
	Deadline() (deadline time.Time, ok bool)
	//返回自动关闭的截止时间，没有设置的话，ok==false
	
	// Done returns a channel that's closed when work done on behalf of this
	// context should be canceled. Done may return nil if this context can
	// never be canceled. Successive calls to Done return the same value.
	// The close of the Done channel may happen asynchronously,
	// after the cancel function returns.
	//
	// WithCancel arranges for Done to be closed when cancel is called;
	// WithDeadline arranges for Done to be closed when the deadline
	// expires; WithTimeout arranges for Done to be closed when the timeout
	// elapses.
	//
	// Done is provided for use in select statements:
	//
	//  // Stream generates values with DoSomething and sends them to out
	//  // until DoSomething returns an error or ctx.Done is closed.
	//  func Stream(ctx context.Context, out chan&lt;- Value) error {
	//  	for {
	//  		v, err := DoSomething(ctx)
	//  		if err != nil {
	//  			return err
	//  		}
	//  		select {
	//  		case &lt;-ctx.Done():
	//  			return ctx.Err()
	//  		case out &lt;- v:
	//  		}
	//  	}
	//  }
	//
	// See https://blog.golang.org/pipelines for more examples of how to use
	// a Done channel for cancellation.
	Done() &lt;-chan struct{}
	//简单来说就是如果该context取消了，就返回一个关着的通道，否则返回nil。表示 context 被取消的信号。
	//多用于select判定中，源码中举了例子。作用就是当关闭context时，同时把相关的goroutine返回，以释放资源

	// If Done is not yet closed, Err returns nil.
	// If Done is closed, Err returns a non-nil error explaining why:
	// Canceled if the context was canceled
	// or DeadlineExceeded if the context's deadline passed.
	// After Err returns a non-nil error, successive calls to Err return the same error.
	Err() error

	// Value returns the value associated with this context for key, or nil
	// if no value is associated with key. Successive calls to Value with
	// the same key returns the same result.
	//
	// Use context values only for request-scoped data that transits
	// processes and API boundaries, not for passing optional parameters to
	// functions.
	//
	// A key identifies a specific value in a Context. Functions that wish
	// to store values in Context typically allocate a key in a global
	// variable then use that key as the argument to context.WithValue and
	// Context.Value. A key can be any type that supports equality;
	// packages should define keys as an unexported type to avoid
	// collisions.
	//
	// Packages that define a Context key should provide type-safe accessors
	// for the values stored using that key:
	//
	// 	// Package user defines a User type that's stored in Contexts.
	// 	package user
	//
	// 	import &quot;context&quot;
	//
	// 	// User is the type of value stored in the Contexts.
	// 	type User struct {...}
	//
	// 	// key is an unexported type for keys defined in this package.
	// 	// This prevents collisions with keys defined in other packages.
	// 	type key int
	//
	// 	// userKey is the key for user.User values in Contexts. It is
	// 	// unexported; clients use user.NewContext and user.FromContext
	// 	// instead of using this key directly.
	// 	var userKey key
	//
	// 	// NewContext returns a new Context that carries value u.
	// 	func NewContext(ctx context.Context, u *User) context.Context {
	// 		return context.WithValue(ctx, userKey, u)
	// 	}
	//
	// 	// FromContext returns the User value stored in ctx, if any.
	// 	func FromContext(ctx context.Context) (*User, bool) {
	// 		u, ok := ctx.Value(userKey).(*User)//得用户值，直接可用
	// 		return u, ok
	// 	}
	Value(key interface{}) interface{}
	//用key查value，无则返回nil。
}
</code></pre>

<p>方法：
<code>func Background() Context</code>返回一个非nil，但空的context，一般就用来初始化，或者作为context根结点。
<code>func TODO() Context</code>返回一个非nil，但空的context。使用context.TODO当不清楚要使用哪个context或context还不可用时。
<code>func WithValue(parent Context, key, val interface{}) Context</code>返回的是原context的副本。参数一看就懂。官方文档推荐key不要使用字符串等内置类型，要自己定义。</p>

<h2>func</h2>

<blockquote>
<p>造新的context，与父context相同（这句话很不严谨，但我此时不好描述）</p>
</blockquote>

<p><code>func WithCancel(parent Context) (ctx Context, cancel CancelFunc)</code>WithCancel返回一个带有新的Done通道的父级副本。当返回的cancel函数被调用或父context的Done通道被关闭时，返回的context的Done通道被关闭，以先发生的方式为准。取消这个context会释放与它关联的资源，所以代码应该在这个context中运行的操作完成后立即调用cancel。
一句话：造新的context，并返回一个cancel让你随时可以取消。</p>

<pre><code class="language-go">ctx, cancel := context.WithCancel(context.Background())
defer cancel()
</code></pre>

<p><code>func WithDeadline(parent Context, d time.Time) (Context, CancelFunc)</code>WithDeadline返回父context的副本，其截止日期调整为不迟于d。如果父context的截止日期已经早于d，则WithDeadline(parent, d)在语义上等同于父context。当截止日期到期时，返回的context的Done通道被关闭，当返回的cancel函数被调用时，或者当父context的Done通道被关闭时，以先发生的方式为准。
一句话：造新的context，调整deadline不迟于d，只能往前调。原定父context五分钟后，子context可调整为三分钟后。
<code>func WithTimeout(parent Context, timeout time.Duration) (Context, CancelFunc)</code>WithTimeout returns WithDeadline(parent, time.Now().Add(timeout)).就是方便操作</p>

<h2>学习总结</h2>

<ul>
<li>首先明确context 几乎成为了go中 并发控制和超时控制的标准做法。</li>
<li>它是并发安全的</li>
<li>在不同调用函数中共享数据</li>
<li>取消goroutine主要方式select+Done()</li>
<li>防止 goroutine 泄漏,官方文档有例子</li>
<li>context 可能并不完美，但它确实简洁高效地解决了问题</li>
</ul>

<blockquote>
<h5>参考</h5>

<p>官方文档写得很清晰了
[讲的挺好的源码分析]（<a href="https://www.cnblogs.com/qcrao-2018/archive/2019/06/12/11007503.html）">https://www.cnblogs.com/qcrao-2018/archive/2019/06/12/11007503.html）</a>
五花八门的各种博客</p>
</blockquote>
