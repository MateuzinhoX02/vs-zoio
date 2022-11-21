package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import WeekData;

using StringTools;

class ZoioState extends MusicBeatState
{
	var curSelected:Int = 1;
	var week1image:FlxSprite;
	var week2image:FlxSprite;
	var bg:FlxSprite;
	var txtBG:FlxSprite;
	var txtInfo:String = ".";
	var txtDisp:FlxText;
	var songArray = ['cigarro-outset', 'alekness', 'hellek', 'zapurgation'];
	var songArray2 = ['cigarro-outset', 'alekness', 'hellek', 'zapurgation']; //colocar o nome das outras músicas aqui, talvez secretos, idk

	override function create()
	{
		bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		week1image = new FlxSprite().loadGraphic(Paths.image('menu_asset/weekTricky'));
		week1image.antialiasing = ClientPrefs.globalAntialiasing;
		week1image.visible = true;
		add(week1image);

		week2image = new FlxSprite().loadGraphic(Paths.image('menu_asset/weekZoio'));
		week2image.antialiasing = ClientPrefs.globalAntialiasing;
		week2image.visible = false;
		add(week2image);

		textBG = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);

		txtDisp = new FlxText(textBG.x, textBG.y + 4, FlxG.width, txtInfo, 18);
		txtDisp.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		txtDisp.scrollFactor.set();
		add(txtDisp);

		super.create();
	}


	override function update(elapsed:Float)
	{
			txtInfo.text = "Week selecionada: " + WeekData.weeksList[curWeek];

			if (controls.UI_DOWN_P)
			{
				curSelected = 2;
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			
			if (controls.UI_UP_P)
			{
				if(curSelected == 2) 
				{
					curSelected = 1;
				} 
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}

			if (controls.ACCEPT)
			{
				receba();
			}

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	function receba()
	{
			FlxG.sound.play(Paths.sound('confirmMenu'));

			// Nevermind that's stupid lmao
			if(curSelected == 1) 
			{
			PlayState.storyPlaylist = songArray;
			}
			else 
			{
			PlayState.storyPlaylist = songArray2;
			}
			PlayState.isStoryMode = true;

			PlayState.storyDifficulty = '-hard';

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + '-hard', PlayState.storyPlaylist[0].toLowerCase());
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			PlayState.campaignMisses = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState(), true);
				FreeplayState.destroyFreeplayVocals();
			});
		} else {
			FlxG.sound.play(Paths.sound('cancelMenu'));
	}
