# Oxford COVID-19 (OxCOVID19) Database 

The files contained in this directory are a snapshot of the database described
in **MANUSCRIPT** as of **31-07-2020**. The `data` directory contains the actual
data and the `src` directory the code to generate this snapshot. A complete
listing of the variables can be found in **MANUSCRIPT**. Since the OxCOVID19
Database draws from multiple data sources there are different licenses for
different tables, please see https://covid19.eng.ox.ac.uk/ for additional
details.

---

__Cite as:__ Adam Mahdi, Piotr Błaszczyk, Paweł Dłotko, Dario Salvi, Tak-Shing
Chan, John Harvey, Davide Gurnari, Yue Wu, Ahmad Farhat, Niklas Hellmer,
Alexander E. Zarebski, Bernie Hogan, Lionel Tarassenko, <em>Oxford COVID-19
Database: multimodal data repository for understanding the global impact of
COVID-19. University of Oxford</em>, 2020.

---

## Data schemas

See the `schema` directory for a listing of all the table schemas in both human
and machine readable form.

## Downloading

Prior to running the download we set up a virtual environment with the correct
packages installed with the following commands.

```
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

Recall that you can use `python --version` to check which version of python you
are running. If the virtual environment has been set up correctly you should
have a version `3.x` when it has been activated. To actually download the
database run the following command.

```
python src/main.py
```

**Note** that by default the python script only does a dry run, to get it to
actually carry out the download, the variable `DRY_RUN` needs to be set to
`False` in the script. There is also the `LIMIT` variable to declare whether or
not to limit the size of the download.

## Usage example

See the `src/README.org` file for an example of the usage of these data.

## Authors

Adam Mahdi 1
Piotr Błaszczyk 2
Paweł Dłotko 3
Dario Salvi 4
Tak-Shing Chan 5
John Harvey 5
Davide Gurnari 6
Yue Wu 7
Ahmad Farhat 8
Niklas Hellmer 5
Alexander E. Zarebski 9
Bernie Hogan 10
Lionel Tarassenko 1

### Affiliations

1. Institute of Biomedical Engineering, Department of Engineering Science,
   University of Oxford, Oxford, United Kingdom
2. Faculty of Computer Science, Electronics and Telecommunications, AGH
   University of Science and Technology, Krakow, Poland
3. Dioscuri Centre in Topological Data Analysis, Mathematical Institute, Polish
   Academy of Sciences, Warsaw, Poland and Department of Mathematics, Swansea
   University, Swansea, United Kingdom
4. School of Arts and Communication (K3**, Malmö University, Malmö, Sweden
5. Department of Mathematics, Swansea University, Swansea, United Kingdom
6. Department of Mathematics, University of Padova, Padova, Italy
7. Mathematical Institute, University of Oxford, Oxford, United Kingdom and The
   Alan Turing Institute, London, United Kingdom
8. American University of Sharjah, Sharjah, United Arab Emirates
9. Department of Zoology, University of Oxford, Oxford, United Kingdom
10. Oxford Internet Institute, University of Oxford, Oxford, United Kingdom

### Correspondance

Adam Mahdi, adam.mahdi@eng.ox.ac.uk
