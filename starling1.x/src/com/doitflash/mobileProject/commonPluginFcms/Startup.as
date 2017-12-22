package com.doitflash.mobileProject.commonPluginFcms
{
	import events.PageEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.Responder;
	import flash.net.URLVariables;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	import com.doitflash.consts.Orientation;
	import com.doitflash.text.modules.MyMovieClip;
	import com.doitflash.mobileProject.commonFcms.extraManager.ExtraManager;
	import com.doitflash.mobileProject.commonFcms.extraManager.InputText;
	import com.doitflash.mobileProject.commonFcms.extraManager.TabButton;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Ali Tavakoli - 9/3/2012 9:35 AM
	 */
	public class Startup extends MyMovieClip 
	{
// ----------------------------------------------------------------------------------------------------------------------- vars
		
		// needed vars
		//protected var _extraManager:ExtraManager = new ExtraManager();
		protected var _formatInput:TextFormat;
		protected var _formatLabel:TextFormat;
		
		//private var _nameDefStr:String = "";
		//private var _nameStr:String = "";
		//private var _nameTxt:InputText;
		//private var _inputWidth:Number = 500;
		
		
		protected var _title:Title;
		
// ----------------------------------------------------------------------------------------------------------------------- constructor func
		
		public function Startup():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_margin = 10;
			_bgAlpha = 1;
			_bgColor = 0xFFFFFF;
			drawBg();
		}
		
// ----------------------------------------------------------------------------------------------------------------------- funcs
		
		protected function stageRemoved(e:Event=null):void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			
			if (_title)
			{
				this.removeChild(_title);
				_title = null;
			}
			
			// save values in fields (this happens when you change the page but if you close the page, fields will be destroyed)
			//if(_nameTxt) _nameStr = _nameTxt.value;
		}
		
		protected function stageAdded(e:Event=null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			
			//_extraManager.base = _base;
			
			if (!_title) initTitle();
			if (!_formatInput) initFormat();
			
			//if (!_nameTxt) initFields();
			
			onResize();
			setTimeout(onResize, 20);
		}
		
		
		
// ----------------------------------------------------------------------------------------------------------------------- Main
		
		private function initTitle():void
		{
			_title = new Title();
			_title.addEventListener(PageEvent.CLOSE, close);
			_title.titleName = "<font face='Arimo' color='#333333' size='30'>" + _base.removeTextFormat(unescape(_data.name)) + "<font size='13'>    -    Plugin: " + _data.type + "</font></font>";
			_title.base = _base;
			this.addChild(_title);
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
		
// ----------------------------------------------------------------------------------------------------------------------- Helpful
		
		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_title)
			{
				_title.width = _width;
				_title.height = 40;
			}
		}
		
		protected function close(e:*=null):void
		{
			
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Methods
		
		
		
// ----------------------------------------------------------------------------------------------------------------------- Properties
		
		
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}