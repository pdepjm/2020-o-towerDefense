import wollok.game.*
import isometry.*

object enemy {
	var position = game.at(game.height(), game.center().x())
	var direction = directionDown
	
	method image() = "Delta/idle.png"
	method position() = position
	method startWalking() {
		game.addVisual(self)
		game.onTick(100, "enemyCrawling", {self.step()})
	}
	
	method step(){
		position = direction.next(position)
		if(direction.isAtLimit(position)) {
			direction = direction.opposite()
		}
	}
}

object directionUp {
	const isometricConverter = new IsometricConverter()
	method opposite() = directionDown
	method next(position) = isometricConverter.up(position)
	method isAtLimit(position) = position.y() > game.height() || position.x() < 0
}

object directionDown {
	const isometricConverter = new IsometricConverter()
	method opposite() = directionUp
	method next(position) = isometricConverter.down(position)
	method isAtLimit(position) = position.y() < 0 || position.x() > game.width()
}