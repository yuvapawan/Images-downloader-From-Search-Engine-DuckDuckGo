use strict;
use LWP::Simple;
my $page=1;
my $temp=0;
my $cnt=0;
my $count=50;
my $id;
print "Your search please: ";
my $search = <STDIN>;
chomp $search;
$search=~s/\s/%20/isg;
my $content = get("https://duckduckgo.com/?q=$search&t=hf&iax=images&ia=images");
if($content=~/vqd='(.*?)';/is)
{
	$id=$1;
}
my $content1 = get("https://duckduckgo.com/i.js?l=wt-wt&o=json&q=$search&vqd=$id&f=,,,&p=0");
&download_images($content1);
sub download_images
{
	my $content1=shift;
	while($content1=~m/"image":"(.*?)"/isg)
	{
        	my $image_url=$1;
		print "$image_url\n";
		my $image=$image_url;
		while($image=~/\//isg)
		{
			$image=~s/.*?\///isg;
		}
		$image="/home/nambiaruran/Desktop/Pawan/logs/"."$image";
		#getstore($image_url, $image);
		system("wget --tries=3 --user-agent=\"googlebot(compatible; Mozilla 4.0; MSIE 5.5)\"  -q -t 6 -O $image \"$image_url\" &");
		$cnt++;
	}
	if($temp<$cnt)
        {
             $temp=$cnt;
             &download_pages();
        }
}
sub download_pages
{
	my $next_url="https://duckduckgo.com/i.js?q=$search&p=1&s=$count&u=yahoo&f=,,,&l=wt-wt&vqd=$id";
	$page++;
	$count=$count+50;
	print "\n$page\n\n";
	my $next_content = get($next_url) or die 'Unable to get page';
	&download_images($next_content);
}
