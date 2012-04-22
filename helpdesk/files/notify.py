"""
Sends SMS message. Should be run like:

python notify.py '<number to send to>' 'message to send' 'url'

requires twilio and TinyUrl python modules

"""

import sys
import tinyurl
from twilio.rest import TwilioRestClient

account = "xxxx"
token = "xxxx"
client = TwilioRestClient(account, token)

url = tinyurl.create_one(sys.argv[3])
number = sys.argv[1]
text = sys.argv[2]+" \n"+url
if len(text) > 160:
    print "Message too long"
    sys.exit(0);

for num in number.split(','):
    if not num.isdigit():
        print "Phone number is not valid."
        sys.exit(0);
    message = client.sms.messages.create(to=num, from_="<twilio number>",body=text)
print text
