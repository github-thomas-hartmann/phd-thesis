<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    <sch:pattern>
        <sch:rule context="/">
            <sch:assert test="library">library must be the root element</sch:assert>
        </sch:rule>
        <sch:rule context="/library">
            <sch:assert test="book">at least 1 book</sch:assert>
            <sch:assert test="not(@*)">library cannot have any attributes</sch:assert>
        </sch:rule>
        <sch:rule context="/library/book">
            <sch:assert test="not(following-sibling::book/@id=@id)">
                book ids must be unique within the XML document
            </sch:assert>
            <sch:assert test="@id=concat('_', isbn)">
                book ids must be derived from the text content of isbn
            </sch:assert>
        </sch:rule>
        <sch:rule context="/library/*">
            <sch:assert test="name()='book' or name()='author'">
                allowed child elements of library: book, author
            </sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>