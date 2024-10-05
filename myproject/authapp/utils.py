# utils.py (create a utility function for face detection)
import cv2
import numpy as np
from django.core.files.base import ContentFile
from django.conf import settings

def process_face_image(image):
    # Load the image
    np_img = np.fromstring(image.read(), np.uint8)
    img = cv2.imdecode(np_img, cv2.IMREAD_COLOR)

    # Load the pre-trained face detection model
    face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')

    # Convert to grayscale
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # Detect faces in the image
    faces = face_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5, minSize=(30, 30))

    if len(faces) == 0:
        return None  # No faces found

    # Draw rectangles around detected faces (for debugging, not necessary)
    for (x, y, w, h) in faces:
        cv2.rectangle(img, (x, y), (x+w, y+h), (255, 0, 0), 2)

    # Re-encode the image after processing (optional, to save a processed image)
    _, encoded_img = cv2.imencode('.jpg', img)
    return ContentFile(encoded_img.tobytes(), 'processed_face.jpg')
# utils.py
import face_recognition
from .models import UserProfile
from django.core.files.base import ContentFile

# utils.py
import face_recognition
from .models import UserProfile

def is_face_duplicate(new_image):
    """
    Check if the uploaded face image matches any existing face in the database.
    """
    # Load the new face image and generate its encoding
    new_image_encoding = get_face_encoding(new_image)
    
    if new_image_encoding is None:
        return False  # No face detected, so no duplicate check

    # Loop through all existing profiles with face images
    profiles = UserProfile.objects.exclude(face_image='')

    for profile in profiles:
        if profile.face_image:
            # Load the existing image from the database
            existing_image_path = profile.face_image.path
            existing_image = face_recognition.load_image_file(existing_image_path)
            existing_image_encoding = face_recognition.face_encodings(existing_image)

            if len(existing_image_encoding) > 0:
                # Compare the new face with the existing face
                results = face_recognition.compare_faces([existing_image_encoding[0]], new_image_encoding)
                if results[0]:  # If the face matches
                    return True

    return False

def get_face_encoding(image):
    """
    Returns the face encoding for an image. Returns None if no face is detected.
    """
    # Convert the uploaded image to a numpy array
    np_img = np.fromstring(image.read(), np.uint8)
    img = cv2.imdecode(np_img, cv2.IMREAD_COLOR)

    # Convert image to face encoding using face_recognition library
    face_encodings = face_recognition.face_encodings(img)

    if len(face_encodings) > 0:
        return face_encodings[0]  # Return the first face encoding
    else:
        return None  # No face found
