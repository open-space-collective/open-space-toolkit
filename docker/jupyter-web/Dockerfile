# Apache License 2.0

# Web hosted Jupyter Notebook image

ARG JUPYTER_NOTEBOOK_IMAGE_REPOSITORY=jupyter/scipy-notebook:x86_64-python-3.11.3

FROM ${JUPYTER_NOTEBOOK_IMAGE_REPOSITORY}

LABEL maintainer="kyle.cochran@loftorbital.com"

ENV JUPYTER_ENABLE_LAB="yes"

# Set user to root

USER root

# Install Python utilities

RUN apt-get update \
 && apt-get install -y curl \
 && rm -rf /var/lib/apt/lists/*

RUN pip install --quiet "numpy" "pandas" "plotly" "ipywidgets>=7.6" "ipympl>=0.9.0"

RUN jupyter labextension install --no-build \
        @jupyterlab/shortcuts-extension

COPY ./docker/jupyter-web/shortcuts-extension /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/shortcuts-extension

# Fetch the example notebooks from the component repositories

RUN for project in physics astrodynamics; do \
        git clone --depth=1 --filter=blob:none --sparse "https://github.com/open-space-collective/open-space-toolkit-${project}.git" "/tmp/${project}" \
     && git -C "/tmp/${project}" sparse-checkout set tutorials/python/notebooks \
     && mkdir -p /home/jovyan/notebooks \
     && cp -r "/tmp/${project}/tutorials/python/notebooks" "/home/jovyan/notebooks/${project}" \
     && rm -rf "/tmp/${project}" ; \
    done

RUN chown -R ${NB_UID}:${NB_GID} /home/jovyan

# Install Open Space Toolkit

RUN pip install open-space-toolkit-astrodynamics

# Restore user

USER ${NB_UID}

# Disable token

CMD ["start-notebook.sh", "--NotebookApp.token=''"]
