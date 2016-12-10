package com.doitflash.mobileProject.commonCpuSrc.plugins.WP
{
	import flash.events.Event;
	import flash.system.System;
	import flash.utils.setTimeout;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	
	import com.doitflash.text.modules.MyMovieClip;
	import com.doitflash.remote.wp.WordPressParser;
	import com.doitflash.events.WpEvent;
	
	import com.doitflash.mobileProject.commonCpuSrc.plugins.WP.assets.CommentMc;
	import com.doitflash.mobileProject.commonCpuSrc.plugins.WP.toolbar.Toolbar;
	import com.doitflash.mobileProject.commonCpuSrc.plugins.WP.posts.Posts;
	import com.doitflash.mobileProject.commonCpuSrc.plugins.WP.comments.Comments;
	import com.doitflash.mobileProject.commonCpuSrc.plugins.WP.comments.Reply;
	import com.doitflash.mobileProject.commonCpuSrc.events.AppEvent;
	
	import pl.mateuszmackowiak.nativeANE.dialogs.NativeTextField;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 5/1/2012 11:25 AM
	 */
	public class WordPress extends MyMovieClip 
	{
		private var _backBtnEngaged:Boolean;
		private var _toolbar:Toolbar;
		private var _posts:Posts;
		private var _comments:Comments;
		private var _reply:Reply;
		
		private var _currPostData:Object; // when you select a post, its data will be saved here also
		
		private var _stageWebView:*;
		private var _rect:Rectangle;
		
		private var _wpParser:WordPressParser;
		
		private var _vibe:*;
		private var _searchDialog:*;
		private var _keyword:String = "";
		
		public function WordPress():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			//_margin = 10;
			/*_bgAlpha = 1;
			_bgColor = 0xFF0FFF;
			_bgStrokeAlpha = 1;
			_bgStrokeColor = 0xCCCCCC;
			_bgStrokeThickness = 10;
			drawBg();*/
			
		}
		
		private function stageRemoved(e:Event = null):void 
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			_base.removeEventListener(AppEvent.BACK_BUTTON_CLICK, onDeviceBackButtClick);
			_base.networkMonitor.removeEventListener(AppEvent.NETWORK_STATUS, onNetStatus);
			
			// dispose xml objects
			System.disposeXML(_xml);
			if(_toolbar) System.disposeXML(_toolbar.xml);
			if(_toolbar) System.disposeXML(_toolbar.configXml);
			if(_posts) System.disposeXML(_posts.configXml);
			if(_comments) System.disposeXML(_comments.configXml);
			
			this.removeChild(_toolbar);
			_toolbar = null;
			
			this.removeChild(_posts);
			_posts = null;
			
			_wpParser.clearEvents();
		}
		
		private function stageAdded(e:Event = null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			_base.addEventListener(AppEvent.BACK_BUTTON_CLICK, onDeviceBackButtClick);
			_base.networkMonitor.addEventListener(AppEvent.NETWORK_STATUS, onNetStatus);
			
			
			//_base.c.log(">> ", _data.type, " - ", _data.id, " - ", _data.content)
			
			/*var x:XML = new XML(
			<data>
				<wp>http://192.168.1.20/wordpress/</wp>
				<icons>
					<item name="SEARCH" label="search" />
					<item name="POSTS" label="posts" />
				</icons>
			</data>
			);
			
			trace(escape(x.toXMLString()));*/
			
			//<item name="CATS" label="categories" />
			//<item name="PAGES" label="pages" />
			
			_xml = new XML(unescape(_data.content)); // save the xml object
			_wpParser = new WordPressParser(_xml.wp.text(), 2);
			_wpParser.cache(_base.sql, _base.xml.appName.text(), _data.localDb);
			_wpParser.addEventListener(WpEvent.NETWORK_STATUS, onNetworkStatus);
			//_wpParser.addEventListener(WpEvent.UPDATE_AVAILABLE, onPostsUpdateAvailable);
			_wpParser.addEventListener(WpEvent.RECENT_POSTS, onRecentPosts);
			_wpParser.addEventListener(WpEvent.POST_CONTENT, onPostContentListener);
			_wpParser.addEventListener(WpEvent.SEARCH_RESULT, onSearchResult);
			_wpParser.addEventListener(WpEvent.SUBMIT_COMMENT, onCommentResult);
			_wpParser.networkAvailable = _base.networkMonitor.available;
			//_wpParser.networkAvailable = false;
			initToolbar();
			
			onResize();
			
			setTimeout(dispatch, 150);
			setTimeout(loadDefault, 1500);
			function dispatch():void
			{
				dispatchEvent(new AppEvent(AppEvent.MODULE_READY));
			}
			
			function loadDefault():void
			{
				initPosts();
				onResize();
			}
		}
		
		private	function onNetStatus(e:AppEvent):void
		{
			_wpParser.networkAvailable = e.param.available;
		}
		
