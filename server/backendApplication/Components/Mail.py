import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

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
    
    # Send an OTP to Person Email Address
    def sendOTP(self, otpCode):

         # Create a new mail
        msg = MIMEMultipart('alternative')
        msg['Subject'] = self.subject
        msg['From'] = self.sender
        msg['To'] = ', '.join(self.recipients)

        # Create the HTML part of the email
        html = f"""
        <html>
        <body>
            <div style="font-family: Helvetica,Arial,sans-serif;min-width:1000px;overflow:auto;line-height:2">
                <div style="margin:50px auto;width:70%;padding:20px 0">
                        <div style="border-bottom:1px solid #eee">
                            <a href="" style="font-size:1.4em;color: #00466a;text-decoration:none;font-weight:600">Vivid Estate</a>
                        </div>
                            <p>New account verification request. To complete your account verification, please use the following One-Time Password (OTP). If you did not request this code, please contact our support team immediately.</p>
                            <h2 style="background: #00466a;margin: 0 auto;width: max-content;padding: 0 10px;color: #fff;border-radius: 4px;">{otpCode}</h2>
                            <p style="font-size:0.9em;">Best Regards,<br />Vivid Estate Team</p>
                            <hr style="border:none;border-top:1px solid #eee" />
                        <div style="float:right;padding:8px 0;color:#aaa;font-size:0.8em;line-height:1;font-weight:300">
                            <p>Vivid Estate</p>
                            <p>Your Path to Real Residence</p>
                        </div>
                        </div>
                </div>
        </body>
        </html>
        """

        # Attach the HTML part to the email
        msg.attach(MIMEText(html, 'html'))

        # Begin the Sending Process
        with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smtp_server:
            # Login to Mail Server
            smtp_server.login(self.sender, self.password)

            # Send the Mail
            smtp_server.sendmail(self.sender, self.recipients, msg.as_string())

        # Display Log to Terminal
        print(f"-> OTP Send | To: {self.recipients} | Subject: {self.subject} | OTP: {otpCode}")


