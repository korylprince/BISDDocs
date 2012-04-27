"""
Sends SMS message. Should be run like:

python notify.py '<number to send to>' 'url' << message to send

Where << signifies input is expected from stdin

requires twilio and TinyUrl python modules

"""

import sys
import tinyurl
from twilio.rest import TwilioRestClient

account = "xxxx"
token = "xxxx"
client = TwilioRestClient(account, token)

# get url and create text
url = tinyurl.create_one(sys.argv[2])
number = sys.argv[1]
text = sys.stdin.read()
# Cut off text before 60 characters
text = text[0:160-len(url)-4] +"...\n"+ url 

# send to multiple phones if present
for num in number.split(','):
    if not num.isdigit():
        print "Phone number is not valid."
        sys.exit(0);
    message = client.sms.messages.create(to=num, from_="<twilio number>",body=text)
# output text sent
print text
