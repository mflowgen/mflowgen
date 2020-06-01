default: chipart

.PHONY: chipart

chipart:
	mkdir -p outputs
	ln -s inputs/shapes.py .
	python draw.py
	calibredrv chipart.tcl

.PHONY: stipple

stipple:
	calibredrv stipple.tcl

