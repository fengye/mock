module 'mock'

CLASS: DeckComponent( RenderComponent )
	:MODEL{
		Field 'deck'  :asset('deck2d\\..*')        :getset('Deck'),
	}

--------------------------------------------------------------------
function DeckComponent:__init()
	self.prop = MOAIProp.new()
	self:setBlend('normal')
end

function DeckComponent:onAttach( entity )
	entity:_attachProp( self.prop )
end

function DeckComponent:onDetach( entity )
	entity:_detachProp( self.prop )
end

--------------------------------------------------------------------
function DeckComponent:setDeck( deckPath )
	self.deckPath = deckPath
	local deck = mock.loadAsset( deckPath )
	self.prop:setDeck( deck )
end

function DeckComponent:getDeck( deckPath )
	return self.deckPath	
end

function DeckComponent:setBlend( b )
	self.blend = b
	setPropBlend( self.prop, b )
end

function DeckComponent:getBounds()
	return self.prop:getBounds()
end

function DeckComponent:getTransform()
	return self.prop
end

function DeckComponent:setLayer( layer )
	layer:insertProp( self.prop )
end

--------------------------------------------------------------------
function DeckComponent:drawBounds()
	GIIHelper.setVertexTransform( self.prop )
	local x1,y1,z1, x2,y2,z2 = self.prop:getBounds()
	MOAIDraw.drawRect( x1,y1,x2,y2 )
end

--------------------------------------------------------------------
function DeckComponent:inside( x, y, z )
	local x1,y1,z1, x2,y2,z2 = self.prop:getWorldBounds()
	if not x1 then return false end 
	return x>=x1 and y>=y1 and x<=x2 and y<=y2
end