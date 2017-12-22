package com.doitflash.mobileProject.commonFcms.extraManager
{
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.text.TextArea;
	import com.doitflash.mobileProject.commonFcms.events.PageEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.Responder;
	import flash.net.URLVariables;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 12/14/2011 12:14 PM
	 */
	public class InsertData extends MySprite 
	{
		protected var _extraManager:ExtraManager = new ExtraManager();
		
		public var saveMode:String = PageEvent.SAVE_NEW;
		
		private var _scroller:*;
		protected var _body:MySprite = new MySprite();
		protected var _inputWidth:Number = 400;
		protected var _formatInput:TextFormat;
		protected var _formatLabel:TextFormat;
		
		protected var _saveBtn:TabButton;
		
		public function InsertData():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_margin = 10;
			_bgAlpha = 1;
			_bgColor = 0xFFFFFF;
			_bgStrokeAlpha = 1;
			_bgStrokeColor = 0xCCCCCC;
			_bgStrokeThickness = 1;
			drawBg();
		}
		
		protected function stageRemoved(e:Event=null):void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			this.removeChild(_scroller);
			_scroller = null;
		}
		
		private function stageAdded(e:Event=null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			_extraManager.base = _base;
			
			initScroller();
			if (!_formatInput) initFormat();
			init();
			initButtons();
			
			onResize();
		}
		
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
			_formatInput.size = 13;
			_formatInput.font = "Arimo";
			
			_formatLabel = new TextFormat();
			_formatLabel.color = 0x333333;
			_formatLabel.size = 13;
			_formatLabel.font = "Arimo";
		}
		
		protected function init():void
		{
			
		}
		
//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Private Funcs			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		private function initButtons():void
		{
			if(!_saveBtn) _saveBtn = new TabButton();
			_saveBtn.addEventListener(MouseEvent.CLICK, onSave);
			_saveBtn.buttonMode = true;
			if(saveMode == PageEvent.SAVE_NEW) _saveBtn.label = "<font face='Arimo' size='13' color='#333333'>Save New</font>";
			else if(saveMode == PageEvent.SAVE_UPDATE) _saveBtn.label = "<font face='Arimo' size='13' color='#333333'>Update</font>";
			_saveBtn.icon = new _base.getGraphic.tickBtn();
			this.addChild(_saveBtn);
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Helpful Private Funcs	---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_saveBtn)
			{
				_saveBtn.width = _width;
				_saveBtn.height = 40;
				_saveBtn.y = _height - _saveBtn.height;
			}
			
			if (_scroller)
			{
				_scroller.x = _margin;
				_scroller.y = _margin;
				_scroller.maskWidth = _width - (_margin * 2) - (_scroller.scrollBarWidth + _scroller.scrollSpace);
				_scroller.maskHeight = _height - _saveBtn.height - (_margin * 2);
			}
		}
		
		private function onSave(e:MouseEvent):void
		{
			switch (saveMode) 
			{
				case PageEvent.SAVE_NEW:
				
					toSaveNew();
				
				break;
				case PageEvent.SAVE_UPDATE:
				
					toSaveUpdate();
				
				default:
			}
			
		}
		
		protected function toSaveNew():void
		{
			
		}
		
		protected function toSaveUpdate():void
		{
			
		}
		
		protected function onInsertResult($result:*):void
		{
			_base.showPreloader(false);
			var vars:URLVariables = new URLVariables($result);
			
			switch (vars.backToFlash) 
			{
				case "true":
					
					// let NewItem.as know that new data has been successfully inserted into Database
					this.dispatchEvent(new PageEvent(PageEvent.SAVE_REQUEST_SUCCEEDED, vars));
					
				break;
				default:
					
					_base.showAlert("<font color='#333333' size='13'>" + vars.msg + "</font>", "", 350, 150);
					setTimeout(_base.sizeRefresh, 20);
			}
			
			
		}
		
		protected function onUpdateResult($result:*):void
		{
			_base.showPreloader(false);
			var vars:URLVariables = new URLVariables($result);
			
			switch (vars.backToFlash) 
			{
				case "true":
					
					// let NewItem.as know that new data has been successfully inserted into Database
					this.dispatchEvent(new PageEvent(PageEvent.UPDATE_REQUEST_SUCCEEDED, vars));
					
				break;
				default:
					
					_base.showAlert("<font color='#333333' size='13'>" + vars.msg + "</font>", "", 350, 150);
					setTimeout(_base.sizeRefresh, 20);
			}
			
			
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Methods					---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		public function fieldsInfo($info:Object):void
		{
			if ($info) 
			{
				_data = $info;
				saveMode = PageEvent.SAVE_UPDATE;
			}
			else
			{
				saveMode = PageEvent.SAVE_NEW;
			}
			
			initButtons();
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
// 	Getter - Setter			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		
		
	}
	
}