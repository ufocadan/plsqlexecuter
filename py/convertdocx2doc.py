from docx import Document

# Load the .docx file
docx_path = r"D:\GDrive-MKZ\Shared drives\MKZ\Talepler\Ünal Foçadan\AEGL-12993\AEGL-12993_MKZ-83488_V1.docx"
document = Document(docx_path)

# Save as .doc (note: true .doc conversion may require a library like LibreOffice)
doc_path = r"D:\GDrive-MKZ\Shared drives\MKZ\Talepler\Ünal Foçadan\AEGL-12993\AEGL-12993_MKZ-83488_V1.doc"
document.save(doc_path)