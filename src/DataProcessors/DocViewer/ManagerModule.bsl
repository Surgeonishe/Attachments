
Function GenerateHTML ( FileName ) export
	
	html = makeHTML ( FileName );
	return html;
	
EndFunction

Function makeHTML ( FileName )
	
	s = "";
	ext = GetExtension ( FileName );
	if ( ext = "gif" or ext = "jpg" or ext = "jpeg" or ext = "tiff" ) then
		s = makeForImage ( FileName );
	elsif ( ext = "txt" ) then
		s = makeForTXT ( FileName );
	elsif ( ext = "xml" ) then
		s = makeForXML ( FileName);
	elsif ( ext = "pdf" ) then
		s = makeForPDF ( FileName );
	elsif ( ext = "doc" or ext = "docx" ) then
		s = makeForMSDOC ( FileName );
	elsif ( ext = "xls" or ext = "xlsx" ) then
		s = makeForMSDOC ( FileName );
	endif;
	return s;
	
EndFunction

Function makeForImage ( FileName )
	
	template = getPattern ( "IMAGE" );
	return ( StrReplace ( template, "#DATA_FILE#", FileName ) );
	
EndFunction

Function makeForTXT ( FileName )
	
	template = getPattern ( "TXT" );
	text = GetTextFile ( FileName );
	return ( StrReplace ( template, "#DATA_FILE#", text ) );
	
EndFunction

Function GetTextFile ( FileName ) Export
	
	reader = new TextDocument ();
	reader.Read ( FileName, TextEncoding.UTF8 );
	s = reader.GetText ();
	reader = undefined; 	
	return s;

EndFunction
	
Function makeForXML ( FileName )
	
	temp = GetTempFileName ( "xml" );
	writer = new XMLWriter ();
	writer.OpenFile ( temp );
	text = GetTextFile ( FileName );
	writer.WriteRaw ( text );
	writer.Close ();
	return temp;
	
EndFunction

Function makeForPDF ( FileName )
	
	binary = new BinaryData ( FileName );
	string64 = GetBase64StringFromBinaryData ( binary );
	template = getPattern ( "PDF" );
	return ( StrReplace ( template, "#DATA_FILE#", string64 ) );	
	
EndFunction

Function makeForMSDOC ( FileName )
	
	data = new BinaryData ( FileName );
	address = PutToTempStorage ( data, new UUID () );
	link = getInfobaseLink ( address );
	template = getPattern ( "MSDOC" );
	// временное решение для показа работоспособности
	link = "https://dogma.su/upload/iblock/38d/38d44711862f284574f1351e52dbabb5.doc";
	link = "https://kub-24.ru/wp-content/uploads/price_02.03.2020.xlsx";
	return ( StrReplace ( template, "#DATA_FILE#", link ) );
	
EndFunction

Function getInfobaseLink ( Address )
	
	return GetInfoBaseURL () + "/" + Address;

EndFunction 

Function GetExtension ( File ) export

	pos = 0;
	ext = File;
	while ( true ) do
		pos = Find ( ext, "." );
		if ( not pos ) then
			break;
		else
			ext = Mid ( ext, pos + 1 );
		endif;
	enddo;
	return ?( ext = File, "", Lower ( ext ) );

EndFunction

Function getPattern ( Name )
	
	template = DataProcessors.DocViewer.GetTemplate ( Name );
	return template.GetText ();
	
EndFunction