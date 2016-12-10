package com.doitflash.mobileProject.commonFcms.pages.appPages
{
	import com.doitflash.extendable.MySprite;
	import com.doitflash.text.TextArea;
	import com.doitflash.tools.sizeControl.Scaler;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.Responder;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;
	
	import com.doitflash.mobileProject.commonFcms.events.PageEvent;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 12/16/2011 3:26 PM
	 */
	public class Item extends MySprite 
	{
		public var goUp:Boolean = true;
		public var goDown:Boolean = true;
		
		private var _nameTxt:TextArea;
		private var _pluginUsedTxt:TextArea;
		private var _icon:Bitmap;
		private var _moveUpBtn:*;
		private var _moveDownBtn:*;
		private var _dropBtn:*;
		private var _editBtn:*;
		private var _contentEditBtn:*;
		
		public function Item():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			//_bgAlpha = 0.08;
			//_bgColor = 0xFF9900;
			//_bgStrokeAlpha = 1;
			//_bgStrokeColor = 0x000000;
			//_bgStrokeThickness = 1;
			drawBg();
		}
		
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
			
			if (!_icon) initIcon();
			if (!_nameTxt) initDetails();
			
			this.addEventListener(MouseEvent.ROLL_OVER, onItemOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onItemOut);
			
			onResize();
		}
		
