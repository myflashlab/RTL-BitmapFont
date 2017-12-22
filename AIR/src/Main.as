package
{

import flash.events.Event;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;
import starling.core.Starling;

/**
 * ...
 * @author Hadi Tavakoli
 */
[SWF(width="800", height="600", frameRate="60", backgroundColor="#808080")]
public class Main extends Sprite
{
	public var _starling:Starling;
	
	public function Main():void
	{
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		
		// touch or gesture?
		Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
		
		// entry point
		if(stage) init(); else addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(e:Event = null):void
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		
		stage.addEventListener(Event.RESIZE, onResize);
	}
	
	private function onResize(e:Event):void
	{
		stage.removeEventListener(Event.RESIZE, onResize);
		
		MainApp.theBase = this;
		
		_starling = new Starling(MainApp, stage);
		_starling.start();
	}
	
}
	
}