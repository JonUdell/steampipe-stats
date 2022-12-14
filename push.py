"""
push members_join_commits to steampipe cloud
"""

import os, psycopg2, requests

def connect():
  conn_str = f""" host='localhost' dbname='steampipe' user='steampipe' \
    port='9193' password='{os.environ['STEAMPIPE_LOCAL_PASSWORD']}' """
  conn = psycopg2.connect(conn_str)
  return conn.cursor()

def push(sql):
  url = 'https://cloud.steampipe.io/api/latest/org/acme/workspace/jon/query'
  data = {'sql':sql}
  token = os.environ['STEAMPIPE_CLOUD_TOKEN']
  headers = {"Authorization": "Bearer " + token}
  r = requests.post(url, headers=headers, data=data)
  return r.text

def escape(row):
  _row = []
  for col in row:
    col = col.replace("'", "''")
    col = col.replace('""', '"')
    col = col.replace('"', "''")
    _row.append(col)
  row = str(tuple(_row))
  row = row.replace('"', "'")
  return row

def init_sql(table):
  return ( f'insert into public.{table} values ' )

def push_rows(table, query):
  cur = connect()
  cur.execute(query)
  rows = cur.fetchall()
  i = 0
  sql = init_sql(table)
  values = []
  for row in rows:
    i += 1
    value = escape(row)
    values.append( value )
    if i % 1000 == 0:
      sql += ','.join(values)
      print(i, push(sql))
      sql = init_sql(table)
      values = []
  if i == len(rows) and len(values):
    sql = init_sql(table)
    sql += ','.join(values)
    print(i, push(sql))

push('drop table if exists members_join_commits')
push('create table public.members_join_commits ( repository_full_name text, author_login text, author_date text, html_url text, message text)')
push_rows('members_join_commits', 'select * from public.members_join_commits')
push('grant all on members_join_commits to public')



    
