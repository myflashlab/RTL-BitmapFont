package com.doitflash.mobileProject.commonFcms.install
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFormat;
	import com.doitflash.text.TextArea;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	
	import com.doitflash.text.modules.MySprite;
	
	import com.doitflash.mobileProject.commonFcms.events.PageEvent;
	import com.doitflash.mobileProject.commonFcms.extraManager.InputText;
	import com.doitflash.mobileProject.commonFcms.extraManager.ExtraManager;
	
	//import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 1/8/2012 10:35 AM
	 */
	public class Step2 extends MySprite 
	{
		private var _extraManager:ExtraManager = new ExtraManager();
		
		private var _scroller:*;
		protected var _body:MySprite = new MySprite();
		
		private var _formatInput:TextFormat;
		private var _formatLabel:TextFormat;
		
		private var _txt:TextArea;
		
		private var _dbHost:InputText;
		private var _dbName:InputText;
		private var _dbUser:InputText;
		private var _dbPass:InputText;
		
		private var _inputWidth:Number = 380;
		
		public function Step2():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_margin = 10;
			_bgStrokeAlpha = 1;
			_bgStrokeColor = 0xCCCCCC;
			_bgStrokeThickness = 1;
			_bgAlpha = 1;
			_bgColor = 0xFFFFFF;
			drawBg();
		}
		
		private function stageRemoved(e:Event=null):void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			this.removeChild(_scroller);
			_scroller = null;
			
			_dbHost.value;
			_dbName.value;
			_dbUser.value;
			_dbPass.value;
		}
		
		private function stageAdded(e:Event = null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			_extraManager.base = _base;
			
			initScroller();
			if (!_formatInput) initFormat();
			if (!_txt) initTxt();
			if (!_dbHost) initFields();
			
			onResize();
		}
		
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////// Private Functions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

		private function initScroller():void
		{
			_scroller = new _base.getScroller.getClass();
			_scroller.importProp = _base.getScroller.getDll.exportProp;
			_scroller.maskContent = _body;
			this.addChild(_scroller);
		}
		
		private function initFormat():void
		{
			_formatInput = new TextFormat();
			_formatInput.color = 0x333333;
			_formatInput.size = 12;
			_formatInput.font = "Verdana";
			
			_formatLabel = new TextFormat();
			_formatLabel.color = 0x333333;
			_formatLabel.size = 12;
			_formatLabel.font = "Verdana";
		}
		
		private function initTxt():void
		{
			_txt = new TextArea();
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.antiAliasType = AntiAliasType.ADVANCED;
			_txt.multiline = true;
			_txt.wordWrap = true;
			_txt.embedFonts = true;
			_txt.selectable = false;
			_txt.defaultTextFormat = _formatLabel;
			_txt.htmlText = "Please enter your database information below.";
			_body.addChild(_txt);
		}
		
		private function initFields():void
		{
			_dbHost = new InputText();
			_dbHost.base = _base;
			_dbHost.labelFormat = _formatLabel;
			_dbHost.inputFormat = _formatInput;
			_dbHost.inputWidth = _inputWidth;
			_dbHost.value = "";
			_dbHost.label = "DB Hostname:";
			_body.addChild(_dbHost);
			_dbHost.getListOfExtras.add(_extraManager.createNotice("Database hostname is the name of your MySql server, it's usually<br><b>localhost</b> on most hostings but if it's different, your hosting<br>server will tell you what it is when you are creating a database.<br><br>If you are using ixwebhosting, your db hostname will be something<br>like <b>mysql000.ixwebhosting.com<b>"));
			
			// ------------------------------------------------------------------------------
			
			_dbName = new InputText();
			_dbName.base = _base;
			_dbName.labelFormat = _formatLabel;
			_dbName.inputFormat = _formatInput;
			_dbName.inputWidth = _inputWidth;
			_dbName.value = "";
			_dbName.label = "DB Name:";
			_body.addChild(_dbName);
			_dbName.getListOfExtras.add(_extraManager.createNotice("Name of your database"));
			
			// ------------------------------------------------------------------------------
			
			_dbUser = new InputText();
			_dbUser.base = _base;
			_dbUser.labelFormat = _formatLabel;
			_dbUser.inputFormat = _formatInput;
			_dbUser.inputWidth = _inputWidth;
			_dbUser.value = "";
			_dbUser.label = "DB User:";
			_body.addChild(_dbUser);
			_dbUser.getListOfExtras.add(_extraManager.createNotice("The username you specified for your database"));
			
			// ------------------------------------------------------------------------------
			
			_dbPass = new InputText();
			_dbPass.base = _base;
			_dbPass.displayAsPassword = true;
			_dbPass.labelFormat = _formatLabel;
			_dbPass.inputFormat = _formatInput;
			_dbPass.inputWidth = _inputWidth;
			_dbPass.value = "";
			_dbPass.label = "DB Pass:";
			_body.addChild(_dbPass);
			_dbPass.getListOfExtras.add(_extraManager.createNotice("The password to your database"));
		}
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////// Helpful Private Functions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_scroller)
			{
				_scroller.x = _margin;
				_scroller.y = _margin;
				_scroller.maskWidth = _width - (_margin * 2) - (_scroller.scrollBarWidth + _scroller.scrollSpace);
				_scroller.maskHeight = _height - (_margin * 2);
			}
			
			var w:Number = 510;
			var h:Number = 30;
			var y:Number = 0;
			
			if (_txt)
			{
				_txt.width = _scroller.maskWidth - 2;
				
				y += _txt.height + 15;
			}
			
			if (_dbHost)
			{
				_dbHost.x = 0;
				_dbHost.y = y;
				_dbHost.width = w;
				_dbHost.height = h;
				y += _dbHost.height + 15;
				
				_dbName.x = _dbHost.x;
				_dbName.y = y;
				_dbName.width = w;
				_dbName.height = h;
				y += _dbName.height + 15;
				
				_dbUser.x = _dbHost.x;
				_dbUser.y = y;
				_dbUser.width = w;
				_dbUser.height = h;
				y += _dbUser.height + 15;
				
				_dbPass.x = _dbHost.x;
				_dbPass.y = y;
				_dbPass.width = w;
				_dbPass.height = h;
				y += _dbPass.height + 15;
			}
			
			_body.width = w;
			_body.height = y;
		}
		
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////// Methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
		public function retrieveValues():Object
		{
			_data = { };
			
			_data.dbHost = _dbHost.value;
			_data.dbName = _dbName.value;
			_data.dbUser = _dbUser.value;
			_data.dbPass = _dbPass.value;
			
			return _data;
		}
		

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////// Getter - Setter
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

		
	}
	
}