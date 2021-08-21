#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

FROM continuumio/miniconda3

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# This Dockerfile adds a non-root user with sudo access. Use the "remoteUser"
# property in devcontainer.json to use it. On Linux, the container user's GID/UIDs
# will be updated to match your local UID/GID (when using the dockerFile property).
# See https://aka.ms/vscode-remote/containers/non-root-user for details.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG CONDA_ENV_NAME='base'
ENV CONDA_ENV_NAME=$CONDA_ENV_NAME
ENV CONDA_BIN='/opt/conda/bin/conda'

# Copy environment.yml (if found) to a temp locaition so we update the environment. Also
# copy "noop.txt" so the COPY instruction does not fail if no environment.yml exists.
COPY environment*.yml requirements .devcontainer/noop.txt /tmp/conda-tmp/
COPY requirements /tmp/conda-tmp/requirements
COPY .devcontainer/conda_set_env_vars.sh /opt/conda/activate.d/env_vars.sh
COPY .devcontainer/conda_unset_env_vars.sh /opt/conda/deactivate.d/env_vars.sh

RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    #
    # Verify git, process tools, lsb-release (common in install instructions for CLIs) installed
    && apt-get -y install make git vim bash-completion locales shtool iproute2 procps lsb-release \
    #
    # Install pylint
    && /opt/conda/bin/pip install pylint \
    #
    # Create Python environment based on environment-dev.yml
    && $CONDA_BIN env create -n $CONDA_ENV_NAME -f /tmp/conda-tmp/environment-dev.yml \
    && echo "source activate ${CONDA_ENV_NAME}" > ~/.bashrc \
    # Create Client-side environment based on environment-client.yml (if present)
    # && if [ -f "/tmp/conda-tmp/environment-client.yml" ]; then $CONDA_BIN env create -n $CLIENT_CONDA_ENV_NAME -f /tmp/conda-tmp/environment-client.yml; fi \
    #
    # Update Python environment based on environment.yml
    # && $CONDA_BIN env update -n $APP_CONDA_ENV_NAME -f /tmp/conda-tmp/environment.yml \
    && rm -rf /tmp/conda-tmp \
    #
    # Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # [Optional] Add sudo support for the non-root user
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && chown -R $USERNAME:$USERNAME '/opt/conda'\
    #
    # Create alternate global install location that both uses have rights to access
    # && mkdir -p /usr/local/share/pip-global \
    # && chown ${USERNAME}:root /usr/local/share/pip-global \
    #  
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

RUN ["/bin/bash", "-c", "source /opt/conda/bin/activate && \
    conda activate ${CONDA_ENV_NAME} && \  
    jupyter contrib nbextension install --user"]

# set Locale
ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
RUN sudo locale-gen en_US.UTF-8 \
    && sudo dpkg-reconfigure locales \
    && sudo localedef -i en_US -f UTF-8 en_US.UTF-8

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