// ----------------------------------------------------------------------------------------------------------------------- funcs
		
		private function initToolbar():void
		{
			_toolbar = new Toolbar();
			_toolbar.addEventListener(AppEvent.REQUEST_DATA, onNavRequest, false, 0, true);
			_toolbar.xml = new XML(_xml.icons);
			_toolbar.configXml = new XML(_xml.config.title);
			_toolbar.base = _base;
			
			this.addChild(_toolbar);
		}
		
		private function onNavRequest(e:AppEvent):void
		{
			if (!_base.networkMonitor.available)
			{
				_base.showPreloader(true, "network connection error");
				
				_backBtnEngaged = true;
				this.dispatchEvent(new AppEvent(AppEvent.BACK_BUTTON_ENGAGED, _backBtnEngaged));
				
				return;
			}
			
			switch (String(e.param.name)) 
			{
				case "SEARCH":
					
					if (_base.nativeExtensions.nativeTextInputDialog.isSupported)
					{
						if (!_searchDialog) _searchDialog = new _base.nativeExtensions["nativeTextInputDialog"]();
						_searchDialog.theme = _base.nativeExtensions["nativeAlert"].ANDROID_HOLO_LIGHT_THEME;
						_searchDialog.addEventListener(_base.nativeExtensions.nativeDialogEvent.CLOSED, onSearchdialogHandler, false, 0, true);
						
						var v:Vector.<NativeTextField> = new Vector.<NativeTextField>();
						var ti:* = new _base.nativeExtensions["nativeTextField"]("keyword");
						ti.prompText = "search";
						ti.text = "";
						v.push(ti);
						
						var b:Vector.<String> = new Vector.<String>();
						b.push("cancel", "Search");
						
						_searchDialog.show(v, b);
						
					}
					
				break;
				case "POSTS":
					
					onDeviceBackButtClick();
					onDeviceBackButtClick();
					
					_posts.isSearch = false;
					_posts.clean();
					_wpParser.posts.clean();
					initPosts();
					
				break;
				default:
			}
		}
		
		private function initPosts():void
		{
			if (!_posts) _posts = new Posts();
			_posts.addEventListener(AppEvent.REQUEST_RECENT_POSTS, requestPosts, false, 0, true);
			_posts.addEventListener(AppEvent.REQUEST_POST, toShowPostContent, false, 0, true);
			_posts.base = _base;
			_posts.configXml = new XML(_xml.config.list);
			
			this.addChild(_posts);
			
			requestPosts();
		}
		
		private function requestPosts(e:AppEvent=null):void
		{
			if (_posts.isSearch)
			{
				if (_wpParser.searchPosts && _wpParser.searchPosts.loadedPosts.length == _wpParser.searchPosts.totalPosts) return;
				
				_base.showPreloader(true);
				_wpParser.search(null);
			}
			else
			{
				if (_wpParser.posts && _wpParser.posts.loadedPosts.length == (_wpParser.posts.totalPosts - _wpParser.posts.updates)) return;
				
				_base.showPreloader(true);
				_wpParser.getRecentPosts();
			}
		}
		
		private function onRecentPosts(e:WpEvent):void
		{
			_base.showPreloader(false);
			_posts.update(e.param);
		}
		
		private function onSearchResult(e:WpEvent):void
		{
			_base.showPreloader(false);
			_posts.update(e.param);
		}
		
		private function onPostContentListener(e:WpEvent):void
		{
			_base.showPreloader(false);
			
			if (!_stageWebView) _stageWebView = new _base.deviceInfo.stageWebView();
			if (!_rect) _rect = new Rectangle(0, _toolbar.height, _width, _height - _toolbar.height);
			
			_posts.visible = false;
			
			_stageWebView.stage = this.stage;
			_stageWebView.loadString(e.param.content);
			
			if (e.param.comment_status == "open")
			{
				var commentMc:CommentMc = new CommentMc();
				commentMc.addEventListener(MouseEvent.CLICK, toShowComments);
				//commentMc.data = e.param;
				commentMc.label_txt.text = e.param.comment_count;
				_toolbar._list_right.add(commentMc);
			}
			
			_currPostData = e.param;
			
			onResize();
		}
		
		private function toShowPostContent(e:AppEvent):void
		{
			_backBtnEngaged = true;
			this.dispatchEvent(new AppEvent(AppEvent.BACK_BUTTON_ENGAGED, _backBtnEngaged));
			
			if (_base.nativeExtensions.vibration.isSupported) 
			{ 
				if(!_vibe) _vibe = new _base.nativeExtensions["vibration"](); 
				_vibe.vibrate(25);
			}
			
			_base.showPreloader(true);
			if (e.param.type == "post") _wpParser.getPost(e.param.id);
			//else if (e.param.type == "page") _wpParser.getPage(e.param.id);
		}
		
		private function toShowComments(e:MouseEvent):void
		{
			e.target.removeEventListener(MouseEvent.CLICK, toShowComments);
			_stageWebView.dispose();
			_stageWebView = null;
			
			initComments(_currPostData);
		}
		
		private function onNetworkStatus(e:WpEvent):void
		{
			//_base.c.log(e.param.status, " = ", e.param.msg)
			//trace(e.param.status, " = ", e.param.msg)
			_base.showPreloader(true, e.param.msg);
		}
		
		private function initComments($data:Object):void
		{
			_toolbar._list_right.removeAll();
			createGeneralReply($data);
			
			_comments = new Comments();
			_comments.addEventListener(AppEvent.WP_REPLY, initReply);
			_comments.base = _base;
			_comments.data = $data;
			_comments.configXml = new XML(_xml.config.comments);
			
			this.addChild(_comments);
			onResize();
			
			_backBtnEngaged = true;
			this.dispatchEvent(new AppEvent(AppEvent.BACK_BUTTON_ENGAGED, _backBtnEngaged));
		}
		
		private function initReply(e:*):void
		{
			var var1:Number = 0;
			var var2:Number = _currPostData.id;
			try 
			{
				var1 = e.param.id; // we're replying to this id
			}
			catch (err:Error) { };
			
			_toolbar._list_right.removeAll();
			
			_reply = new Reply();
			_reply.addEventListener(AppEvent.SUBMIT_COMMENT, onSubmitComment, false, 0, true);
			_reply.base = _base;
			_reply.data = _currPostData;
			_reply.data.comment_parent = var1;
			_reply.data.post_id = var2;
			
			_comments.visible = false;
			
			this.addChild(_reply);
			onResize();
			
			_backBtnEngaged = true;
			this.dispatchEvent(new AppEvent(AppEvent.BACK_BUTTON_ENGAGED, _backBtnEngaged));
		}
		
		private function onSubmitComment(e:AppEvent):void
		{
			_base.showPreloader(true);
			_wpParser.submitComment(e.param.name, e.param.email, e.param.content, e.param.post_id, e.param.comment_parent);
		}
		
		private function onCommentResult(e:WpEvent):void
		{
			
			if (e.param.status == "error")
			{
				_base.showPreloader(true, e.param.msg);
				setTimeout(hide, 2500);
			}
			else if (e.param.status == "pending")
			{
				//_base.showPreloader(true, "");
				_base.showPreloader(true, _xml.config.comments.commentStatus.pending.text());
				setTimeout(hide, 2500, true);
			}
			else if (e.param.status == "ok")
			{
				_base.showPreloader(true, _xml.config.comments.commentStatus.ok.text());
				setTimeout(hide, 2500, true);
			}
			
			function hide($close:Boolean=false):void
			{
				_base.showPreloader(false);
				if ($close)
				{
					onDeviceBackButtClick();
					onDeviceBackButtClick();
				}
				
			}
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Helpful Funcs

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_toolbar)
			{
				_toolbar.x = _toolbar.y = 0;
				_toolbar.width = _width;
				_toolbar.height = 50;
			}
			
			if (_posts)
			{
				_posts.width = _width;
				_posts.height = _height - _toolbar.height;
				_posts.y = _toolbar.height;
			}
			
			if (_stageWebView && _stageWebView.stage)
			{
				_rect.topLeft = new Point(0, _toolbar.height);
				_rect.bottomRight = new Point(_width, _height);
				_stageWebView.viewPort = _rect;
			}
			
			if (_comments)
			{
				_comments.width = _width;
				_comments.height = _height - _toolbar.height;
				_comments.y = _toolbar.height;
			}
			
			if (_reply)
			{
				_reply.width = _width;
				_reply.height = _height - _toolbar.height;
				_reply.y = _toolbar.height;
			}
		}
		
		private function createGeneralReply($data:Object):void
		{
			var commentMc:CommentMc = new CommentMc();
			commentMc.addEventListener(MouseEvent.CLICK, initReply, false, 0, true);
			commentMc.data = $data;
			commentMc.label_txt.text = "Re";
			_toolbar._list_right.add(commentMc);
		}
		
		private function onDeviceBackButtClick(e:AppEvent=null):void
		{
			if (_base.preloaderMc.visible)
			{
				if (!_base.networkMonitor.available)
				{
					_backBtnEngaged = false;
					this.dispatchEvent(new AppEvent(AppEvent.BACK_BUTTON_ENGAGED, _backBtnEngaged));
				}
				
				_base.showPreloader(false);
				return;
			}
			
			if (_stageWebView && _stageWebView.stage)
			{
				_stageWebView.dispose();
				_stageWebView = null;
				
				_posts.visible = true;
				
				_toolbar._list_right.removeAll();
				
				_backBtnEngaged = false;
				this.dispatchEvent(new AppEvent(AppEvent.BACK_BUTTON_ENGAGED, _backBtnEngaged));
			}
			
			if (_reply)
			{
				_toolbar._list_right.removeAll();
				createGeneralReply(_reply.data);
				
				_comments.visible = true;
				
				this.removeChild(_reply);
				_reply = null;
				
				return;
			}
			
			if (_comments)
			{
				this.removeChild(_comments);
				_comments = null;
				
				_posts.visible = true;
				
				_toolbar._list_right.removeAll();
				
				_backBtnEngaged = false;
				this.dispatchEvent(new AppEvent(AppEvent.BACK_BUTTON_ENGAGED, _backBtnEngaged));
			}
		}
		
		private function onSearchdialogHandler(e:*):void
		{
			_searchDialog.removeEventListener(e.type, onSearchdialogHandler);
			
			_keyword = e.target.textInputs[0].text;
			if (e.index > 1 && _keyword.length > 0)
			{
				_posts.clean();
				_posts.isSearch = true;
				_wpParser.search(_keyword);
				_base.showPreloader(true);
				
				onDeviceBackButtClick();
				onDeviceBackButtClick();
			}
		}
	
// ----------------------------------------------------------------------------------------------------------------------- Methods

		

// ----------------------------------------------------------------------------------------------------------------------- Properties

		public function get backBtnEngaged():Boolean
		{
			return _backBtnEngaged;
		}
		
	}
	
}