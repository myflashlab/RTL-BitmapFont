package com.doitflash.mobileProject.commonCpuSrc.plugins.WP.comments
{
	import  com.doitflash.mobileProject.commonCpuSrc.plugins.WP.assets.Butt;
	import com.doitflash.events.WpEvent;
	import com.doitflash.mobileProject.commonCpuSrc.events.AppEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import com.doitflash.text.TextArea;
	
	import com.doitflash.text.modules.MySprite;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 4/20/2012 8:21 PM
	 */
	public class Reply extends MySprite 
	{
		private var _nameTxt:TextArea;
		private var _nameStr:String = "Your Name:";
		private var _emailTxt:TextArea;
		private var _emailStr:String = "Your Email:";
		private var _contentTxt:TextArea;
		private var _contentStr:String = "Content...";
		
		private var _btn:Butt;
		
		public function Reply():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_margin = 15;
			_bgAlpha = 1;
			_bgColor = 0xFFFFFF;
			//_bgStrokeAlpha = 1;
			//_bgStrokeColor = 0x000000;
			//_bgStrokeThickness = 1;
			drawBg();
			
		}
		
		private function stageRemoved(e:Event = null):void 
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			
		}
		
		private function stageAdded(e:Event = null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			/*for (var name:String in _data) 
			{
				_base.c.log(name)
			}
			_base.c.log("-------------");*/
			//_base.c.log(_data.comment_parent);
			
			initBtn();
			initFields();
			
			onResize();
			
		}
		
