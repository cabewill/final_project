#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use JSON;
use LWP::UserAgent;
use POSIX qw(strftime);

# Configuration
my $db_file     = "/opt/feedback_app/webapp/instance/feedback.db";  
my $asana_token = "2/1209273346308614/1209281692667377:e61d0f0cd29a6eb7b72b569e70a75cb1";  
my $asana_project_id = "1209273349038992";  

# Open database connection
my $dbh = DBI->connect("dbi:SQLite:dbname=$db_file", "", "", { RaiseError => 1, AutoCommit => 1 });

# Get timestamp for 24 hours ago
my $yesterday = time() - (24 * 60 * 60);
my $date_threshold = strftime "%Y-%m-%d %H:%M:%S", localtime($yesterday);

# Query for feedback in the last 24 hours
my $sth = $dbh->prepare("SELECT experience FROM feedback WHERE datetime >= ?");
$sth->execute($date_threshold);

# Count positive and negative feedback
my ($positive, $negative) = (0, 0);
while (my ($experience) = $sth->fetchrow_array) {
    $experience eq 'Good' ? $positive++ : $negative++;
}
$sth->finish;
$dbh->disconnect;

# Calculate percentages
my $total = $positive + $negative;
my $pos_percent = $total ? sprintf("%.2f", ($positive / $total) * 100) : 0;
my $neg_percent = $total ? sprintf("%.2f", ($negative / $total) * 100) : 0;

# Prepare Asana task content
my $task_content = "Feedback Analysis (Last 24 hours):\n";
$task_content .= "✅ Positive: $positive ($pos_percent%)\n";
$task_content .= "❌ Negative: $negative ($neg_percent%)\n";
$task_content .= "📊 Total Feedback: $total\n";

# Send task to Asana
my $ua = LWP::UserAgent->new;
my $response = $ua->post(
    "https://app.asana.com/api/1.0/tasks",
    "Content-Type"  => "application/json",
    "Authorization" => "Bearer $asana_token",
    Content         => encode_json({
        data => {
            name        => "Daily Feedback Report",
            notes       => $task_content,
            projects    => [$asana_project_id],
        }
    })
);

# Check Asana API response
if ($response->is_success) {
    print "✅ Asana Task Created Successfully!\n";
} else {
    print "❌ Error creating Asana task: " . $response->decoded_content . "\n";
}
