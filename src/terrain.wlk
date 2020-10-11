import wollok.game.*
import isometry.*

class Terrain {
	
	const property id
	const cornerHeights // 4 numbers, clockwise, first represents left-up corner
	const sideTypes // 4 strings, clockwise, first represents left side type
	
	var property position = game.at(0,0)
	
	method image() = "landscape/landscape_" + id + ".png"
	method zIndex() = game.height() - position.y()
	
	method redraw() {
		game.removeVisual(self)
		game.addVisual(self)
	}
	
	method goesBelow(terrain){
		return self.zIndex() < terrain.zIndex()
	}
	
	method isAt(pos) = position == pos
	
	method matches(anotherTerrain) = isometricTerrainConverter.directions().any{direction => self.matchesTo(direction,anotherTerrain)}
	
	method matchesTo(dir, anotherTerrain) = anotherTerrain.isAt(dir.next(position)) && self.matchesHeights(dir, anotherTerrain) && self.matchesSides(dir, anotherTerrain)
	
	method matchesSides(dir, anotherTerrain) = self.sideType(dir) == anotherTerrain.sideType(dir.opposite()) 
	
	method sideType(dir) = sideTypes.get(dir.index())
	
	method matchesHeights(dir, anotherTerrain) = (0..1).all{ i => self.heightAt(dir.cornerIndexes().get(i)) == anotherTerrain.heightAt(dir.opposite().cornerIndexes().get(i)) }
	
	method heightAt(cornerIndex) = cornerHeights.get(cornerIndex)
	
	method adjacentTo(anotherTerrain) = isometricTerrainConverter.directions().any{dir => anotherTerrain.isAt(dir.next(position))}
	
	method cloneIn(pos) {
		return new Terrain(id=id, cornerHeights=cornerHeights, sideTypes=sideTypes, position=pos)
	}
}

object terrainDB {
	const all = [
		new Terrain(id="00", sideTypes=["grass", "grass", "water", "water"], cornerHeights=[2,2,2,2]),
		new Terrain(id="01", sideTypes=["water", "water", "grass", "grass"], cornerHeights=[2,2,2,2]),
		new Terrain(id="02", sideTypes=["grass", "grass", "road", "road"], cornerHeights=[2,2,2,2]),
		new Terrain(id="03", sideTypes=["road", "road", "grass", "grass"], cornerHeights=[2,2,2,2]),
		new Terrain(id="04", sideTypes=["grass", "road", "grass", "road"], cornerHeights=[2,2,2,2]),
		new Terrain(id="05", sideTypes=["grass", "water", "water", "grass"], cornerHeights=[2,2,2,2]),
		new Terrain(id="06", sideTypes=["road", "grass", "road", "road"], cornerHeights=[2,2,2,2]),
		new Terrain(id="07", sideTypes=["grass", "road", "road", "grass"], cornerHeights=[2,2,2,2]),
		new Terrain(id="08", sideTypes=["grass", "road", "grass", "road"], cornerHeights=[3,3,2,2]),
		new Terrain(id="09", sideTypes=["road", "grass", "road", "grass"], cornerHeights=[2,2,2,2]),
		new Terrain(id="10", sideTypes=["road", "road", "grass", "road"], cornerHeights=[2,2,2,2]),
		new Terrain(id="11", sideTypes=["grass", "road", "road", "road"], cornerHeights=[2,2,2,2]),
		new Terrain(id="12", sideTypes=["road", "grass", "road", "grass"], cornerHeights=[3,2,2,3]),
		new Terrain(id="13", sideTypes=["grass", "grass", "grass", "grass"], cornerHeights=[2,2,2,2]),
		new Terrain(id="14", sideTypes=["road", "road", "road", "grass"], cornerHeights=[2,2,2,2]),
		new Terrain(id="15", sideTypes=["grass", "road", "grass", "road"], cornerHeights=[2,2,3,3]),
		new Terrain(id="16", sideTypes=["grass", "grass", "grass", "grass"], cornerHeights=[3,2,2,3]),
		new Terrain(id="17", sideTypes=["road", "road", "road", "road"], cornerHeights=[1,1,1,1]),
		new Terrain(id="18", sideTypes=["road", "grass", "road", "grass"], cornerHeights=[2,3,3,2]),
		new Terrain(id="19", sideTypes=["grass", "grass", "grass", "grass"], cornerHeights=[2,2,3,3]),
		new Terrain(id="20", sideTypes=["grass", "grass", "grass", "grass"], cornerHeights=[2,3,3,2]),
		new Terrain(id="21", sideTypes=["grass", "grass", "grass", "grass"], cornerHeights=[1,1,1,1]),
		new Terrain(id="22", sideTypes=["grass", "grass", "grass", "grass"], cornerHeights=[3,3,3,3]),
		new Terrain(id="23", sideTypes=["grass", "grass", "grass", "grass"], cornerHeights=[3,3,2,2]),
		new Terrain(id="24", sideTypes=["grass", "grass", "grass", "grass"], cornerHeights=[2,2,2,3]),
		new Terrain(id="25", sideTypes=["grass", "grass", "grass", "grass"], cornerHeights=[2,2,3,2]),
		new Terrain(id="26", sideTypes=["grass", "grass", "grass", "grass"], cornerHeights=[3,2,2,2]),
		new Terrain(id="27", sideTypes=["grass", "grass", "grass", "grass"], cornerHeights=[2,3,2,2]),
		new Terrain(id="28", sideTypes=["grass", "grass", "grass", "grass"], cornerHeights=[2,2,2,2]),
		new Terrain(id="29", sideTypes=["road", "grass", "road", "grass"], cornerHeights=[2,2,2,2]),
		new Terrain(id="30", sideTypes=["road", "road", "road", "road"], cornerHeights=[2,2,2,2]),
		new Terrain(id="31", sideTypes=["road", "grass", "grass", "road"], cornerHeights=[2,2,2,2]),
		new Terrain(id="32", sideTypes=["grass", "road", "grass", "road"], cornerHeights=[2,2,2,2]),
		new Terrain(id="33", sideTypes=["water", "grass", "water", "grass"], cornerHeights=[2,2,2,2]),
		new Terrain(id="34", sideTypes=["grass", "grass", "road", "road"], cornerHeights=[2,2,2,2]),
		new Terrain(id="35", sideTypes=["road", "road", "grass", "grass"], cornerHeights=[2,2,2,2]),
		new Terrain(id="36", sideTypes=["water", "grass", "grass", "water"], cornerHeights=[2,2,2,2]),
		new Terrain(id="37", sideTypes=["grass", "water", "grass", "water"], cornerHeights=[2,2,2,2]),
		new Terrain(id="38", sideTypes=["road", "grass", "grass", "road"], cornerHeights=[2,2,2,2]),
		new Terrain(id="39", sideTypes=["grass", "road", "road", "grass"], cornerHeights=[2,2,2,2])
	]
	
	method anyOne(position) {
		const theOne = all.anyOne()
		theOne.position(position)
		return theOne
	} 
	
	method filter(position, closure) = all.filter{terrain => terrain.position(position) closure.apply(terrain)}
	
	method get(id) = all.find{terrain => terrain.id() == id} // for testing
}
