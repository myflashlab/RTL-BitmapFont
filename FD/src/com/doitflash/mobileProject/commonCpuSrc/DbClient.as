package com.doitflash.mobileProject.commonCpuSrc
{
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.data.SQLResult;
	import flash.events.EventDispatcher;
	import flash.events.SQLEvent;
	import flash.events.SQLErrorEvent;
	import flash.filesystem.File;
	import flash.net.Responder;
	import flash.utils.ByteArray;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 3/18/2012 8:21 PM
	 */
	public class DbClient extends EventDispatcher 
	{
		protected static var _db:DbClient = new DbClient();
		protected static var _data:Object;
		
		protected var _dbFile:File;
		protected var _sqlConn:SQLConnection;
		
		protected var _sqlStmt:SQLStatement;
		protected var _sqlStr:String;
		
		protected static function connect():Boolean
		{
			if (_db._sqlConn && _db._sqlConn.connected) return false;
			
			toResolvePath();
			
			_db._sqlConn = new SQLConnection();
			_db._sqlConn.open(_db._dbFile);
			
			// create table: pages
			_db._sqlStmt = new SQLStatement();
			_db._sqlStr =	"	CREATE TABLE IF NOT EXISTS pages (" +
							"	id INTEGER, " + 
							"	type TEXT, " +
							"	localDb TEXT, " +
							"	name TEXT, " +
							"	icon TEXT, " +
							"	content BLOB, " +
							"	itemOrder INTEGER, " +
							"	itemActive INTEGER, " +
							"	itemAdd TEXT, " +
							"	itemLastUpdate TEXT, " +
							"	updateId TEXT " +
							"	); ";
						
			_db._sqlStmt.sqlConnection = _db._sqlConn;
			_db._sqlStmt.text = _db._sqlStr;
			_db._sqlStmt.execute();
			
			// create table: header
			_db._sqlStmt = new SQLStatement();
			_db._sqlStr =	"	CREATE TABLE IF NOT EXISTS header (" +
							"	content BLOB, " +
							"	updateId TEXT " +
							")";
						
			_db._sqlStmt.sqlConnection = _db._sqlConn;
			_db._sqlStmt.text = _db._sqlStr;
			_db._sqlStmt.execute();
			
			// create table: footer
			_db._sqlStmt = new SQLStatement();
			_db._sqlStr =	"	CREATE TABLE IF NOT EXISTS footer (" +
							"	content BLOB, " +
							"	updateId TEXT " +
							")";
						
			_db._sqlStmt.sqlConnection = _db._sqlConn;
			_db._sqlStmt.text = _db._sqlStr;
			_db._sqlStmt.execute();
			
			// create table: forces
			_db._sqlStmt = new SQLStatement();
			_db._sqlStr =	"	CREATE TABLE IF NOT EXISTS forces (" +
							"	imagesUpdateId TEXT, " +
							"	allUpdateId TEXT " +
							")";
						
			_db._sqlStmt.sqlConnection = _db._sqlConn;
			_db._sqlStmt.text = _db._sqlStr;
			_db._sqlStmt.execute();
			
			// create table: media
			_db._sqlStmt = new SQLStatement();
			_db._sqlStr =	"	CREATE TABLE IF NOT EXISTS media (" +
							"	url TEXT, " +
							"	bytes BLOB " +
							")";
							
			_db._sqlStmt.sqlConnection = _db._sqlConn;
			_db._sqlStmt.text = _db._sqlStr;
			_db._sqlStmt.execute();
			
			/*// create table: manifest
			_db._sqlStmt = new SQLStatement();
			_db._sqlStr =	"	CREATE TABLE IF NOT EXISTS manifest (" +
							"	appName TEXT, " +
							"	appID TEXT, " +
							"	appVersion TEXT, " +
							"	googlePlay TEXT, " +
							"	apk TEXT, " +
							"	lastCompile TEXT " +
							")";
						
			_db._sqlStmt.sqlConnection = _db._sqlConn;
			_db._sqlStmt.text = _db._sqlStr;
			_db._sqlStmt.execute();*/
			
			
			return true;
		}
		
		protected static function toResolvePath():void
		{
			if (_data && _data.dbPath && _data.dbName)
			{
				_db._dbFile = File.documentsDirectory.resolvePath(_data.dbPath);
				_db._dbFile.createDirectory();
				_db._dbFile = File.documentsDirectory.resolvePath(_data.dbPath + "/" + _data.dbName);
			}
			else
			{
				_db._dbFile = File.applicationStorageDirectory.resolvePath("app.db");
			}
		}
		
		/*public static function saveManifest($obj:Object):void
		{
			DbClient.connect();
			
			// delete any old data from db
			_db._sqlStmt = new SQLStatement();
			_db._sqlStr = 	" 	DELETE FROM manifest ";
			_db._sqlStmt.sqlConnection = _db._sqlConn;
			_db._sqlStmt.text = _db._sqlStr;
			_db._sqlStmt.execute();
			
			// save new data into db
			_db._sqlStmt = new SQLStatement();
			_db._sqlStr =	"	INSERT INTO manifest (appName, appID, appVersion, googlePlay, apk, lastCompile) " +
							"	VALUES ('" + $obj.appName + "', " +
							"	'" + $obj.appID + "', " +
							"	'" + $obj.appVersion + "', " +
							"	'" + $obj.googlePlay + "', " +
							"	'" + $obj.apk + "', " +
							"	'" + $obj.lastCompile + "'" +
							"	)";
			_db._sqlStmt.sqlConnection = _db._sqlConn;
			_db._sqlStmt.text = _db._sqlStr;
			_db._sqlStmt.execute();
		}
		
		public static function getManifest():Array
		{
			DbClient.connect();
			var result:Array;
			
			_db._sqlStmt = new SQLStatement();
			_db._sqlStr =	" 	SELECT * FROM manifest LIMIT 1";
			_db._sqlStmt.sqlConnection = _db._sqlConn;
			_db._sqlStmt.text = _db._sqlStr;
			_db._sqlStmt.execute( -1, new Responder(onResult, null));
			
			function onResult($result:SQLResult):void
			{
				result = $result.data;
			}
			
			return result;
		}*/
		
		public static function saveHeader($obj:Object):void
		{
			DbClient.connect();
			
			// delete any old data from db
			_db._sqlStmt = new SQLStatement();
			_db._sqlStr = 	" 	DELETE FROM header ";
			_db._sqlStmt.sqlConnection = _db._sqlConn;
			_db._sqlStmt.text = _db._sqlStr;
			_db._sqlStmt.execute();
			
			// save new data into db
			_db._sqlStmt = new SQLStatement();
			_db._sqlStr =	"	INSERT INTO  header (content, updateId) " +
							"	VALUES ('" + $obj.content + "', " +
							"	'" + $obj.updateId + "'" +
							"	)";
			_db._sqlStmt.sqlConnection = _db._sqlConn;
			_db._sqlStmt.text = _db._sqlStr;
			_db._sqlStmt.execute();
		}
		
		public static function saveFooter($obj:Object):void
		{
			DbClient.connect();
			
			// delete any old data from db
			_db._sqlStmt = new SQLStatement();
			_db._sqlStr = 	" 	DELETE FROM footer ";
			_db._sqlStmt.sqlConnection = _db._sqlConn;
			_db._sqlStmt.text = _db._sqlStr;
			_db._sqlStmt.execute();
			
			// save new data into db
			_db._sqlStmt = new SQLStatement();
			_db._sqlStr =	"	INSERT INTO footer (content, updateId) " +
							"	VALUES ('" + $obj.content + "', " +
							"	'" + $obj.updateId + "'" +
							"	)";
			_db._sqlStmt.sqlConnection = _db._sqlConn;
			_db._sqlStmt.text = _db._sqlStr;
			_db._sqlStmt.execute();
		}
		
		public static function savePages($arr:Array):void
		{
			DbClient.connect();
			
			for (var i:int = 0; i < $arr.length; i++) 
			{
				var $obj:Object = $arr[i];
				
				// delete the old data from db
				_db._sqlStmt = new SQLStatement();
				_db._sqlStr = 	" 	DELETE FROM pages WHERE id='" + $obj.id + "'";
				_db._sqlStmt.sqlConnection = _db._sqlConn;
				_db._sqlStmt.text = _db._sqlStr;
				_db._sqlStmt.execute();
				
				// save new data into db
				_db._sqlStmt = new SQLStatement();
				_db._sqlStr =	"	INSERT INTO pages (id, type, localDb, name, icon, itemOrder, updateId) " +
								"	VALUES ('" + $obj.id + "', " +
								"	'" + $obj.type + "', " +
								"	'" + $obj.localDb + "', " +
								"	'" + $obj.name + "', " +
								"	'" + $obj.icon + "', " +
								"	'" + $obj.itemOrder + "', " +
								"	'" + $obj.updateId + "'" +
								"	)";
				_db._sqlStmt.sqlConnection = _db._sqlConn;
				_db._sqlStmt.text = _db._sqlStr;
				_db._sqlStmt.execute();
			}
			
		}
		
		public static function savePageContent($obj:Object):void
		{
			DbClient.connect();
			
			// save new data into db
			_db._sqlStmt = new SQLStatement();
			_db._sqlStr =	"	UPDATE pages SET " +
							"	content='" + $obj.content + "'" +
							" 	WHERE id='" + $obj.id + "'";
			_db._sqlStmt.sqlConnection = _db._sqlConn;
			_db._sqlStmt.text = _db._sqlStr;
			_db._sqlStmt.execute();
		}
		
		public static function saveBytes($url:String, $bytes:ByteArray):void
		{
			DbClient.connect();
			
			// check if this $url record exists already? delete it if so.
			_db._sqlStmt = new SQLStatement();
			_db._sqlStr = 	" 	DELETE FROM media WHERE url='" + $url + "'";
			_db._sqlStmt.sqlConnection = _db._sqlConn;
			_db._sqlStmt.text = _db._sqlStr;
			_db._sqlStmt.execute();
			
			// save the new bytes in a new record
			_db._sqlStmt = new SQLStatement();
			_db._sqlStr =	"	INSERT INTO media (url, bytes) " +
							"	VALUES (:theUrl, :theBytes)";
			
			_db._sqlStmt.sqlConnection = _db._sqlConn;
			_db._sqlStmt.text = _db._sqlStr;
			_db._sqlStmt.parameters[":theUrl"] = $url;
			_db._sqlStmt.parameters[":theBytes"] = $bytes;
			_db._sqlStmt.execute();
		}
		
		public static function getBytes($url:String):ByteArray
		{
			DbClient.connect();
			var result:ByteArray;
			
			_db._sqlStmt = new SQLStatement();
			_db._sqlStr =	" 	SELECT bytes FROM media WHERE url='" + $url + "' LIMIT 1";
			_db._sqlStmt.sqlConnection = _db._sqlConn;
			_db._sqlStmt.text = _db._sqlStr;
			_db._sqlStmt.execute( -1, new Responder(onResult, null));
			
			function onResult($result:SQLResult):void
			{
				if ($result.data)
				{
					result = $result.data[0].bytes;
				}
			}
			
			return result;
		}
		
		public static function getHeader():Array
		{
			DbClient.connect();
			var result:Array;
			
			_db._sqlStmt = new SQLStatement();
			_db._sqlStr =	" 	SELECT * FROM header LIMIT 1";
			_db._sqlStmt.sqlConnection = _db._sqlConn;
			_db._sqlStmt.text = _db._sqlStr;
			_db._sqlStmt.execute( -1, new Responder(onResult, null));
			
			function onResult($result:SQLResult):void
			{
				result = $result.data;
			}
			
			return result;
		}
		
		public static function getFooter():Array
		{
			DbClient.connect();
			var result:Array;
			
			_db._sqlStmt = new SQLStatement();
			_db._sqlStr =	" 	SELECT * FROM footer LIMIT 1";
			_db._sqlStmt.sqlConnection = _db._sqlConn;
			_db._sqlStmt.text = _db._sqlStr;
			_db._sqlStmt.execute( -1, new Responder(onResult, null));
			
			function onResult($result:SQLResult):void
			{
				result = $result.data;
			}
			
			return result;
		}
		
		public static function getPages():Array
		{
			DbClient.connect();
			var result:Array;
			
			_db._sqlStmt = new SQLStatement();
			_db._sqlStr =	" 	SELECT * FROM pages ORDER BY itemOrder ASC";
			_db._sqlStmt.sqlConnection = _db._sqlConn;
			_db._sqlStmt.text = _db._sqlStr;
			_db._sqlStmt.execute( -1, new Responder(onResult, null));
			
			function onResult($result:SQLResult):void
			{
				result = $result.data;
			}
			
			return result;
		}
		
		public static function getPageContent($pageId:int):Array
		{
			DbClient.connect();
			var result:Array;
			
			_db._sqlStmt = new SQLStatement();
			_db._sqlStr =	" 	SELECT id,type,localDb,content FROM pages WHERE id='" + $pageId +"' LIMIT 1";
			_db._sqlStmt.sqlConnection = _db._sqlConn;
			_db._sqlStmt.text = _db._sqlStr;
			_db._sqlStmt.execute( -1, new Responder(onResult, null));
			
			function onResult($result:SQLResult):void
			{
				result = $result.data;
			}
			
			return result;
		}
		
		public static function getHeaderUpdateId():Number
		{
			DbClient.connect();
			var result:Number = 0;
			
			_db._sqlStmt = new SQLStatement();
			_db._sqlStr =	" 	SELECT updateId FROM header LIMIT 1";
			_db._sqlStmt.sqlConnection = _db._sqlConn;
			_db._sqlStmt.text = _db._sqlStr;
			_db._sqlStmt.execute(-1, new Responder(onResult, null));
			
			function onResult($result:SQLResult):void
			{
				if ($result.data)
				{
					result = $result.data[0].updateId;
				}
			}
			
			return result;
		}
		
		public static function getFooterUpdateId():Number
		{
			DbClient.connect();
			var result:Number = 0;
			
			_db._sqlStmt = new SQLStatement();
			_db._sqlStr =	" 	SELECT updateId FROM footer LIMIT 1";
			_db._sqlStmt.sqlConnection = _db._sqlConn;
			_db._sqlStmt.text = _db._sqlStr;
			_db._sqlStmt.execute(-1, new Responder(onResult, null));
			
			function onResult($result:SQLResult):void
			{
				if ($result.data)
				{
					result = $result.data[0].updateId;
				}
			}
			
			return result;
		}
		
		public static function getPagesUpdateId():Object
		{
			DbClient.connect();
			var result:Object = {};
			
			_db._sqlStmt = new SQLStatement();
			_db._sqlStr =	" 	SELECT id,updateId FROM pages";
			_db._sqlStmt.sqlConnection = _db._sqlConn;
			_db._sqlStmt.text = _db._sqlStr;
			_db._sqlStmt.execute( -1, new Responder(onResult, null));
			
			function onResult($result:SQLResult):void
			{
				if ($result.data)
				{
					result = { };
					for (var i:int = 0; i < $result.data.length; i++) 
					{
						result[$result.data[i].id] = $result.data[i].updateId;
					}
				}
			}
			
			return result;
		}
		
		public static function checkForces($obj:Object):void
		{
			DbClient.connect();
			
			//C.log("??? ", $obj.imagesUpdateId, $obj.allUpdateId)
			
			_db._sqlStmt = new SQLStatement();
			_db._sqlStr =	" 	SELECT * FROM forces LIMIT 1";
			_db._sqlStmt.sqlConnection = _db._sqlConn;
			_db._sqlStmt.text = _db._sqlStr;
			_db._sqlStmt.execute( -1, new Responder(onResult, null));
			
			function onResult($result:SQLResult):void
			{
				if ($result.data)
				{
					// compare images updateIdes
					if ($result.data[0].imagesUpdateId != $obj.imagesUpdateId)
					{
						// delete image chache
						DbClient.cleanChache();
						
						// update imagesUpdateId
						updateImageForce();
					}
					
					//C.log($result.data[0].allUpdateId);
				}
				else
				{
					insertForces();
				}
			}
			
			function insertForces():void
			{
				_db._sqlStmt = new SQLStatement();
				_db._sqlStr =	"	INSERT INTO forces (imagesUpdateId, allUpdateId) " +
								"	VALUES ('" + $obj.imagesUpdateId + "', " +
								"	'" + $obj.allUpdateId + "'" +
								"	)";
				_db._sqlStmt.sqlConnection = _db._sqlConn;
				_db._sqlStmt.text = _db._sqlStr;
				_db._sqlStmt.execute();
			}
			
			function updateImageForce():void
			{
				_db._sqlStmt = new SQLStatement();
				_db._sqlStr =	"	UPDATE forces SET " +
								"	imagesUpdateId='" + $obj.imagesUpdateId + "'";
				_db._sqlStmt.sqlConnection = _db._sqlConn;
				_db._sqlStmt.text = _db._sqlStr;
				_db._sqlStmt.execute();
			}
		}
		
		public static function cleanChache():void
		{
			_db._sqlStmt = new SQLStatement();
			_db._sqlStr = 	" 	DELETE FROM media ";
			_db._sqlStmt.sqlConnection = _db._sqlConn;
			_db._sqlStmt.text = _db._sqlStr;
			_db._sqlStmt.execute();
		}
		
		public static function dropPages($items:Array):void
		{
			_db._sqlStmt = new SQLStatement();
			_db._sqlStr = 	" 	DELETE FROM pages WHERE ";
			
			for (var i:int = 0; i < $items.length; i++) 
			{
				if (i < $items.length - 1) _db._sqlStr +=	"id='" + $items[i] + "' OR ";
				else if(i == $items.length - 1) _db._sqlStr +=	"id='" + $items[i] + "'";
			}
			
			_db._sqlStmt.sqlConnection = _db._sqlConn;
			_db._sqlStmt.text = _db._sqlStr;
			_db._sqlStmt.execute();
		}
		
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////// Getter - Setter
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

		protected static function getter(str:String):*
		{
			if(_db)return _db[str];
			else return null;
		}
		
		protected static function setter(str:String, v:*):void
		{
			if (_db)_db[str] = v;
		}
		
		public static function get available():Boolean
		{
			var result:Boolean = false;
			
			if (!_db._dbFile)
			{
				toResolvePath();
			}
			
			result = _db._dbFile.exists;
			
			return result;
		}
		
		public static function get data():Object
		{
			return _data;
		}
		
		public static function set data(a:Object):void
		{
			_data = a;
		}
	}
	
}