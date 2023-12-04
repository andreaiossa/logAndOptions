changeset:
	chmod u+x ./scripts/changeset.sh
	./scripts/changeset.sh
version:
	chmod u+x ./scripts/version.sh
	git push
	./scripts/version.sh
	git push --tags --no-verify