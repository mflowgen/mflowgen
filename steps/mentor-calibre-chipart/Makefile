default: chipart

.PHONY: chipart

chipart:
# For some reason, Calibre requires this directory to exist
	mkdir -p ${HOME}/.calibrewb_workspace/tmp
	mkdir -p outputs
	ln -sf inputs/shapes.py .
	python draw.py
	calibredrv chipart.tcl

.PHONY: stipple

stipple:
	calibredrv stipple.tcl

.PHONY: debug

debug:
	calibredrv -m outputs/chipart.gds


