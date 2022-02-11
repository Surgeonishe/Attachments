
&AtServer
Procedure OnCreateAtServer ( Cancel, StandardProcessing )
	
	initializing ();
	
EndProcedure

&AtServer
Procedure initializing ()
	
	FileName = "";
	
EndProcedure 

&AtClient
Procedure OpenFile ( Command )
	
	dialog = new FileDialog ( FileDialogMode.Open );
	dialog.Multiselect = false;
	dialog.Filter = РаботаСФайлами.ПолучитьФильтрФайлов ();
	p = new Structure ();
	dialog.Show ( new NotifyDescription ( "SelectFiles", ThisObject, p ) );
	
EndProcedure

&AtClient
Function getFilesFilters ()
	
	s = Nstr ( "ru = 'Все файлы '; en = 'All types '; ua = 'Усі файли '" ) + "(*.gif;*.jpg;*.jpeg;*.png;*.tiff;*.pdf;*.xml;*.txt;*.doc;*.docx;*.xls;*.xlsx)|*.gif;*.jpg;*.jpeg;*.png;*.tiff;*.pdf;*.xml;*.txt;*.doc;*.docx;*.xls;*.xlsx|"
	+ Nstr ( "ru = 'Изображения '; en = 'Images '; ua = 'Зображення '" ) + "(*.gif;*.jpg;*.jpeg;*.png;*.tiff)|*.gif;*.jpg;*.jpeg;*.png;*.tiff|"
	+ Nstr ( "ru = 'PDF '; en = 'PDF '; ua = 'PDF '" ) + "(*.pdf)|*.pdf|"
	+ Nstr ( "ru = 'Текст '; en = 'Text '; ua = 'Текст '" ) + "(*.txt)|*.txt|"
	+ Nstr ( "ru = 'Word '; en = 'Word '; ua = 'Word '" ) + "(*.doc;*.docx)|*.doc;*docx|"
	+ Nstr ( "ru = 'Excel '; en = 'Excel '; ua = 'Excel '" ) + "(*.xls;*.xlsx)|*.xls;*xlsx|"
	+ Nstr ( "ru = 'XML '; en = 'XML '; ua = 'XML '" ) + "(*.xml)|*.xml|";
	Возврат s;

EndFunction

&AtClient
Procedure SelectFiles ( Files, Params ) export
	
	if ( Files = undefined ) then
		return;
	endif;
	FileName = Files [ 0 ];
	HTMLString = makeHTML ( FileName );
	
EndProcedure

&AtServerNoContext
Function makeHTML ( FileName )
	
	return DataProcessors.DocViewer.GenerateHTML ( FileName );
		
EndFunction