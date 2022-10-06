Step 1

File 1_construct_X.R shows you construction of X list from original txt files.
If you want to skip it, use ready X_real_data.Rdata

Step 2

This describes how you can retrieve protein-protein interaction network from STRING database.
If you want to skip it, use ready string_network.tsv

Use gene_names as inout for STRING database. https://string-db.org/ 
Search -> Multiple Proteins -> Add gene names list -> Choose Homo Sapiens organism ->
Continue -> Mapping (download the file of how STRING matched gene names) -> 
Continue -> Settings -> Active interaction sources "Experiments" and "Databases" ->
Minimum required interaction score "Highest confidence 0.9" -> Update -> Exports -> 
Download "as short tabular text output: tsv"

Step 3
2_string_network makes a graph object from tsx network and calculates weights for minimization problem. If you want to skip it,
use 





