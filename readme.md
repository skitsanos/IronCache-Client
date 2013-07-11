IronCache API Client for ActionScript 3.0
---

**Usage:**

Create IronCache client instance

```
private var caches:IronCache = new IronCache('project_id', 'token');
```

List caches

```
caches.caches('myapp', function (data:*):void
			{
				log.text = JSON.stringify(data);
			});
```

Clear caches

```
caches.clear('myapp', function (data:*):void
			{
				log.text = JSON.stringify(data);
			});
```

Put value into a cache

```
caches.put('myapp', 'transport-orders.counter', 1, function (data:*):void
			{
				log.text = JSON.stringify(data);
			});
```

Increment value

```
caches.increment('smartcontainers', 'transport-orders.counter', 1, function (data:*):void
			{
				log.text = JSON.stringify(data);
			});
```

**References**

+ [IronCache Documentation](http://dev.iron.io/cache/)