import uuid
from PIL import Image, ExifTags

from django.conf import settings


# Stitch Mutiple Images to Together
class ImageStitching:

    # Load Image from its Path
    def loadImage(self, path):

        img = Image.open(settings.FILESTORAGE + f"/{path}")
        for orientation in ExifTags.TAGS.keys() : 
            if ExifTags.TAGS[orientation]=='Orientation' : break 

        exif=dict(img._getexif().items())

        if   exif[orientation] == 3 : 
            img=img.rotate(180, expand=True)
        elif exif[orientation] == 6 : 
            img=img.rotate(270, expand=True)
        elif exif[orientation] == 8 : 
            img=img.rotate(90, expand=True)

        return img

    # fineSizeOfImages
    def findSize(self, imagePaths):
        for path in imagePaths:
            try:
                img = self.loadImage(path)
                return img.size
            except Exception as e:
                print("Exception")

    # Open All the Images
    def openImages(self, imagePaths, size):
        images = []
        for path in imagePaths:
            try:
                img = self.loadImage(path)
            except Exception as e:
                # Create a black image of the same size if the image is not found
                if images.__len__() == 0:
                    img = Image.new("RGB", size , color="black")
                else:
                    img = Image.new("RGB", images[-1].size , color="black")
            images.append(img)
        return images

    # Stich Images Vertically
    def sitchVertically(self, images, overlap_percent=0.05):

        # Open images and calculate the total height with overlap
        total_width = max(img.width for img in images)
        total_height = sum(img.height for img in images) - sum(int(img.height * overlap_percent) for img in images[1:])

        # Create a new blank image with the calculated dimensions
        stitched_image = Image.new("RGB", (total_width, total_height), color="black")

        # Paste images vertically with overlap
        y_offset = 0
        for img in images:
            # Paste image at the current offset
            stitched_image.paste(img, (0, y_offset))
            # Calculate overlap for the current image
            overlap = int(img.height * overlap_percent)
            # Update the offset for the next image
            y_offset += img.height - overlap

        # Create Random Name
        fileNewName = "file_" + str(uuid.uuid4()) + ".jpg"

        # Save the stitched image
        stitched_image.save(settings.FILESTORAGE + f"/{fileNewName}")

        return fileNewName

    # Stitch Images Horizontally
    def stitchHorizontally(self, images, overlap_percent=0.05):

        # Open images and calculate the total width and height with overlap
        total_width = sum(img.width for img in images) - sum(int(img.width * overlap_percent) for img in images[1:])
        total_height = max(img.height for img in images)

        # Create a new blank image with the calculated dimensions
        stitched_image = Image.new("RGB", (total_width, total_height), color="black")

        # Paste images horizontally with overlap
        x_offset = 0
        for img in images:
            # Paste image at the current offset
            stitched_image.paste(img, (x_offset, 0))
            # Calculate overlap for the current image
            overlap = int(img.width * overlap_percent)
            # Update the offset for the next image
            x_offset += img.width - overlap

        # Create Random Name
        fileNewName = "file_" + str(uuid.uuid4()) + ".jpg"

        # Save the stitched image
        stitched_image.save(settings.FILESTORAGE + f"/{fileNewName}")

        return fileNewName
