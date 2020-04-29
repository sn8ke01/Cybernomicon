## Macro Fundies

 Visial Basic for Applications code can be embedded in MS Office files with the goal of automating and accessing Win API and other low-level funtions, from withing the MS files.
 
As of MS Office '07 macros can't be embedded in the default MS Word document file.


| File Extension| File Type     | Macro Permit?|
| ------------- |:-------------:| -----:|
| DOCX          | compressed document | No |
| DOTX          | compressed template | Yes|
| DOCM          | compressed document | Yes|
|DOTM           | compressed template | Yes|

MS Windows uses file extentions to determine the software that will handle opening the file when clicked.

Word performs file data validation prior to opening a file.  Data validation is performed in the form of data structure identification, against OfficeOpen XML standard.

Validation is performed by *WWWLIB.DLL*.

**File extenstion plays no role data validation**
If an error occurs during data structure identification, the file will not be opened.

DOCM files with macros can be renamed as other formats by changing the extension and *still keep* macro execution capabilites.

EX: RTF files does not support macros but a DOCM file renamed to and RTF will be handled by MS Word and be capable of macro execution.

Same internal mechanism applies to all MS Office Suite software.

File asociation cmd to determine which files are associated to Office programs.  Replace *string* with either **word, excel,** or **powerp**

```cmd
assoc | findstr /i "string"
```

**Remote Templates** are exception.  A DOCX file refing a remote template that includes macros can "execute" macros.

*Ref a Remote Template*:
File - Options Add-ins Manage: Templates - Go
