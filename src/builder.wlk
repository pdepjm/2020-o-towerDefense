import wollok.game.*
import isometry.*

object builder inherits Terrain (position=game.origin()){
	const images = ["landscape_00.png","landscape_01.png","landscape_02.png","landscape_03.png","landscape_04.png","landscape_05.png","landscape_06.png","landscape_07.png","landscape_08.png","landscape_09.png", "landscape_00.png","landscape_01.png","landscape_02.png","landscape_03.png","landscape_04.png","landscape_05.png","landscape_06.png","landscape_07.png","landscape_08.png","landscape_09.png","landscape_10.png","landscape_11.png","landscape_12.png","landscape_13.png","landscape_14.png","landscape_15.png","landscape_16.png","landscape_17.png","landscape_18.png","landscape_19.png","landscape_20.png","landscape_21.png","landscape_22.png","landscape_23.png","landscape_24.png","landscape_25.png","landscape_26.png","landscape_27.png","landscape_28.png","landscape_29.png","landscape_30.png","landscape_31.png","landscape_32.png","landscape_33.png","landscape_34.png","landscape_35.png","landscape_36.png","landscape_37.png","landscape_38.png","landscape_39.png"]
	var currentImageIndex = 0
	const terrains = [self]
	const isometricConverter = new IsometricConverter(size=4)
	
	override method image() = "landscape/" + images.get(currentImageIndex)
	
	method changeImage(){
		if(currentImageIndex == images.size()-1) {
			currentImageIndex = 0
		} else {
			currentImageIndex++
		}
	}
	
	method build(){
		const terrain = new Terrain(image=self.image(), position=self.position())
		terrains.add(terrain) 
		game.addVisual(terrain)
		self.redrawAll()
	}
	
	method configureKeys(){
		keyboard.space().onPressDo({self.changeImage()})
		keyboard.enter().onPressDo({self.build()})
		keyboard.up().onPressDo({self.moveTo(isometricConverter.up(position))})
		keyboard.down().onPressDo({self.moveTo(isometricConverter.down(position))})
		keyboard.right().onPressDo({self.moveTo(isometricConverter.right(position))})
		keyboard.left().onPressDo({self.moveTo(isometricConverter.left(position))})
	}
	
	method moveTo(pos){
		position = pos
		self.redrawAll()
	}
	
	method redrawAll(){
		terrains.sortedBy{t1, t2 => t1.goesBelow(t2)}
			.forEach{terrain => terrain.redraw()}
	}

}


class Terrain {
	var property image
	var property position
	method zIndex() = game.height() - position.y()
	
	method redraw() {
		game.removeVisual(self)
		game.addVisual(self)
	}
	
	method goesBelow(terrain){
		return self.zIndex() < terrain.zIndex()
	}
}
