################################################################################################################################################################

# @project        Open Space Toolkit
# @file           docker/jupyter/Dockerfile
# @author         Lucas Brémond <lucas@loftorbital.com>
# @license        Apache License 2.0

################################################################################################################################################################

ARG JUPYTER_NOTEBOOK_IMAGE_REPOSITORY=jupyter/scipy-notebook:latest

FROM ${JUPYTER_NOTEBOOK_IMAGE_REPOSITORY}

LABEL maintainer="lucas@loftorbital.com"

ENV JUPYTER_ENABLE_LAB yes

# Set user to root

USER root

# Install Python utilities

RUN pip install --quiet numpy pandas plotly
RUN conda install ipympl=0.4.0

# Install JupyterLab extensions

RUN jupyter labextension install --no-build \
        @jupyterlab/shortcuts-extension \
        @jupyter-widgets/jupyterlab-manager \
        jupyter-matplotlib \
        plotlywidget \
        jupyterlab-plotly \
 && jupyter lab build \
 && jupyter labextension update --all

COPY ./shortcuts-extension /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/shortcuts-extension

RUN chown -R ${NB_UID}:${NB_UID} /home/jovyan/.jupyter

ENV LD_LIBRARY_PATH "/usr/local/lib:/usr/lib/x86_64-linux-gnu:/opt/conda/lib/python3.8/site-packages:/home/jovyan/lib:/opt/conda/lib"
ENV PYTHONPATH "/opt/conda/lib/python3.8/site-packages:/home/jovyan/lib"

# Install Open Space Toolkit

RUN pip install open-space-toolkit-astrodynamics

# Restore user

USER ${NB_UID}

# Disable token

CMD ["start-notebook.sh", "--NotebookApp.token=''"]

################################################################################################################################################################
