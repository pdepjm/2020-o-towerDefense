class IsometricConverter {
	const size = 1
	method up(position) = position.up(size).left(2*size)
	method down(position) = position.down(size).right(2*size)
	method left(position) = position.left(2*size).down(size)
	method right(position) = position.right(2*size).up(size)
}