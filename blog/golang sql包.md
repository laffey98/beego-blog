# golang sql包
> <https://pkg.go.dev/database/sql>

## 简介
sql包提供了一个使用sql语言数据库的通用接口，go标准库中没有驱动。实际上想要链接数据库，还需要特定的驱动。

## 类型及方法
> 按官方文档顺序
>
> （写给自己）先DB，row，tx，Conn，之后其他

### ColumnType（可以称作列，字段，属性等） 
- `func (ci *ColumnType) DatabaseTypeName() string`return the database system name of the column type。比如"VARCHAR", "TEXT", "NVARCHAR", "DECIMAL", "BOOL", "INT", and "BIGINT".如为空，则是驱动不支持。
- `func (ci *ColumnType) DecimalSize() (precision, scale int64, ok bool)`返回十进制类型的刻度和精度。如果不适用或不支持ok为false.
- `func (ci *ColumnType) Length() (length int64, ok bool)`返回可变长度列类型(如文本和二进制字段类型)的列类型长度。如果类型长度无界，则值为math。MaxInt64(仍然适用任何数据库限制)。如果列类型不是可变长度的，比如int，或者如果驱动不支持ok则为false。
- `func (ci *ColumnType) Name() string`返回列的名称或别名。
- `func (ci *ColumnType) Nullable() (nullable, ok bool)`列是否为空。如果驱动程序不支持这个属性ok将为false
- `func (ci *ColumnType) ScanType() reflect.Type`返回适合使用Rows.Scan进行扫描的Go类型。如果驱动不支持此属性，ScanType将返回空接口的类型。
### Conn（连接）
- Conn表示单个数据库连接，而不是数据库连接池。
- 最好是从DB运行查询，除非有一个连续的单个数据库连接的特定需要。
- Conn必须调用Close来返回到数据库池的连接，并且可以与正在运行的查询同时执行。
- `func (c *Conn) BeginTx(ctx context.Context, opts *TxOptions) (*Tx, error)`启动一个事务。在事务提交或回滚之前，将使用所提供的上下文。如果上下文被取消，将回滚事务，Tx.Commit将返回一个错误。提供的TxOptions是可选的，如果应该使用默认值，可以为nil。
- `func (c *Conn) Close() error`Close将连接返回到连接池。Close之后的所有操作将返回ErrConnDone。与其他操作同时调用Close是安全的，它将阻塞直到所有其他操作完成。可以取消任何使用的上下文，然后直接调用close
- `func (c *Conn) ExecContext(ctx context.Context, query string, args ...interface{}) (Result, error)`ExecContext执行查询而不返回任何行。这些参数用于查询中的任何占位符参数
- `func (c *Conn) PingContext(ctx context.Context) error`PingContext验证与数据库的连接是否仍然存在。
- `func (c *Conn) PrepareContext(ctx context.Context, query string) (*Stmt, error)`PrepareContext为以后的查询或执行创建一个准备好的语句。当不再需要该语句时，调用者必须调用该语句的Close方法。所提供的上下文用于语句的准备，而不是语句的执行。
- `func (c *Conn) QueryContext(ctx context.Context, query string, args ...interface{}) (*Rows, error)`QueryContext执行一个(通常是SELECT)查询。args参数用于查询中的任何占位符参数。
- `func (c *Conn) QueryRowContext(ctx context.Context, query string, args ...interface{}) *Row`QueryRowContext执行一个最多返回一行的查询。QueryRowContext总是返回一个非nil值。如果查询没有选择行，则Row的Scan将返回ErrNoRows。否则，Row的Scan将扫描第一个选中的行并丢弃其余的行。
### DB（重中之重）
- DB是一个数据库句柄，表示一个由零个或多个底层连接组成的连接池。它对于多个goroutines的并发使用是安全的。
- sql包自动创建和释放连接;它还维护一个空闲连接的空闲池。如果数据库有每个连接状态的概念，那么可以在事务(Tx)或连接(Conn)中可靠地观察到这种状态。
- 一旦数据库调用Begin时，返回的Tx被绑定到单个连接。
- 一旦在事务上调用提交或回滚，该事务的连接将返回到DB的空闲连接池。
- 池的大小可以通过SetMaxIdleConns来控制。
- `func Open(driverName, dataSourceName string) (*DB, error)`Open打开由数据库驱动程序名称和驱动程序特定数据源名称指定的数据库。Open只验证其参数，而不创建到数据库的连接。要验证数据源名称是否有效，请调用Ping。返回的DB对于多个goroutines的并发使用是安全的，它维护自己的空闲连接池。因此，Open函数应该只调用一次。很少有必要关闭数据库。
- `func OpenDB(c driver.Connector) *DB`OpenDB使用连接器打开数据库，允许驱动程序绕过基于字符串的数据源名称。只验证其参数，而不创建到数据库的连接。要验证数据源名称是否有效，请调用Ping。返回的DB对于多个goroutines的并发使用是安全的，它维护自己的空闲连接池。因此，Open函数应该只调用一次。很少有必要关闭数据库。
- `func (db *DB) Begin() (*Tx, error)`Begin启动一个事务。默认的隔离级别取决于驱动程序。在内部使用 context.Background
- `func (db *DB) BeginTx(ctx context.Context, opts *TxOptions) (*Tx, error)`BeginTx启动一个事务。在事务提交或回滚之前，将使用所提供的上下文。如果上下文被取消，将回滚事务，Tx.Commit将返回一个错误。提供的TxOptions是可选的，如果应该使用默认值，可以为nil。参考上面一条，显性指定context
- `func (db *DB) Close() error`Close关闭数据库并阻止启动新的查询。关闭，然后等待服务器上已经开始处理的所有查询完成。很少关闭一个DB，因为DB句柄意味着它是长期存在的，并且在许多goroutines之间共享。
- `func (db *DB) Conn(ctx context.Context) (*Conn, error)`Conn通过打开一个新连接或从连接池返回一个现有连接来返回单个连接。Conn将阻塞，直到一个连接被返回或ctx被取消。在相同Conn上运行的查询将在相同的数据库会话中运行。每个Conn在使用后必须通过调用Conn. close返回到数据库池
- `func (db *DB) Driver() driver.Driver`Driver返回数据库的底层驱动。
- `func (db *DB) Exec(query string, args ...interface{}) (Result, error)`Exec执行查询而不返回任何行。arg参数用于查询中的任何占位符参数。Exec在内部使用 context.Background
- `func (db *DB) ExecContext(ctx context.Context, query string, args ...interface{}) (Result, error)`参考上面一条，显性指定context
- `func (db *DB) Ping() error`Ping 验证与数据库的连接是否仍然存在，必要时建立连接。 Ping 在内部使用 context.Background
- `func (db *DB) PingContext(ctx context.Context) error`参考上面一条，显性指定context
- `func (db *DB) Prepare(query string) (*Stmt, error)`Prepare 为以后的查询或执行创建准备好的语句。当不再需要该语句时，调用者必须调用该语句的 Close 方法。 Prepare 在内部使用 context.Background
- `func (db *DB) PrepareContext(ctx context.Context, query string) (*Stmt, error)`参考上面一条，显性指定context
- `func (db *DB) Query(query string, args ...interface{}) (*Rows, error)`Query 执行返回行的查询，通常是 SELECT。 args 用于查询中的任何占位符参数。 在内部使用 context.Background
- `func (db *DB) QueryContext(ctx context.Context, query string, args ...interface{}) (*Rows, error)`参考上面一条，显性指定context
- `func (db *DB) QueryRow(query string, args ...interface{}) *Row`QueryRow 执行预期最多返回一行的查询。 QueryRow 总是返回一个非零值。错误会延迟到调用 Row 的 Scan 方法。如果查询未选择任何行，Row 的 Scan 将返回 ErrNoRows。否则，Row's Scan 会扫描第一个选定的行并丢弃其余行。
- `func (db *DB) QueryRowContext(ctx context.Context, query string, args ...interface{}) *Row`参考上面一条，显性指定context
- `func (db *DB) SetConnMaxIdleTime(d time.Duration)`SetConnMaxIdleTime 设置连接可能处于空闲状态的最长时间。 过期的连接可能会在重用之前延迟关闭。 如果 d <= 0，则连接不会由于连接的空闲时间而关闭。
- `func (db *DB) SetConnMaxLifetime(d time.Duration)`SetConnMaxLifetime 设置连接可以重用的最长时间。 过期的连接可能会在重用之前延迟关闭。 如果 d <= 0，则连接不会由于连接的时间而关闭。
- `func (db *DB) SetMaxIdleConns(n int)`SetMaxIdleConns 设置空闲连接池的最大连接数。 如果 MaxOpenConns 大于 0 但小于新的 MaxIdleConns，则新的 MaxIdleConns 将减少以匹配 MaxOpenConns 限制。 如果 n <= 0，则不保留任何空闲连接。 当前的默认最大空闲连接数为 2。
- `func (db *DB) SetMaxOpenConns(n int)`SetMaxOpenConns 设置与数据库的最大打开连接数。 如果 MaxIdleConns 大于 0 并且新的 MaxOpenConns 小于 MaxIdleConns，则 MaxIdleConns 将减少以匹配新的 MaxOpenConns 限制。 如果 n <= 0，则对打开的连接数没有限制。默认值为 0（无限制）。
- `func (db *DB) Stats() DBStats`Stats返回数据库统计信息。
### DBStats
DBStats 包含数据库统计信息
```go
//源码如下（很明显，不用翻译了）
type DBStats struct {
	MaxOpenConnections int // Maximum number of open connections to the database.

	// Pool Status
	OpenConnections int // The number of established connections both in use and idle.
	InUse           int // The number of connections currently in use.
	Idle            int // The number of idle connections.

	// Counters
	WaitCount         int64         // The total number of connections waited for.
	WaitDuration      time.Duration // The total time blocked waiting for a new connection.
	MaxIdleClosed     int64         // The total number of connections closed due to SetMaxIdleConns.
	MaxIdleTimeClosed int64         // The total number of connections closed due to SetConnMaxIdleTime.
	MaxLifetimeClosed int64         // The total number of connections closed due to SetConnMaxLifetime.
}
```
### IsolationLevel（int）
IsolationLevel 是 TxOptions 中使用的事务隔离级别。
驱动程序可能在 BeginTx 中支持的各种隔离级别。如果驱动程序不支持给定的隔离级别，则可能会返回错误
```go
const (
	LevelDefault IsolationLevel = iota
	LevelReadUncommitted
	LevelReadCommitted
	LevelWriteCommitted
	LevelRepeatableRead
	LevelSnapshot
	LevelSerializable
	LevelLinearizable
)
```
- `func (i IsolationLevel) String() string`String 返回事务隔离级别的名称

