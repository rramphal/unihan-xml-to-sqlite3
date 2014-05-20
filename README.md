## Unihan XML to SQLite3
###### Ravi S. Rāmphal // 2014.02.12 // Updated 2014.05.20

***

### Description

This is a script to read the [XML file](http://www.unicode.org/Public/UCD/latest/ucdxml/ucd.unihan.flat.zip) provided by the [Unicode Unihan Database project](http://www.unicode.org/charts/unihan.html) into a query-able SQLite3 database.

***

### Reflection

I decided to upload the raw XML file as well as the generated SQLite3 file for my own convenience. However, the script can be refactored to download the XML file directly from the server, unzipping it, generating the database, and then deleting the XML file. I can also look into the difference between using just the Unihan information and the complete UCD information.