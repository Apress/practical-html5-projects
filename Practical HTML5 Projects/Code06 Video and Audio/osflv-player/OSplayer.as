package 
{
	import flash.display.*;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.*;
	import fl.video.FLVPlayback;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.media.SoundTransform;
	import flash.events.FullScreenEvent;
	import fl.video.VideoEvent;
	import fl.video.VideoState;


	import fl.transitions.*;
	import fl.transitions.easing.*;

	import flash.system.Security;

	public class OSplayer extends osflv
	{
		private var _videoPlayback:FLVPlayback = new FLVPlayback();
		private var _textError:TextField = new TextField();

		private var _controlBar:MovieClip = new MovieClip ();
		private var _playBtn:Sprite = new Sprite ();
		private var _pauseBtn:Sprite = new Sprite ();
		private var _volumeBtn:Sprite = new Sprite ();
		private var _volPanel:MovieClip = new MovieClip ();
		private var _volArea:Sprite = new Sprite ();
		private var _volPost:Sprite = new Sprite ();
		private var _volPostFill:Sprite = new Sprite ();
		private var _volSlider:Sprite = new Sprite ();
		var volumeOnShow:Boolean = false;
		private var vol:Number;
		private var musicVol:SoundTransform;
		private var _fullscreenBtn:Sprite = new Sprite ();

		private var _progBar:Sprite = new Sprite ();
		private var _progBarShell:Sprite = new Sprite ();
		private var _seekBarShell:Sprite = new Sprite ();
		private var _seekBar:Sprite = new Sprite ();
		private var _blankBar:Sprite = new Sprite ();

		private var _timePassed:TextField = new TextField ();
		private var _timeTotal:TextField = new TextField ();
		private var _timeDiv:TextField = new TextField ();

		private var _tTime:int;
		private var _pTime:int;

		private var integer:String;
		private var decimal:String;
		private var timeval:String;

		private var _replayBkg:Sprite = new Sprite ();
		private var _replayGraphic:replay = new replay ();

		//private var _playBkg:Sprite = new Sprite();
		private var _playGraphic:bPlay = new bPlay ();

		private var matrix:Matrix = new Matrix ();

		private var _imgLd:Loader = new Loader ();
		private var _imgContainer:Sprite = new Sprite ();
		private var _imgMask:Sprite = new Sprite ();

		private var _autoLoad:Boolean = true;
		private var _autoPlay:Boolean = true;
		private var _vUrl:String;

		private var _prevImg:String;

		private var playerWidth:int;
		private var playerHeight:int;
		private var buttonColor:uint;
		private var accentColor:uint;
		private var txtColor:uint;
		private var initialVolume:int;
		private var vmute:Boolean = false;

		private var div1:Sprite = new Sprite ();
		private var div2:Sprite = new Sprite ();
		private var div3:Sprite = new Sprite ();
		private var div4:Sprite = new Sprite ();

		private var _preLoader:preLoader = new preLoader ();

		var firstDraw:Boolean = true;

		var replayVisible = false;
		var timer:Timer = new Timer(2000);

		public function OSplayer()
		{
			stage.align = "TL";
			stage.scaleMode = "noScale";

			

			this.init();
		}

		public function init()
		{
			// Flash Vars
			var _video:String = LoaderInfo(this.root.loaderInfo).parameters.movie;
	
			var _pWidth:int = LoaderInfo(this.root.loaderInfo).parameters.width;
			var _pHeight:int = LoaderInfo(this.root.loaderInfo).parameters.height;
			var _accColor:uint = LoaderInfo(this.root.loaderInfo).parameters.accentcolor;
			var _btnColor:uint = LoaderInfo(this.root.loaderInfo).parameters.btncolor;
			var _txtColor:uint = LoaderInfo(this.root.loaderInfo).parameters.txtcolor;
			var _initVol:int = LoaderInfo(this.root.loaderInfo).parameters.volume;
			var _mute:String = LoaderInfo(this.root.loaderInfo).parameters.mute;
			var _autoplay:String = LoaderInfo(this.root.loaderInfo).parameters.autoplay;
			var _autoload:String = LoaderInfo(this.root.loaderInfo).parameters.autoload;
			var _previewImage:String = LoaderInfo(this.root.loaderInfo).parameters.previewimage;

			if (_mute == null)
			{
				_mute = "off";
			}

			if (_initVol > 95)
			{
				_initVol = 95;
			}

			_vUrl = _video;
			playerWidth = _pWidth;
			playerHeight = _pHeight;
			buttonColor = _btnColor;
			accentColor = _accColor;
			txtColor = _txtColor;
			initialVolume = _initVol;
			_prevImg = _previewImage;

			if (_mute == "off")
			{
				vmute = false;
			}
			else if (_mute == "on")
			{
				vmute = true;

			}// Button event listeners
			_volumeBtn.addEventListener(MouseEvent.MOUSE_OVER,adjustVolume);
			_volumeBtn.addEventListener(MouseEvent.MOUSE_OUT,timeoutcloseVolume);
			_volumeBtn.addEventListener(MouseEvent.CLICK,adjustVolumeMute);
			_fullscreenBtn.addEventListener(MouseEvent.CLICK,setFullScreen);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN,fsEvent);
			addEventListener(Event.ENTER_FRAME,updateProgBar);
			addEventListener(Event.ENTER_FRAME,loadPlayer);
			_pauseBtn.addEventListener(MouseEvent.CLICK,pauseVideo);
			_playBtn.addEventListener(MouseEvent.CLICK,playVideo);
			_videoPlayback.addEventListener(VideoEvent.COMPLETE,onVideoEnded);

			this.draw();

			if (_playBtn.visible == true)
			{
				_pauseBtn.visible = false;
			}

			if (_autoplay == "on")
			{
				_autoload = "on";
				_autoLoad = true;
				_autoPlay = true;
			}
			else if (_autoplay != "on" && _autoload != "on")
			{
				_autoPlay = false;
				_autoLoad = false;
			}
			else if (_autoplay != "on" && _autoload == "on")
			{
				_autoPlay = false;
				_autoLoad = true;
			}

			if (_videoPlayback.state == VideoState.PLAYING)
			{
				_playGraphic.visible = false;
			}

			// Add objects to the stage 
			addChild(_videoPlayback);

			addChild(_volPanel);
			_volPanel.addChild(_volPost);
			_volPanel.addChild(_volSlider);

			addChild(_controlBar);
			addChild(_playBtn);
			addChild(_pauseBtn);
			addChild(_volumeBtn);
			addChild(_fullscreenBtn);

			addChild(_progBarShell);

			addChild(_seekBarShell);
			addChild(_seekBar);
			addChild(_progBar);
			addChild(_blankBar);

			addChild(_timePassed);
			addChild(_timeTotal);
			addChild(_timeDiv);

			addChild(_replayBkg);
			addChild(_replayGraphic);

			addChild(_imgContainer);

			//addChild(_playBkg);
			addChild(_playGraphic);

			addChild(_textError);

			addChild(div1);
			addChild(div2);
			addChild(div3);
			addChild(div4);

			addChild(_preLoader);
		}

		public function draw():void
		{

			

			matrix.createGradientBox(stage.stageWidth,0,50,0,0);

			// Display error message if video path is null or incorrect
			_textError.defaultTextFormat = new TextFormat("Arial",13,0xffffff,true);
			_textError.text = "There is no video path specified.";
			_textError.x = (stage.stageWidth / 2) - 110;
			_textError.y = (stage.stageHeight - 25) / 2;
			_textError.width = 220;
			_textError.visible = false;

			// Set up Control Bar
			_controlBar.graphics.beginGradientFill("linear",[0x555555,0x888888],[1,1],[0x00,0xFF],matrix,"pad","RGB",0);
			_controlBar.graphics.drawRect(0,0,stage.stageWidth,25);
			_controlBar.graphics.endFill();
			_controlBar.width = stage.stageWidth;
			_controlBar.x = 0;
			_controlBar.y = stage.stageHeight - 25;


			_playBtn.graphics.lineStyle(2,buttonColor,1.0,false,"normal",null,"round",3);
			_playBtn.graphics.beginFill(buttonColor);
			_playBtn.graphics.moveTo(0,0);
			_playBtn.graphics.lineTo(8,5);
			_playBtn.graphics.lineTo(0,10);
			_playBtn.graphics.lineTo(0,0);
			_playBtn.graphics.endFill();
			_playBtn.buttonMode = true;

			_playBtn.x = _controlBar.x + 12;
			_playBtn.y = _controlBar.y + 6;

			_pauseBtn.graphics.lineStyle(2,buttonColor,1.0,false,"normal",null,"round",3);
			_pauseBtn.graphics.beginFill(buttonColor);
			_pauseBtn.graphics.moveTo(0,0);
			_pauseBtn.graphics.drawRect(0,0,2,8);
			_pauseBtn.graphics.moveTo(5,0);
			_pauseBtn.graphics.drawRect(5,0,2,8);
			_pauseBtn.buttonMode = true;

			_pauseBtn.x = _controlBar.x + 11;
			_pauseBtn.y = _controlBar.y + 8;

			_volumeBtn.graphics.lineStyle(1,buttonColor,1.0,false,"normal",null,"round",3);
			_volumeBtn.graphics.beginFill(buttonColor);
			_volumeBtn.graphics.moveTo(7,0);
			_volumeBtn.graphics.lineTo(2,3);
			_volumeBtn.graphics.lineTo(0,3);
			_volumeBtn.graphics.lineTo(0,6);
			_volumeBtn.graphics.lineTo(2,6);
			_volumeBtn.graphics.lineTo(7,9);
			_volumeBtn.graphics.lineTo(7,0);
			_volumeBtn.graphics.endFill();
			_volumeBtn.graphics.moveTo(10,1);
			_volumeBtn.graphics.curveTo(12,2,12,5);
			_volumeBtn.graphics.curveTo(12,7,10,9);
			_volumeBtn.graphics.moveTo(12,-1);
			_volumeBtn.graphics.curveTo(15,1,15,5);
			_volumeBtn.graphics.curveTo(15,9,12,11);
			_volumeBtn.buttonMode = true;

			_volPanel.graphics.lineStyle(1,0x333333,1.0,false,"normal",null,"round",3);
			_volPanel.graphics.beginFill(0x888888,.8);
			_volPanel.graphics.drawRoundRect(0,0,30,110,3,3);

			_volPanel.x = stage.stageWidth - 34 - _volPanel.width;
			_volPanel.y = stage.stageHeight - 25 - (_volPanel.height -1);
			_volPanel.visible = false;

			_volPost.graphics.beginFill(accentColor);
			_volPost.graphics.drawRoundRect(0,0,6,_volPanel.height - 10,2,2);
			_volPost.graphics.endFill();

			_volPost.x = _volPanel.width / 2 - 3;
			_volPost.y = 5;

			_volPostFill.graphics.beginFill(accentColor);
			_volPostFill.graphics.drawRoundRect(0,0,6,_volPanel.height - 10,2,2);
			_volPostFill.graphics.endFill();

			_volPostFill.x = _volPanel.width / 2 - 3;
			_volPostFill.y = 5;



			_volSlider.graphics.beginFill(0x333333);
			_volSlider.graphics.drawRoundRect(0,0,11,6,3,3);
			_volSlider.graphics.endFill();
			_volSlider.buttonMode = true;

			if (firstDraw == true)
			{

			_volSlider.x = _volPost.x + _volPost.width / 2 - _volSlider.width / 2;
			_volSlider.y = (1 - (initialVolume / 100)) * 100;
			if (firstDraw == true)
			{
				// Setup Video Playback
			
			_videoPlayback.height = stage.stageHeight;
			_videoPlayback.width = stage.stageWidth;
			_videoPlayback.y =( stage.stageHeight / 2 - _videoPlayback.height / 2)-25;
			_videoPlayback.x = stage.stageWidth / 2 - _videoPlayback.width / 2;


				if (vmute == true)
				{
					vol = 0;
					_volSlider.y = 100;
					musicVol = new SoundTransform(vol);
				}

				if (vmute == false)
				{
					_volSlider.y = (1 - (initialVolume / 100)) * 100;

					vol = 1 - ((_volSlider.y - 5) / 100);
					musicVol = new SoundTransform(vol);
				}


				_videoPlayback.soundTransform = musicVol;
			}
			
				
				

				
			}

			_fullscreenBtn.graphics.lineStyle(2,buttonColor,1.0,false,"normal",null,"round",3);
			_fullscreenBtn.graphics.beginFill(buttonColor);
			_fullscreenBtn.graphics.moveTo(0,0);
			_fullscreenBtn.graphics.drawRoundRect(0,0,18,12,2,2);
			_fullscreenBtn.graphics.endFill();
			_fullscreenBtn.graphics.lineStyle(2,buttonColor,1.0,false,"normal",null,"round",3);
			_fullscreenBtn.graphics.beginFill(0x888888);
			_fullscreenBtn.graphics.moveTo(0,0);
			_fullscreenBtn.graphics.drawRoundRect(0,0,11,7,2,2);
			_fullscreenBtn.buttonMode = true;

			_fullscreenBtn.x = _controlBar.x + _controlBar.width - (_fullscreenBtn.width + 8);
			_fullscreenBtn.y = _controlBar.y + 6;

			_volumeBtn.x = _controlBar.x + _fullscreenBtn.x - (_volumeBtn.width + 12);
			_volumeBtn.y = _controlBar.y + 7;

			_progBarShell.graphics.beginFill(0x555555);
			_progBarShell.graphics.drawRect(0,0,_controlBar.width - (_volumeBtn.width + _fullscreenBtn.width + _playBtn.width + 50),25);
			_progBarShell.graphics.endFill();

			_progBarShell.x = _controlBar.x + _playBtn.x + _playBtn.width + 10;
			_progBarShell.y = _controlBar.y;

			_progBarShell.width = _controlBar.width - 160;



			_blankBar.graphics.beginFill(0x3d3d3,0);

			_blankBar.graphics.drawRect(0,0,_controlBar.width - (_volumeBtn.width + _fullscreenBtn.width + _playBtn.width + 50),25);
			_blankBar.graphics.endFill();


			_blankBar.x = _controlBar.x + _playBtn.x + _playBtn.width + 10;
			_blankBar.y = _controlBar.y;
			_blankBar.buttonMode = true;

			_blankBar.width = _controlBar.width - 160;

			_progBar.graphics.beginFill(accentColor);
			_progBar.graphics.drawRect(0,0,_progBarShell.width,25);
			_progBar.graphics.endFill();

			_progBar.x = _controlBar.x + _playBtn.x + _playBtn.width + 10;
			_progBar.y = _controlBar.y;

			//seek bar
			_seekBarShell.graphics.beginFill(0x555555);
			_seekBarShell.graphics.drawRect(0,0,_controlBar.width - (_volumeBtn.width + _fullscreenBtn.width + _playBtn.width + 50),25);
			_seekBarShell.graphics.endFill();

			_seekBarShell.x = _controlBar.x + _playBtn.x + _playBtn.width + 10;
			_seekBarShell.y = _controlBar.y;

			_seekBarShell.width = _controlBar.width - 160;

			_seekBar.graphics.beginFill(0xbebebe);
			_seekBar.graphics.drawRect(0,0,_seekBarShell.width,25);
			_seekBar.graphics.endFill();

			_seekBar.x = _controlBar.x + _playBtn.x + _playBtn.width + 10;
			_seekBar.y = _controlBar.y;



			_timePassed.defaultTextFormat = new TextFormat("Arial",9,txtColor,false);
			_timePassed.text = "00:00";
			_timePassed.width = 50;

			_timePassed.x = _progBarShell.x + _progBarShell.width + 5;
			_timePassed.y = _progBarShell.y + 5;

			_timeTotal.defaultTextFormat = new TextFormat("Arial",9,txtColor,false);
			_tTime = _videoPlayback.totalTime;
			_timeTotal.text = "00:00";
			_timeTotal.width = 30;

			_timeTotal.x = _progBarShell.x + _progBarShell.width + 36;
			_timeTotal.y = _progBarShell.y + 5;

			_timeDiv.defaultTextFormat = new TextFormat("Arial",9,txtColor,false);
			_timeDiv.text = "/";
			_timeDiv.width = 10;

			_timeDiv.x = _timePassed.x + 26;
			_timeDiv.y = _timePassed.y;

			_replayBkg.graphics.beginFill(0x000000,.3);
			_replayBkg.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			_replayBkg.graphics.endFill();
			_replayBkg.visible = false;
			//_replayBkg.x = 0;
			//_replayBkg.y = 0;

			_replayBkg.width = stage.stageWidth;
			_replayBkg.height = stage.stageHeight - 25;

			_replayGraphic.x = (_replayBkg.width - _replayGraphic.width) / 2;
			_replayGraphic.y = (_replayBkg.height - _replayGraphic.height) / 2;
			_replayGraphic.buttonMode = enabled;
			if (replayVisible==false){
			_replayGraphic.visible = false;}
			else _replayGraphic.visible = true;

			/*_playBkg.graphics.beginFill(0x000000, .7);
			_playBkg.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight - 25);
			_playBkg.graphics.endFill();
			
			_playBkg.x = 0;
			_playBkg.y = 0;
			_playBkg.visible = false;*/

			//_playBkg.width = stage.stageWidth;
			//_playBkg.height = stage.stageHeight - 25;

			_playGraphic.x = (stage.stageWidth - _playGraphic.width) / 2;
			_playGraphic.y = ((stage.stageHeight - 25) - _playGraphic.height) / 2;
			_playGraphic.buttonMode = enabled;
			_playGraphic.visible = false;

			div1.graphics.lineStyle(1,0x999999);
			div1.graphics.moveTo(0,0);
			div1.graphics.lineTo(0,25);
			div1.graphics.endFill();
			div1.x = _progBarShell.x - 1;
			div1.y = _controlBar.y;

			div2.graphics.lineStyle(1,0x999999);
			div2.graphics.moveTo(0,0);
			div2.graphics.lineTo(0,25);
			div2.graphics.endFill();
			div2.x = _progBarShell.x + _progBarShell.width;
			div2.y = _controlBar.y;

			div3.graphics.lineStyle(1,0x999999);
			div3.graphics.moveTo(0,0);
			div3.graphics.lineTo(0,25);
			div3.graphics.endFill();
			div3.x = _timePassed.x + 60;
			div3.y = _controlBar.y;

			div4.graphics.lineStyle(1,0x999999);
			div4.graphics.moveTo(0,0);
			div4.graphics.lineTo(0,25);
			div4.graphics.endFill();
			div4.x = _volumeBtn.x + _volumeBtn.width + 5;
			div4.y = _controlBar.y;

			_preLoader.x = stage.stageWidth / 2;
			_preLoader.y = ((stage.stageHeight - 25) / 2);
			_preLoader.visible = false;
			
			_progBar.width = 0;

			firstDraw = false;

		}



		public function loadPlayer(e:Event)
		{
			// Check for video
			if (_vUrl == "movieurl")
			{
				_textError.visible = true;
				//_playBkg.visible = false;
				_playGraphic.visible = false;
				_preLoader.visible = false;
			}

			if (_vUrl != "movieurl" && _autoLoad == true)
			{
				_videoPlayback.load(_vUrl);
				_videoPlayback.addEventListener(VideoEvent.READY,loadPlayerComplete);
			}
			else
			{
				_preLoader.visible = false;
				loadPlayVideo();
			}

			if (_autoLoad == true)
			{
				if (_videoPlayback.bytesLoaded < _videoPlayback.bytesTotal - 1 && _vUrl != "movieurl" && _videoPlayback.state != VideoState.PLAYING && _playBtn.visible == false)
				{

					_preLoader.visible = true;
					_preLoader.play();
				}
				else if ((_videoPlayback.bytesLoaded >= _videoPlayback.bytesTotal && _vUrl != "movieurl") || _videoPlayback.state == VideoState.PLAYING)
				{
					_preLoader.stop();
					_preLoader.visible = false;


				}
			}
		}

		public function loadPlayerComplete(e:VideoEvent):void
		{
			// If autoplay is true, autoload also has to be true
			if (_autoPlay == true)
			{
				_videoPlayback.play();
				_fullscreenBtn.mouseEnabled = true;
				_volumeBtn.mouseEnabled = true;
				_pauseBtn.visible = true;
				_playBtn.visible = false;
				_playGraphic.visible = false;
			}
			else
			{
				_videoPlayback.pause();
				_playBtn.visible = true;
				_pauseBtn.visible = false;
				//_playBkg.visible = true;
				_playGraphic.visible = true;

				this.setPrevImage();

				_fullscreenBtn.mouseEnabled = false;
				_volumeBtn.mouseEnabled = false;

				_playGraphic.addEventListener(MouseEvent.CLICK,playVideo);
			}
			
		}

		public function pauseVideo(e:MouseEvent)
		{
			
			_videoPlayback.pause();
			_pauseBtn.visible = false;
			_playBtn.visible = true;
			
		}

		public function playVideo(e:MouseEvent)
		{
			_videoPlayback.play();

			if (_imgContainer.visible == true)
			{
				_imgContainer.visible = false;
			}

			if (_playGraphic.visible == true)
			{
				//_playBkg.visible = false;
				_playGraphic.visible = false;
			}
			else if (_playGraphic.visible == true)
			{
				_imgContainer.visible = false;
				_playGraphic.visible = false;
			}

			_playBtn.visible = false;
			_pauseBtn.visible = true;

			_fullscreenBtn.mouseEnabled = true;
			_volumeBtn.mouseEnabled = true;
			
		}

		public function loadPlayVideo():void
		{
			if (_videoPlayback.state == VideoState.DISCONNECTED)
			{
				_playBtn.visible = true;
				_pauseBtn.visible = false;
				//_playBkg.visible = true;
				_playGraphic.visible = true;
			}

			this.setPrevImage();

			_fullscreenBtn.mouseEnabled = false;
			_volumeBtn.mouseEnabled = false;

			_playGraphic.addEventListener(MouseEvent.CLICK,startVideo);
			
		}

		public function startVideo(e:MouseEvent)
		{
			_videoPlayback.load(_vUrl);

			if (_videoPlayback.bytesLoaded < _videoPlayback.bytesTotal - 1 && _vUrl != "movieurl" && _videoPlayback.state != VideoState.PLAYING)
			{
				_preLoader.visible = true;
				_preLoader.play();
			}
			else if ((_videoPlayback.bytesLoaded >= _videoPlayback.bytesTotal && _vUrl != "movieurl") || _videoPlayback.state == VideoState.PLAYING)
			{
				_preLoader.stop();
				_preLoader.visible = false;
				_replayGraphic.visible = false;
			}

			_fullscreenBtn.mouseEnabled = true;
			_volumeBtn.mouseEnabled = true;
			_pauseBtn.visible = true;
			_playBtn.visible = false;
			_playGraphic.visible = false;

			_videoPlayback.addEventListener(VideoEvent.READY,playNow);
		}

		public function playNow(e:VideoEvent):void
		{
			_videoPlayback.play();
			
		}

		public function setPrevImage():void
		{
			// Check for preview image and setup display
			if (_prevImg == null || _prevImg == "previewimageurl")
			{

			}
			else
			{
				_imgMask.graphics.beginFill(0xffffff,0);
				_imgMask.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight - 25);
				_imgMask.graphics.endFill();

				_imgLd.load(new URLRequest(_prevImg));
				_imgContainer.addChild(_imgLd);
				_imgContainer.mask = _imgMask;
				_imgContainer.visible = true;

				_imgContainer.x = 0;
				_imgContainer.y = 0;
			}
			
		}

		public function updateProgBar(e:Event)
		{
			
			_blankBar.addEventListener(MouseEvent.CLICK,seekProgBar);


			_seekBar.width = Math.floor((_videoPlayback.bytesLoaded / _videoPlayback.bytesTotal) * (_controlBar.width - 160));
			
			if(_videoPlayback.playheadTime >0.25) {
			_progBar.width = Math.floor((_videoPlayback.playheadTime  / _videoPlayback.totalTime) * (_controlBar.width - 160));
			}

			var tTime = Math.floor(_videoPlayback.totalTime);
			var tMinutes = Math.floor(tTime/60);
			var tSeconds = tTime - (tMinutes*60);

			var time = Math.floor(_videoPlayback.playheadTime);
			var seconds = int;
			var minutes = int;

			var pTime = int;
			var tTimeMin = int;
			var tTimeSec = int;

			if (tMinutes < 10)
			{
				tMinutes = "0" + tMinutes;
			}
			if (tSeconds < 10)
			{
				tSeconds = "0" + tSeconds;
			}

			if (_autoLoad == false && _playGraphic.visible == true || _vUrl == "movieurl")
			{
				_timeTotal.text = "00:00";
			}
			else
			{
				_timeTotal.text = tMinutes + ":" + tSeconds;
			}

			if (_videoPlayback.playheadTime >= 58)
			{
				minutes = Math.floor(time / 60);
				seconds = time - (minutes * 60);

				if (minutes < 10)
				{
					tTimeMin = "0" + minutes;
				}
				else if (minutes >= 10)
				{
					tTimeMin = minutes;

				}
				if (seconds < 10)
				{
					tTimeSec = "0" + seconds;
				}
				else if (seconds >= 10)
				{
					tTimeSec = seconds;

				}
				_timePassed.text = tTimeMin + ":" + tTimeSec;
			}
			else if (_videoPlayback.playheadTime < 59)
			{
				seconds = time;

				if (seconds < 10)
				{
					pTime = "0" + seconds;
				}
				else if (seconds >= 10)
				{
					pTime = seconds;

				}
				_timePassed.text = "00:" + pTime;
			}
			
			if (_videoPlayback.playheadTime >= _videoPlayback.totalTime)
			{
				trace('entro');
				if (replayVisible == true)
				{
					//_replayBkg.visible = true;

					_playBtn.visible = false;
					_pauseBtn.visible = true;
					_pauseBtn.mouseEnabled = false;
					_volumeBtn.mouseEnabled = false;
					_videoPlayback.pause();
					_replayGraphic.visible = true;
					_blankBar.mouseEnabled = false;

				}
				replayVisible = true;
				_replayGraphic.addEventListener(MouseEvent.CLICK,replayVideo);
			}
			
		}

		public function replayVideo(e:MouseEvent)
		{
			
			
			_blankBar.mouseEnabled = false;
			_replayBkg.visible = false;
			_pauseBtn.mouseEnabled = true;
			_volumeBtn.mouseEnabled = true;
			_blankBar.mouseEnabled = true;
			_replayGraphic.visible = false;
			replayVisible = false;
			// Reset progress bar position and play video
			_progBar.width = 0;
			_videoPlayback.playheadTime = 0;
			//_videoPlayback.totalTime =100;


			_videoPlayback.play();


			

			_fullscreenBtn.mouseEnabled = true;
		}
		public function onVideoEnded(e:VideoEvent){
			
			
					//_replayBkg.visible = true;

					_playBtn.visible = false;
					_pauseBtn.visible = true;
					_pauseBtn.mouseEnabled = false;
					_volumeBtn.mouseEnabled = false;
					_videoPlayback.pause();
					_replayGraphic.visible = true;
					_blankBar.mouseEnabled = false;

				
				
				replayVisible = true;
				_replayGraphic.addEventListener(MouseEvent.CLICK,replayVideo);
			}
		public function seekProgBar(e:MouseEvent)
		{
			
			_progBar.width = ((mouseX - 32) * _videoPlayback.totalTime) / _blankBar.width;
			_videoPlayback.playheadTime = _progBar.width;
			
		}

		public function adjustVolume(e:MouseEvent)
		{
			
			_volPanel.x = stage.stageWidth - 34 - _volPanel.width;
			_volPanel.y = stage.stageHeight - 25 - _volPanel.height - 1;
			_volPanel.visible = true;
			_volSlider.addEventListener(MouseEvent.MOUSE_DOWN,startVolDrag);
			_volPanel.addEventListener(MouseEvent.MOUSE_OUT,timeoutcloseVolume);
			_volPanel.addEventListener(MouseEvent.MOUSE_OVER,timestopcloseVolume);


		}
		function timestopcloseVolume(e:MouseEvent)
		{
			
			timer.stop();
		}
		function timeoutcloseVolume(e:MouseEvent)
		{
			
			timer.addEventListener(TimerEvent.TIMER,closeVolume);
			timer.start();
		}
		public function adjustVolumeMute(e:MouseEvent)
		{
			
			_volSlider.y = 100;

			vol = 1 - ((_volSlider.y - 5) / 100) - .05;

			musicVol = new SoundTransform(vol);

			_videoPlayback.soundTransform = musicVol;



		}
		public function startVolDrag(e:MouseEvent)
		{
			
			_volSlider.startDrag(true,new Rectangle((_volPanel.width / 2 - 5),5,0,95));

			_volSlider.addEventListener(MouseEvent.MOUSE_UP,stopVolDrag);
			_volSlider.addEventListener(MouseEvent.MOUSE_UP,closeVolume);
		}

		public function stopVolDrag(e:MouseEvent)
		{
			vol = (1 - ((_volSlider.y - 5) / 100)) - .05;
			musicVol = new SoundTransform(vol);

			_videoPlayback.soundTransform = musicVol;

			_volSlider.stopDrag();
		}

		public function closeVolume(e:Event)
		{
			volumeOnShow = false;
			timer.stop();
			TransitionManager.start(_volPanel,{type:Fade,direction:Transition.OUT,duration:.3,easing:None.easeNone,startPoint:1});

		}

		public function setFullScreen(e:MouseEvent)
		{
			

			if (stage.displayState == StageDisplayState.NORMAL)
			{


				stage.displayState = StageDisplayState.FULL_SCREEN;
				_videoPlayback.fullScreenTakeOver = false;

				_videoPlayback.height = stage.stageHeight;
				_videoPlayback.width = stage.stageWidth;
				_videoPlayback.y =( stage.stageHeight / 2 - _videoPlayback.height / 2)-25;
				_videoPlayback.x = stage.stageWidth / 2 - _videoPlayback.width / 2;
			}
			else if (stage.displayState == StageDisplayState.FULL_SCREEN)
			{
				stage.displayState = StageDisplayState.NORMAL;
				
				_videoPlayback.width = stage.stageWidth ;
				_videoPlayback.height = stage.stageHeight ;
				_videoPlayback.y =( stage.stageHeight / 2 - _videoPlayback.height / 2)-25;
				_videoPlayback.x = stage.stageWidth / 2 - _videoPlayback.width / 2;
				
				
			}
		}

		public function fsEvent(event:FullScreenEvent):void
		{
			
			_videoPlayback.height = stage.stageHeight;
			_videoPlayback.width = stage.stageWidth;

			

			draw();
		}
	}
}