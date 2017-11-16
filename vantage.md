 # Vantage Points

## Questions

5.1. CSV is simpler to parse than JSON and CSV data can be opened in Excel, Google Sheets, or another app that handles spreadsheets.

5.2. JSON is more flexible than CSV because it is unstructured. JSON can contain elements within elements and different types.

5.3. https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=NFLX&interval=1min&apikey=NAJXWIA8D6VN6A3K&datatype=csv

5.4. The API's JSON format has unnecessary numbers before the names of the stock types- the "1." before "open", the "2." before "high",
        etc, should be removed because they don't add any useful information and they just make it more difficult to access the
        information, because anyone writing code to read the JSON file has to know to get "1. open" instead of just "open", which would
        make more sense.

## Debrief

a. https://www.quora.com/What-is-the-difference-between-parsing-a-CSV-and-JSON-file-What-common-algorithms-would-you-use-in-both
    https://www.alphavantage.co/documentation/#intraday

b. 45 minutes
