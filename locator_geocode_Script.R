# Load required libraries
library(httr)
library(readr)

# User-configurable parameters
service_url <- "https://locator.stanford.edu/arcgis/rest/services/geocode/NorthAmerica/GeocodeServer/geocodeAddresses"
csv_file_path <- "~/GitHub/Locator-Scripts/Data/oneMillionAddresses.csv" # Path to your CSV file
output_csv_file <- "~/GitHub/Locator-Scripts/Data/geocoded_addresses.csv" # Output CSV file path
chunk_size <- 10 # Number of records per batch
job_size <- 100 # "all" or an integer

# Read CSV file
addresses <- read_csv(csv_file_path)

# Function to geocode addresses
geocode_addresses <- function(batch_addresses, service_url) {
  # Construct request payload
  payload <- list(
    f = "json",
    addresses = toJSON(list(records = batch_addresses), auto_unbox = TRUE)
  )
  
  # Make HTTP POST request
  response <- POST(service_url, body = payload, encode = "json")
  
  # Check for successful response
  if (response$status_code == 200) {
    content <- content(response, "parsed")
    return(content$locations)
  } else {
    stop("Failed to geocode addresses")
  }
}

# Batch processing
results <- list()
for (i in seq(1, nrow(addresses), by = chunk_size)) {
  end <- min(i + chunk_size - 1, nrow(addresses))
  batch <- addresses[i:end, ]
  if (job_size != "all" && as.numeric(job_size) < end) {
    batch <- addresses[i:as.numeric(job_size), ]
  }
  geocoded <- geocode_addresses(batch, service_url)
  results <- c(results, geocoded)
  print(paste("Processed", end, "of", nrow(addresses), "records"))
  if (job_size != "all" && as.numeric(job_size) <= end) {
    break
  }
}

# Convert results to data frame and save to CSV
results_df <- data.frame(matrix(unlist(results), ncol = length(results[[1]]), byrow = T))
write_csv(results_df, output_csv_file)

print("Geocoding completed.")
