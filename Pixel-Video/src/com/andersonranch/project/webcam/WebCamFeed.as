package com.andersonranch.project.webcam {
	import com.quasimondo.bitmapdata.ThresholdBitmap;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.media.Camera;
	import flash.media.Video;

	/**
	 * @author mikesven
	 */
	public class WebCamFeed extends Sprite {
		
		private var _width:int;
		private var _height:int;
		
		private var cam:Camera;
		private var video:Video;
		private var bitmap:Bitmap;
		private var bmd:BitmapData;
		private var thresholdData:ThresholdBitmap;
		
		public function WebCamFeed(camWidth:int, camHeight:int) {
		
			_width = camWidth;
			_height = camHeight;
			
			init();
		
		}
		
		public function takeSnapshot():void{
			
			thresholdData.draw(video, null, null);
			thresholdData.render();
			
		}
		
		public function getColorAtPoint(xLoc:int, yLoc:int):uint{
			
			return thresholdData.getPixel(xLoc, yLoc);
		
		}

		private function init() : void {
		
			video = new Video(_width, _height);
			cam	= Camera.getCamera();
			cam.setMode(_width / 2, _height / 2, 30);
			video.attachCamera(cam);
			
			bmd = new BitmapData(_width, _height, true, 0x00000000);
			
			thresholdData = new ThresholdBitmap(bmd);
			thresholdData.smooth = 1;
			thresholdData.applyDespeckle = true;
			thresholdData.thresholdValue = 127;
			thresholdData.adaptiveTolerance = 50;
			thresholdData.adaptiveRadius = 32;
			thresholdData.mode = ThresholdBitmap.ADAPTIVE;
			
			bitmap = new Bitmap(thresholdData);
			addChild(bitmap);
			
		}
		
	}
}
