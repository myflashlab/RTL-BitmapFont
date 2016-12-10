package com.doitflash.mobileProject.commonFcms.pages.plugins
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	
	import com.doitflash.text.TextArea;
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.text.modules.MySprite;
	
	import com.doitflash.utils.lists.List;
	import com.doitflash.events.ListEvent;
	import com.doitflash.consts.Direction;
	import com.doitflash.consts.Orientation;
	
	import com.doitflash.mobileProject.commonFcms.events.PluginEvent;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 5/17/2012 12:13 PM
	 */
	public class DirectoryItem extends MySprite 
	{
		private var _nameTxt:TextArea;
		private var _descriptionTxt:TextArea;
		private var _versionTxt:TextArea;
		private var _priceTxt:TextArea;
		
		private var _line:Shape;
		private var _line2:Shape;
		
		private var _purchaseBtn:*;
		private var _installBtn:*;
		private var _updateBtn:*;
		private var _dropBtn:*;
		
		private var _list:List;
		
		private var _status:String;
		
		private var _isPurchased:Boolean = false;
		
		public function DirectoryItem():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_line = new Shape();
			this.addChild(_line);
			
			_line2 = new Shape();
			this.addChild(_line2);
			
			//_margin = 10;
			//_bgAlpha = 0.5;
			//_bgColor = 0xFF9900;
			drawBg();
		}
		
//--------------------------------------------------------------------------------------------------------------------- Private
		
		private function stageRemoved(e:Event=null):void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			this.removeEventListener(MouseEvent.ROLL_OVER, onItemOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, onItemOut);
		}
		
		private function stageAdded(e:Event=null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			if (!_nameTxt) initInfo();
			if (!_list) initList();
			
			if (_status == Directory.PLUGIN_NOT_PURCHASED)
			{
				if (!_dropBtn) initBuyBtn();
				if (!_priceTxt) initPrice();
			}
			
			if (_status == Directory.PLUGIN_INSTALLED)
			{
				if (!_dropBtn) initDropBtn();
			}
			
			if (_status == Directory.PLUGIN_NEEDS_UPDATE)
			{
				if (!_updateBtn) initUpdateBtn();
				if (!_dropBtn) initDropBtn();
			}
			
			if (_status == Directory.PLUGIN_NOT_INSTALLED)
			{
				if (!_installBtn) initInstallBtn();
			}
			
			this.addEventListener(MouseEvent.ROLL_OVER, onItemOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onItemOut);
			
			onResize();
		}
		
		private function initInfo():void
		{
			_nameTxt = new TextArea();
			_nameTxt.autoSize = TextFieldAutoSize.LEFT;
			_nameTxt.antiAliasType = AntiAliasType.ADVANCED;
			//_nameTxt.multiline = true;
			//_nameTxt.wordWrap = true;
			_nameTxt.embedFonts = true;
			_nameTxt.selectable = false;
			_nameTxt.htmlText = "<font face='Arimo' color='#333333' size='12'><b><i>" + _xml.name.text() + "</i></b></font>";
			this.addChild(_nameTxt);
			
			_descriptionTxt = new TextArea();
			//_descriptionTxt.autoSize = TextFieldAutoSize.LEFT;
			_descriptionTxt.antiAliasType = AntiAliasType.ADVANCED;
			_descriptionTxt.multiline = true;
			_descriptionTxt.wordWrap = true;
			_descriptionTxt.embedFonts = true;
			_descriptionTxt.selectable = false;
			//_descriptionTxt.border = true;
			_descriptionTxt.htmlText = "<font face='Arimo' color='#999999' size='12'>" + _xml.description.text() + "</font>";
			this.addChild(_descriptionTxt);
			
			_versionTxt = new TextArea();
			_versionTxt.autoSize = TextFieldAutoSize.LEFT;
			_versionTxt.antiAliasType = AntiAliasType.ADVANCED;
			//_versionTxt.multiline = true;
			//_versionTxt.wordWrap = true;
			_versionTxt.embedFonts = true;
			_versionTxt.selectable = false;
			//_versionTxt.border = true;
			_versionTxt.htmlText = "<font face='Arimo' color='#333333' size='12'><i>Version: <font color='#3A87AD'>" + _xml.version.text() + "</font> | By: <font color='#3A87AD'><a href='" + _xml.authorSite.text() + "' target='_blank'>" + _xml.author.text() + "</a></font> | <font color='#3A87AD'><b><a href='" + _xml.moreDescription.text() + "' target='_blank'>Read More</a></b></font></i></font>";
			this.addChild(_versionTxt);
		}
		
		private function initList():void
		{
			_list = new List();
			_list.addEventListener(ListEvent.RESIZE, onResize);
			_list.direction = Direction.LEFT_TO_RIGHT;
			_list.orientation = Orientation.VERTICAL;
			_list.table = true;
			_list.numRowsOrColumns = 2;
			_list.space = 0;
			_list.speed = 0;
			
			this.addChild(_list);
		}
		
		private function initPrice():void
		{
			_priceTxt = new TextArea();
			_priceTxt.autoSize = TextFieldAutoSize.LEFT;
			_priceTxt.antiAliasType = AntiAliasType.ADVANCED;
			//_priceTxt.multiline = true;
			//_priceTxt.wordWrap = true;
			_priceTxt.embedFonts = true;
			_priceTxt.selectable = false;
			//_priceTxt.border = true;
			/*if (_xml.price.text() == "0") _priceTxt.htmlText = "<font face='Arimo' color='#008800' size='20'>FREE</font>";
			else */_priceTxt.htmlText = "<font face='Arimo' color='#008800' size='20'>$" + _xml.price.text() + "</font>";
			this.addChild(_priceTxt);
		}
		
		private function initBuyBtn():void
		{
			_purchaseBtn = new _base.getGraphic.buyBtn();
			_purchaseBtn.addEventListener(MouseEvent.CLICK, onPurchase);
			_purchaseBtn.addEventListener(MouseEvent.ROLL_OVER, onOver);
			_purchaseBtn.addEventListener(MouseEvent.ROLL_OUT, onOut);
			_purchaseBtn.data.alt = "Buy and use instantly!";
			_purchaseBtn.buttonMode = true;
			_list.add(_purchaseBtn);
		}
		
		private function initInstallBtn():void
		{
			_installBtn = new _base.getGraphic.addBtn();
			_installBtn.addEventListener(MouseEvent.CLICK, onInstall);
			_installBtn.addEventListener(MouseEvent.ROLL_OVER, onOver);
			_installBtn.addEventListener(MouseEvent.ROLL_OUT, onOut);
			_installBtn.data.alt = "Install";
			_installBtn.buttonMode = true;
			_list.add(_installBtn);
		}
		
		private function initUpdateBtn():void
		{
			_updateBtn = new _base.getGraphic.updateBtn();
			_updateBtn.addEventListener(MouseEvent.CLICK, onUpdate);
			_updateBtn.addEventListener(MouseEvent.ROLL_OVER, onOver);
			_updateBtn.addEventListener(MouseEvent.ROLL_OUT, onOut);
			_updateBtn.data.alt = "Update";
			_updateBtn.buttonMode = true;
			_list.add(_updateBtn);
		}
		
		private function initDropBtn():void
		{
			_dropBtn = new _base.getGraphic.dropBtn();
			_dropBtn.addEventListener(MouseEvent.CLICK, onUninstall);
			_dropBtn.addEventListener(MouseEvent.ROLL_OVER, onOver);
			_dropBtn.addEventListener(MouseEvent.ROLL_OUT, onOut);
			_dropBtn.data.alt = "Uninstall";
			_dropBtn.buttonMode = true;
			_list.add(_dropBtn);
		}
		
		private function onPurchase(e:MouseEvent):void
		{
			this.dispatchEvent(new PluginEvent(PluginEvent.PURCHASE, _xml));
		}
		
		private function onInstall(e:MouseEvent):void
		{
			this.dispatchEvent(new PluginEvent(PluginEvent.INSTALL, _xml));
		}
		
		private function onUpdate(e:MouseEvent):void
		{
			this.dispatchEvent(new PluginEvent(PluginEvent.UPDATE, _xml));
		}
		
		private function onUninstall(e:MouseEvent):void
		{
			this.dispatchEvent(new PluginEvent(PluginEvent.UNINSTALL, _xml));
		}
