brewfile:=Brewfile
python_version:=3.9.1
current:=$(shell cat .python-version)
repo:=$(shell basename $(CURDIR))

requirements:
	@echo
	@brew bundle list --file=$(brewfile)

--install:
	@echo
	@brew bundle install --file=$(brewfile)

--venv:
	@echo
	@pyenv install $(python_version) -s
	@pyenv virtualenv -f -q $(python_version) $(repo) 1> /dev/null
	@pyenv local $(repo)
	@pip install -q --upgrade pip
	@pip install -qr requirements.txt

--hooks:
	@git add .
	@pre-commit install
	@pre-commit autoupdate
	@echo
	@-pre-commit

--references:
	@sed -i '' s/$(current)/$(repo)/g README.md
	@sed -i '' s/$(current)/$(repo)/g .python-version

init: --install rename --hooks

rename: --venv --references
