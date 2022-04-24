function onCreate()
	
	--Makes the gloop sprite and marks down its animations
	makeLuaSprite('Background','stages/met/floor',0, -28.1)
	--setProperty('Background.antialiasing',false)
	
	makeAnimatedLuaSprite('badnik', 'stages/met/badnik', 1901.85, 666.95)
	addAnimationByPrefix('badnik', 'dance', 'badnikbop', 24, false)
	objectPlayAnimation('badnik', 'dance', true)
	setGraphicSize('badnik', getProperty('badnik.width') * 1.5)
	updateHitbox('badnik')

	addLuaSprite('Background',false)
	addLuaSprite('badnik',false)

	--close(true)	
end

function onBeatHit()
	-- triggered 4 times per section
	
	if curBeat % 2 == 0 then
		objectPlayAnimation('badnik', 'dance', true);
	end
	
end

function onUpdate(elapsed)

    if not mustHitSection then
		setProperty('defaultCamZoom',0.7)
	else
		setProperty('defaultCamZoom',0.8)
	end
end

function onCountdownTick(counter)
	if curBeat % 2 == 0 then
		objectPlayAnimation('badnik', 'dance', true);
	end
end