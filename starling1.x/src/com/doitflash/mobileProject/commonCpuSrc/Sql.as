package com.doitflash.mobileProject.commonCpuSrc
{
	import flash.data.SQLConnection;
	import flash.data.EncryptedLocalStore;
	import flash.data.SQLCollationType;
	import flash.data.SQLColumnNameStyle;
	import flash.data.SQLColumnSchema;
	import flash.data.SQLIndexSchema;
	import flash.data.SQLMode;
	import flash.data.SQLStatement;
	import flash.data.SQLResult;
	import flash.data.SQLSchema;
	import flash.data.SQLSchemaResult;
	import flash.data.SQLTableSchema;
	import flash.data.SQLTransactionLockType;
	import flash.data.SQLTriggerSchema;
	import flash.data.SQLViewSchema;
	import flash.events.SQLEvent;
	import flash.events.SQLErrorEvent;
	import flash.filesystem.File;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 5/4/2012 12:08 PM
	 */
	public class Sql
	{
		
		public function Sql():void 
		{
			
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Privates
		
		
		
// ----------------------------------------------------------------------------------------------------------------------- Methods
		
		
		
// ----------------------------------------------------------------------------------------------------------------------- Properties
		
		public static function get sQLConnection():Class
		{
			return SQLConnection;
		}
		
		public static function get sQLViewSchema():Class
		{
			return SQLViewSchema;
		}
		
		public static function get sQLTriggerSchema():Class
		{
			return SQLTriggerSchema;
		}
		
		public static function get sQLTransactionLockType():Class
		{
			return SQLTransactionLockType;
		}
		
		public static function get sQLTableSchema():Class
		{
			return SQLTableSchema;
		}
		
		public static function get sQLSchemaResult():Class
		{
			return SQLSchemaResult;
		}
		
		public static function get sQLSchema():Class
		{
			return SQLSchema;
		}
		
		public static function get sQLMode():Class
		{
			return SQLMode;
		}
		
		public static function get sQLIndexSchema():Class
		{
			return SQLIndexSchema;
		}
		
		public static function get sQLColumnSchema():Class
		{
			return SQLColumnSchema;
		}
		
		public static function get sQLColumnNameStyle():Class
		{
			return SQLColumnNameStyle;
		}
		
		public static function get sQLCollationType():Class
		{
			return SQLCollationType;
		}
		
		public static function get encryptedLocalStore():Class
		{
			return EncryptedLocalStore;
		}
		
		public static function get file():Class
		{
			return File;
		}
		
		public static function get sQLErrorEvent():Class
		{
			return SQLErrorEvent;
		}
		
		public static function get sQLEvent():Class
		{
			return SQLEvent;
		}
		
		public static function get sQLResult():Class
		{
			return SQLResult;
		}
		
		public static function get sQLStatement():Class
		{
			return SQLStatement;
		}
	}
	
}