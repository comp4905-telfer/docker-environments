jupyter lab build --name=$NOTEBOOK_TITLE_PREFIX-$NOTEBOOK_TITLE_POSTFIX
jupyter lab --ip 0.0.0.0 --port 8888 --no-browser --allow-root --NotebookApp.token=$NOTEBOOK_PASSWORD --NotebookApp.allow_origin=* --NotebookApp.notebook_dir=/
