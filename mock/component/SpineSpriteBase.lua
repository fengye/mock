module 'mock'

CLASS: SpineSpriteBase ()
	:MODEL{
		Field 'sprite' :asset('spine') :getset('Sprite') :label('Sprite');
	}

function SpineSpriteBase:__init()
	self.skeleton  = self:_createSkeleton()
	self.propInserted  = false
end

function SpineSpriteBase:_createSkeleton()
	return MOAISpineSkeleton.new()
end

function SpineSpriteBase:onAttach( entity )
	entity:_attachProp( self.skeleton )
end

function SpineSpriteBase:onDetach( entity )
	entity:_detachProp( self.skeleton )
	self.skeleton:forceUpdateSlots()
end

function SpineSpriteBase:setSprite( path, alphaBlend )
	alphaBlend = alphaBlend~=false
	self.spritePath   = path	
	self.skeletonData = loadAsset( path )
	if self.skeletonData  then
		local entity = self._entity
		if entity then
			entity:_detachProp( self.skeleton )		
			self.skeleton  = self:_createSkeleton()
			self.skeleton:load( self.skeletonData, 0.001, true )
			entity:_attachProp( self.skeleton )
		else
			self.skeleton:load( self.skeletonData, 0.001, true )
		end
	end
end

function SpineSpriteBase:getSprite()
	return self.spritePath
end

function SpineSpriteBase:setMixTable( t )
	self.mixTable = t
end

function SpineSpriteBase:getMixTable()
	return self.mixTable
end

function SpineSpriteBase:affirmClip( name )
	local t = self.skeletonData._animationTable
	return t[ name ]
end

function SpineSpriteBase:getClipLength( name )
	--TODO
	return 1
end
