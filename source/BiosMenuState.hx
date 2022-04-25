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

	var charSpr:FlxSprite;
	var portrait:FlxSprite;
	var bioText:FlxText;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var chars:Array<String> = [
		'silver',
		'dark',
		'terios',
		'sonai'
	];

	var magenta:FlxSprite;
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

		camGame = new FlxCamera();

		FlxG.cameras.reset(camGame);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;
		
		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(0).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.set(0, 0);
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFFF282E;
		add(magenta);
		
		// magenta.scrollFactor.set();
		
		var uiShadow:FlxSprite = new FlxSprite(725.05, 209).loadGraphic(Paths.image('bios/hover'));
		uiShadow.setGraphicSize(554);
		uiShadow.updateHitbox();
		uiShadow.scrollFactor.set();
		add(uiShadow);
		
		//stupid fucking way to load al lof this shit so that it doesnt lag when selected i know just WHATEVER RAAGH IS UCK AT CODING FUUCK
		
		charSpr = new FlxSprite(867, 122.4);
		charSpr.frames = Paths.getSparrowAtlas('characters/terios', 'shared');
		charSpr.animation.addByPrefix('idle', 'Terios IDLE0', 24, false);
		charSpr.animation.play('idle', true);
		charSpr.setGraphicSize(283);
		charSpr.updateHitbox();
		charSpr.scrollFactor.set();
		add(charSpr);
		
		remove(charSpr);
		charSpr.kill();
		charSpr = new FlxSprite(880.85, 209);
		charSpr.frames = Paths.getSparrowAtlas('characters/Proto_Silver_Sonic', 'shared');
		charSpr.animation.addByPrefix('idle', 'Proto IDLE', 24, false);
		charSpr.animation.play('idle', true);
		charSpr.setGraphicSize(208);
		charSpr.updateHitbox();
		charSpr.scrollFactor.set();
		add(charSpr);
		
		remove(charSpr);
		charSpr.kill();
		charSpr = new FlxSprite(847.35, 83.45);
		charSpr.frames = Paths.getSparrowAtlas('characters/DarkSonic_Assets', 'shared');
		charSpr.animation.addByPrefix('idle', 'Dark Sonic IDLE', 24, false);
		charSpr.animation.play('idle', true);
		charSpr.setGraphicSize(278);
		charSpr.updateHitbox();
		charSpr.scrollFactor.set();
		add(charSpr);
		
		remove(charSpr);
		charSpr.kill();
		charSpr = new FlxSprite(855.6, 107.5);
		charSpr.frames = Paths.getSparrowAtlas('characters/impo', 'shared');
		charSpr.animation.addByPrefix('idle', 'SAI IDLE', 24, false);
		charSpr.animation.play('idle', true);
		charSpr.setGraphicSize(305);
		charSpr.updateHitbox();
		charSpr.scrollFactor.set();
		add(charSpr);
		
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
		
		portrait = new FlxSprite(234, 128).loadGraphic(Paths.image('bios/portrait-dark'));
		portrait.setGraphicSize(296);
		portrait.updateHitbox();
		portrait.scrollFactor.set();
		portrait.antialiasing = ClientPrefs.globalAntialiasing;
		add(portrait);
		
		remove(portrait);
		portrait.destroy();
		portrait = new FlxSprite(234, 128).loadGraphic(Paths.image('bios/portrait-silver'));
		portrait.setGraphicSize(296);
		portrait.updateHitbox();
		portrait.scrollFactor.set();
		portrait.antialiasing = ClientPrefs.globalAntialiasing;
		add(portrait);
		
		remove(portrait);
		portrait.destroy();
		portrait = new FlxSprite(234, 128).loadGraphic(Paths.image('bios/portrait-terios'));
		portrait.setGraphicSize(296);
		portrait.updateHitbox();
		portrait.scrollFactor.set();
		portrait.antialiasing = ClientPrefs.globalAntialiasing;
		add(portrait);
		
		remove(portrait);
		portrait.destroy();
		portrait = new FlxSprite(234, 128).loadGraphic(Paths.image('bios/portrait-sonai'));
		portrait.setGraphicSize(296);
		portrait.updateHitbox();
		portrait.scrollFactor.set();
		portrait.antialiasing = ClientPrefs.globalAntialiasing;
		add(portrait);
		
		bioText = new FlxText(0, 0, 0, "Dark Sonic\rVoiced by Snap\rOne of Sonic's many super forms,\rachieved from his anger and the energy from counterfeit Chaos Emeralds \rAlthough, this only appeared once in Sonic X Season 3 Episode 67 Testing Time.", 12);
		bioText.setFormat("PhantomMuff 1.5", 16, FlxColor.WHITE, CENTER);
		bioText.scrollFactor.set();
		bioText.setPosition(plate.getMidpoint().x - 325, plate.getMidpoint().y - 60);
		add(bioText);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		FlxG.camera.follow(camFollowPos, null, 1);

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
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

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

		if (charSpr != null && curBeat % 1 == 0)
			charSpr.animation.play('idle', true);
	}


	function changeItem(huh:Int = 0)
	{
		curSelected += huh;
		
		bioText.fieldWidth = -5;
		bioText.wordWrap = false;
		bioText.autoSize = false;
		if (curSelected >= chars.length) //revert back to without - 1
			curSelected = 0;
		if (curSelected < 0)
			curSelected = chars.length - 1; //revert back to - 1
			
		remove(portrait);
		portrait.destroy();
		portrait = new FlxSprite(234, 128).loadGraphic(Paths.image('bios/portrait-'+chars[curSelected]));
		portrait.setGraphicSize(296);
		portrait.updateHitbox();
		portrait.scrollFactor.set();
		portrait.antialiasing = ClientPrefs.globalAntialiasing;
		add(portrait);
		charSpr.offset.y = 0;
			
		switch (curSelected) // 0 = silver, 1 = dark, 2 = terios, 3 = sonai
		{
			case 0:
				remove(charSpr);
				charSpr.kill();
				charSpr = new FlxSprite(880.85, 209);
				charSpr.frames = Paths.getSparrowAtlas('characters/Proto_Silver_Sonic', 'shared');
				charSpr.animation.addByPrefix('idle', 'Proto IDLE', 24, false);
				charSpr.animation.play('idle', true);
				charSpr.setGraphicSize(208);
				charSpr.updateHitbox();
				charSpr.scrollFactor.set();
				charSpr.offset.y = -10;
				add(charSpr);
				
				bioText.text = "Silver Sonic\nVoiced by Luckiibean\nSonic's first robotic doppelganger created by Dr.Eggman.\n\nThis guy has made an appearance in:\nSonic 2 8-BIT, Sonic Mania and both the Archie and IDW comics.";
			case 1:
				remove(charSpr);
				charSpr.kill();
				charSpr = new FlxSprite(847.35, 83.45);
				charSpr.frames = Paths.getSparrowAtlas('characters/DarkSonic_Assets', 'shared');
				charSpr.animation.addByPrefix('idle', 'Dark Sonic IDLE', 24, false);
				charSpr.animation.play('idle', true);
				charSpr.setGraphicSize(278);
				charSpr.updateHitbox();
				charSpr.scrollFactor.set();
				add(charSpr);
				
				bioText.text = "Dark Sonic\nVoiced by Snap\nOne of Sonic's many super forms,\nmanifested from his anger & the energy from counterfeit Chaos Emeralds\nAlthough, he only appeared once in\nSonic X in The Season 3 Episode: Testing Time.";
			case 2:
				remove(charSpr);
				charSpr.kill();
				charSpr = new FlxSprite(867, 122.4);
				charSpr.frames = Paths.getSparrowAtlas('characters/terios', 'shared');
				charSpr.animation.addByPrefix('idle', 'Terios IDLE0', 24, false);
				charSpr.animation.play('idle', true);
				charSpr.setGraphicSize(283);
				charSpr.updateHitbox();
				charSpr.scrollFactor.set();
				add(charSpr);
				
				bioText.text = "Terios\nVoiced by Begwhi\nA character based on one of Shadow's original character designs for:\nSonic Adventure 2\n\nGiven the name Terios (or Umbra) by the community.";
			case 3:
				remove(charSpr);
				charSpr.kill();
				charSpr = new FlxSprite(855.6, 107.5);
				charSpr.frames = Paths.getSparrowAtlas('characters/impo', 'shared');
				charSpr.animation.addByPrefix('idle', 'SAI IDLE', 24, false);
				charSpr.animation.play('idle', true);
				charSpr.setGraphicSize(305);
				charSpr.updateHitbox();
				charSpr.scrollFactor.set();
				add(charSpr);
				bioText.text = "Extrapolator/SonAI\nExtrapolator (or SonAI for short) is Simply EJ's EXE take on the blue blur. \nIn summary, its an AI that was meant to assist in making Sonic 2 that was\nreactivated in a corrupted copy of the game,\nyears after it's released causing it to be corrupted itself.";
		}
	}
}
