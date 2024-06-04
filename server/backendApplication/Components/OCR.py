import easyocr as ocr
import cv2 as cv
import matplotlib.pyplot as plt
from scipy.spatial import distance


def normalize(img,result):
    w,h = img.shape[:-1]
    normalize_bbx = []
    detected_labels = []
    for (bbox, text, prob) in result:
        (tl, tr, br, bl) = bbox
        tl[0],tl[1] = round(tl[0] / h,3),round(tl[1] / w,3)
        tr[0],tr[1] = round(tr[0] / h,3),round(tr[1] / w,3)
        br[0],br[1] = round(br[0] / h,3),round(br[1] / w,3)
        bl[0],bl[1] = round(bl[0] / h,3),round(bl[1] / w,3)
        normalize_bbx.append([tl,tr,br,bl])
        detected_labels.append(text)
    return normalize_bbx,detected_labels



def calculate_distance(key,bbx):
    euc_sum = 0
    for val1,val2 in zip(key,bbx):
        euc_sum = euc_sum + distance.euclidean(val1,val2)
        return euc_sum

def get_value(key,normalize_output):
    distances = {}
    for bbx,text in normalize_output:
        distances[text] = calculate_distance(key,bbx)
    return distances   


def getCnicDetails(image_path):

    # OCR the Image using Easy OCR
    reader = ocr.Reader(['en'])
    image = cv.imread(image_path)
    result = reader.readtext(image_path)

    # Normalized the Data
    norm_boxes,labels = normalize(image,result)
    normalize_output = list(zip(norm_boxes,labels)) 

    #print(normalize_output)

    # name_key = [[0.272, 0.233], [0.323, 0.233], [0.323, 0.27], [0.272, 0.27]]
    name_value = [[0.283, 0.271], [0.415, 0.271], [0.415, 0.325], [0.283, 0.325]]
    # identity_key = [[0.261, 0.695], [0.442, 0.695], [0.442, 0.743], [0.261, 0.743]]
    identity_value = [[0.281, 0.768], [0.496, 0.768], [0.496, 0.83], [0.281, 0.83]]
    # father_key = [[0.285, 0.42], [0.388, 0.42], [0.388, 0.457], [0.285, 0.457]]
    father_value = [[0.29, 0.456], [0.494, 0.456], [0.494, 0.514], [0.29, 0.514]]
    # dob_key = [[0.519, 0.713], [0.631, 0.713], [0.631, 0.756], [0.519, 0.756]]
    dob_value = [[0.529, 0.751], [0.648, 0.751], [0.648, 0.803], [0.529, 0.803]]

    # Desired Output Fields
    dict_data = {}
    output_dict = {}
    output_dict['Name'] = name_value
    output_dict['CNIC No'] = identity_value
    output_dict['Father Name']  = father_value
    output_dict['Date of Birth'] = dob_value

    for key,value in output_dict.items():
        output_dict = get_value(value,normalize_output)
        answer = list(min(output_dict.items(), key=lambda x: x[1]))[0]
        dict_data[key] = answer 

    # Display Log to Terminal
    print(f"-> CNIC OCR Complete | Result: {str(dict_data)}")

    return dict_data
