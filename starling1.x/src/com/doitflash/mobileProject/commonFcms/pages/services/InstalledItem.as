package com.doitflash.mobileProject.commonFcms.pages.services
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
	
	import com.doitflash.mobileProject.commonFcms.events.ServiceEvent;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 9/23/2012 10:38 AM
	 */
	public class InstalledItem extends MySprite 
	{
		private var _nameTxt:TextArea;
		private var _descriptionTxt:TextArea;
		private var _versionTxt:TextArea;
		private var _priceTxt:TextArea;
		
		private var _line:Shape;
		private var _line2:Shape;
		
		private var _updateBtn:*;
		private var _dropBtn:*;
		private var _activateBtn:*;
		private var _inactivateBtn:*;
		private var _settingBtn:*;
		
		private var _list:List;
		
		private var _status:String;
		private var _statusMsg:Array = ["<font color='#B94A48'>Service is not active</font>", "<font color='#468847'>Service is active</font>"];
		
		public function InstalledItem():void 
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
			
			if (_status == PageServices.SERVICE_INSTALLED)
			{
				if (!_dropBtn) initDropBtn();
			}
			
			if (_status == PageServices.SERVICE_NEEDS_UPDATE)
			{
				if (!_updateBtn) initUpdateBtn();
				if (!_dropBtn) initDropBtn();
			}
			
			if (_data.activated == 0)
			{
				if (!_activateBtn) initActivateBtn();
			}
			else
			{
				if (!_inactivateBtn) initInactivateBtn();
			}
			
			if (!_settingBtn) initSettingBtn();
			
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
			_nameTxt.htmlText = "<font face='Arimo' color='#333333' size='12'><b><i>" + _data.type + "</i></b></font>";
			this.addChild(_nameTxt);
			
			_descriptionTxt = new TextArea();
			//_descriptionTxt.autoSize = TextFieldAutoSize.LEFT;
			_descriptionTxt.antiAliasType = AntiAliasType.ADVANCED;
			_descriptionTxt.multiline = true;
			_descriptionTxt.wordWrap = true;
			_descriptionTxt.embedFonts = true;
			_descriptionTxt.selectable = false;
			//_descriptionTxt.border = true;
			_descriptionTxt.htmlText = "<font face='Arimo' color='#999999' size='12'>" + _data.description + "</font>";
			this.addChild(_descriptionTxt);
			
			_versionTxt = new TextArea();
			_versionTxt.autoSize = TextFieldAutoSize.LEFT;
			_versionTxt.antiAliasType = AntiAliasType.ADVANCED;
			//_versionTxt.multiline = true;
			//_versionTxt.wordWrap = true;
			_versionTxt.embedFonts = true;
			_versionTxt.selectable = false;
			//_versionTxt.border = true;
			_versionTxt.htmlText = "<font face='Arimo' color='#333333' size='12'><i>Installed version: <font color='#3A87AD'>" + _data.version + "</font> | By: <font color='#3A87AD'><a href='" + _data.authorSite + "' target='_blank'>" + _data.author + "</a></font> | <font color='#3A87AD'><b><a href='" + _data.moreDescription + "' target='_blank'>Read More</a></b></font></i>     " + _statusMsg[_data.activated] + "</font>";
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
		
		private function initUpdateBtn():void
		{
			_updateBtn = new _base.getGraphic.updateBtn();
			_updateBtn.addEventListener(MouseEvent.CLICK, onUpdate, false, 0, true);
			_updateBtn.addEventListener(MouseEvent.ROLL_OVER, onOver, false, 0, true);
			_updateBtn.addEventListener(MouseEvent.ROLL_OUT, onOut, false, 0, true);
			_updateBtn.data.alt = "Update";
			_updateBtn.buttonMode = true;
			_list.add(_updateBtn);
		}
		
		private function initDropBtn():void
		{
			_dropBtn = new _base.getGraphic.dropBtn();
			_dropBtn.addEventListener(MouseEvent.CLICK, onUninstall, false, 0, true);
			_dropBtn.addEventListener(MouseEvent.ROLL_OVER, onOver, false, 0, true);
			_dropBtn.addEventListener(MouseEvent.ROLL_OUT, onOut, false, 0, true);
			_dropBtn.data.alt = "Uninstall";
			_dropBtn.buttonMode = true;
			_list.add(_dropBtn);
		}
		
		private function initActivateBtn($index:Number=-1):void
		{
			_activateBtn = new _base.getGraphic.serviceActivateBtn();
			_activateBtn.addEventListener(MouseEvent.CLICK, onActivate, false, 0, true);
			_activateBtn.addEventListener(MouseEvent.ROLL_OVER, onOver, false, 0, true);
			_activateBtn.addEventListener(MouseEvent.ROLL_OUT, onOut, false, 0, true);
			_activateBtn.data.alt = "Click to activate this service";
			_activateBtn.buttonMode = true;
			_list.add(_activateBtn, $index);
		}
		
		private function initInactivateBtn($index:Number=-1):void
		{
			_inactivateBtn = new _base.getGraphic.serviceInActivateBtn();
			_inactivateBtn.addEventListener(MouseEvent.CLICK, onInactivate, false, 0, true);
			_inactivateBtn.addEventListener(MouseEvent.ROLL_OVER, onOver, false, 0, true);
			_inactivateBtn.addEventListener(MouseEvent.ROLL_OUT, onOut, false, 0, true);
			_inactivateBtn.data.alt = "Click to inactivate this service";
			_inactivateBtn.buttonMode = true;
			_list.add(_inactivateBtn, $index);
		}
		
		private function initSettingBtn():void
		{
			_settingBtn = new _base.getGraphic.serviceSettingBtn();
			_settingBtn.addEventListener(MouseEvent.CLICK, onSetting, false, 0, true);
			_settingBtn.addEventListener(MouseEvent.ROLL_OVER, onOver, false, 0, true);
			_settingBtn.addEventListener(MouseEvent.ROLL_OUT, onOut, false, 0, true);
			_settingBtn.data.alt = "Click to modify the service setting";
			_settingBtn.buttonMode = true;
			_list.add(_settingBtn);
		}
		
		private function onUpdate(e:MouseEvent):void
		{
			this.dispatchEvent(new ServiceEvent(ServiceEvent.UPDATE, _data));
		}
		
		private function onUninstall(e:MouseEvent):void
		{
			this.dispatchEvent(new ServiceEvent(ServiceEvent.UNINSTALL, _data));
		}
		
		private function onActivate(e:MouseEvent):void
		{
			this.dispatchEvent(new ServiceEvent(ServiceEvent.ACTIVATE, _data));
		}
		
		private function onInactivate(e:MouseEvent):void
		{
			this.dispatchEvent(new ServiceEvent(ServiceEvent.INACTIVATE, _data));
		}
		
		private function onSetting(e:MouseEvent):void
		{
			this.dispatchEvent(new ServiceEvent(ServiceEvent.SETTING, _data));
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
			
			if (_nameTxt)
			{
				_nameTxt.y = 5;
				
				//_nameTxt.y = _height - _nameTxt.height >> 1;
				var rightSide:Number = _line2.x;
				
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
			_base.getTooltip.mouseSpaceY = -35;
			_base.getTooltip.delay = 0.5;
			_base.getTooltip.showText("<font face='Tahoma' size='11' color='#000000'>"+ e.currentTarget.data.alt +"</font>", "ltr");
		}
		
		private function onOut(e:MouseEvent):void
		{
			_base.getTooltip.hide();
		}

//--------------------------------------------------------------------------------------------------------------------- Methods

		public function updateActivation($status:int):void
		{
			if ($status == _data.activated) return;
			
			
			var index:int;
			if (_data.activated == 1)
			{
				index = _list.getItemIndex(_inactivateBtn);
				_list.remove(_inactivateBtn);
				_inactivateBtn = null;
				if (!_activateBtn) initActivateBtn(index);
			}
			else
			{
				index = _list.getItemIndex(_activateBtn);
				_list.remove(_activateBtn);
				_activateBtn = null;
				if (!_inactivateBtn) initInactivateBtn(index);
			}
			
			_data.activated = $status;
			_versionTxt.htmlText = "<font face='Arimo' color='#333333' size='12'><i>Installed version: <font color='#3A87AD'>" + _data.version + "</font> | By: <font color='#3A87AD'><a href='" + _data.authorSite + "' target='_blank'>" + _data.author + "</a></font> | <font color='#3A87AD'><b><a href='" + _data.moreDescription + "' target='_blank'>Read More</a></b></font></i>     " + _statusMsg[_data.activated] + "</font>";
		}

//--------------------------------------------------------------------------------------------------------------------- Properties

		public function set status(a:String):void
		{
			_status = a;
		}
	}
	
}