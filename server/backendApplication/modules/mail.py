import smtplib
from email.mime.text import MIMEText

# Credintials for our email service
sender = "vivid.estate01@gmail.com"
password = "lnoijpjsnggukynp"

# Send a Email to the User
def send_email(subject, body, recipients):
    msg = MIMEText(body)
    msg['Subject'] = subject
    msg['From'] = sender
    msg['To'] = ', '.join(recipients)
    with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smtp_server:
       smtp_server.login(sender, password)
       smtp_server.sendmail(sender, recipients, msg.as_string())
    print("Email sent! - " + subject)