// ----------------------------------------------------------------------------------------------------------------------- funcs
		
		private function initBtn():void
		{
			_btn = new Butt();
			_btn.addEventListener(MouseEvent.MOUSE_UP, onUp);
			_btn.addEventListener(MouseEvent.MOUSE_OUT, onUp);
			_btn.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_btn.addEventListener(MouseEvent.CLICK, onSubmit);
			_btn.label_txt.text = "Submit";
			
			this.addChild(_btn);
		}
		//private var nt:*;
		private function initFields():void
		{
			var format:TextFormat = new TextFormat();
			format.size = 35;
			format.color = 0x333333;
			format.font = "Arimo";
			
			var h:Number;
			
			/*nt = new _base.nativeExtensions["nativeText"](1);
			nt.returnKeyLabel = "done";
			//nt.returnKeyLabel = ReturnKeyLabel.DONE;
			nt.autoCorrect = true;
			nt.fontSize = 35;
			nt.borderThickness = 1;
			nt.fontFamily = "Arial";
			nt.text = _nameStr;
			nt.width = stage.stageWidth;
			//nt.x = (stage.stageWidth / 2) - (nt.width / 2);
			//nt.y = (stage.stageHeight / 2) - (nt.height);
			this.addChild(nt);*/
			
			_nameTxt = new TextArea();
			_nameTxt.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_nameTxt.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			_nameTxt.autoSize = TextFieldAutoSize.LEFT;
			_nameTxt.antiAliasType = AntiAliasType.ADVANCED;
			_nameTxt.type = TextFieldType.INPUT;
			_nameTxt.embedFonts = true;
			_nameTxt.border = true;
			_nameTxt.data = {defaultValue:_nameStr};
			_nameTxt.defaultTextFormat = format;
			_nameTxt.text = _nameStr;
			this.addChild(_nameTxt);
			
			h = _nameTxt.height;
			_nameTxt.autoSize = TextFieldAutoSize.NONE;
			_nameTxt.height = h;
			
			//------------------------------------------------------
			
			_emailTxt = new TextArea();
			_emailTxt.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_emailTxt.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			_emailTxt.autoSize = TextFieldAutoSize.LEFT;
			_emailTxt.antiAliasType = AntiAliasType.ADVANCED;
			_emailTxt.type = TextFieldType.INPUT;
			_emailTxt.embedFonts = true;
			_emailTxt.border = true;
			_emailTxt.data = {defaultValue:_emailStr};
			_emailTxt.defaultTextFormat = format;
			_emailTxt.text = _emailStr;
			this.addChild(_emailTxt);
			
			h = _emailTxt.height;
			_emailTxt.autoSize = TextFieldAutoSize.NONE;
			_emailTxt.height = h;
			
			//------------------------------------------------------
			
			_contentTxt = new TextArea();
			_contentTxt.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_contentTxt.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			//_contentTxt.autoSize = TextFieldAutoSize.LEFT;
			_contentTxt.antiAliasType = AntiAliasType.ADVANCED;
			_contentTxt.type = TextFieldType.INPUT;
			_contentTxt.embedFonts = true;
			_contentTxt.wordWrap = true;
			_contentTxt.multiline = true;
			_contentTxt.border = true;
			_contentTxt.data = {defaultValue:_contentStr};
			_contentTxt.defaultTextFormat = new TextFormat("Arimo", 20, 0x333333);
			_contentTxt.text = _contentStr;
			this.addChild(_contentTxt);
			
			//h = _emailTxt.height;
			//_emailTxt.autoSize = TextFieldAutoSize.NONE;
			//_emailTxt.height = h;
			
			
		}
		
		private function onSubmit(e:MouseEvent):void
		{
			this.dispatchEvent(new AppEvent(AppEvent.SUBMIT_COMMENT, {name:_nameTxt.text, email:_emailTxt.text, content:_contentTxt.text, post_id:_data.post_id, comment_parent:_data.comment_parent}))
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Helpful Funcs

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_btn)
			{
				_btn.x = _width / 2 - _btn.width / 2;
				_btn.y = _height - _btn.height - _margin;
			}
			
			if (_nameTxt)
			{
				//nt.x = _margin;
				//nt.y = _margin;
				//nt.width = _width - _margin * 2;
				
				_nameTxt.x = _margin;
				//_nameTxt.y = nt.y + nt.height + 5;
				_nameTxt.y = _margin;
				//_nameTxt.width = _width - _margin * 2;
				
				//_nameTxt.scaleX = _nameTxt.scaleY = _base.deviceInfo.dpiScaleMultiplier;
				_nameTxt.width = (_width - _margin * 2)/* * (1 / _base.deviceInfo.dpiScaleMultiplier)*/;
				//_nameTxt.height = _nameTxt.height * (1 / _base.deviceInfo.dpiScaleMultiplier);
				
				_emailTxt.x = _margin;
				_emailTxt.y = _nameTxt.y + _nameTxt.height + 5;
				//_emailTxt.scaleX = _emailTxt.scaleY = _base.deviceInfo.dpiScaleMultiplier;
				_emailTxt.width = (_width - _margin * 2)/* * (1 / _base.deviceInfo.dpiScaleMultiplier)*/;
				//_emailTxt.height = _emailTxt.height * (1 / _base.deviceInfo.dpiScaleMultiplier);
				
				_contentTxt.x = _margin;
				_contentTxt.y = _emailTxt.y + _emailTxt.height + 5;
				_contentTxt.width = (_width - _margin * 2);
				_contentTxt.height = _height - _contentTxt.y - _btn.height - _margin - 5;
			}
		}
		
		private function onFocusIn(e:FocusEvent):void
		{
			if(e.target.text == e.target.data.defaultValue) e.target.text = "";
		}
		
		private function onFocusOut(e:FocusEvent):void
		{
			if (e.target.text == "") e.target.text = e.target.data.defaultValue;
		}
		
		private function onUp(e:MouseEvent):void
		{
			_btn.bg_mc.gotoAndStop(1);
		}
		
		private function onDown(e:MouseEvent):void
		{
			_btn.bg_mc.gotoAndStop(2);
		}
	
// ----------------------------------------------------------------------------------------------------------------------- Methods

		

// ----------------------------------------------------------------------------------------------------------------------- Properties

		
		
	}
	
}