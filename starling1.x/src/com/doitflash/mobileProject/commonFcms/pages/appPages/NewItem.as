package com.doitflash.mobileProject.commonFcms.pages.appPages
{
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.text.TextArea;
	import com.doitflash.mobileProject.commonFcms.events.PageEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	
	import com.doitflash.mobileProject.commonFcms.extraManager.TabButton;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 12/14/2011 10:23 AM
	 */
	public class NewItem extends MySprite 
	{
		private var _titleStr:Array = [];
		private var _titleIcon:Array = [];
		
		private var _isOpen:Boolean;
		private var _titleHeight:Number;
		
		private var _titleMc:TabButton;
		private var _insertMc:*;
		
		public function NewItem():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
		}
		
		private function stageRemoved(e:Event=null):void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			
		}
		
		protected function stageAdded(e:Event=null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			_titleStr[0] = "<font face='Arimo' color='#333333' size='13'>Add New Page </font>";
			_titleStr[1] = "<font face='Arimo' color='#333333' size='13'>Back to pages' list</font>";
			
			_titleIcon[0] = new _base.getGraphic.addBtn();
			_titleIcon[1] = new _base.getGraphic.backBtn();
			
			if(!_titleMc) initTitle();
			if(!_insertMc) initBody()
			
			onResize();
		}
		
//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Private Funcs			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		private function initTitle():void
		{
			_titleMc = new TabButton();
			_titleMc.addEventListener(MouseEvent.CLICK, onActivation);
			_titleMc.buttonMode = true;
			_titleMc.label = _titleStr[0];
			_titleMc.icon = _titleIcon[0];
			this.addChild(_titleMc);
		}
		
		private function initBody():void
		{
			setInsertType();
			_insertMc.addEventListener(PageEvent.SAVE_REQUEST_SUCCEEDED, onSave);
			_insertMc.addEventListener(PageEvent.UPDATE_REQUEST_SUCCEEDED, onUpdateSave);
			_insertMc.base = _base;
			_insertMc.serverPath = _serverPath;
			
			_insertMc.visible = false;
			this.addChild(_insertMc);
		}
		
		protected function setInsertType():void
		{
			_insertMc = new InsertPage();
		}
		
		protected function onActivation(e:MouseEvent=null):void
		{
			if (_isOpen) 
			{
				_isOpen = false;
				_insertMc.visible = false;
				_titleMc.label = _titleStr[0];
				_titleMc.icon = _titleIcon[0];
			}
			else 
			{
				_isOpen = true;
				_insertMc.visible = true;
				_titleMc.label = _titleStr[1];
				_titleMc.icon = _titleIcon[1];
				_insertMc.fieldsInfo(null);
				//_insertMc.saveMode = PageEvent.SAVE_NEW;
			}
			
			this.dispatchEvent(new PageEvent(PageEvent.NEW_ITEM_MODULE_ACTIVATION));
		}
		
		private function onUpdateSave(e:PageEvent):void
		{
			// on a successful data being saved in db, close NewItem.as
			if (_isOpen) onActivation();
			
			this.dispatchEvent(new PageEvent(PageEvent.UPDATE_REQUEST_SUCCEEDED, e.param));
		}
		
		private function onSave(e:PageEvent):void
		{
			// on a successful data being saved in db, close NewItem.as
			if (_isOpen) onActivation();
			
			this.dispatchEvent(new PageEvent(PageEvent.SAVE_REQUEST_SUCCEEDED, e.param));
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Helpful Private Funcs	---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_titleMc)
			{
				_titleMc.width = _width;
				_titleMc.height = _titleHeight;
			}
			
			if (_insertMc)
			{
				_insertMc.width = _width;
				_insertMc.height = _height - (_titleMc.y + _titleMc.height);
				_insertMc.y = _titleMc.y + _titleMc.height;
			}
		}
		
		public function open():void
		{
			if (!_isOpen)
			{
				onActivation();
			}
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Methods					---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		

//-----------------------------------------------------------------------------------------------------------------------------------------------
// 	Getter - Setter			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		public function get isOpen():Boolean
		{
			return _isOpen;
		}
		
		public function get titleHeight():Number
		{
			return _titleHeight;
		}
		
		public function set titleHeight(a:Number):void
		{
			_titleHeight = a;
		}
		
		public function get insertMc():*
		{
			return _insertMc;
		}
		
	}
	
}