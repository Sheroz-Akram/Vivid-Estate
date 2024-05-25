from django.core.files.storage import FileSystemStorage
from django.conf import settings

class FileHandler:

    # Delete File In Storage
    def deleteFile(self, fileName: str):

        # Create an Instance of File Storage
        fs = FileSystemStorage(location=settings.FILESTORAGE)

        # Now We Delete the File From Storage
        fs.delete(fileName)

