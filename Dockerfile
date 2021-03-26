FROM continuumio/miniconda3:4.9.2 as base

# Make sure conda is up-to-date.
RUN conda update -n base -c defaults -y conda

# Install node so that JupyterLab extensions can be used.
RUN apt-get install -y curl && \
    curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y \
        nodejs \
        pandoc \
        texlive-xetex \
        texlive-fonts-recommended \
        texlive-generic-recommended

# Ensure default user isn't root.
RUN adduser --gecos "JupyterLab User" --disabled-password app
USER app
WORKDIR /home/app

# Install everything
FROM base as condaEnv
COPY --chown=app:app environment.yml /home/app/environment.yml
RUN conda config --prepend pkgs_dirs /home/app/.conda/pkgs
RUN conda env create --prefix ./env
RUN ./env/bin/jupyter labextension install @jupyter-widgets/jupyterlab-manager
RUN ./env/bin/jupyter lab build
RUN ./env/bin/jupyter lab clean

# Setup the Jupyter Lab base layer.
FROM base as jupyter
COPY --chown=app:app --from=condaEnv /home/app/env /home/app/env
COPY --chown=app:app scripts /home/app/scripts
RUN bash /home/app/scripts/setup.sh
RUN chmod u+x /home/app/scripts/entrypoint.sh
EXPOSE 8888
CMD [ "/home/app/scripts/entrypoint.sh" ]
