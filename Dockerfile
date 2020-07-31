FROM continuumio/miniconda3:4.8.2 as base

# Make sure conda is up-to-date.
RUN conda update -n base -c defaults -y conda

# Install node so that JupyterLab extensions can be used.
RUN apt-get install -y curl && \
    curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs

# Ensure default user isn't root.
RUN adduser --gecos "JupyterLab User" --disabled-password app
USER app
WORKDIR /home/app

# Install everything
FROM base as condaEnv
COPY --chown=app:app environment.yml /home/app/environment.yml
RUN conda config --prepend pkgs_dirs /home/app/.conda/pkgs
RUN conda env create --prefix ./env

# Start JupyterLab
FROM base as jupyter
COPY --chown=app:app entrypoint.sh /home/app/entrypoint.sh
COPY --from=condaEnv /home/app/env /home/app/env
RUN chmod u+x /home/app/entrypoint.sh
EXPOSE 8888
CMD [ "/home/app/entrypoint.sh" ]
