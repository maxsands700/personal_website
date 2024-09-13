import pandas as pd
import numpy as np
import openpyxl
import os


def find_header_indices(df):
    fiscal_year_idx = df.index[df.iloc[:, 0] == 'Fiscal Year'].tolist()[0]
    top_group_var_idx = fiscal_year_idx - 1
    return fiscal_year_idx, top_group_var_idx


def get_column_spans(df, top_group_var_idx):
    # Get the row with top_group_vars or category labels
    top_group_var_row = df.iloc[top_group_var_idx, :]
    top_group_var_row = top_group_var_row.replace(
        to_replace=r'\d+$', value='', regex=True)

    # Check if there is more than one non-NA value, indicating multiple top_group_vars
    if top_group_var_row.count() > 1:
        # Forward fill to handle merged cells and count the occurrences
        column_spans = top_group_var_row.ffill().value_counts().to_dict()
    else:
        # If there's only one non-NA value, we treat the entire row as a single category
        column_spans = {top_group_var_row.dropna().unique()[0]: len(
            df.columns) - 2}  # -2 to exclude 'Fiscal Year' and 'Month'

    return column_spans


# Define function to align Fiscal to Calendar Date
def fiscal_to_calendar(fiscal_date):
    # If the month is from October to December, we subtract one year for alignment purposes
    if fiscal_date.month >= 10:
        return fiscal_date.replace(year=fiscal_date.year - 1)
    else:
        return fiscal_date


def clean_homeland_table(df):
    # find fiscal year and top group var row indices
    fiscal_year_idx, top_group_var_idx = find_header_indices(df)

    # get dictionary of number of columns for each top group_var
    top_group_var_dict = get_column_spans(df, top_group_var_idx)

    # drop footnote rows
    ftnt = df.iloc[5:, 1:].isna().all(axis=1)
    ftnt_idx = ftnt[ftnt].index
    df = df[~df.index.isin(ftnt_idx)].reset_index(drop=True)
    # forward fill Fiscal Year
    df[0].ffill(inplace=True)
    # remove Total Rows for each year, they are unnecessary
    df = df[df[1] != 'Total'].reset_index(drop=True)

    df = df.iloc[fiscal_year_idx:].reset_index(drop=True)

    # initialize list to store each dataframe for each top_group_var
    dfs = []
    start_col = 2
    for top_group_var, num_cols in top_group_var_dict.items():
        # Get the range of columns for the current encounter type
        sub_df = df.iloc[:, start_col:start_col+num_cols]
        # reset column headers
        sub_df.columns = sub_df.iloc[0]
        sub_df = sub_df.drop(df.index[0]).reset_index(drop=True)
        # add Fiscal Year and Month to sub_df slice
        sub_df = pd.concat([sub_df, df.iloc[1:, :2].set_axis(
            labels=['Fiscal Year', 'Month'], axis=1).reset_index(drop=True)], axis=1)
        # pivot to long format
        sub_df = sub_df.melt(id_vars=('Fiscal Year', 'Month'),
                             var_name='Sub Var', value_name='value')
        # add top group var
        sub_df['Top Var'] = top_group_var
        # append to dfs list
        dfs.append(sub_df)
        # update the starting col integer for next iteration
        start_col += num_cols

    df = pd.concat(dfs, ignore_index=True)

    # get Fiscal Date column
    df['Date'] = df['Fiscal Year'].astype(str) + ' ' + df['Month']
    df['Date'] = df['Date'].str.replace('YTD ', '')
    df['Fiscal Date'] = pd.to_datetime(df['Date'], errors='coerce')
    # Remove any rows where fiscal date conversion failed
    df.dropna(subset=['Fiscal Date'], inplace=True)

    df = df[['Fiscal Date', 'Top Var', 'Sub Var', 'value']]

    # get Calendar Date
    df['Calendar Date'] = df['Fiscal Date'].apply(fiscal_to_calendar)

    # Pivot data to wide format
    df_wide = pd.pivot_table(
        df,
        values='value',
        index=['Calendar Date'],
        columns=['Top Var', 'Sub Var']
    )

    return df, df_wide
