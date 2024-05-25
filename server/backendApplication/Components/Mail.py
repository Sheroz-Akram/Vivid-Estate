import smtplib
from email.mime.text import MIMEText

class Mail:

    # Credintials for our email service
    sender = "vivid.estate01@gmail.com"
    password = "lnoijpjsnggukynp"

    # Constructor Mail Class
    def __init__(self, subject:str):
        self.subject = subject
        self.recipients = []

    # Add New Recipients to our Mail
    def addRecipients(self, recipient:str):
        self.recipients.append(recipient)

    # Set the Body Of Mail
    def setBody(self, body:str):
        self.body = body

    # Send Mail
    def sendMail(self):

        # Create a new Mail
        msg = MIMEText(self.body)
        msg['Subject'] = self.subject
        msg['From'] = self.sender
        msg['To'] = ', '.join(self.recipients)

        # Begin the Sending Process
        with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smtp_server:

            # Login to Mail Server
            smtp_server.login(self.sender, self.password)

            # Send the Mail
            smtp_server.sendmail(self.sender, self.recipients, msg.as_string())

        # Display Log to Terminal
        print(f"-> Email Send | To: {self.recipients} | Subject: {self.subject}")

