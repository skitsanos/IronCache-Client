/**
 * com.skitsanos.api.ironio.IronCache
 * @author Skitsanos (@skitsanos, http://skitsanos.com).
 * @version 1.0
 */
package com.skitsanos.api.ironio
{
	import com.adobe.net.URI;

	import flash.events.ErrorEvent;
	import flash.utils.ByteArray;

	import org.httpclient.HttpClient;
	import org.httpclient.events.HttpDataEvent;
	import org.httpclient.events.HttpStatusEvent;

	public class IronCache
	{
		public var projectId:String;
		public var token:String;

		public function IronCache(projectId:String = null, token:String = null)
		{
			if (projectId != null && token != null)
			{
				this.projectId = projectId;
				this.token = token;
			}
		}

		/**
		 * Build IronCache URL
		 * @return
		 */
		private function getUrl():String
		{
			//http://cache-aws-us-east-1.iron.io/1/projects/51de78455de93824ff00000c/caches?oauth=C5HhOgghkAaxRp-U_bgpKRNM3Ko
			var url:String = 'http://cache-aws-us-east-1.iron.io/1/projects/' + projectId + '/caches';
			return url;
		}

		/**
		 * Performs HTTP REST API call to Iron.IO Caches
		 * @param url API end point
		 * @param method HTTP method for the call
		 * @param data
		 * @param handler
		 */
		private function execute(url:String, method:String, data:String, handler:Function):void
		{
			trace(url);

			var client:HttpClient = new HttpClient();

			client.listener.onStatus = function (e:HttpStatusEvent):void
			{
				trace(e.code + ': ' + e.response.message);
			};

			client.listener.onError = function (e:ErrorEvent):void
			{
				handler({type: 'error', message: e.text});
			};

			client.listener.onData = function (e:HttpDataEvent):void
			{
				handler({type: 'result', message: JSON.parse(e.readUTFBytes())});
			};

			var jsonData:ByteArray = new ByteArray();

			switch (method.toLowerCase())
			{
				case 'get':
					client.get(new URI(url));
					break;

				case 'post':
					jsonData.writeUTFBytes(data);
					jsonData.position = 0;
					client.post(new URI(url), jsonData, 'application/json');
					break;

				case 'put':
					jsonData.writeUTFBytes(data);
					jsonData.position = 0;
					client.put(new URI(url), jsonData, 'application/json');
					break;

				case 'delete':
					client.del(new URI(url));
					break;
			}
		}

		/**
		 * Get a list of all caches in a project. 100 caches are listed at a time.
		 * @param name
		 * @param handler
		 */
		public function caches(name:String, handler:Function):void
		{
			var url:String = getUrl() + '/' + name + '?oauth=' + token;

			execute(url, 'GET', null, handler);
		}

		/**
		 * Delete all items in a cache. This cannot be undone.
		 * @param name The name of the cache whose items should be cleared.
		 * @param handler
		 */
		public function clear(name:String, handler:Function):void
		{
			var url:String = getUrl() + '/' + name + '/clear?oauth=' + token;

			execute(url, 'POST', '', handler);
		}

		/**
		 * This call puts an item into a cache.
		 * @param name The name of the cache. If the cache does not exist, it will be created for you.
		 * @param key  The key to store the item under in the cache.
		 * @param value
		 * @param handler
		 */
		public function put(name:String, key:String, value:*, handler:Function):void
		{
			var url:String = getUrl() + '/' + name + '/items/' + key + '?oauth=' + token;

			execute(url, 'PUT', JSON.stringify({value: value}), handler);
		}

		/**
		 * This call retrieves an item from the cache. The item will not be deleted.
		 * @param name The name of the cache the item belongs to.
		 * @param key The key the item is stored under in the cache.
		 * @param handler
		 */
		public function get(name:String, key:String, handler:Function):void
		{
			var url:String = getUrl() + '/' + name + '/items/' + key + '?oauth=' + token;

			execute(url, 'GET', '', handler);
		}

		/**
		 * This call increments the numeric value of an item in the cache. The amount must be a number and attempting
		 * to increment non-numeric values results in an error. Negative amounts may be passed to decrement the value.
		 * The increment is atomic, so concurrent increments will all be observed.
		 * @param name The name of the cache. If the cache does not exist, it will be created for you.
		 * @param key  The key of the item to increment.
		 * @param amount The amount to increment the value, as an integer. If negative, the value will be decremented.
		 * @param handler
		 */
		public function increment(name:String, key:String, amount:int, handler:Function):void
		{
			var url:String = getUrl() + '/' + name + '/items/' + key + '/increment?oauth=' + token;

			execute(url, 'POST', JSON.stringify({amount: amount}), handler);
		}

		/**
		 * This call will delete the item from the cache.
		 * @param name The name of the cache the item belongs to.
		 * @param key The key the item is stored under in the cache.
		 * @param handler
		 */
		public function remove(name:String, key:String, handler:Function):void
		{
			var url:String = getUrl() + '/' + name + '/items/' + key + '?oauth=' + token;

			execute(url, 'DELETE', '', handler);
		}
	}
}
