# Abusing Office Capabilities

Office functionality that can be abused for effective social engineering and gain a foothold onto a network.

## Case 1: Object Linking and Embedding (OLE) Objects

When macros are globally disabled, malware authors can use OLE capabilities to trick users to enabling and downloading malicious content.

OLE allows embedding and linking to documents and other objects.  This allows data from one application to be stored in the document of another application.  The *first app* is the **creating application** and the *second app* is the **container application**.

**Ex:** Embed a spreadsheet (creating) into a word (container) document.  When the word doc will interact with the spreadsheet app to display the spreadsheet to the user.



 

