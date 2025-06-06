# Locator-Scripts

## Overview

This repository contains scripts and data for batch geocoding large lists of addresses using the [Stanford ArcGIS Locator Service](https://locator.stanford.edu/). The primary workflow reads a CSV of addresses, sends them in batches to the Stanford ArcGIS REST API, and writes the geocoded results to a new CSV file. The scripts are designed for efficiency and robustness with large datasets.

---

## About locator.stanford.edu

The [Stanford ArcGIS Locator Service](https://locator.stanford.edu/) provides geocoding capabilities for North America and the USA via a REST API. It allows users to submit addresses and receive geographic coordinates and address components in return. The service supports batch geocoding (multiple addresses per request) and returns detailed match information for each address.

- **API Documentation:** [ArcGIS REST API: geocodeAddresses](https://developers.arcgis.com/rest/geocode/api-reference/geocoding-geocode-addresses.htm)
- **Batch Limit:** Up to 1000 addresses per request.
- **Required Fields:** Typically `Address`, `City`, `Region` (State), `Postal`, and `CountryCode`.

---

## Repository Structure

### Data Files

- **Data/oneMillionAddresses.csv**  
  A large CSV file containing addresses to be geocoded.  
  **Columns:**  
  - `OBJECTID`: Unique identifier for each address  
  - `Address`: Street address  
  - `Postal`: ZIP code  
  - (Other columns may be present but are not required by the geocoder)

- **Data/geocoded_addresses01.csv**, **Data/geocoded_addresses02.csv**, ...  
  Output files containing geocoded results.  
  **Columns:**  
  - Various geocoding result fields such as `ResultID`, `Status`, `Score`, `Match_addr`, `X`, `Y`, etc.

---

### Code Files

- **locator_geocode_Script.R**  
  Main R script for batch geocoding.  
  **Features:**  
  - Reads input CSV of addresses.
  - Ensures required columns for the locator service.
  - Sends addresses in user-configurable batch sizes to the ArcGIS REST API.
  - Handles API responses and extracts geocoding results.
  - Writes results to a CSV file.
  - Prints progress summaries, elapsed time, estimated time to completion, and a final summary.

  **Key Parameters:**  
  - `service_url`: API endpoint for the Stanford locator.
  - `csv_file_path`: Path to the input addresses CSV.
  - `output_csv_file`: Path for the geocoded output.
  - `chunk_size`: Number of addresses per batch.
  - `job_size`: How many records to process (`"all"` or an integer).

  **Usage:**  
  1. Edit the user-configurable parameters at the top of the script.
  2. Run the script in R.
  3. Monitor progress and find results in the specified output CSV.

---

## How to Use

1. Place your input addresses in `Data/oneMillionAddresses.csv` (or edit the script to use your file).
2. Run `locator_geocode_Script.R` in R.
3. The script will process the addresses in batches, geocode them, and write the results to a CSV in the `Data/` folder.
4. Review the output CSV for geocoding results.

---

## Notes

- The script is designed for beginning R users and is heavily commented.
- The Stanford Locator API may require Stanford network access or VPN.
- For large jobs, adjust `chunk_size` and `job_size` as needed.
- Output CSV columns may vary depending on the locator's response.

---

## License

This repository is for educational and research use. Please respect the terms of use for the Stanford Locator Service and any data you process.

