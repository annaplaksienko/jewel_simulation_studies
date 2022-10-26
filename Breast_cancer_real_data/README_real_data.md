#### Step 1

File *1\_construct\_X.R* shows you construction of X list from original txt files.
If you want to skip it, use ready *X\_real\_data.Rdata*.

#### Step 2

This describes how you can retrieve protein-protein interaction network from STRING database.
If you want to skip it, use ready *string\_network.tsv*

Use *gene_names.txt* as an input for the [STRING database](https://string-db.org/). 
Search -> Multiple Proteins -> Add gene names list -> Choose Homo Sapiens organism ->
Continue -> Mapping (download the file of how STRING matched gene names) -> 
Continue -> Settings -> Active interaction sources "Experiments" and "Databases" ->
Minimum required interaction score "Highest confidence 0.9" -> Update -> Exports -> 
Download "as short tabular text output: tsv"

####Step 3

File *2\_string\_network.R* makes a graph object from tsv network and calculates weights for minimization problem. If you want to skip it, use ready *string\_network\_3\%\_hub10.Rdata*.







