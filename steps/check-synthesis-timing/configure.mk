define commands.check-synthesis-timing
	@mkdir -p $(reports_dir.check-synthesis-timing)
	@python $(flow_dir.check-synthesis-timing)/check-synthesis-timing.py > $(reports_dir.check-synthesis-timing)/report.txt
endef
