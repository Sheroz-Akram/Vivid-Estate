import uuid
from django.core.files.storage import FileSystemStorage
from django.conf import settings

class FileHandler:

    # Delete File In Storage
    def deleteFile(self, fileName: str):

        # Create an Instance of File Storage
        fs = FileSystemStorage(location=settings.FILESTORAGE)

        # Now We Delete the File From Storage
        fs.delete(fileName)

    # Store New File In Storage System
    def storeFile(self, fileData: any):

        # Create or get an instance of FileSystemStorage to handle saving
        fs = FileSystemStorage(location=settings.FILESTORAGE)
            
        # Save the file directly
        fileNewName = "file_" + str(uuid.uuid4()) + fileData.name

        # Store the Files in Server
        fs.save(fileNewName, fileData)

        # Return the name of File
        return fileNewName

