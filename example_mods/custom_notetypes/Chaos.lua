--Idea by MoonScarf
--Created by Kevin Kuntz
function onCreatePost()
	for i = 0, getProperty('unspawnNotes.length') - 1 do
		sus = getPropertyFromGroup('unspawnNotes', i, 'isSustainNote')
		mustPress = getPropertyFromGroup('unspawnNotes', i, 'mustPress')
		noteType = getPropertyFromGroup('unspawnNotes', i, 'noteType')
		if noteType == 'Chaos' then
			if not sus then
				oFX = getPropertyFromGroup('unspawnNotes', i, 'offsetX')
			else
				susFX = getPropertyFromGroup('unspawnNotes', i, 'offsetX')
			end
			if mustPress then
				setPropertyFromGroup('unspawnNotes', i, 'offsetX', getPropertyFromGroup('unspawnNotes', i, 'offsetX') - 640)
			else
				setPropertyFromGroup('unspawnNotes', i, 'offsetX', getPropertyFromGroup('unspawnNotes', i, 'offsetX') + 640)
			end
        end
    end
end

function onUpdatePost(el)
    songPos = getSongPosition()
	local currentBeat = (getSongPosition() / 1000)*(bpm/60)
    for a = 0, getProperty('notes.length') - 1 do
        strumTime = getPropertyFromGroup('notes', a, 'strumTime')
		sus = getPropertyFromGroup('notes', a, 'isSustainNote')
		noteType = getPropertyFromGroup('notes', a, 'noteType')
        if noteType == 'Chaos' then
			if sus then
				setPropertyFromGroup('notes', a, 'offsetX', getPropertyFromGroup('notes', a, 'offsetX') + 3 * math.cos((currentBeat + a / scrollSpeed * 0.15) * (math.pi * 0.3)))
			end
			if (strumTime - songPos) < 1200 / scrollSpeed and not sus then
				if getPropertyFromGroup('notes', a, 'offsetX') ~= oFX then
					setPropertyFromGroup('notes', a, 'offsetX', lerp(getPropertyFromGroup('notes', a, 'offsetX'), oFX, boundTo(el * 25, 0, 1)))
				elseif getPropertyFromGroup('notes', a, 'offsetX') <= oFX then
					setPropertyFromGroup('notes', a, 'offsetX', oFX)
				end
			elseif (strumTime - songPos) < 1310 / scrollSpeed and sus then
				if getPropertyFromGroup('notes', a, 'offsetX') ~= susFX then
					setPropertyFromGroup('notes', a, 'offsetX', lerp(getPropertyFromGroup('notes', a, 'offsetX'), susFX, boundTo(el * 25, 0, 1)))
				elseif getPropertyFromGroup('notes', a, 'offsetX') <= susFX then
					setPropertyFromGroup('notes', a, 'offsetX', susFX)
				end
			end
        end
    end
end

function lerp(a, b, ratio)
  return math.floor(a + ratio * (b - a))
end

function boundTo(value, min, max)
	return math.max(min, math.min(max, value))
end

