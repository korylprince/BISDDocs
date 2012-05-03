#Taken in part from http://kermit.yaxs.net/post/2061563927/request-tracker-quick-n-dirty-sending-sms-on-change

# load the ticket and info
my $Ticket = $self->TicketObj;
my $QueueName = $Ticket->QueueObj->Name;
my $Requestor = $Ticket->RequestorAddresses;
my $Subject = $Ticket->Subject;
my $url = $RT::WebURL . "m/ticket/show?id=" . $Ticket->Id;

# Check which queue ticket is in and get queue owner
my $user = RT::User->new($RT::SystemUser);

if ($QueueName eq "QUEUE1") {
    $user->Load('user1');
}
elsif ($QueueName eq "QUEUE2") {
    $user->Load('user2');
}
else {
    $RT::Logger->info ( 'Not sending notification SMS - Ticket Created in System');
    return 1;
}
my $OwnerMobileNumber = $user->MobilePhone;

# check if we have a mobile number for the new owner, leave a log message and quit if we dont
if ( !$OwnerMobileNumber ) {
    $RT::Logger->info ( 'Not sending notification SMS - no mobile number found for owner');
    return 1;
}

# Log the sms
$RT::Logger->info ( 'Sending SMS to '.$OwnerMobileNumber.', ticket subject is '.$Ticket->Subject.' requested by '.$Ticket->RequestorAddresses );

# Get the ticket body 
my $Content = $Ticket->Transactions->First->Content();

# build command
# python notify.py number url << sms body
my $command = "python /opt/notify.py $OwnerMobileNumber \"$url\"  <<EOF\nNew $QueueName Ticket:\n$Requestor - $Subject:\n$Content\nEOF";

# execute command and get output 
my $output = `$command`;

# add system comment
$self->TicketObj->Comment(
        Content=>"Outgoing SMS Sent:\n".$output
        );
return 1;
