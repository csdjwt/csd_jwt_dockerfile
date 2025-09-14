FROM archlinux

RUN echo "Installing packages via ArchLinux's Pacman..."
RUN pacman -Syu rust git python3 python-pip base-devel --noconfirm >/dev/null
RUN echo "Installed rust, git, python3, python-pip, base-devel."

ENV CSD_JWT_ITERATIONS=1
ENV OPENSSL_LIB_DIR=/usr/lib/
ENV OPENSSL_INCLUDE_DIR=/usr/include/

RUN echo "Cloning and installing csd_jwt repository from GitHub..."
RUN cd / && git clone https://github.com/csdjwt/csd_jwt >/dev/null
RUN echo "Repository cloned."

RUN echo "Installing pip packages for plotting results..."
RUN pip install --no-cache-dir --break-system-packages pandas matplotlib numpy >/dev/null
RUN echo "Installed pandas, matplotlib, numpy."

WORKDIR /csd_jwt

RUN echo "Building a --release version of the rust code..."
RUN cargo build --release >/dev/null 2>&1 
RUN echo "Code successfully compiled."

RUN echo "Container is ready to be executed."
CMD nice -20 cargo run --release \
	&& python _paper_plots.py \
	&& python _appendix_plots.py \
	&& tar cvfz all_csvs.tar.gz csv_dir/ >/dev/null \
	&& tar cvfz all_plots.tar.gz plots/ >/dev/null 
		