### NamedArg
NamedArg 是一个命名参数。 NamedArg 值可用作 Query 或 Exec 的参数，并绑定到 SQL 语句中相应的命名参数。
`func Named(name string, value interface{}) NamedArg`Named 提供了一种更简洁的方式来创建 NamedArg 值
```go
//文字不好理解，源码加例子，就不用解释太多了
//源码如下
type NamedArg struct {

	// Name is the name of the parameter placeholder.
	//
	// If empty, the ordinal position in the argument list will be
	// used.
	//
	// Name must omit any symbol prefix.
	Name string

	// Value is the value of the parameter.
	// It may be assigned the same value types as the query
	// arguments.
	Value interface{}
	// contains filtered or unexported fields
}

//例子如下
db.ExecContext(ctx, `
    delete from Invoice
    where
        TimeCreated < @end
        and TimeCreated >= @start;`,
    sql.Named("start", startTime),
    sql.Named("end", endTime),
)
```

### Result
Result 总结了一个已执行的 SQL 命令
```go
//源码如下
type Result interface {
	// LastInsertId returns the integer generated by the database
	// in response to a command. Typically this will be from an
	// "auto increment" column when inserting a new row. Not all
	// databases support this feature, and the syntax of such
	// statements varies.
	//简单来说，就是插入的行数
	LastInsertId() (int64, error)

	// RowsAffected returns the number of rows affected by an
	// update, insert, or delete. Not every database or database
	// driver may support this.
	//简单来说，就是这次命令影响的行数
	RowsAffected() (int64, error)
}
```
### Row
Row 是调用 QueryRow 以选择单行的结果。
`func (r *Row) Err() error`Err 提供了一种包装包的方法，可以在不调用 Scan 的情况下检查查询错误。 Err 返回运行查询时遇到的错误（如果有）。如果此错误不为零，则 Scan 也会返回此错误。
`func (r *Row) Scan(dest ...interface{}) error`Scan 将匹配行中的列复制到 dest 指向的值中。有关详细信息，请参阅有关 Rows.Scan 的文档。如果多行与查询匹配，则 Scan 使用第一行并丢弃其余行。如果没有行匹配查询，Scan 返回 ErrNoRows。
### Rows
Rows是查询的结果。它的光标在结果集的第一行之前开始。使用 Next 逐行前进
- `func (rs *Rows) Close() error`Close 关闭Rows，防止进一步枚举。如果调用 Next 并返回 false 并且没有进一步的结果集，则 Rows 将自动关闭，并足以检查 Err 的结果。 Close 是幂等的，不会影响 Err 的结果。
- `func (rs *Rows) ColumnTypes() ([]*ColumnType, error)`ColumnTypes 返回列类型、长度和可为空的列信息。某些驱动程序可能无法提供某些信息。
- `func (rs *Rows) Columns() ([]string, error)`Columns 返回列名。如果行已关闭，列将返回错误。
- `func (rs *Rows) Err() error`Err 返回迭代期间遇到的错误（如果有）。 Err 可以在显式或隐式关闭后调用。
- `func (rs *Rows) Next() bool`Next 准备下一个结果行以使用 Scan 方法读取。成功时返回 true，如果没有下一个结果行或在准备时发生错误，则返回 false。应使用 Err 以区分这两种情况。 每次调用 Scan，甚至是第一次调用，都必须在调用 Next 之前。
- `func (rs *Rows) Scan(dest ...interface{}) error`Scan 将当前行中的列复制到 dest 指向的值中。 dest 中的值数必须与 Rows 中的列数相同。Scan 还会在字符串和数字类型之间进行转换。例如，值为 300 的 float64 或值为“300”的字符串可以扫描成uint16类型
### Stmt
- Stmt 是一个准备好的语句。 Stmt 对于多个 goroutine 并发使用是安全的
- 如果在 Tx 或 Conn 上准备了 Stmt，它将永远绑定到单个底层连接。如果 Tx 或 Conn 关闭，Stmt 将变得不可用，所有操作都将返回错误。如果在 DB 上准备了 Stmt，它将在 DB 的生命周期内保持可用。当 Stmt 需要在新的底层连接上执行时，它会自动在新的连接上进行准备。
- `func (s *Stmt) Close() error`关闭
- `func (s *Stmt) Exec(args ...interface{}) (Result, error)`Exec 使用给定的参数执行准备好的语句，并返回总结语句效果的 Result。 Exec 在内部使用 context.Background
- `func (s *Stmt) ExecContext(ctx context.Context, args ...interface{}) (Result, error)`参考上面一条，显性指定context
- `func (s *Stmt) Query(args ...interface{}) (*Rows, error)`Query 使用给定的参数执行准备好的查询语句，并将查询结果作为 Rows 返回。 查询在内部使用 context.Background
- `func (s *Stmt) QueryContext(ctx context.Context, args ...interface{}) (*Rows, error)`参考上面一条，显性指定context
- `func (s *Stmt) QueryRow(args ...interface{}) *Row`QueryRow 使用给定的参数执行准备好的查询语句。如果在语句执行期间发生错误，则该错误将通过对返回的 Row 调用 Scan 来返回，该Row 始终为非零。如果查询未选择任何行，Row 的 Scan 将返回 ErrNoRows。否则，Row's Scan 会扫描第一个选定的行并丢弃其余行。QueryRow 在内部使用 context.Background
- `func (s *Stmt) QueryRowContext(ctx context.Context, args ...interface{}) *Row`参考上面一条，显性指定context
### Tx
Tx 是一个进行中的数据库事务。 事务必须以调用 Commit 或 Rollback 结束。 在调用 Commit 或 Rollback 后，事务上的所有操作都会失败并显示 ErrTxDone。 通过调用事务的 Prepare 或 Stmt 方法为事务准备的语句通过调用 Commit 或 Rollback 关闭。
-  `func (tx *Tx) Commit() error`提交事务
-  `func (tx *Tx) Exec(query string, args ...interface{}) (Result, error)`Exec 执行不返回行的查询。例如：一个 INSERT 和 UPDATE。 Exec 在内部使用 context.Background
-  `func (tx *Tx) ExecContext(ctx context.Context, query string, args ...interface{}) (Result, error)`参考上面一条，显性指定context
-  `func (tx *Tx) Prepare(query string) (*Stmt, error)`Prepare 创建一个准备好的语句以在事务中使用。 返回的语句在事务中运行，一旦事务提交或回滚就不能再使用。 要在此事务上使用现有的准备好的语句，请参阅 Tx.Stmt。 Prepare 在内部使用 context.Background
-  `func (tx *Tx) PrepareContext(ctx context.Context, query string) (*Stmt, error)`参考上面一条，显性指定context
-  `func (tx *Tx) Query(query string, args ...interface{}) (*Rows, error)`Query 执行返回行的查询，通常是 SELECT。 查询在内部使用 context.Background
-  `func (tx *Tx) QueryContext(ctx context.Context, query string, args ...interface{}) (*Rows, error)`参考上面一条，显性指定context
-  `func (tx *Tx) QueryRow(query string, args ...interface{}) *Row`类似的东西，不解释了hhhhhh
-  `func (tx *Tx) QueryRowContext(ctx context.Context, query string, args ...interface{}) *Row`参考上面一条，显性指定context
-  `func (tx *Tx) Rollback() error`回滚
-  `func (tx *Tx) Stmt(stmt *Stmt) *Stmt`Stmt 从现有语句返回特定于事务的预准备语句。Stmt 在内部使用 context.Background
-  `func (tx *Tx) StmtContext(ctx context.Context, stmt *Stmt) *Stmt`参考上面一条，显性指定context
### TxOptions
TxOptions 保存要在 DB.BeginTx 中使用的事务选项。
```go
type TxOptions struct {
	// Isolation is the transaction isolation level.事务隔离级别。
	// If zero, the driver or database's default level is used.
	//如果为零，则使用驱动程序或数据库的默认级别。
	Isolation IsolationLevel
	ReadOnly  bool
}
```

> ##### 参考
> 官方文档<https://pkg.go.dev/database/sql>
> <https://www.cnblogs.com/lanyangsh/p/13912249.html> 简要介绍go-sql-driver的调如何与database/sql关联起来的，包括从驱动注册到具体查询，每个步骤的底层调用。涉及sql/drive包。
> 许多博客，主要是看实例
