"""vividEstate URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.urls import path, include
from .Views import AccountViews
from .Views import ChatViews
from .Views import IssueReport
from .Views import AdvertisementAPI

urlpatterns = [

    # Account Management End Points
    path("ocr_cnic", view=AccountViews.OcrCNIC, name="CNIC OCR"),
    path("login", view=AccountViews.loginUser, name="Login"),
    path("signup", view=AccountViews.SignUp, name="Sign Up"),
    path("otp_verify", view=AccountViews.verify_otp, name="OTP Verification"),
    path("resend_otp", view=AccountViews.resendOTP, name="OTP Resend"),
    path("store_cnic", view=AccountViews.storeCNICData, name="CNIC Data Store"),
    path("forgot_password", view=AccountViews.forgotPassword, name="User Forgot Password"),
    path("password_reset_otp", view=AccountViews.verifyPasswordResetOTP, name="Verify Password Reset OTP"),
    path("reset_password", view=AccountViews.passwordReset, name="Reset Password"),
    path("delete_account", view=AccountViews.deleteAccount, name="Delete User Account"),
    path("profile_data", view=AccountViews.getUserProfileData, name="Get User Profile Data"),
    path("update_profile_picture", view=AccountViews.updateProfilePicture, name="Update User Profile Picture"),
    path("update_profile", view=AccountViews.updateProfileData, name="Update the User Profile Data"),
    path("update_feedback", view=AccountViews.updateFeedback, name="Update User Feedback"),

    # Chat API EndPoints
    path("initiate_chat", view=ChatViews.InitiateChat, name="Initiate Chat"),
    path("send_message", view=ChatViews.sendMessage, name="Send Message"),
    path("get_all_chats", view=ChatViews.get_all_user_chat, name="All Chats Data"),
    path("get_all_messages", view=ChatViews.get_all_chat_messages, name="Get Chat Messages"),
    path("get_all_unview_messages", view=ChatViews.get_all_unview_messages, name="Get Unview Messages"),
    path("delete_chat", view=ChatViews.deleteUserChat, name="Delete User Chat"),

    # User Issue & Reports
    path("submit_issue", view=IssueReport.submitIssueReport, name="User Issue Submit"),

    # Add Management API Endpoints
    path("submit_new_ad", view=AdvertisementAPI.StoreNewAd, name="Create a new Advertisement"),
    path("search_property", view=AdvertisementAPI.SearchLocationProperty, name="Search Properties with Location and Filters"),
    path("search_property_all", view=AdvertisementAPI.DetailSearchQuery, name="Detail Search Results of the Properties"),
    
    

]
