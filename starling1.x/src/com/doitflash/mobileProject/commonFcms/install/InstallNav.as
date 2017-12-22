package com.doitflash.mobileProject.commonFcms.install
{
	import com.doitflash.consts.Position;
	import com.doitflash.mobileProject.commonFcms.events.InstallEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.doitflash.text.modules.MySprite;
	
	import com.doitflash.mobileProject.commonFcms.extraManager.TabButton;
	
	//import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 1/8/2012 10:35 AM
	 */
	public class InstallNav extends MySprite 
	{
		private var _nextBtn:TabButton;
		private var _backBtn:TabButton;
		
		public function InstallNav():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_bgStrokeAlpha = 1;
			_bgStrokeColor = 0xCCCCCC;
			_bgStrokeThickness = 1;
			_bgAlpha = 1;
			_bgColor = 0xF7F7F7;
			drawBg();
		}
		
		private function stageAdded(e:Event = null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			initBtns();
			check();
		}
		
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////// Private Functions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

		private function initBtns():void
		{
			_nextBtn = new TabButton();
			_nextBtn.bgAlpha = 0;
			_nextBtn.bgStrokeAlpha = 0;
			_nextBtn.addEventListener(MouseEvent.CLICK, onNext);
			_nextBtn.buttonMode = true;
			_nextBtn.iconPosition = Position.RIGHT;
			_nextBtn.label = "<font face='Verdana' size='11' color='#333333'>NEXT</font>";
			_nextBtn.icon = new _base.getGraphic.nextBtn();
			this.addChild(_nextBtn);
			
			_backBtn = new TabButton();
			_backBtn.bgAlpha = 0;
			_backBtn.bgStrokeAlpha = 0;
			_backBtn.addEventListener(MouseEvent.CLICK, onBack);
			_backBtn.buttonMode = true;
			_backBtn.label = "<font face='Verdana' size='11' color='#333333'>BACK</font>";
			_backBtn.icon = new _base.getGraphic.backBtn();
			this.addChild(_backBtn);
		}
		
		private function onNext(e:MouseEvent):void
		{
			this.dispatchEvent(new InstallEvent(InstallEvent.NEXT_STEP));
			check();
		}
		
		private function onBack(e:MouseEvent):void
		{
			this.dispatchEvent(new InstallEvent(InstallEvent.PREV_STEP));
			check();
		}
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////// Helpful Private Functions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_nextBtn)
			{
				_nextBtn.width = 100;
				_nextBtn.height = _height;
				_nextBtn.x = _width - _nextBtn.width;
			}
			
			if (_backBtn)
			{
				_backBtn.width = 100;
				_backBtn.height = _height;
			}
		}
		
		private function check():void
		{
			_backBtn.visible = true;
			_nextBtn.visible = true;
			
			_nextBtn.label = "<font face='Verdana' size='11' color='#333333'>NEXT</font>";
			_nextBtn.icon = new _base.getGraphic.nextBtn();
			
			if (_base.getCurrStepNum == 1)
			{
				_backBtn.visible = false;
			}
			else if (_base.getCurrStepNum == Installation.NUM_STEPS - 1)
			{
				_nextBtn.label = "<font face='Verdana' size='11' color='#333333'>INSTALL</font>";
				_nextBtn.icon = new _base.getGraphic.tickBtn();
			}
			else if (_base.getCurrStepNum == Installation.NUM_STEPS)
			{
				_nextBtn.visible = false;
				_backBtn.visible = false;
				this.dispatchEvent(new InstallEvent(InstallEvent.START));
			}
		}
		
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////// Methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
		
		

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////// Getter - Setter
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

		public function get backBtn():TabButton
		{
			return _backBtn;
		}
		
		public function get nextBtn():TabButton
		{
			return _nextBtn;
		}
	}
	
}