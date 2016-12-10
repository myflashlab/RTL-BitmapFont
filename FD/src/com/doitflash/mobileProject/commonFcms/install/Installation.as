package com.doitflash.mobileProject.commonFcms.install
{
	import com.doitflash.text.TextArea;
	import com.doitflash.mobileProject.commonFcms.events.InstallEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.Responder;
	import flash.net.URLVariables;
	import flash.text.TextFieldAutoSize;
	import flash.text.Font;
	
	import com.doitflash.mobileProject.commonFcms.preloader.Preloader;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli
	 */
	public class Installation extends Preloader 
	{
		public static const NUM_STEPS:int = 4;
		
		private var _currStep:*;
		private var _header:*;
		private var _nav:InstallNav;
		private var _currStepNumber:int = 1;
		
		private var _step1:Step1;
		private var _step2:Step2;
		private var _step3:Step3;
		private var _lastStep:LastStep;
		
		public function Installation():void 
		{
			super();
			
			_bgStrokeAlpha = 1;
			_bgStrokeColor = 0xCCCCCC;
			_bgStrokeThickness = 1;
			_bgAlpha = 1;
			_bgColor = 0xF7F7F7;
			drawBg();
		}
		
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////// Private Functions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

		override protected function init():void
		{
			initHeader();
			initNav();
			initStep(_currStepNumber);
			
			setPageAddress("installation", "installation");
		}
		
		private function initHeader():void
		{
			if (!_header) 
			{
				_header = new getGraphic.installHeader();
				_header.stepsTxt.autoSize = TextFieldAutoSize.LEFT;
				this.addChild(_header);
			}
			
			if (_currStepNumber == Installation.NUM_STEPS) _header.stepsTxt.htmlText = "Installing...";
			else _header.stepsTxt.htmlText = "STEP " + _currStepNumber + "";
			
			onResize();
			
		}
		
		private function initNav():void
		{
			_nav = new InstallNav();
			_nav.addEventListener(InstallEvent.NEXT_STEP, goNextStep);
			_nav.addEventListener(InstallEvent.PREV_STEP, goPrevStep);
			_nav.addEventListener(InstallEvent.START, toStartInstall);
			_nav.base = this;
			_nav.serverPath = _serverPath;
			this.addChild(_nav);
		}
		
		private function toStartInstall(e:InstallEvent):void
		{
			_lastStep.txt.htmlText = "fCMS installation just started, please be patient<br><br>1/4) Connecting to Database...";
			gateway.call("Install.part1", new Responder(onPart1Result, onFault), _step2.retrieveValues());
		}
		
		private function toCreateTables():void
		{
			_lastStep.txt.htmlText += "<br>";
			_lastStep.txt.text += "2/4) Creating database tables...";
			gateway.call("Install.part2", new Responder(onPart2Result, onFault));
		}
		
		private function toSaveAdminInfo():void
		{
			_lastStep.txt.htmlText += "<br>";
			_lastStep.txt.text += "3/4) Saving admin Information...";
			gateway.call("Install.part3", new Responder(onPart3Result, onFault), _step3.retrieveValues());
		}
		
		private function toFinalizeInstallation():void
		{
			_lastStep.txt.htmlText += "<br>";
			_lastStep.txt.text += "4/4) verifying the installation...";
			gateway.call("Install.finish", new Responder(onFinishResult, onFault));
		}
		
		
		
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////// Helpful Private Functions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function onPart1Result($result:String):void
		{
			var vars:URLVariables = new URLVariables($result);
			
			if (vars.backToFlash == "true")
			{
				_lastStep.txt.text += " OK";
				toCreateTables();
			}
			else if (vars.backToFlash == "false")
			{
				_lastStep.txt.htmlText += "<br><font color='#990000'>" + vars.msg + "</font>";
				_nav.backBtn.visible = true;
			}
		}
		
		private function onPart2Result($result:String):void
		{
			var vars:URLVariables = new URLVariables($result);
			
			if (vars.backToFlash == "true")
			{
				_lastStep.txt.text += " OK";
				toSaveAdminInfo();
			}
			else if (vars.backToFlash == "false")
			{
				_lastStep.txt.htmlText += "<br><font color='#990000'>" + vars.msg + "</font>";
				_nav.backBtn.visible = true;
			}
		}
		
		private function onPart3Result($result:String):void
		{
			var vars:URLVariables = new URLVariables($result);
			
			if (vars.backToFlash == "true")
			{
				_lastStep.txt.text += " OK";
				toFinalizeInstallation();
			}
			else if (vars.backToFlash == "false")
			{
				_lastStep.txt.htmlText += "<br><font color='#990000'>" + vars.msg + "</font>";
				_nav.backBtn.visible = true;
			}
		}
		
		/*private function onPart4Result($result:String):void
		{
			var vars:URLVariables = new URLVariables($result);
			
			if (vars.backToFlash == "true")
			{
				_lastStep.txt.text += " OK";
				toFinalizeInstallation();
			}
			else if (vars.backToFlash == "false")
			{
				_lastStep.txt.htmlText += "<br><font color='#990000'>" + vars.msg + "</font>";
				_nav.backBtn.visible = true;
			}
		}*/
		
		private function onFinishResult($result:String):void
		{
			var vars:URLVariables = new URLVariables($result);
			
			if (vars.backToFlash == "true")
			{
				_lastStep.txt.text += " OK";
				_lastStep.txt.htmlText += "<br><font color='#009900'>" + vars.msg + "</font>";
				_header.stepsTxt.htmlText = "";
			}
			else if (vars.backToFlash == "false")
			{
				_lastStep.txt.htmlText += "<br><font color='#990000'>" + vars.msg + "</font>";
				_nav.backBtn.visible = true;
			}
		}
		
		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			this.width = 550;
			this.height = 400;
			
			this.x = stage.stageWidth / 2 - this.width / 2;
			this.y = stage.stageHeight / 2 - this.height / 2;
			
			if (_header)
			{
				_header.stepsTxt.y = _header.height - _header.stepsTxt.height;
			}
			
			if (_nav)
			{
				_nav.width = _width;
				_nav.height = 40;
				_nav.y = _height - _nav.height;
			}
			
			if (_currStep)
			{
				_currStep.width = _width;
				_currStep.height = _height - _nav.height - _header.height;
				_currStep.y = _header.height;
			}
		}
		
		private function goNextStep(e:InstallEvent):void
		{
			_currStepNumber++;
			initHeader();
			initStep(_currStepNumber);
		}
		
		private function goPrevStep(e:InstallEvent):void
		{
			_currStepNumber--;
			initHeader();
			initStep(_currStepNumber);
		}
		
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////// Methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
		public function initStep($step:int):void
		{
			cleanUp(_body);
			
			switch ($step) 
			{
				case 1:
					
					if(!_step1) _step1 = new Step1();
					_step1.base = this;
					_step1.serverPath = _serverPath;
					_body.addChild(_step1);
					
					_currStep = _step1;
					
				break;
				case 2:
					
					if(!_step2) _step2 = new Step2();
					_step2.base = this;
					_step2.serverPath = _serverPath;
					_body.addChild(_step2);
					
					_currStep = _step2;
					
				break;
				case 3:
					
					if(!_step3) _step3 = new Step3();
					_step3.base = this;
					_step3.serverPath = _serverPath;
					_body.addChild(_step3);
					
					_currStep = _step3;
					
				break;
				case 4:
					
					if(!_lastStep) _lastStep = new LastStep();
					_lastStep.base = this;
					_lastStep.serverPath = _serverPath;
					_body.addChild(_lastStep);
					
					_currStep = _lastStep;
					
				break;
				default:
			}
			
			onResize();
		}
		
		override public function onFault(a:String):void
		{
			super.onFault(a);
			
			_nav.backBtn.visible = true;
		}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////// Getter - Setter
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

		public function get getCurrStepNum():int
		{
			return _currStepNumber;
		}
	}
	
}