#Taken in part from http://kermit.yaxs.net/post/2061563927/request-tracker-quick-n-dirty-sending-sms-on-change

# don't send if user makes self owner
if ($self->TicketObj->Owner == $self->TransactionObj->Creator) {
  $RT::Logger->info ( 'Not sending notification SMS - Creator made change');
  return 1;
}

# load the ticket and info
my $Ticket = $self->TicketObj;
my $QueueName = $Ticket->QueueObj->Name;
my $Requestor = $Ticket->RequestorAddresses;
my $Subject = $Ticket->Subject;
my $url = $RT::WebURL . "m/ticket/show?id=" . $Ticket->Id;

# Check which queue ticket is in and get queue owner
my $user = RT::User->new($RT::SystemUser);
my $OwnerID = $self->TicketObj->Owner;
$user->Load($OwnerID);
my $OwnerMobileNumber = $user->MobilePhone;

# check if we have a mobile number for the new owner, leave a log message and quit if we dont
if ( !$OwnerMobileNumber ) {
  $RT::Logger->info ( 'Not sending notification SMS - no mobile number found for owner');
  return 1;
}

# Log the sms
$RT::Logger->info ( 'Sending SMS to '.$OwnerMobileNumber.', ticket subject is '.$Ticket->Subject.' requested by '.$Ticket->RequestorAddresses );

my $Content = $Ticket->Transactions->First->Content();

my $command = "python /opt/notify.py $OwnerMobileNumber \"$url\"  <<EOF\nTicket assigned:\n$Requestor - $Subject:\n$Content\nEOF";

# and backticks to exec the sms script 
my $output = `$command`;

# add system comment
$self->TicketObj->Comment(
Content=>"Outgoing SMS Sent:\n".$output
);
return 1;
