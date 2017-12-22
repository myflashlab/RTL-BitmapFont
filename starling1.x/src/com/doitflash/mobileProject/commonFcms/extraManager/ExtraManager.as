package com.doitflash.mobileProject.commonFcms.extraManager
{
	import com.doitflash.events.RemoteEvent;
	import com.doitflash.text.TextArea;
	import com.doitflash.remote.browse.Browser;
	import com.doitflash.mobileProject.commonFcms.events.PageEvent;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.net.Responder;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import com.doitflash.events.AlertEvent;
	import flash.utils.setTimeout;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import com.doitflash.mobileProject.commonFcms.extraManager.pluginBrowse.PluginBrowser;
	import com.doitflash.mobileProject.commonFcms.extraManager.fontBrowse.FontBrowser;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli
	 */
	public class ExtraManager extends EventDispatcher 
	{
		private var _base:Object;
		
		public function ExtraManager() 
		{
			
		}
		
		public function createNotice($data:String):*
		{
			var extra:* = new _base.getGraphic.helpBtn();
			extra.addEventListener(MouseEvent.ROLL_OVER, onOver);
			extra.addEventListener(MouseEvent.ROLL_OUT, onOut);
			extra.data.alt = $data;
			extra.buttonMode = true;
			
			return extra;
		}
		
		public function createPreview($target:InputText, $projectPreviewPath:String):*
		{
			var extra:* = new _base.getGraphic.previewBtn();
			extra.addEventListener(MouseEvent.ROLL_OVER, onOver);
			extra.addEventListener(MouseEvent.ROLL_OUT, onOut);
			extra.addEventListener(MouseEvent.CLICK, onPreview);
			extra.data.alt = "preview (mouse interaction is disabled<br>in the preview window.)";
			extra.data.projectPreviewPath = $projectPreviewPath;
			extra.data.target = $target;
			extra.buttonMode = true;
			
			return extra;
		}
		
		public function createDoc($projectDocPath:String, $tooltipMsg:String):*
		{
			var extra:* = new _base.getGraphic.docBtn();
			extra.addEventListener(MouseEvent.ROLL_OVER, onOver);
			extra.addEventListener(MouseEvent.ROLL_OUT, onOut);
			extra.addEventListener(MouseEvent.CLICK, onDoc);
			extra.data.alt = $tooltipMsg;
			extra.data.projectDocPath = $projectDocPath;
			extra.buttonMode = true;
			
			return extra;
		}
		
		public function createServerBrowse($default:String, $target:*, $alertTitle:String, $tooltipMsg:String, $approveBtnLabel:String="SELECT", $onApproveFunc:Function=null):*
		{
			var extra:* = new _base.getGraphic.browseBtn();
			extra.addEventListener(MouseEvent.ROLL_OVER, onOver);
			extra.addEventListener(MouseEvent.ROLL_OUT, onOut);
			extra.addEventListener(MouseEvent.CLICK, onServerBrowse);
			extra.data.alt = $tooltipMsg;
			extra.data.defLocation = $default;
			extra.data.alertTitle = $alertTitle;
			extra.data.target = $target;
			extra.data.approveBtnLabel = $approveBtnLabel;
			extra.data.onApproveFunc = $onApproveFunc;
			extra.buttonMode = true;
			
			return extra;
		}
		
		public function createPluginBrowse($target:*, $alertTitle:String, $tooltipMsg:String, $approveBtnLabel:String="SELECT", $onApproveFunc:Function=null):*
		{
			var extra:* = new _base.getGraphic.pluginBtn();
			extra.addEventListener(MouseEvent.ROLL_OVER, onOver);
			extra.addEventListener(MouseEvent.ROLL_OUT, onOut);
			extra.addEventListener(MouseEvent.CLICK, onPluginBrowse);
			extra.data.alt = $tooltipMsg;
			extra.data.alertTitle = $alertTitle;
			extra.data.target = $target;
			extra.data.approveBtnLabel = $approveBtnLabel;
			extra.data.onApproveFunc = $onApproveFunc;
			extra.buttonMode = true;
			
			return extra;
		}
		
		public function createFontBrowse($target:*, $alertTitle:String, $tooltipMsg:String, $approveBtnLabel:String = "OK", $onApproveFunc:Function = null):*
		{
			var extra:* = new _base.getGraphic.fontBtn();
			extra.addEventListener(MouseEvent.ROLL_OVER, onOver);
			extra.addEventListener(MouseEvent.ROLL_OUT, onOut);
			extra.addEventListener(MouseEvent.CLICK, onFontBrowse);
			extra.data.alt = $tooltipMsg;
			extra.data.alertTitle = $alertTitle;
			extra.data.target = $target;
			extra.data.approveBtnLabel = $approveBtnLabel;
			extra.data.onApproveFunc = $onApproveFunc;
			extra.buttonMode = true;
			
			return extra;
		}
		
		private function onOver(e:MouseEvent):void
		{
			_base.getTooltip.mouseSpaceX = 20;
			_base.getTooltip.mouseSpaceY = 20;
			_base.getTooltip.delay = 0.5;
			_base.getTooltip.showText("<font face='Tahoma' size='11' color='#000000'>"+ e.currentTarget.data.alt +"</font>", "ltr");
		}
		
		private function onOut(e:MouseEvent):void
		{
			_base.getTooltip.hide();
		}
		
		private function onPreview(e:MouseEvent):void
		{
			_base.getAlert.getDll.clearEvents();
			_base.getAlert.getDll.w = 800;
			_base.getAlert.getDll.h = 450;
			_base.sizeRefresh();
			
			var format:TextFormat = new TextFormat();
			format.color = 0x333333;
			format.size = 13;
			format.font = "Arimo";
			
			var ta:TextArea = new TextArea();
			ta.condenseWhite = true;
			ta.mouseEnabled = false;
			ta.autoSize = TextFieldAutoSize.LEFT;
			ta.antiAliasType = AntiAliasType.ADVANCED;
			ta.multiline = true;
			ta.wordWrap = true;
			ta.embedFonts = true;
			
			ta.serverPath = e.currentTarget.data.projectPreviewPath;
			ta.assetsPath = e.currentTarget.data.projectPreviewPath + "fcms/assets/";
			ta.funcSecurity = false;
			ta.defaultTextFormat = format;
			ta.holder = this;
			ta.client = this; // must be where you have your 'allowed functions' saved
			
			e.currentTarget.data.target.getInputTxt.wordWrap = false;
			ta.fmlText = e.currentTarget.data.target.value;
			e.currentTarget.data.target.getInputTxt.wordWrap = true;
			
			
			ta.width = _base.getAlert.getDll.contentWidth - 2;
			
			_base.getAlert.getDll.title("Preview...", "Verdana", 0x333333, 18);
			_base.getAlert.setApproveSkin("OK");
			_base.getAlert.getDll.openAlert(ta, "Verdana", "approve");
			setTimeout(_base.sizeRefresh, 20);
		}
		
		private function onDoc(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(e.currentTarget.data.projectDocPath), "_blank");
		}
		
		private function onServerBrowse(e:MouseEvent):void
		{
			_base.getAlert.getDll.clearEvents();
			_base.getAlert.getDll.w = 800;
			_base.getAlert.getDll.h = 450;
			_base.getAlert.getDll.scrollerEnabled = false; // to remove the alert window scroller
			_base.sizeRefresh();
			
			var remoteBrowser:Browser = new Browser(true);
			remoteBrowser.addEventListener(RemoteEvent.FAULT, onRemoteBrowserFault);
			remoteBrowser.addEventListener(RemoteEvent.CONNECTING, onBrowserConnecting);
			remoteBrowser.addEventListener(RemoteEvent.RESULT, onBrowserResult);
			remoteBrowser.addEventListener(RemoteEvent.LOADING, onBrowserLoading);
			
			remoteBrowser.detailsWindow.loadingAnimation = new _base.getGraphic.simpleLoader01();
			
			// toolbar icons will be created in Toolbar.as , initIcons()
			remoteBrowser.setToolbarIcons = [ { name:"icon_newFolder", alt:"Create a new folder", icon:_base.getGraphic.addNewFolder, func:remoteBrowser.onNewFolder }, { name:"icon_upload_computer", alt:"Upload files from your computer", icon:_base.getGraphic.uploadFromComputer, func:remoteBrowser.onQuickUploadFromComputer } ];
			
			remoteBrowser.browseType = Browser.BROWSE_ALL;
			remoteBrowser.setTooltip = _base.getTooltip;
			//remoteBrowser.base = _base;
			remoteBrowser.limitToBase = true; // make sure you cannot go upper than "remoteBrowser.path"
			remoteBrowser.data.target = e.currentTarget.data.target;
			remoteBrowser.data.onApproveFunc = e.currentTarget.data.onApproveFunc;
			remoteBrowser.setIcons = { icon_dir:_base.getGraphic.iconDirectory, icon_file:_base.getGraphic.iconFile };
			remoteBrowser.importScroller(_base.getScroller.getClass, _base.getScroller.getDll);
			remoteBrowser.gateway = _base.gateway;
			remoteBrowser.phpClass = "browsing.ServerBrowse";
			remoteBrowser.path = "../" + _base.projectPath.substring(0, _base.projectPath.length - 1) + e.currentTarget.data.defLocation;
			remoteBrowser.previewPath = "amfphp/Services/browsing/";
			
			remoteBrowser.width = _base.getAlert.getDll.contentWidth - 1;
			remoteBrowser.height = _base.getAlert.getDll.contentHeight - 1;
			
			_base.getAlert.setApproveSkin(e.currentTarget.data.approveBtnLabel);
			_base.getAlert.getDll.addEventListener(AlertEvent.APPROVE, onRemoteBrowserApprove);
			_base.getAlert.getDll.addEventListener(AlertEvent.CLOSE, onAlertClose);
			_base.getAlert.getDll.title(e.currentTarget.data.alertTitle, "Verdana", 0x333333, 18);
			_base.getAlert.getDll.openAlert(remoteBrowser, "Verdana", "approve");
			
			function onRemoteBrowserFault(e:*):void
			{
				_base.getAlert.getDll.close();
				setTimeout(_base.onFault, 1000, e);
			}
			
			function onBrowserConnecting(e:RemoteEvent):void
			{
				_base.showPreloader(true);
			}
			
			function onBrowserResult(e:RemoteEvent):void
			{
				_base.showPreloader(false);
			}
			
			function onBrowserLoading(e:RemoteEvent):void
			{
				_base.showPreloader(e.param);
			}
			
			function onRemoteBrowserApprove(e:*):void
			{
				e.currentTarget.clearEvents();
				_base.getAlert.setApproveSkin("OK");
				
				setTimeout(dispatchResults, 500, _base.getAlert.getDll.content);
			}
			
			function dispatchResults($remoteBrowser:Browser):void
			{
				if ($remoteBrowser.data.onApproveFunc) $remoteBrowser.data.onApproveFunc($remoteBrowser);
				dispatchEvent(new PageEvent(PageEvent.ALERT_RESULT, {remoteBrowser:$remoteBrowser}));
			}
		}
		
		private function onPluginBrowse(e:MouseEvent):void
		{
			_base.getAlert.getDll.clearEvents();
			_base.getAlert.getDll.w = 600;
			_base.getAlert.getDll.h = 450;
			_base.getAlert.getDll.scrollerEnabled = true;
			_base.sizeRefresh();
			
			var pluginBrowser:PluginBrowser = new PluginBrowser();
			pluginBrowser.data.target = e.currentTarget.data.target;
			pluginBrowser.data.onApproveFunc = e.currentTarget.data.onApproveFunc;
			pluginBrowser.base = _base;
			pluginBrowser.width = _base.getAlert.getDll.contentWidth - 1;
			//pluginBrowser.height = 50;
			
			_base.getAlert.setApproveSkin(e.currentTarget.data.approveBtnLabel);
			_base.getAlert.getDll.addEventListener(AlertEvent.APPROVE, onPluginBrowserApprove);
			_base.getAlert.getDll.addEventListener(AlertEvent.CLOSE, onAlertClose);
			_base.getAlert.getDll.title(e.currentTarget.data.alertTitle, "Verdana", 0x333333, 18);
			_base.getAlert.getDll.openAlert(pluginBrowser, "Verdana", "approve");
			
			function onPluginBrowserApprove(e:*):void
			{
				e.currentTarget.clearEvents();
				_base.getAlert.setApproveSkin("OK");
				
				setTimeout(dispatchResults, 500, _base.getAlert.getDll.content);
			}
			
			function dispatchResults($pluginBrowser:PluginBrowser):void
			{
				$pluginBrowser.data.onApproveFunc($pluginBrowser.selectedPlugin, $pluginBrowser.data.target);
			}
		}
		
		private function onFontBrowse(e:MouseEvent):void
		{
			_base.getAlert.getDll.clearEvents();
			_base.getAlert.getDll.w = 800;
			_base.getAlert.getDll.h = 450;
			_base.getAlert.getDll.scrollerEnabled = false;
			_base.sizeRefresh();
			
			var pluginBrowser:FontBrowser = new FontBrowser();
			pluginBrowser.data.target = e.currentTarget.data.target;
			pluginBrowser.data.onApproveFunc = e.currentTarget.data.onApproveFunc;
			pluginBrowser.base = _base;
			pluginBrowser.width = _base.getAlert.getDll.contentWidth - 1;
			pluginBrowser.height = _base.getAlert.getDll.contentHeight - 1;
			
			_base.getAlert.setApproveSkin(e.currentTarget.data.approveBtnLabel);
			_base.getAlert.getDll.addEventListener(AlertEvent.APPROVE, onApprove);
			_base.getAlert.getDll.addEventListener(AlertEvent.CLOSE, onAlertClose);
			_base.getAlert.getDll.title(e.currentTarget.data.alertTitle, "Verdana", 0x333333, 18);
			_base.getAlert.getDll.openAlert(pluginBrowser, "Verdana", "approve");
			
			function onApprove(e:*):void
			{
				e.currentTarget.clearEvents();
				_base.getAlert.setApproveSkin("OK");
				
				setTimeout(dispatchResults, 500, _base.getAlert.getDll.content);
			}
			
			function dispatchResults($content:FontBrowser):void
			{
				//$pluginBrowser.data.onApproveFunc($pluginBrowser.selectedPlugin, $pluginBrowser.data.target);
				C.log("result: " + $content)
			}
		}
		
		private function onAlertClose(e:*=null):void
		{
			e.currentTarget.clearEvents();
			_base.getAlert.setApproveSkin("OK");
		}
		
		public function get base():Object
		{
			return _base;
		}
		
		public function set base(a:Object):void
		{
			_base = a;
		}
		
	}

}