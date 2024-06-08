from ..modules.helper import *
from django.views.decorators.csrf import csrf_exempt
from ..models import *
from django.conf import settings

# Import Application Components
from ..Components.UserComponent import *
from ..Components.ChatSystem import *
from ..Components.ImageStitching import *

# Display Matrix in Nice Foramt
def display_matrix(ImageMatrix):
    for row in ImageMatrix:
        print(' '.join(['1' if elem else '0' for elem in row]))

# Use regular expression to extract the numbers from the string
def string_to_coordinates(s):
    match = re.match(r'image(\d+)x(\d+)', s)
    if match:
        x = int(match.group(1))
        y = int(match.group(2))
        return (x, y)
    else:
        raise ValueError("String format is incorrect")

# Stich Images Together
def stitchImageVertically(img1, img2, img3):

    # Store the Images
    fileHandler = FileHandler()

    # Now Perform Stitching
    imageStitching = ImageStitching()

    try:
        img1Location = fileHandler.storeFile(img1)
    except:
        img1Location = ""

    try:
        img2Location = fileHandler.storeFile(img2)
    except:
        img2Location = ""

    try:
        img3Location = fileHandler.storeFile(img3)
    except:
        img3Location = ""

    # Find Size for the Image
    size = imageStitching.findSize(
        [img1Location, img2Location, img3Location]
    )

    # Open Images
    images = imageStitching.openImages([
        img1Location, img2Location, img3Location
    ], size)
    filename = imageStitching.sitchVertically(images)

    # Now Remove Files
    try:
        fileHandler.deleteFile(img1Location)
    except:
        print("Unable to delete all files")

    try:
        fileHandler.deleteFile(img2Location)
    except:
        print("Unable to delete file")
    
    try:
        fileHandler.deleteFile(img3Location)
    except:
        print("Unable to delete file")
    
    return filename

# Stitch Images Together to Create Panaroma Image
@csrf_exempt
def StitchImagesView(request):


    # Matrix Creation
    ImageMatrix = []

    # Loop Through All the Files
    for imgFile in request.FILES:

        # Extract coordinates from filename
        coordinates = string_to_coordinates(imgFile)
        x, y = coordinates

        # Log Console
        print(f"FileName: {imgFile} Location {request.FILES[imgFile]}")

        # Add Images to Matrix
        if x == ImageMatrix.__len__():
            ImageMatrix.append(["","",""])
        ImageMatrix[x][y] = request.FILES[imgFile]
    
    # Store The List of All Verticall Stitches
    imagesVertical = []
    fileNames = []

    # Perform Vertical Stitch
    for image in ImageMatrix:

        # Stich First and Second Image
        fileName = stitchImageVertically(image[2], image[1], image[0])
        imagesVertical.append(Image.open(settings.FILESTORAGE + f"/{fileName}"))
        fileNames.append(fileName)
        
    
    # Perform Horizontal Stitches
    imageStitching = ImageStitching()
    finalImage = imageStitching.stitchHorizontally(imagesVertical)

    # Delete All the Files
    for fileName in fileNames:
        os.remove(settings.FILESTORAGE + f"/{fileName}")

    return httpSuccessJsonResponse(finalImage)