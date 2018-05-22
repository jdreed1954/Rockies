library(XML)
# Also load the other required package.
library("methods")
# Give the input file name to the function.
result <- xmlParse(file = "employee.xml")
# Exract the root node form the xml file.
rootnode <- xmlRoot(result)

# Find number of nodes in the root.
rootsize <- xmlSize(rootnode)

# Print the result.
print(rootsize)
# Exract the root node form the xml file.
rootnode <- xmlRoot(result)

# Print the result.
print(rootnode[1])


# Get the first element of the first node.
print(rootnode[[1]][[1]])

# Get the fifth element of the first node.
print(rootnode[[1]][[5]])

# Get the second element of the third node.
print(rootnode[[3]][[2]])

# Convert the input xml file to a data frame.
xmldataframe <- xmlToDataFrame("employee.xml")
print(xmldataframe)
