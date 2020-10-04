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