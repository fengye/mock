module 'mock'

--------------------------------------------------------------------
CLASS: EffectNode  ()
CLASS: EffectGroup ( EffectNode )
CLASS: EffectRoot  ( EffectGroup )

----------------------------------------------------------------------
--CLASS: EffectNode
--------------------------------------------------------------------
EffectNode :MODEL {
		Field 'name'     :string();
		Field 'children' :array( EffectNode ) :no_edit();
		Field 'parent'   :type( EffectNode ) :no_edit();
	}

function EffectNode:__init()
	self._built   = false
	self.parent   = false
	self.children = {}
	self.name     = self:getDefaultName()
end

function EffectNode:getDefaultName()
	return 'effect'
end

function EffectNode:getTypeName()
	return 'node'
end

function EffectNode:setName( n )
	self.name = n
end

function EffectNode:findChild( name )
	for i, c in pairs( self.children ) do
		if c.name == name then return c end
	end
	return nil
end

function EffectNode:addChild( n, idx )
	if n.parent then
		n.parent:removeChild( n )
	end
	if idx then
		table.insert( self.children, idx, n )
	else
		table.insert( self.children, n )
	end
	n.parent = self
end

function EffectNode:removeChild( n )	
	for i, c in ipairs( self.children ) do
		if c == n then
			table.remove( self.children, i )
			n.parent = false
			return
		end
	end
end

function EffectNode:build( state )
	-- print('building', self:getClassName() )
	self:onBuild( state )
	for i, child in pairs( self.children ) do
		child:build( state )
	end
	self:postBuild( state )
	self._built = true
	return true
end

function EffectNode:onBuild( state )
end

function EffectNode:postBuild( state )
end

function EffectNode:loadIntoEmitter( emitter )
	if not self._built then	self:build() end
	self:onLoad( emitter )	
end

function EffectNode:onLoad( emitter )
end

function EffectNode:getHandle( emitter )
	return false
end

----------------------------------------------------------------------
--CLASS: EffectGroup
--------------------------------------------------------------------
function EffectGroup:__init()
end

function EffectGroup:getDefaultName()
	return 'group'
end

function EffectGroup:getTypeName()
	return 'group'
end

function EffectGroup:build( state )
	for i, child in pairs( self.children ) do
		child:build( state )
	end
end

function EffectGroup:loadIntoEmitter( em )
	for i, child in pairs( self.children ) do
		child:loadIntoEmitter( em )
	end
end

--------------------------------------------------------------------
--CLASS: EffectRoot
--------------------------------------------------------------------

EffectRoot :MODEL {
	Field 'duration' :range( 0 );
	Field 'loop'     :boolean();
}

function EffectRoot:__init()
	self.duration = 0
end


--------------------------------------------------------------------
updateAllSubClasses( EffectNode )
--------------------------------------------------------------------

CLASS: EffectConfig ()
	:MODEL{
		Field '_root' :type( EffectRoot ) :no_edit();
	}

function EffectConfig:__init()
	self._root = EffectRoot()
end

function EffectConfig:getRootNode()
	return self._root
end

function EffectConfig:loadIntoEmitter( e )
	self._root:loadIntoEmitter( e )
end

local effectNodeTypeRegistry = {}
--------------------------------------------------------------------
function registerEffectNodeType( name, clas )
	--TODO: reload on modification??
	effectNodeTypeRegistry[ name ] = clas
end

--------------------------------------------------------------------
function loadEffectConfig( node )
	local defData   = loadAssetDataTable( node:getObjectFile('def') )
	local config = deserialize( nil, defData )
	return config
end

registerAssetLoader( 'effect', loadEffectConfig )
