#!/usr/bin/python
# -*- coding: utf-8 -*-
import os
import smtplib
import mimetypes
from email import encoders
from email.mime.audio import MIMEAudio
from email.mime.base import MIMEBase
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

from log4u import say_it, say_tb

__author__ = 'Shawn Yan'
__date__ = '9:20 2018/5/21'


def _send_email(sender, receivers, msg):
    try:
        mail_server = smtplib.SMTP("LSHMAIL1.latticesemi.com")
        mail_server.sendmail(sender, receivers, msg)
        say_it("Send out email successfully")
    except:
        say_tb()
        return 1


def send_text_email(sender, receivers, subject, text_message):
    msg = MIMEText(text_message)
    msg["Subject"] = subject
    msg["From"] = sender
    msg["To"] = receivers
    _send_email(sender, receivers, msg.as_string())


def send_html_email(sender, receivers, subject, html_message):
    msg = MIMEText(html_message, _subtype="html")
    msg["Subject"] = subject
    msg["From"] = sender
    msg["To"] = receivers
    _send_email(sender, receivers, msg.as_string())


def _email_attachment(a_file):
    ctype, encoding = mimetypes.guess_type(a_file)
    if ctype is None or encoding is not None:
        ctype = 'application/octet-stream'
    main_type, sub_type = ctype.split('/', 1)

    mime_type = dict(text=MIMEText, image=MIMEImage, audio=MIMEAudio, default=MIMEBase)
    fp = open(a_file).read()
    if main_type in mime_type:
        _ = mime_type[main_type]
        att = _(fp, _subtype=sub_type)
    else:
        _ = mime_type["default"]
        att = _(main_type, sub_type)
        att.set_payload(fp)
        encoders.encode_base64(att)
    att.add_header('Content-Disposition', 'attachment', filename=os.path.basename(a_file))
    return att


def sent_text_email_attachment(sender, receivers, subject, text_message, attachments):
    msg = MIMEMultipart()
    msg["Subject"] = subject
    msg["From"] = sender
    msg["To"] = receivers
    part1 = MIMEText(text_message)
    msg.attach(part1)
    for att in attachments:
        msg.attach(_email_attachment(att))
    _send_email(sender, receivers, msg.as_string())


def sent_html_email_attachment(sender, receivers, subject, html_message, attachments):
    msg = MIMEMultipart()
    msg["Subject"] = subject
    msg["From"] = sender
    msg["To"] = receivers
    part1 = MIMEText(html_message, _subtype="html")
    msg.attach(part1)
    for att in attachments:
        msg.attach(_email_attachment(att))
    _send_email(sender, receivers, msg.as_string())


if __name__ == "__main__":
    sent_text_email_attachment("shawn.yan@latticesemi.com",
                               "shawn.yan@latticesemi.com",
                               "my subject",
                               "check again!",
                               ["D:/radiant_auto/ng1_1.360/components.xml"])
