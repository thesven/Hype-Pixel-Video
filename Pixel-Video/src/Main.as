package 
{
	import hype.extended.color.ColorPool;
	import hype.extended.layout.GridLayout;
	import hype.framework.core.ObjectPool;
	import hype.framework.core.TimeType;
	import hype.framework.display.BitmapCanvas;
	import hype.framework.interactive.HotKey;
	import hype.framework.rhythm.SimpleRhythm;

	import com.andersonranch.project.webcam.WebCamFeed;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	
	[SWF(backgroundColor="#000000", frameRate="30", width="640", height="480")]
	
	public class Main extends Sprite
	{
		
		private var cam:WebCamFeed;
		
		private var objContainer:Sprite;
		private var objPool:ObjectPool;
		private var colorPool:ColorPool;
		private var objLayout:GridLayout;
		private var checkRhythm:SimpleRhythm;
		private var hotKey:HotKey;
		private var bmc:BitmapCanvas;
		
		private var colorTransform:ColorTransform = new ColorTransform(1,1,1,1,-10,-1,-10,-10);
		
		private var isRunning:Boolean = false;
		
		public function Main()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void{
			
			removeEventListener(Event.ADDED_TO_STAGE, init);	
			
			cam = new WebCamFeed(stage.stageWidth, stage.stageHeight);
			addChild(cam);
			cam.visible = false;
			
			objContainer = new Sprite();
			addChild(objContainer);
			objContainer.visible = false;
			
			objLayout = new GridLayout(5, 5, 10, 10, 64);
			
			//colorPool = new ColorPool(0xFE4F4A, 0xDB1E13, 0xFE2C11, 0xFE4F27, 0xFD6D46, 0xFC9E57, 0x9D2E6B, 0xD7498F, 0xC43675, 0xBD3A74, 0xD73F75, 0xE43256, 0xFB4E6D, 0x9C0821, 0xC90D2C, 0xDA1E3D, 0xEF1428, 0xCC0416, 0xFC2E31);
			colorPool = new ColorPool(0x9DE204, 0x8ED104, 0x76BF04, 0x7DB40F, 0x5AA00A, 0x44850A, 0x326C06, 0x1D6105, 0x326F21, 0x1F6323, 0x1C5522);
			
			objPool = new ObjectPool([CircleAsset], 3072);
			objPool.onRequestObject = onPoolRequest;
			objPool.requestAll();
			
			bmc = new BitmapCanvas(stage.stageWidth, stage.stageHeight);
			addChild(bmc);
			bmc.startCapture(objContainer, true);
			
			hotKey = new HotKey(stage);
			hotKey.addHotKey(swapState, "s");
			
			checkRhythm = new SimpleRhythm(startPixelCheck);
			checkRhythm.start(TimeType.TIME, 65);
			
			isRunning = true;
			
		}
		
		private function onPoolRequest(clip:MovieClip):void{
			
			objLayout.applyLayout(clip);
			colorPool.colorChildren(clip);
			clip.alpha = 0;
			
			objContainer.addChild(clip);
			
		}
		
		private function startPixelCheck(r:SimpleRhythm):void{
			cam.takeSnapshot();
			objPool.activeSet.forEach(checkPointOnBitmap);
			bmc.colorTransform(colorTransform);
		}
		
		private function checkPointOnBitmap(clip:MovieClip):void{
			
			if("0x" + cam.getColorAtPoint(clip.x, clip.y).toString(16) == "0xffffff"){
				clip.alpha = 1;
			} else {
				clip.alpha = 0;
			}
			
		}
		
		private function swapState():void{
			
			isRunning = !isRunning;
			
			if(!isRunning){
				checkRhythm.stop();
			} else {
				checkRhythm.start();
			}
			
		}
		
	}
}
