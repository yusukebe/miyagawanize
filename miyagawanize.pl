#!/usr/bin/perl
use strict;
use warnings;
use Imager;
use Image::ObjectDetect;

my $file = shift or die "image file path is required!";
my $image    = Imager->new->read( file => $file );
my $cascade  = './haarcascade_frontalface_alt2.xml';
my $detector = Image::ObjectDetect->new($cascade);
my @faces    = $detector->detect($file);

my $purple_source = Imager->new->read(file => './purple.png');
my $aspect = 1.5;

for my $face (@faces) {
    my $purple = $purple_source->scale(
        xpixels => $face->{width} / $aspect,
        ypixels => $face->{height} / $aspect,
    );
    $image->rubthrough(
        tx  => $face->{width} / $aspect / 2 + $face->{x},
        ty  => $face->{height} / $aspect + $face->{y},
        src => $purple,
    );
}

$image->write( file => './output.jpg' );

__END__
