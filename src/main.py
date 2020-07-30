import psycopg2
import pandas as pd
from datetime import date

DRY_RUN = True

CONN = psycopg2.connect(
    host='covid19db.org',
    port=5432,
    dbname='covid19',
    user='covid19',
    password='covid19')
CUR = CONN.cursor()

def report_action(sql_command: str, output_filepath: str) -> None:
    template = "{border}\nRunning SQL query:\n\t{query}\nWriting to file:\n\t{output}"
    print(template.format(border = 80*"=", query = sql_command, output = output_filepath))


def fetch_and_record_table(table_name: str) -> None:
    """Fetch and record a table from the database.

    Parameters
    ----------
    table_name : str
        The name of the table to use
    """
    assert table_name != "weather", "will not fetch the weather table with this function!"
    sql_command = """SELECT * FROM {tn} LIMIT 2000 """.format(tn = table_name)
    output_filepath = "data/{tn}.csv".format(tn = table_name)
    report_action(sql_command, output_filepath)
    if not DRY_RUN:
        pd.read_sql(sql_command, CONN).to_csv(output_filepath, index = False)

def fetch_and_record_weather(start_date: date, end_date: date) -> None:
    """Fetch and record the weather data from the start date up until the day prior
    to the end date.

    Parameters
    ----------
    start_date : date
        The first day to record values from
    end_date : date
        The day after the last day to record values from.
    """
    sql_command_template = """SELECT * FROM weather WHERE date >= '{start_date}' AND date < '{end_date}'"""
    sql_command = sql_command_template.format(start_date=start_date.isoformat(), end_date=end_date.isoformat())
    output_filepath = "data/weather-{start_date}.csv".format(start_date = start_date.isoformat())
    report_action(sql_command, output_filepath)
    if not DRY_RUN:
        pd.read_sql(sql_command, CONN).to_csv(output_filepath, index = False)


def print_distinct_values(table_name: str, col_name: str) -> None:
    """Print the discinct values in a column of a table

    This function is mainly useful for looking in the database to see what data
    there is.

    Parameters
    ----------
    table_name : str
        The name of the table
    col_name : str
        The name of the column
    """
    sql_command = """SELECT DISTINCT {cn} FROM {tn}""".format(tn = table_name, cn = col_name)
    print(pd.read_sql(sql_command, CONN))



def main():
    fetch_and_record_table("epidemiology")
    fetch_and_record_table("government_response")
    fetch_and_record_table("mobility")
    fetch_and_record_table("surveys")
    fetch_and_record_table("world_bank")
    for m in range(1,6+1):
        start_date = date(2020,m,1)
        end_date = date(2020,m+1,1)
        fetch_and_record_weather(start_date,end_date)
    return(0)


if __name__ == "__main__":
    main()
