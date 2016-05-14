::Saxon-B 9.1.0.8

ECHO OFF

SET absolutePath=C:\Daten\Studium\Promotion\journals\2013\IJMSO

java net.sf.saxon.Transform -s:%absolutePath%\input.xsd -xsl:%absolutePath%\timeDifference.xsl -o:%absolutePath%\timeDifference.txt
		
PAUSE