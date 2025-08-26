import meilisearch
client = meilisearch.Client("http://127.0.0.1:7700",'T6kYKl_2-EgN0Cj1o8axPvt4Dk7HVgg6rnnOnVsRDgw')
def stock_search(query):
    return client.index("nasdaq").search("appl")
