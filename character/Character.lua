module 'character'
--------------------------------------------------------------------
CLASS: Character ( mock.Behaviour )
	:MODEL{
		Field 'config'  :asset('character') :getset( 'Config' );
		Field 'default' :string();
	}

function Character:__init()
	self.config      = false
	self.default     = 'default'
	self.activeState = false
	self.spineSprite = mock.SpineSprite()
	self.soundSource = mock.SoundSource()
end

function Character:setConfig( configPath )
	self.configPath = configPath
	self.config = mock.loadAsset( configPath )
	self:updateConfig()
end

function Character:getConfig()
	return self.configPath
end

function Character:updateConfig()
	local config = self.config
	if not config then return end
	local path = config:getSpine()
	self.spineSprite:setSprite( path )
	--todo
end

function Character:playAction( name )
	if not self.config then
		_warn('character has no config')
		return false
	end
	local action = self.config:getAction( name )
	if not action then
		_warn( 'character has no action', name )
		return false
	end
	local actionState = action:createState( self )
	self.activeState = actionState
	actionState:start()
	return actionState
end

function Character:stop()
	if not self.activeState then return end
	self.activeState:stop()
	self.activeState = false
	self.spineSprite:stop()
end

-----
function Character:onStart( ent )
	ent:attach( self.spineSprite )
	ent:attach( self.soundSource )
	if self.default and self.config then
		if self.default == '' then return end
		self:playAction( self.default )
	end
end

function Character:onDetach( ent )
	ent:detach( self.spineSprite )
	return mock.Behaviour.onDetach( self, ent )
end
------
--EVENT ACTION:
function Character:playAnim( clip, loop )
	self.spineSprite:play( clip, loop and MOAITimer.LOOP )
end

function Character:stopAnim()
	self.spineSprite:stop()
end

--------------------------------------------------------------------
mock.registerComponent( 'Character', Character )
