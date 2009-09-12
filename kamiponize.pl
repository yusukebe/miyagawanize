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

my $kamipo_source = Imager->new->read(file => './kamipo.png');

for my $face (@faces) {
    my $kamipo = $kamipo_source->scale(
        xpixels => $face->{width},
        ypixels => $face->{height},
    );
    $image->rubthrough(
        tx  => $face->{x} - $face->{width} / 2,
        ty  => $face->{y} + $face->{height} / 3,
        src => $kamipo,
    );
}

$image->write( file => './output.jpg' );

__END__
