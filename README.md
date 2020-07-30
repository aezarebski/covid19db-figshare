# Oxford COVID-19 (OxCOVID19) Database 

The files contained in this directory are a snapshot of the database described
in **MANUSCRIPT** as of **DATE**. The `data` directory contains the actual data
and the `src` directory the code to generate this snapshot. A complete listing
of the variables can be found in **MANUSCRIPT**. Since the OxCOVID19 Database
draws from multiple data sources there are different licenses for different
tables, please see the **WEBSITE** page for additional details.

---

__Cite as:__ Adam Mahdi, Piotr Błaszczyk, Paweł Dłotko, Dario Salvi, Tak-Shing
Chan, John Harvey, Davide Gurnari, Yue Wu, Ahmad Farhat, Niklas Hellmer,
Alexander Zarebski, Lionel Tarassenko, <em>Oxford COVID-19 Database: multimodal
data repository for understanding the global impact of COVID-19. University of
Oxford</em>, 2020.

---

## Downloading

Prior to running the download we set up a virtual environment with the correct
packages installed with the following commands.

```
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

To actually download the database run the following commands.

```
python src/main.py
```

**Note*** that by default the python script only does a dry run, to get it to
actually carry out the download, the variable `DRY_RUN` needs to be set to
`False` in the script. There is also the `LIMIT` variable to declare whether or
not to limit the size of the download.
