import wollok.game.*
import isometry.*
import terrain.*
import debug.*

object builder inherits Terrain (position=game.origin()){
	const terrains = []
	var currentTerrain = terrainSwitcher.next(null)
	var adjacentTerrains // saved for performance reasons

	override method image() = currentTerrain.image()
		
	method terrains(ts) {terrains.addAll(ts)} // for testing
	method terrain(t) {currentTerrain = t} // for testing
	
	method nextTerrain(){
		currentTerrain = terrainSwitcher.next(currentTerrain)
		self.toggleWarning()
	}
	
	method possibleTerrains() = terrainDB.filter(position, {terrain => self.fitsHere(terrain)})
	
	method build(){
		const terrain = currentTerrain.cloneIn(position)
		terrains.add(terrain) 
		game.addVisual(terrain)
		self.redrawAll()
	}
	
	method configureKeys(){
		keyboard.space().onPressDo({self.nextTerrain()})
		keyboard.enter().onPressDo({self.build()})
		keyboard.up().onPressDo({self.moveTo(isometricTerrainConverter.up(position))})
		keyboard.down().onPressDo({self.moveTo(isometricTerrainConverter.down(position))})
		keyboard.right().onPressDo({self.moveTo(isometricTerrainConverter.right(position))})
		keyboard.left().onPressDo({self.moveTo(isometricTerrainConverter.left(position))})
	}
	
	method moveTo(pos){
		position = pos
		adjacentTerrains = terrains.filter{terrain => terrain.adjacentTo(self)} // saving for performance
		terrainSwitcher.possibleTerrains(null) // performance reasons. Forces update afterwards
		self.toggleWarning()
		self.redrawAll()
	}
	
	method toggleWarning(){
		if(self.fitsHere(currentTerrain)) warning.hide() else warning.show()
	}
	
	method redrawAll(){
		(terrains + [self,warning]).sortedBy{t1, t2 => t1.goesBelow(t2)}
			.forEach{terrain => terrain.redraw()}
	}
	
	method fitsHere(terrain) = self.adjacentTerrains().all{adjacent => adjacent.matches(terrain)}
	
	method adjacentTerrains() = adjacentTerrains

}

object warning {
	var on = false
	method position() = builder.position()
	method image() = "warning.png"
	method zIndex() = 9999 
	method goesBelow(other) = false
	method redraw() {
		if(on){
			game.removeVisual(self)
			game.addVisual(self)			
		}
	}
	method show() {
		if(!on) {
			on = true
			game.addVisual(self)
		}
	}
	method hide(){
		if(on){
			on = false
			game.removeVisual(self)
		}
	}
}


object terrainSwitcher {
	var possibleTerrains	
	
	method possibleTerrains(possible) {
		possibleTerrains = possible
	}
	
	method possibleTerrains() {
		if(possibleTerrains == null) {
			possibleTerrains = builder.possibleTerrains()
		}
		return possibleTerrains
	}
	
	method next(current) = if (current == null) terrainDB.anyOne(game.at(0,0))
		else if (self.possibleTerrains().isEmpty()) current
		else self.possibleTerrain()
		
	method possibleTerrain() {
		self.rotatePosibleTerrains()
		return self.possibleTerrains().last()
	}
	
	method rotatePosibleTerrains() {
		possibleTerrains = possibleTerrains.drop(1) + [possibleTerrains.first()]
	}
}