//--------------------------------------------------------------------------------------------------------------------- Helpful

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			
			_line.graphics.clear();
			_line.graphics.lineStyle(1, 0xE9E9E9);
			_line.graphics.moveTo(0, 0);
			_line.graphics.lineTo(_width, 0);
			_line.graphics.moveTo(0, _height);
			_line.graphics.lineTo(_width, _height);
			_line.graphics.endFill();
			
			_line2.graphics.clear();
			_line2.graphics.lineStyle(1, 0xE9E9E9);
			_line2.graphics.moveTo(0, 5);
			_line2.graphics.lineTo(0, _height - 5);
			_line2.graphics.endFill();
			
			_line2.x = _width - 50;
			
			if (_priceTxt)
			{
				_priceTxt.x = _line2.x - _priceTxt.width - 5;
				_priceTxt.y = _height - _priceTxt.height >> 1;
			}
			
			if (_nameTxt)
			{
				_nameTxt.y = 5;
				
				//_nameTxt.y = _height - _nameTxt.height >> 1;
				var rightSide:Number = _line2.x;
				if (_priceTxt) rightSide = _priceTxt.x;
				
				//_descriptionTxt.x = 120;
				_descriptionTxt.y = _nameTxt.y + _nameTxt.height + 20;
				_descriptionTxt.width = _width - _descriptionTxt.x - (_width - rightSide + 5);
				//_descriptionTxt.height = _nameTxt.height * 2;
				
				_versionTxt.y = _height - _versionTxt.height - 5;
			}
			
			if (_list)
			{
				_list.x = _line2.x + ((_width - _line2.x) / 2 - _list.width / 2);
				_list.y = _height - _list.height >> 1;
			}
			
			/*if (_installBtn)
			{
				_installBtn.x = _line2.x;
			}*/
		}
		
		private function onItemOver(e:MouseEvent):void
		{
			_bgAlpha = 1;
			_bgColor = 0xF5F5F5;
			drawBg();
		}
		
		private function onItemOut(e:MouseEvent):void
		{
			_bgAlpha = 0;
			_bgColor = 0xEFF2F7;
			drawBg();
		}
		
		private function onOver(e:MouseEvent):void
		{
			_base.getTooltip.mouseSpaceX = 0;
			_base.getTooltip.mouseSpaceY = -20;
			_base.getTooltip.delay = 0.5;
			_base.getTooltip.showText("<font face='Tahoma' size='11' color='#000000'>"+ e.currentTarget.data.alt +"</font>", "ltr");
		}
		
		private function onOut(e:MouseEvent):void
		{
			_base.getTooltip.hide();
		}

//--------------------------------------------------------------------------------------------------------------------- Methods

		

//--------------------------------------------------------------------------------------------------------------------- Properties

		public function set status(a:String):void
		{
			_status = a;
		}
		
		public function get isPurchased():Boolean
		{
			return _isPurchased;
		}
		
		public function set isPurchased(a:Boolean):void
		{
			_isPurchased = a;
		}
	}
	
}