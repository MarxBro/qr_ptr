#!/usr/bin/perl
######################################################################
# Generador random queries.
######################################################################

use strict;
use feature "say";
use Getopt::Std;
use autodie;
use Data::Dumper;
use Crypt::PasswdMD5;
use Digest::SHA "sha1_base64";
use URI::Escape "uri_escape";
use File::Slurp "write_file";
use Imager::QRCode;

######################################################################
# QR OPTIONS
######################################################################
# Colores para usar en la imagen QR.
# pueden ser asi tambien: Imager::Color->new("#C0C0C0");
my $color_claro  = Imager::Color->new( 255, 255, 255 );
my $color_oscuro = Imager::Color->new( 0, 0, 0 );
# Tamaño QR -> NO es en pixeles, es especificacion de modulos (2 - 4).
my $QR_size          = 2;
# Margen... SI es en pixeles.
my $QR_margin        = 2;
# L M Q H 
my $QR_level         = 'M';
# mayusculas, minusculas...
my $QR_casesensitive = 1;

my $qrcode = Imager::QRCode->new(
    size          => $QR_size,
    margin        => $QR_margin,
    version       => 1,
    level         => $QR_level,
    casesensitive => $QR_casesensitive,
    lightcolor    => $color_claro, 
    darkcolor     => $color_oscuro,
);
    

my %opts = ();
getopts('dh',\%opts);

my $debug = $opts{d} || 0;
my $cantidadPasses_a_generar = 10;

my $salt = 'sabaduba123@#^0s0s~~!~';
my @passes = map { $_ = random_hash(64) ; $_ } (0 .. $cantidadPasses_a_generar);
my %codigos_finales = ();
my $id = 1;
my $table_qr = "tabla_qr" . ".csv"; # Salida a CSV

######################################################################
# MAIN
######################################################################
if ( $opts{h} ) {
    ayudas();
    exit;
}
else {
    foreach my $p ( sort(@passes) ) {
        $codigos_finales{$id}{'P'}   = $p;
        $codigos_finales{$id}{'DES'} = crypt( $p, $salt );
        $codigos_finales{$id}{'MD5'} = unix_md5_crypt( $p, $salt );
        my $choclo =
          $codigos_finales{$id}{'DES'} . $codigos_finales{$id}{'MD5'};
        $codigos_finales{$id}{'F'}   = sha1_base64($choclo);
        $codigos_finales{$id}{'URI'} = uri_escape( $codigos_finales{$id}{'F'} );
        $id++;
    }
    my @EQUIVALENCIAS = ();
    my $lna_encabezado = 'ARCHIVO_IMAGEN,CODIGO_ID,URL_CODIGO_ID' . "\n";
    push (@EQUIVALENCIAS,$lna_encabezado);
    foreach my $k ( keys %codigos_finales ) {
        my $F   = $codigos_finales{$k}{'F'};
        my $URI = $codigos_finales{$k}{'URI'};
        my $nn  = $k . '.gif';
        qr_como_un_loco( "$F", "$nn" );
        say "$nn === $F" if $debug;
        my $lna_para_csv_equivalencias = join(',',($nn,$URI,$F)) . "\n";
        push(@EQUIVALENCIAS,$lna_para_csv_equivalencias);
    }
    #guardar una tabla con las equivalencias en texto y QR.
    write_file($table_qr,@EQUIVALENCIAS);
}

######################################################################
# Funciones
######################################################################
sub random_hash {
    my ( $ash, $ml ) = ( '', ( ( defined $_[0] && $_[0] > 0 ) ? $_[0] : 4 ) );
    my $Ml = ( defined $_[1] && $_[1] >= $ml ) ? $_[1] : $ml + 5;
    $ash .= ( '.', '/', 0 .. 9, 'A' .. 'Z', 'a' .. 'z' )[ rand 64 ] 
        foreach ( 1 .. ( $ml + int( rand $Ml - $ml ) ) );
    return $ash;
}

sub qr_como_un_loco {
    my $texto_para_qr        = $_[0];
    my $nombre_archivo_final = $_[1];
    my $img                  = $qrcode->plot($texto_para_qr);
    $img->write( file => "$nombre_archivo_final" );
}

sub ayudas {
    say "Generador de codigos QR." and exit;
}


=pod

=encoding utf8

=head1 SYNOPSIS

Script para generar codigos qr de random strings...

Huevada mayuscula.

=head1 Autor y Licencia.

Programado por B<Marxbro> aka B<Gstv>, un dia de Agosto del 2015.
Distribuir solo bajo la licencia WTFPL: 
I<Do What the Fuck You Want To Public License>.

Zaijian.

=cut
