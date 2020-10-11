import wollok.game.*

class IsometricConverter {
	const size = 1
	const property dirLeft = new DirectionLeft(isometricConverter=self)
	const property dirUp = new DirectionUp(isometricConverter=self)
	const property dirRight = new DirectionRight(isometricConverter=self)
	const property dirDown = new DirectionDown(isometricConverter=self)	
	
	method up(position) = position.up(size).left(2*size)
	method down(position) = position.down(size).right(2*size)
	method left(position) = position.left(2*size).down(size)
	method right(position) = position.right(2*size).up(size)
	
	method directions() = [self.dirLeft(), self.dirUp(), self.dirRight(), self.dirDown()]	
}

object isometricTerrainConverter inherits IsometricConverter(size = 4){}

class IsometricDirection {
	const isometricConverter
}

class DirectionLeft inherits IsometricDirection {
	method index() = 0 // In a list of directions, clockwisely, left is the first.
	method cornerIndexes() = [3,0]
	method opposite() = isometricConverter.dirRight()
	method next(position) = isometricConverter.left(position)
	method isAtLimit(position) = position.y() < 0 || position.x() < 0
}

class DirectionUp inherits IsometricDirection {
	method index() = 1
	method cornerIndexes() = [0,1]
	method opposite() = isometricConverter.dirDown()
	method next(position) = isometricConverter.up(position)
	method isAtLimit(position) = position.y() > game.height() || position.x() < 0
}

class DirectionRight inherits IsometricDirection {
	method index() = 2
	method cornerIndexes() = [2,1]
	method opposite() = isometricConverter.dirLeft()
	method next(position) = isometricConverter.right(position)
	method isAtLimit(position) = position.y() > game.height() || position.x() > game.width()
}

class DirectionDown inherits IsometricDirection {
	method index() = 3
	method cornerIndexes() = [3,2]
	method opposite() = isometricConverter.dirUp()
	method next(position) = isometricConverter.down(position)
	method isAtLimit(position) = position.y() < 0 || position.x() > game.width()
}