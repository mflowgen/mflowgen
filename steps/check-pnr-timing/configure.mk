define commands.check-pnr-timing
	@mkdir -p $(reports_dir.check-pnr-timing)
	@python $(flow_dir.check-pnr-timing)/check-pnr-timing.py > $(reports_dir.check-pnr-timing)/report.txt
endef
