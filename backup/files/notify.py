'''
Checks log file for some info and sends texts
'''

from twilio.rest import TwilioRestClient
import commands
import re
import sys

account = "xxxx"
token = "xxxx"
client = TwilioRestClient(account, token)

f = open(sys.argv[1], 'r')
text = f.read()
f.close()
splittext = text.split('\n')
success = 'Success' if 'Error running backup' not in text else 'Failed'
sftpindex = splittext.index([x for x in splittext if 'sftp' in x][0])

size = [x for x in splittext[sftpindex + 2].split(' ') if x != '']

msg = "\nBackup: {0}\n\
space used: {1}\n\
space left: {2}\n\
% used: {3}\n".format(success,size[1],size[2],size[4])

message = client.sms.messages.create(to="<send-to Number>", from_="<twilio number>",body=msg)
