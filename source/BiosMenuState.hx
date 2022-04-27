package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.util.FlxTimer;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class BiosMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.5.1-git'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;
	var bioText:FlxText;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var chars:Array<String> = [
		'silver',
		'dark',
		'terios',
		'sonai'
	];
	var bios:Array<String> = [];
	var charSprites:Map<String, Dynamic> = [];
	var portSprites:Map<String, Dynamic> = [];
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	override function create()
	{
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Bios Menu", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;
		
		var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('bios/bg'));
		bg.scrollFactor.set(0, 0);
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		
		// magenta.scrollFactor.set();
		
		var uiShadow:FlxSprite = new FlxSprite(725.05, 209).loadGraphic(Paths.image('bios/hover'));
		uiShadow.setGraphicSize(554);
		uiShadow.updateHitbox();
		uiShadow.scrollFactor.set();
		add(uiShadow);
		
		var plate:FlxSprite = new FlxSprite(237.05, 535.05).loadGraphic(Paths.image('bios/plate'));
		plate.setGraphicSize(812);
		plate.updateHitbox();
		plate.scrollFactor.set();
		plate.antialiasing = ClientPrefs.globalAntialiasing;
		add(plate);
		
		var chalkboard:FlxSprite = new FlxSprite(78, 96.05).loadGraphic(Paths.image('bios/chalkboard'));
		chalkboard.setGraphicSize(562);
		chalkboard.updateHitbox();
		chalkboard.scrollFactor.set();
		chalkboard.antialiasing = ClientPrefs.globalAntialiasing;
		add(chalkboard);
		
		//stupid fucking way to precache al lof this shit so that it doesnt lag when selected i know just WHATEVER RAAGH IS UCK AT CODING FUUCK
		
		for (i in 0...chars.length)
		{
			var charSpr:FlxSprite = new FlxSprite();
			charSpr.frames = Paths.getSparrowAtlas('bios/menu_chars');
			charSpr.animation.addByPrefix(chars[i], chars[i], 24, false);
			charSpr.animation.play(chars[i], true);
			switch (chars[i])
			{
				case 'silver':
					bios[i] = "Silver Sonic\nVoiced by Luckiibean\nSonic's first robotic doppelganger created by Dr.Eggman.\n\nThis guy has made an appearance in:\nSonic 2 8-BIT, Sonic Mania and both the Archie and IDW comics.";
					charSpr.setGraphicSize(208);
					charSpr.setPosition(880.85, 209);
				case 'dark':
					bios[i] = "Dark Sonic\nVoiced by Snap\nOne of Sonic's many super forms,\nmanifested from his anger & the energy from counterfeit Chaos Emeralds\nAlthough, he only appeared once in\nSonic X in The Season 3 Episode: Testing Time.";
					charSpr.setGraphicSize(273);
					charSpr.setPosition(847.35, 83.45);
				case 'terios':
					bios[i] = "Terios\nVoiced by Begwhi\nA character based on one of Shadow's original character designs for:\nSonic Adventure 2\n\nGiven the name Terios (or Umbra) by the community.";
					charSpr.setGraphicSize(283);
					charSpr.setPosition(867, 122.4);
				case 'sonai':
					bios[i] = "Extrapolator/SonAI\nExtrapolator (or SonAI for short) is Simply EJ's EXE take on the blue blur. \nIn summary, its an AI that was meant to assist in making Sonic 2 that was\nreactivated in a corrupted copy of the game,\nyears after it's released causing it to be corrupted itself.";
					charSpr.setGraphicSize(305);
					charSpr.setPosition(855.6, 107.5);
			}
			charSpr.updateHitbox();
			charSpr.scrollFactor.set();
			charSpr.ID = i;
			charSprites[chars[i]] = charSpr;
			add(charSpr);
			
			var portrait:FlxSprite = new FlxSprite().loadGraphic(Paths.image('bios/portrait-' + chars[i]));
			portrait.setGraphicSize(296);
			switch (chars[i])
			{
				case 'silver':
					portrait.setPosition(234, 132);
				default:
					portrait.setPosition(234, 128);
			}
			portrait.updateHitbox();
			portrait.scrollFactor.set();
			portrait.ID = i;
			portSprites[chars[i]] = portrait;
			add(portrait);
		}
		
		bioText = new FlxText(0, 0, 0, "Dark Sonic\rVoiced by Snap\rOne of Sonic's many super forms,\rachieved from his anger and the energy from counterfeit Chaos Emeralds \rAlthough, this only appeared once in Sonic X Season 3 Episode 67 Testing Time.", 12);
		bioText.setFormat("PhantomMuff 1.5", 16, FlxColor.WHITE, CENTER);
		bioText.scrollFactor.set();
		bioText.fieldWidth = -5;
		bioText.wordWrap = false;
		bioText.autoSize = false;
		bioText.setPosition(plate.getMidpoint().x - 325, plate.getMidpoint().y - 60);
		add(bioText);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
			
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);

		if (!selectedSomethin)
		{
			if (controls.UI_LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}
			
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);
	}
	
	override function beatHit()
	{
		super.beatHit();

		if (charSprites[chars[curSelected]] != null && curBeat % 1 == 0)
			charSprites[chars[curSelected]].animation.play(chars[curSelected], true);
	}


	function changeItem(huh:Int = 0)
	{
		curSelected += huh;
		if (curSelected >= chars.length) //revert back to without - 1
			curSelected = 0;
		if (curSelected < 0)
			curSelected = chars.length - 1; //revert back to - 1
		
		for (sprite in charSprites)
		{
			if (sprite.ID == curSelected)
			{
				charSprites[chars[curSelected]].animation.play(chars[curSelected], true);
				sprite.visible = true;
			}
			else
				sprite.visible = false;
		}
		
		for (sprite in portSprites)
		{
			if (sprite.ID == curSelected)
				sprite.visible = true;
			else
				sprite.visible = false;
		}
		
		bioText.text = bios[curSelected];
	}
}