//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Private Funcs			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		private function initIcon():void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onIconLoaded);
			loader.load(new URLRequest(_base.projectPath + _data.icon + "?" + getTimer()));
		}
		
		private function onIconLoaded(e:Event):void
		{
			_icon = e.target.content as Bitmap;
			_icon.smoothing = true;
			
			this.addChild(_icon);
			onResize();
		}
		
		private function initDetails():void
		{
			_nameTxt = new TextArea();
			_nameTxt.autoSize = TextFieldAutoSize.LEFT;
			_nameTxt.antiAliasType = AntiAliasType.ADVANCED;
			_nameTxt.embedFonts = true;
			_nameTxt.mouseEnabled = false;
			_nameTxt.htmlText = "<font face='Arimo' size='13' color='#333333'>" + _base.removeTextFormat(unescape(_data.name)) + "</font>";
			this.addChild(_nameTxt);
			
			_pluginUsedTxt = new TextArea();
			_pluginUsedTxt.autoSize = TextFieldAutoSize.LEFT;
			_pluginUsedTxt.antiAliasType = AntiAliasType.ADVANCED;
			_pluginUsedTxt.embedFonts = true;
			_pluginUsedTxt.mouseEnabled = false;
			_pluginUsedTxt.htmlText = "<font face='Arimo' size='13' color='#333333'>Plugin: <font color='#990000'>" + _data.type + "</font></font>";
			_pluginUsedTxt.x = 270;
			this.addChild(_pluginUsedTxt);
			
			_moveUpBtn = new _base.getGraphic.moveUpBtn();
			_moveUpBtn.addEventListener(MouseEvent.CLICK, onMoveUp);
			_moveUpBtn.addEventListener(MouseEvent.ROLL_OVER, onOver);
			_moveUpBtn.addEventListener(MouseEvent.ROLL_OUT, onOut);
			_moveUpBtn.data.alt = "Move up";
			_moveUpBtn.buttonMode = true;
			if (goUp) this.addChild(_moveUpBtn);
			
			_moveDownBtn = new _base.getGraphic.moveDownBtn();
			_moveDownBtn.addEventListener(MouseEvent.CLICK, onMoveDown);
			_moveDownBtn.addEventListener(MouseEvent.ROLL_OVER, onOver);
			_moveDownBtn.addEventListener(MouseEvent.ROLL_OUT, onOut);
			_moveDownBtn.data.alt = "Move down";
			_moveDownBtn.buttonMode = true;
			if (goDown) this.addChild(_moveDownBtn);
			
			_dropBtn = new _base.getGraphic.dropBtn();
			_dropBtn.addEventListener(MouseEvent.CLICK, onDrop);
			_dropBtn.addEventListener(MouseEvent.ROLL_OVER, onOver);
			_dropBtn.addEventListener(MouseEvent.ROLL_OUT, onOut);
			_dropBtn.data.alt = "Delete";
			_dropBtn.buttonMode = true;
			this.addChild(_dropBtn);
			
			_editBtn = new _base.getGraphic.generalEditBtn();
			_editBtn.addEventListener(MouseEvent.CLICK, onEdit);
			_editBtn.addEventListener(MouseEvent.ROLL_OVER, onOver);
			_editBtn.addEventListener(MouseEvent.ROLL_OUT, onOut);
			_editBtn.data.alt = "General Edit";
			_editBtn.buttonMode = true;
			this.addChild(_editBtn);
			
			_contentEditBtn = new _base.getGraphic.editBtn();
			_contentEditBtn.addEventListener(MouseEvent.CLICK, onContentEdit);
			_contentEditBtn.addEventListener(MouseEvent.ROLL_OVER, onOver);
			_contentEditBtn.addEventListener(MouseEvent.ROLL_OUT, onOut);
			_contentEditBtn.data.alt = "Content Edit";
			_contentEditBtn.buttonMode = true;
			this.addChild(_contentEditBtn);
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Helpful Private Funcs	---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_icon)
			{
				var arr:Array = Scaler.resize([_icon.width, _icon.height], [30, 30]);
				_icon.width = arr[0];
				_icon.height = arr[1];
			}
			
			if (_nameTxt)
			{
				(_icon)? _nameTxt.x = _icon.x + _icon.width + 5 : _nameTxt.x = 5;
				_nameTxt.y = _height - _nameTxt.height >> 1;
				_pluginUsedTxt.y = _height - _nameTxt.height >> 1;
				
				_moveUpBtn.x = _width - _moveUpBtn.width - 5;
				_moveUpBtn.y = _height - _moveUpBtn.height >> 1;
				
				_moveDownBtn.x = _moveUpBtn.x - _moveDownBtn.width - 5;
				_moveDownBtn.y = _moveUpBtn.y;
				
				_dropBtn.x = _moveDownBtn.x - _dropBtn.width - 5;
				_dropBtn.y = _moveDownBtn.y;
				
				_editBtn.x = _dropBtn.x - _editBtn.width - 5;
				_editBtn.y = _dropBtn.y;
				
				_contentEditBtn.x = _editBtn.x - _contentEditBtn.width - 5;
				_contentEditBtn.y = _editBtn.y;
			}
			
			
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
		
		private function onItemOver(e:MouseEvent):void
		{
			_bgAlpha = 1;
			_bgColor = 0xF5F5F5;
			drawBg();
		}
		
		private function onItemOut(e:MouseEvent):void
		{
			_bgAlpha = 0;
			_bgColor = 0xF5F5F5;
			drawBg();
		}
		
		private function onMoveUp(e:MouseEvent):void
		{
			this.dispatchEvent(new PageEvent(PageEvent.ITEM_MOVE_UP, _data));
		}
		
		private function onMoveDown(e:MouseEvent):void
		{
			this.dispatchEvent(new PageEvent(PageEvent.ITEM_MOVE_DOWN, _data));
		}
		
		private function onDrop(e:MouseEvent):void
		{
			this.dispatchEvent(new PageEvent(PageEvent.ITEM_DROP, _data));
		}
		
		private function onEdit(e:MouseEvent):void
		{
			this.dispatchEvent(new PageEvent(PageEvent.ITEM_EDIT, _data));
		}
		
		private function onContentEdit(e:MouseEvent):void
		{
			this.dispatchEvent(new PageEvent(PageEvent.ITEM_CONTENT_EDIT, _data));
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Methods					---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		public function update():void
		{
			if(_moveUpBtn.stage) this.removeChild(_moveUpBtn);
			if(_moveDownBtn.stage) this.removeChild(_moveDownBtn);
			
			if (goUp) this.addChild(_moveUpBtn);
			if (goDown) this.addChild(_moveDownBtn);
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
// 	Getter - Setter			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		
		
	}
	
}